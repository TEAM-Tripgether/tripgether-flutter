import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../core/router/routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../shared/widgets/common/common_app_bar.dart';
import '../../../../shared/widgets/buttons/common_button.dart';
import '../../../map/presentation/providers/map_provider.dart';
import '../providers/place_detail_provider.dart';

/// 장소 상세 화면
///
/// 장소의 상세 정보를 표시하고, Google Maps에 마커를 표시합니다.
/// "지도에서 보기" 버튼을 통해 Map 탭으로 이동할 수 있습니다.
class PlaceDetailScreen extends ConsumerWidget {
  /// 장소 ID
  final String placeId;

  const PlaceDetailScreen({
    super.key,
    required this.placeId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final placeAsync = ref.watch(placeDetailProvider(placeId));

    return Scaffold(
      appBar: CommonAppBar.forSubPage(
        title: l10n.placeDetailTitle,
      ),
      body: placeAsync.when(
        data: (place) {
          if (place == null) {
            return _buildNotFoundError(context, l10n);
          }
          return _buildPlaceDetail(context, ref, l10n, place);
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => _buildError(context, l10n, error),
      ),
    );
  }

  /// 장소 상세 정보 표시
  Widget _buildPlaceDetail(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations l10n,
    place,
  ) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 이미지 갤러리
          if (place.photoUrls.isNotEmpty) _buildImageGallery(place.photoUrls),

          // 장소 기본 정보
          Padding(
            padding: EdgeInsets.all(AppSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 카테고리
                if (place.category != null) ...[
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
                      place.category!,
                      style: AppTextStyles.metaMedium12.copyWith(
                        color: AppColors.textColor1.withValues(alpha: 0.4),
                      ),
                    ),
                  ),
                  AppSpacing.verticalSpaceSM,
                ],

                // 장소 이름
                Text(
                  place.name,
                  style: AppTextStyles.titleBold24,
                ),

                AppSpacing.verticalSpaceSM,

                // 평점 및 리뷰 수
                if (place.rating != null) ...[
                  Row(
                    children: [
                      SvgPicture.asset(
                        'assets/icons/star.svg',
                        width: AppSizes.iconDefault,
                        height: AppSizes.iconDefault,
                        colorFilter: ColorFilter.mode(
                          AppColors.mainColor,
                          BlendMode.srcIn,
                        ),
                      ),
                      SizedBox(width: AppSpacing.xs),
                      Text(
                        '${place.rating} (${place.userRatingsTotal ?? 0})',
                        style: AppTextStyles.bodyRegular14.copyWith(
                          color: AppColors.textColor1.withValues(alpha: 0.6),
                        ),
                      ),
                    ],
                  ),
                  AppSpacing.verticalSpaceSM,
                ],

                // 주소
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SvgPicture.asset(
                      'assets/icons/location_on.svg',
                      width: AppSizes.iconDefault,
                      height: AppSizes.iconDefault,
                      colorFilter: ColorFilter.mode(
                        AppColors.mainColor,
                        BlendMode.srcIn,
                      ),
                    ),
                    SizedBox(width: AppSpacing.xs),
                    Expanded(
                      child: Text(
                        place.address,
                        style: AppTextStyles.bodyRegular14,
                      ),
                    ),
                  ],
                ),

                // 전화번호
                if (place.phone != null) ...[
                  AppSpacing.verticalSpaceSM,
                  Row(
                    children: [
                      Icon(
                        Icons.phone_outlined,
                        size: AppSizes.iconDefault,
                        color: AppColors.mainColor,
                      ),
                      SizedBox(width: AppSpacing.xs),
                      Text(
                        place.phone!,
                        style: AppTextStyles.bodyRegular14,
                      ),
                    ],
                  ),
                ],

                // 설명
                if (place.description != null) ...[
                  AppSpacing.verticalSpaceMD,
                  Text(
                    l10n.placeDetailDescription,
                    style: AppTextStyles.titleSemiBold16,
                  ),
                  AppSpacing.verticalSpaceXS,
                  Text(
                    place.description!,
                    style: AppTextStyles.bodyRegular14.copyWith(
                      color: AppColors.textColor1.withValues(alpha: 0.7),
                    ),
                  ),
                ],

                AppSpacing.verticalSpaceMD,

                // Google Maps 미니맵
                _buildMiniMap(context, l10n, place),

                AppSpacing.verticalSpaceLG,

                // 액션 버튼들
                _buildActionButtons(context, ref, l10n, place),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// 이미지 갤러리 (PageView)
  Widget _buildImageGallery(List<String> imageUrls) {
    return SizedBox(
      height: 300.h,
      child: PageView.builder(
        itemCount: imageUrls.length,
        itemBuilder: (context, index) {
          return CachedNetworkImage(
            imageUrl: imageUrls[index],
            fit: BoxFit.cover,
            placeholder: (context, url) => _buildImageShimmer(),
            errorWidget: (context, url, error) => _buildImageError(),
          );
        },
      ),
    );
  }

  /// 이미지 로딩 Shimmer
  Widget _buildImageShimmer() {
    return Shimmer.fromColors(
      baseColor: AppColors.subColor2.withValues(alpha: 0.3),
      highlightColor: AppColors.shimmerHighlight,
      child: Container(color: AppColors.white),
    );
  }

  /// 이미지 에러 플레이스홀더
  Widget _buildImageError() {
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

  /// Google Maps 미니맵
  Widget _buildMiniMap(
    BuildContext context,
    AppLocalizations l10n,
    place,
  ) {
    // 위치 정보 없음
    if (place.latitude == null || place.longitude == null) {
      return Container(
        height: 200.h,
        decoration: BoxDecoration(
          color: AppColors.backgroundLight,
          borderRadius: AppRadius.allMedium,
        ),
        child: Center(
          child: Text(
            l10n.placeDetailNoLocation,
            style: AppTextStyles.bodyRegular14.copyWith(
              color: AppColors.textColor1.withValues(alpha: 0.6),
            ),
          ),
        ),
      );
    }

    final position = LatLng(place.latitude!, place.longitude!);

    return ClipRRect(
      borderRadius: AppRadius.allMedium,
      child: SizedBox(
        height: 200.h,
        child: GoogleMap(
          initialCameraPosition: CameraPosition(
            target: position,
            zoom: 16.0,
          ),
          markers: {
            Marker(
              markerId: MarkerId(place.placeId),
              position: position,
              infoWindow: InfoWindow(title: place.name),
            ),
          },
          zoomControlsEnabled: false,
          myLocationButtonEnabled: false,
          mapToolbarEnabled: false,
          scrollGesturesEnabled: false,
          zoomGesturesEnabled: false,
          tiltGesturesEnabled: false,
          rotateGesturesEnabled: false,
        ),
      ),
    );
  }

  /// 액션 버튼들
  Widget _buildActionButtons(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations l10n,
    place,
  ) {
    return Column(
      children: [
        // 지도에서 보기 버튼
        if (place.latitude != null && place.longitude != null)
          PrimaryButton(
            text: l10n.viewOnMap,
            icon: Icons.map_outlined,
            onPressed: () {
              // Map 탭으로 이동
              context.go(AppRoutes.map);

              // 지도 이동 및 마커 표시
              final position = LatLng(place.latitude!, place.longitude!);
              ref.read(mapControllerProvider.notifier).moveToPlaceWithMarker(
                    place.placeId,
                    position,
                    place.name,
                  );
            },
            isFullWidth: true,
          ),

        AppSpacing.verticalSpaceSM,

        // 길찾기 버튼
        if (place.latitude != null && place.longitude != null)
          SecondaryButton(
            text: l10n.getDirections,
            icon: Icons.directions_outlined,
            onPressed: () {
              // TODO: 길찾기 기능 구현 (Google Maps 앱 실행)
              debugPrint('[PlaceDetailScreen] 길찾기: ${place.name}');
            },
            isFullWidth: true,
          ),

        AppSpacing.verticalSpaceSM,

        // 전화/공유 버튼들
        Row(
          children: [
            // 전화하기
            if (place.phone != null)
              Expanded(
                child: SecondaryButton(
                  text: l10n.placeDetailCall,
                  icon: Icons.phone_outlined,
                  onPressed: () {
                    // TODO: 전화 기능 구현
                    debugPrint('[PlaceDetailScreen] 전화: ${place.phone}');
                  },
                ),
              ),
            if (place.phone != null) SizedBox(width: AppSpacing.sm),

            // 공유하기
            Expanded(
              child: SecondaryButton(
                text: l10n.placeDetailShare,
                icon: Icons.share_outlined,
                onPressed: () {
                  // TODO: 공유 기능 구현
                  debugPrint('[PlaceDetailScreen] 공유: ${place.name}');
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  /// 장소를 찾을 수 없음 에러
  Widget _buildNotFoundError(BuildContext context, AppLocalizations l10n) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(AppSpacing.lg),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.location_off_outlined,
              size: AppSizes.iconLarge * 2,
              color: AppColors.subColor2,
            ),
            AppSpacing.verticalSpaceMD,
            Text(
              '장소를 찾을 수 없습니다',
              style: AppTextStyles.titleSemiBold16,
            ),
          ],
        ),
      ),
    );
  }

  /// 일반 에러
  Widget _buildError(
    BuildContext context,
    AppLocalizations l10n,
    Object error,
  ) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(AppSpacing.lg),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: AppSizes.iconLarge * 2,
              color: AppColors.error,
            ),
            AppSpacing.verticalSpaceMD,
            Text(
              '데이터를 불러올 수 없습니다',
              style: AppTextStyles.titleSemiBold16,
            ),
            AppSpacing.verticalSpaceXS,
            Text(
              error.toString(),
              style: AppTextStyles.caption12.copyWith(
                color: AppColors.textColor1.withValues(alpha: 0.6),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
