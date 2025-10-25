import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';

/// 관심사 선택 칩 위젯
///
/// 온보딩 과정에서 사용자가 관심사를 선택할 수 있는 커스텀 Chip입니다.
/// - 선택되지 않은 상태: 회색 테두리 + 흰색 배경
/// - 선택된 상태: 보라색 배경 + 흰색 텍스트
class InterestChip extends StatelessWidget {
  /// 칩에 표시될 관심사 텍스트
  final String label;

  /// 현재 선택 상태
  final bool isSelected;

  /// 칩 클릭 시 실행될 콜백 함수
  final VoidCallback onTap;

  const InterestChip({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.sm,
        ),
        decoration: BoxDecoration(
          // 선택 시: 보라색 배경, 미선택 시: 흰색 배경
          color: isSelected ? AppColors.primary : AppColors.surface,
          // 선택 시: 테두리 없음, 미선택 시: 회색 테두리
          border: isSelected
              ? null
              : Border.all(color: AppColors.outline, width: 1.w),
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: Text(
          label,
          style: textTheme.labelLarge?.copyWith(
            // 선택 시: 흰색 텍스트, 미선택 시: 기본 텍스트 색상
            color: isSelected ? AppColors.onPrimary : AppColors.textPrimary,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
