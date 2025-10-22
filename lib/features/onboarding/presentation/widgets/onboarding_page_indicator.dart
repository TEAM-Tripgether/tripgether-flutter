import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../../../core/constants/app_colors.dart';

/// 온보딩 페이지 인디케이터 위젯
///
/// smooth_page_indicator를 사용하여 현재 페이지를 시각적으로 표시합니다.
/// - 총 5개 페이지 (닉네임, 생년월일, 성별, 관심사, 완료)
/// - WormEffect를 사용하여 부드러운 전환 애니메이션 제공
class OnboardingPageIndicator extends StatelessWidget {
  /// PageController (페이지 전환 제어)
  final PageController controller;

  /// 총 페이지 개수
  final int count;

  const OnboardingPageIndicator({
    super.key,
    required this.controller,
    required this.count,
  });

  @override
  Widget build(BuildContext context) {
    return SmoothPageIndicator(
      controller: controller,
      count: count,
      effect: WormEffect(
        // 비활성 점 색상
        dotColor: AppColors.neutral80,
        // 활성 점 색상 (보라색)
        activeDotColor: AppColors.primary,
        // 점 크기
        dotHeight: 8.h,
        dotWidth: 8.w,
        // 점 사이 간격
        spacing: 8.w,
        // 벌레 효과 (부드러운 전환)
        paintStyle: PaintingStyle.fill,
      ),
    );
  }
}
