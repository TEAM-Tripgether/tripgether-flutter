import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../shared/widgets/buttons/social_login_button.dart';
import '../../../../shared/widgets/common/app_snackbar.dart';

/// 소셜 로그인 섹션 위젯
///
/// 구글, 카카오, 네이버 로그인 버튼을 표시하는 위젯입니다.
///
/// **디자인 (2025-11-01)**:
/// - 구글: 밝은 회색 배경 + 어두운 텍스트 + 구글 SVG 로고
/// - 카카오: 카카오 옐로우 배경 + 검정 텍스트 + 카카오 SVG 로고 (준비 중)
/// - 네이버: 네이버 그린 배경 + 흰색 텍스트 + 네이버 SVG 로고 (준비 중)
///
/// **아이콘**: assets/platform_icons/*.svg 사용
/// **버튼 간격**: AppSpacing.lg (16px)
class SocialLoginSection extends StatelessWidget {
  /// 구글 로그인 버튼 탭 콜백
  final VoidCallback onGoogleLogin;

  /// 구글 로그인 로딩 상태
  final bool isGoogleLoading;

  const SocialLoginSection({
    super.key,
    required this.onGoogleLogin,
    this.isGoogleLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Column(
      children: [
        /// 구글 로그인 버튼
        /// 밝은 회색 배경 + 검정 텍스트 + 구글 로고
        SocialLoginButton(
          text: l10n.signInWithGoogle,
          backgroundColor: AppColorPalette.googleButton, // #F1F1F1
          textColor: AppColors.textColor1, // 검정 텍스트 (Medium16)
          onPressed: onGoogleLogin,
          isLoading: isGoogleLoading,
          // 구글 SVG 아이콘 (AppSizes.iconMedium = 20px)
          icon: SvgPicture.asset(
            'assets/platform_icons/google.svg',
            width: AppSizes.iconMedium,
            height: AppSizes.iconMedium,
          ),
        ),

        /// 버튼 간 간격: 16px
        SizedBox(height: AppSpacing.lg),

        /// 카카오 로그인 버튼 (준비 중)
        /// 카카오 옐로우 배경 + 검정 텍스트
        SocialLoginButton(
          text: l10n.signInWithKakao,
          backgroundColor: AppColorPalette.kakaoButton, // #FEE500
          textColor: AppColors.textColor1, // 검정 텍스트 (Medium16)
          onPressed: () => _showComingSoon(context, l10n),
          // 카카오 SVG 아이콘 (AppSizes.iconMedium = 20px)
          icon: SvgPicture.asset(
            'assets/platform_icons/kakao.svg',
            width: AppSizes.iconMedium,
            height: AppSizes.iconMedium,
          ),
        ),

        /// 버튼 간 간격: 16px
        SizedBox(height: AppSpacing.lg),

        /// 네이버 로그인 버튼 (준비 중)
        /// 네이버 그린 배경 + 흰색 텍스트
        SocialLoginButton(
          text: l10n.signInWithNaver,
          backgroundColor: AppColorPalette.naverButton, // #03C75A
          textColor: AppColors.white, // 흰색 텍스트 (Medium16)
          onPressed: () => _showComingSoon(context, l10n),
          // 네이버 SVG 아이콘 (AppSizes.iconMedium = 20px)
          icon: SvgPicture.asset(
            'assets/platform_icons/naver.svg',
            width: AppSizes.iconMedium,
            height: AppSizes.iconMedium,
          ),
        ),
      ],
    );
  }

  /// "준비 중입니다" 스낵바 표시
  ///
  /// 카카오, 네이버 로그인 버튼 클릭 시 호출됩니다.
  void _showComingSoon(BuildContext context, AppLocalizations l10n) {
    AppSnackBar.showInfo(
      context,
      l10n.comingSoon,
      duration: const Duration(seconds: 2),
    );
  }
}

/// 향후 SNS 로그인 추가 예시 (주석 처리)
///
/// ```dart
/// /// Google 로그인 버튼 추가
/// SocialLoginButton(
///   text: 'Google로 시작하기',
///   backgroundColor: AppColorPalette.googleButton,
///   textColor: Colors.white,
///   onPressed: onGoogleLogin,
///   icon: Image.asset('assets/icons/google.png', width: 20.w),
/// ),
///
/// SizedBox(height: 12.h),
///
/// /// Apple 로그인 버튼 추가
/// SocialLoginButton(
///   text: 'Apple로 시작하기',
///   backgroundColor: AppColorPalette.appleButton,
///   textColor: Colors.white,
///   onPressed: onAppleLogin,
///   icon: Icon(Icons.apple, color: Colors.white, size: 20.w),
/// ),
/// ```
