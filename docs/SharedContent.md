# 공유 콘텐츠 시스템 아키텍처

## 📋 개요

외부 앱(Instagram, TikTok 등)에서 Tripgether로 공유된 콘텐츠를 서버에서 분석하고, 앱에서 조회하여 표시하는 시스템입니다.

**핵심 원칙**: 서버 조회 방식 (Server-Side Polling)
- FCM 푸시 알림 불필요
- 로컬 Repository 불필요
- 서버가 Single Source of Truth

---

## 🎯 전체 플로우

```
┌─────────────────────────────────────────────────┐
│ 1. 외부 앱에서 공유                             │
│    사용자: Instagram → 공유 → Tripgether 선택   │
└─────────────────────────────────────────────────┘
                  ↓
┌─────────────────────────────────────────────────┐
│ 2. 플랫폼별 처리                                │
│    Android: MainActivity → SharingService       │
│    iOS: Share Extension (네이티브)             │
│                                                 │
│    → 서버로 URL 전송                            │
│      POST /api/shared-content                   │
└─────────────────────────────────────────────────┘
                  ↓
┌─────────────────────────────────────────────────┐
│ 3. 서버 처리                                    │
│    - DB에 저장 (status: pending)                │
│    - 백그라운드 분석 시작                        │
│    - 완료 시 status: complete 업데이트          │
└─────────────────────────────────────────────────┘
                  ↓
┌─────────────────────────────────────────────────┐
│ 4. 사용자가 나중에 앱 열기                       │
│    NotificationScreen 초기화                    │
│    → Riverpod Provider 실행                     │
│    → 서버 조회                                  │
│      GET /api/shared-content?status=complete    │
└─────────────────────────────────────────────────┘
                  ↓
┌─────────────────────────────────────────────────┐
│ 5. 화면에 표시                                  │
│    완료된 콘텐츠 리스트 표시                     │
└─────────────────────────────────────────────────┘
```

---

## 🤖 Android 구현

### 1. MainActivity (Intent 수신)

외부 앱에서 공유 시 자동으로 앱이 실행됩니다.

```kotlin
// android/app/src/main/kotlin/com/example/tripgether/MainActivity.kt
class MainActivity: FlutterActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        handleSharingIntent(intent)
    }

    private fun handleSharingIntent(intent: Intent?) {
        if (intent?.action == Intent.ACTION_SEND) {
            val text = intent.getStringExtra(Intent.EXTRA_TEXT)
            // MethodChannel로 Flutter에 전달
            sendToFlutter(text)
        }
    }
}
```

### 2. SharingService (Flutter)

MethodChannel로 받은 데이터를 서버로 전송합니다.

**파일**: `lib/core/services/sharing_service.dart`

```dart
class SharingService {
  final SharedContentApiClient _apiClient;

  Future<void> _handleSharedData(SharedData sharedData) async {
    final url = SharedDataParser.extractUrl(sharedData.sharedTexts);

    // 서버로 전송
    try {
      await _apiClient.submitUrl(
        token: _userToken,
        url: url,
      );

      debugPrint('[SharingService] ✅ 서버 전송 성공: $url');
    } catch (e) {
      debugPrint('[SharingService] ❌ 서버 전송 실패: $e');
    }
  }
}
```

---

## 🍎 iOS 구현

### 1. Share Extension (네이티브)

Flutter 앱이 실행되지 않으므로, Swift에서 직접 서버로 전송합니다.

**파일**: `ios/Share Extension/ShareViewController.swift`

```swift
import UIKit
import Social

class ShareViewController: SLComposeServiceViewController {

    let appGroupIdentifier = "group.com.tripgether"
    let apiEndpoint = "https://api.tripgether.suhsaechan.kr/api/shared-content"

    override func didSelectPost() {
        guard let url = extractURL() else {
            showError("URL을 찾을 수 없습니다")
            return
        }

        // UserDefaults에서 사용자 토큰 읽기
        let sharedDefaults = UserDefaults(suiteName: appGroupIdentifier)
        guard let userToken = sharedDefaults?.string(forKey: "userToken") else {
            showError("로그인이 필요합니다")
            return
        }

        // 서버로 전송
        sendToServer(url: url, token: userToken) { [weak self] success in
            if success {
                print("[Share Extension] ✅ 서버 전송 성공")
            } else {
                print("[Share Extension] ❌ 서버 전송 실패")
            }

            self?.extensionContext?.completeRequest(
                returningItems: [],
                completionHandler: nil
            )
        }
    }

    private func sendToServer(
        url: String,
        token: String,
        completion: @escaping (Bool) -> Void
    ) {
        guard let apiURL = URL(string: apiEndpoint) else {
            completion(false)
            return
        }

        var request = URLRequest(url: apiURL)
        request.httpMethod = "POST"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let body: [String: Any] = ["url": url]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let httpResponse = response as? HTTPURLResponse {
                completion(
                    httpResponse.statusCode == 200 ||
                    httpResponse.statusCode == 201
                )
            } else {
                completion(false)
            }
        }.resume()
    }

    private func extractURL() -> String? {
        // URL 추출 로직
        // ...
        return nil
    }

    private func showError(_ message: String) {
        print("[Share Extension] 에러: \(message)")
        self.extensionContext?.completeRequest(
            returningItems: [],
            completionHandler: nil
        )
    }
}
```

### 2. UserDefaults 토큰 저장

로그인 시 Flutter에서 iOS UserDefaults에 토큰을 저장해야 합니다.

**Flutter 코드**: `lib/core/services/auth/google_auth_service.dart`

```dart
Future<void> _saveTokenToUserDefaults(String token) async {
  if (!Platform.isIOS) return;

  try {
    await _channel.invokeMethod('saveUserToken', {'token': token});
    debugPrint('[Auth] iOS UserDefaults에 토큰 저장 완료');
  } catch (e) {
    debugPrint('[Auth] iOS UserDefaults 토큰 저장 실패: $e');
  }
}
```

**네이티브 코드**: `ios/Runner/AppDelegate.swift`

```swift
case "saveUserToken":
    if let args = call.arguments as? [String: Any],
       let token = args["token"] as? String {
        let sharedDefaults = UserDefaults(suiteName: "group.com.tripgether")
        sharedDefaults?.set(token, forKey: "userToken")
        sharedDefaults?.synchronize()
        result(true)
    } else {
        result(false)
    }

case "clearUserToken":
    let sharedDefaults = UserDefaults(suiteName: "group.com.tripgether")
    sharedDefaults?.removeObject(forKey: "userToken")
    sharedDefaults?.synchronize()
    result(true)
```

---

## 📡 API Client

서버와 통신하는 클라이언트입니다.

**파일**: `lib/core/services/api/shared_content_api_client.dart`

```dart
import 'package:dio/dio.dart';

class SharedContentApiClient {
  final Dio _dio;

  SharedContentApiClient(this._dio);

  /// 서버에 URL 전송
  Future<void> submitUrl({
    required String token,
    required String url,
  }) async {
    await _dio.post(
      '/api/shared-content',
      data: {'url': url},
      options: Options(
        headers: {'Authorization': 'Bearer $token'},
      ),
    );
  }

  /// 완료된 콘텐츠 조회
  Future<List<SharedContent>> getCompletedContents({
    required String token,
  }) async {
    final response = await _dio.get(
      '/api/shared-content',
      queryParameters: {'status': 'complete'},
      options: Options(
        headers: {'Authorization': 'Bearer $token'},
      ),
    );

    final List<dynamic> data = response.data;
    return data
        .map((json) => SharedContent.fromJson(json))
        .toList();
  }
}
```

---

## 🎨 Riverpod Provider

서버 데이터를 조회하는 Provider입니다.

**파일**: `lib/features/notifications/presentation/providers/shared_content_provider.dart`

```dart
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../domain/models/shared_content.dart';

part 'shared_content_provider.g.dart';

@riverpod
class SharedContents extends _$SharedContents {
  @override
  Future<List<SharedContent>> build() async {
    final apiClient = ref.watch(sharedContentApiClientProvider);
    final authState = ref.watch(authStateProvider);

    if (authState.userToken == null) {
      return [];
    }

    return await apiClient.getCompletedContents(
      token: authState.userToken!,
    );
  }

  /// 수동 새로고침
  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final apiClient = ref.read(sharedContentApiClientProvider);
      final authState = ref.read(authStateProvider);

      return await apiClient.getCompletedContents(
        token: authState.userToken!,
      );
    });
  }
}
```

---

## 📱 NotificationScreen

서버에서 조회한 데이터를 표시하는 화면입니다.

**파일**: `lib/features/notifications/presentation/screens/notification_screen.dart`

```dart
class NotificationScreen extends ConsumerWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final contentsAsync = ref.watch(sharedContentsProvider);

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: CommonAppBar.forSubPage(
        title: '',
        backgroundColor: AppColors.backgroundLight,
        rightActions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              ref.read(sharedContentsProvider.notifier).refresh();
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 헤더
            Padding(
              padding: EdgeInsets.all(AppSpacing.xxl),
              child: Text(
                l10n.notifications,
                style: AppTextStyles.titleBold24,
              ),
            ),

            // 콘텐츠 리스트
            Expanded(
              child: contentsAsync.when(
                data: (contents) {
                  if (contents.isEmpty) {
                    return Center(
                      child: EmptyStates.noData(
                        title: l10n.noNotifications,
                        message: l10n.sharedContentMessage,
                      ),
                    );
                  }

                  return RefreshIndicator(
                    onRefresh: () => ref
                        .read(sharedContentsProvider.notifier)
                        .refresh(),
                    child: ListView.builder(
                      padding: EdgeInsets.symmetric(
                        horizontal: AppSpacing.lg,
                      ),
                      itemCount: contents.length,
                      itemBuilder: (context, index) {
                        final content = contents[index];
                        return _buildNotificationItem(
                          context: context,
                          content: content,
                        );
                      },
                    ),
                  );
                },
                loading: () => Center(
                  child: CircularProgressIndicator(),
                ),
                error: (error, stack) => Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('오류 발생: $error'),
                      SizedBox(height: AppSpacing.md),
                      ElevatedButton(
                        onPressed: () {
                          ref
                              .read(sharedContentsProvider.notifier)
                              .refresh();
                        },
                        child: Text('다시 시도'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationItem({
    required BuildContext context,
    required SharedContent content,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: AppSpacing.sm),
      padding: EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: AppRadius.allMedium,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${content.author}님의 공유 콘텐츠',
            style: AppTextStyles.titleSemiBold14,
          ),
          SizedBox(height: AppSpacing.xs),
          Text(
            content.url,
            style: AppTextStyles.bodyMedium12,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          if (content.processedData != null) ...[
            SizedBox(height: AppSpacing.sm),
            Text(
              '${content.processedData!['locations']?.length ?? 0}개 장소 발견',
              style: AppTextStyles.bodyMedium14.copyWith(
                color: AppColors.mainColor,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
```

---

## 🗄️ 데이터 모델

**파일**: `lib/features/notifications/domain/models/shared_content.dart`

```dart
class SharedContent {
  final String id;
  final String url;
  final String author;
  final DateTime sharedAt;
  final String status; // 'pending', 'processing', 'complete', 'failed'
  final Map<String, dynamic>? processedData;

  SharedContent({
    required this.id,
    required this.url,
    required this.author,
    required this.sharedAt,
    required this.status,
    this.processedData,
  });

  factory SharedContent.fromJson(Map<String, dynamic> json) {
    return SharedContent(
      id: json['id'] as String,
      url: json['url'] as String,
      author: json['author'] as String,
      sharedAt: DateTime.parse(json['sharedAt'] as String),
      status: json['status'] as String,
      processedData: json['processedData'] as Map<String, dynamic>?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'url': url,
      'author': author,
      'sharedAt': sharedAt.toIso8601String(),
      'status': status,
      'processedData': processedData,
    };
  }
}
```

---

## 🌐 백엔드 API 스펙

### POST /api/shared-content

공유된 URL을 서버에 전송합니다.

**요청**:
```http
POST /api/shared-content
Authorization: Bearer {userToken}
Content-Type: application/json

{
  "url": "https://instagram.com/p/DQi7ehvCW2x/"
}
```

**응답**:
```json
{
  "id": "generated_id",
  "url": "https://instagram.com/p/DQi7ehvCW2x/",
  "userId": "user_id_from_token",
  "status": "pending",
  "createdAt": "2025-11-15T12:00:00Z"
}
```

**처리 과정**:
1. 요청 수신 → DB에 저장 (status: pending)
2. 백그라운드 작업 시작 (큐에 추가)
3. URL 분석 (장소 추출, 메타데이터 파싱)
4. 완료 시 DB 업데이트 (status: complete, processedData 저장)

---

### GET /api/shared-content

완료된 콘텐츠를 조회합니다.

**요청**:
```http
GET /api/shared-content?status=complete
Authorization: Bearer {userToken}
```

**응답**:
```json
[
  {
    "id": "1",
    "url": "https://instagram.com/p/DQi7ehvCW2x/",
    "author": "today_good_tip",
    "userId": "user_id",
    "status": "complete",
    "processedData": {
      "locations": [
        {
          "name": "카페 A",
          "address": "서울 강남구 테헤란로 123",
          "category": "카페",
          "coordinates": {
            "latitude": 37.123456,
            "longitude": 127.123456
          }
        },
        {
          "name": "식당 B",
          "address": "서울 서초구 강남대로 456",
          "category": "식당",
          "coordinates": {
            "latitude": 37.234567,
            "longitude": 127.234567
          }
        }
      ],
      "analysis": {
        "totalLocations": 2,
        "categories": ["카페", "식당"],
        "region": "서울 강남"
      }
    },
    "sharedAt": "2025-11-15T12:00:00Z",
    "completedAt": "2025-11-15T12:05:00Z"
  }
]
```

---

## ✅ 장점

| 항목 | 설명 |
|------|------|
| **간단함** | 4개 컴포넌트만으로 구현 (모델, API Client, Provider, Screen) |
| **동기화** | 서버가 Single Source of Truth → 동기화 문제 없음 |
| **실시간성** | 불필요 (나중에 앱 열 때 확인해도 됨) |
| **유지보수** | 코드가 적어서 유지보수 쉬움 |
| **확장성** | 서버에서 기능 추가 용이 |
| **플랫폼 통일** | Android/iOS 모두 동일한 서버 조회 방식 |

---

## ⚠️ 제거된 복잡한 구조

다음 컴포넌트들은 **불필요하므로 구현하지 않습니다**:

- ❌ **Repository**: 서버가 이미 저장소 역할
- ❌ **Processor**: 서버가 백그라운드에서 처리
- ❌ **FCM Handler**: 실시간 알림 불필요 (나중에 조회)
- ❌ **로컬 상태 관리**: 서버 조회로 충분
- ❌ **큐 시스템**: 서버에서 처리

---

## 🔄 옵션: 캐싱 추가

오프라인 대응이 필요하다면 선택적으로 캐싱을 추가할 수 있습니다.

```dart
@riverpod
class SharedContents extends _$SharedContents {
  @override
  Future<List<SharedContent>> build() async {
    final cache = ref.watch(cacheProvider);
    final apiClient = ref.watch(sharedContentApiClientProvider);

    // 1. 캐시 먼저 반환 (즉시 표시)
    final cached = await cache.get<List<SharedContent>>('shared_contents');
    if (cached != null) {
      // 백그라운드에서 서버 조회
      _refreshInBackground(apiClient, cache);
      return cached;
    }

    // 2. 캐시 없으면 서버 조회
    final serverData = await apiClient.getCompletedContents(...);
    await cache.set('shared_contents', serverData);
    return serverData;
  }

  Future<void> _refreshInBackground(
    SharedContentApiClient apiClient,
    CacheProvider cache,
  ) async {
    try {
      final serverData = await apiClient.getCompletedContents(...);
      await cache.set('shared_contents', serverData);
      // Provider 갱신
      ref.invalidateSelf();
    } catch (e) {
      // 백그라운드 갱신 실패는 무시 (캐시 데이터 계속 사용)
    }
  }
}
```

---

## 📚 참고 문서

- [Architecture.md](./Architecture.md) - 전체 앱 아키텍처
- [Services.md](./Services.md) - SharingService 상세 설명
- [BackendAPI.md](./BackendAPI.md) - 백엔드 API 전체 스펙
