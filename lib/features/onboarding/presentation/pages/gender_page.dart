import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../shared/widgets/buttons/common_button.dart';
import '../widgets/gender_selection_card.dart';

/// 성별 선택 페이지 (페이지 3/5)
///
/// 남성, 여성, 선택 안 함 중 선택할 수 있습니다.
/// 선택 사항이므로 선택하지 않아도 다음으로 진행 가능합니다.
///
/// 로컬 상태로 관리:
/// - _selectedGender: 현재 선택된 성별 ('male', 'female', 'notSelected', null)
class GenderPage extends StatefulWidget {
  final VoidCallback onNext;
  final PageController pageController;

  const GenderPage({
    super.key,
    required this.onNext,
    required this.pageController,
  });

  @override
  State<GenderPage> createState() => _GenderPageState();
}

class _GenderPageState extends State<GenderPage> {
  // 로컬 상태: 선택된 성별 ('male', 'female', 'notSelected', null)
  String? _selectedGender;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: AppSpacing.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // 상단 공간
          const Spacer(flex: 1),

          // 제목
          Text(
            '성별을 선택해주세요. (선택)',
            style: textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),

          // 제목-선택 간격
          const Spacer(flex: 3),

          // 성별 선택 카드들
          Column(
            children: [
              GenderSelectionCard(
                label: '남성',
                isSelected: _selectedGender == 'male',
                onTap: () => setState(() => _selectedGender = 'male'),
              ),
              AppSpacing.verticalSpaceMD,
              GenderSelectionCard(
                label: '여성',
                isSelected: _selectedGender == 'female',
                onTap: () => setState(() => _selectedGender = 'female'),
              ),
              AppSpacing.verticalSpaceMD,
              GenderSelectionCard(
                label: '선택 안 함',
                isSelected: _selectedGender == 'notSelected',
                onTap: () => setState(() => _selectedGender = 'notSelected'),
              ),
            ],
          ),

          // 선택-설명 간격 (좁게)
          AppSpacing.verticalSpaceSM,

          // 설명
          Text(
            '여행 추천 개인화에 활용돼요.',
            style: textTheme.bodySmall?.copyWith(
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),

          // 설명-버튼 간격 (입력 중앙 유지)
          const Spacer(flex: 3),

          // 계속하기 버튼
          PrimaryButton(
            text: '계속하기',
            onPressed: widget.onNext,
            isFullWidth: true,
          ),

          // 하단 여백 (Flex로 제어)
          const Spacer(flex: 2),
        ],
      ),
    );
  }
}
