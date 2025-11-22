# 📋 온보딩 시스템 리팩토링 계획

## 🔴 문제점 분석

### 1. 에러 처리 문제
- **하드코딩된 에러 메시지**: 각 페이지마다 고정된 메시지 사용
- **백엔드 메시지 무시**: API에서 전달하는 실제 에러 메시지를 활용하지 않음
- **중복된 SnackBar 코드**: 모든 페이지에 동일한 패턴 반복
- **AppSnackBar 미사용**: 이미 구현된 공용 컴포넌트를 사용하지 않음

### 2. API 구조 문제
- **이중 계층**: `onboarding_api_service.dart` → `onboarding_notifier.dart` → 페이지
- **에러 전파 실패**: Notifier에서 `return null`로 에러 정보 소실
- **불필요한 래핑**: Notifier가 단순히 API 서비스를 래핑만 함

### 3. 코드 중복
- 5개 페이지(terms, nickname, birthdate, gender, interests)에서 동일한 패턴 반복
- 각 페이지마다 200줄 이상의 중복 코드

## 🛠️ 리팩토링 단계

### ✅ Phase 1: 즉시 수정 (Critical)

#### 1.1 Notifier 에러 전파 수정
```dart
// onboarding_notifier.dart - 모든 메서드 수정
Future<OnboardingResponse?> updateName({required String name}) async {
  try {
    // ... API 호출 ...
  } catch (e, stack) {
    debugPrint('[OnboardingNotifier] ❌ 이름 설정 실패: $e');
    state = AsyncValue.error(e, stack);
    rethrow;  // ✅ 에러를 상위로 전파
  }
}
```

#### 1.2 페이지 에러 처리 개선
```dart
// 각 페이지에서 AppSnackBar 사용
try {
  final response = await ref
      .read(onboardingNotifierProvider.notifier)
      .updateName(name: _controller.text);

  if (response != null) {
    widget.onStepChange(response.currentStep);
  }
} catch (e) {
  if (mounted) {
    // 백엔드 메시지 추출 및 표시
    final message = e.toString().replaceAll('Exception: ', '');
    AppSnackBar.showError(context, message);
  }
}
```

### 📝 Phase 2: 구조 개선 (Medium Priority)

#### 2.1 공통 Base Page 생성
```dart
// lib/features/onboarding/presentation/base/onboarding_base_page.dart
abstract class OnboardingBasePage extends ConsumerStatefulWidget {
  final VoidCallback onNext;
  final void Function(String currentStep) onStepChange;
  final PageController pageController;

  // 공통 API 호출 처리
  Future<void> handleApiCall({
    required Future<OnboardingResponse?> Function() apiCall,
    required BuildContext context,
    required String defaultErrorMessage,
  }) async {
    try {
      final response = await apiCall();
      if (response != null) {
        onStepChange(response.currentStep);
      }
    } catch (e) {
      if (context.mounted) {
        final message = _extractErrorMessage(e, defaultErrorMessage);
        AppSnackBar.showError(context, message);
      }
    }
  }

  String _extractErrorMessage(dynamic error, String fallback) {
    if (error == null) return fallback;
    final message = error.toString();
    if (message.startsWith('Exception: ')) {
      return message.substring(11);
    }
    return message;
  }
}
```

### 🔄 Phase 3: 전체 리팩토링 (Low Priority)

#### 3.1 Provider 구조 단순화
- API 서비스와 Notifier 역할 명확히 분리
- 불필요한 중간 계층 제거 검토

#### 3.2 상태 관리 통합
- 로컬 상태와 서버 상태 일원화
- 로딩 상태 중앙 관리

## 📊 구현 계획

### 즉시 수정할 파일들

1. **onboarding_notifier.dart**
   - [ ] 모든 catch 블록에서 `return null` → `rethrow`로 변경
   - [ ] agreeTerms, updateName, updateBirthDate, updateGender, updateInterests

2. **nickname_page.dart**
   - [ ] AppSnackBar import 추가
   - [ ] 에러 처리 부분에서 AppSnackBar.showError 사용
   - [ ] 백엔드 메시지 추출 로직 추가

3. **birthdate_page.dart**
   - [ ] AppSnackBar import 추가
   - [ ] 에러 처리 부분에서 AppSnackBar.showError 사용
   - [ ] 백엔드 메시지 추출 로직 추가

4. **gender_page.dart**
   - [ ] AppSnackBar import 추가
   - [ ] 에러 처리 부분에서 AppSnackBar.showError 사용
   - [ ] 백엔드 메시지 추출 로직 추가

5. **interests_page.dart**
   - [ ] AppSnackBar import 추가
   - [ ] 에러 처리 부분에서 AppSnackBar.showError 사용
   - [ ] 백엔드 메시지 추출 로직 추가

## 💡 기대 효과

### 코드 개선
- **중복 제거**: ~200줄 감소
- **일관성**: 모든 페이지에서 동일한 에러 처리
- **유지보수성**: 한 곳에서 에러 처리 로직 관리

### 사용자 경험
- **정확한 에러 메시지**: 백엔드에서 전달하는 실제 메시지 표시
- **일관된 UI**: AppSnackBar를 통한 통일된 메시지 디자인

### 개발 효율성
- **디버깅 용이**: 실제 에러 내용 확인 가능
- **빠른 수정**: 공통 컴포넌트 활용으로 수정 시간 단축

## 🚀 실행 순서

1. **Step 1**: onboarding_notifier.dart의 에러 전파 수정 (5분)
2. **Step 2**: 각 페이지의 에러 처리를 AppSnackBar로 변경 (각 5분 × 5페이지 = 25분)
3. **Step 3**: 테스트 및 검증 (10분)

**예상 소요 시간**: 약 40분