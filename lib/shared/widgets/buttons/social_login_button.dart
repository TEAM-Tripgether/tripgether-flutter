import 'package:flutter/material.dart';
import '../../../../core/theme/app_spacing.dart';

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
  });

  @override
  Widget build(BuildContext context) {
    // Theme의 textTheme을 가져와서 일관된 텍스트 스타일 적용
    final textTheme = Theme.of(context).textTheme;

    return SizedBox(
      width: double.infinity, // 전체 너비
      height: height ?? AppSizes.buttonHeight, // Theme의 버튼 높이 사용
      child: ElevatedButton(
        // 로딩 중일 때는 버튼 비활성화
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: textColor,
          elevation: AppElevation.none, // Theme의 elevation 사용
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: AppRadius.allLarge, // Theme의 border radius 사용
            // 테두리가 지정된 경우에만 표시
            side: borderColor != null
                ? BorderSide(color: borderColor!, width: AppSizes.borderMedium)
                : BorderSide.none,
          ),
          // 탭 시 리플 효과 색상 (배경색 기반으로 자동 조정)
          splashFactory: InkRipple.splashFactory,
        ),
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
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // 아이콘이 있는 경우 표시
                  if (icon != null) ...[icon!, SizedBox(width: AppSpacing.sm)],
                  // 버튼 텍스트 (Theme의 textTheme 활용)
                  Text(
                    text,
                    style: textTheme.labelLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.1,
                      color: textColor,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
