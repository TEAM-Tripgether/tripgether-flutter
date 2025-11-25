import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';

/// 장소 사진 가로 스크롤 갤러리
///
/// - 가로 스크롤 ListView
/// - 84.h 높이, 104.w 너비 (가로 비율)
/// - CachedNetworkImage + Shimmer 로딩
/// - 탭하면 전체화면 갤러리로 이동 (TODO)
///
/// 재사용 가능: PlaceDetailScreen, SnsContentDetailScreen 등
class PlacePhotoGallery extends StatelessWidget {
  /// 사진 URL 리스트
  final List<String> photoUrls;

  /// 장소 이름 (전체화면 갤러리 제목용)
  final String placeName;

  /// 사진 탭 콜백 (선택 사항)
  final Function(int index)? onPhotoTap;

  const PlacePhotoGallery({
    super.key,
    required this.photoUrls,
    required this.placeName,
    this.onPhotoTap,
  });

  @override
  Widget build(BuildContext context) {
    if (photoUrls.isEmpty) return const SizedBox.shrink();

    return SizedBox(
      height: 84.h,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg),
        itemCount: photoUrls.length,
        separatorBuilder: (_, _) => SizedBox(width: AppSpacing.sm),
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              if (onPhotoTap != null) {
                onPhotoTap!(index);
              } else {
                // TODO: 전체화면 갤러리로 이동
                debugPrint('[PlacePhotoGallery] Open gallery at index: $index');
              }
            },
            child: ClipRRect(
              borderRadius: AppRadius.allMedium,
              child: CachedNetworkImage(
                imageUrl: photoUrls[index],
                width: 104.w,
                height: 84.h,
                fit: BoxFit.cover,
                placeholder: (context, url) => _buildShimmer(),
                errorWidget: (context, url, error) => _buildError(),
              ),
            ),
          );
        },
      ),
    );
  }

  /// Shimmer 로딩 플레이스홀더
  Widget _buildShimmer() {
    return Shimmer.fromColors(
      baseColor: AppColors.subColor2.withValues(alpha: 0.3),
      highlightColor: AppColors.shimmerHighlight,
      child: Container(color: AppColors.white),
    );
  }

  /// 에러 플레이스홀더
  Widget _buildError() {
    return Container(
      color: AppColors.imagePlaceholder,
      child: Center(
        child: Icon(
          Icons.image_outlined,
          size: AppSizes.iconLarge,
          color: AppColors.white,
        ),
      ),
    );
  }
}
