import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';
import '../../../core/models/place_model.dart';
import '../../../core/router/routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../l10n/app_localizations.dart';
import '../buttons/common_button.dart';

/// 장소 정보 바텀시트
///
/// 지도에서 마커 클릭 시 표시되는 바텀시트입니다.
/// 장소의 기본 정보(이름, 주소, 평점, 사진 등)를 표시하고,
/// "상세보기" 버튼을 통해 PlaceDetailScreen으로 이동할 수 있습니다.
class PlaceInfoBottomSheet extends StatelessWidget {
  /// 표시할 장소 정보
  final PlaceModel place;

  /// 바텀시트 닫기 콜백
  final VoidCallback? onClose;

  const PlaceInfoBottomSheet({
    super.key,
    required this.place,
    this.onClose,
  });

  /// 바텀시트 표시 헬퍼 메서드
  ///
  /// [context] BuildContext
  /// [place] 표시할 장소 정보
  /// [onClose] 바텀시트 닫힐 때 콜백
  static void show(
    BuildContext context, {
    required PlaceModel place,
    VoidCallback? onClose,
  }) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => PlaceInfoBottomSheet(
        place: place,
        onClose: onClose,
      ),
    ).whenComplete(() {
      // 바텀시트가 닫힐 때 콜백 실행
      onClose?.call();
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(AppSpacing.lg),
          topRight: Radius.circular(AppSpacing.lg),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: EdgeInsets.all(AppSpacing.lg),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 드래그 핸들
              _buildDragHandle(),

              AppSpacing.verticalSpaceMD,

              // 장소 정보 영역
              _buildPlaceInfo(context, l10n),

              AppSpacing.verticalSpaceLG,

              // 이미지 갤러리 (사진이 있는 경우에만)
              if (place.photoUrls.isNotEmpty) ...[
                _buildImageGallery(),
                AppSpacing.verticalSpaceLG,
              ],

              // 상세보기 버튼
              _buildDetailButton(context, l10n),
            ],
          ),
        ),
      ),
    );
  }

  /// 드래그 핸들 빌드
  Widget _buildDragHandle() {
    return Center(
      child: Container(
        width: 40.w,
        height: 4.h,
        decoration: BoxDecoration(
          color: AppColors.subColor2.withValues(alpha: 0.3),
          borderRadius: BorderRadius.circular(2.r),
        ),
      ),
    );
  }

  /// 장소 정보 빌드
  Widget _buildPlaceInfo(BuildContext context, AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 카테고리 칩 (있는 경우)
        if (place.category != null && place.category!.isNotEmpty) ...[
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: AppSpacing.smd,
              vertical: AppSpacing.xxs,
            ),
            decoration: BoxDecoration(
              color: AppColors.subColor2.withValues(alpha: 0.2),
              borderRadius: AppRadius.allSmall,
            ),
            child: Text(
              place.category!,
              style: AppTextStyles.metaMedium12.copyWith(
                color: AppColors.textColor1.withValues(alpha: 0.6),
              ),
            ),
          ),
          AppSpacing.verticalSpaceSM,
        ],

        // 장소 이름
        Text(
          place.name,
          style: AppTextStyles.titleSemiBold16,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),

        AppSpacing.verticalSpaceXS,

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
                place.address,
                style: AppTextStyles.metaMedium12.copyWith(
                  color: AppColors.textColor1.withValues(alpha: 0.6),
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),

        // 평점 및 리뷰 수 (있는 경우)
        if (place.rating != null) ...[
          AppSpacing.verticalSpaceXS,
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
                '${place.rating}${place.userRatingsTotal != null ? ' (${place.userRatingsTotal})' : ''}',
                style: AppTextStyles.metaMedium12.copyWith(
                  color: AppColors.textColor1.withValues(alpha: 0.6),
                ),
              ),
            ],
          ),
        ],

        // 설명 (있는 경우)
        if (place.description != null && place.description!.isNotEmpty) ...[
          AppSpacing.verticalSpaceSM,
          Text(
            place.description!,
            style: AppTextStyles.bodyRegular14.copyWith(
              color: AppColors.textColor1.withValues(alpha: 0.8),
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ],
    );
  }

  /// 이미지 갤러리 빌드
  Widget _buildImageGallery() {
    return SizedBox(
      height: 100.h,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: place.photoUrls.length,
        separatorBuilder: (context, index) => AppSpacing.horizontalSpaceSM,
        itemBuilder: (context, index) {
          return ClipRRect(
            borderRadius: AppRadius.allMedium,
            child: CachedNetworkImage(
              imageUrl: place.photoUrls[index],
              width: 120.w,
              height: 100.h,
              fit: BoxFit.cover,
              placeholder: (context, url) => _buildShimmerPlaceholder(),
              errorWidget: (context, url, error) => _buildErrorPlaceholder(),
            ),
          );
        },
      ),
    );
  }

  /// Shimmer 로딩 플레이스홀더
  Widget _buildShimmerPlaceholder() {
    return Shimmer.fromColors(
      baseColor: AppColors.subColor2.withValues(alpha: 0.3),
      highlightColor: AppColors.shimmerHighlight,
      child: Container(
        width: 120.w,
        height: 100.h,
        color: AppColors.white,
      ),
    );
  }

  /// 에러 플레이스홀더
  Widget _buildErrorPlaceholder() {
    return Container(
      width: 120.w,
      height: 100.h,
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

  /// 상세보기 버튼 빌드
  Widget _buildDetailButton(BuildContext context, AppLocalizations l10n) {
    return PrimaryButton(
      text: l10n.mapPlaceDetailButton,
      onPressed: () {
        // 바텀시트 닫기
        Navigator.of(context).pop();

        // PlaceDetailScreen으로 이동
        context.push(
          AppRoutes.placeDetail.replaceAll(':placeId', place.placeId),
          extra: place, // initialPlace로 전달
        );
      },
      isFullWidth: true,
    );
  }
}
