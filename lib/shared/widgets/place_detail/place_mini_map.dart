import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:dio/dio.dart';
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
/// - 단일 마커 표시 (커스텀 아이콘 지원)
/// - 높이 커스터마이징 가능
///
/// 재사용 가능: PlaceDetailScreen, SnsContentDetailScreen 등
class PlaceMiniMap extends StatefulWidget {
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

  /// 마커 아이콘 URL (선택 사항)
  /// 제공되면 해당 이미지를 마커 아이콘으로 사용
  final String? iconUrl;

  const PlaceMiniMap({
    super.key,
    required this.latitude,
    required this.longitude,
    required this.placeName,
    required this.placeId,
    this.height = 200.0,
    this.iconUrl,
  });

  @override
  State<PlaceMiniMap> createState() => _PlaceMiniMapState();
}

class _PlaceMiniMapState extends State<PlaceMiniMap> {
  /// 커스텀 마커 아이콘 (로드 완료 시 non-null)
  BitmapDescriptor? _customMarkerIcon;

  /// Dio 인스턴스 (이미지 다운로드용)
  final Dio _dio = Dio();

  @override
  void initState() {
    super.initState();
    _loadCustomMarkerIcon();
  }

  @override
  void didUpdateWidget(PlaceMiniMap oldWidget) {
    super.didUpdateWidget(oldWidget);
    // iconUrl이 변경되면 새로 로드
    if (oldWidget.iconUrl != widget.iconUrl) {
      _loadCustomMarkerIcon();
    }
  }

  /// 커스텀 마커 아이콘 로드
  Future<void> _loadCustomMarkerIcon() async {
    if (widget.iconUrl == null || widget.iconUrl!.isEmpty) {
      if (mounted) {
        setState(() {
          _customMarkerIcon = null;
        });
      }
      return;
    }

    try {
      final icon = await _getMarkerIconFromUrl(widget.iconUrl!);
      if (mounted) {
        setState(() {
          _customMarkerIcon = icon;
        });
      }
    } catch (e) {
      debugPrint('[PlaceMiniMap] 마커 아이콘 로드 실패: $e');
      if (mounted) {
        setState(() {
          _customMarkerIcon = null;
        });
      }
    }
  }

  /// URL에서 마커 아이콘 BitmapDescriptor 생성
  ///
  /// 네트워크 이미지를 다운로드하여 적절한 크기로 리사이즈 후
  /// BitmapDescriptor로 변환합니다.
  Future<BitmapDescriptor> _getMarkerIconFromUrl(String url) async {
    // Dio를 사용하여 이미지 다운로드
    final response = await _dio.get<List<int>>(
      url,
      options: Options(responseType: ResponseType.bytes),
    );

    if (response.statusCode != 200 || response.data == null) {
      throw Exception('이미지 다운로드 실패: ${response.statusCode}');
    }

    final Uint8List imageData = Uint8List.fromList(response.data!);

    // 이미지 디코딩 및 리사이즈 (AppSizes.iconSmall = 16 기준)
    final markerSize = AppSizes.iconSmall.toInt() * 2; // 32px (레티나 대응)
    final ui.Codec codec = await ui.instantiateImageCodec(
      imageData,
      targetWidth: markerSize,
      targetHeight: markerSize,
    );
    final ui.FrameInfo frameInfo = await codec.getNextFrame();
    final ui.Image image = frameInfo.image;

    // PNG로 인코딩
    final ByteData? byteData = await image.toByteData(
      format: ui.ImageByteFormat.png,
    );
    if (byteData == null) {
      throw Exception('이미지 변환 실패');
    }

    final Uint8List pngBytes = byteData.buffer.asUint8List();

    return BitmapDescriptor.bytes(pngBytes);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    // latitude/longitude null 체크 - 위치 정보 없을 때
    if (widget.latitude == null || widget.longitude == null) {
      return Container(
        height: widget.height.h,
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

    final position = LatLng(widget.latitude!, widget.longitude!);

    // 마커 아이콘 결정: 커스텀 아이콘 로드 완료 시 사용, 아니면 기본 마커
    final markerIcon = _customMarkerIcon ?? BitmapDescriptor.defaultMarker;

    return ClipRRect(
      borderRadius: AppRadius.allMedium,
      child: SizedBox(
        height: widget.height.h,
        child: GoogleMap(
          initialCameraPosition: CameraPosition(
            target: position,
            zoom: 16.0,
          ),
          markers: {
            Marker(
              markerId: MarkerId(widget.placeId),
              position: position,
              icon: markerIcon,
              infoWindow: InfoWindow(title: widget.placeName),
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
