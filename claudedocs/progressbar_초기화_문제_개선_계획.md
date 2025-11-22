# 프로그레스 바 초기화 문제 개선 계획

## 📊 현재 문제 상황

**증상**: 라우팅은 정상 작동하지만 프로그레스 바가 항상 1번째 세그먼트로 초기화됨

**사용자 보고**: "라우팅은 잘되는데 progressappbar 가 1로 초기화 되는 문제 발생"

---

## 🔍 원인 분석

### 1. PageController 초기화 타이밍 문제

**파일**: [onboarding_screen.dart:104-128](../lib/features/onboarding/presentation/screens/onboarding_screen.dart#L104)

```dart
Future<void> _initializeOnboarding() async {
  try {
    // SecureStorage에서 onboardingStep 읽기
    final currentStep = await _secureStorage.read(key: 'onboardingStep');

    // currentStep을 페이지 인덱스로 매핑
    final initialPage = _mapStepToPageIndex(currentStep);

    debugPrint('[OnboardingScreen] 🔄 초기화: currentStep=$currentStep → initialPage=$initialPage');

    // ✅ PageController 초기화 (initialPage 설정 정상)
    _pageController = PageController(initialPage: initialPage);

    // ✅ _currentPage 변수 초기화 (initialPage 설정 정상)
    _currentPage = initialPage;

    setState(() => _isInitialized = true);
  } catch (e) {
    // 오류 발생 시 기본값(0)으로 시작
    _pageController = PageController(initialPage: 0);
    setState(() => _isInitialized = true);
  }
}
```

**정상 동작**:
- `_pageController`는 올바른 `initialPage`로 초기화됨
- `_currentPage` 상태 변수도 올바른 값으로 설정됨

### 2. OnboardingPageIndicator의 페이지 감지 로직

**파일**: [onboarding_page_indicator.dart:28-35](../lib/features/onboarding/presentation/widgets/onboarding_page_indicator.dart#L28)

```dart
return AnimatedBuilder(
  animation: controller,
  builder: (context, child) {
    // 현재 페이지 인덱스 (0-4)
    // controller.page가 null일 수 있으므로 0으로 fallback
    final currentPage = controller.hasClients
        ? (controller.page?.round() ?? 0)  // ⚠️ 문제 지점
        : 0;
```

**문제점**:
- `controller.page`는 PageController가 실제로 렌더링된 후에야 정확한 값을 반환
- `PageController(initialPage: 3)` 생성 직후에는 `controller.page`가 `null` 또는 `0.0`일 수 있음
- `AnimatedBuilder`의 첫 번째 빌드 시점에서 `controller.page`가 아직 초기화되지 않음

### 3. 타이밍 문제 시나리오

```
1. OnboardingScreen.initState() 호출
   ↓
2. _initializeOnboarding() 비동기 시작
   ↓
3. _pageController = PageController(initialPage: 3) 생성
   ↓
4. setState(() => _isInitialized = true) 호출
   ↓
5. build() 메서드 실행 → OnboardingPageIndicator 생성
   ↓
6. AnimatedBuilder 첫 빌드
   - controller.page가 아직 null 또는 0.0
   - currentPage = controller.page?.round() ?? 0  ← ❌ 0으로 fallback
   ↓
7. PageView가 실제로 렌더링되어야 controller.page 업데이트
   ↓
8. AnimatedBuilder 재빌드 → 올바른 페이지 표시
```

**결과**: 첫 번째 빌드에서 프로그레스 바가 잠깐 "1번"으로 표시되고, 이후 올바른 위치로 업데이트됨

---

## 🎯 해결 방안

### 방안 1: OnboardingScreen에서 _currentPage 전달 (권장)

**장점**:
- 간단하고 직접적인 해결책
- `_currentPage` 상태 변수를 직접 사용하므로 항상 정확한 값 보장
- 추가 로직 없이 즉시 올바른 프로그레스 표시

**구현**:

```dart
// onboarding_screen.dart 수정
OnboardingPageIndicator(
  controller: _pageController,
  count: 5,
  currentPage: _currentPage,  // ✅ 현재 페이지 직접 전달
)

// onboarding_page_indicator.dart 수정
class OnboardingPageIndicator extends StatelessWidget {
  final PageController controller;
  final int count;
  final int currentPage;  // ✅ 외부에서 받은 currentPage 사용

  const OnboardingPageIndicator({
    super.key,
    required this.controller,
    required this.count,
    required this.currentPage,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(count, (index) {
        // ✅ 외부에서 받은 currentPage 직접 사용 (controller.page 무시)
        final isCompleted = index <= currentPage;

        return Expanded(
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            height: 4.h,
            margin: EdgeInsets.symmetric(horizontal: 2.w),
            decoration: BoxDecoration(
              color: isCompleted
                  ? AppColors.mainColor
                  : AppColors.subColor2.withValues(alpha: 0.9),
              borderRadius: BorderRadius.circular(2.r),
            ),
          ),
        );
      }),
    );
  }
}
```

**변경 사항**:
1. `OnboardingPageIndicator`에 `currentPage` 파라미터 추가
2. `AnimatedBuilder` 제거 (더 이상 controller.page를 watch할 필요 없음)
3. `OnboardingScreen`에서 `_currentPage` 상태 변수 전달
4. `onPageChanged` 콜백에서 `setState(() => _currentPage = index)` 호출 시 자동으로 프로그레스 바 업데이트

---

### 방안 2: WidgetsBinding.addPostFrameCallback 사용 (복잡)

**장점**: PageController의 자동 감지 유지

**단점**: 복잡하고 불필요한 오버헤드

**구현**:

```dart
class OnboardingPageIndicator extends StatefulWidget {
  final PageController controller;
  final int count;

  @override
  State<OnboardingPageIndicator> createState() => _OnboardingPageIndicatorState();
}

class _OnboardingPageIndicatorState extends State<OnboardingPageIndicator> {
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();

    // 첫 프레임 이후 PageController의 initialPage 읽기
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.controller.hasClients) {
        setState(() {
          _currentPage = widget.controller.page?.round() ?? 0;
        });
      }
    });

    widget.controller.addListener(_onPageChanged);
  }

  void _onPageChanged() {
    if (widget.controller.hasClients) {
      final newPage = widget.controller.page?.round() ?? 0;
      if (newPage != _currentPage) {
        setState(() => _currentPage = newPage);
      }
    }
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onPageChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(widget.count, (index) {
        final isCompleted = index <= _currentPage;

        return Expanded(
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            height: 4.h,
            margin: EdgeInsets.symmetric(horizontal: 2.w),
            decoration: BoxDecoration(
              color: isCompleted
                  ? AppColors.mainColor
                  : AppColors.subColor2.withValues(alpha: 0.9),
              borderRadius: BorderRadius.circular(2.r),
            ),
          ),
        );
      }),
    );
  }
}
```

**문제점**: StatefulWidget 변환, 리스너 관리, 복잡도 증가

---

### 방안 3: ValueListenableBuilder 사용 (중간)

**장점**: 반응형 UI 패턴 유지

**단점**: 추가 ValueNotifier 필요

**구현**:

```dart
// onboarding_screen.dart
class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  late final PageController _pageController;
  late final ValueNotifier<int> _currentPageNotifier;

  @override
  void initState() {
    super.initState();
    _currentPageNotifier = ValueNotifier<int>(0);
    _initializeOnboarding();
  }

  Future<void> _initializeOnboarding() async {
    final currentStep = await _secureStorage.read(key: 'onboardingStep');
    final initialPage = _mapStepToPageIndex(currentStep);

    _pageController = PageController(initialPage: initialPage);
    _currentPageNotifier.value = initialPage;  // ✅ 초기값 설정

    setState(() => _isInitialized = true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          ValueListenableBuilder<int>(
            valueListenable: _currentPageNotifier,
            builder: (context, currentPage, child) {
              return OnboardingPageIndicator(
                count: 5,
                currentPage: currentPage,  // ✅ ValueNotifier 값 전달
              );
            },
          ),
          Expanded(
            child: PageView(
              controller: _pageController,
              onPageChanged: (index) {
                _currentPageNotifier.value = index;  // ✅ 값 업데이트
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _currentPageNotifier.dispose();
    _pageController.dispose();
    super.dispose();
  }
}
```

---

## 📋 권장 구현: 방안 1

**이유**:
1. **단순성**: 가장 간단하고 직관적인 해결책
2. **성능**: AnimatedBuilder 제거로 불필요한 재빌드 감소
3. **신뢰성**: 상태 변수 직접 사용으로 항상 정확한 값 보장
4. **유지보수**: 코드 복잡도 최소화, 이해하기 쉬움

**구현 단계**:

1. ✅ **onboarding_page_indicator.dart 수정**:
   - `currentPage` 파라미터 추가
   - `AnimatedBuilder` 제거
   - `controller.page` 대신 `currentPage` 사용

2. ✅ **onboarding_screen.dart 수정**:
   - `OnboardingPageIndicator` 호출 시 `currentPage: _currentPage` 전달

**예상 작업 시간**: 10분

---

## 🧪 테스트 시나리오

### 테스트 1: 초기 로딩
```
1. 로그인 후 onboardingStep = 'GENDER' (페이지 3)
2. OnboardingScreen 진입
3. 확인: 프로그레스 바가 즉시 3/5로 표시되는지 확인
```

### 테스트 2: 페이지 전환
```
1. 현재 페이지 3에서 "계속하기" 버튼 클릭
2. 페이지 4로 이동
3. 확인: 프로그레스 바가 부드럽게 4/5로 애니메이션되는지 확인
```

### 테스트 3: API 응답 후 페이지 이동
```
1. 페이지 3에서 API 호출
2. API 응답: currentStep = 'INTERESTS' (페이지 4)
3. _goToStepPage(currentStep) 호출
4. 확인: 프로그레스 바가 즉시 4/5로 업데이트되는지 확인
```

---

## 📝 추가 개선 사항 (선택)

### 1. 디버그 로그 추가
```dart
OnboardingPageIndicator(
  count: 5,
  currentPage: _currentPage,
)

// 로그 추가
debugPrint('[OnboardingScreen] 📊 Progress Bar: currentPage=$_currentPage');
```

### 2. 애니메이션 듀레이션 조정
```dart
// 현재: 300ms
duration: const Duration(milliseconds: 300),

// 더 빠르게: 200ms (선택 사항)
duration: const Duration(milliseconds: 200),
```

---

## ✅ 결론

**권장 방안**: 방안 1 (currentPage 파라미터 전달)

**이유**:
- 가장 간단하고 효과적
- 성능 개선 (불필요한 AnimatedBuilder 제거)
- 즉시 올바른 프로그레스 표시 보장
- 코드 유지보수성 향상

**다음 단계**: 방안 1 구현 진행 여부 확인 후 즉시 적용 가능
