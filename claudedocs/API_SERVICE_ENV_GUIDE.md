# API 서비스 환경 변수 가이드

**작성일**: 2025-10-17
**목적**: 새로운 백엔드 API 서비스 개발 시 환경 변수 사용 표준

---

## 개요

Tripgether 앱의 모든 백엔드 API 서비스는 환경 변수를 통해 Base URL과 설정을 관리합니다.
이를 통해 개발/스테이징/프로덕션 환경을 코드 수정 없이 전환할 수 있습니다.

## 환경 변수 설정

### .env 파일 구조

```env
# ═══════════════════════════════════════════════════════════
# 백엔드 API 설정
# ═══════════════════════════════════════════════════════════
# 실제 백엔드 API Base URL
API_BASE_URL=http://api.tripgether.suhsaechan.kr

# HTTP 요청 타임아웃 (밀리초)
API_TIMEOUT=10000

# Mock/Real API 전환 플래그 (true: Mock, false: Real)
USE_MOCK_API=true
```

### 환경별 .env 파일 (추천)

프로젝트 루트에 환경별 파일을 생성하면 더 편리합니다:

```
.env                    # 기본 (개발 환경)
.env.development        # 개발 환경
.env.staging            # 스테이징 환경
.env.production         # 프로덕션 환경
```

**예시: .env.production**
```env
API_BASE_URL=https://api.tripgether.com
API_TIMEOUT=15000
USE_MOCK_API=false
```

## API 서비스 구현 패턴

### 1. Import 추가

```dart
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
```

### 2. 환경 변수 Getter 구현

```dart
class YourApiService {
  /// Base URL (환경 변수에서 읽기)
  static String get _baseUrl {
    return dotenv.env['API_BASE_URL'] ?? 'http://localhost:8000';
  }

  /// 타임아웃 (환경 변수에서 읽기)
  static int get _timeout {
    final timeoutStr = dotenv.env['API_TIMEOUT'] ?? '10000';
    return int.tryParse(timeoutStr) ?? 10000;
  }

  /// Mock 모드 여부 (환경 변수에서 읽기)
  static bool get _useMockData {
    final useMock = dotenv.env['USE_MOCK_API'] ?? 'true';
    return useMock.toLowerCase() == 'true';
  }
}
```

### 3. Dio 클라이언트 생성 시 사용

```dart
Future<Response> someApiCall() async {
  final dio = Dio(
    BaseOptions(
      baseUrl: _baseUrl,                              // ← 환경 변수
      connectTimeout: Duration(milliseconds: _timeout), // ← 환경 변수
      receiveTimeout: Duration(milliseconds: _timeout), // ← 환경 변수
      headers: {
        'Content-Type': 'application/json',
      },
    ),
  );

  return await dio.post('/api/some-endpoint', data: {...});
}
```

### 4. Mock/Real API 분기

```dart
Future<DataModel> fetchData() async {
  if (_useMockData) {
    return await _mockFetchData();  // Mock 데이터 반환
  } else {
    return await _realFetchData();  // 실제 API 호출
  }
}
```

## 실제 사용 예시

### auth_api_service.dart에서의 구현

```dart
class AuthApiService {
  // ✅ 환경 변수로 관리되는 설정들
  static bool get _useMockData {
    final useMock = dotenv.env['USE_MOCK_API'] ?? 'true';
    return useMock.toLowerCase() == 'true';
  }

  static String get _baseUrl {
    return dotenv.env['API_BASE_URL'] ?? 'http://api.tripgether.suhsaechan.kr';
  }

  static int get _timeout {
    final timeoutStr = dotenv.env['API_TIMEOUT'] ?? '10000';
    return int.tryParse(timeoutStr) ?? 10000;
  }

  // API 메서드에서 사용
  Future<AuthResponse> signIn(AuthRequest request) async {
    if (_useMockData) {
      return await _mockSignIn(request);
    } else {
      return await _realSignIn(request);
    }
  }

  Future<AuthResponse> _realSignIn(AuthRequest request) async {
    final dio = Dio(
      BaseOptions(
        baseUrl: _baseUrl,  // ← .env에서 읽어온 Base URL
        connectTimeout: Duration(milliseconds: _timeout),
        receiveTimeout: Duration(milliseconds: _timeout),
        headers: {'Content-Type': 'application/json'},
      ),
    );

    final response = await dio.post('/api/auth/sign-in', data: request.toJson());
    return AuthResponse.fromJson(response.data);
  }
}
```

## 환경 전환 방법

### 개발 중 (Mock 모드)

**.env 파일:**
```env
API_BASE_URL=http://api.tripgether.suhsaechan.kr
USE_MOCK_API=true  # ← Mock 모드 활성화
```

**동작:**
- Google 로그인 → Mock JWT 토큰 → 홈 화면
- 백엔드 서버 없이 전체 플로우 테스트 가능

### 백엔드 연동 시 (Real 모드)

**.env 파일:**
```env
API_BASE_URL=http://api.tripgether.suhsaechan.kr
USE_MOCK_API=false  # ← Real 모드 활성화
```

**동작:**
- Google 로그인 → 실제 백엔드 API 호출 → 진짜 JWT 토큰 → 홈 화면

### 프로덕션 배포

**.env.production 파일:**
```env
API_BASE_URL=https://api.tripgether.com  # ← HTTPS 프로덕션 URL
API_TIMEOUT=15000                         # ← 더 긴 타임아웃
USE_MOCK_API=false                        # ← Real 모드 필수
```

**빌드 명령어:**
```bash
# iOS
flutter build ios --dart-define-from-file=.env.production

# Android
flutter build apk --dart-define-from-file=.env.production
```

## 주의사항

### ✅ 올바른 사용

```dart
// ✅ GOOD: 환경 변수로 관리
static String get _baseUrl {
  return dotenv.env['API_BASE_URL'] ?? 'http://localhost:8000';
}

// ✅ GOOD: Getter 사용
final dio = Dio(BaseOptions(baseUrl: _baseUrl));
```

### ❌ 피해야 할 패턴

```dart
// ❌ BAD: 하드코딩
static const String _baseUrl = 'http://api.tripgether.suhsaechan.kr';

// ❌ BAD: 직접 URL 사용
final dio = Dio(BaseOptions(baseUrl: 'http://localhost:8000'));

// ❌ BAD: 환경별 분기문
final baseUrl = kDebugMode
  ? 'http://localhost:8000'
  : 'https://api.tripgether.com';
```

## 새 API 서비스 추가 체크리스트

새로운 백엔드 API 서비스를 만들 때 다음을 확인하세요:

- [ ] `flutter_dotenv` import 추가
- [ ] `_baseUrl` getter 구현 (dotenv.env 사용)
- [ ] `_timeout` getter 구현 (dotenv.env 사용)
- [ ] `_useMockData` getter 구현 (필요 시)
- [ ] Dio 클라이언트에서 환경 변수 사용
- [ ] Mock/Real API 분기 구현 (필요 시)
- [ ] .env 파일에 필요한 환경 변수 추가

## 디버깅

### 환경 변수 값 확인

```dart
debugPrint('[API Service] Base URL: $_baseUrl');
debugPrint('[API Service] Timeout: $_timeout');
debugPrint('[API Service] Use Mock: $_useMockData');
```

### .env 파일 로드 확인

**main.dart**에서 dotenv 로드 확인:
```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: ".env");  // ← 반드시 있어야 함

  runApp(MyApp());
}
```

## 참고 자료

- [flutter_dotenv 패키지](https://pub.dev/packages/flutter_dotenv)
- [Dio HTTP 클라이언트](https://pub.dev/packages/dio)
- [실제 구현 예시: auth_api_service.dart](../lib/features/auth/services/auth_api_service.dart)

---

**문서 버전**: 1.0.0
**최종 수정일**: 2025-10-17
**작성자**: Claude Code
