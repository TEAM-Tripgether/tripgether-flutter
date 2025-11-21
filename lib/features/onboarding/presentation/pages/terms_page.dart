import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/widgets/buttons/common_button.dart';
import '../../../../l10n/app_localizations.dart';
import '../../providers/onboarding_provider.dart';
import '../../providers/onboarding_notifier.dart';
import '../../utils/onboarding_error_handler.dart';
import '../widgets/onboarding_layout.dart';

/// 약관 동의 페이지 (STEP 1/6)
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
  final void Function(String currentStep) onStepChange;
  final PageController pageController;

  const TermsPage({
    super.key,
    required this.onNext,
    required this.onStepChange,
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

  // API 호출 로딩 상태
  bool _isLoading = false;

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
      _termsOfService &&
      _privacyPolicy &&
      _ageConfirmation &&
      _marketingConsent;

  /// 필수 약관 동의 상태 확인 (버튼 활성화 조건)
  bool get _isRequiredAgreed =>
      _termsOfService && _privacyPolicy && _ageConfirmation;

  /// 계속하기 버튼 핸들러 (API 호출)
  Future<void> _handleContinue() async {
    if (_isLoading) return;

    setState(() => _isLoading = true);

    try {
      // 1. onboardingProvider에 약관 동의 상태 저장 (로컬)
      ref.read(onboardingProvider.notifier).updateTermsAgreement(
            termsOfService: _termsOfService,
            privacyPolicy: _privacyPolicy,
            ageConfirmation: _ageConfirmation,
            marketingConsent: _marketingConsent,
          );

      // 2. API 호출
      final response = await ref
          .read(onboardingNotifierProvider.notifier)
          .agreeTerms(
            isServiceTermsAndPrivacyAgreed: _isRequiredAgreed,
            isMarketingAgreed: _marketingConsent,
          );

      if (!mounted) return;

      // 3. API 응답 성공 시 currentStep에 따라 페이지 이동
      if (response != null) {
        debugPrint('[TermsPage] ✅ 약관 동의 API 호출 성공 → 다음 단계: ${response.currentStep}');
        widget.onStepChange(response.currentStep);
      } else {
        // API 호출 실패 - 사용자 친화적 에러 메시지
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                '약관 동의 처리 중 오류가 발생했습니다.\n잠시 후 다시 시도해주세요.',
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
      debugPrint('[TermsPage] ❌ 약관 동의 API 호출 실패: $e');
      if (mounted) {
        await handleOnboardingError(context, ref, e);
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

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
        content: SingleChildScrollView(child: Text(content)),
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
          // 상단 고정 간격
          AppSpacing.verticalSpace72,

          // 전체 동의 (강조 컨테이너)
          _buildCheckboxTile(
            value: _isAllAgreed,
            onChanged: _handleAgreeAll,
            title: l10n.agreeToAll,
            showViewDetails: false,
            backgroundColor: AppColors.subColor2.withValues(alpha: 0.2),
          ),

          AppSpacing.verticalSpaceSM, // 8px
          // 필수 약관 1
          _buildCheckboxTile(
            value: _termsOfService,
            onChanged: (value) =>
                setState(() => _termsOfService = value ?? false),
            title: '${l10n.termsOfService} *',
            onViewDetails: () => _showTermsDialog(
              l10n.termsOfService,
              '서비스 이용약관 내용...\n\n향후 실제 약관 내용으로 대체됩니다.',
            ),
          ),

          AppSpacing.verticalSpaceSM, // 8px
          // 필수 약관 2
          _buildCheckboxTile(
            value: _privacyPolicy,
            onChanged: (value) =>
                setState(() => _privacyPolicy = value ?? false),
            title: '${l10n.privacyPolicy} *',
            onViewDetails: () => _showTermsDialog(
              l10n.privacyPolicy,
              '개인정보 처리방침 내용...\n\n향후 실제 약관 내용으로 대체됩니다.',
            ),
          ),

          AppSpacing.verticalSpaceSM, // 8px
          // 필수 약관 3
          _buildCheckboxTile(
            value: _ageConfirmation,
            onChanged: (value) =>
                setState(() => _ageConfirmation = value ?? false),
            title: '${l10n.ageConfirmation} *',
            onViewDetails: () => _showTermsDialog(
              l10n.ageConfirmation,
              '만 14세 이상 확인 내용...\n\n향후 실제 약관 내용으로 대체됩니다.',
            ),
          ),

          AppSpacing.verticalSpaceSM, // 8px
          // 선택 약관
          _buildCheckboxTile(
            value: _marketingConsent,
            onChanged: (value) =>
                setState(() => _marketingConsent = value ?? false),
            title: '[선택] ${l10n.marketingConsent}',
            onViewDetails: () => _showTermsDialog(
              l10n.marketingConsent,
              '마케팅 정보 수신 동의 내용...\n\n향후 실제 약관 내용으로 대체됩니다.',
            ),
          ),

          // 하단 동적 간격
          const Spacer(),
        ],
      ),
      button: PrimaryButton(
        text: l10n.btnContinue,
        onPressed: _isRequiredAgreed && !_isLoading ? _handleContinue : null,
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
    );
  }

  /// 체크박스 타일 위젯 생성
  Widget _buildCheckboxTile({
    required bool value,
    required ValueChanged<bool?> onChanged,
    required String title,
    TextStyle? textStyle,
    bool showViewDetails = true,
    VoidCallback? onViewDetails,
    Color? backgroundColor,
    BorderRadius? borderRadius,
    EdgeInsets? padding,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor ?? Colors.transparent,
        borderRadius: borderRadius ?? AppRadius.allMedium,
      ),
      padding:
          padding ??
          EdgeInsets.symmetric(
            vertical: AppSpacing.xs,
            horizontal: AppSpacing.xs,
          ),
      child: Row(
        children: [
          // 터치 영역 확대: 체크박스부터 아이콘 버튼 전까지
          Expanded(
            child: InkWell(
              onTap: () => onChanged(!value),
              borderRadius: borderRadius ?? AppRadius.allSmall,
              child: Row(
                children: [
                  // 체크박스 (IgnorePointer로 감싸서 활성 스타일 유지)
                  IgnorePointer(
                    child: Transform.scale(
                      scale: 1.2, // 체크박스 크기 확대
                      child: Checkbox(
                        value: value,
                        onChanged: onChanged, // 활성 상태 유지 (스타일 적용)
                        activeColor: AppColors.mainColor, // 체크 시 mainColor
                        checkColor: AppColors.white, // 체크 아이콘 흰색
                        shape: RoundedRectangleBorder(
                          borderRadius: AppRadius.allSmall, // 4px radius
                        ),
                        side: BorderSide(
                          color: AppColors.subColor2,
                          width: AppSizes.borderMedium,
                        ),
                      ),
                    ),
                  ),
                  // 제목
                  Expanded(
                    child: Text(
                      title,
                      style: textStyle ?? AppTextStyles.bodyMedium16,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // 자세히 보기 아이콘
          if (showViewDetails)
            IconButton(
              onPressed: onViewDetails,
              icon: Icon(
                Icons.arrow_forward_ios_rounded,
                size: AppSizes.iconSmall, // 16px
                color: AppColors.textColor1.withValues(alpha: 0.4),
              ),
              constraints: const BoxConstraints(),
            ),
        ],
      ),
    );
  }
}
