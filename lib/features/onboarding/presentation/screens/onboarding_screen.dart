import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_colors.dart';
import '../pages/nickname_page.dart';
import '../pages/birthdate_page.dart';
import '../pages/gender_page.dart';
import '../pages/interests_page.dart';
import '../pages/welcome_page.dart';
import '../widgets/onboarding_page_indicator.dart';

/// 온보딩 메인 화면
///
/// 5개의 페이지를 PageView로 관리하며, 단계별로 사용자 정보를 입력받습니다.
/// - 페이지 1: 닉네임 설정
/// - 페이지 2: 생년월일 입력
/// - 페이지 3: 성별 선택
/// - 페이지 4: 관심사 선택
/// - 페이지 5: 완료 화면
///
/// **스와이프 제한**:
/// - 모든 스와이프 제스처 차단 (NeverScrollableScrollPhysics)
/// - "계속하기" 버튼을 통해서만 다음 페이지 진행 가능
/// - 이전 페이지 이동이 필요한 경우 별도 뒤로가기 버튼 추가 가능
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  /// 페이지 컨트롤러
  late final PageController _pageController;

  /// 현재 페이지 인덱스 (0-4)
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  /// 다음 페이지로 이동
  void _goToNextPage() {
    if (_currentPage < 4) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      // 시스템 뒤로가기 제어 (Android 물리 버튼, iOS 제스처)
      canPop: false, // 시스템 pop을 직접 제어
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return; // 이미 pop되었으면 무시

        if (_currentPage > 0) {
          // 이후 페이지: 이전 온보딩 페이지로 이동
          _pageController.previousPage(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        }
        // 첫 페이지(_currentPage == 0)에서는 아무 동작도 하지 않음 (차단)
      },
      child: Scaffold(
        backgroundColor: AppColors.surface,
        // AppBar: Welcome 페이지(마지막 페이지)에서는 숨김
        appBar: _currentPage == 4
            ? null // Welcome 페이지에서는 AppBar 없음
            : PreferredSize(
                preferredSize: Size.fromHeight(60.h),
                child: AppBar(
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  // 왼쪽: 뒤로가기 버튼 (첫 페이지에서는 숨김)
                  // 첫 페이지에서 뒤로가기 시 Navigator.pop()이 호출되면
                  // GoRouter 스택이 비어서 에러 발생 (context.go()로 진입했기 때문)
                  leading: _currentPage > 0
                      ? IconButton(
                          icon: const Icon(Icons.arrow_back_ios),
                          onPressed: () {
                            _pageController.previousPage(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                            );
                          },
                          iconSize: 24.w,
                          color: AppColors.textColor1,
                          padding: EdgeInsets.zero,
                        )
                      : null, // 첫 페이지에서는 뒤로가기 버튼 없음
                  // 중앙: 페이지 인디케이터 (너비 제한)
                  title: SizedBox(
                    width: 200.w, // Progress Bar 최대 너비 제한
                    child: OnboardingPageIndicator(
                      controller: _pageController,
                      count: 5,
                    ),
                  ),
                  centerTitle: true,
                ),
              ),
        // PageView: SafeArea 제거 (AppBar가 자동으로 Safe Area 처리)
        body: PageView(
          controller: _pageController,
          // 모든 스와이프 제스처 차단 - 버튼으로만 페이지 이동
          physics: const NeverScrollableScrollPhysics(),
          onPageChanged: (index) {
            setState(() => _currentPage = index);
          },
          children: [
            // 페이지 1: 닉네임 설정
            NicknamePage(
              onNext: _goToNextPage,
              pageController: _pageController,
            ),

            // 페이지 2: 생년월일 입력
            BirthdatePage(
              onNext: _goToNextPage,
              pageController: _pageController,
            ),

            // 페이지 3: 성별 선택
            GenderPage(onNext: _goToNextPage, pageController: _pageController),

            // 페이지 4: 관심사 선택
            InterestsPage(
              onNext: _goToNextPage,
              pageController: _pageController,
            ),

            // 페이지 5: 완료 화면
            const WelcomePage(),
          ],
        ),
      ),
    );
  }
}
