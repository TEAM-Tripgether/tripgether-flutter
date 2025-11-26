import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../core/models/place_model.dart';
import '../../../core/router/routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../l10n/app_localizations.dart';
import '../buttons/common_button.dart';
import '../common/place_info_widgets.dart';

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

  const PlaceInfoBottomSheet({super.key, required this.place, this.onClose});

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
      builder: (context) =>
          PlaceInfoBottomSheet(place: place, onClose: onClose),
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
          PlaceCategoryChip(category: place.category!),
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
        PlaceAddressRow(address: place.address),

        // 평점 및 리뷰 수 (있는 경우)
        if (place.rating != null) ...[
          AppSpacing.verticalSpaceXS,
          PlaceRatingRow(
            rating: place.rating!,
            reviewCount: place.userRatingsTotal,
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
    return PlaceImageGallery(
      imageUrls: place.photoUrls,
      imageWidth: 120.w,
      imageHeight: 100.h,
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
