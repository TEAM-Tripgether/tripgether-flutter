import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/router/routes.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../shared/widgets/buttons/common_button.dart';
import '../../../../l10n/app_localizations.dart';
import '../../providers/onboarding_provider.dart';

/// 온보딩 완료 화면 (페이지 5/5)
///
/// 환영 메시지와 함께 그라데이션 배경을 표시하며,
/// "Tripgether 시작하기" 버튼으로 홈 화면으로 이동합니다.
///
/// **Provider 연동**:
/// - onboardingProvider에서 입력받은 닉네임을 사용하여 개인화된 환영 메시지 표시
/// - 닉네임이 없으면 국제화된 플레이스홀더 사용
class WelcomePage extends ConsumerWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);

    // onboardingProvider에서 닉네임 가져오기
    final onboardingData = ref.watch(onboardingProvider);
    final nickname = onboardingData.nickname;

    return Container(
      width: double.infinity,
      height: double.infinity,
      // 대각선 그라데이션 배경 (선명한 보라 → 밝은 연보라 → 흰색)
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.gradient2, // #5325CB - 선명한 보라
            AppColors.gradient3, // #B599FF - 밝은 연보라
            AppColors.white, // #FFFFFF - 흰색
          ],
          stops: const [0.0, 0.5, 0.85], // 50% : 35% : 15% 비율
        ),
      ),
      child: SafeArea(
        top: false, // 상단은 SafeArea 제외 (전체 화면 그라데이션)
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: AppSpacing.xxxl,
          ), // 32px (OnboardingLayout과 동일)
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // 상단 유연한 여백 (중앙 배치를 위한 균형)
              const Spacer(flex: 2),

              // 체크 아이콘 (PNG)
              Image.asset('assets/icons/check.png', width: 66.w, height: 66.h),

              // 아이콘과 메시지 사이 40px 간격
              AppSpacing.verticalSpaceHuge,

              // 통합 환영 메시지 (닉네임 포함)
              Text(
                l10n.onboardingWelcomeUnified(
                  nickname.isNotEmpty ? nickname : l10n.defaultNickname,
                ),
                style: AppTextStyles.greetingSemiBold20.copyWith(
                  color: AppColors.white,
                ),
                textAlign: TextAlign.center,
              ),

              // 하단 유연한 여백 (버튼을 하단에 배치)
              const Spacer(flex: 3),

              // SNS 장소추출 튜토리얼 버튼 (테두리 버튼, 국제화 적용)
              OutlinedButton(
                onPressed: () {
                  // TODO: 튜토리얼 화면으로 이동
                },
                style: OutlinedButton.styleFrom(
                  minimumSize: Size(double.infinity, 48.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppRadius.circle),
                  ),
                  side: BorderSide(
                    color: AppColors.gradient2, // #5325CB - 선명한 보라 테두리
                    width: 2.w,
                  ),
                ),
                child: Text(
                  l10n.snsPlaceExtractionTutorial,
                  style: AppTextStyles.bodyMedium16.copyWith(
                    color: AppColors.mainColor, // #5325CB - 선명한 보라 텍스트
                  ),
                ),
              ),

              AppSpacing.verticalSpaceLG,

              // 시작하기 버튼 (mainColor 배경 + 흰색 텍스트)
              PrimaryButton(
                text: l10n.startNow,
                onPressed: () => context.go(AppRoutes.home),
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

              // 하단 여백 (OnboardingLayout과 동일한 80px)
              AppSpacing.verticalSpace80,
            ],
          ),
        ),
      ),
    );
  }
}
