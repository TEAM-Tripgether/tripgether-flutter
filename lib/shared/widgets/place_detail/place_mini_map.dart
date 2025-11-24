import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../l10n/app_localizations.dart';

/// Google Maps 미니맵 위젯
///
/// - 정적 맵 (모든 제스처 비활성화)
/// - 단일 마커 표시
/// - 높이 커스터마이징 가능
///
/// 재사용 가능: PlaceDetailScreen, SnsContentDetailScreen 등
class PlaceMiniMap extends StatelessWidget {
  /// 위도
  final double? latitude;

  /// 경도
  final double? longitude;

  /// 장소 이름 (마커 InfoWindow 제목)
  final String placeName;

  /// 장소 고유 ID (마커 ID로 사용)
  final String placeId;

  /// 맵 높이 (기본값: 200.0)
  final double height;

  const PlaceMiniMap({
    super.key,
    required this.latitude,
    required this.longitude,
    required this.placeName,
    required this.placeId,
    this.height = 200.0,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    // latitude/longitude null 체크 - 위치 정보 없을 때
    if (latitude == null || longitude == null) {
      return Container(
        height: height.h,
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

    final position = LatLng(latitude!, longitude!);

    return ClipRRect(
      borderRadius: AppRadius.allMedium,
      child: SizedBox(
        height: height.h,
        child: GoogleMap(
          initialCameraPosition: CameraPosition(
            target: position,
            zoom: 16.0,
          ),
          markers: {
            Marker(
              markerId: MarkerId(placeId),
              position: position,
              infoWindow: InfoWindow(title: placeName),
            ),
          },
          // 모든 제스처 비활성화 (정적 맵)
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
}
