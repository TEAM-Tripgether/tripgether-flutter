import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';

/// 소셜 로그인 버튼 위젯
///
/// 카카오, 네이버, Google, Apple 등 다양한 SNS 로그인 버튼을
/// 재사용 가능하도록 구현한 범용 위젯입니다.
///
/// **사용 예시**:
/// ```dart
/// SocialLoginButton(
///   text: "카카오로 시작하기",
///   backgroundColor: AppColorPalette.kakaoButton,
///   textColor: Colors.black,
///   icon: Image.asset('assets/icons/kakao.png', width: 20.w),
///   onPressed: () => _handleKakaoLogin(),
/// )
/// ```
class SocialLoginButton extends StatelessWidget {
  /// 버튼에 표시될 텍스트
  final String text;

  /// 버튼 배경색
  final Color backgroundColor;

  /// 텍스트 색상
  final Color textColor;

  /// 버튼 왼쪽에 표시될 아이콘 (선택 사항)
  /// 없으면 텍스트만 표시됩니다
  final Widget? icon;

  /// 버튼 탭 시 실행될 콜백 함수
  final VoidCallback onPressed;

  /// 버튼 테두리 색상 (선택 사항)
  /// 기본값은 null (테두리 없음)
  final Color? borderColor;

  /// 버튼 높이 (선택 사항)
  /// 기본값: 48.h
  final double? height;

  /// 로딩 상태 표시 여부
  /// true일 때 CircularProgressIndicator를 표시하고 버튼을 비활성화합니다
  final bool isLoading;

  /// 커스텀 버튼 스타일 (선택 사항)
  /// 제공되면 기본 스타일을 오버라이드합니다
  final ButtonStyle? customStyle;

  const SocialLoginButton({
    super.key,
    required this.text,
    required this.backgroundColor,
    required this.textColor,
    required this.onPressed,
    this.icon,
    this.borderColor,
    this.height,
    this.isLoading = false,
    this.customStyle,
  });

  /// 기본 버튼 스타일 생성
  /// backgroundColor, textColor, borderColor 파라미터를 사용하여 기본 스타일 구성
  ButtonStyle _buildBaseStyle() {
    return ElevatedButton.styleFrom(
      backgroundColor: backgroundColor,
      foregroundColor: textColor,
      elevation: AppElevation.high, // 그림자 효과 (3)
      shadowColor: AppColors.shadow.withValues(alpha: 0.25), // 뚜렷한 검은색 그림자 (25%)
      // 패딩: AppSpacing.buttonPaddingSmall 활용 (가로 16, 세로 12)
      padding: AppSpacing.buttonPaddingSmall,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.circle), // 완전한 pill 모양
        side: borderColor != null
            ? BorderSide(color: borderColor!, width: AppSizes.borderMedium)
            : BorderSide.none,
      ),
      splashFactory: InkRipple.splashFactory,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity, // 전체 너비
      height: height ?? AppSizes.buttonHeight, // Theme의 버튼 높이 사용
      child: ElevatedButton(
        // 로딩 중일 때는 버튼 비활성화
        onPressed: isLoading ? null : onPressed,
        // 기본 스타일과 커스텀 스타일 병합 (null이 아닌 속성만 오버라이드)
        style: _buildBaseStyle().merge(customStyle),
        // 로딩 중일 때 CircularProgressIndicator 표시
        child: isLoading
            ? SizedBox(
                width: AppSizes.iconMedium,
                height: AppSizes.iconMedium,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(textColor),
                ),
              )
            : Stack(
                children: [
                  // 텍스트를 버튼 중앙에 배치
                  Center(
                    child: Text(
                      text,
                      style: AppTextStyles.bodyLarge.copyWith(
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.1,
                        color: textColor,
                      ),
                    ),
                  ),
                  // 아이콘을 왼쪽에 고정 배치 (약간의 패딩과 함께)
                  if (icon != null)
                    Positioned(
                      left: AppSpacing.lg, // 16px 왼쪽 패딩
                      top: 0,
                      bottom: 0,
                      child: Center(child: icon!),
                    ),
                ],
              ),
      ),
    );
  }
}
