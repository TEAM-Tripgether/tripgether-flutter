import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/constants/app_colors.dart';
import '../../../l10n/app_localizations.dart';

/// 섹션 헤더 위젯
///
/// 리스트나 그룹의 제목과 액션 버튼을 표시하는 공통 헤더 컴포넌트
/// 주로 "인기 코스", "내 주변 코스" 등의 섹션 타이틀로 사용됩니다.
///
/// 사용 예시:
/// ```dart
/// SectionHeader(
///   title: '인기 코스',
///   onSeeMoreTap: () => Navigator.push(...),
/// )
/// ```
class SectionHeader extends StatelessWidget {
  /// 섹션 제목
  final String title;

  /// 더보기 버튼 탭 시 실행될 콜백
  /// null이면 더보기 버튼이 표시되지 않음
  final VoidCallback? onSeeMoreTap;

  /// 더보기 버튼 텍스트 (기본값: AppLocalizations의 "더보기")
  final String? seeMoreText;

  /// 제목 텍스트 스타일 (null이면 기본 스타일 사용)
  final TextStyle? titleStyle;

  /// 더보기 버튼 텍스트 스타일 (null이면 기본 스타일 사용)
  final TextStyle? seeMoreStyle;

  /// 좌우 패딩 값 (기본값: AppSpacing.lg)
  final double? horizontalPadding;

  /// 더보기 아이콘 표시 여부 (기본값: true)
  final bool showSeeMoreIcon;

  /// 커스텀 trailing 위젯 (더보기 버튼 대신 표시)
  /// 이 값이 null이 아니면 더보기 버튼 대신 이 위젯이 표시됨
  final Widget? trailing;

  const SectionHeader({
    super.key,
    required this.title,
    this.onSeeMoreTap,
    this.seeMoreText,
    this.titleStyle,
    this.seeMoreStyle,
    this.horizontalPadding,
    this.showSeeMoreIcon = true,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    // 기본 제목 스타일
    final effectiveTitleStyle =
        titleStyle ??
        textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.w700,
          color: AppColors.onSurface,
        );

    // 기본 더보기 버튼 스타일
    final effectiveSeeMoreStyle =
        seeMoreStyle ??
        textTheme.labelMedium?.copyWith(
          fontWeight: FontWeight.w500,
          color: AppColors.primary,
        );

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: horizontalPadding ?? AppSpacing.lg,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // 섹션 제목
          Expanded(
            child: Text(
              title,
              style: effectiveTitleStyle,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),

          // 우측 액션 (커스텀 trailing 또는 더보기 버튼)
          if (trailing != null)
            trailing!
          else if (onSeeMoreTap != null)
            _buildSeeMoreButton(
              context,
              seeMoreText ?? l10n.more,
              effectiveSeeMoreStyle!,
            ),
        ],
      ),
    );
  }

  /// 더보기 버튼 위젯 빌드
  Widget _buildSeeMoreButton(
    BuildContext context,
    String text,
    TextStyle style,
  ) {
    return GestureDetector(
      onTap: onSeeMoreTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: EdgeInsets.symmetric(
          vertical: AppSpacing.xs.h,
          horizontal: AppSpacing.xs.w,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 더보기 텍스트
            Text(text, style: style),

            // 화살표 아이콘 (showSeeMoreIcon이 true일 때만)
            if (showSeeMoreIcon) ...[
              SizedBox(width: AppSpacing.xs.w),
              Icon(
                Icons.arrow_forward_ios,
                size: AppSizes.iconSmall,
                color: AppColors.primary,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// 섹션 헤더와 하단 간격을 포함한 컴포지트 위젯
///
/// SectionHeader와 하단 여백을 함께 제공하는 편의 위젯
/// 대부분의 경우 헤더 아래에 일정한 간격이 필요하므로 이 위젯 사용 권장
///
/// 사용 예시:
/// ```dart
/// SectionHeaderWithSpacing(
///   title: '인기 코스',
///   onSeeMoreTap: () => Navigator.push(...),
///   bottomSpacing: 16.h, // 커스텀 간격
/// )
/// ```
class SectionHeaderWithSpacing extends StatelessWidget {
  /// 섹션 제목
  final String title;

  /// 더보기 버튼 탭 시 실행될 콜백
  final VoidCallback? onSeeMoreTap;

  /// 더보기 버튼 텍스트
  final String? seeMoreText;

  /// 제목 텍스트 스타일
  final TextStyle? titleStyle;

  /// 더보기 버튼 텍스트 스타일
  final TextStyle? seeMoreStyle;

  /// 좌우 패딩 값
  final double? horizontalPadding;

  /// 더보기 아이콘 표시 여부
  final bool showSeeMoreIcon;

  /// 커스텀 trailing 위젯
  final Widget? trailing;

  /// 헤더 하단 간격 (기본값: AppSpacing.md)
  final double? bottomSpacing;

  const SectionHeaderWithSpacing({
    super.key,
    required this.title,
    this.onSeeMoreTap,
    this.seeMoreText,
    this.titleStyle,
    this.seeMoreStyle,
    this.horizontalPadding,
    this.showSeeMoreIcon = true,
    this.trailing,
    this.bottomSpacing,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        SectionHeader(
          title: title,
          onSeeMoreTap: onSeeMoreTap,
          seeMoreText: seeMoreText,
          titleStyle: titleStyle,
          seeMoreStyle: seeMoreStyle,
          horizontalPadding: horizontalPadding,
          showSeeMoreIcon: showSeeMoreIcon,
          trailing: trailing,
        ),
        SizedBox(height: bottomSpacing ?? AppSpacing.md.h),
      ],
    );
  }
}
