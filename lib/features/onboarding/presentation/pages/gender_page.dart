import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../shared/widgets/buttons/common_button.dart';
import '../widgets/gender_selection_card.dart';
import '../widgets/onboarding_layout.dart';
import '../../../../l10n/app_localizations.dart';
import '../../providers/onboarding_provider.dart';

/// 성별 선택 페이지 (STEP 4/5)
///
/// 남성, 여성, 선택 안 함 중 선택할 수 있습니다.
/// 선택 사항이므로 선택하지 않아도 다음으로 진행 가능합니다.
///
/// **Provider 연동**:
/// - onboardingProvider에 성별 저장 (MALE, FEMALE, NONE)
class GenderPage extends ConsumerStatefulWidget {
  final VoidCallback onNext;
  final PageController pageController;

  const GenderPage({
    super.key,
    required this.onNext,
    required this.pageController,
  });

  @override
  ConsumerState<GenderPage> createState() => _GenderPageState();
}

class _GenderPageState extends ConsumerState<GenderPage> {
  // 로컬 상태: 선택된 성별 ('male', 'female', 'notSelected', null)
  String? _selectedGender;

  @override
  void initState() {
    super.initState();
    // onboardingProvider에서 저장된 성별 불러오기
    final savedGender = ref.read(onboardingProvider).gender;
    if (savedGender != 'NONE') {
      _selectedGender = savedGender.toLowerCase();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return OnboardingLayout(
      stepNumber: 4,
      title: l10n.onboardingGenderPrompt,
      showRequiredMark: false,
      description: l10n.onboardingGenderDescription,
      content: Column(
        children: [
          // 선택 카드를 중앙에 배치
          const Spacer(),

          // 성별 선택 카드들 (국제화 적용)
          Column(
            children: [
              GenderSelectionCard(
                label: l10n.genderMale,
                isSelected: _selectedGender == 'male',
                onTap: () => setState(() => _selectedGender = 'male'),
              ),
              AppSpacing.verticalSpaceMD,
              GenderSelectionCard(
                label: l10n.genderFemale,
                isSelected: _selectedGender == 'female',
                onTap: () => setState(() => _selectedGender = 'female'),
              ),
              AppSpacing.verticalSpaceMD,
              GenderSelectionCard(
                label: l10n.genderSkip,
                isSelected: _selectedGender == 'notSelected',
                onTap: () => setState(() => _selectedGender = 'notSelected'),
              ),
            ],
          ),

          const Spacer(),
        ],
      ),
      button: PrimaryButton(
        text: l10n.btnContinue,
        // 성별을 선택해야만 활성화 (null이 아닐 때만)
        onPressed: _selectedGender != null
            ? () {
                // onboardingProvider에 성별 저장
                final genderValue = _selectedGender == 'male'
                    ? 'MALE'
                    : _selectedGender == 'female'
                    ? 'FEMALE'
                    : 'NONE';
                ref
                    .read(onboardingProvider.notifier)
                    .updateGender(genderValue);

                // 다음 페이지로 이동
                widget.onNext();
              }
            : null,
        isFullWidth: true,
        style: ButtonStyle(
          shape: WidgetStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppRadius.circle),
            ),
          ),
        ),
      ),
    );
  }
}
