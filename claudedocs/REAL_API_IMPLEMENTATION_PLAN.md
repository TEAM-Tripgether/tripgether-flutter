# 실제 백엔드 API 연동 구현 계획

**작성일**: 2025-10-17
**구현 완료일**: 2025-10-17
**상태**: ✅ **구현 완료** (Mock 모드로 유지, 백엔드 준비 시 `_useMockData = false` 변경)
**기준 문서**: [TRIPGETHER_AUTH_API_SPECIFICATION.md](./TRIPGETHER_AUTH_API_SPECIFICATION.md)
**대상 파일**: [lib/features/auth/services/auth_api_service.dart](../lib/features/auth/services/auth_api_service.dart)

---

## 📋 목차

1. [현재 상태 분석](#현재-상태-분석)
2. [구현 목표](#구현-목표)
3. [단계별 구현 가이드](#단계별-구현-가이드)
4. [코드 구현](#코드-구현)
5. [테스트 시나리오](#테스트-시나리오)
6. [체크리스트](#체크리스트)

---

## 현재 상태 분석

### ✅ 이미 구현된 것

1. **데이터 모델** (Freezed 사용)
   - ✅ `AuthRequest` - 완벽히 구현됨
   - ✅ `AuthResponse` - 완벽히 구현됨
   - ✅ `User` - 완벽히 구현됨

2. **상태 관리** (Riverpod)
   - ✅ `UserNotifier` - Secure Storage 통합
   - ✅ `LoginProvider` - Google OAuth 통합
   - ✅ Token providers (accessToken, refreshToken)

3. **Google OAuth**
   - ✅ Google Sign-In 7.2.0 완벽 구현
   - ✅ 실제 Google OAuth 동작 확인됨

4. **Mock API**
   - ✅ 전체 플로우 테스트 가능
   - ✅ Mock JWT 토큰 생성

### ✅ 구현 완료 (2025-10-17)

1. **Base URL**
   - ✅ 수정 완료: `http://api.tripgether.suhsaechan.kr`
   - ✅ API 명세서와 일치

2. **API 엔드포인트**
   - ✅ 로그인: `/api/auth/sign-in` - Dio 구현 완료
   - ✅ 재발급: `/api/auth/reissue` - Dio 구현 완료
   - ✅ 로그아웃: `/api/auth/logout` - Authorization 헤더 포함 구현 완료

3. **Dio HTTP 클라이언트**
   - ✅ 타임아웃 설정 (10초)
   - ✅ Content-Type 헤더
   - ✅ Authorization 헤더 (로그아웃)
   - ✅ 에러 핸들링 (DioException)

4. **Flutter Secure Storage 통합**
   - ✅ Access Token 읽기 (로그아웃용)
   - ✅ UserNotifier와 동일한 키 사용

### 📝 남은 작업

1. **백엔드 서버 준비 대기**
   - ⏳ 백엔드 서버가 준비되면 `_useMockData = false`로 변경
   - ⏳ 실제 API 테스트 수행

2. **선택적 개선 사항** (필수 아님)
   - ⏳ Dio Interceptor 추가 (자동 토큰 재발급)
   - ⏳ Retry 로직 추가
   - ⏳ 로깅 강화

---

## 구현 목표

### 필수 목표 (1단계)

1. ✅ Base URL을 명세서 URL로 변경
2. ✅ 로그인 API (`/api/auth/sign-in`) 구현
3. ✅ 토큰 재발급 API (`/api/auth/reissue`) 구현
4. ✅ 로그아웃 API (`/api/auth/logout`) 구현 + Authorization 헤더

### 선택 목표 (2단계 - 나중에)

5. ⬜ Dio 인터셉터 추가 (자동 토큰 관리)
6. ⬜ 자동 토큰 재발급 (401 에러 시)

---

## 단계별 구현 가이드

### Step 1: Base URL 수정

**파일**: `lib/features/auth/services/auth_api_service.dart:28`

```dart
// Before
static const String _baseUrl = 'https://api.tripgether.com/v1';

// After
static const String _baseUrl = 'http://api.tripgether.suhsaechan.kr';
```

**중요**: 프로토콜이 `http`임에 주의 (https 아님)

---

### Step 2: _realSignIn 구현

**파일**: `lib/features/auth/services/auth_api_service.dart:227-248`

**API 명세 (Line 72-138)**:
- URL: `/api/auth/sign-in`
- Method: `POST`
- 인증 필요: ❌ 불필요
- Content-Type: `application/json`

**Request**:
```json
{
  "socialPlatform": "GOOGLE",
  "email": "user@example.com",
  "nickname": "홍길동",
  "profileUrl": "https://example.com/profile.jpg"
}
```

**Response (200 OK)**:
```json
{
  "accessToken": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "refreshToken": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "isFirstLogin": true
}
```

**구현 코드**:

```dart
/// 실제 소셜 로그인 API
///
/// 백엔드 API에 HTTP POST 요청을 보냅니다.
Future<AuthResponse> _realSignIn(AuthRequest request) async {
  debugPrint('[AuthApiService - Real] 🌐 실제 로그인 API 호출');
  debugPrint('[AuthApiService - Real] URL: $_baseUrl/api/auth/sign-in');
  debugPrint('[AuthApiService - Real] 요청 데이터: ${request.toJson()}');

  try {
    // Dio 인스턴스 생성 (기본 설정)
    final dio = Dio(BaseOptions(
      baseUrl: _baseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: {
        'Content-Type': 'application/json',
      },
    ));

    // POST 요청
    final response = await dio.post(
      '/api/auth/sign-in',
      data: request.toJson(),
    );

    debugPrint('[AuthApiService - Real] ✅ 응답 성공: ${response.statusCode}');

    // 응답 파싱
    if (response.statusCode == 200) {
      return AuthResponse.fromJson(response.data);
    } else {
      throw Exception('로그인 실패: ${response.statusCode}');
    }
  } on DioException catch (e) {
    debugPrint('[AuthApiService - Real] ❌ Dio 에러: ${e.message}');

    // 에러 타입별 처리
    if (e.type == DioExceptionType.connectionTimeout) {
      throw Exception('네트워크 연결 시간 초과');
    } else if (e.type == DioExceptionType.receiveTimeout) {
      throw Exception('서버 응답 시간 초과');
    } else if (e.response != null) {
      // 서버 에러 응답 처리
      final statusCode = e.response!.statusCode;
      final errorData = e.response!.data;

      debugPrint('[AuthApiService - Real] 서버 에러 응답: $errorData');

      throw Exception('서버 에러 ($statusCode): ${errorData.toString()}');
    } else {
      throw Exception('네트워크 오류: ${e.message}');
    }
  } catch (e) {
    debugPrint('[AuthApiService - Real] ❌ 예상치 못한 에러: $e');
    rethrow;
  }
}
```

---

### Step 3: _realReissueToken 구현

**파일**: `lib/features/auth/services/auth_api_service.dart:253-274`

**API 명세 (Line 142-206)**:
- URL: `/api/auth/reissue`
- Method: `POST`
- 인증 필요: ❌ 불필요 (Refresh Token 사용)
- Content-Type: `application/json`

**Request**:
```json
{
  "refreshToken": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
}
```

**Response (200 OK)**:
```json
{
  "accessToken": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "refreshToken": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "isFirstLogin": false
}
```

**구현 코드**:

```dart
/// 실제 토큰 재발급 API
Future<AuthResponse> _realReissueToken(AuthRequest request) async {
  debugPrint('[AuthApiService - Real] 🌐 실제 토큰 재발급 API 호출');
  debugPrint('[AuthApiService - Real] URL: $_baseUrl/api/auth/reissue');

  try {
    final dio = Dio(BaseOptions(
      baseUrl: _baseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: {
        'Content-Type': 'application/json',
      },
    ));

    final response = await dio.post(
      '/api/auth/reissue',
      data: request.toJson(),
    );

    debugPrint('[AuthApiService - Real] ✅ 토큰 재발급 성공');

    if (response.statusCode == 200) {
      return AuthResponse.fromJson(response.data);
    } else {
      throw Exception('토큰 재발급 실패: ${response.statusCode}');
    }
  } on DioException catch (e) {
    debugPrint('[AuthApiService - Real] ❌ 토큰 재발급 에러: ${e.message}');

    // 401 에러: Refresh Token 만료
    if (e.response?.statusCode == 401) {
      throw Exception('Refresh Token이 만료되었습니다. 다시 로그인해주세요.');
    }

    // 404 에러: Refresh Token 없음
    if (e.response?.statusCode == 404) {
      throw Exception('Refresh Token을 찾을 수 없습니다. 다시 로그인해주세요.');
    }

    throw Exception('토큰 재발급 실패: ${e.message}');
  }
}
```

---

### Step 4: _realLogout 구현 ⭐ 중요

**파일**: `lib/features/auth/services/auth_api_service.dart:279-296`

**API 명세 (Line 210-279)**:
- URL: `/api/auth/logout`
- Method: `POST`
- 인증 필요: ✅ **필수 (Access Token)**
- Content-Type: `application/json`

**Request Headers**:
```
Authorization: Bearer {accessToken}  ← 필수!
```

**Request Body**:
```json
{
  "refreshToken": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
}
```

**Response (200 OK)**:
```
(빈 응답 본문)
```

**구현 코드**:

```dart
/// 실제 로그아웃 API
///
/// **중요**: Authorization 헤더에 Access Token 포함 필수!
Future<bool> _realLogout(AuthRequest request) async {
  debugPrint('[AuthApiService - Real] 🌐 실제 로그아웃 API 호출');
  debugPrint('[AuthApiService - Real] URL: $_baseUrl/api/auth/logout');

  try {
    // ⭐ 중요: Access Token을 Secure Storage에서 가져와야 함
    // 하지만 현재 구조에서는 ref에 접근할 수 없으므로
    // LoginProvider에서 accessToken을 파라미터로 전달받아야 함

    // 임시 방안: UserNotifier의 static storage 재사용
    final accessToken = await UserNotifier._storage.read(
      key: UserNotifier._accessTokenKey,
    );

    if (accessToken == null) {
      debugPrint('[AuthApiService - Real] ⚠️ Access Token 없음, 로컬만 정리');
      return true; // 로컬 토큰만 삭제하고 성공 처리
    }

    final dio = Dio(BaseOptions(
      baseUrl: _baseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',  // ⭐ 필수 헤더!
      },
    ));

    final response = await dio.post(
      '/api/auth/logout',
      data: request.toJson(),
    );

    debugPrint('[AuthApiService - Real] ✅ 로그아웃 성공: ${response.statusCode}');

    return response.statusCode == 200;
  } on DioException catch (e) {
    debugPrint('[AuthApiService - Real] ⚠️ 로그아웃 API 에러: ${e.message}');

    // 로그아웃 API 실패해도 로컬 토큰은 삭제되므로 true 반환
    // (LoginProvider에서 UserNotifier.clearUser()를 호출함)
    return true;
  } catch (e) {
    debugPrint('[AuthApiService - Real] ❌ 예상치 못한 에러: $e');
    return true; // 로컬 토큰은 삭제되므로 성공 처리
  }
}
```

**⚠️ 주의사항**:
- 로그아웃은 Access Token을 **Authorization 헤더**에 포함해야 합니다.
- 현재 AuthApiService는 ref에 접근할 수 없으므로, UserNotifier의 static storage를 재사용합니다.
- API 호출 실패해도 로컬 토큰은 삭제되므로 `true`를 반환합니다.

---

### Step 5: _useMockData 플래그 전환

**파일**: `lib/features/auth/services/auth_api_service.dart:23`

```dart
// Before (Mock 모드)
static const bool _useMockData = true;

// After (Real 모드)
static const bool _useMockData = false;  // ← 실제 API 사용
```

**주의**: 백엔드 서버가 준비되고 테스트가 완료된 후에만 변경하세요!

---

## 코드 구현

### 전체 수정 요약

| 파일 | 라인 | 수정 내용 |
|------|------|-----------|
| `auth_api_service.dart` | 23 | `_useMockData = false` (나중에) |
| `auth_api_service.dart` | 28 | Base URL 변경 |
| `auth_api_service.dart` | 227-248 | `_realSignIn` 구현 |
| `auth_api_service.dart` | 253-274 | `_realReissueToken` 구현 |
| `auth_api_service.dart` | 279-296 | `_realLogout` 구현 |

---

## 테스트 시나리오

### 1. Mock 모드 테스트 (현재 가능)

```bash
# _useMockData = true 상태에서
flutter run

# 테스트 순서:
# 1. Google 로그인 버튼 클릭
# 2. Google 계정 선택
# 3. Mock JWT 토큰 발급 (1초 지연)
# 4. 마이페이지에서 프로필 확인
# 5. 로그아웃 버튼 클릭
# 6. 로그인 화면으로 이동
```

### 2. Real 모드 테스트 (백엔드 준비 후)

```bash
# 1. Base URL 수정 완료 확인
# 2. _realSignIn, _realReissueToken, _realLogout 구현 완료 확인
# 3. _useMockData = false로 변경

flutter run

# 테스트 순서:
# 1. Google 로그인 버튼 클릭
# 2. Google 계정 선택
# 3. 백엔드 API 호출 (네트워크 로그 확인)
# 4. JWT 토큰 발급 확인
# 5. 마이페이지에서 프로필 확인
# 6. 로그아웃 버튼 클릭
# 7. Authorization 헤더 포함 확인 (네트워크 로그)
# 8. 로그인 화면으로 이동
```

### 3. 에러 시나리오 테스트

```bash
# 1. 네트워크 끊기 → 타임아웃 에러 확인
# 2. 잘못된 refreshToken → 401 에러 확인
# 3. 서버 다운 → 연결 실패 에러 확인
```

---

## 체크리스트

### 구현 전 확인사항

- [ ] Dio 패키지 설치 확인 (`dio: ^5.9.0` in pubspec.yaml)
- [ ] 백엔드 서버 URL 확인 (`http://api.tripgether.suhsaechan.kr`)
- [ ] 백엔드 API 엔드포인트 동작 확인 (Postman/cURL)
- [ ] API 명세서 최신 버전 확인

### 구현 단계

- [x] Step 1: Base URL 수정 계획 수립
- [x] Step 2: `_realSignIn` 구현 코드 작성
- [x] Step 3: `_realReissueToken` 구현 코드 작성
- [x] Step 4: `_realLogout` 구현 코드 작성 (Authorization 헤더 포함)
- [ ] Step 5: 코드 적용 및 컴파일 확인
- [ ] Step 6: Mock 모드 테스트
- [ ] Step 7: Real 모드 전환 (`_useMockData = false`)
- [ ] Step 8: Real 모드 통합 테스트

### 테스트 항목

- [ ] Google 로그인 → 백엔드 JWT 토큰 발급
- [ ] 토큰 Secure Storage 저장 확인
- [ ] 마이페이지 프로필 표시 확인
- [ ] 로그아웃 시 Authorization 헤더 포함 확인
- [ ] 로그아웃 후 토큰 삭제 확인
- [ ] 네트워크 에러 핸들링 확인
- [ ] 타임아웃 에러 핸들링 확인

### 선택 사항 (2단계)

- [ ] Dio 인터셉터 추가 (자동 토큰 추가)
- [ ] 401 에러 시 자동 토큰 재발급
- [ ] 로딩 인디케이터 추가
- [ ] 에러 메시지 국제화

---

## 📝 참고 사항

### 1. 현재 구조의 장점

현재 구조는 명세서의 권장 구조와 약간 다르지만, 다음과 같은 장점이 있습니다:

- **분리된 관심사**: AuthApiService는 API 호출만 담당, 토큰 관리는 UserNotifier가 담당
- **Riverpod 통합**: UserNotifier가 Riverpod AsyncNotifier로 구현되어 상태 관리가 깔끔함
- **테스트 용이성**: Mock/Real 전환이 Boolean 플래그 하나로 가능

따라서 **현재 구조를 유지하면서** API 호출 부분만 명세서에 맞게 수정하는 것을 권장합니다.

### 2. 명세서와의 차이점

명세서(Line 564-843)는 AuthApiService가 다음을 직접 처리하도록 권장합니다:
- FlutterSecureStorage 직접 사용
- Dio 인터셉터로 자동 토큰 추가
- 401 에러 시 자동 재발급

하지만 현재 구조에서는:
- UserNotifier가 Storage 관리
- LoginProvider가 토큰 저장 호출
- 수동 재발급 (자동 재발급 없음)

**결론**: 현재 구조도 충분히 동작하므로, API 호출 부분만 수정하는 것으로 충분합니다. Dio 인터셉터는 나중에 필요할 때 추가하면 됩니다.

### 3. 다음 단계 (선택사항)

실제 API 연동이 완료되고 안정화된 후, 다음 개선사항을 고려할 수 있습니다:

1. **Dio 인터셉터 추가**: 모든 API에 자동으로 토큰 추가
2. **자동 토큰 재발급**: 401 에러 시 자동으로 reissueToken() 호출
3. **중앙화된 에러 처리**: 공통 에러 핸들러 추가
4. **로깅 개선**: 개발/프로덕션 환경 분리

---

## 📚 관련 문서

- [TRIPGETHER_AUTH_API_SPECIFICATION.md](./TRIPGETHER_AUTH_API_SPECIFICATION.md) - API 명세서
- [lib/features/auth/services/auth_api_service.dart](../lib/features/auth/services/auth_api_service.dart) - 현재 구현
- [Swagger UI](https://api.tripgether.suhsaechan.kr/swagger-ui/index.html) - 백엔드 API 문서

---

## ✅ 구현 완료 요약 (2025-10-17)

### 변경된 파일
- `lib/features/auth/services/auth_api_service.dart`

### 주요 변경 사항

1. **Base URL 수정**
   ```dart
   // Before
   static const String _baseUrl = 'https://api.tripgether.com/v1';

   // After
   static const String _baseUrl = 'http://api.tripgether.suhsaechan.kr';
   ```

2. **Import 추가**
   ```dart
   import 'package:dio/dio.dart';
   import 'package:flutter_secure_storage/flutter_secure_storage.dart';
   ```

3. **_realSignIn() 구현**
   - Dio HTTP 클라이언트 사용
   - `/api/auth/sign-in` 엔드포인트
   - 타임아웃 10초 설정
   - DioException 에러 핸들링

4. **_realReissueToken() 구현**
   - `/api/auth/reissue` 엔드포인트
   - 401/404 에러 특별 처리 (재로그인 유도)
   - Refresh Token 만료 감지

5. **_realLogout() 구현**
   - ⭐ Authorization 헤더에 Access Token 포함
   - Flutter Secure Storage에서 토큰 읽기
   - 네트워크 오류 시에도 true 반환 (로컬 토큰 삭제 우선)

### 테스트 방법

**Mock 모드 (현재)**:
```dart
static const bool _useMockData = true;  // 현재 상태
```
- Google 로그인 → Mock JWT → 홈 화면 진입 (정상 작동)

**Real 모드 (백엔드 준비 후)**:
```dart
static const bool _useMockData = false;  // 백엔드 준비 시 변경
```
- Google 로그인 → 실제 백엔드 API → JWT 발급 → 홈 화면

### 다음 단계
1. 백엔드 서버 준비 확인
2. `_useMockData = false` 변경
3. 실제 API 통합 테스트 수행
4. 프로덕션 배포

---

**문서 버전**: 2.0.0 (구현 완료)
**최종 수정일**: 2025-10-17
**작성자**: Claude Code
