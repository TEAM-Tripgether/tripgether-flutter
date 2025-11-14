import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/widgets/buttons/common_button.dart';
import '../../../../shared/widgets/inputs/onboarding_text_field.dart';
import '../../../../l10n/app_localizations.dart';
import '../../providers/onboarding_provider.dart';
import '../widgets/onboarding_layout.dart';

/// 닉네임 설정 페이지 (STEP 2/5)
///
/// 소셜 로그인에서 가져온 닉네임을 기본값으로 제공하며,
/// 사용자가 수정할 수 있습니다 (2-10자).
///
/// **Provider 연동**:
/// - onboardingProvider에 닉네임 저장
/// - welcome_page에서 저장된 닉네임으로 환영 메시지 표시
class NicknamePage extends ConsumerStatefulWidget {
  final VoidCallback onNext;
  final PageController pageController;

  const NicknamePage({
    super.key,
    required this.onNext,
    required this.pageController,
  });

  @override
  ConsumerState<NicknamePage> createState() => _NicknamePageState();
}

class _NicknamePageState extends ConsumerState<NicknamePage> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();

    // onboardingProvider에서 저장된 닉네임 가져오기 (있으면)
    // 처음 진입 시에는 빈 문자열
    final savedNickname = ref.read(onboardingProvider).nickname;
    _controller = TextEditingController(text: savedNickname);
    _controller.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleNext() {
    // 1. 로컬 검증
    if (_controller.text.length >= 2 && _controller.text.length <= 10) {
      // 2. 키보드 내리기
      FocusScope.of(context).unfocus();

      // 3. onboardingProvider에 닉네임 저장
      ref.read(onboardingProvider.notifier).updateNickname(_controller.text);

      // 4. 다음 페이지로 이동
      widget.onNext();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isValid =
        _controller.text.length >= 2 && _controller.text.length <= 10;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        // 빈 공간 클릭 시 키보드 포커스 해제
        FocusScope.of(context).unfocus();
      },
      child: OnboardingLayout(
        stepNumber: 2,
        title: l10n.onboardingNicknamePrompt,
        showRequiredMark: true,
        description: '다른 유저에게 보이는 이름이에요\n비속어/광고 문구는 제한돼요',
        content: Column(
          children: [
            // 입력 필드를 중앙에 배치
            AppSpacing.verticalSpace72,

            // 입력 필드
            Padding(
              padding: EdgeInsets.symmetric(horizontal: AppSpacing.xxxl),
              child: OnboardingTextField(
                controller: _controller,
                hintText: '닉네임을 입력하세요',
                maxLength: 10,
                textAlign: TextAlign.center,
                style: AppTextStyles.bodyMedium16,
              ),
            ),

            const Spacer(),
          ],
        ),
        button: PrimaryButton(
          text: l10n.btnContinue,
          onPressed: isValid ? _handleNext : null,
          isFullWidth: true,
          style: ButtonStyle(
            shape: WidgetStateProperty.all(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppRadius.circle),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
