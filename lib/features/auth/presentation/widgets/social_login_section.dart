import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
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

  const SocialLoginSection({
    super.key,
    required this.onGoogleLogin,
    required this.onEmailSignup,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        /// 구글 로그인 버튼
        /// 흰색 배경 + 회색 테두리 + 구글 로고
        SocialLoginButton(
          text: 'Google로 시작하기',
          backgroundColor: Colors.white,
          textColor: Colors.black.withValues(alpha: 0.87),
          borderColor: AppColors.outline, // 회색 테두리
          onPressed: onGoogleLogin,
          // 구글 아이콘 - 'G' 텍스트로 임시 대체 (향후 실제 로고로 교체)
          icon: Container(
            width: 20.w,
            height: 20.h,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(2.r),
            ),
            child: Center(
              child: Text(
                'G',
                style: TextStyle(
                  fontFamily: 'Pretendard',
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF4285F4), // 구글 블루
                ),
              ),
            ),
          ),
        ),

        SizedBox(height: AppSpacing.sm),

        /// 이메일로 가입하기 버튼
        /// 흰색 배경 + textSecondary 색상 텍스트 (테두리 없음)
        SocialLoginButton(
          text: '이메일로 가입하기',
          backgroundColor: Colors.white,
          textColor: AppColors.textSecondary, // #828693
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
