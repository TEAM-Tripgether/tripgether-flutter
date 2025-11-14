import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';

/// 칩 리스트 위젯
///
/// 검색 추천어, 카테고리 필터, 태그 등을 칩 형태로 표시하는 위젯
/// Wrap을 사용하여 자동으로 줄바꿈 처리
///
/// 사용 예시:
/// ```dart
/// ChipList(
///   items: ['데이트', '산책', '빈티지'],
///   onItemTap: (item) => print('Selected: $item'),
/// )
/// ```
class ChipList extends StatelessWidget {
  /// 칩으로 표시할 아이템 리스트
  final List<String> items;

  /// 칩 탭 시 실행될 콜백
  final ValueChanged<String>? onItemTap;

  /// 칩 간 가로 간격 (기본값: 8.w)
  final double? horizontalSpacing;

  /// 칩 간 세로 간격 (기본값: 8.h)
  final double? verticalSpacing;

  /// 칩 배경색 (기본값: subColor2 alpha 0.95)
  final Color? backgroundColor;

  /// 칩 테두리 색상 (기본값: subColor2 alpha 0.9)
  final Color? borderColor;

  /// 칩 텍스트 색상 (기본값: textColor1)
  final Color? textColor;

  /// 칩 텍스트 스타일 (색상 제외)
  final TextStyle? textStyle;

  /// 칩 내부 패딩 (기본값: horizontal: 12.w, vertical: 8.h)
  final EdgeInsets? chipPadding;

  /// 칩 border radius (기본값: 16.r)
  final double? borderRadius;

  /// 좌우 외부 패딩 (기본값: 16.w)
  final double? horizontalPadding;

  const ChipList({
    super.key,
    required this.items,
    this.onItemTap,
    this.horizontalSpacing,
    this.verticalSpacing,
    this.backgroundColor,
    this.borderColor,
    this.textColor,
    this.textStyle,
    this.chipPadding,
    this.borderRadius,
    this.horizontalPadding,
  });

  @override
  Widget build(BuildContext context) {
    // 기본 텍스트 스타일
    final effectiveTextStyle = textStyle ?? AppTextStyles.buttonMediumMedium14;

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: horizontalPadding ?? AppSpacing.lg,
      ),
      child: Wrap(
        spacing: horizontalSpacing ?? AppSpacing.xs.w,
        runSpacing: verticalSpacing ?? AppSpacing.xs.h,
        children: items.map((item) {
          return _buildChipItem(context, item, effectiveTextStyle);
        }).toList(),
      ),
    );
  }

  /// 개별 칩 아이템 빌드
  Widget _buildChipItem(
    BuildContext context,
    String item,
    TextStyle baseTextStyle,
  ) {
    return GestureDetector(
      onTap: onItemTap != null ? () => onItemTap!(item) : null,
      child: Chip(
        label: Text(
          item,
          style: baseTextStyle.copyWith(
            color: textColor ?? AppColors.textColor1,
          ),
        ),
        backgroundColor: backgroundColor ?? AppColors.subColor2.withValues(alpha: 0.95),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius ?? AppRadius.large),
          side: BorderSide(color: borderColor ?? AppColors.subColor2.withValues(alpha: 0.9), width: 1),
        ),
        padding:
            chipPadding ??
            EdgeInsets.symmetric(
              horizontal: AppSpacing.sm.w,
              vertical: AppSpacing.xs.h,
            ),
      ),
    );
  }
}

/// 선택 가능한 칩 리스트 위젯
///
/// 사용자가 칩을 선택/해제할 수 있으며, 선택된 칩은 다른 스타일로 표시
/// 필터링이나 다중 선택 시나리오에 적합
///
/// 사용 예시:
/// ```dart
/// SelectableChipList(
///   items: ['데이트', '산책', '빈티지'],
///   selectedItems: _selectedCategories,
///   onSelectionChanged: (selected) {
///     setState(() => _selectedCategories = selected);
///   },
/// )
/// ```
class SelectableChipList extends StatelessWidget {
  /// 칩으로 표시할 아이템 리스트
  final List<String> items;

  /// 현재 선택된 아이템 리스트
  final Set<String> selectedItems;

  /// 선택 상태 변경 시 실행될 콜백
  final ValueChanged<Set<String>>? onSelectionChanged;

  /// 단일 선택 모드 (기본값: false, 다중 선택)
  final bool singleSelection;

  /// 칩 간 가로 간격
  final double? horizontalSpacing;

  /// 칩 간 세로 간격
  final double? verticalSpacing;

  /// 선택되지 않은 칩 배경색
  final Color? unselectedBackgroundColor;

  /// 선택된 칩 배경색
  final Color? selectedBackgroundColor;

  /// 선택되지 않은 칩 텍스트 색상
  final Color? unselectedTextColor;

  /// 선택된 칩 텍스트 색상
  final Color? selectedTextColor;

  /// 칩 텍스트 스타일
  final TextStyle? textStyle;

  /// 칩 내부 패딩
  final EdgeInsets? chipPadding;

  /// 칩 border radius
  final double? borderRadius;

  /// 좌우 외부 패딩
  final double? horizontalPadding;

  const SelectableChipList({
    super.key,
    required this.items,
    required this.selectedItems,
    this.onSelectionChanged,
    this.singleSelection = false,
    this.horizontalSpacing,
    this.verticalSpacing,
    this.unselectedBackgroundColor,
    this.selectedBackgroundColor,
    this.unselectedTextColor,
    this.selectedTextColor,
    this.textStyle,
    this.chipPadding,
    this.borderRadius,
    this.horizontalPadding,
  });

  @override
  Widget build(BuildContext context) {
    // 기본 텍스트 스타일
    final effectiveTextStyle = textStyle ?? AppTextStyles.buttonMediumMedium14;

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: horizontalPadding ?? AppSpacing.lg,
      ),
      child: Wrap(
        spacing: horizontalSpacing ?? AppSpacing.xs.w,
        runSpacing: verticalSpacing ?? AppSpacing.xs.h,
        children: items.map((item) {
          final isSelected = selectedItems.contains(item);
          return _buildSelectableChipItem(
            context,
            item,
            isSelected,
            effectiveTextStyle,
          );
        }).toList(),
      ),
    );
  }

  /// 선택 가능한 칩 아이템 빌드
  Widget _buildSelectableChipItem(
    BuildContext context,
    String item,
    bool isSelected,
    TextStyle baseTextStyle,
  ) {
    return GestureDetector(
      onTap: onSelectionChanged != null ? () => _handleSelection(item) : null,
      child: Chip(
        label: Text(
          item,
          style: baseTextStyle.copyWith(
            color: isSelected
                ? (selectedTextColor ?? AppColors.white)
                : (unselectedTextColor ?? AppColors.textColor1),
          ),
        ),
        backgroundColor: isSelected
            ? (selectedBackgroundColor ?? AppColors.mainColor)
            : (unselectedBackgroundColor ?? AppColors.subColor2.withValues(alpha: 0.95)),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius ?? AppRadius.large),
          side: BorderSide(
            color: isSelected
                ? (selectedBackgroundColor ?? AppColors.mainColor)
                : AppColors.subColor2.withValues(alpha: 0.9),
            width: 1,
          ),
        ),
        padding:
            chipPadding ??
            EdgeInsets.symmetric(
              horizontal: AppSpacing.sm.w,
              vertical: AppSpacing.xs.h,
            ),
      ),
    );
  }

  /// 선택 처리 로직
  void _handleSelection(String item) {
    if (onSelectionChanged == null) return;

    final newSelection = Set<String>.from(selectedItems);

    if (singleSelection) {
      // 단일 선택 모드: 선택된 아이템만 유지
      if (newSelection.contains(item)) {
        newSelection.clear(); // 이미 선택된 경우 선택 해제
      } else {
        newSelection.clear();
        newSelection.add(item);
      }
    } else {
      // 다중 선택 모드: 토글
      if (newSelection.contains(item)) {
        newSelection.remove(item);
      } else {
        newSelection.add(item);
      }
    }

    onSelectionChanged!(newSelection);
  }
}
