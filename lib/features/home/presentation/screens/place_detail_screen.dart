import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../../core/router/routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../shared/widgets/common/common_app_bar.dart';
import '../../../../shared/widgets/common/section_divider.dart';
import '../../../../shared/widgets/buttons/common_button.dart';
import '../../../../shared/widgets/place_detail/place_info_header.dart';
import '../../../../shared/widgets/place_detail/place_mini_map.dart';
import '../../../../shared/widgets/place_detail/place_info_section.dart';
import '../../../../shared/widgets/place_detail/place_photo_gallery.dart';
import '../../../../shared/widgets/cards/sns_content_card.dart';
import '../../../../shared/widgets/cards/place_detail_card.dart';
import '../../../../shared/widgets/layout/section_header.dart';
import '../../../map/presentation/providers/map_provider.dart';
import '../providers/place_detail_provider.dart';

/// 장소 상세 화면
///
/// 장소의 상세 정보를 표시하고, 관련 컨텐츠 및 다른 장소들을 보여줍니다.
/// "지도에서 보기" 버튼을 통해 Map 탭으로 이동할 수 있습니다.
class PlaceDetailScreen extends ConsumerWidget {
  /// 장소 ID
  final String placeId;

  const PlaceDetailScreen({super.key, required this.placeId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final placeAsync = ref.watch(placeDetailProvider(placeId));

    return Scaffold(
      appBar: CommonAppBar.forSubPage(title: l10n.placeDetailTitle),
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
          // 1. 장소 기본 정보 헤더 (카테고리, 이름, 설명) - 패딩 있음
          Padding(
            padding: EdgeInsets.all(AppSpacing.lg),
            child: PlaceInfoHeader(
              category: place.category,
              name: place.name,
              description: place.description,
            ),
          ),

          // 2. Google Maps 미니맵 - 패딩 있음
          Padding(
            padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg),
            child: PlaceMiniMap(
              latitude: place.latitude,
              longitude: place.longitude,
              placeName: place.name,
              placeId: place.placeId,
              height: 240.h,
            ),
          ),

          AppSpacing.verticalSpaceLG, // 지도 → 구분선 간격
          // 3. 구분선 - 패딩 없음 (앱 양 끝으로 뻗음)
          const SectionDivider.thick(),

          AppSpacing.verticalSpaceLG, // 구분선 → 상세 정보 간격
          // 4. 장소 상세 정보 (주소, 전화, 별점) - 패딩 있음 (헤더보다 8px 더 들어감)
          Padding(
            padding: EdgeInsets.symmetric(horizontal: AppSpacing.xxl),
            child: PlaceInfoSection(
              address: place.address,
              phone: place.phone,
              rating: place.rating?.toDouble(),
              reviewCount: place.userRatingsTotal,
              onPhoneTap: place.phone != null
                  ? () {
                      // TODO: 전화 기능 구현
                      debugPrint('[PlaceDetailScreen] 전화: ${place.phone}');
                    }
                  : null,
              onAddressTap: () async {
                // 주소를 클립보드에 복사
                await Clipboard.setData(ClipboardData(text: place.address));
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(l10n.addressCopied),
                      duration: const Duration(seconds: 2),
                    ),
                  );
                }
              },
            ),
          ),

          AppSpacing.verticalSpaceLG, // 상세 정보 → 사진 간격
          // 5. 장소 사진 갤러리 (가로 스크롤) - PlacePhotoGallery 내부에 패딩 있음
          if (place.photoUrls.isNotEmpty) ...[
            PlacePhotoGallery(
              photoUrls: place.photoUrls,
              placeName: place.name,
              onPhotoTap: (index) {
                // TODO: 전체화면 갤러리로 이동
                debugPrint('[PlaceDetailScreen] 사진 탭: index $index');
              },
            ),
            AppSpacing.verticalSpaceXXL,
          ],

          // 6. 이 장소를 포함한 SNS 컨텐츠 섹션 - 패딩 있음
          Padding(
            padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg),
            child: _buildRelatedContentsSection(context, ref, l10n),
          ),

          AppSpacing.verticalSpaceXXL,

          // 7. 같은 컨텐츠의 다른 장소들 섹션 - 패딩 있음
          Padding(
            padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg),
            child: _buildOtherPlacesSection(context, ref, l10n),
          ),

          AppSpacing.verticalSpaceXXL,

          // 8. 액션 버튼들 - 패딩 있음
          Padding(
            padding: EdgeInsets.all(AppSpacing.lg),
            child: _buildActionButtons(context, ref, l10n, place),
          ),
        ],
      ),
    );
  }

  /// 관련 SNS 컨텐츠 섹션
  Widget _buildRelatedContentsSection(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations l10n,
  ) {
    final relatedContentsAsync = ref.watch(relatedContentsProvider(placeId));

    return relatedContentsAsync.when(
      data: (contents) {
        if (contents.isEmpty) return const SizedBox.shrink();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SectionHeader(title: '이 장소를 포함한 컨텐츠', showMoreButton: false),
            AppSpacing.verticalSpaceMD,
            SizedBox(
              height: 180.h,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: contents.length,
                separatorBuilder: (_, __) => AppSpacing.horizontalSpaceMD,
                itemBuilder: (context, index) {
                  return SnsContentCard(
                    content: contents[index],
                    width: 140.w,
                    onTap: () {
                      context.push(
                        '${AppRoutes.snsContentDetail}/${contents[index].contentId}',
                      );
                    },
                  );
                },
              ),
            ),
          ],
        );
      },
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
    );
  }

  /// 같은 컨텐츠의 다른 장소들 섹션
  Widget _buildOtherPlacesSection(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations l10n,
  ) {
    final otherPlacesAsync = ref.watch(otherPlacesProvider(placeId));

    return otherPlacesAsync.when(
      data: (places) {
        if (places.isEmpty) return const SizedBox.shrink();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SectionHeader(title: '함께 저장된 다른 장소', showMoreButton: false),
            AppSpacing.verticalSpaceMD,
            SizedBox(
              height: 240.h,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: places.length,
                separatorBuilder: (_, __) => AppSpacing.horizontalSpaceMD,
                itemBuilder: (context, index) {
                  final place = places[index];
                  return SizedBox(
                    width: 200.w,
                    child: PlaceDetailCard(
                      category: place.category ?? '',
                      placeName: place.name,
                      address: place.address,
                      rating: place.rating?.toDouble() ?? 0.0,
                      reviewCount: place.userRatingsTotal ?? 0,
                      imageUrls: place.photoUrls,
                      onTap: () {
                        // 다른 장소 상세 화면으로 이동
                        context.push(
                          '${AppRoutes.placeDetail}/${place.placeId}',
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
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
              ref
                  .read(mapControllerProvider.notifier)
                  .moveToPlaceWithMarker(place.placeId, position, place.name);
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
            Text('장소를 찾을 수 없습니다', style: AppTextStyles.titleSemiBold16),
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
