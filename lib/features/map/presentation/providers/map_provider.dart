import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

part 'map_provider.g.dart';

/// 지도 컨트롤러 상태 관리
///
/// GoogleMapController를 Riverpod으로 관리하여
/// 지도 이동, 줌, 마커 표시 등의 기능을 제공합니다.
@riverpod
class MapController extends _$MapController {
  GoogleMapController? _controller;

  @override
  GoogleMapController? build() {
    return null;
  }

  /// 지도 컨트롤러 설정
  ///
  /// GoogleMap 위젯의 onMapCreated 콜백에서 호출됩니다.
  void setController(GoogleMapController controller) {
    _controller = controller;
    state = controller;
  }

  /// 특정 위치로 애니메이션 이동
  ///
  /// [position] 이동할 위도/경도 좌표
  /// [zoom] 줌 레벨 (선택 사항, 기본값: 현재 줌 유지)
  Future<void> moveToLocation(LatLng position, {double? zoom}) async {
    if (_controller == null) return;

    await _controller!.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(target: position, zoom: zoom ?? 14.0),
      ),
    );
  }

  /// 현재 위치로 이동
  ///
  /// TODO: Geolocator 패키지 추가 후 실제 GPS 위치 사용
  /// 현재는 서울 시청을 기본 위치로 사용합니다.
  Future<void> moveToMyLocation() async {
    const defaultLocation = LatLng(37.5665, 126.9780); // 서울 시청
    await moveToLocation(defaultLocation, zoom: 15.0);
  }

  /// 장소로 이동하며 마커 추가
  ///
  /// [placeId] 장소 고유 ID
  /// [position] 장소 위치
  /// [title] 장소 이름
  /// [zoom] 줌 레벨 (선택 사항, 기본값: 16.0)
  Future<void> moveToPlaceWithMarker(
    String placeId,
    LatLng position,
    String title, {
    double zoom = 16.0,
  }) async {
    // 기존 마커 제거 후 새 마커 추가
    ref.read(mapMarkersProvider.notifier).clearMarkers();
    ref.read(mapMarkersProvider.notifier).addMarker(placeId, position, title);

    // 해당 위치로 이동
    await moveToLocation(position, zoom: zoom);
  }

  /// Dispose 시 컨트롤러 정리
  void disposeController() {
    _controller?.dispose();
    _controller = null;
    state = null;
  }
}

/// 초기 카메라 위치 Provider
///
/// 서울 시청을 중심으로 하는 초기 지도 위치를 제공합니다.
final initialCameraPositionProvider = Provider<CameraPosition>((ref) {
  return const CameraPosition(
    target: LatLng(37.5665, 126.9780), // 서울 시청
    zoom: 14.0,
  );
});

/// 지도 타입 상태 관리 (일반/위성)
///
/// 사용자가 지도 타입을 전환할 수 있도록 상태를 관리합니다.
@riverpod
class MapTypeState extends _$MapTypeState {
  @override
  MapType build() {
    return MapType.normal;
  }

  /// 지도 타입 토글 (일반 ↔ 위성)
  void toggle() {
    state = state == MapType.normal ? MapType.satellite : MapType.normal;
  }
}

/// 지도 마커 상태 관리
///
/// 지도에 표시할 마커들을 관리합니다.
/// PlaceDetailScreen의 "지도에서 보기" 버튼으로 전환 시
/// 해당 장소의 마커를 지도에 표시합니다.
@riverpod
class MapMarkers extends _$MapMarkers {
  @override
  Set<Marker> build() {
    return {};
  }

  /// 마커 추가
  ///
  /// [markerId] 마커 고유 ID (일반적으로 placeId 사용)
  /// [position] 마커 위치
  /// [title] 마커 제목 (InfoWindow에 표시)
  void addMarker(String markerId, LatLng position, String title) {
    final marker = Marker(
      markerId: MarkerId(markerId),
      position: position,
      infoWindow: InfoWindow(title: title),
    );
    state = {...state, marker};
  }

  /// 모든 마커 제거
  void clearMarkers() {
    state = {};
  }

  /// 특정 마커 제거
  ///
  /// [markerId] 제거할 마커 ID
  void removeMarker(String markerId) {
    state = state.where((marker) => marker.markerId.value != markerId).toSet();
  }
}
