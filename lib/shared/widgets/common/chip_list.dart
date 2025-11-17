import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';

/// 공통 칩 컨테이너 빌더
///
/// ChipList와 SelectableChipList에서 사용하는 공통 칩 UI 구현
/// Material 위젯을 사용하지 않고 Container로 직접 구현하여
/// surfaceTintColor 등 Material 3 기본 스타일의 영향을 받지 않음
///
/// **Material을 사용하지 않는 이유**:
/// - Material 3 Chip은 surfaceTintColor, elevation 등 기본 스타일 자동 적용
/// - 외곽선처럼 보이는 미묘한 색상 차이 발생 가능
/// - Container 직접 사용으로 디자인 완벽 제어
Widget _buildChipContainer({
  required String label,
  required Color backgroundColor,
  required Color textColor,
  required TextStyle textStyle,
  required EdgeInsets padding,
  required double borderRadius,
  Border? border,
  VoidCallback? onTap,
}) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      padding: padding,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(borderRadius),
        border: border,
      ),
      child: Text(
        label,
        style: textStyle.copyWith(color: textColor),
      ),
    ),
  );
}

/// 칩 리스트 위젯
///
/// 검색 추천어, 카테고리 필터, 태그 등을 칩 형태로 표시하는 위젯
/// Wrap을 사용하여 자동으로 줄바꿈 처리
///
/// **디자인 원칙**:
/// - Material 위젯 미사용으로 완벽한 스타일 제어
/// - InterestChip과 동일한 Container 기반 구현
/// - 공통 빌더 함수(_buildChipContainer) 활용으로 일관성 유지
///
/// **Material을 사용하지 않는 이유**:
/// Material 3의 Chip은 surfaceTintColor, elevation 등 기본 스타일이
/// 자동 적용되어 외곽선처럼 보이는 효과 발생. Container 직접 사용으로
/// 디자인 시스템(AppColors, AppSpacing)의 정확한 적용 보장.
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
    return _buildChipContainer(
      label: item,
      backgroundColor: backgroundColor ?? AppColors.subColor2.withValues(alpha: 0.95),
      textColor: textColor ?? AppColors.textColor1,
      textStyle: baseTextStyle,
      padding: chipPadding ??
          EdgeInsets.symmetric(
            horizontal: AppSpacing.sm.w,
            vertical: AppSpacing.xs.h,
          ),
      borderRadius: borderRadius ?? AppRadius.large,
      border: Border.all(
        color: borderColor ?? AppColors.subColor2.withValues(alpha: 0.9),
        width: 1,
      ),
      onTap: onItemTap != null ? () => onItemTap!(item) : null,
    );
  }
}

/// 선택 가능한 칩 리스트 위젯
///
/// 사용자가 칩을 선택/해제할 수 있으며, 선택된 칩은 다른 스타일로 표시
/// 필터링이나 다중 선택 시나리오에 적합
///
/// **디자인 원칙**:
/// - Material 위젯 미사용으로 완벽한 스타일 제어
/// - InterestChip과 동일한 Container 기반 구현
/// - 공통 빌더 함수(_buildChipContainer) 활용으로 일관성 유지
/// - showBorder 파라미터로 외곽선 제어 (기본값: true)
///
/// **Material을 사용하지 않는 이유**:
/// Material 3의 Chip은 surfaceTintColor, elevation 등 기본 스타일이
/// 자동 적용되어 외곽선처럼 보이는 효과 발생. Container 직접 사용으로
/// 디자인 시스템의 정확한 적용 보장.
///
/// 사용 예시:
/// ```dart
/// // 기본 사용 (외곽선 있음)
/// SelectableChipList(
///   items: ['데이트', '산책', '빈티지'],
///   selectedItems: _selectedCategories,
///   onSelectionChanged: (selected) {
///     setState(() => _selectedCategories = selected);
///   },
/// )
///
/// // SNS 필터 (외곽선 없음)
/// SelectableChipList(
///   items: ['전체', '유튜브', '인스타그램'],
///   selectedItems: {_selectedCategory},
///   singleSelection: true,
///   showBorder: false,
///   onSelectionChanged: (selected) {
///     setState(() => _selectedCategory = selected.first);
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

  /// 외곽선 표시 여부 (기본값: true)
  final bool showBorder;

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
    this.showBorder = true,
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
    return _buildChipContainer(
      label: item,
      backgroundColor: isSelected
          ? (selectedBackgroundColor ?? AppColors.mainColor)
          : (unselectedBackgroundColor ??
              AppColors.subColor2.withValues(alpha: 0.2)),
      textColor: isSelected
          ? (selectedTextColor ?? AppColors.white)
          : (unselectedTextColor ?? AppColors.textColor1),
      textStyle: baseTextStyle,
      padding: chipPadding ??
          EdgeInsets.symmetric(
            horizontal: AppSpacing.sm.w,
            vertical: AppSpacing.xs.h,
          ),
      borderRadius: borderRadius ?? AppRadius.large,
      border: showBorder
          ? Border.all(
              color: isSelected
                  ? (selectedBackgroundColor ?? AppColors.mainColor)
                  : AppColors.subColor2.withValues(alpha: 0.9),
              width: 1,
            )
          : null,
      onTap: onSelectionChanged != null ? () => _handleSelection(item) : null,
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
