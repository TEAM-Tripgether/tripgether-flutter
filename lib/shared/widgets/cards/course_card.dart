import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';
import '../../../features/course_market/data/models/course_model.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../l10n/app_localizations.dart';
import '../layout/section_header.dart';

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
        margin: EdgeInsets.only(right: AppSpacing.md),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: AppRadius.allXLarge,
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
          borderRadius: AppRadius.topXLarge,
          child: CachedNetworkImage(
            imageUrl: course.thumbnailUrl,
            width: double.infinity,
            height: 160.h,
            fit: BoxFit.cover,
            placeholder: (context, url) => Shimmer.fromColors(
              baseColor: AppColors.shimmerBase,
              highlightColor: AppColors.shimmerHighlight,
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
                size: AppSizes.iconXLarge,
                color: AppColors.neutral70,
              ),
            ),
          ),
        ),

        // 상단 좌측 뱃지 (카테고리)
        Positioned(
          top: AppSpacing.sm.h,
          left: AppSpacing.sm.w,
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: AppSpacing.sm,
              vertical: AppSpacing.xs.h,
            ),
            decoration: BoxDecoration(
              color: AppColors.neutral10.withValues(alpha: 0.6),
              borderRadius: AppRadius.allLarge,
            ),
            child: Text(
              course.category.displayName,
              style: AppTextStyles.buttonSmallBold10.copyWith(
                color: AppColors.white,
              ),
            ),
          ),
        ),

        // 상단 우측 좋아요 버튼
        Positioned(
          top: AppSpacing.sm.h,
          right: AppSpacing.sm.w,
          child: GestureDetector(
            onTap:
                onLikeTap ??
                () {
                  debugPrint('좋아요 클릭: ${course.title}');
                },
            child: Container(
              width: AppSizes.iconLarge,
              height: AppSizes.iconLarge,
              decoration: BoxDecoration(
                color: AppColors.surface.withValues(alpha: 0.9),
                shape: BoxShape.circle,
              ),
              child: Icon(
                isLiked ? Icons.favorite : Icons.favorite_border,
                size: AppSizes.iconMedium,
                color: isLiked ? AppColors.error : AppColors.neutral60,
              ),
            ),
          ),
        ),

        // 하단 좌측 가격 뱃지
        if (course.price > 0)
          Positioned(
            bottom: AppSpacing.sm.h,
            left: AppSpacing.sm.w,
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: AppSpacing.sm,
                vertical: AppSpacing.xs.h,
              ),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: AppRadius.allLarge,
              ),
              child: Text(
                course.priceText,
                style: AppTextStyles.buttonSmallBold10.copyWith(
                  fontWeight: FontWeight.w700,
                  color: AppColors.white,
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
      padding: EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 코스 제목
          Text(
            course.title,
            style: AppTextStyles.sectionTitle.copyWith(
              fontWeight: FontWeight.w700,
              color: AppColors.onSurface,
              height: 1.3,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: AppSpacing.xs.h),

          // 코스 설명
          Text(
            course.description,
            style: AppTextStyles.bodyRegular14.copyWith(
              color: AppColors.neutral60,
              height: 1.3,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: AppSpacing.sm.h),

          // 코스 메타 정보 (장소 수, 소요시간, 거리)
          _buildMetaInfo(),

          SizedBox(height: AppSpacing.sm.h),

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
            Icon(
              Icons.location_on,
              size: AppSizes.iconSmall,
              color: AppColors.neutral60,
            ),
            AppSpacing.horizontalSpaceXS,
            Text(
              l10n.placesCount(course.placeCount),
              style: AppTextStyles.metaMedium12.copyWith(
                color: AppColors.neutral60,
              ),
            ),
            SizedBox(width: AppSpacing.sm),

            // 소요 시간
            Icon(
              Icons.access_time,
              size: AppSizes.iconSmall,
              color: AppColors.neutral60,
            ),
            AppSpacing.horizontalSpaceXS,
            Text(
              course.durationText,
              style: AppTextStyles.metaMedium12.copyWith(
                color: AppColors.neutral60,
              ),
            ),

            // 거리
            if (course.distance != null) ...[
              SizedBox(width: AppSpacing.sm),
              Icon(
                Icons.straighten,
                size: AppSizes.iconSmall,
                color: AppColors.neutral60,
              ),
              AppSpacing.horizontalSpaceXS,
              Text(
                course.distanceText,
                style: AppTextStyles.metaMedium12.copyWith(
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
    return Builder(
      builder: (context) {
        return Row(
          children: [
            // 작성자 프로필 이미지
            if (course.authorProfileUrl != null)
              ClipOval(
                child: CachedNetworkImage(
                  imageUrl: course.authorProfileUrl!,
                  width: AppSizes.iconMedium,
                  height: AppSizes.iconMedium,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(
                    width: AppSizes.iconMedium.w,
                    height: AppSizes.iconMedium.w,
                    color: AppColors.neutral95,
                  ),
                  errorWidget: (context, url, error) => Container(
                    width: AppSizes.iconMedium.w,
                    height: AppSizes.iconMedium.w,
                    color: AppColors.neutral95,
                    child: Icon(
                      Icons.person,
                      size: AppSizes.iconSmall,
                      color: AppColors.neutral70,
                    ),
                  ),
                ),
              ),
            if (course.authorProfileUrl != null) SizedBox(width: AppSpacing.xs),

            // 작성자 이름
            Expanded(
              child: Text(
                course.authorName,
                style: AppTextStyles.metaMedium12.copyWith(
                  color: AppColors.neutral50,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),

            // 좋아요 수
            Icon(
              Icons.favorite,
              size: AppSizes.iconSmall,
              color: AppColors.error.withValues(alpha: 0.7),
            ),
            SizedBox(width: AppSpacing.xs.w / 2),
            Text(
              '${course.likeCount}',
              style: AppTextStyles.metaMedium12.copyWith(
                fontWeight: FontWeight.w600,
                color: AppColors.neutral50,
              ),
            ),
          ],
        );
      },
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
      baseColor: AppColors.shimmerBase,
      highlightColor: AppColors.shimmerHighlight,
      child: Container(
        width: width ?? 280.w,
        margin: EdgeInsets.only(right: AppSpacing.md),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: AppRadius.allXLarge,
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
                borderRadius: AppRadius.topXLarge,
              ),
            ),

            Padding(
              padding: EdgeInsets.all(AppSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 제목
                  Container(
                    width: double.infinity,
                    height: 16.h,
                    color: AppColors.surface,
                  ),
                  SizedBox(height: AppSpacing.sm.h),

                  // 설명
                  Container(
                    width: 200.w,
                    height: 12.h,
                    color: AppColors.surface,
                  ),
                  SizedBox(height: AppSpacing.md.h),

                  // 메타 정보
                  Container(
                    width: 150.w,
                    height: 12.h,
                    color: AppColors.surface,
                  ),
                  SizedBox(height: AppSpacing.md.h),

                  // 작성자 정보
                  Row(
                    children: [
                      Container(
                        width: AppSizes.iconMedium.w,
                        height: AppSizes.iconMedium.w,
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          shape: BoxShape.circle,
                        ),
                      ),
                      SizedBox(width: AppSpacing.xs.w / 2),
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
        SectionHeaderWithSpacing(title: title, onSeeMoreTap: onSeeMoreTap),

        // 코스 리스트 (가로 스크롤)
        SizedBox(
          height: 330.h, // 카드 높이
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg),
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
}
