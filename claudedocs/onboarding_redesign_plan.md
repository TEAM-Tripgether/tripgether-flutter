# 온보딩 재설계 계획서

**작성일**: 2025-11-18
**목적**: Swagger API 분석 결과를 기반으로 올바른 온보딩 로직 재구현
**참고 문서**: [onboarding_api_analysis.md](./onboarding_api_analysis.md)

---

## 📋 설계 목표

### 핵심 요구사항

1. ✅ **USE_MOCK_API 분기 처리**: Mock/Real API 모드 지원
2. ✅ **각 단계마다 API 호출**: 5단계 온보딩 각각 서버 동기화
3. ✅ **currentStep 기반 라우팅**: API 응답의 `currentStep`으로 다음 화면 결정
4. ✅ **COMPLETED 체크**: `onboardingStatus`와 `currentStep` 모두 `COMPLETED`일 때만 홈으로 이동
5. ✅ **앱 재시작 복원**: 중단된 단계부터 재개
6. ✅ **Access Token Race Condition 해결**: 메모리 캐싱 도입

---

## 🏗️ 아키텍처 설계

### 계층 구조

```
┌─────────────────────────────────────────┐
│     Presentation Layer (UI)             │
│  - OnboardingScreen (PageView)          │
│  - TermsPage, NamePage, etc.            │
└──────────────┬──────────────────────────┘
               │
┌──────────────▼──────────────────────────┐
│     Business Logic Layer                │
│  - OnboardingNotifier (Riverpod)        │
│  - 각 단계별 API 호출 메서드             │
└──────────────┬──────────────────────────┘
               │
┌──────────────▼──────────────────────────┐
│     Data Layer                          │
│  - OnboardingApiService                 │
│    ├─ Mock Mode (로컬 응답)             │
│    └─ Real Mode (백엔드 API)            │
└──────────────┬──────────────────────────┘
               │
┌──────────────▼──────────────────────────┐
│     Storage Layer                       │
│  - UserNotifier (토큰 메모리 캐싱)      │
│  - FlutterSecureStorage (영구 저장)     │
└─────────────────────────────────────────┘
```

---

## 🔑 핵심 개념

### 1. `currentStep`의 의미

백엔드 응답의 `currentStep`은 **"다음에 수행할 단계"**를 의미합니다:

| API 호출 단계 | 완료된 작업 | 응답의 currentStep | 다음 UI 화면 | 페이지 인덱스 |
|------------|-----------|------------------|------------|------------|
| POST /terms | 약관 동의 | "NAME" | 이름 입력 페이지 | 1 |
| POST /name | 이름 설정 | "BIRTH_DATE" | 생년월일 입력 페이지 | 2 |
| POST /birth-date | 생년월일 설정 | "GENDER" | 성별 선택 페이지 | 3 |
| POST /gender | 성별 설정 | "INTERESTS" | 관심사 선택 페이지 | 4 |
| POST /interests | 관심사 설정 | "COMPLETED" | 완료 화면 (WelcomePage) | 5 |

**⚠️ 중요**: 뒤로가기 완전 차단 (AppBar 뒤로가기 아이콘 제거, 시스템 백버튼 차단)

### 2. 온보딩 완료 조건

온보딩이 완료되려면 **두 조건을 모두 만족**해야 합니다:

```dart
bool isOnboardingComplete(OnboardingResponse response) {
  return response.currentStep == 'COMPLETED' &&
         response.onboardingStatus == 'COMPLETED';
}
```

### 3. Mock vs Real API

```dart
// Mock 모드: 로컬에서 즉시 응답 생성
if (USE_MOCK_API) {
  return OnboardingResponse(
    currentStep: getNextStep(currentStep),
    onboardingStatus: 'IN_PROGRESS',
    member: updatedMember,
  );
}

// Real 모드: 백엔드 API 호출
else {
  final response = await dio.post('/api/members/onboarding/terms', ...);
  return OnboardingResponse.fromJson(response.data);
}
```

---

## 📐 상세 설계

### Phase 1: Access Token 메모리 캐싱 (UserNotifier)

**문제**: FlutterSecureStorage의 비동기 저장 지연으로 인한 Race Condition

**해결책**: 메모리 캐싱 추가

#### UserNotifier 수정

```dart
@Riverpod(keepAlive: true)
class UserNotifier extends _$UserNotifier {
  // ✨ 메모리 캐시 추가
  String? _accessTokenCache;
  String? _refreshTokenCache;

  /// 토큰 저장 (메모리 캐시 + Secure Storage)
  Future<void> _saveTokensToStorage({
    required String accessToken,
    required String refreshToken,
  }) async {
    try {
      // 1. 먼저 메모리 캐시에 즉시 저장 (동기)
      _accessTokenCache = accessToken;
      _refreshTokenCache = refreshToken;

      // 2. 그 다음 Secure Storage에 비동기로 저장
      await _storage.write(key: _accessTokenKey, value: accessToken);
      await _storage.write(key: _refreshTokenKey, value: refreshToken);

      debugPrint('[UserNotifier] 🔑 토큰 저장 완료 (메모리 + 저장소)');
    } catch (e) {
      debugPrint('[UserNotifier] ⚠️ 토큰 저장 실패: $e');
      rethrow;
    }
  }

  /// Access Token 읽기 (메모리 캐시 우선)
  Future<String?> getAccessToken() async {
    // 1. 메모리 캐시에서 먼저 확인 (즉시 반환)
    if (_accessTokenCache != null) {
      return _accessTokenCache;
    }

    // 2. 메모리에 없으면 Secure Storage에서 읽기
    try {
      _accessTokenCache = await _storage.read(key: _accessTokenKey);
      return _accessTokenCache;
    } catch (e) {
      debugPrint('[UserNotifier] ❌ Access Token 읽기 실패: $e');
      return null;
    }
  }

  /// 로그아웃 시 메모리 캐시 초기화
  Future<void> clearUser() async {
    // 메모리 캐시 초기화
    _accessTokenCache = null;
    _refreshTokenCache = null;

    // ... 기존 로그아웃 로직
  }
}
```

**장점**:
- ✅ 즉시 사용 가능 (동기적 메모리 접근)
- ✅ 플랫폼 독립적 (iOS/Android 동일)
- ✅ 안정적 (FlutterSecureStorage 지연 무관)

---

### Phase 2: OnboardingResponse 모델 정의

#### 파일: `lib/features/onboarding/data/models/onboarding_response.dart`

```dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'onboarding_response.freezed.dart';
part 'onboarding_response.g.dart';

/// 온보딩 API 응답 모델
///
/// **백엔드 응답 구조**:
/// ```json
/// {
///   "currentStep": "NAME",
///   "onboardingStatus": "IN_PROGRESS",
///   "member": { /* MemberDto */ }
/// }
/// ```
@freezed
class OnboardingResponse with _$OnboardingResponse {
  const factory OnboardingResponse({
    /// 다음에 수행할 온보딩 단계
    /// TERMS | NAME | BIRTH_DATE | GENDER | INTERESTS | COMPLETED
    required String currentStep,

    /// 전체 온보딩 진행 상태
    /// NOT_STARTED | IN_PROGRESS | COMPLETED
    required String onboardingStatus,

    /// 업데이트된 회원 정보
    required MemberDto member,
  }) = _OnboardingResponse;

  factory OnboardingResponse.fromJson(Map<String, dynamic> json) =>
      _$OnboardingResponseFromJson(json);
}

/// 회원 정보 DTO (백엔드 MemberDto 구조)
@freezed
class MemberDto with _$MemberDto {
  const factory MemberDto({
    required String id,
    required String email,
    required String name,
    required String onboardingStatus,
    required bool isServiceTermsAndPrivacyAgreed,
    required bool isMarketingAgreed,
    String? birthDate,
    String? gender,
  }) = _MemberDto;

  factory MemberDto.fromJson(Map<String, dynamic> json) =>
      _$MemberDtoFromJson(json);
}
```

---

### Phase 3: OnboardingApiService 구현

#### 파일: `lib/features/onboarding/services/onboarding_api_service.dart`

```dart
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../data/models/onboarding_response.dart';

/// 온보딩 API 서비스
///
/// Mock/Real API 분기 처리를 담당합니다.
class OnboardingApiService {
  // ══════════════════════════════════════════════════════════════
  // Mock/Real API 전환
  // ══════════════════════════════════════════════════════════════

  static bool get _useMockData {
    const dartDefine = String.fromEnvironment('USE_MOCK_API');
    if (dartDefine.isNotEmpty) {
      return dartDefine.toLowerCase() == 'true';
    }

    final envValue = dotenv.env['USE_MOCK_API'];
    if (envValue != null) {
      return envValue.toLowerCase() == 'true';
    }

    return true; // 기본값: Mock 모드
  }

  static String get _baseUrl {
    const dartDefine = String.fromEnvironment('API_BASE_URL');
    if (dartDefine.isNotEmpty) return dartDefine;

    return dotenv.env['API_BASE_URL'] ??
           'https://api.tripgether.suhsaechan.kr';
  }

  final Dio _dio;

  OnboardingApiService()
      : _dio = Dio(BaseOptions(
          baseUrl: _baseUrl,
          connectTimeout: const Duration(seconds: 10),
          receiveTimeout: const Duration(seconds: 10),
        ));

  // ══════════════════════════════════════════════════════════════
  // API 메서드
  // ══════════════════════════════════════════════════════════════

  /// 약관 동의
  Future<OnboardingResponse> agreeTerms({
    required String accessToken,
    required bool isServiceTermsAndPrivacyAgreed,
    required bool isMarketingAgreed,
  }) async {
    if (_useMockData) {
      return _mockAgreeTerms(
        isServiceTermsAndPrivacyAgreed: isServiceTermsAndPrivacyAgreed,
        isMarketingAgreed: isMarketingAgreed,
      );
    }

    final response = await _dio.post(
      '/api/members/onboarding/terms',
      options: Options(headers: {'Authorization': 'Bearer $accessToken'}),
      data: {
        'isServiceTermsAndPrivacyAgreed': isServiceTermsAndPrivacyAgreed,
        'isMarketingAgreed': isMarketingAgreed,
      },
    );

    return OnboardingResponse.fromJson(response.data);
  }

  /// 이름 설정
  Future<OnboardingResponse> updateName({
    required String accessToken,
    required String name,
  }) async {
    if (_useMockData) {
      return _mockUpdateName(name: name);
    }

    final response = await _dio.post(
      '/api/members/onboarding/name',
      options: Options(headers: {'Authorization': 'Bearer $accessToken'}),
      data: {'name': name},
    );

    return OnboardingResponse.fromJson(response.data);
  }

  /// 생년월일 설정
  Future<OnboardingResponse> updateBirthDate({
    required String accessToken,
    required String birthDate,
  }) async {
    if (_useMockData) {
      return _mockUpdateBirthDate(birthDate: birthDate);
    }

    final response = await _dio.post(
      '/api/members/onboarding/birth-date',
      options: Options(headers: {'Authorization': 'Bearer $accessToken'}),
      data: {'birthDate': birthDate},
    );

    return OnboardingResponse.fromJson(response.data);
  }

  /// 성별 설정
  Future<OnboardingResponse> updateGender({
    required String accessToken,
    required String gender,
  }) async {
    if (_useMockData) {
      return _mockUpdateGender(gender: gender);
    }

    final response = await _dio.post(
      '/api/members/onboarding/gender',
      options: Options(headers: {'Authorization': 'Bearer $accessToken'}),
      data: {'gender': gender},
    );

    return OnboardingResponse.fromJson(response.data);
  }

  /// 관심사 설정
  Future<OnboardingResponse> updateInterests({
    required String accessToken,
    required List<String> interestIds,
  }) async {
    if (_useMockData) {
      return _mockUpdateInterests(interestIds: interestIds);
    }

    final response = await _dio.post(
      '/api/members/onboarding/interests',
      options: Options(headers: {'Authorization': 'Bearer $accessToken'}),
      data: {'interestIds': interestIds},
    );

    return OnboardingResponse.fromJson(response.data);
  }

  // ══════════════════════════════════════════════════════════════
  // Mock API 응답
  // ══════════════════════════════════════════════════════════════

  OnboardingResponse _mockAgreeTerms({
    required bool isServiceTermsAndPrivacyAgreed,
    required bool isMarketingAgreed,
  }) {
    debugPrint('[OnboardingApiService] 🧪 Mock: 약관 동의');
    return const OnboardingResponse(
      currentStep: 'NAME',
      onboardingStatus: 'IN_PROGRESS',
      member: MemberDto(
        id: 'mock-user-id',
        email: 'mock@example.com',
        name: '',
        onboardingStatus: 'IN_PROGRESS',
        isServiceTermsAndPrivacyAgreed: true,
        isMarketingAgreed: false,
      ),
    );
  }

  OnboardingResponse _mockUpdateName({required String name}) {
    debugPrint('[OnboardingApiService] 🧪 Mock: 이름 설정 - $name');
    return OnboardingResponse(
      currentStep: 'BIRTH_DATE',
      onboardingStatus: 'IN_PROGRESS',
      member: MemberDto(
        id: 'mock-user-id',
        email: 'mock@example.com',
        name: name,
        onboardingStatus: 'IN_PROGRESS',
        isServiceTermsAndPrivacyAgreed: true,
        isMarketingAgreed: false,
      ),
    );
  }

  OnboardingResponse _mockUpdateBirthDate({required String birthDate}) {
    debugPrint('[OnboardingApiService] 🧪 Mock: 생년월일 설정 - $birthDate');
    return OnboardingResponse(
      currentStep: 'GENDER',
      onboardingStatus: 'IN_PROGRESS',
      member: MemberDto(
        id: 'mock-user-id',
        email: 'mock@example.com',
        name: 'Mock User',
        onboardingStatus: 'IN_PROGRESS',
        isServiceTermsAndPrivacyAgreed: true,
        isMarketingAgreed: false,
        birthDate: birthDate,
      ),
    );
  }

  OnboardingResponse _mockUpdateGender({required String gender}) {
    debugPrint('[OnboardingApiService] 🧪 Mock: 성별 설정 - $gender');
    return OnboardingResponse(
      currentStep: 'INTERESTS',
      onboardingStatus: 'IN_PROGRESS',
      member: MemberDto(
        id: 'mock-user-id',
        email: 'mock@example.com',
        name: 'Mock User',
        onboardingStatus: 'IN_PROGRESS',
        isServiceTermsAndPrivacyAgreed: true,
        isMarketingAgreed: false,
        birthDate: '1990-01-01',
        gender: gender,
      ),
    );
  }

  OnboardingResponse _mockUpdateInterests({required List<String> interestIds}) {
    debugPrint('[OnboardingApiService] 🧪 Mock: 관심사 설정 - ${interestIds.length}개');
    return const OnboardingResponse(
      currentStep: 'COMPLETED',
      onboardingStatus: 'COMPLETED',
      member: MemberDto(
        id: 'mock-user-id',
        email: 'mock@example.com',
        name: 'Mock User',
        onboardingStatus: 'COMPLETED',
        isServiceTermsAndPrivacyAgreed: true,
        isMarketingAgreed: false,
        birthDate: '1990-01-01',
        gender: 'MALE',
      ),
    );
  }
}
```

---

### Phase 4: OnboardingNotifier 구현

#### 파일: `lib/features/onboarding/providers/onboarding_notifier.dart`

```dart
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../auth/providers/user_provider.dart';
import '../data/models/onboarding_response.dart';
import '../services/onboarding_api_service.dart';

part 'onboarding_notifier.g.dart';

/// 온보딩 상태 및 API 호출 관리
@riverpod
class OnboardingNotifier extends _$OnboardingNotifier {
  final _storage = const FlutterSecureStorage();
  final _apiService = OnboardingApiService();

  @override
  Future<OnboardingResponse?> build() async {
    // 초기 상태: null (온보딩 시작 전)
    return null;
  }

  // ══════════════════════════════════════════════════════════════
  // 온보딩 단계별 API 호출
  // ══════════════════════════════════════════════════════════════

  /// 1. 약관 동의
  Future<OnboardingResponse?> agreeTerms({
    required bool isServiceTermsAndPrivacyAgreed,
    required bool isMarketingAgreed,
  }) async {
    try {
      // 1. Access Token 가져오기 (메모리 캐시에서 즉시 읽기)
      final accessToken = await ref.read(userNotifierProvider.notifier).getAccessToken();
      if (accessToken == null) {
        debugPrint('[OnboardingNotifier] ❌ Access Token 없음');
        return null;
      }

      // 2. API 호출
      final response = await _apiService.agreeTerms(
        accessToken: accessToken,
        isServiceTermsAndPrivacyAgreed: isServiceTermsAndPrivacyAgreed,
        isMarketingAgreed: isMarketingAgreed,
      );

      // 3. currentStep을 Secure Storage에 저장 (앱 재시작 복원용)
      await _storage.write(key: 'onboardingStep', value: response.currentStep);

      // 4. 상태 업데이트
      state = AsyncValue.data(response);

      return response;
    } catch (e, stack) {
      debugPrint('[OnboardingNotifier] ❌ 약관 동의 실패: $e');
      state = AsyncValue.error(e, stack);
      return null;
    }
  }

  /// 2. 이름 설정
  Future<OnboardingResponse?> updateName({required String name}) async {
    try {
      final accessToken = await ref.read(userNotifierProvider.notifier).getAccessToken();
      if (accessToken == null) return null;

      final response = await _apiService.updateName(
        accessToken: accessToken,
        name: name,
      );

      await _storage.write(key: 'onboardingStep', value: response.currentStep);
      state = AsyncValue.data(response);

      return response;
    } catch (e, stack) {
      debugPrint('[OnboardingNotifier] ❌ 이름 설정 실패: $e');
      state = AsyncValue.error(e, stack);
      return null;
    }
  }

  /// 3. 생년월일 설정
  Future<OnboardingResponse?> updateBirthDate({required String birthDate}) async {
    try {
      final accessToken = await ref.read(userNotifierProvider.notifier).getAccessToken();
      if (accessToken == null) return null;

      final response = await _apiService.updateBirthDate(
        accessToken: accessToken,
        birthDate: birthDate,
      );

      await _storage.write(key: 'onboardingStep', value: response.currentStep);
      state = AsyncValue.data(response);

      return response;
    } catch (e, stack) {
      debugPrint('[OnboardingNotifier] ❌ 생년월일 설정 실패: $e');
      state = AsyncValue.error(e, stack);
      return null;
    }
  }

  /// 4. 성별 설정
  Future<OnboardingResponse?> updateGender({required String gender}) async {
    try {
      final accessToken = await ref.read(userNotifierProvider.notifier).getAccessToken();
      if (accessToken == null) return null;

      final response = await _apiService.updateGender(
        accessToken: accessToken,
        gender: gender,
      );

      await _storage.write(key: 'onboardingStep', value: response.currentStep);
      state = AsyncValue.data(response);

      return response;
    } catch (e, stack) {
      debugPrint('[OnboardingNotifier] ❌ 성별 설정 실패: $e');
      state = AsyncValue.error(e, stack);
      return null;
    }
  }

  /// 5. 관심사 설정
  Future<OnboardingResponse?> updateInterests({required List<String> interestIds}) async {
    try {
      final accessToken = await ref.read(userNotifierProvider.notifier).getAccessToken();
      if (accessToken == null) return null;

      final response = await _apiService.updateInterests(
        accessToken: accessToken,
        interestIds: interestIds,
      );

      await _storage.write(key: 'onboardingStep', value: response.currentStep);
      state = AsyncValue.data(response);

      return response;
    } catch (e, stack) {
      debugPrint('[OnboardingNotifier] ❌ 관심사 설정 실패: $e');
      state = AsyncValue.error(e, stack);
      return null;
    }
  }
}
```

---

### Phase 5: 라우팅 로직 구현

#### 5-1. LoginScreen 수정

```dart
// 로그인 성공 후
final (success, isFirstLogin, onboardingStep) = await loginWithGoogle();

if (success && context.mounted) {
  if (onboardingStep == 'COMPLETED') {
    // 온보딩 완료 → 홈으로 이동
    context.go(AppRoutes.home);
  } else {
    // 온보딩 진행 필요 → 온보딩 화면으로 이동
    context.go(AppRoutes.onboarding);
  }
}
```

#### 5-2. 각 온보딩 페이지 수정

```dart
// TermsPage 예시
Future<void> _handleNext() async {
  setState(() => _isLoading = true);

  final response = await ref.read(onboardingNotifierProvider.notifier).agreeTerms(
    isServiceTermsAndPrivacyAgreed: _isServiceAgreed,
    isMarketingAgreed: _isMarketingAgreed,
  );

  if (!mounted) return;
  setState(() => _isLoading = false);

  if (response != null) {
    // currentStep에 따라 다음 페이지로 이동
    _navigateBasedOnCurrentStep(response.currentStep);
  } else {
    _showErrorSnackBar();
  }
}

void _navigateBasedOnCurrentStep(String currentStep) {
  switch (currentStep) {
    case 'NAME':
      widget.pageController.nextPage(...);
      break;
    case 'COMPLETED':
      context.go(AppRoutes.home);
      break;
    // ... 기타 단계 처리
  }
}
```

#### 5-3. SplashScreen 수정

```dart
void _navigateAfterSessionRestore(bool hasUser) async {
  await Future.delayed(const Duration(milliseconds: 2500));
  if (!mounted) return;

  if (hasUser) {
    // Secure Storage에서 onboardingStep 읽기
    const storage = FlutterSecureStorage();
    final onboardingStep = await storage.read(key: 'onboardingStep');

    if (!mounted) return;

    // onboardingStep이 COMPLETED가 아니면 온보딩 화면으로
    if (onboardingStep != null && onboardingStep != 'COMPLETED') {
      context.go(AppRoutes.onboarding);
    } else {
      context.go(AppRoutes.home);
    }
  } else {
    context.go(AppRoutes.login);
  }
}
```

---

## 📊 상태 흐름도

```
[앱 시작]
    │
    ▼
[SplashScreen]
    │
    ├─ hasUser == false ─────────────────────────────────────► [LoginScreen]
    │                                                                │
    │                                                                │ 로그인 성공
    │                                                                ▼
    │                                                     [AuthResponse.onboardingStep 확인]
    │                                                                │
    │                                                                ├─ "COMPLETED" ───► [HomeScreen]
    │                                                                └─ 기타 ──────────► [OnboardingScreen]
    │
    └─ hasUser == true ────► [Secure Storage에서 onboardingStep 읽기]
                                     │
                                     ├─ null 또는 "COMPLETED" ───────► [HomeScreen]
                                     └─ "TERMS", "NAME", ... ────────► [OnboardingScreen]


[OnboardingScreen 내부 흐름]

[TermsPage] ─ API 호출 ─► response.currentStep == "NAME" ─► [NamePage]
                                                                   │
[NamePage] ─ API 호출 ─► response.currentStep == "BIRTH_DATE" ─► [BirthdatePage]
                                                                         │
[BirthdatePage] ─ API 호출 ─► response.currentStep == "GENDER" ─► [GenderPage]
                                                                          │
[GenderPage] ─ API 호출 ─► response.currentStep == "INTERESTS" ─► [InterestsPage]
                                                                           │
[InterestsPage] ─ API 호출 ─► response.currentStep == "COMPLETED" ─► [WelcomePage]
                               response.onboardingStatus == "COMPLETED"          │
                                                                                 ▼
                                                                           [HomeScreen]
```

---

## ✅ 체크리스트

### Phase 1: 토큰 관리 (UserNotifier)
- [ ] `_accessTokenCache`, `_refreshTokenCache` 메모리 변수 추가
- [ ] `_saveTokensToStorage()` 수정: 메모리 캐시 먼저 저장
- [ ] `getAccessToken()` 메서드 추가: 메모리 캐시 우선 읽기
- [ ] `clearUser()` 수정: 메모리 캐시 초기화 추가

### Phase 2: 데이터 모델
- [ ] `OnboardingResponse` Freezed 모델 생성
- [ ] `MemberDto` Freezed 모델 생성
- [ ] `dart run build_runner build` 실행

### Phase 3: API 서비스
- [ ] `OnboardingApiService` 클래스 생성
- [ ] Mock API 응답 메서드 5개 구현
- [ ] Real API 호출 메서드 5개 구현
- [ ] `USE_MOCK_API` 플래그 분기 처리

### Phase 4: 상태 관리
- [ ] `OnboardingNotifier` Riverpod Provider 생성
- [ ] 5개 API 호출 메서드 구현
- [ ] currentStep Secure Storage 저장 로직 추가
- [ ] `dart run build_runner build` 실행

### Phase 5: UI 수정
- [ ] `TermsPage` - `agreeTerms()` 호출 + 라우팅
- [ ] `NamePage` - `updateName()` 호출 + 라우팅
- [ ] `BirthdatePage` - `updateBirthDate()` 호출 + 라우팅
- [ ] `GenderPage` - `updateGender()` 호출 + 라우팅
- [ ] `InterestsPage` - `updateInterests()` 호출 + 라우팅
- [ ] `LoginScreen` - onboardingStep 기반 라우팅
- [ ] `SplashScreen` - onboardingStep 복원 로직

### Phase 6: 테스트
- [ ] Mock 모드로 전체 온보딩 플로우 테스트
- [ ] 중간에 앱 종료 후 재시작 → 복원 확인
- [ ] COMPLETED 체크 → 홈 화면 이동 확인
- [ ] Real 모드 전환 후 백엔드 연동 테스트

---

## 🎯 예상 결과

### 시나리오 1: 첫 로그인 (Mock 모드)

```
1. 로그인 성공 → onboardingStep = "TERMS"
2. 약관 동의 → API 호출 → currentStep = "NAME"
3. 이름 입력 → API 호출 → currentStep = "BIRTH_DATE"
4. 생년월일 입력 → API 호출 → currentStep = "GENDER"
5. 성별 선택 → API 호출 → currentStep = "INTERESTS"
6. 관심사 선택 → API 호출 → currentStep = "COMPLETED", onboardingStatus = "COMPLETED"
7. 홈 화면으로 자동 이동
```

### 시나리오 2: 중단 후 재시작

```
1. 생년월일까지 완료 후 앱 종료
   - Secure Storage에 onboardingStep = "GENDER" 저장됨
2. 앱 재시작 → SplashScreen
3. Secure Storage에서 onboardingStep 읽기 → "GENDER"
4. OnboardingScreen으로 이동 (성별 선택 페이지부터 시작)
5. 성별 선택 → API 호출 → 다음 단계 진행
```

### 시나리오 3: 온보딩 완료 후 재로그인

```
1. 이전에 온보딩 완료 (onboardingStep = "COMPLETED")
2. 로그아웃 후 재로그인
3. AuthResponse.onboardingStep = "COMPLETED"
4. LoginScreen에서 즉시 홈으로 이동
```

---

**설계 종료**
