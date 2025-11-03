import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_colors.dart';

/// 온보딩 페이지 인디케이터 위젯 - Segment Progress Bar 스타일
///
/// 5개 세그먼트로 나뉜 프로그레스 바로 현재 온보딩 진행 상태를 시각적으로 표시합니다.
/// - 총 5개 페이지 (닉네임, 생년월일, 성별, 관심사, 완료)
/// - 각 세그먼트는 하나의 온보딩 단계를 나타냅니다
/// - 완료된 세그먼트는 primary 색상, 미완료는 neutral 색상으로 표시
/// - AnimatedContainer를 사용하여 부드러운 전환 애니메이션 제공
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
    // PageController의 현재 페이지를 실시간으로 추적
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        // 현재 페이지 인덱스 (0-4)
        // controller.page가 null일 수 있으므로 0으로 fallback
        final currentPage = controller.hasClients
            ? (controller.page?.round() ?? 0)
            : 0;

        return Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(count, (index) {
            // 현재 페이지 이하의 세그먼트는 완료 상태로 표시
            final isCompleted = index <= currentPage;

            return Expanded(
              child: AnimatedContainer(
                // 부드러운 전환 애니메이션 (300ms)
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                // 세그먼트 높이
                height: 4.h,
                // 세그먼트 간격 (양쪽 2픽셀씩, 총 4픽셀 간격)
                margin: EdgeInsets.symmetric(horizontal: 2.w),
                decoration: BoxDecoration(
                  // 완료된 세그먼트: primary 색상, 미완료: neutral90 색상
                  color: isCompleted ? AppColors.primary : AppColors.neutral90,
                  // 모서리 둥글게 처리 (반경 2픽셀)
                  borderRadius: BorderRadius.circular(2.r),
                ),
              ),
            );
          }),
        );
      },
    );
  }
}
