import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../core/router/routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
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
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context).loginFailedTryAgain),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    }
  }
  */

  /// 구글 로그인 핸들러
  Future<void> _handleGoogleLogin(BuildContext context) async {
    debugPrint('[LoginScreen] 🔘 구글 로그인 버튼 클릭');

    // 로딩 시작
    setState(() => _isGoogleLoading = true);

    // LoginProvider를 통한 구글 로그인
    final (success, isFirstLogin) = await ref
        .read(loginNotifierProvider.notifier)
        .loginWithGoogle();

    debugPrint('[LoginScreen] 구글 로그인 결과: ${success ? "성공 ✅" : "실패 ❌"}');
    debugPrint('[LoginScreen] 최초 로그인 여부: $isFirstLogin');

    // 로딩 종료
    if (mounted) {
      setState(() => _isGoogleLoading = false);
    }

    // 로그인 성공 시 온보딩 또는 홈으로 이동
    if (success && context.mounted) {
      if (isFirstLogin) {
        // 최초 로그인: 온보딩 페이지로 이동
        debugPrint(
          '[LoginScreen] 🎯 온보딩 페이지로 이동 중... (${AppRoutes.onboarding})',
        );
        context.go(AppRoutes.onboarding);
        debugPrint('[LoginScreen] ✅ 온보딩 화면 전환 완료');
      } else {
        // 기존 사용자: 홈으로 이동
        debugPrint('[LoginScreen] 🏠 홈 화면으로 이동 중... (${AppRoutes.home})');
        context.go(AppRoutes.home);
        debugPrint('[LoginScreen] ✅ 홈 화면 전환 완료');
      }
    } else if (!success && context.mounted) {
      // 로그인 실패 시 에러 메시지 표시
      debugPrint('[LoginScreen] ⚠️ 구글 로그인 실패 - 에러 메시지 표시');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            AppLocalizations.of(context).googleLoginFailed,
            style: AppTextStyles.bodyRegular14.copyWith(
              color: AppColors.white,
            ),
          ),
          backgroundColor: AppColors.error,
          behavior: SnackBarBehavior.floating,
        ),
      );
    } else if (!context.mounted) {
      debugPrint('[LoginScreen] ⚠️ context가 unmounted됨 - 화면 전환 불가');
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

  /// 빠른 회원가입 배지 위젯
  /// SNS 로그인의 빠른 가입을 강조하는 시각적 요소
  Widget _buildQuickSignupBadge() {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.lg, // 16px
        vertical: AppSpacing.sm, // 8px
      ),
      decoration: BoxDecoration(
        color: AppColors.surface, // 흰색 배경
        borderRadius: BorderRadius.circular(AppRadius.circle), // pill 모양
        border: Border.all(
          color: AppColors.gradient3, // #B599FF 밝은 연보라 테두리
          width: AppSizes.borderMedium, // 2px 테두리
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min, // 내용물 크기에 맞춤
        children: [
          // 번개 아이콘 (빠르게를 시각적으로 표현)
          Icon(
            Icons.flash_on,
            color: AppColorPalette.kakaoButton, // 카카오 옐로우 (#FEE500)
            size: AppSizes.iconSmall, // 16px
          ),
          SizedBox(width: AppSpacing.xs), // 4px
          // 텍스트
          Text(
            '10초만에 빠르게 회원가입!',
            style: AppTextStyles.bodyRegular14.copyWith(
              color: AppColors.gradient3, // #B599FF 밝은 연보라 텍스트
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /// 화이트 배경 (디자인 변경: 그라데이션 → 단색)
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: AppSpacing.xxl),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              /// 상단 여백 (로고를 아래로 내리기 위한 유연한 공간)
              AppSpacing.verticalSpace120,

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
                        'SNS 계정으로 로그인/회원가입',
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

              AppSpacing.verticalSpaceMD,

              /// 빠른 회원가입 배지
              /// SNS 로그인의 간편함을 강조
              Center(child: _buildQuickSignupBadge()),

              AppSpacing.verticalSpaceMD,

              /// 소셜 로그인 섹션
              /// 구글, 카카오, 네이버 로그인 버튼 표시
              SocialLoginSection(
                onGoogleLogin: () => _handleGoogleLogin(context),
                isGoogleLoading: _isGoogleLoading,
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
