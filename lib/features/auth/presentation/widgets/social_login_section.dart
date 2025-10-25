import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../shared/widgets/buttons/social_login_button.dart';

/// 소셜 로그인 섹션 위젯
///
/// 구글 로그인과 이메일 가입 버튼을 표시하는 위젯입니다.
///
/// **디자인**:
/// - 구글: 흰색 배경 + 회색 테두리 + 'G' 아이콘
/// - 이메일: 흰색 배경 + textSecondary 색상 테두리
///
/// **확장성**: 버튼 추가/제거가 쉽도록 설계되어
/// 향후 Apple 등의 로그인 추가가 간편합니다.
class SocialLoginSection extends StatelessWidget {
  /// 구글 로그인 버튼 탭 콜백
  final VoidCallback onGoogleLogin;

  /// 이메일 가입 버튼 탭 콜백
  final VoidCallback onEmailSignup;

  /// 구글 로그인 로딩 상태
  final bool isGoogleLoading;

  const SocialLoginSection({
    super.key,
    required this.onGoogleLogin,
    required this.onEmailSignup,
    this.isGoogleLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final colorScheme = theme.colorScheme;
    final l10n = AppLocalizations.of(context);

    return Column(
      children: [
        /// 구글 로그인 버튼
        /// Surface 배경 + 회색 테두리 + 구글 로고
        SocialLoginButton(
          text: l10n.signInWithGoogle,
          backgroundColor: colorScheme.surface,
          textColor: colorScheme.onSurface,
          borderColor: AppColors.outline, // 회색 테두리
          onPressed: onGoogleLogin,
          isLoading: isGoogleLoading,
          // 구글 아이콘 - 'G' 텍스트로 임시 대체 (향후 실제 로고로 교체)
          icon: Container(
            width: AppSizes.iconMedium,
            height: AppSizes.iconMedium.h,
            decoration: BoxDecoration(
              color: colorScheme.surface,
              borderRadius: AppRadius.circular(2),
            ),
            child: Center(
              child: Text(
                'G',
                style: textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: AppColorPalette.googleButton, // 구글 브랜드 색상
                ),
              ),
            ),
          ),
        ),

        SizedBox(height: AppSpacing.sm),

        /// 이메일로 가입하기 버튼
        /// Surface 배경 + onSurfaceVariant 색상 텍스트 (테두리 없음)
        SocialLoginButton(
          text: l10n.signUpWithEmail,
          backgroundColor: colorScheme.surface,
          textColor: colorScheme.onSurfaceVariant,
          onPressed: onEmailSignup,
        ),

        SizedBox(height: AppSpacing.xxl),
      ],
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
