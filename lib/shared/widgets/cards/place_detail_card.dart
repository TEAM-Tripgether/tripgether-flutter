import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shimmer/shimmer.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';

/// 장소 상세 카드 위젯
///
/// 카테고리, 장소명, 주소, 평점, 리뷰 수, 이미지 리스트를 표시합니다.
/// 최근 저장한 장소, 링크에 포함된 장소 섹션에서 사용됩니다.
class PlaceDetailCard extends StatelessWidget {
  /// 카테고리 (예: "카페")
  final String category;

  /// 장소 이름
  final String placeName;

  /// 주소
  final String address;

  /// 평점 (예: 4.0)
  final double rating;

  /// 리뷰 수 (예: 92)
  final int reviewCount;

  /// 이미지 URL 리스트
  final List<String> imageUrls;

  /// 카드 탭 콜백
  final VoidCallback? onTap;

  /// 카드 배경색 (기본값: AppColors.white)
  final Color? backgroundColor;

  const PlaceDetailCard({
    super.key,
    required this.category,
    required this.placeName,
    required this.address,
    required this.rating,
    required this.reviewCount,
    required this.imageUrls,
    this.onTap,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(AppSpacing.sm), // 8
        decoration: BoxDecoration(
          color: backgroundColor ?? AppColors.white,
          borderRadius: AppRadius.allMedium,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 텍스트 영역 (카테고리, 장소명, 주소, 리뷰)
            Padding(
              padding: EdgeInsets.symmetric(horizontal: AppSpacing.sm),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 카테고리
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.subColor2.withValues(alpha: 0.2),
                      borderRadius: AppRadius.allSmall,
                    ),
                    padding: EdgeInsets.symmetric(
                      horizontal: AppSpacing.smd,
                      vertical: AppSpacing.xxs,
                    ),
                    child: Text(
                      category,
                      style: AppTextStyles.metaMedium12.copyWith(
                        color: AppColors.textColor1.withValues(alpha: 0.4),
                      ),
                    ),
                  ),

                  AppSpacing.verticalSpaceXSM, // 6
                  // 장소 이름
                  Text(
                    placeName,
                    style: AppTextStyles.titleSemiBold14,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),

                  AppSpacing.verticalSpaceXS, // 4
                  // 주소
                  Row(
                    children: [
                      SvgPicture.asset(
                        'assets/icons/location_on.svg',
                        width: AppSizes.iconSmall,
                        height: AppSizes.iconSmall,
                        colorFilter: ColorFilter.mode(
                          AppColors.mainColor,
                          BlendMode.srcIn,
                        ),
                      ),
                      AppSpacing.horizontalSpaceXS,
                      Expanded(
                        child: Text(
                          address,
                          style: AppTextStyles.metaMedium12.copyWith(
                            color: AppColors.textColor1.withValues(alpha: 0.6),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),

                  AppSpacing.verticalSpaceXS, // 4
                  // 평점 및 리뷰 수
                  Row(
                    children: [
                      SvgPicture.asset(
                        'assets/icons/star.svg',
                        width: AppSizes.iconSmall,
                        height: AppSizes.iconSmall,
                        colorFilter: ColorFilter.mode(
                          AppColors.mainColor,
                          BlendMode.srcIn,
                        ),
                      ),
                      AppSpacing.horizontalSpaceXS,
                      Text(
                        '$rating ($reviewCount)',
                        style: AppTextStyles.metaMedium12.copyWith(
                          color: AppColors.textColor1.withValues(alpha: 0.6),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            AppSpacing.verticalSpaceSM, // 8
            // 가로 스크롤 이미지 리스트
            if (imageUrls.isNotEmpty) _buildImageList(),
          ],
        ),
      ),
    );
  }

  /// 가로 스크롤 이미지 리스트
  Widget _buildImageList() {
    return SizedBox(
      height: 84.h,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: imageUrls.length,
        separatorBuilder: (context, index) =>
            SizedBox(width: AppSpacing.xs), // 4
        itemBuilder: (context, index) {
          return _buildImageItem(imageUrls[index]);
        },
      ),
    );
  }

  /// 개별 이미지 아이템
  Widget _buildImageItem(String imageUrl) {
    return ClipRRect(
      borderRadius: AppRadius.allMedium,
      child: CachedNetworkImage(
        imageUrl: imageUrl,
        width: 104.w,
        height: 84.h,
        fit: BoxFit.cover,
        placeholder: (context, url) => _buildShimmerPlaceholder(),
        errorWidget: (context, url, error) => _buildErrorPlaceholder(),
      ),
    );
  }

  /// Shimmer 로딩 플레이스홀더
  Widget _buildShimmerPlaceholder() {
    return Shimmer.fromColors(
      baseColor: AppColors.subColor2.withValues(alpha: 0.3),
      highlightColor: AppColors.shimmerHighlight,
      child: Container(width: 104.w, height: 84.h, color: AppColors.white),
    );
  }

  /// 에러 플레이스홀더
  Widget _buildErrorPlaceholder() {
    return Container(
      width: 104.w,
      height: 84.h,
      color: AppColors.imagePlaceholder,
      child: Center(
        child: Icon(
          Icons.image_outlined,
          size: AppSizes.iconMedium,
          color: AppColors.white,
        ),
      ),
    );
  }
}
