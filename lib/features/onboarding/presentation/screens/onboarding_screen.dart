import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../pages/terms_page.dart';
import '../pages/nickname_page.dart';
import '../pages/birthdate_page.dart';
import '../pages/gender_page.dart';
import '../pages/interests_page.dart';
import '../pages/welcome_page.dart';
import '../widgets/onboarding_page_indicator.dart';

/// 온보딩 메인 화면
///
/// 6개의 페이지를 PageView로 관리하며, 단계별로 사용자 정보를 입력받습니다.
/// - 페이지 0: 약관 동의 (TERMS)
/// - 페이지 1: 이름 입력 (NAME)
/// - 페이지 2: 생년월일 입력 (BIRTH_DATE)
/// - 페이지 3: 성별 선택 (GENDER)
/// - 페이지 4: 관심사 선택 (INTERESTS)
/// - 페이지 5: 완료 화면 (COMPLETED)
///
/// **⚠️ 뒤로가기 완전 차단**:
/// - AppBar 제거 (뒤로가기 버튼 아이콘 없음)
/// - 시스템 뒤로가기 차단 (Android 물리 버튼, iOS 제스처)
/// - 스와이프 제스처 차단 (NeverScrollableScrollPhysics)
/// - "계속하기" 버튼을 통해서만 다음 페이지 진행 (순방향만 가능)
class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  /// 페이지 컨트롤러 (비동기 초기화를 위해 nullable)
  PageController? _pageController;

  /// 현재 페이지 인덱스 (0-5)
  int _currentPage = 0;

  /// SecureStorage 인스턴스
  final _secureStorage = const FlutterSecureStorage();

  /// 초기 페이지 로딩 완료 여부
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializeOnboarding();
  }

  /// 온보딩 초기화: currentStep 읽어서 적절한 페이지로 시작
  Future<void> _initializeOnboarding() async {
    try {
      // SecureStorage에서 onboardingStep 읽기
      final currentStep = await _secureStorage.read(key: 'onboardingStep');

      // currentStep을 페이지 인덱스로 매핑
      final initialPage = _mapStepToPageIndex(currentStep);

      debugPrint(
        '[OnboardingScreen] 🔄 초기화: currentStep=$currentStep → initialPage=$initialPage',
      );

      // PageController 초기화
      _pageController = PageController(initialPage: initialPage);
      _currentPage = initialPage;

      // ⚠️ 비동기 작업 완료 후 위젯이 dispose된 경우 처리
      if (!mounted) {
        _pageController?.dispose();
        return;
      }

      setState(() => _isInitialized = true);
    } catch (e) {
      debugPrint('[OnboardingScreen] ❌ 초기화 실패: $e');

      // 오류 발생 시 기본값(0)으로 시작
      _pageController = PageController(initialPage: 0);

      if (!mounted) {
        _pageController?.dispose();
        return;
      }

      setState(() => _isInitialized = true);
    }
  }

  /// currentStep 문자열을 페이지 인덱스로 매핑
  ///
  /// - TERMS → 0
  /// - NAME → 1
  /// - BIRTH_DATE → 2
  /// - GENDER → 3
  /// - INTERESTS → 4
  /// - COMPLETED → 5
  /// - null 또는 기타 → 0 (기본값)
  int _mapStepToPageIndex(String? currentStep) {
    if (currentStep == null) return 0;

    switch (currentStep) {
      case 'TERMS':
        return 0;
      case 'NAME':
        return 1;
      case 'BIRTH_DATE':
        return 2;
      case 'GENDER':
        return 3;
      case 'INTERESTS':
        return 4;
      case 'COMPLETED':
        return 5;
      default:
        debugPrint(
          '[OnboardingScreen] ⚠️ 알 수 없는 currentStep: $currentStep → 기본값(0) 사용',
        );
        return 0;
    }
  }

  @override
  void dispose() {
    _pageController?.dispose();
    super.dispose();
  }

  /// 다음 페이지로 이동 (순차적)
  void _goToNextPage() {
    if (_currentPage < 5) {
      _pageController?.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  /// API 응답의 currentStep에 따라 페이지 이동
  void _goToStepPage(String currentStep) {
    final targetPage = _mapStepToPageIndex(currentStep);

    debugPrint(
      '[OnboardingScreen] 📍 API 응답 currentStep: $currentStep → 페이지 $targetPage로 이동',
    );

    _pageController?.jumpToPage(targetPage);
  }

  @override
  Widget build(BuildContext context) {
    // 초기화 완료 전까지 로딩 화면 표시
    if (!_isInitialized) {
      return const Scaffold(
        backgroundColor: AppColors.surface,
        body: Center(
          child: CircularProgressIndicator(color: AppColors.mainColor),
        ),
      );
    }

    // ✅ 초기화 완료 후에는 _pageController가 non-null임을 보장
    final pageController = _pageController!;

    return PopScope(
      // ⚠️ 시스템 뒤로가기 완전 차단 (Android 물리 버튼, iOS 제스처)
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        // 모든 뒤로가기 동작 차단 (아무 작업도 하지 않음)
        if (didPop) return;
        // 뒤로가기 시도 시 아무 동작도 하지 않음 → 사용자는 뒤로 갈 수 없음
      },
      child: Scaffold(
        backgroundColor: AppColors.surface,
        // ⚠️ AppBar 완전 제거 (뒤로가기 버튼 없음)
        // 프로그레스 바는 body 내부에 직접 배치
        appBar: null,
        body: Column(
          children: [
            // 프로그레스 바 (WelcomePage 제외, 0-4 페이지에만 표시)
            // SafeArea 내부에 배치
            if (_currentPage < 5)
              SafeArea(
                bottom: false,
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppSpacing.xxxl,
                    vertical: AppSpacing.lg,
                  ),
                  child: SizedBox(
                    width: 200.w,
                    child: OnboardingPageIndicator(
                      controller: pageController,
                      count: 5, // 실제 데이터 입력 5단계
                    ),
                  ),
                ),
              ),

            // PageView (나머지 공간)
            Expanded(
              child: PageView(
                controller: pageController,
                // 모든 스와이프 제스처 차단 - 버튼으로만 페이지 이동
                physics: const NeverScrollableScrollPhysics(),
                onPageChanged: (index) {
                  setState(() => _currentPage = index);
                },
                children: [
                  // 페이지 0-4: SafeArea 적용
                  SafeArea(
                    top: false,
                    child: TermsPage(
                      onNext: _goToNextPage,
                      onStepChange: _goToStepPage,
                      pageController: pageController,
                    ),
                  ),
                  SafeArea(
                    top: false,
                    child: NicknamePage(
                      onNext: _goToNextPage,
                      onStepChange: _goToStepPage,
                      pageController: pageController,
                    ),
                  ),
                  SafeArea(
                    top: false,
                    child: BirthdatePage(
                      onNext: _goToNextPage,
                      onStepChange: _goToStepPage,
                      pageController: pageController,
                    ),
                  ),
                  SafeArea(
                    top: false,
                    child: GenderPage(
                      onNext: _goToNextPage,
                      onStepChange: _goToStepPage,
                      pageController: pageController,
                    ),
                  ),
                  SafeArea(
                    top: false,
                    child: InterestsPage(
                      onNext: _goToNextPage,
                      onStepChange: _goToStepPage,
                      pageController: pageController,
                    ),
                  ),

                  // 페이지 5: WelcomePage - SafeArea 제외 (전체 화면 그라데이션)
                  const WelcomePage(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
