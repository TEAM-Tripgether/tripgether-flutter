import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';

/// Tripgether 앱의 공용 버튼 컴포넌트
///
/// ⚠️ 중요: Theme 대신 AppColors를 직접 사용합니다.
/// 디자이너가 지정한 색상을 명시적으로 적용하여 명확성과 유지보수성을 향상시킵니다.

// ==================== Primary Button ====================

/// 주요 액션을 위한 Primary Button (ElevatedButton 기반)
///
/// 사용 예시:
/// ```dart
/// PrimaryButton(
///   text: '저장',
///   onPressed: () => _handleSave(),
/// )
/// ```
///
/// 아이콘 포함 예시:
/// ```dart
/// PrimaryButton(
///   text: '다음',
///   icon: Icons.arrow_forward,
///   onPressed: () => _goNext(),
/// )
/// ```
class PrimaryButton extends StatelessWidget {
  /// 버튼에 표시될 텍스트
  final String text;

  /// 버튼 탭 시 실행될 콜백 함수
  final VoidCallback? onPressed;

  /// 버튼 왼쪽에 표시될 아이콘 (선택 사항)
  final IconData? icon;

  /// 버튼이 화면 전체 너비를 차지할지 여부 (기본값: true)
  final bool isFullWidth;

  /// 버튼 높이 (기본값: AppSizes.buttonHeight)
  final double? height;

  /// 로딩 상태 표시 여부
  final bool isLoading;

  /// 커스텀 버튼 스타일 (선택 사항)
  /// 제공되면 Theme 스타일을 오버라이드합니다
  final ButtonStyle? style;

  const PrimaryButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.icon,
    this.isFullWidth = true,
    this.height,
    this.isLoading = false,
    this.style,
  });

  /// 기본 버튼 스타일 생성
  /// 디자이너 스펙을 직접 적용: mainColor 배경, white 텍스트
  ButtonStyle _buildBaseStyle() {
    return ElevatedButton.styleFrom(
      backgroundColor: AppColors.buttonActive, // #5325CB
      foregroundColor: AppColors.buttonTextActive, // white
      disabledBackgroundColor: AppColors.mainColor.withValues(
        alpha: 0.2,
      ), // #5325CB alpha 0.2
      disabledForegroundColor: AppColors.buttonTextInactive, // white
      elevation: AppElevation.medium,
      shadowColor: AppColors.shadow.withValues(alpha: 0.15),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(100), // 완전한 pill 모양
      ),
      minimumSize: Size(AppSizes.buttonMinWidth, AppSizes.buttonHeight),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: isFullWidth ? double.infinity : null,
      height: height ?? AppSizes.buttonHeight,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        // 기본 스타일과 커스텀 스타일 병합 (null이 아닌 속성만 오버라이드)
        style: _buildBaseStyle().merge(style),
        child: isLoading
            ? SizedBox(
                width: AppSizes.iconMedium,
                height: AppSizes.iconMedium,
                child: const CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    AppColors.buttonTextActive, // white
                  ),
                ),
              )
            : Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (icon != null) ...[
                    Icon(icon, size: AppSizes.iconMedium),
                    SizedBox(width: AppSpacing.sm),
                  ],
                  Text(
                    text,
                    style: AppTextStyles.buttonLargeMedium16.copyWith(
                      color: onPressed != null
                          ? AppColors.buttonTextActive
                          : AppColors.buttonTextInactive,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

// ==================== Secondary Button ====================

/// 부가 액션을 위한 Secondary Button (OutlinedButton 기반)
///
/// 사용 예시:
/// ```dart
/// SecondaryButton(
///   text: '취소',
///   onPressed: () => _handleCancel(),
/// )
/// ```
class SecondaryButton extends StatelessWidget {
  /// 버튼에 표시될 텍스트
  final String text;

  /// 버튼 탭 시 실행될 콜백 함수
  final VoidCallback? onPressed;

  /// 버튼 왼쪽에 표시될 아이콘 (선택 사항)
  final IconData? icon;

  /// 버튼이 화면 전체 너비를 차지할지 여부 (기본값: true)
  final bool isFullWidth;

  /// 버튼 높이 (기본값: AppSizes.buttonHeight)
  final double? height;

  /// 로딩 상태 표시 여부
  final bool isLoading;

  /// 커스텀 버튼 스타일 (선택 사항)
  /// 제공되면 Theme 스타일을 오버라이드합니다
  final ButtonStyle? style;

  const SecondaryButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.icon,
    this.isFullWidth = true,
    this.height,
    this.isLoading = false,
    this.style,
  });

  /// 기본 버튼 스타일 생성
  /// 디자이너 스펙을 직접 적용: mainColor 테두리/텍스트, 흰 배경
  ButtonStyle _buildBaseStyle() {
    return OutlinedButton.styleFrom(
      foregroundColor: AppColors.mainColor, // #5325CB 텍스트
      disabledForegroundColor: AppColors.textColor1.withValues(
        alpha: 0.4,
      ), // alpha 0.4
      side: BorderSide(
        color: AppColors.subColor2, // #BBBBBB 테두리
        width: AppSizes.borderThin,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(100), // 완전한 pill 모양
      ),
      minimumSize: Size(AppSizes.buttonMinWidth, AppSizes.buttonHeight),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: isFullWidth ? double.infinity : null,
      height: height ?? AppSizes.buttonHeight,
      child: OutlinedButton(
        onPressed: isLoading ? null : onPressed,
        // 기본 스타일과 커스텀 스타일 병합 (null이 아닌 속성만 오버라이드)
        style: _buildBaseStyle().merge(style),
        child: isLoading
            ? SizedBox(
                width: AppSizes.iconMedium,
                height: AppSizes.iconMedium,
                child: const CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    AppColors.mainColor, // #5325CB
                  ),
                ),
              )
            : Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (icon != null) ...[
                    Icon(icon, size: AppSizes.iconMedium),
                    SizedBox(width: AppSpacing.sm),
                  ],
                  Text(text),
                ],
              ),
      ),
    );
  }
}

// ==================== Tertiary Button ====================

/// 텍스트 전용 Tertiary Button (TextButton 기반)
///
/// 덜 중요한 액션이나 링크 스타일이 필요한 경우 사용합니다.
///
/// 사용 예시:
/// ```dart
/// TertiaryButton(
///   text: '건너뛰기',
///   onPressed: () => _skip(),
/// )
/// ```
class TertiaryButton extends StatelessWidget {
  /// 버튼에 표시될 텍스트
  final String text;

  /// 버튼 탭 시 실행될 콜백 함수
  final VoidCallback? onPressed;

  /// 버튼 왼쪽에 표시될 아이콘 (선택 사항)
  final IconData? icon;

  /// 버튼이 화면 전체 너비를 차지할지 여부 (기본값: false)
  final bool isFullWidth;

  /// 버튼 높이 (기본값: AppSizes.textButtonHeight)
  final double? height;

  /// 커스텀 버튼 스타일 (선택 사항)
  /// 제공되면 Theme 스타일을 오버라이드합니다
  final ButtonStyle? style;

  const TertiaryButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.icon,
    this.isFullWidth = false,
    this.height,
    this.style,
  });

  /// 기본 버튼 스타일 생성
  /// 디자이너 스펙을 직접 적용: subColor2 텍스트
  ButtonStyle _buildBaseStyle() {
    return TextButton.styleFrom(
      foregroundColor: AppColors.subColor2, // #BBBBBB
      disabledForegroundColor: AppColors.textColor1.withValues(
        alpha: 0.4,
      ), // alpha 0.4
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(100), // 완전한 pill 모양
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: isFullWidth ? double.infinity : null,
      height: height ?? AppSizes.textButtonHeight,
      child: TextButton(
        onPressed: onPressed,
        // 기본 스타일과 커스텀 스타일 병합 (null이 아닌 속성만 오버라이드)
        style: _buildBaseStyle().merge(style),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) ...[
              Icon(icon, size: AppSizes.iconSmall),
              SizedBox(width: AppSpacing.xs),
            ],
            Text(text),
          ],
        ),
      ),
    );
  }
}

// ==================== Icon Button Wrapper ====================

/// 일관된 스타일의 Icon Button 래퍼
///
/// Theme의 iconButtonTheme 스타일을 활용합니다.
///
/// 사용 예시:
/// ```dart
/// CommonIconButton(
///   icon: Icons.favorite,
///   onPressed: () => _toggleFavorite(),
///   tooltip: '좋아요',
/// )
/// ```
class CommonIconButton extends StatelessWidget {
  /// 표시할 아이콘
  final IconData icon;

  /// 버튼 탭 시 실행될 콜백 함수
  final VoidCallback? onPressed;

  /// 접근성을 위한 툴팁 텍스트
  final String? tooltip;

  /// 아이콘 크기 (기본값: AppSizes.iconDefault)
  final double? size;

  /// 배경색이 있는 버튼 여부 (기본값: false)
  final bool hasBackground;

  /// 배경색 (hasBackground가 true일 때만 적용)
  final Color? backgroundColor;

  const CommonIconButton({
    super.key,
    required this.icon,
    required this.onPressed,
    this.tooltip,
    this.size,
    this.hasBackground = false,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final iconButton = IconButton(
      icon: Icon(icon),
      onPressed: onPressed,
      tooltip: tooltip,
      iconSize: size ?? AppSizes.iconDefault,
      color: AppColors.textColor1, // 디자이너 스펙 적용
    );

    if (!hasBackground) {
      return iconButton;
    }

    // 배경이 있는 경우 Container로 감싸기
    return Container(
      decoration: BoxDecoration(
        color:
            backgroundColor ??
            AppColors.subColor2.withValues(alpha: 0.2), // subColor2 alpha 0.2
        borderRadius: AppRadius.allMedium,
      ),
      child: iconButton,
    );
  }
}

// ==================== Button Group ====================

/// 여러 버튼을 그룹으로 배치하는 헬퍼 위젯
///
/// 사용 예시:
/// ```dart
/// ButtonGroup(
///   children: [
///     SecondaryButton(text: '취소', onPressed: () => _cancel()),
///     PrimaryButton(text: '확인', onPressed: () => _confirm()),
///   ],
/// )
/// ```
class ButtonGroup extends StatelessWidget {
  /// 배치할 버튼들
  final List<Widget> children;

  /// 버튼 사이 간격 (기본값: AppSpacing.md)
  final double? spacing;

  /// 수평 배치 여부 (기본값: true)
  final bool isHorizontal;

  const ButtonGroup({
    super.key,
    required this.children,
    this.spacing,
    this.isHorizontal = true,
  });

  @override
  Widget build(BuildContext context) {
    if (isHorizontal) {
      return Row(
        children: [
          for (int i = 0; i < children.length; i++) ...[
            Expanded(child: children[i]),
            if (i < children.length - 1)
              SizedBox(width: spacing ?? AppSpacing.md),
          ],
        ],
      );
    } else {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (int i = 0; i < children.length; i++) ...[
            children[i],
            if (i < children.length - 1)
              SizedBox(height: spacing ?? AppSpacing.md),
          ],
        ],
      );
    }
  }
}

// ==================== Link Button ====================

/// 링크 바로가기 버튼
///
/// 외부 URL이나 콘텐츠로 이동하는 링크 버튼입니다.
/// SVG 아이콘과 텍스트를 포함하며, 작고 가벼운 스타일입니다.
///
/// 사용 예시:
/// ```dart
/// LinkButton(
///   text: '링크 바로가기',
///   onPressed: () => _openUrl(),
/// )
/// ```
///
/// 커스텀 아이콘 예시:
/// ```dart
/// LinkButton(
///   text: '상세보기',
///   iconPath: 'assets/icons/open.svg',
///   textStyle: AppTextStyles.labelMedium,
///   backgroundColor: AppColors.primary,
///   foregroundColor: AppColors.white,
///   onPressed: () => _openDetail(),
/// )
/// ```
class LinkButton extends StatelessWidget {
  /// 버튼에 표시될 텍스트
  final String text;

  /// 버튼 탭 시 실행될 콜백 함수
  final VoidCallback? onPressed;

  /// SVG 아이콘 경로 (기본값: 'assets/icons/link.svg')
  final String? iconPath;

  /// 배경색 (기본값: AppColors.white)
  final Color? backgroundColor;

  /// 아이콘 및 텍스트 색상 (기본값: AppColors.subColor2)
  final Color? foregroundColor;

  /// 텍스트 스타일 (기본값: AppTextStyles.metaMedium12)
  /// 버튼마다 다른 스타일이 필요할 때 커스텀 가능
  final TextStyle? textStyle;

  const LinkButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.iconPath,
    this.backgroundColor,
    this.foregroundColor,
    this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: AppSpacing.sm, // 8
          vertical: AppSpacing.smd, // 10
        ),
        decoration: BoxDecoration(
          color: backgroundColor ?? AppColors.white,
          borderRadius: AppRadius.allSmall, // 4.r
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(
              iconPath ?? 'assets/icons/link.svg',
              width: AppSizes.iconSmall, // 16.w
              height: AppSizes.iconSmall,
              colorFilter: ColorFilter.mode(
                foregroundColor ?? AppColors.subColor2,
                BlendMode.srcIn,
              ),
            ),
            SizedBox(width: AppSpacing.xs), // 4.w
            Text(text, style: textStyle ?? AppTextStyles.metaMedium12),
          ],
        ),
      ),
    );
  }
}
