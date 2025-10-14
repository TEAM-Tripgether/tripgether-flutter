import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/theme/app_spacing.dart';

/// Tripgether 앱의 공용 버튼 컴포넌트
///
/// Theme 시스템을 완전히 활용하여 일관된 버튼 스타일을 제공합니다.
/// 모든 버튼은 app_theme.dart에 정의된 스타일을 기본으로 사용하며,
/// 필요시 개별 커스터마이징이 가능합니다.

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

  const PrimaryButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.icon,
    this.isFullWidth = true,
    this.height,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SizedBox(
      width: isFullWidth ? double.infinity : null,
      height: height ?? AppSizes.buttonHeight,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        // Theme의 elevatedButtonTheme 스타일이 자동 적용됨
        child: isLoading
            ? SizedBox(
                width: AppSizes.iconMedium,
                height: AppSizes.iconMedium,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    theme.colorScheme.onPrimary,
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

  const SecondaryButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.icon,
    this.isFullWidth = true,
    this.height,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SizedBox(
      width: isFullWidth ? double.infinity : null,
      height: height ?? AppSizes.buttonHeight,
      child: OutlinedButton(
        onPressed: isLoading ? null : onPressed,
        // Theme의 outlinedButtonTheme 스타일이 자동 적용됨
        child: isLoading
            ? SizedBox(
                width: AppSizes.iconMedium,
                height: AppSizes.iconMedium,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    theme.colorScheme.primary,
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

  const TertiaryButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.icon,
    this.isFullWidth = false,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: isFullWidth ? double.infinity : null,
      height: height ?? AppSizes.textButtonHeight,
      child: TextButton(
        onPressed: onPressed,
        // Theme의 textButtonTheme 스타일이 자동 적용됨
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
      // Theme의 iconButtonTheme 스타일이 자동 적용됨
    );

    if (!hasBackground) {
      return iconButton;
    }

    // 배경이 있는 경우 Container로 감싸기
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor ?? Theme.of(context).colorScheme.surfaceContainerHighest,
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
