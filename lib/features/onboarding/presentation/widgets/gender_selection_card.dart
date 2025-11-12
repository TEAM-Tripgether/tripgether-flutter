import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';

/// 성별 선택 카드 위젯
///
/// 온보딩 과정에서 사용자가 성별을 선택할 수 있는 커스텀 카드입니다.
/// - 선택되지 않은 상태: 회색 테두리 + 흰색 배경
/// - 선택된 상태: 보라색 테두리 (두껍게) + 연한 보라색 배경
class GenderSelectionCard extends StatelessWidget {
  /// 카드에 표시될 성별 텍스트 (예: "남성", "여성", "선택 안 함")
  final String label;

  /// 현재 선택 상태
  final bool isSelected;

  /// 카드 클릭 시 실행될 콜백 함수
  final VoidCallback onTap;

  const GenderSelectionCard({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.lg,
        ),
        decoration: BoxDecoration(
          // 선택 시: 연한 보라색 배경, 미선택 시: 흰색 배경
          color: isSelected ? AppColors.primaryContainer : AppColors.surface,
          // 선택 시: 두꺼운 보라색 테두리, 미선택 시: 얇은 회색 테두리
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.subColor2,
            width: isSelected ? 2.w : 1.w,
          ),
          // 소셜 로그인 버튼과 동일한 완전한 pill 모양 적용
          borderRadius: BorderRadius.circular(AppRadius.circle),
        ),
        child: Center(
          child: Text(
            label,
            style: AppTextStyles.sectionTitle.copyWith(
              // 선택 시: 보라색 텍스트, 미선택 시: 기본 텍스트 색상
              color: isSelected ? AppColors.primary : AppColors.textPrimary,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}
