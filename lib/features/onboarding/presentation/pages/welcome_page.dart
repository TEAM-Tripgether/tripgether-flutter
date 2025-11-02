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
import '../../../auth/providers/user_provider.dart';

/// 온보딩 완료 화면 (페이지 5/5)
///
/// 환영 메시지와 함께 그라데이션 배경을 표시하며,
/// "Tripgether 시작하기" 버튼으로 홈 화면으로 이동합니다.
/// Google 로그인으로 받은 닉네임을 동적으로 표시합니다.
class WelcomePage extends ConsumerWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);

    // UserNotifierProvider에서 사용자 정보 가져오기
    final userAsync = ref.watch(userNotifierProvider);

    // 사용자 닉네임 추출 (로딩 중이거나 없으면 기본값 "Kevin" 사용)
    final nickname = userAsync.when(
      data: (user) => user?.nickname ?? 'Kevin',
      loading: () => 'Kevin',
      error: (_, stack) => 'Kevin',
    );

    return Container(
      width: double.infinity,
      height: double.infinity,
      // 대각선 그라데이션 배경 (선명한 보라 → 밝은 연보라 → 흰색)
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.gradientMiddle, // #5325CB - 선명한 보라
            AppColors.gradientEnd, // #B599FF - 밝은 연보라
            AppColors.onPrimary, // #FFFFFF - 흰색
          ],
          stops: const [0.0, 0.5, 0.85], // 50% : 35% : 15% 비율
        ),
      ),
      // SafeArea를 제거하여 상단부터 전체 화면 사용
      child: Padding(
        padding: AppSpacing.symmetric(horizontal: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 상단 유연한 여백 (중앙 배치를 위한 균형)
            const Spacer(flex: 2),

            // 체크 아이콘 (PNG)
            Image.asset('assets/icons/check.png', width: 66.w, height: 66.h),

            AppSpacing.verticalSpaceHuge,

            // 환영 메시지
            Text(
              l10n.onboardingWelcomeTitle,
              style: AppTextStyles.headlineLarge.copyWith(
                fontWeight: FontWeight.w700,
                color: AppColors.onPrimary,
              ),
              textAlign: TextAlign.center,
            ),

            AppSpacing.verticalSpaceMD,

            // 설명 메시지 (동적 닉네임 + 국제화 적용)
            Text(
              l10n.onboardingWelcomeDescription(nickname),
              style: AppTextStyles.titleMedium.copyWith(
                color: AppColors.onPrimary.withValues(alpha: 0.9),
              ),
              textAlign: TextAlign.center,
            ),

            // 하단 유연한 여백 (버튼을 하단에 배치)
            const Spacer(flex: 3),

            // 버튼 영역 (SafeArea로 하단 안전 영역 보호)
            SafeArea(
              top: false, // 상단은 SafeArea 적용 안 함 (그라데이션이 상단까지 확장)
              child: Column(
                children: [
                  // SNS 장소추출 튜토리얼 버튼 (테두리 버튼, 국제화 적용)
                  OutlinedButton(
                    onPressed: () {
                      // TODO: 튜토리얼 화면으로 이동
                    },
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 48),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppRadius.circle),
                      ),
                      side: BorderSide(
                        color: AppColors.gradientMiddle, // #5325CB - 선명한 보라 테두리
                        width: 2,
                      ),
                    ),
                    child: Text(
                      l10n.snsPlaceExtractionTutorial,
                      style: AppTextStyles.bodyLarge.copyWith(
                        color: AppColors.gradientMiddle, // #5325CB - 선명한 보라 텍스트
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),

                  AppSpacing.verticalSpaceMD,

                  // 시작하기 버튼 (흰색 배경 + 보라색 텍스트)
                  PrimaryButton(
                    text: l10n.startTripgether,
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
                ],
              ),
            ),

            AppSpacing.verticalSpaceXXL,
          ],
        ),
      ),
    );
  }
}
