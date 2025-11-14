import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';

/// 섹션 헤더 위젯
///
/// 홈 화면 및 다양한 화면에서 섹션 제목과 더보기 버튼을 표시합니다.
/// 일관된 스타일과 레이아웃을 제공하여 UI 통일성을 유지합니다.
///
/// 사용 예시:
/// ```dart
/// SectionHeader(
///   title: '최근 저장한 장소',
///   onMoreTap: () => context.push('/places'),
/// )
///
/// // 더보기 버튼 없는 경우
/// SectionHeader(
///   title: '추천 코스',
///   showMoreButton: false,
/// )
///
/// // 커스텀 액션 버튼
/// SectionHeader(
///   title: '내 여행',
///   trailing: IconButton(
///     icon: Icon(Icons.add),
///     onPressed: () => _addTrip(),
///   ),
/// )
/// ```
class SectionHeader extends StatelessWidget {
  /// 섹션 제목 텍스트
  final String title;

  /// 더보기 버튼 클릭 시 콜백
  final VoidCallback? onMoreTap;

  /// 더보기 버튼 표시 여부 (기본값: true)
  final bool showMoreButton;

  /// 커스텀 trailing 위젯 (showMoreButton이 true일 때 무시됨)
  final Widget? trailing;

  /// 제목 텍스트 스타일 (기본값: AppTextStyles.titleSemiBold16)
  final TextStyle? titleStyle;

  /// 왼쪽 패딩 (기본값: AppSpacing.sm)
  final double? leftPadding;

  const SectionHeader({
    super.key,
    required this.title,
    this.onMoreTap,
    this.showMoreButton = true,
    this.trailing,
    this.titleStyle,
    this.leftPadding,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: leftPadding ?? AppSpacing.sm),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // 섹션 제목
          Text(
            title,
            style:
                titleStyle ??
                AppTextStyles.titleSemiBold16.copyWith(
                  color: AppColors.textColor1,
                ),
          ),

          // 더보기 버튼 또는 커스텀 trailing
          if (showMoreButton)
            IconButton(
              onPressed: onMoreTap,
              icon: Icon(
                Icons.chevron_right_rounded,
                color: AppColors.subColor2,
                size: AppSizes.iconLarge,
              ),
            )
          else if (trailing != null)
            trailing!,
        ],
      ),
    );
  }
}
