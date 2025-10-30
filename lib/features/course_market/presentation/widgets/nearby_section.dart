import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tripgether/core/theme/app_spacing.dart';
import 'package:tripgether/shared/widgets/layout/section_header.dart';
import 'package:tripgether/shared/widgets/cards/nearby_course_card.dart';

/// 내 주변 코스 데이터 모델
class NearbyCourse {
  final String id;
  final String imageUrl;
  final String title;
  final List<String> categories;

  const NearbyCourse({
    required this.id,
    required this.imageUrl,
    required this.title,
    required this.categories,
  });
}

/// 내 주변 섹션 위젯
///
/// **레이아웃:**
/// - 섹션 제목: "내 주변 (현재 위치 : OO구 OO동)"
/// - 4열 2행 고정 그리드 (8개 카드)
/// - 카드 크기: 86w × 150h 고정
class NearbySection extends StatelessWidget {
  /// 현재 위치 (구 + 동)
  final String location;

  /// 표시할 주변 코스 리스트
  final List<NearbyCourse> courses;

  /// 섹션 제목 접두사 (기본값: "내 주변")
  final String titlePrefix;

  /// 더보기 버튼 탭 콜백
  final VoidCallback? onSeeMoreTap;

  /// 코스 카드 탭 콜백
  final void Function(NearbyCourse course)? onCourseTap;

  /// 로딩 상태
  final bool isLoading;

  /// 스켈레톤 개수 (로딩 시)
  final int skeletonCount;

  const NearbySection({
    super.key,
    required this.location,
    required this.courses,
    this.titlePrefix = '내 주변',
    this.onSeeMoreTap,
    this.onCourseTap,
    this.isLoading = false,
    this.skeletonCount = 8,
  });

  @override
  Widget build(BuildContext context) {
    final sectionTitle = '$titlePrefix (현재 위치 : $location)';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // 실시간 인기 코스와 동일하게 SectionHeaderWithSpacing 사용
        SectionHeaderWithSpacing(
          title: sectionTitle,
          onSeeMoreTap: onSeeMoreTap,
        ),

        // GridView에 직접 패딩 적용
        isLoading ? _buildLoadingGrid() : _buildCourseGrid(),
      ],
    );
  }

  /// 코스 그리드 빌드 (4열 고정)
  Widget _buildCourseGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4, // 4열 고정
        crossAxisSpacing: 8.w,
        mainAxisSpacing: 12.h,
        childAspectRatio: 86 / 150, // 0.57 (고정 비율)
      ),
      itemCount: courses.length,
      itemBuilder: (context, index) {
        final course = courses[index];
        return NearbyCourseCard(
          imageUrl: course.imageUrl,
          title: course.title,
          categories: course.categories,
          onTap: onCourseTap != null ? () => onCourseTap!(course) : null,
        );
      },
    );
  }

  /// 로딩 그리드 빌드 (4열 고정)
  Widget _buildLoadingGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4, // 4열 고정
        crossAxisSpacing: 8.w,
        mainAxisSpacing: 12.h,
        childAspectRatio: 86 / 150, // 0.57
      ),
      itemCount: skeletonCount,
      itemBuilder: (context, index) => const NearbyCourseCardSkeleton(),
    );
  }
}
