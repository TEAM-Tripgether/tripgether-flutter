import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../core/router/routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/widgets/common/app_snackbar.dart';
import '../../providers/login_provider.dart';
// import '../widgets/login_form.dart'; // 주석 처리: 이메일 로그인 임시 비활성화
import '../widgets/social_login_section.dart';

/// 로그인 화면
///
/// 앱 로고와 소셜 로그인 버튼들을 포함하는 메인 로그인 화면입니다.
///
/// **디자인 변경 (2025-11-01)**:
/// - 배경: 화이트 배경 (이전: 보라색 그라데이션)
/// - 레이아웃: 중앙 정렬 (로고 + 소셜 로그인)
/// - 이메일 로그인 폼: 임시 비활성화 (향후 재도입 가능)
///
/// **현재 구성**:
/// - 상단: app_logo_black (Tripgether + 태그라인 포함)
/// - 하단: 소셜 로그인 버튼들 (구글, 이메일 가입)
class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  /// 구글 로그인 로딩 상태
  bool _isGoogleLoading = false;

  /// ============================================================
  /// 📝 이메일 로그인 관련 메서드 - 임시 비활성화
  /// 향후 이메일 로그인 재도입 시 주석 해제하여 사용
  /// ============================================================
  /*
  /// 이메일/비밀번호 로그인 핸들러
  Future<void> _handleEmailLogin(
    BuildContext context,
    WidgetRef ref,
    String email,
    String password,
  ) async {
    debugPrint('[LoginScreen] 📝 이메일 로그인 버튼 클릭');
    debugPrint('[LoginScreen] 📧 Email: $email');

    // LoginProvider를 통한 로그인 API 호출
    final success = await ref
        .read(loginNotifierProvider.notifier)
        .loginWithEmail(email: email, password: password);

    debugPrint('[LoginScreen] 로그인 결과: ${success ? "성공 ✅" : "실패 ❌"}');

    // 로그인 성공 시 홈으로 이동
    if (success && context.mounted) {
      debugPrint('[LoginScreen] 🏠 홈 화면으로 이동 중... (${AppRoutes.home})');
      context.go(AppRoutes.home);
      debugPrint('[LoginScreen] ✅ 화면 전환 완료');
    } else if (context.mounted) {
      // 로그인 실패 시 에러 메시지 표시
      debugPrint('[LoginScreen] ⚠️ 로그인 실패 - 에러 메시지 표시');
      AppSnackBar.showError(
        context,
        AppLocalizations.of(context).loginFailedTryAgain,
      );
    }
  }
  */

  /// 구글 로그인 핸들러
  Future<void> _handleGoogleLogin(BuildContext context) async {
    debugPrint('[LoginScreen] 🔘 구글 로그인 버튼 클릭');

    // 로딩 시작
    setState(() => _isGoogleLoading = true);

    try {
      // LoginProvider를 통한 구글 로그인
      final (success, requiresOnboarding) = await ref
          .read(loginNotifierProvider.notifier)
          .loginWithGoogle();

      debugPrint('[LoginScreen] 구글 로그인 결과: ${success ? "성공 ✅" : "실패 ❌"}');
      debugPrint('[LoginScreen] 온보딩 필요 여부: $requiresOnboarding');

      // 로그인 성공 시 온보딩 또는 홈으로 이동
      if (success && context.mounted) {
        if (requiresOnboarding) {
          // 온보딩 필요: 온보딩 페이지로 이동
          debugPrint(
            '[LoginScreen] 🎯 온보딩 필요 → 온보딩 화면으로 이동 (${AppRoutes.onboarding})',
          );
          context.go(AppRoutes.onboarding);
          debugPrint('[LoginScreen] ✅ 온보딩 화면 전환 완료');
        } else {
          // 온보딩 완료: 홈으로 이동
          debugPrint('[LoginScreen] 🏠 온보딩 완료 → 홈 화면으로 이동 (${AppRoutes.home})');
          context.go(AppRoutes.home);
          debugPrint('[LoginScreen] ✅ 홈 화면 전환 완료');
        }
      } else if (!success && context.mounted) {
        // 사용자가 취소한 경우 - 에러 메시지 표시하지 않음
        debugPrint('[LoginScreen] ℹ️ 사용자가 구글 로그인을 취소함');
      }
    } catch (e) {
      // 에러 발생 시 백엔드에서 받은 구체적인 에러 메시지 표시
      debugPrint('[LoginScreen] ⚠️ 구글 로그인 에러 발생: $e');

      if (context.mounted) {
        // Exception 메시지에서 'Exception: ' 접두사 제거
        final errorMessage = e.toString().replaceFirst('Exception: ', '');

        // 백엔드에서 받은 구체적인 에러 메시지 표시
        // 백엔드가 이미 한국어 메시지를 제공하므로 그대로 사용
        AppSnackBar.showError(
          context,
          errorMessage.isEmpty
              ? AppLocalizations.of(context).googleLoginFailed
              : errorMessage,
        );
      }
    } finally {
      // 로딩 종료
      if (mounted) {
        setState(() => _isGoogleLoading = false);
      }
    }
  }

  /*
  /// 이메일 회원가입 핸들러 (제거됨: 소셜 로그인만 사용)
  void _handleEmailSignup(BuildContext context) {
    // TODO: 회원가입 화면으로 이동
    debugPrint('[Login] 이메일 회원가입 이동');

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(AppLocalizations.of(context).signupScreenPreparation),
      ),
    );
  }
  */

  /*
  /// 비밀번호 찾기 핸들러
  void _handleFindPassword(BuildContext context) {
    // TODO: 비밀번호 찾기 화면으로 이동
    debugPrint('[Login] 비밀번호 찾기 이동');
  }
  */
  /// ============================================================

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      /// 화이트 배경 (디자인 변경: 그라데이션 → 단색)
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: AppSpacing.xxxl),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              /// 상단 여백 (로고를 아래로 내리기 위한 유연한 공간)
              AppSpacing.verticalSpace80,

              /// 앱 로고 이미지
              Image.asset(
                'assets/app_logo_black.png',
                width: 240.w,
                height: 240.h,
                fit: BoxFit.contain,
              ),

              /// 로고와 소셜 로그인 사이의 넓은 간격
              AppSpacing.verticalSpace80,

              /// ============================================================
              /// 📝 LOGIN FORM (이메일/비밀번호 로그인) - 임시 비활성화
              /// 향후 이메일 로그인 재도입 시 주석 해제하여 사용
              /// ============================================================
              /*
              LoginForm(
                onLogin: (email, password) {
                  _handleEmailLogin(context, ref, email, password);
                },
                onFindPassword: () => _handleFindPassword(context),
              ),

              AppSpacing.verticalSpaceHuge,
              */
              /// ============================================================

              /// SNS 계정 로그인 구분선
              Padding(
                padding: AppSpacing.symmetric(horizontal: 60), // divider 길이 축소
                child: Row(
                  children: [
                    Expanded(
                      child: Divider(
                        color: AppColors.subColor2,
                        thickness: AppSizes.dividerThin,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: AppSpacing.md),
                      child: Text(
                        l10n.snsLoginDivider,
                        style: AppTextStyles.metaMedium12.copyWith(
                          color: AppColors.subColor2,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Divider(
                        color: AppColors.subColor2,
                        thickness: AppSizes.dividerThin,
                      ),
                    ),
                  ],
                ),
              ),

              AppSpacing.verticalSpace60,

              /// 소셜 로그인 섹션 + 빠른 회원가입 SVG 배지 (Stack)
              /// Stack을 사용해 배지를 구글 로그인 버튼 위쪽에 오버레이
              Stack(
                clipBehavior: Clip.none, // overflow 허용 (배지가 버튼 밖으로 나올 수 있음)
                children: [
                  // 베이스 레이어: 소셜 로그인 버튼들
                  SocialLoginSection(
                    onGoogleLogin: () => _handleGoogleLogin(context),
                    isGoogleLoading: _isGoogleLoading,
                  ),

                  // 오버레이 레이어: 빠른 회원가입 SVG 배지 (언어별 분기)
                  Positioned(
                    top: -56.h, // 구글 버튼 위쪽에 배치 (자유롭게 조정 가능)
                    left: 0,
                    right: 0,
                    child: Center(
                      child: SvgPicture.asset(
                        // TODO: 영어 SVG 추가 시 언어별 분기 처리
                        // l10n.localeName == 'ko'
                        //     ? 'assets/icons/quicksignup_kr.svg'
                        //     : 'assets/icons/quicksignup_en.svg',
                        'assets/icons/quicksignup_kr.svg',
                        width: 180.w, // 적절한 크기 (필요 시 조정)
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ],
              ),

              /// 하단 여백
              AppSpacing.verticalSpace60,
            ],
          ),
        ),
      ),
    );
  }
}
