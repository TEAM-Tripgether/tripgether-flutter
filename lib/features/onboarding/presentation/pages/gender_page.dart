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
import '../../providers/onboarding_notifier.dart';

/// 성별 선택 페이지 (STEP 4/5)
///
/// 남성, 여성, 선택 안 함 중 선택할 수 있습니다.
/// 선택 사항이므로 선택하지 않아도 다음으로 진행 가능합니다.
///
/// **Provider 연동**:
/// - onboardingProvider에 성별 저장 (MALE, FEMALE, NONE)
class GenderPage extends ConsumerStatefulWidget {
  final VoidCallback onNext;
  final void Function(String currentStep) onStepChange;
  final PageController pageController;

  const GenderPage({
    super.key,
    required this.onNext,
    required this.onStepChange,
    required this.pageController,
  });

  @override
  ConsumerState<GenderPage> createState() => _GenderPageState();
}

class _GenderPageState extends ConsumerState<GenderPage> {
  // 로컬 상태: 선택된 성별 ('male', 'female', 'notSelected', null)
  String? _selectedGender;

  // API 호출 로딩 상태
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // onboardingProvider에서 저장된 성별 불러오기
    final savedGender = ref.read(onboardingProvider).gender;
    if (savedGender != 'NONE') {
      _selectedGender = savedGender.toLowerCase();
    }
  }

  /// 계속하기 버튼 핸들러 (API 호출)
  Future<void> _handleContinue() async {
    if (_selectedGender == null || _isLoading) return;

    setState(() => _isLoading = true);

    try {
      // 1. 성별 값 변환
      final genderValue = _selectedGender == 'male'
          ? 'MALE'
          : _selectedGender == 'female'
              ? 'FEMALE'
              : 'NONE';

      // 2. onboardingProvider에 성별 저장 (로컬)
      ref.read(onboardingProvider.notifier).updateGender(genderValue);

      // 3. API 호출
      final response = await ref
          .read(onboardingNotifierProvider.notifier)
          .updateGender(gender: genderValue);

      if (!mounted) return;

      // 4. API 응답 성공 시 currentStep에 따라 페이지 이동
      if (response != null) {
        debugPrint('[GenderPage] ✅ 성별 설정 API 호출 성공 → 다음 단계: ${response.currentStep}');
        widget.onStepChange(response.currentStep);
      } else {
        // API 호출 실패 - 사용자 친화적 에러 메시지
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                '성별 설정 중 오류가 발생했습니다.\n잠시 후 다시 시도해주세요.',
                style: AppTextStyles.bodyMedium14.copyWith(color: AppColors.white),
              ),
              backgroundColor: AppColors.error,
              duration: const Duration(seconds: 3),
              behavior: SnackBarBehavior.floating,
              margin: EdgeInsets.all(AppSpacing.lg),
              action: SnackBarAction(
                label: '확인',
                textColor: AppColors.white,
                onPressed: () {},
              ),
            ),
          );
        }
      }
    } catch (e) {
      debugPrint('[GenderPage] ❌ 성별 설정 API 호출 실패: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('오류가 발생했습니다: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  /// 건너뛰기 버튼 핸들러 (API 호출)
  Future<void> _handleSkip() async {
    if (_isLoading) return;

    setState(() => _isLoading = true);

    try {
      // 1. onboardingProvider에 성별 저장 (로컬)
      ref.read(onboardingProvider.notifier).updateGender('NONE');

      // 2. API 호출
      final response = await ref
          .read(onboardingNotifierProvider.notifier)
          .updateGender(gender: 'NONE');

      if (!mounted) return;

      // 3. API 응답 성공 시 currentStep에 따라 페이지 이동
      if (response != null) {
        debugPrint('[GenderPage] ✅ 성별 건너뛰기 API 호출 성공 → 다음 단계: ${response.currentStep}');
        widget.onStepChange(response.currentStep);
      } else {
        // API 호출 실패
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('처리 중 오류가 발생했습니다. 다시 시도해주세요.'),
              backgroundColor: AppColors.error,
            ),
          );
        }
      }
    } catch (e) {
      debugPrint('[GenderPage] ❌ 성별 건너뛰기 API 호출 실패: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('오류가 발생했습니다: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
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
            onPressed: !_isLoading ? _handleSkip : null,
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
            onPressed: _selectedGender != null && !_isLoading ? _handleContinue : null,
            isLoading: _isLoading,
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
