import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
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
          // 설명과 선택 카드 사이 간격 (닉네임 페이지와 동일)
          AppSpacing.verticalSpace72,

          // 성별 선택 카드들 (남성/여성만)
          Column(
            children: [
              GenderSelectionCard(
                label: l10n.genderMale,
                isSelected: _selectedGender == 'male',
                onTap: () => setState(() => _selectedGender = 'male'),
              ),
              AppSpacing.verticalSpaceLG,
              GenderSelectionCard(
                label: l10n.genderFemale,
                isSelected: _selectedGender == 'female',
                onTap: () => setState(() => _selectedGender = 'female'),
              ),
            ],
          ),

          const Spacer(),
        ],
      ),
      button: Column(
        children: [
          // 건너뛰기 텍스트 버튼 (언더라인 포함)
          TextButton(
            onPressed: () {
              // 성별 선택 없이 건너뛰기
              ref.read(onboardingProvider.notifier).updateGender('NONE');
              widget.onNext();
            },
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: Text(
              l10n.genderSkip,
              style: AppTextStyles.buttonMediumMedium14.copyWith(
                color: AppColors.mainColor,
                decoration: TextDecoration.underline,
                decorationColor: AppColors.mainColor,
              ),
            ),
          ),
          AppSpacing.verticalSpaceLG,
          // 계속하기 버튼 (성별 선택 시에만 활성화)
          PrimaryButton(
            text: l10n.btnContinue,
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
        ],
      ),
    );
  }
}
