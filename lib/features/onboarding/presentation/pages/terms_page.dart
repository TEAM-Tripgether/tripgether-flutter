import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/widgets/buttons/common_button.dart';
import '../../../../l10n/app_localizations.dart';
import '../../providers/onboarding_provider.dart';
import '../widgets/onboarding_layout.dart';

/// 약관 동의 페이지 (STEP 1/5)
///
/// **필수 약관**:
/// - 서비스 이용약관
/// - 개인정보 처리방침
/// - 만 14세 이상 확인
///
/// **선택 약관**:
/// - 마케팅 정보 수신 동의
///
/// **검증 규칙**:
/// - 필수 약관 3개 모두 동의해야 다음 단계로 진행 가능
/// - 전체 동의 체크박스: 모든 약관(필수+선택) 일괄 동의
///
/// **Provider 연동**:
/// - onboardingProvider에 약관 동의 상태 저장
class TermsPage extends ConsumerStatefulWidget {
  final VoidCallback onNext;
  final PageController pageController;

  const TermsPage({
    super.key,
    required this.onNext,
    required this.pageController,
  });

  @override
  ConsumerState<TermsPage> createState() => _TermsPageState();
}

class _TermsPageState extends ConsumerState<TermsPage> {
  // 약관 동의 상태 (로컬)
  bool _termsOfService = false;
  bool _privacyPolicy = false;
  bool _ageConfirmation = false;
  bool _marketingConsent = false;

  @override
  void initState() {
    super.initState();
    // onboardingProvider에서 저장된 약관 동의 상태 불러오기
    final savedData = ref.read(onboardingProvider);
    _termsOfService = savedData.termsOfService;
    _privacyPolicy = savedData.privacyPolicy;
    _ageConfirmation = savedData.ageConfirmation;
    _marketingConsent = savedData.marketingConsent;
  }

  /// 전체 동의 상태 확인
  bool get _isAllAgreed =>
      _termsOfService && _privacyPolicy && _ageConfirmation && _marketingConsent;

  /// 필수 약관 동의 상태 확인 (버튼 활성화 조건)
  bool get _isRequiredAgreed =>
      _termsOfService && _privacyPolicy && _ageConfirmation;

  /// 전체 동의 토글 핸들러
  void _handleAgreeAll(bool? value) {
    setState(() {
      _termsOfService = value ?? false;
      _privacyPolicy = value ?? false;
      _ageConfirmation = value ?? false;
      _marketingConsent = value ?? false;
    });
  }

  /// 약관 상세 내용 다이얼로그 표시
  void _showTermsDialog(String title, String content) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: SingleChildScrollView(
          child: Text(content),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('닫기'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return OnboardingLayout(
      stepNumber: 1,
      title: l10n.onboardingTermsPrompt,
      showRequiredMark: true,
      description: l10n.onboardingTermsDescription,
      content: Column(
        children: [
          // 약관 목록 영역을 중앙에 배치
          const Spacer(),

          // 전체 동의 체크박스
          _buildCheckboxTile(
            value: _isAllAgreed,
            onChanged: _handleAgreeAll,
            title: l10n.agreeToAll,
            isBold: true,
            showViewDetails: false,
          ),

          AppSpacing.verticalSpaceSM,

          // 구분선
          Divider(color: AppColors.subColor2, height: 1),

          AppSpacing.verticalSpaceSM,

          // 필수 약관 목록
          _buildCheckboxTile(
            value: _termsOfService,
            onChanged: (value) =>
                setState(() => _termsOfService = value ?? false),
            title: '${l10n.termsOfService} (필수)',
            onViewDetails: () => _showTermsDialog(
              l10n.termsOfService,
              '서비스 이용약관 내용...\n\n향후 실제 약관 내용으로 대체됩니다.',
            ),
          ),

          _buildCheckboxTile(
            value: _privacyPolicy,
            onChanged: (value) =>
                setState(() => _privacyPolicy = value ?? false),
            title: '${l10n.privacyPolicy} (필수)',
            onViewDetails: () => _showTermsDialog(
              l10n.privacyPolicy,
              '개인정보 처리방침 내용...\n\n향후 실제 약관 내용으로 대체됩니다.',
            ),
          ),

          _buildCheckboxTile(
            value: _ageConfirmation,
            onChanged: (value) =>
                setState(() => _ageConfirmation = value ?? false),
            title: '${l10n.ageConfirmation} (필수)',
            showViewDetails: false,
          ),

          AppSpacing.verticalSpaceMD,

          // 선택 약관
          _buildCheckboxTile(
            value: _marketingConsent,
            onChanged: (value) =>
                setState(() => _marketingConsent = value ?? false),
            title: l10n.marketingConsent,
            showViewDetails: false,
          ),

          const Spacer(),
        ],
      ),
      button: PrimaryButton(
        text: l10n.btnContinue,
        onPressed: _isRequiredAgreed
            ? () {
                // onboardingProvider에 약관 동의 상태 저장
                ref.read(onboardingProvider.notifier).updateTermsAgreement(
                      termsOfService: _termsOfService,
                      privacyPolicy: _privacyPolicy,
                      ageConfirmation: _ageConfirmation,
                      marketingConsent: _marketingConsent,
                    );

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

  /// 체크박스 타일 위젯 생성
  Widget _buildCheckboxTile({
    required bool value,
    required ValueChanged<bool?> onChanged,
    required String title,
    bool isBold = false,
    bool showViewDetails = true,
    VoidCallback? onViewDetails,
  }) {
    final l10n = AppLocalizations.of(context);

    return Row(
      children: [
        // 체크박스
        Checkbox(
          value: value,
          onChanged: onChanged,
          activeColor: AppColors.mainColor,
        ),

        // 제목
        Expanded(
          child: GestureDetector(
            onTap: () => onChanged(!value),
            child: Text(
              title,
              style: isBold
                  ? AppTextStyles.titleSemiBold16
                  : AppTextStyles.bodyRegular14,
            ),
          ),
        ),

        // 자세히 보기 버튼
        if (showViewDetails)
          TextButton(
            onPressed: onViewDetails,
            child: Text(
              l10n.viewDetails,
              style: AppTextStyles.buttonMediumMedium14.copyWith(
                color: AppColors.subColor2,
              ),
            ),
          ),
      ],
    );
  }
}
