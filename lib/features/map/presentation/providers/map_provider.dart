import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../../core/services/location/location_service.dart';
import '../../../home/presentation/providers/content_provider.dart';

part 'map_provider.g.dart';

/// 지도 컨트롤러 상태 관리
///
/// GoogleMapController를 Riverpod으로 관리하여
/// 지도 이동, 줌, 마커 표시 등의 기능을 제공합니다.
///
/// ⚠️ keepAlive: true - 지도 화면을 벗어나도 컨트롤러 상태 유지
/// (탭 전환 시 컨트롤러가 null로 리셋되는 문제 방지)
@Riverpod(keepAlive: true)
class MapController extends _$MapController {
  @override
  GoogleMapController? build() {
    debugPrint('[MapController] 🏗️ build() 호출 - Provider 초기화');
    return null;
  }

  /// 지도 컨트롤러 설정
  ///
  /// GoogleMap 위젯의 onMapCreated 콜백에서 호출됩니다.
  void setController(GoogleMapController controller) {
    debugPrint('[MapController] ✅ setController() - 컨트롤러 설정됨');
    state = controller;
  }

  /// 특정 위치로 애니메이션 이동
  ///
  /// [position] 이동할 위도/경도 좌표
  /// [zoom] 줌 레벨 (선택 사항, 기본값: 현재 줌 유지)
  Future<void> moveToLocation(LatLng position, {double? zoom}) async {
    if (state == null) {
      debugPrint('[MapController] ⚠️ moveToLocation - 컨트롤러 null, 스킵');
      return;
    }

    await state!.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(target: position, zoom: zoom ?? 14.0),
      ),
    );
  }

  /// 현재 위치로 이동
  ///
  /// GPS를 통해 실제 현재 위치를 가져와 지도를 이동합니다.
  /// 위치 권한이 없거나 서비스가 비활성화된 경우 서울 시청으로 이동합니다.
  Future<void> moveToMyLocation() async {
    debugPrint('[MapController] ═══════════════════════════════════════');
    debugPrint('[MapController] 📍 내 위치로 이동 시작');
    debugPrint('[MapController] 컨트롤러 상태: ${state != null ? "준비됨" : "null"}');

    if (state == null) {
      debugPrint('[MapController] ❌ 컨트롤러가 null - 이동 불가');
      debugPrint('[MapController] 💡 힌트: 지도가 아직 생성되지 않았습니다');
      debugPrint('[MapController] ═══════════════════════════════════════');
      return;
    }

    try {
      debugPrint('[MapController] 🔍 LocationService.getCurrentLocation() 호출 중...');
      final currentLocation = await LocationService.getCurrentLocation();

      // 기본 위치(서울 시청)인지 확인
      final isDefaultLocation =
          currentLocation.latitude == LocationService.defaultLocation.latitude &&
          currentLocation.longitude == LocationService.defaultLocation.longitude;

      debugPrint(
        '[MapController] 📍 위치 가져옴 - '
        '위도: ${currentLocation.latitude}, 경도: ${currentLocation.longitude}',
      );
      debugPrint(
        '[MapController] ${isDefaultLocation ? "⚠️ 기본 위치(서울 시청) 사용됨 - 권한 또는 GPS 문제 가능성" : "✅ 실제 현재 위치 획득"}',
      );

      debugPrint('[MapController] 🎯 moveToLocation() 호출 중...');
      await moveToLocation(currentLocation, zoom: 15.0);
      debugPrint('[MapController] ✅ 카메라 이동 완료');
    } catch (e, stackTrace) {
      debugPrint('[MapController] ❌ 내 위치로 이동 실패: $e');
      debugPrint('[MapController] StackTrace: $stackTrace');
    }
    debugPrint('[MapController] ═══════════════════════════════════════');
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
    debugPrint('[MapController] 🗑️ disposeController() - 컨트롤러 정리');
    state?.dispose();
    state = null;
  }

  /// 모든 마커가 보이도록 카메라 영역 조정
  ///
  /// 마커들의 좌표를 기반으로 LatLngBounds를 계산하고,
  /// 모든 마커가 화면에 보이도록 카메라를 이동합니다.
  ///
  /// [markers] 표시할 마커 Set
  /// [padding] 화면 가장자리 여백 (기본값: 50.0)
  Future<void> fitBoundsToMarkers(Set<Marker> markers, {double padding = 50.0}) async {
    if (state == null) {
      debugPrint('[MapController] ⚠️ 컨트롤러가 null - fitBounds 스킵');
      return;
    }

    if (markers.isEmpty) {
      debugPrint('[MapController] ⚠️ 마커 없음 - fitBounds 스킵');
      return;
    }

    // 마커가 1개인 경우: 해당 위치로 줌 16 이동
    if (markers.length == 1) {
      final singleMarker = markers.first;
      debugPrint(
        '[MapController] 📍 마커 1개 - 해당 위치로 이동: '
        '${singleMarker.position.latitude}, ${singleMarker.position.longitude}',
      );
      await moveToLocation(singleMarker.position, zoom: 16.0);
      return;
    }

    // 마커가 2개 이상인 경우: LatLngBounds 계산
    debugPrint('[MapController] 📍 마커 ${markers.length}개 - Bounds 계산 시작');

    double minLat = markers.first.position.latitude;
    double maxLat = markers.first.position.latitude;
    double minLng = markers.first.position.longitude;
    double maxLng = markers.first.position.longitude;

    for (final marker in markers) {
      final lat = marker.position.latitude;
      final lng = marker.position.longitude;

      if (lat < minLat) minLat = lat;
      if (lat > maxLat) maxLat = lat;
      if (lng < minLng) minLng = lng;
      if (lng > maxLng) maxLng = lng;
    }

    final bounds = LatLngBounds(
      southwest: LatLng(minLat, minLng),
      northeast: LatLng(maxLat, maxLng),
    );

    debugPrint(
      '[MapController] 📍 Bounds 계산 완료 - '
      'SW: ($minLat, $minLng), NE: ($maxLat, $maxLng)',
    );

    await state!.animateCamera(
      CameraUpdate.newLatLngBounds(bounds, padding),
    );

    debugPrint('[MapController] ✅ 카메라 이동 완료 - 모든 마커 표시');
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

/// 현재 카메라 모드 (내 위치 / 저장 장소 전체)
///
/// - true: 내 위치에 포커스된 상태
/// - false: 저장 장소 전체가 보이는 상태 (기본값)
///
/// "내 위치" 버튼을 토글 방식으로 사용:
/// - 저장 장소 모드에서 클릭 → 내 위치로 이동
/// - 내 위치 모드에서 클릭 → 저장 장소 전체 보기
@Riverpod(keepAlive: true)
class CameraFocusMode extends _$CameraFocusMode {
  @override
  bool build() {
    return false; // 기본값: 저장 장소 전체 보기 모드
  }

  /// 내 위치 모드로 전환
  void setMyLocationMode() {
    debugPrint('[CameraFocusMode] 📍 내 위치 모드로 전환');
    state = true;
  }

  /// 저장 장소 전체 보기 모드로 전환
  void setSavedPlacesMode() {
    debugPrint('[CameraFocusMode] 🗺️ 저장 장소 전체 보기 모드로 전환');
    state = false;
  }

  /// 모드 토글
  void toggle() {
    state = !state;
    debugPrint('[CameraFocusMode] 🔄 모드 토글 → ${state ? "내 위치" : "저장 장소 전체"}');
  }
}

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

  /// 여러 마커 한번에 추가
  ///
  /// [markers] 추가할 마커 Set
  void addMarkers(Set<Marker> markers) {
    state = {...state, ...markers};
  }

  /// 저장 장소 마커로 교체
  ///
  /// 기존 마커를 모두 제거하고 새 마커들로 교체합니다.
  void replaceWithSavedPlaceMarkers(Set<Marker> markers) {
    state = markers;
  }
}

/// 저장한 장소 마커 Provider
///
/// GET /api/place/saved에서 저장된 장소를 조회하고,
/// 좌표가 없는 장소는 GET /api/place/{placeId}로 상세 조회하여
/// 마커로 변환합니다.
///
/// 지도 화면에서 저장한 모든 장소를 마커로 표시할 때 사용됩니다.
@riverpod
Future<Set<Marker>> savedPlacesMarkers(Ref ref) async {
  debugPrint('[SavedPlacesMarkers] 📍 저장 장소 마커 생성 시작');

  final repository = ref.read(contentRepositoryProvider);
  final savedPlaces = await repository.getSavedPlaces();

  debugPrint('[SavedPlacesMarkers] 📋 저장된 장소 수: ${savedPlaces.length}');

  final markers = <Marker>{};

  for (final place in savedPlaces) {
    // 좌표가 있는 경우 바로 마커 생성
    if (place.latitude != null && place.longitude != null) {
      debugPrint(
        '[SavedPlacesMarkers] ✅ ${place.name} - 좌표 있음 '
        '(${place.latitude}, ${place.longitude})',
      );
      markers.add(
        Marker(
          markerId: MarkerId(place.placeId),
          position: LatLng(place.latitude!, place.longitude!),
          infoWindow: InfoWindow(
            title: place.name,
            snippet: place.address,
          ),
        ),
      );
    } else {
      // 좌표가 없는 경우 상세 조회로 좌표 가져오기
      debugPrint(
        '[SavedPlacesMarkers] 🔍 ${place.name} - 좌표 없음, 상세 조회 시작',
      );
      try {
        final detailedPlace = await repository.getPlaceById(place.placeId);
        if (detailedPlace.latitude != null && detailedPlace.longitude != null) {
          debugPrint(
            '[SavedPlacesMarkers] ✅ ${detailedPlace.name} - 상세 조회로 좌표 획득 '
            '(${detailedPlace.latitude}, ${detailedPlace.longitude})',
          );
          markers.add(
            Marker(
              markerId: MarkerId(detailedPlace.placeId),
              position: LatLng(
                detailedPlace.latitude!,
                detailedPlace.longitude!,
              ),
              infoWindow: InfoWindow(
                title: detailedPlace.name,
                snippet: detailedPlace.address,
              ),
            ),
          );
        } else {
          debugPrint(
            '[SavedPlacesMarkers] ⚠️ ${place.name} - 상세 조회에도 좌표 없음',
          );
        }
      } catch (e) {
        debugPrint(
          '[SavedPlacesMarkers] ❌ ${place.name} - 상세 조회 실패: $e',
        );
      }
    }
  }

  debugPrint('[SavedPlacesMarkers] 📍 마커 생성 완료: ${markers.length}개');
  return markers;
}
