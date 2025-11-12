import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';

/// 관심사 카테고리 드롭다운 버튼 위젯
///
/// **특징**:
/// - 회색 pill 모양 배경
/// - 텍스트 길이에 따라 너비 자동 조절 (intrinsicWidth)
/// - 드롭다운 아이콘 우측에 표시 (열림/닫힘 상태에 따라 ▲/▼)
/// - 탭 시 드롭다운 토글
///
/// **디자인 (2025-11-02)**:
/// - 배경색: Colors.grey.withValues(alpha: 0.1) (연한 회색)
/// - 테두리: 없음
/// - Border Radius: AppRadius.circle (완전한 pill 모양)
/// - 패딩: 좌우 16, 상하 12
/// - 아이콘:
///   - 닫힌 상태: Icons.keyboard_arrow_down (▼)
///   - 열린 상태: Icons.keyboard_arrow_up (▲)
///
/// **사용 예시**:
/// ```dart
/// CategoryDropdownButton(
///   categoryName: '맛집/푸드',
///   isExpanded: _expandedCategoryId == category.id,
///   onTap: () => _toggleCategory(category.id),
/// )
/// ```
class CategoryDropdownButton extends StatelessWidget {
  /// 카테고리 이름 (화면에 표시될 텍스트)
  final String categoryName;

  /// 현재 열린 상태인지 여부 (true = 열림 ▲, false = 닫힘 ▼)
  final bool isExpanded;

  /// 선택된 관심사 개수 (1개 이상이면 강조 표시)
  final int selectedCount;

  /// 버튼 탭 시 실행될 콜백 함수
  final VoidCallback onTap;

  const CategoryDropdownButton({
    super.key,
    required this.categoryName,
    required this.isExpanded,
    this.selectedCount = 0,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        // 패딩: 좌우 16, 상하 12
        padding: AppSpacing.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          // 우선순위: 열린 상태 > 선택된 항목 있음 > 기본 상태
          color: isExpanded
              ? AppColors
                    .primaryContainer // #E8DDFF - 연한 보라색 (열린 상태)
              : selectedCount > 0
              ? AppColors
                    .primaryContainer // #E8DDFF - 연한 보라색 (선택됨)
              : Colors.grey.withValues(alpha: 0.1), // 연한 회색 (기본)
          // 열린 상태 또는 선택된 항목 있음: 보라색 테두리
          border: (isExpanded || selectedCount > 0)
              ? Border.all(
                  color: AppColors.primary, // #664BAE - 보라색
                  width: 2,
                )
              : null,
          // 완전한 pill 모양
          borderRadius: BorderRadius.circular(AppRadius.circle),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min, // 텍스트 길이에 맞춰 너비 자동 조절
          children: [
            // 카테고리 이름 텍스트
            Text(
              categoryName,
              style: AppTextStyles.bodyRegular14.copyWith(
                fontWeight: FontWeight.w500,
                // 우선순위: 열린 상태 > 선택된 항목 있음 > 기본 상태
                color: isExpanded
                    ? AppColors
                          .gradientMiddle // #5325CB - 선명한 보라색 (열린 상태)
                    : selectedCount > 0
                    ? AppColors
                          .gradientMiddle // #5325CB - 선명한 보라색 (선택됨)
                    : AppColors.subColor2, // #BBBBBB - 회색 (기본)
              ),
            ),

            // 텍스트-아이콘 간격
            AppSpacing.horizontalSpace(4),

            // 드롭다운 아이콘 (열림/닫힘 상태에 따라 ▲/▼)
            Icon(
              isExpanded
                  ? Icons
                        .keyboard_arrow_up // 열린 상태: ▲
                  : Icons.keyboard_arrow_down, // 닫힌 상태: ▼
              size: AppSizes.iconSmall, // 18px
              color: AppColors.textSecondary,
            ),
          ],
        ),
      ),
    );
  }
}
