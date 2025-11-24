# Share Extension URL Processing Fix - Implementation Summary

## Problem Statement

외부 앱에서 URL을 공유하면 shareExtension 큐에 쌓이지만, `/api/content/analyze` API로 URL을 보낼 때 다음 오류가 발생:

```
type 'Null' is not a subtype of type 'String' in type cast
```

## Root Cause Analysis

1. **Missing Method**: `ApiContentDataSource.analyzeSharedUrl` 메서드가 구현되지 않음
2. **Null Handling**: API 응답에서 `platform` 필드가 null일 때 타입 캐스팅 실패
3. **Queue Processing**: 공유된 URL 큐를 처리하는 로직이 없음

## Solution Overview

### 1. API Integration (`api_content_data_source.dart`)

```dart
Future<ContentModel> analyzeSharedUrl({required String snsUrl}) async {
  final response = await dio.post(
    '$baseUrl/api/content/analyze',
    data: {'snsUrl': snsUrl},
  );
  
  // Null-safe parsing with defaults
  final contentId = responseData['contentId'] as String? ?? '';
  final platform = responseData['platform'] as String? ?? 'UNKNOWN';
  final status = responseData['status'] as String? ?? 'PENDING';
}
```

**Key Features**:
- POST 요청으로 `snsUrl`만 전송
- contentId, platform, status에 대한 기본값 제공
- 상세한 디버그 로깅

### 2. Data Model Fix (`content_model.dart`)

```dart
@freezed
class ContentModel with _$ContentModel {
  const factory ContentModel({
    required String contentId,
    @Default('UNKNOWN') String platform,  // ← Changed from required
    @Default('PENDING') String status,
    // ...
  }) = _ContentModel;
}
```

**Key Changes**:
- `platform` 필드를 required에서 default value로 변경
- PENDING 상태일 때 platform이 null일 수 있는 상황 대응

### 3. URL Queue Management (`sharing_service.dart`)

```dart
// 네이티브 메서드가 구현되지 않은 경우 fallback
Future<List<String>> getPendingUrls() async {
  try {
    final result = await _channel.invokeMethod<List<dynamic>>('getPendingUrls');
    return result?.cast<String>() ?? [];
  } catch (error) {
    // Fallback: currentSharedData에서 URL 추출
    return _extractUrlsFromCurrentData();
  }
}
```

**Key Features**:
- 네이티브 메서드 호출 시도
- 실패 시 `currentSharedData`에서 URL 추출하는 fallback
- Graceful degradation 지원

### 4. Queue Processing Logic (`home_screen.dart`)

```dart
Future<void> _processQueuedUrls() async {
  final pendingUrls = await sharingService.getPendingUrls();
  
  for (final url in pendingUrls) {
    // URL 유효성 검사
    if (!sharingService.isValidUrl(url)) continue;
    
    // 백엔드로 전송
    await contentRepository.analyzeSharedUrl(snsUrl: url);
    
    // 성공 시 큐에서 제거
    await sharingService.removeUrlFromQueue(url);
  }
  
  // 콘텐츠 목록 새로고침
  ref.invalidate(contentListProvider);
}
```

**Key Features**:
- 화면 로드 시 자동 실행
- 새로고침 시 재실행
- URL 유효성 검사
- 상세한 성공/실패 로깅
- 처리 후 자동 새로고침

## API Request/Response

### Request Format
```json
POST /api/content/analyze
{
  "snsUrl": "https://www.instagram.com/reel/DRYJvdckjCc/?utm_source=ig_web_button_native_share"
}
```

### Expected Response
```json
{
  "contentId": "550e8400-e29b-41d4-a716-446655440000",
  "platform": "INSTAGRAM",  // May be null for PENDING
  "status": "PENDING",
  "platformUploader": "nolla_nolla_nolla",
  "thumbnailUrl": "https://...",
  "originalUrl": "https://...",
  "title": null,
  "summary": null,
  "createdAt": "2025-01-24T10:30:00",
  "updatedAt": "2025-01-24T10:30:00"
}
```

## Testing Guide

### Test Scenario 1: Mock API 모드

```bash
# .env 파일 설정
USE_MOCK_API=true

# 또는 dart-define 사용
flutter run --dart-define=USE_MOCK_API=true
```

**Expected Behavior**:
1. 외부 앱에서 URL 공유
2. 앱 홈 화면 진입 시 자동으로 URL 처리
3. Mock 데이터로 3초 후 COMPLETED 상태로 변경
4. 콘텐츠 목록에 추가됨

**Log Output**:
```
[HomeScreen] 📥 공유 URL 큐 처리 시작
[SharingService] 📥 대기 중인 URL 큐 조회 시작
[SharingService] ✅ 대기 중인 URL 1개 발견: [https://...]
[HomeScreen] 📤 URL 전송 중: https://...
[HomeScreen] ✅ URL 전송 성공: https://... (contentId: 1234, status: PENDING)
[HomeScreen] 📊 처리 결과: 성공 1개, 실패 0개
```

### Test Scenario 2: Real API 모드

```bash
USE_MOCK_API=false
flutter run --dart-define=USE_MOCK_API=false
```

**Expected Behavior**:
1. 외부 앱에서 URL 공유
2. 앱 홈 화면 진입 시 자동으로 URL 처리
3. 백엔드 API로 POST 요청 전송
4. 응답 받아서 콘텐츠 생성
5. AI 서버가 비동기로 처리 (status: PENDING → ANALYZING → COMPLETED)

**Error Scenarios**:
- **네트워크 오류**: 재시도 없이 실패 로그만 남김 (URL은 큐에 남음)
- **인증 오류**: JWT 토큰 문제 시 로그 출력
- **API 오류**: 백엔드 에러 응답 시 상세 로그

### Test Scenario 3: Native Methods 미구현

네이티브 메서드가 구현되지 않은 경우:

**Expected Behavior**:
1. `getPendingUrls()` 호출 시 MissingPluginException 발생
2. Fallback으로 `currentSharedData`에서 URL 추출
3. URL 처리 후 `removeUrlFromQueue()` 호출 시 예외 무시
4. 정상 동작 (단, 큐 관리 기능은 제한적)

**Log Output**:
```
[SharingService] ⚠️ 네이티브 메서드 미구현 - currentSharedData 사용
[SharingService] ✅ currentSharedData에서 URL 1개 발견: [https://...]
[SharingService] ⚠️ 네이티브 메서드 미구현 - 제거 스킵: https://...
```

## Troubleshooting

### Issue: "type 'Null' is not a subtype of type 'String'"

**원인**: API 응답에서 필수 필드가 null
**해결**: `content_model.g.dart` 업데이트로 해결됨
```dart
platform: json['platform'] as String? ?? 'UNKNOWN',
```

### Issue: "No implementation found for method getPendingUrls"

**원인**: 네이티브 메서드 미구현
**해결**: Fallback 메커니즘이 자동으로 작동
**추가 조치**: iOS/Android에 네이티브 메서드 구현 필요

### Issue: URL이 큐에서 제거되지 않음

**원인**: `removeUrlFromQueue` 네이티브 메서드 미구현
**임시 해결**: 현재는 메서드 호출 실패 시 무시하고 계속 진행
**장기 해결**: 네이티브 메서드 구현 필요

### Issue: 중복 URL이 계속 처리됨

**원인**: URL 제거 실패로 인한 중복 처리
**해결 방법**:
1. 네이티브 메서드 구현
2. 또는 처리된 URL을 로컬에 캐싱하여 중복 체크

## Native Implementation Requirements

### iOS (Swift)

`AppDelegate.swift` 또는 `ShareViewController.swift`에 추가:

```swift
// URL 큐 저장소 (UserDefaults 사용)
private let urlQueueKey = "shared_url_queue"

// 대기 중인 URL 목록 조회
case "getPendingUrls":
    if let urls = UserDefaults.standard.array(forKey: urlQueueKey) as? [String] {
        result(urls)
    } else {
        result([])
    }

// URL 큐에서 제거
case "removeUrlFromQueue":
    if let args = call.arguments as? [String: Any],
       let url = args["url"] as? String {
        var urls = UserDefaults.standard.array(forKey: urlQueueKey) as? [String] ?? []
        urls.removeAll { $0 == url }
        UserDefaults.standard.set(urls, forKey: urlQueueKey)
        result(true)
    } else {
        result(false)
    }

// URL 큐 전체 초기화
case "clearUrlQueue":
    UserDefaults.standard.removeObject(forKey: urlQueueKey)
    result(true)
```

### Android (Kotlin)

`MainActivity.kt`에 추가:

```kotlin
// URL 큐 저장소 (SharedPreferences 사용)
private val PREF_URL_QUEUE = "shared_url_queue"

// 대기 중인 URL 목록 조회
"getPendingUrls" -> {
    val prefs = getSharedPreferences("FlutterSharedPrefs", Context.MODE_PRIVATE)
    val urlsJson = prefs.getString(PREF_URL_QUEUE, "[]")
    val urls = JSONArray(urlsJson)
    val list = mutableListOf<String>()
    for (i in 0 until urls.length()) {
        list.add(urls.getString(i))
    }
    result.success(list)
}

// URL 큐에서 제거
"removeUrlFromQueue" -> {
    val args = call.arguments as? Map<String, Any>
    val url = args?.get("url") as? String
    
    val prefs = getSharedPreferences("FlutterSharedPrefs", Context.MODE_PRIVATE)
    val urlsJson = prefs.getString(PREF_URL_QUEUE, "[]")
    val urls = JSONArray(urlsJson)
    val newUrls = JSONArray()
    
    for (i in 0 until urls.length()) {
        if (urls.getString(i) != url) {
            newUrls.put(urls.getString(i))
        }
    }
    
    prefs.edit().putString(PREF_URL_QUEUE, newUrls.toString()).apply()
    result.success(true)
}

// URL 큐 전체 초기화
"clearUrlQueue" -> {
    val prefs = getSharedPreferences("FlutterSharedPrefs", Context.MODE_PRIVATE)
    prefs.edit().remove(PREF_URL_QUEUE).apply()
    result.success(true)
}
```

## Files Modified

1. `lib/core/models/content_model.dart` - Model 수정
2. `lib/core/models/content_model.g.dart` - Generated code 수정
3. `lib/core/services/sharing_service.dart` - Queue 관리 추가
4. `lib/features/home/data/data_sources/content_data_source.dart` - Interface 추가
5. `lib/features/home/data/data_sources/api_content_data_source.dart` - API 구현
6. `lib/features/home/data/data_sources/mock_content_data_source.dart` - Mock 구현
7. `lib/features/home/data/repositories/content_repository.dart` - Repository 업데이트
8. `lib/features/home/presentation/screens/home_screen.dart` - Queue 처리 로직 추가

## Performance Considerations

1. **순차 처리**: URL을 순차적으로 처리하여 서버 부하 방지
2. **에러 격리**: 한 URL 실패가 다른 URL 처리에 영향 없음
3. **자동 새로고침**: 처리 성공 시 한 번만 새로고침
4. **메모리 효율**: 처리 완료된 URL은 즉시 제거

## Security Considerations

1. **URL 검증**: `isValidUrl()` 메서드로 유효한 URL만 처리
2. **JWT 인증**: 모든 API 요청에 JWT 토큰 자동 추가
3. **에러 로깅**: 민감한 정보 노출 없이 디버깅 정보만 로깅

## Future Enhancements

1. **재시도 로직**: 네트워크 오류 시 자동 재시도
2. **배치 처리**: 여러 URL을 한 번에 전송
3. **우선순위 큐**: 최근 공유된 URL 우선 처리
4. **오프라인 큐**: 오프라인 시 로컬에 저장 후 온라인 시 자동 전송
5. **진행 상태 UI**: URL 처리 중 사용자에게 진행 상태 표시

## References

- BackendAPI.md: `/api/content/analyze` 엔드포인트 명세
- PRD.md: 프로젝트 요구사항 문서
- SHARE_EXTENSION_REFACTORING_SUMMARY.md: Share Extension 리팩토링 문서
