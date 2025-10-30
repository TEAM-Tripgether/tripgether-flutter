import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';
import 'package:tripgether/core/theme/app_colors.dart';
import 'package:tripgether/core/theme/app_text_styles.dart';

/// 내 주변 코스 카드 위젯
///
/// **디자인 스펙:**
/// - 전체 크기: 86w × 150h (고정)
/// - 이미지: 86w × 86h, radius 12r
/// - 텍스트: 제목(2줄) + 카테고리(1줄)
/// - 간격: 4h로 통일
/// - 경계선 없음 (이미지만 radius)
class NearbyCourseCard extends StatelessWidget {
  final String imageUrl;
  final String title;
  final List<String> categories;
  final VoidCallback? onTap;

  const NearbyCourseCard({
    super.key,
    required this.imageUrl,
    required this.title,
    this.categories = const [],
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: 86.w,
        height: 150.h,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 이미지 (86×86, radius 12)
            ClipRRect(
              borderRadius: BorderRadius.circular(12.r),
              child: SizedBox(width: 86.w, height: 86.h, child: _buildImage()),
            ),

            SizedBox(height: 4.h),

            // 제목 (2줄)
            Text(
              title,
              style: AppTextStyles.bodyMedium.copyWith(
                fontWeight: FontWeight.w600,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),

            SizedBox(height: 4.h),

            // 카테고리 (1줄, 공백 구분)
            if (categories.isNotEmpty)
              Text(
                categories.join(' '),
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.textSecondary,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
          ],
        ),
      ),
    );
  }

  /// 이미지 위젯 (CachedNetworkImage + Shimmer)
  Widget _buildImage() {
    return CachedNetworkImage(
      imageUrl: imageUrl,
      fit: BoxFit.cover,
      placeholder: (context, url) => Shimmer.fromColors(
        baseColor: AppColors.shimmerBase,
        highlightColor: AppColors.shimmerHighlight,
        child: Container(color: AppColors.surface),
      ),
      errorWidget: (context, url, error) => Container(
        color: AppColors.surfaceVariant,
        child: Center(
          child: Icon(
            Icons.image_not_supported_outlined,
            color: AppColors.textSecondary,
            size: 32.w,
          ),
        ),
      ),
    );
  }
}

/// 내 주변 코스 카드 스켈레톤 (86×150)
class NearbyCourseCardSkeleton extends StatelessWidget {
  const NearbyCourseCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.shimmerBase,
      highlightColor: AppColors.shimmerHighlight,
      child: SizedBox(
        width: 86.w,
        height: 150.h,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 이미지 (86×86, radius 12)
            ClipRRect(
              borderRadius: BorderRadius.circular(12.r),
              child: Container(
                width: 86.w,
                height: 86.h,
                color: AppColors.surface,
              ),
            ),

            SizedBox(height: 4.h),

            // 제목
            Container(width: 70.w, height: 14.h, color: AppColors.surface),

            SizedBox(height: 4.h),

            // 카테고리
            Container(width: 50.w, height: 12.h, color: AppColors.surface),
          ],
        ),
      ),
    );
  }
}
