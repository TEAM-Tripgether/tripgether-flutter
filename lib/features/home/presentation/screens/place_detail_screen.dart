import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../../core/router/routes.dart';
import '../../../../core/models/place_model.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../shared/widgets/common/app_snackbar.dart';
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
import '../../../../shared/widgets/dialogs/folder_selection_dialog.dart';
import '../../data/services/place_api_service.dart';
import '../providers/place_detail_provider.dart';
import '../providers/content_provider.dart';
import '../../../map/presentation/providers/map_provider.dart';

/// 장소 상세 화면
///
/// 장소의 상세 정보를 표시하고, 관련 컨텐츠 및 다른 장소들을 보여줍니다.
/// "지도에서 보기" 버튼을 통해 Map 탭으로 이동할 수 있습니다.
///
/// [placeId]: 장소 고유 ID (필수)
/// [initialPlace]: 초기 장소 정보 (선택). 전달되면 네트워크 조회 없이 즉시 표시됩니다.
///                 SNS 콘텐츠에서 넘어온 저장되지 않은 장소를 조회할 때 사용합니다.
class PlaceDetailScreen extends ConsumerWidget {
  /// 장소 ID
  final String placeId;

  /// 초기 장소 정보 (선택)
  /// SNS 콘텐츠에서 전달된 장소 정보를 직접 사용하여 저장되지 않은 장소도 조회 가능
  final PlaceModel? initialPlace;

  const PlaceDetailScreen({
    super.key,
    required this.placeId,
    this.initialPlace,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);

    // initialPlace가 제공된 경우 즉시 표시 (저장되지 않은 장소도 조회 가능)
    if (initialPlace != null) {
      return Scaffold(
        appBar: CommonAppBar.forSubPage(
          title: '',
          rightActions: [
            _buildMapIconButton(context, ref, l10n, initialPlace!),
          ],
        ),
        body: _buildPlaceDetail(context, ref, l10n, initialPlace!),
      );
    }

    // initialPlace가 없는 경우 Provider를 통해 저장된 장소 조회
    final placeAsync = ref.watch(placeDetailProvider(placeId));

    return Scaffold(
      appBar: CommonAppBar.forSubPage(
        title: '',
        rightActions: placeAsync.maybeWhen(
          data: (place) => place != null
              ? [_buildMapIconButton(context, ref, l10n, place)]
              : const [],
          orElse: () => const [],
        ),
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

  /// 지도에서 보기 아이콘 버튼
  ///
  /// AppBar 우측에 표시되며, 클릭 시 해당 장소의 마커를 지도에 추가하고
  /// Map 탭으로 이동합니다.
  Widget _buildMapIconButton(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations l10n,
    PlaceModel place,
  ) {
    // 좌표가 없는 경우 아이콘 숨김
    if (place.latitude == null || place.longitude == null) {
      return const SizedBox.shrink();
    }

    return IconButton(
      icon: Icon(
        Icons.map_outlined,
        size: AppSizes.iconDefault,
        color: AppColors.subColor2,
      ),
      onPressed: () {
        debugPrint('[PlaceDetailScreen] 🗺️ 지도에서 보기: ${place.name}');

        // 1. 지도에 마커 추가 및 카메라 이동 설정
        ref.read(mapControllerProvider.notifier).moveToPlaceWithMarker(
          place.placeId,
          LatLng(place.latitude!, place.longitude!),
          place.name,
        );

        // 2. Map 탭으로 이동
        context.go(AppRoutes.map);

        debugPrint('[PlaceDetailScreen] ✅ Map 탭으로 이동 완료');
      },
      tooltip: l10n.placeDetailViewOnMap,
    );
  }

  /// 장소 상세 정보 표시
  Widget _buildPlaceDetail(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations l10n,
    place,
  ) {
    return Column(
      children: [
        // 스크롤 가능 영역 (1~7번 콘텐츠)
        Expanded(
          child: SingleChildScrollView(
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
                    iconUrl: place.iconUrl,
                  ),
                ),

                AppSpacing.verticalSpaceLG, // 지도 → 구분선 간격
                // 3. 구분선 - 패딩 없음 (앱 양 끝으로 뻗음)
                const SectionDivider.thick(),

                AppSpacing.verticalSpaceLG, // 구분선 → 상세 정보 간격
                // 4. 장소 상세 정보 (주소, 전화, 영업시간, 별점) - 패딩 있음 (헤더보다 8px 더 들어감)
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: AppSpacing.xxl),
                  child: PlaceInfoSection(
                    address: place.address,
                    phone: place.phone,
                    rating: place.rating?.toDouble(),
                    reviewCount: place.userRatingsTotal,
                    businessHours: place.businessHours,
                    businessStatus: place.businessStatus,
                    onPhoneTap: place.phone != null
                        ? () {
                            // TODO: 전화 기능 구현
                            debugPrint(
                              '[PlaceDetailScreen] 전화: ${place.phone}',
                            );
                          }
                        : null,
                    onAddressTap: () async {
                      // 주소를 클립보드에 복사
                      await Clipboard.setData(
                        ClipboardData(text: place.address),
                      );
                      if (context.mounted) {
                        AppSnackBar.showInfo(context, l10n.addressCopied);
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

                // 스크롤 영역 하단 여백 (버튼과의 간격)
                AppSpacing.verticalSpaceLG,
              ],
            ),
          ),
        ),

        // 하단 고정 버튼 영역
        Padding(
          padding: EdgeInsets.only(
            bottom: AppSpacing.huge,
            left: AppSpacing.lg,
            right: AppSpacing.lg,
          ),
          child: _buildActionButtons(context, ref, l10n, place),
        ),
      ],
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
                separatorBuilder: (_, _) => AppSpacing.horizontalSpaceMD,
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
      error: (_, _) => const SizedBox.shrink(),
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
                separatorBuilder: (_, _) => AppSpacing.horizontalSpaceMD,
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
                          AppRoutes.placeDetail.replaceAll(
                            ':placeId',
                            place.placeId,
                          ),
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
      error: (_, _) => const SizedBox.shrink(),
    );
  }

  /// 액션 버튼들
  Widget _buildActionButtons(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations l10n,
    place,
  ) {
    return PrimaryButton(
      text: '저장하기',
      onPressed: () {
        // 폴더 선택 다이얼로그 표시
        showDialog(
          context: context,
          builder: (dialogContext) => FolderSelectionDialog(
            onSave: (folderId) async {
              // folderId가 null이면 "전체 저장하기"
              debugPrint(
                '[PlaceDetailScreen] 장소 저장: ${place.name}, 폴더: ${folderId ?? "전체"}',
              );

              try {
                // 장소 저장 API 호출
                final response = await PlaceApiService.savePlace(
                  placeId: place.placeId,
                );

                debugPrint(
                  '[PlaceDetailScreen] ✅ 저장 성공: ${response.savedStatus}',
                );

                // HomeScreen의 저장된 장소 목록 새로고침
                ref.invalidate(recentSavedPlacesProvider);

                // 성공 메시지 표시
                if (context.mounted) {
                  AppSnackBar.showSuccess(context, '${place.name} 저장 완료');
                }
              } catch (e) {
                debugPrint('[PlaceDetailScreen] ❌ 저장 실패: $e');

                // Exception에서 메시지만 추출
                // Exception.toString()은 "Exception: 메시지" 형태이므로 prefix 제거
                final errorMessage = e.toString().replaceFirst(
                  'Exception: ',
                  '',
                );

                // 에러 메시지 표시
                if (context.mounted) {
                  AppSnackBar.showError(context, errorMessage);
                }
              }
            },
            onCreateFolder: () {
              // TODO: 새 폴더 생성 화면으로 이동
              debugPrint('[PlaceDetailScreen] 새 폴더 만들기');
            },
          ),
        );
      },
      isFullWidth: true,
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
            Text('데이터를 불러올 수 없습니다', style: AppTextStyles.titleSemiBold16),
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
