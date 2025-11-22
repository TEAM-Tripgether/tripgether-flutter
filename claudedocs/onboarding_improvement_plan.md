# 온보딩 플로우 개선 계획

## 📊 개요

**분석 완료일**: 2025-11-19
**총 이슈 수**: 18개
**예상 총 작업 시간**: 약 15시간
**스프린트 수**: 3개 (Critical → High Priority → Refactoring)

---

## 🎯 스프린트 구성

### Sprint 1: Critical Issues (Week 1) - 5.5시간
**목표**: 앱 안정성과 Riverpod 규칙 준수를 위한 핵심 버그 수정

### Sprint 2: High Priority (Week 2) - 5.5시간
**목표**: 사용자 경험 개선 및 에러 처리 강화

### Sprint 3: Refactoring & Optimization (Week 3) - 4시간
**목표**: 코드 품질 향상 및 성능 최적화

---

# Sprint 1: Critical Issues

## 🚨 Issue #1: initState에서 ref.read() 사용 (5개 파일)

### **우선순위**: 🔴 CRITICAL
### **예상 시간**: 2시간
### **영향도**: Riverpod 규칙 위반, 상태 동기화 문제 가능성

### 문제점
```dart
// ❌ WRONG - initState에서 ref.read() 사용
@override
void initState() {
  super.initState();
  final currentStep = ref.read(onboardingNotifierProvider).value?.currentStep;
}
```

### 해결 방법
**Option A: WidgetsBinding.addPostFrameCallback 사용 (권장)**
```dart
@override
void initState() {
  super.initState();
  WidgetsBinding.instance.addPostFrameCallback((_) {
    if (!mounted) return;
    final currentStep = ref.read(onboardingNotifierProvider).value?.currentStep;
    _pageController.jumpToPage(_getPageIndex(currentStep));
  });
}
```

**Option B: ref.listen 사용**
```dart
@override
void initState() {
  super.initState();
  // Listen은 initState에서 안전하게 사용 가능
  ref.listen(onboardingNotifierProvider, (previous, next) {
    if (next.hasValue) {
      final currentStep = next.value!.currentStep;
      _pageController.jumpToPage(_getPageIndex(currentStep));
    }
  });
}
```

### 수정 대상 파일
1. [terms_page.dart:45](../lib/features/onboarding/presentation/pages/terms_page.dart#L45)
2. [nickname_page.dart:38](../lib/features/onboarding/presentation/pages/nickname_page.dart#L38)
3. [birthdate_page.dart:42](../lib/features/onboarding/presentation/pages/birthdate_page.dart#L42)
4. [gender_page.dart:36](../lib/features/onboarding/presentation/pages/gender_page.dart#L36)
5. [interests_page.dart:48](../lib/features/onboarding/presentation/pages/interests_page.dart#L48)

### 작업 순서
```
1. terms_page.dart 수정 (30분)
   - addPostFrameCallback로 변경
   - mounted 체크 추가
   - 테스트: 약관 페이지 초기화 확인

2. nickname_page.dart 수정 (20분)
   - 동일 패턴 적용

3. birthdate_page.dart 수정 (20분)
   - 동일 패턴 적용

4. gender_page.dart 수정 (20분)
   - 동일 패턴 적용

5. interests_page.dart 수정 (30min)
   - OverlayEntry disposal 로직과 함께 개선
   - 테스트: 관심사 선택 드롭다운 동작 확인
```

---

## 🚨 Issue #2: Access Token 경쟁 조건 (Race Condition)

### **우선순위**: 🔴 CRITICAL
### **예상 시간**: 3시간
### **영향도**: API 호출 실패, 401 에러 가능성

### 문제점
```dart
// LoginProvider에서 토큰 저장
await ref.read(userNotifierProvider.notifier).setUser(
  user: user,
  accessToken: authResponse.accessToken,
  refreshToken: authResponse.refreshToken,
);

// 즉시 OnboardingScreen으로 이동
context.go(AppRoutes.onboarding);

// OnboardingNotifier가 토큰을 읽으려 시도
final accessToken = await storage.read(key: 'access_token');
// ⚠️ 아직 토큰이 Storage에 저장되지 않았을 수 있음 (iOS는 최대 100ms 지연)
```

### 해결 방법
**Option A: setUser() 완료 보장 + 메모리 캐싱**

```dart
// 1. UserNotifier에 메모리 캐시 추가
@riverpod
class UserNotifier extends _$UserNotifier {
  String? _cachedAccessToken;  // ✅ 메모리 캐시

  Future<void> setUser({
    required User user,
    required String accessToken,
    required String refreshToken,
  }) async {
    // 메모리 캐시 즉시 업데이트
    _cachedAccessToken = accessToken;

    // Storage 비동기 저장
    await storage.write(key: 'access_token', value: accessToken);
    await storage.write(key: 'refresh_token', value: refreshToken);

    state = AsyncValue.data(user);
  }

  String? get accessToken => _cachedAccessToken;  // ✅ 즉시 접근
}
```

```dart
// 2. OnboardingNotifier에서 메모리 캐시 우선 사용
Future<OnboardingState> build() async {
  // 메모리 캐시 확인 (즉시 사용 가능)
  final cachedToken = ref.read(userNotifierProvider.notifier).accessToken;

  if (cachedToken != null) {
    return _initializeWithToken(cachedToken);  // ✅ 경쟁 조건 회피
  }

  // Fallback: Storage 읽기 (앱 재시작 후)
  final storageToken = await storage.read(key: 'access_token');
  if (storageToken != null) {
    return _initializeWithToken(storageToken);
  }

  throw Exception('Access Token not found');
}
```

**Option B: LoginProvider에서 완료 대기**

```dart
// LoginProvider.dart
Future<(bool, bool)> loginWithGoogle() async {
  // ... Google OAuth ...

  // 1. 토큰 저장 완료 대기 (await)
  await ref.read(userNotifierProvider.notifier).setUser(
    user: user,
    accessToken: authResponse.accessToken,
    refreshToken: authResponse.refreshToken,
  );

  // 2. 추가 지연 (iOS Keychain 보장)
  await Future.delayed(const Duration(milliseconds: 150));

  // 3. 이제 안전하게 이동
  return (true, authResponse.requiresOnboarding);
}
```

### 권장 솔루션
**Option A (메모리 캐싱)** - 더 안정적이고 빠름

### 수정 대상 파일
1. [user_provider.dart](../lib/features/auth/providers/user_provider.dart) - 메모리 캐시 추가
2. [onboarding_notifier.dart](../lib/features/onboarding/providers/onboarding_notifier.dart) - 캐시 우선 사용
3. [login_provider.dart](../lib/features/auth/providers/login_provider.dart) - 검증 로그 추가

### 작업 순서
```
1. user_provider.dart 수정 (1.5시간)
   - _cachedAccessToken, _cachedRefreshToken 필드 추가
   - setUser()에서 메모리 캐시 업데이트
   - clearUser()에서 캐시 초기화
   - Getter 메서드 추가
   - 테스트: 캐시 동작 확인

2. onboarding_notifier.dart 수정 (1시간)
   - build()에서 메모리 캐시 우선 확인
   - Fallback: Storage 읽기
   - 에러 처리 개선
   - 테스트: 로그인 후 즉시 온보딩 API 호출 성공 확인

3. login_provider.dart 검증 (30분)
   - 로그 추가: "토큰 저장 완료", "캐시 확인됨"
   - 통합 테스트: 실제 기기에서 로그인 → 온보딩 플로우
```

---

## 🚨 Issue #3: onboardingStep null 처리 부족

### **우선순위**: 🔴 CRITICAL
### **예상 시간**: 30분
### **영향도**: 런타임 크래시 가능성

### 문제점
```dart
// splash_screen.dart:95
final onboardingStep = await storage.read(key: 'onboardingStep');

if (onboardingStep != null && onboardingStep != 'COMPLETED') {
  context.go(AppRoutes.onboarding);  // ✅ null 체크 있음
}

// onboarding_screen.dart:45
final onboardingStep = await storage.read(key: 'onboardingStep');
final pageIndex = _getPageIndex(onboardingStep);  // ❌ null 가능성!
```

### 해결 방법
```dart
// onboarding_screen.dart - Null-safe 처리
final onboardingStep = await storage.read(key: 'onboardingStep');

// null인 경우 기본값 사용 (TERMS 또는 서버에서 가져오기)
final safeStep = onboardingStep ?? 'TERMS';
final pageIndex = _getPageIndex(safeStep);

debugPrint('[OnboardingScreen] 📍 복원된 단계: $safeStep (원본: $onboardingStep)');
```

### 수정 대상 파일
1. [onboarding_screen.dart:45](../lib/features/onboarding/presentation/screens/onboarding_screen.dart#L45)

### 작업 순서
```
1. onboarding_screen.dart 수정 (30분)
   - null 체크 추가
   - 기본값 'TERMS' 설정
   - 디버그 로그 추가
   - 테스트: Storage에 값 없을 때 TERMS부터 시작 확인
```

---

# Sprint 2: High Priority Issues

## ⚠️ Issue #4: 온보딩 초기화 실패 시 에러 처리

### **우선순위**: 🟡 HIGH
### **예상 시간**: 1시간
### **영향도**: 사용자가 진행 불가능한 상태로 갇힐 수 있음

### 문제점
```dart
// onboarding_notifier.dart
Future<OnboardingState> build() async {
  final accessToken = await storage.read(key: 'access_token');

  if (accessToken == null) {
    throw Exception('Access Token not found');  // ❌ 사용자에게 보이지 않음
  }
}
```

### 해결 방법
```dart
// onboarding_notifier.dart - 에러 처리 개선
Future<OnboardingState> build() async {
  try {
    final accessToken = await storage.read(key: 'access_token');

    if (accessToken == null) {
      debugPrint('[OnboardingNotifier] ❌ Access Token 없음 → 로그인 화면으로 이동 필요');

      // ✅ 사용자에게 알림 + 로그인 화면 이동
      throw OnboardingException(
        'tokenNotFound',
        '로그인 정보가 만료되었습니다. 다시 로그인해주세요.',
        shouldRedirectToLogin: true,
      );
    }

    // ... API 호출 ...

  } on DioException catch (e) {
    debugPrint('[OnboardingNotifier] ❌ API 에러: ${e.message}');

    if (e.response?.statusCode == 401) {
      throw OnboardingException(
        'unauthorized',
        '인증이 만료되었습니다. 다시 로그인해주세요.',
        shouldRedirectToLogin: true,
      );
    }

    throw OnboardingException(
      'apiError',
      '온보딩 정보를 불러오지 못했습니다.\n잠시 후 다시 시도해주세요.',
      shouldRetry: true,
    );
  }
}
```

```dart
// onboarding_exception.dart - 새 파일
class OnboardingException implements Exception {
  final String code;
  final String userMessage;
  final bool shouldRedirectToLogin;
  final bool shouldRetry;

  OnboardingException(
    this.code,
    this.userMessage, {
    this.shouldRedirectToLogin = false,
    this.shouldRetry = false,
  });
}
```

```dart
// onboarding_screen.dart - 에러 UI 처리
@override
Widget build(BuildContext context) {
  final onboardingState = ref.watch(onboardingNotifierProvider);

  return onboardingState.when(
    data: (state) => _buildOnboardingFlow(state),
    loading: () => _buildLoadingScreen(),
    error: (error, stack) {
      // ✅ 사용자 친화적 에러 처리
      if (error is OnboardingException) {
        return _buildErrorScreen(
          message: error.userMessage,
          onRetry: error.shouldRetry ? () => ref.refresh(onboardingNotifierProvider) : null,
          onGoToLogin: error.shouldRedirectToLogin ? () => context.go(AppRoutes.login) : null,
        );
      }

      return _buildErrorScreen(
        message: '오류가 발생했습니다.\n잠시 후 다시 시도해주세요.',
        onRetry: () => ref.refresh(onboardingNotifierProvider),
      );
    },
  );
}

Widget _buildErrorScreen({
  required String message,
  VoidCallback? onRetry,
  VoidCallback? onGoToLogin,
}) {
  return Scaffold(
    body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 64, color: AppColors.error),
          SizedBox(height: AppSpacing.lg),
          Text(message, textAlign: TextAlign.center, style: AppTextStyles.bodyMedium16),
          SizedBox(height: AppSpacing.xxl),
          if (onRetry != null)
            PrimaryButton(text: '다시 시도', onPressed: onRetry),
          if (onGoToLogin != null)
            PrimaryButton(text: '로그인 화면으로', onPressed: onGoToLogin),
        ],
      ),
    ),
  );
}
```

### 수정 대상 파일
1. [onboarding_notifier.dart](../lib/features/onboarding/providers/onboarding_notifier.dart) - 에러 처리 강화
2. [onboarding_screen.dart](../lib/features/onboarding/presentation/screens/onboarding_screen.dart) - 에러 UI 추가
3. **새 파일**: `lib/features/onboarding/exceptions/onboarding_exception.dart`

### 작업 순서
```
1. onboarding_exception.dart 생성 (15분)
   - OnboardingException 클래스 작성

2. onboarding_notifier.dart 수정 (30분)
   - try-catch 블록 추가
   - OnboardingException throw
   - DioException 처리

3. onboarding_screen.dart 수정 (15분)
   - _buildErrorScreen() 추가
   - when(error:) 처리 개선
   - 테스트: 토큰 없을 때 에러 화면 표시 확인
```

---

## ⚠️ Issue #5-6: API 실패 시 사용자 피드백 부족

### **우선순위**: 🟡 HIGH
### **예상 시간**: 1.5시간
### **영향도**: 사용자가 오류 원인을 알 수 없음

### 문제점
```dart
// terms_page.dart
final success = await ref.read(onboardingNotifierProvider.notifier).saveTermsAgreement(...);

if (success) {
  _pageController.nextPage(...);
} else {
  // ❌ 아무 피드백 없음! 사용자는 왜 진행이 안 되는지 모름
}
```

### 해결 방법
**Step 1: OnboardingNotifier에서 구체적 에러 메시지 반환**

```dart
// onboarding_notifier.dart
Future<(bool success, String? errorMessage)> saveTermsAgreement({
  required bool serviceTermsAndPrivacy,
  required bool marketing,
}) async {
  try {
    final response = await onboardingService.updateTerms(...);

    state = AsyncValue.data(state.value!.copyWith(
      currentStep: response.currentStep,
      onboardingStatus: response.onboardingStatus,
    ));

    return (true, null);  // ✅ 성공

  } on DioException catch (e) {
    debugPrint('[OnboardingNotifier] ❌ 약관 저장 실패: ${e.response?.data}');

    // ✅ 사용자 친화적 에러 메시지
    final errorMessage = switch (e.response?.statusCode) {
      401 => '로그인이 만료되었습니다. 다시 로그인해주세요.',
      400 => '잘못된 요청입니다. 약관 동의를 확인해주세요.',
      500 => '서버 오류가 발생했습니다. 잠시 후 다시 시도해주세요.',
      _ => '네트워크 오류가 발생했습니다.\n인터넷 연결을 확인해주세요.',
    };

    return (false, errorMessage);

  } catch (e) {
    debugPrint('[OnboardingNotifier] ❌ 예상치 못한 에러: $e');
    return (false, '오류가 발생했습니다. 다시 시도해주세요.');
  }
}
```

**Step 2: 각 페이지에서 SnackBar로 에러 표시**

```dart
// terms_page.dart
Future<void> _handleNext() async {
  if (!_serviceTermsAndPrivacy) {
    // 필수 약관 미동의
    _showErrorSnackBar('필수 약관에 동의해주세요.');
    return;
  }

  // ✅ 로딩 표시
  setState(() => _isLoading = true);

  final (success, errorMessage) = await ref
      .read(onboardingNotifierProvider.notifier)
      .saveTermsAgreement(
        serviceTermsAndPrivacy: _serviceTermsAndPrivacy,
        marketing: _marketing,
      );

  setState(() => _isLoading = false);

  if (success) {
    _pageController.nextPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  } else {
    // ✅ 에러 메시지 표시
    _showErrorSnackBar(errorMessage ?? '저장에 실패했습니다.');
  }
}

void _showErrorSnackBar(String message) {
  if (!mounted) return;

  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message, style: AppTextStyles.bodyMedium14.copyWith(color: Colors.white)),
      backgroundColor: AppColors.error,
      duration: const Duration(seconds: 3),
      behavior: SnackBarBehavior.floating,
      margin: EdgeInsets.all(AppSpacing.lg),
    ),
  );
}
```

### 수정 대상 파일
1. [onboarding_notifier.dart](../lib/features/onboarding/providers/onboarding_notifier.dart) - 반환 타입 변경
2. [terms_page.dart](../lib/features/onboarding/presentation/pages/terms_page.dart)
3. [nickname_page.dart](../lib/features/onboarding/presentation/pages/nickname_page.dart)
4. [birthdate_page.dart](../lib/features/onboarding/presentation/pages/birthdate_page.dart)
5. [gender_page.dart](../lib/features/onboarding/presentation/pages/gender_page.dart)
6. [interests_page.dart](../lib/features/onboarding/presentation/pages/interests_page.dart)

### 작업 순서
```
1. onboarding_notifier.dart 수정 (30분)
   - 모든 메서드 반환 타입을 (bool, String?) 튜플로 변경
   - DioException 에러 메시지 매핑
   - 테스트: Mock API에서 401, 500 에러 시뮬레이션

2. terms_page.dart 수정 (15min)
   - _showErrorSnackBar() 추가
   - _handleNext() 에러 처리 개선
   - _isLoading 상태 추가
   - 테스트: 네트워크 끊고 다음 버튼 클릭

3. nickname_page.dart 수정 (15min)
   - 동일 패턴 적용

4. birthdate_page.dart 수정 (15min)
   - 동일 패턴 적용

5. gender_page.dart 수정 (15min)
   - 동일 패턴 적용

6. interests_page.dart 수정 (15min)
   - 동일 패턴 적용
   - 테스트: 전체 온보딩 플로우에서 각 단계 에러 처리 확인
```

---

## ⚠️ Issue #7: BirthDate 유효성 검사 성능

### **우선순위**: 🟡 HIGH
### **예상 시간**: 30분
### **영향도**: 불필요한 리빌드로 입력 딜레이 발생

### 문제점
```dart
// birthdate_page.dart - onChange마다 setState() 호출
TextField(
  onChanged: (value) {
    setState(() {
      _birthdate = value;
      _isValid = _validateDate(value);  // ❌ 매 타이핑마다 검증
    });
  },
)
```

### 해결 방법
```dart
// birthdate_page.dart - Debounce 적용
import 'dart:async';

class _BirthdatePageState extends State<BirthdatePage> {
  Timer? _debounceTimer;
  bool _isValid = false;
  String _birthdate = '';

  @override
  void dispose() {
    _debounceTimer?.cancel();
    super.dispose();
  }

  void _onBirthdateChanged(String value) {
    setState(() {
      _birthdate = value;
    });

    // ✅ 500ms 대기 후 검증 (타이핑 중단 시에만 실행)
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 500), () {
      if (!mounted) return;
      setState(() {
        _isValid = _validateDate(value);
      });
    });
  }

  bool _validateDate(String date) {
    if (date.length != 8) return false;

    final year = int.tryParse(date.substring(0, 4));
    final month = int.tryParse(date.substring(4, 6));
    final day = int.tryParse(date.substring(6, 8));

    if (year == null || month == null || day == null) return false;

    final now = DateTime.now();
    final birthDate = DateTime(year, month, day);

    return birthDate.isBefore(now) && year >= 1900;
  }
}
```

### 수정 대상 파일
1. [birthdate_page.dart](../lib/features/onboarding/presentation/pages/birthdate_page.dart)

### 작업 순서
```
1. birthdate_page.dart 수정 (30min)
   - Timer import 추가
   - _onBirthdateChanged() 메서드 추가
   - dispose()에서 Timer 취소
   - 테스트: 빠르게 타이핑 → 500ms 후 검증 실행 확인
```

---

## ⚠️ Issue #8: Storage 중복 읽기

### **우선순위**: 🟡 HIGH
### **예상 시간**: 1시간
### **영향도**: iOS Keychain 접근 지연 누적

### 문제점
```dart
// splash_screen.dart
final user = await storage.read(key: 'user_info');          // 읽기 #1
final accessToken = await storage.read(key: 'access_token'); // 읽기 #2
final onboardingStep = await storage.read(key: 'onboardingStep'); // 읽기 #3

// onboarding_screen.dart
final onboardingStep = await storage.read(key: 'onboardingStep'); // 중복 읽기!
```

### 해결 방법
**Option A: UserProvider에서 onboardingStep 관리 (권장)**

```dart
// user_provider.dart - onboardingStep을 User 상태와 함께 관리
@riverpod
class UserNotifier extends _$UserNotifier {
  String? _cachedAccessToken;
  String? _cachedRefreshToken;
  String? _cachedOnboardingStep;  // ✅ 추가

  @override
  Future<User?> build() async {
    final userJson = await storage.read(key: 'user_info');
    final accessToken = await storage.read(key: 'access_token');
    final onboardingStep = await storage.read(key: 'onboardingStep');

    // 메모리 캐시 초기화
    _cachedAccessToken = accessToken;
    _cachedRefreshToken = await storage.read(key: 'refresh_token');
    _cachedOnboardingStep = onboardingStep;  // ✅ 캐시

    if (userJson != null) {
      return User.fromJson(jsonDecode(userJson));
    }
    return null;
  }

  String? get accessToken => _cachedAccessToken;
  String? get refreshToken => _cachedRefreshToken;
  String? get onboardingStep => _cachedOnboardingStep;  // ✅ Getter

  Future<void> updateOnboardingStep(String step) async {
    _cachedOnboardingStep = step;
    await storage.write(key: 'onboardingStep', value: step);
  }
}
```

```dart
// splash_screen.dart - 캐시된 값 사용
final user = await ref.read(userNotifierProvider.future);

if (user != null) {
  // ✅ 캐시에서 읽기 (Storage 접근 불필요)
  final onboardingStep = ref.read(userNotifierProvider.notifier).onboardingStep;

  if (onboardingStep != null && onboardingStep != 'COMPLETED') {
    context.go(AppRoutes.onboarding);
  } else {
    context.go(AppRoutes.home);
  }
} else {
  context.go(AppRoutes.login);
}
```

```dart
// onboarding_screen.dart - 캐시 사용
final onboardingStep = ref.read(userNotifierProvider.notifier).onboardingStep ?? 'TERMS';
final pageIndex = _getPageIndex(onboardingStep);
```

### 수정 대상 파일
1. [user_provider.dart](../lib/features/auth/providers/user_provider.dart)
2. [splash_screen.dart](../lib/features/splash/presentation/screens/splash_screen.dart)
3. [onboarding_screen.dart](../lib/features/onboarding/presentation/screens/onboarding_screen.dart)

### 작업 순서
```
1. user_provider.dart 수정 (30min)
   - _cachedOnboardingStep 필드 추가
   - build()에서 초기화
   - onboardingStep Getter 추가
   - updateOnboardingStep() 메서드 추가

2. splash_screen.dart 수정 (15min)
   - Storage 직접 읽기 제거
   - UserNotifier 캐시 사용

3. onboarding_screen.dart 수정 (15min)
   - Storage 직접 읽기 제거
   - UserNotifier 캐시 사용
   - 테스트: 앱 시작 → 로그인 → 온보딩 플로우에서 Storage 읽기 횟수 확인
```

---

## ⚠️ Issue #9: Storage 쓰기 타이밍

### **우선순위**: 🟡 HIGH
### **예상 시간**: 1시간
### **영향도**: 앱 종료 시 데이터 유실 가능성

### 문제점
```dart
// onboarding_notifier.dart - API 호출 후 바로 Storage 업데이트
final response = await onboardingService.updateTerms(...);

// ✅ 상태 업데이트 (메모리)
state = AsyncValue.data(state.value!.copyWith(currentStep: response.currentStep));

// ❌ Storage 업데이트 누락! (앱 종료 시 진행 상황 유실)
```

### 해결 방법
```dart
// onboarding_notifier.dart - Storage 동기화 추가
Future<(bool, String?)> saveTermsAgreement({
  required bool serviceTermsAndPrivacy,
  required bool marketing,
}) async {
  try {
    final response = await onboardingService.updateTerms(...);

    // 1. 상태 업데이트
    state = AsyncValue.data(state.value!.copyWith(
      currentStep: response.currentStep,
      onboardingStatus: response.onboardingStatus,
    ));

    // 2. ✅ Storage에 즉시 저장 (앱 종료 대비)
    await ref.read(userNotifierProvider.notifier).updateOnboardingStep(response.currentStep);

    debugPrint('[OnboardingNotifier] 💾 Storage 동기화: ${response.currentStep}');

    return (true, null);

  } catch (e) {
    return (false, '저장 실패');
  }
}
```

**모든 온보딩 메서드에 동일 패턴 적용**:
- `saveTermsAgreement()`
- `saveName()`
- `saveBirthDate()`
- `saveGender()`
- `saveInterests()`

### 수정 대상 파일
1. [onboarding_notifier.dart](../lib/features/onboarding/providers/onboarding_notifier.dart)

### 작업 순서
```
1. saveTermsAgreement() 수정 (10min)
   - updateOnboardingStep() 호출 추가

2. saveName() 수정 (10min)
   - 동일 패턴 적용

3. saveBirthDate() 수정 (10min)
   - 동일 패턴 적용

4. saveGender() 수정 (10min)
   - 동일 패턴 적용

5. saveInterests() 수정 (10min)
   - 동일 패턴 적용

6. 통합 테스트 (10min)
   - 각 단계 저장 → 앱 강제 종료 → 재시작 → 올바른 단계로 복원 확인
```

---

## ⚠️ Issue #10: onboardingStep null 처리 (login_provider.dart)

### **우선순위**: 🟡 HIGH
### **예상 시간**: 30분
### **영향도**: 서버 응답이 null일 경우 크래시

### 문제점
```dart
// login_provider.dart:177
await storage.write(
  key: 'onboardingStep',
  value: authResponse.onboardingStep  // ❌ null 가능성 체크 없음
);
```

### 해결 방법
```dart
// login_provider.dart - Null-safe 처리
if (authResponse.requiresOnboarding) {
  // ✅ null 체크 추가
  final stepToSave = authResponse.onboardingStep.isEmpty
      ? 'TERMS'  // 기본값
      : authResponse.onboardingStep;

  await storage.write(key: 'onboardingStep', value: stepToSave);

  debugPrint('[LoginProvider] 🎯 온보딩 필요 → currentStep: $stepToSave');
} else {
  await storage.write(key: 'onboardingStep', value: 'COMPLETED');
  debugPrint('[LoginProvider] ✅ 온보딩 완료 → COMPLETED 저장');
}
```

### 수정 대상 파일
1. [login_provider.dart:177](../lib/features/auth/providers/login_provider.dart#L177)

### 작업 순서
```
1. login_provider.dart 수정 (30min)
   - isEmpty 체크 추가
   - 기본값 'TERMS' 설정
   - 테스트: Mock API에서 onboardingStep: "" 반환 → 기본값 사용 확인
```

---

# Sprint 3: Refactoring & Optimization

## 🔧 Issue #11: OnboardingStep String → Enum 변환

### **우선순위**: 🟢 MEDIUM
### **예상 시간**: 2시간
### **영향도**: 타입 안정성 향상, 오타 방지

### 문제점
```dart
// ❌ 현재: String 기반 (오타 위험)
if (currentStep == 'TERMS') { ... }
if (currentStep == 'COMPLETED') { ... }  // "COMPLETE"로 오타 가능
```

### 해결 방법
**Step 1: Enum 정의**

```dart
// lib/features/onboarding/models/onboarding_step.dart - 새 파일
enum OnboardingStep {
  terms('TERMS'),
  name('NAME'),
  birthDate('BIRTH_DATE'),
  gender('GENDER'),
  interests('INTERESTS'),
  completed('COMPLETED');

  final String value;
  const OnboardingStep(this.value);

  // ✅ String → Enum 변환
  static OnboardingStep fromString(String value) {
    return OnboardingStep.values.firstWhere(
      (step) => step.value == value,
      orElse: () => OnboardingStep.terms,  // 기본값
    );
  }

  // ✅ Enum → String 변환
  @override
  String toString() => value;
}
```

**Step 2: OnboardingState 모델 변경**

```dart
// onboarding_state.dart
@freezed
class OnboardingState with _$OnboardingState {
  const factory OnboardingState({
    required OnboardingStep currentStep,  // ✅ String → Enum
    required String onboardingStatus,
    required MemberDto member,
  }) = _OnboardingState;

  factory OnboardingState.fromJson(Map<String, dynamic> json) {
    return OnboardingState(
      currentStep: OnboardingStep.fromString(json['currentStep'] as String),
      onboardingStatus: json['onboardingStatus'] as String,
      member: MemberDto.fromJson(json['member']),
    );
  }
}
```

**Step 3: 모든 사용처 업데이트**

```dart
// onboarding_screen.dart
int _getPageIndex(OnboardingStep step) {
  return switch (step) {
    OnboardingStep.terms => 0,
    OnboardingStep.name => 1,
    OnboardingStep.birthDate => 2,
    OnboardingStep.gender => 3,
    OnboardingStep.interests => 4,
    OnboardingStep.completed => 5,
  };
}
```

### 수정 대상 파일
1. **새 파일**: `lib/features/onboarding/models/onboarding_step.dart`
2. [onboarding_state.dart](../lib/features/onboarding/data/models/onboarding_response.dart)
3. [onboarding_screen.dart](../lib/features/onboarding/presentation/screens/onboarding_screen.dart)
4. [onboarding_notifier.dart](../lib/features/onboarding/providers/onboarding_notifier.dart)
5. [user_provider.dart](../lib/features/auth/providers/user_provider.dart)
6. [login_provider.dart](../lib/features/auth/providers/login_provider.dart)
7. [splash_screen.dart](../lib/features/splash/presentation/screens/splash_screen.dart)

### 작업 순서
```
1. onboarding_step.dart 생성 (30min)
   - Enum 정의
   - fromString(), toString() 구현
   - 테스트: 모든 케이스 변환 확인

2. onboarding_state.dart 수정 (30min)
   - currentStep 타입 변경
   - fromJson() 업데이트
   - dart run build_runner build

3. 모든 사용처 업데이트 (1시간)
   - String 비교를 Enum 비교로 변경
   - switch 문 활용
   - 컴파일 에러 수정
   - 테스트: 전체 온보딩 플로우 동작 확인
```

---

## 🔧 Issue #12-14: 코드 품질 개선

### **우선순위**: 🟢 MEDIUM
### **예상 시간**: 1시간 (모두 합산)

### Issue #12: Overlay 위치 개선 (interests_page.dart)
```dart
// ❌ 현재: 하드코딩된 위치
Positioned(
  top: boxOffset.dy + boxSize.height + 8,
  left: boxOffset.dx,
)

// ✅ 개선: 화면 경계 체크
Positioned _getOverlayPosition(Offset boxOffset, Size boxSize, Size screenSize) {
  double top = boxOffset.dy + boxSize.height + 8;
  double left = boxOffset.dx;

  // 화면 하단 넘어가면 위로 표시
  if (top + 200 > screenSize.height) {
    top = boxOffset.dy - 200 - 8;
  }

  // 화면 오른쪽 넘어가면 왼쪽으로 정렬
  if (left + 280 > screenSize.width) {
    left = screenSize.width - 280 - 16;
  }

  return Positioned(top: top, left: left);
}
```

**수정 파일**: [interests_page.dart](../lib/features/onboarding/presentation/pages/interests_page.dart)
**예상 시간**: 30min

---

### Issue #13: 로딩 상태 추가 (각 페이지)
```dart
// 각 페이지에 _isLoading 상태 추가 (Issue #5-6에서 이미 작업 예정)
// 별도 작업 불필요 → Sprint 2에서 처리됨
```

---

### Issue #14: 에러 로깅 개선
```dart
// ✅ 구조화된 로깅
debugPrint('[OnboardingNotifier] ❌ API Error: ${e.response?.statusCode}');
debugPrint('  📍 Endpoint: /api/onboarding/terms');
debugPrint('  📦 Request: $requestData');
debugPrint('  📩 Response: ${e.response?.data}');
```

**수정 파일**: [onboarding_notifier.dart](../lib/features/onboarding/providers/onboarding_notifier.dart)
**예상 시간**: 30min (Sprint 2 Issue #5에서 함께 작업)

---

## 🔧 Issue #15-18: 낮은 우선순위 개선

### **우선순위**: 🟢 LOW
### **예상 시간**: 1시간 (모두 합산)

### Issue #15: 하드코딩된 문자열 다국어화
```dart
// ❌ 현재
Text('필수 약관에 동의해주세요.')

// ✅ 개선
Text(AppLocalizations.of(context).onboardingTermsRequired)
```

**영향도**: 다국어 지원 필요 시 일괄 작업 (현재 우선순위 낮음)
**예상 시간**: 1시간

---

### Issue #16-18: 코드 중복 제거
- `_showErrorSnackBar()` → 공용 유틸 함수로 추출
- 페이지 간 공통 로직 → 믹스인 또는 베이스 클래스
- 예상 시간: 추후 리팩토링 단계에서 진행

---

# 📋 전체 작업 체크리스트

## Sprint 1: Critical (5.5시간)
- [ ] **Issue #1**: initState ref.read() 수정 (2시간)
  - [ ] terms_page.dart
  - [ ] nickname_page.dart
  - [ ] birthdate_page.dart
  - [ ] gender_page.dart
  - [ ] interests_page.dart
- [ ] **Issue #2**: Access Token 경쟁 조건 해결 (3시간)
  - [ ] user_provider.dart - 메모리 캐시 추가
  - [ ] onboarding_notifier.dart - 캐시 우선 사용
  - [ ] login_provider.dart - 검증 로그
- [ ] **Issue #3**: onboardingStep null 처리 (30min)
  - [ ] onboarding_screen.dart

## Sprint 2: High Priority (5.5시간)
- [ ] **Issue #4**: 온보딩 초기화 에러 처리 (1시간)
  - [ ] onboarding_exception.dart 생성
  - [ ] onboarding_notifier.dart - 에러 처리
  - [ ] onboarding_screen.dart - 에러 UI
- [ ] **Issue #5-6**: API 실패 피드백 (1.5시간)
  - [ ] onboarding_notifier.dart - 반환 타입 변경
  - [ ] 모든 페이지 - SnackBar 추가
- [ ] **Issue #7**: BirthDate 유효성 검사 최적화 (30min)
  - [ ] birthdate_page.dart - Debounce
- [ ] **Issue #8**: Storage 중복 읽기 제거 (1시간)
  - [ ] user_provider.dart - onboardingStep 캐시
  - [ ] splash_screen.dart, onboarding_screen.dart
- [ ] **Issue #9**: Storage 쓰기 타이밍 (1시간)
  - [ ] onboarding_notifier.dart - 모든 메서드
- [ ] **Issue #10**: login_provider null 처리 (30min)
  - [ ] login_provider.dart

## Sprint 3: Refactoring (4시간)
- [ ] **Issue #11**: OnboardingStep Enum (2시간)
  - [ ] onboarding_step.dart 생성
  - [ ] 모든 사용처 업데이트
- [ ] **Issue #12**: Overlay 위치 개선 (30min)
  - [ ] interests_page.dart
- [ ] **Issue #14**: 에러 로깅 개선 (30min)
  - [ ] onboarding_notifier.dart
- [ ] **Issue #15**: 다국어화 (1시간)
  - [ ] 추후 작업

---

# 🎯 예상 효과

## 안정성
- ✅ Riverpod 규칙 준수 → 상태 동기화 문제 해결
- ✅ 경쟁 조건 제거 → API 호출 실패율 감소
- ✅ Null Safety 강화 → 런타임 크래시 방지

## 사용자 경험
- ✅ 명확한 에러 메시지 → 사용자가 문제 해결 가능
- ✅ 로딩 상태 표시 → 진행 중임을 명확히 인지
- ✅ 입력 성능 개선 → 부드러운 타이핑 경험

## 유지보수성
- ✅ Enum 타입 사용 → 오타 방지, IDE 자동완성
- ✅ 구조화된 에러 처리 → 디버깅 시간 단축
- ✅ 메모리 캐싱 → Storage 접근 최소화

---

# 📝 테스트 계획

## Sprint 1 테스트
```
1. initState 수정 후:
   - 각 페이지 진입 → PageController 정상 동작 확인
   - 빠른 페이지 전환 → 상태 동기화 확인

2. 경쟁 조건 수정 후:
   - 로그인 → 온보딩 즉시 진입 → API 호출 성공 확인
   - iOS 실제 기기에서 반복 테스트 (10회)

3. Null 처리 후:
   - Storage에 값 없을 때 → 기본값 사용 확인
```

## Sprint 2 테스트
```
1. 에러 처리 후:
   - 네트워크 끊고 각 단계 진행 → 에러 메시지 표시 확인
   - 401 에러 → 로그인 화면 이동 확인

2. Storage 최적화 후:
   - 앱 시작부터 온보딩 완료까지 Storage 읽기 횟수 측정
   - 목표: 3회 이하 (기존 6회 이상)
```

## Sprint 3 테스트
```
1. Enum 변환 후:
   - 전체 온보딩 플로우 동작 확인
   - 컴파일 에러 없음 확인

2. 멀티 디바이스 시나리오:
   - Device A: 온보딩 중간까지 진행 → 앱 종료
   - Device B: 동일 계정 로그인 → 올바른 단계로 복원 확인
```

---

# 🚀 시작 방법

```bash
# Sprint 1 시작
git checkout -b feature/onboarding-critical-fixes

# Issue #1: initState 수정
# ... 작업 ...

git add .
git commit -m "fix: initState ref.read() 수정 (5개 페이지) #1"

# Issue #2: 경쟁 조건 해결
# ... 작업 ...

git commit -m "fix: Access Token 경쟁 조건 해결 (메모리 캐싱) #2"

# Sprint 1 완료 후 PR 생성
gh pr create --title "🚨 [Critical] 온보딩 플로우 안정성 개선" --body "Sprint 1 완료"
```

---

**다음 단계**: `/sc:task Sprint 1 시작` 명령으로 실제 구현 시작
