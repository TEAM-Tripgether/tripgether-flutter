import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/widgets/buttons/common_button.dart';
import '../widgets/gender_selection_card.dart';
import '../../../../l10n/app_localizations.dart';
import '../../providers/onboarding_provider.dart';

/// 성별 선택 페이지 (페이지 3/5)
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

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppSpacing.xxl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // 상단 여백 (위로 올림)
          AppSpacing.verticalSpaceHuge,

          // 제목 (국제화 적용)
          Text(
            l10n.onboardingGenderPrompt,
            style: AppTextStyles.headlineMedium.copyWith(
              fontWeight: FontWeight.w600,
              color: AppColors.gradientMiddle, // #5325CB - 선명한 보라색
            ),
          ),

          // 제목-설명 간격
          AppSpacing.verticalSpaceSM,

          // 설명 (제목 바로 아래, 국제화 적용)
          Text(
            l10n.onboardingGenderDescription,
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.onboardingDescription, // #130537 - 진한 남보라
            ),
            textAlign: TextAlign.center,
          ),

          // 선택 카드를 중앙에 배치하기 위한 여백
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

          // 선택-버튼 간격
          const Spacer(),

          // 계속하기 버튼 (국제화 적용)
          PrimaryButton(
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
            // 소셜 로그인 버튼과 동일한 완전한 pill 모양 적용
            style: ButtonStyle(
              shape: WidgetStateProperty.all(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppRadius.circle),
                ),
              ),
            ),
          ),

          // 하단 여백 (버튼을 조금 위로)
          AppSpacing.verticalSpace60,
        ],
      ),
    );
  }
}
