import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shimmer/shimmer.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';

/// 장소 이미지 갤러리 위젯
///
/// 가로 스크롤 이미지 리스트를 표시합니다.
/// PlaceDetailCard, PlaceInfoBottomSheet 등에서 공통으로 사용됩니다.
///
/// **사용 예시**:
/// ```dart
/// PlaceImageGallery(
///   imageUrls: place.photoUrls,
///   imageWidth: 120.w,
///   imageHeight: 100.h,
/// )
/// ```
class PlaceImageGallery extends StatelessWidget {
  /// 이미지 URL 목록
  final List<String> imageUrls;

  /// 개별 이미지 너비 (기본값: 120.w)
  final double? imageWidth;

  /// 개별 이미지 높이 (기본값: 100.h)
  final double? imageHeight;

  /// 갤러리 전체 높이 (기본값: imageHeight)
  final double? galleryHeight;

  /// 이미지 간 간격 (기본값: AppSpacing.sm)
  final double? spacing;

  /// 이미지 탭 콜백
  final void Function(int index)? onImageTap;

  const PlaceImageGallery({
    super.key,
    required this.imageUrls,
    this.imageWidth,
    this.imageHeight,
    this.galleryHeight,
    this.spacing,
    this.onImageTap,
  });

  @override
  Widget build(BuildContext context) {
    if (imageUrls.isEmpty) return const SizedBox.shrink();

    final width = imageWidth ?? 120.w;
    final height = imageHeight ?? 100.h;

    return SizedBox(
      height: galleryHeight ?? height,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: imageUrls.length,
        separatorBuilder: (context, index) =>
            SizedBox(width: spacing ?? AppSpacing.sm),
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: onImageTap != null ? () => onImageTap!(index) : null,
            child: ClipRRect(
              borderRadius: AppRadius.allMedium,
              child: CachedNetworkImage(
                imageUrl: imageUrls[index],
                width: width,
                height: height,
                fit: BoxFit.cover,
                placeholder: (context, url) => _buildShimmerPlaceholder(width, height),
                errorWidget: (context, url, error) =>
                    _buildErrorPlaceholder(width, height),
              ),
            ),
          );
        },
      ),
    );
  }

  /// Shimmer 로딩 플레이스홀더
  Widget _buildShimmerPlaceholder(double width, double height) {
    return Shimmer.fromColors(
      baseColor: AppColors.subColor2.withValues(alpha: 0.3),
      highlightColor: AppColors.shimmerHighlight,
      child: Container(
        width: width,
        height: height,
        color: AppColors.white,
      ),
    );
  }

  /// 에러 플레이스홀더
  Widget _buildErrorPlaceholder(double width, double height) {
    return Container(
      width: width,
      height: height,
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

/// 장소 주소 Row 위젯
///
/// 위치 아이콘과 주소 텍스트를 표시합니다.
///
/// **사용 예시**:
/// ```dart
/// PlaceAddressRow(address: place.address)
/// ```
class PlaceAddressRow extends StatelessWidget {
  /// 주소 텍스트
  final String address;

  /// 최대 줄 수 (기본값: 1)
  final int maxLines;

  const PlaceAddressRow({
    super.key,
    required this.address,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
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
            maxLines: maxLines,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}

/// 장소 평점 Row 위젯
///
/// 별 아이콘과 평점/리뷰 수를 표시합니다.
///
/// **사용 예시**:
/// ```dart
/// PlaceRatingRow(
///   rating: place.rating,
///   reviewCount: place.userRatingsTotal,
/// )
/// ```
class PlaceRatingRow extends StatelessWidget {
  /// 평점 (예: 4.5)
  final double rating;

  /// 리뷰 수 (선택 사항)
  final int? reviewCount;

  const PlaceRatingRow({
    super.key,
    required this.rating,
    this.reviewCount,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
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
          reviewCount != null ? '$rating ($reviewCount)' : '$rating',
          style: AppTextStyles.metaMedium12.copyWith(
            color: AppColors.textColor1.withValues(alpha: 0.6),
          ),
        ),
      ],
    );
  }
}

/// 장소 카테고리 칩 위젯
///
/// 카테고리 이름을 칩 형태로 표시합니다.
///
/// **사용 예시**:
/// ```dart
/// PlaceCategoryChip(category: place.category)
/// ```
class PlaceCategoryChip extends StatelessWidget {
  /// 카테고리 이름
  final String category;

  const PlaceCategoryChip({
    super.key,
    required this.category,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.smd,
        vertical: AppSpacing.xxs,
      ),
      decoration: BoxDecoration(
        color: AppColors.subColor2.withValues(alpha: 0.2),
        borderRadius: AppRadius.allSmall,
      ),
      child: Text(
        category,
        style: AppTextStyles.metaMedium12.copyWith(
          color: AppColors.textColor1.withValues(alpha: 0.6),
        ),
      ),
    );
  }
}
