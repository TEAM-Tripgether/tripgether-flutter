import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../shared/widgets/buttons/common_button.dart';
import '../../../../shared/widgets/inputs/onboarding_text_field.dart';

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
    final textTheme = Theme.of(context).textTheme;
    final isValid =
        _controller.text.length >= 2 && _controller.text.length <= 10;

    return Padding(
      padding: AppSpacing.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // 상단 공간
          const Spacer(flex: 1),

          // 제목
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '이름을 설정해주세요',
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

          // 제목-입력 간격 (입력을 화면 중앙에 배치)
          const Spacer(flex: 3),

          // 입력 필드 (화면 정중앙)
          OnboardingTextField(
            controller: _controller,
            hintText: '닉네임을 입력하세요',
            maxLength: 10,
            textAlign: TextAlign.center,
            style: textTheme.bodyLarge,
          ),

          // 입력-설명 간격 (좁게)
          AppSpacing.verticalSpaceSM,

          // 설명 (입력 필드 바로 아래)
          Text(
            '다른 유저에게 보이는 이름이에요.\n비속어/광고 문구는 제한돼요.',
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
            onPressed: isValid ? _handleNext : null,
            isFullWidth: true,
          ),

          // 하단 여백 (Flex로 제어)
          const Spacer(flex: 2),
        ],
      ),
    );
  }
}
