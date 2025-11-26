import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../common/place_info_widgets.dart';

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
                  PlaceCategoryChip(category: category),

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
                  PlaceAddressRow(address: address),

                  AppSpacing.verticalSpaceXS, // 4
                  // 평점 및 리뷰 수
                  PlaceRatingRow(
                    rating: rating,
                    reviewCount: reviewCount,
                  ),
                ],
              ),
            ),

            AppSpacing.verticalSpaceSM, // 8
            // 가로 스크롤 이미지 리스트
            if (imageUrls.isNotEmpty)
              PlaceImageGallery(
                imageUrls: imageUrls,
                imageWidth: 104.w,
                imageHeight: 84.h,
                spacing: AppSpacing.xs,
              ),
          ],
        ),
      ),
    );
  }
}
