import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tripgether/core/theme/app_spacing.dart';
import 'package:tripgether/shared/widgets/layout/section_header.dart';
import 'package:tripgether/shared/widgets/cards/popular_course_card.dart';

/// 실시간 인기 코스 데이터 모델 (단순 버전)
///
/// PopularCourseCard를 사용하므로 최소한의 정보만 포함
class PopularCourse {
  final String id;
  final String imageUrl;
  final String title;
  final String? description;

  const PopularCourse({
    required this.id,
    required this.imageUrl,
    required this.title,
    this.description,
  });
}

/// 실시간 인기 코스 섹션 위젯
///
/// **레이아웃:**
/// - 섹션 제목 (SectionHeader)
/// - 가로 스크롤 카드 리스트 (PopularCourseCard, 158x264)
///
/// **사용 예시:**
/// ```dart
/// PopularCoursesSection(
///   courses: [
///     PopularCourse(
///       id: '1',
///       imageUrl: 'https://...',
///       title: '익선동 골목 데이트 산책코스',
///       description: '비 오는 날이 설렘 추억 하나로 충분한',
///     ),
///     // ...
///   ],
///   onSeeMoreTap: () => context.push('/courses/popular'),
///   onCourseTap: (course) => context.push('/course/${course.id}'),
/// )
/// ```
class PopularCoursesSection extends StatelessWidget {
  /// 표시할 인기 코스 리스트
  final List<PopularCourse> courses;

  /// 섹션 제목 (기본값: "실시간 인기 코스")
  final String title;

  /// 더보기 버튼 탭 콜백
  final VoidCallback? onSeeMoreTap;

  /// 코스 카드 탭 콜백
  final void Function(PopularCourse course)? onCourseTap;

  /// 로딩 상태 (true일 때 스켈레톤 표시)
  final bool isLoading;

  /// 스켈레톤 개수 (로딩 시 표시할 카드 개수)
  final int skeletonCount;

  const PopularCoursesSection({
    super.key,
    required this.courses,
    this.title = '실시간 인기 코스',
    this.onSeeMoreTap,
    this.onCourseTap,
    this.isLoading = false,
    this.skeletonCount = 3,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // 섹션 헤더
        SectionHeaderWithSpacing(
          title: title,
          onSeeMoreTap: onSeeMoreTap,
        ),

        // 가로 스크롤 카드 리스트
        SizedBox(
          height: 264.h, // PopularCourseCard의 고정 높이
          child: isLoading ? _buildLoadingList() : _buildCourseList(),
        ),
      ],
    );
  }

  /// 코스 리스트 빌드
  Widget _buildCourseList() {
    if (courses.isEmpty) {
      return _buildEmptyState();
    }

    return ListView.separated(
      scrollDirection: Axis.horizontal,
      padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      itemCount: courses.length,
      separatorBuilder: (context, index) => SizedBox(width: AppSpacing.sm),
      itemBuilder: (context, index) {
        final course = courses[index];
        return PopularCourseCard(
          imageUrl: course.imageUrl,
          title: course.title,
          description: course.description,
          onTap: onCourseTap != null ? () => onCourseTap!(course) : null,
        );
      },
    );
  }

  /// 로딩 리스트 빌드 (스켈레톤)
  Widget _buildLoadingList() {
    return ListView.separated(
      scrollDirection: Axis.horizontal,
      padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      itemCount: skeletonCount,
      separatorBuilder: (context, index) => SizedBox(width: AppSpacing.sm),
      itemBuilder: (context, index) => const PopularCourseCardSkeleton(),
    );
  }

  /// 빈 상태 위젯
  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg),
        child: Text(
          '아직 인기 코스가 없어요',
          style: TextStyle(
            fontSize: 14.sp,
            color: Colors.grey,
          ),
        ),
      ),
    );
  }
}
