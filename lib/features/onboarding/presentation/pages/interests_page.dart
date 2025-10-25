import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../shared/widgets/buttons/common_button.dart';
import '../constants/interest_categories.dart';
import '../widgets/interest_chip.dart';

/// 관심사 선택 페이지 (페이지 4/5)
///
/// 14개 카테고리에서 최소 3개, 최대 10개의 관심사를 선택할 수 있습니다.
/// Accordion 방식으로 한 번에 하나의 카테고리만 열립니다.
///
/// 로컬 상태로 관리:
/// - _selectedInterests: 선택된 관심사 Set<String
/// - _expandedCategoryId: 현재 열려있는 카테고리 ID
class InterestsPage extends StatefulWidget {
  final VoidCallback onNext;
  final PageController pageController;

  const InterestsPage({
    super.key,
    required this.onNext,
    required this.pageController,
  });

  @override
  State<InterestsPage> createState() => _InterestsPageState();
}

class _InterestsPageState extends State<InterestsPage> {
  // 로컬 상태: 선택된 관심사들
  final Set<String> _selectedInterests = {};

  // 현재 열려있는 카테고리 ID (한 번에 하나만 열림)
  String? _expandedCategoryId;

  void _toggleCategory(String categoryId) {
    setState(() {
      _expandedCategoryId = _expandedCategoryId == categoryId
          ? null
          : categoryId;
    });
  }

  void _handleInterestTap(String interest) {
    setState(() {
      if (_selectedInterests.contains(interest)) {
        _selectedInterests.remove(interest);
      } else {
        if (_selectedInterests.length < 10) {
          _selectedInterests.add(interest);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final selectedCount = _selectedInterests.length;
    final isValid = selectedCount >= 3 && selectedCount <= 10;

    return Padding(
      padding: AppSpacing.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // 상단 공간
          const Spacer(flex: 1),

          // 제목 (고정)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '관심사를 선택해주세요',
                style: textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              AppSpacing.horizontalSpace(4),
              Text(
                '*',
                style: textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppColors.error,
                ),
              ),
            ],
          ),

          AppSpacing.verticalSpaceMD,

          // 선택 개수 표시
          Text(
            '$selectedCount개 선택',
            style: textTheme.titleMedium?.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.w600,
            ),
          ),

          AppSpacing.verticalSpaceLG,

          // 카테고리 목록 영역 (스크롤 가능, Flex로 남은 공간 차지)
          Expanded(
            flex: 8,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 카테고리 목록
                  ...interestCategories.map((category) {
                    final isExpanded = _expandedCategoryId == category.id;

                    return Column(
                      children: [
                        // 카테고리 헤더 (드롭다운 버튼)
                        InkWell(
                          onTap: () => _toggleCategory(category.id),
                          child: Container(
                            padding: AppSpacing.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                            decoration: BoxDecoration(
                              border: Border.all(color: AppColors.outline),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  category.name,
                                  style: textTheme.titleSmall,
                                ),
                                Icon(
                                  isExpanded
                                      ? Icons.keyboard_arrow_up
                                      : Icons.keyboard_arrow_down,
                                  color: AppColors.textSecondary,
                                ),
                              ],
                            ),
                          ),
                        ),

                        // 카테고리 하위 항목 (Chip들)
                        if (isExpanded) ...[
                          AppSpacing.verticalSpaceSM,
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: category.items.map((item) {
                              final isSelected = _selectedInterests.contains(
                                item,
                              );
                              return InterestChip(
                                label: item,
                                isSelected: isSelected,
                                onTap: () => _handleInterestTap(item),
                              );
                            }).toList(),
                          ),
                        ],

                        AppSpacing.verticalSpaceMD,
                      ],
                    );
                  }),

                  AppSpacing.verticalSpaceLG,

                  // 설명
                  Text(
                    '선택한 관심사는 언제든 설정에서 바꿀 수 있어요.',
                    style: textTheme.bodySmall?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // 계속하기 버튼
          PrimaryButton(
            text: '완료하기',
            onPressed: isValid ? widget.onNext : null,
            isFullWidth: true,
          ),

          // 하단 여백 (Flex로 제어)
          const Spacer(flex: 1),
        ],
      ),
    );
  }
}
