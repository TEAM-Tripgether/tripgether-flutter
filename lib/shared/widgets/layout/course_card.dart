import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';
import '../../../features/course_market/data/models/course_model.dart';
import '../../../core/constants/app_colors.dart';
import '../../../l10n/app_localizations.dart';

/// 여행 코스 카드 위젯
///
/// 코스마켓에서 사용되는 코스 카드
/// 썸네일, 제목, 설명, 카테고리, 가격, 좋아요 등을 표시
class CourseCard extends StatelessWidget {
  /// 표시할 코스 정보
  final Course course;

  /// 카드 탭 시 실행될 콜백
  final VoidCallback? onTap;

  /// 좋아요 버튼 탭 시 콜백
  final VoidCallback? onLikeTap;

  /// 좋아요 상태
  final bool isLiked;

  /// 카드 너비 (null이면 가로 스크롤용으로 고정 너비)
  final double? width;

  const CourseCard({
    super.key,
    required this.course,
    this.onTap,
    this.onLikeTap,
    this.isLiked = false,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap:
          onTap ??
          () {
            debugPrint('코스 카드 클릭: ${course.title}');
          },
      child: Container(
        width: width ?? 280.w, // 가로 스크롤용 기본 너비
        margin: EdgeInsets.only(right: 12.w),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: AppColors.shadow.withValues(alpha: 0.08),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // 썸네일 이미지 및 뱃지
            _buildThumbnail(context),

            // 코스 정보
            _buildCourseInfo(context),
          ],
        ),
      ),
    );
  }

  /// 썸네일 이미지 영역 빌드
  Widget _buildThumbnail(BuildContext context) {
    return Stack(
      children: [
        // 썸네일 이미지
        ClipRRect(
          borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
          child: CachedNetworkImage(
            imageUrl: course.thumbnailUrl,
            width: double.infinity,
            height: 160.h,
            fit: BoxFit.cover,
            placeholder: (context, url) => Shimmer.fromColors(
              baseColor: AppColors.neutral90,
              highlightColor: AppColors.neutral99,
              child: Container(
                width: double.infinity,
                height: 160.h,
                color: AppColors.surface,
              ),
            ),
            errorWidget: (context, url, error) => Container(
              width: double.infinity,
              height: 160.h,
              color: AppColors.neutral95,
              child: Icon(
                Icons.image_not_supported,
                size: 48.w,
                color: AppColors.neutral70,
              ),
            ),
          ),
        ),

        // 상단 좌측 뱃지 (카테고리)
        Positioned(
          top: 8.h,
          left: 8.w,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
            decoration: BoxDecoration(
              color: AppColors.neutral10.withValues(alpha: 0.6),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(course.category.emoji, style: TextStyle(fontSize: 12.sp)),
                SizedBox(width: 4.w),
                Text(
                  course.category.displayName,
                  style: TextStyle(
                    fontFamily: 'Pretendard',
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.onPrimary,
                  ),
                ),
              ],
            ),
          ),
        ),

        // 상단 우측 좋아요 버튼
        Positioned(
          top: 8.h,
          right: 8.w,
          child: GestureDetector(
            onTap:
                onLikeTap ??
                () {
                  debugPrint('좋아요 클릭: ${course.title}');
                },
            child: Container(
              width: 32.w,
              height: 32.w,
              decoration: BoxDecoration(
                color: AppColors.surface.withValues(alpha: 0.9),
                shape: BoxShape.circle,
              ),
              child: Icon(
                isLiked ? Icons.favorite : Icons.favorite_border,
                size: 18.w,
                color: isLiked ? AppColors.error : AppColors.neutral60,
              ),
            ),
          ),
        ),

        // 하단 좌측 가격 뱃지
        if (course.price > 0)
          Positioned(
            bottom: 8.h,
            left: 8.w,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Text(
                course.priceText,
                style: TextStyle(
                  fontFamily: 'Pretendard',
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.onPrimary,
                ),
              ),
            ),
          ),
      ],
    );
  }

  /// 코스 정보 영역 빌드
  Widget _buildCourseInfo(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(12.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 코스 제목
          Text(
            course.title,
            style: TextStyle(
              fontFamily: 'Pretendard',
              fontSize: 15.sp,
              fontWeight: FontWeight.w700,
              color: AppColors.onSurface,
              height: 1.3,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: 4.h),

          // 코스 설명
          Text(
            course.description,
            style: TextStyle(
              fontFamily: 'Pretendard',
              fontSize: 12.sp,
              fontWeight: FontWeight.w400,
              color: AppColors.neutral60,
              height: 1.3,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: 8.h),

          // 코스 메타 정보 (장소 수, 소요시간, 거리)
          _buildMetaInfo(),

          SizedBox(height: 8.h),

          // 작성자 정보 및 좋아요 수
          _buildAuthorInfo(),
        ],
      ),
    );
  }

  /// 코스 메타 정보 위젯
  Widget _buildMetaInfo() {
    return Builder(
      builder: (context) {
        final l10n = AppLocalizations.of(context);

        return Row(
          children: [
            // 장소 수
            Icon(Icons.location_on, size: 14.w, color: AppColors.neutral60),
            SizedBox(width: 2.w),
            Text(
              l10n.placesCount(course.placeCount),
              style: TextStyle(
                fontFamily: 'Pretendard',
                fontSize: 11.sp,
                fontWeight: FontWeight.w500,
                color: AppColors.neutral60,
              ),
            ),
            SizedBox(width: 8.w),

            // 소요 시간
            Icon(Icons.access_time, size: 14.w, color: AppColors.neutral60),
            SizedBox(width: 2.w),
            Text(
              course.durationText,
              style: TextStyle(
                fontFamily: 'Pretendard',
                fontSize: 11.sp,
                fontWeight: FontWeight.w500,
                color: AppColors.neutral60,
              ),
            ),

            // 거리
            if (course.distance != null) ...[
              SizedBox(width: 8.w),
              Icon(Icons.straighten, size: 14.w, color: AppColors.neutral60),
              SizedBox(width: 2.w),
              Text(
                course.distanceText,
                style: TextStyle(
                  fontFamily: 'Pretendard',
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w500,
                  color: AppColors.neutral60,
                ),
              ),
            ],
          ],
        );
      },
    );
  }

  /// 작성자 정보 위젯
  Widget _buildAuthorInfo() {
    return Row(
      children: [
        // 작성자 프로필 이미지
        if (course.authorProfileUrl != null)
          ClipOval(
            child: CachedNetworkImage(
              imageUrl: course.authorProfileUrl!,
              width: 20.w,
              height: 20.w,
              fit: BoxFit.cover,
              placeholder: (context, url) => Container(
                width: 20.w,
                height: 20.w,
                color: AppColors.neutral95,
              ),
              errorWidget: (context, url, error) => Container(
                width: 20.w,
                height: 20.w,
                color: AppColors.neutral95,
                child: Icon(
                  Icons.person,
                  size: 12.w,
                  color: AppColors.neutral70,
                ),
              ),
            ),
          ),
        if (course.authorProfileUrl != null) SizedBox(width: 6.w),

        // 작성자 이름
        Expanded(
          child: Text(
            course.authorName,
            style: TextStyle(
              fontFamily: 'Pretendard',
              fontSize: 11.sp,
              fontWeight: FontWeight.w500,
              color: AppColors.neutral50,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),

        // 좋아요 수
        Icon(
          Icons.favorite,
          size: 12.w,
          color: AppColors.error.withValues(alpha: 0.7),
        ),
        SizedBox(width: 2.w),
        Text(
          '${course.likeCount}',
          style: TextStyle(
            fontFamily: 'Pretendard',
            fontSize: 11.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.neutral50,
          ),
        ),
      ],
    );
  }
}

/// 코스 카드 스켈레톤 로딩 위젯
///
/// 코스 데이터 로딩 중 표시할 스켈레톤
class CourseCardSkeleton extends StatelessWidget {
  /// 카드 너비
  final double? width;

  const CourseCardSkeleton({super.key, this.width});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.neutral90,
      highlightColor: AppColors.neutral99,
      child: Container(
        width: width ?? 280.w,
        margin: EdgeInsets.only(right: 12.w),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // 썸네일
            Container(
              width: double.infinity,
              height: 160.h,
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
              ),
            ),

            Padding(
              padding: EdgeInsets.all(12.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 제목
                  Container(
                    width: double.infinity,
                    height: 16.h,
                    color: AppColors.surface,
                  ),
                  SizedBox(height: 8.h),

                  // 설명
                  Container(
                    width: 200.w,
                    height: 12.h,
                    color: AppColors.surface,
                  ),
                  SizedBox(height: 12.h),

                  // 메타 정보
                  Container(
                    width: 150.w,
                    height: 12.h,
                    color: AppColors.surface,
                  ),
                  SizedBox(height: 12.h),

                  // 작성자 정보
                  Row(
                    children: [
                      Container(
                        width: 20.w,
                        height: 20.w,
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          shape: BoxShape.circle,
                        ),
                      ),
                      SizedBox(width: 6.w),
                      Container(
                        width: 80.w,
                        height: 12.h,
                        color: AppColors.surface,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// 코스 가로 스크롤 리스트 위젯
///
/// 여러 코스를 가로로 스크롤 가능한 리스트로 표시
class CourseHorizontalList extends StatelessWidget {
  /// 표시할 코스 리스트
  final List<Course> courses;

  /// 섹션 제목
  final String title;

  /// 더보기 버튼 탭 시 콜백
  final VoidCallback? onSeeMoreTap;

  /// 코스 카드 탭 시 콜백
  final void Function(Course course)? onCourseTap;

  /// 좋아요 토글 콜백
  final void Function(Course course)? onLikeTap;

  /// 좋아요 상태 확인 함수
  final bool Function(Course course)? isLiked;

  const CourseHorizontalList({
    super.key,
    required this.courses,
    required this.title,
    this.onSeeMoreTap,
    this.onCourseTap,
    this.onLikeTap,
    this.isLiked,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 섹션 헤더
        _buildSectionHeader(context),

        SizedBox(height: 12.h),

        // 코스 리스트 (가로 스크롤)
        SizedBox(
          height: 330.h, // 카드 높이
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            itemCount: courses.length,
            itemBuilder: (context, index) {
              final course = courses[index];
              return CourseCard(
                course: course,
                onTap: () {
                  if (onCourseTap != null) {
                    onCourseTap!(course);
                  } else {
                    debugPrint('코스 선택: ${course.title}');
                  }
                },
                onLikeTap: () {
                  if (onLikeTap != null) {
                    onLikeTap!(course);
                  }
                },
                isLiked: isLiked?.call(course) ?? false,
              );
            },
          ),
        ),
      ],
    );
  }

  /// 섹션 헤더 위젯 빌드
  Widget _buildSectionHeader(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontFamily: 'Pretendard',
              fontSize: 18.sp,
              fontWeight: FontWeight.w700,
              color: AppColors.onSurface,
            ),
          ),
          if (onSeeMoreTap != null)
            GestureDetector(
              onTap: onSeeMoreTap,
              child: Row(
                children: [
                  Text(
                    l10n.more,
                    style: TextStyle(
                      fontFamily: 'Pretendard',
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w500,
                      color: AppColors.primary,
                    ),
                  ),
                  SizedBox(width: 2.w),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 12.w,
                    color: AppColors.primary,
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
