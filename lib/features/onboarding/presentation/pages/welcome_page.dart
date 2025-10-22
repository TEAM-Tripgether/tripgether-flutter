import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/router/routes.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../shared/widgets/buttons/common_button.dart';

/// 온보딩 완료 화면 (페이지 5/5)
///
/// 환영 메시지와 함께 그라데이션 배경을 표시하며,
/// "Tripgether 시작하기" 버튼으로 홈 화면으로 이동합니다.
class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      width: double.infinity,
      height: double.infinity,
      // 그라데이션 배경 (HomeHeader와 동일)
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: AppColorPalette.homeHeaderGradient,
          stops: const [0.0, 0.7, 1.0],
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: AppSpacing.symmetric(horizontal: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),

              // 환영 메시지
              Text(
                '준비 완료!',
                style: textTheme.displayMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: AppColors.onPrimary,
                ),
                textAlign: TextAlign.center,
              ),

              AppSpacing.verticalSpaceLG,

              Text(
                '이제 Tripgether와 함께\n특별한 여행을 계획해보세요 ✈️',
                style: textTheme.titleLarge?.copyWith(
                  color: AppColors.onPrimary.withValues(alpha: 0.9),
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),

              const Spacer(),

              // 시작하기 버튼 (흰색 배경 + 보라색 텍스트)
              PrimaryButton(
                text: 'Tripgether 시작하기',
                onPressed: () => context.go(AppRoutes.home),
                isFullWidth: true,
              ),

              AppSpacing.verticalSpaceXXL,
            ],
          ),
        ),
      ),
    );
  }
}
