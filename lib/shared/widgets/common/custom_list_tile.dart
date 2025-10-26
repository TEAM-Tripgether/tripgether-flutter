import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';

/// 커스텀 리스트 타일 위젯
///
/// 리스트 아이템을 일관된 스타일로 표시하는 위젯
/// 최근 검색어, 알림 목록, 설정 항목 등에 사용
///
/// 사용 예시:
/// ```dart
/// CustomListTile(
///   leading: Icon(Icons.history),
///   title: '최근 검색어',
///   trailing: IconButton(
///     icon: Icon(Icons.close),
///     onPressed: () => removeItem(),
///   ),
///   onTap: () => navigateToSearch(),
/// )
/// ```
class CustomListTile extends StatelessWidget {
  /// 좌측 아이콘 또는 위젯
  final Widget? leading;

  /// 주요 텍스트 (제목)
  final String title;

  /// 제목 텍스트 스타일 (null이면 기본 스타일 사용)
  final TextStyle? titleStyle;

  /// 부제목 텍스트 (선택)
  final String? subtitle;

  /// 부제목 텍스트 스타일 (null이면 기본 스타일 사용)
  final TextStyle? subtitleStyle;

  /// 우측 위젯 (아이콘 버튼, 스위치 등)
  final Widget? trailing;

  /// 타일 탭 시 실행될 콜백
  final VoidCallback? onTap;

  /// 타일 배경색 (null이면 투명)
  final Color? backgroundColor;

  /// 타일 내부 패딩 (기본값: horizontal: 16.w, vertical: 12.h)
  final EdgeInsets? contentPadding;

  /// leading과 title 사이 간격 (기본값: 12.w)
  final double? leadingTitleSpacing;

  const CustomListTile({
    super.key,
    this.leading,
    required this.title,
    this.titleStyle,
    this.subtitle,
    this.subtitleStyle,
    this.trailing,
    this.onTap,
    this.backgroundColor,
    this.contentPadding,
    this.leadingTitleSpacing,
  });

  @override
  Widget build(BuildContext context) {
    // 기본 제목 스타일
    final effectiveTitleStyle =
        titleStyle ??
        AppTextStyles.bodyMedium.copyWith(color: AppColors.onSurface);

    // 기본 부제목 스타일
    final effectiveSubtitleStyle =
        subtitleStyle ??
        AppTextStyles.bodySmall.copyWith(
          fontWeight: FontWeight.w400,
          color: AppColors.neutral60,
        );

    return ListTile(
      leading: leading,
      title: Text(title, style: effectiveTitleStyle),
      subtitle: subtitle != null
          ? Text(subtitle!, style: effectiveSubtitleStyle)
          : null,
      trailing: trailing,
      onTap: onTap,
      tileColor: backgroundColor,
      contentPadding:
          contentPadding ??
          EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.sm.h,
          ),
      horizontalTitleGap: leadingTitleSpacing ?? AppSpacing.sm.w,
    );
  }
}

/// 아이콘 리스트 타일 위젯
///
/// leading에 아이콘을 자동으로 설정하는 편의 위젯
/// 아이콘 크기와 색상을 일관되게 적용
///
/// 사용 예시:
/// ```dart
/// IconListTile(
///   icon: Icons.history,
///   iconColor: AppColors.neutral60,
///   title: '최근 검색어',
///   trailing: IconButton(
///     icon: Icon(Icons.close),
///     onPressed: () => removeItem(),
///   ),
///   onTap: () => navigateToSearch(),
/// )
/// ```
class IconListTile extends StatelessWidget {
  /// 좌측 아이콘
  final IconData icon;

  /// 아이콘 크기 (기본값: 20.w)
  final double? iconSize;

  /// 아이콘 색상 (기본값: AppColors.neutral60)
  final Color? iconColor;

  /// 주요 텍스트 (제목)
  final String title;

  /// 제목 텍스트 스타일
  final TextStyle? titleStyle;

  /// 부제목 텍스트
  final String? subtitle;

  /// 부제목 텍스트 스타일
  final TextStyle? subtitleStyle;

  /// 우측 위젯
  final Widget? trailing;

  /// 타일 탭 시 실행될 콜백
  final VoidCallback? onTap;

  /// 타일 배경색
  final Color? backgroundColor;

  /// 타일 내부 패딩
  final EdgeInsets? contentPadding;

  const IconListTile({
    super.key,
    required this.icon,
    this.iconSize,
    this.iconColor,
    required this.title,
    this.titleStyle,
    this.subtitle,
    this.subtitleStyle,
    this.trailing,
    this.onTap,
    this.backgroundColor,
    this.contentPadding,
  });

  @override
  Widget build(BuildContext context) {
    return CustomListTile(
      leading: Icon(
        icon,
        size: iconSize ?? AppSizes.iconMedium,
        color: iconColor ?? AppColors.neutral60,
      ),
      title: title,
      titleStyle: titleStyle,
      subtitle: subtitle,
      subtitleStyle: subtitleStyle,
      trailing: trailing,
      onTap: onTap,
      backgroundColor: backgroundColor,
      contentPadding: contentPadding,
    );
  }
}

/// 액션 버튼 리스트 타일 위젯
///
/// trailing에 아이콘 버튼을 자동으로 설정하는 편의 위젯
/// 삭제, 편집, 공유 등의 액션 버튼을 일관되게 표시
///
/// 사용 예시:
/// ```dart
/// ActionListTile(
///   leading: Icon(Icons.history),
///   title: '데이트 코스',
///   actionIcon: Icons.close,
///   onActionTap: () => removeSearch(),
///   onTap: () => navigateToSearch(),
/// )
/// ```
class ActionListTile extends StatelessWidget {
  /// 좌측 위젯
  final Widget? leading;

  /// 주요 텍스트 (제목)
  final String title;

  /// 제목 텍스트 스타일
  final TextStyle? titleStyle;

  /// 부제목 텍스트
  final String? subtitle;

  /// 부제목 텍스트 스타일
  final TextStyle? subtitleStyle;

  /// 액션 버튼 아이콘
  final IconData actionIcon;

  /// 액션 버튼 크기 (기본값: 20.w)
  final double? actionIconSize;

  /// 액션 버튼 색상 (기본값: AppColors.neutral60)
  final Color? actionIconColor;

  /// 액션 버튼 탭 시 실행될 콜백
  final VoidCallback? onActionTap;

  /// 타일 탭 시 실행될 콜백
  final VoidCallback? onTap;

  /// 타일 배경색
  final Color? backgroundColor;

  /// 타일 내부 패딩
  final EdgeInsets? contentPadding;

  const ActionListTile({
    super.key,
    this.leading,
    required this.title,
    this.titleStyle,
    this.subtitle,
    this.subtitleStyle,
    required this.actionIcon,
    this.actionIconSize,
    this.actionIconColor,
    this.onActionTap,
    this.onTap,
    this.backgroundColor,
    this.contentPadding,
  });

  @override
  Widget build(BuildContext context) {
    return CustomListTile(
      leading: leading,
      title: title,
      titleStyle: titleStyle,
      subtitle: subtitle,
      subtitleStyle: subtitleStyle,
      trailing: onActionTap != null
          ? IconButton(
              icon: Icon(
                actionIcon,
                size: actionIconSize ?? AppSizes.iconMedium,
                color: actionIconColor ?? AppColors.neutral60,
              ),
              onPressed: onActionTap,
            )
          : null,
      onTap: onTap,
      backgroundColor: backgroundColor,
      contentPadding: contentPadding,
    );
  }
}
