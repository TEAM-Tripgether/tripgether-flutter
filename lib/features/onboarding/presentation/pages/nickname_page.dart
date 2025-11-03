import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/widgets/buttons/common_button.dart';
import '../../../../shared/widgets/inputs/onboarding_text_field.dart';
import '../../../../l10n/app_localizations.dart';

/// 닉네임 설정 페이지 (페이지 1/5)
///
/// 소셜 로그인에서 가져온 닉네임을 기본값으로 제공하며,
/// 사용자가 수정할 수 있습니다 (2-10자).
class NicknamePage extends StatefulWidget {
  final VoidCallback onNext;
  final PageController pageController;

  const NicknamePage({
    super.key,
    required this.onNext,
    required this.pageController,
  });

  @override
  State<NicknamePage> createState() => _NicknamePageState();
}

class _NicknamePageState extends State<NicknamePage> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    // TODO: 실제로는 Google에서 가져온 닉네임으로 초기화
    _controller = TextEditingController(text: 'Kevin');
    _controller.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleNext() {
    // UI만 구현: 로컬 검증만 수행
    if (_controller.text.length >= 2 && _controller.text.length <= 10) {
      widget.onNext();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isValid =
        _controller.text.length >= 2 && _controller.text.length <= 10;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppSpacing.xxl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // 상단 여백 (위로 올림)
          AppSpacing.verticalSpaceHuge,

          // 제목 (국제화 적용)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.onboardingNicknamePrompt,
                style: AppTextStyles.headlineMedium.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppColors.gradientMiddle, // #5325CB - 선명한 보라색
                ),
              ),
              AppSpacing.horizontalSpace(4),
              Text(
                '*',
                style: AppTextStyles.headlineMedium.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppColors.error,
                ),
              ),
            ],
          ),

          // 제목-설명 간격
          AppSpacing.verticalSpaceSM,

          // 설명 (제목 바로 아래)
          Text(
            '다른 유저에게 보이는 이름이에요\n비속어/광고 문구는 제한돼요',
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.onboardingDescription, // #130537 - 진한 남보라
            ),
            textAlign: TextAlign.center,
          ),

          // 입력 필드를 중앙에 배치하기 위한 여백
          const Spacer(),

          // 입력 필드
          OnboardingTextField(
            controller: _controller,
            hintText: '닉네임을 입력하세요',
            maxLength: 10,
            textAlign: TextAlign.center,
            style: AppTextStyles.bodyLarge,
          ),

          // 입력-버튼 간격
          const Spacer(),

          // 계속하기 버튼 (국제화 적용)
          PrimaryButton(
            text: l10n.btnContinue,
            onPressed: isValid ? _handleNext : null,
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
