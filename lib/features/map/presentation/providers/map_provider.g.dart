// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'map_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$savedPlacesMarkersHash() =>
    r'2e6da89bea3f575c17c774031a8dd20edf448144';

/// 저장한 장소 마커 Provider
///
/// GET /api/place/saved에서 저장된 장소를 조회하고,
/// 좌표가 없는 장소는 GET /api/place/{placeId}로 상세 조회하여
/// 마커로 변환합니다.
///
/// 지도 화면에서 저장한 모든 장소를 마커로 표시할 때 사용됩니다.
///
/// Copied from [savedPlacesMarkers].
@ProviderFor(savedPlacesMarkers)
final savedPlacesMarkersProvider =
    AutoDisposeFutureProvider<Set<Marker>>.internal(
      savedPlacesMarkers,
      name: r'savedPlacesMarkersProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$savedPlacesMarkersHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef SavedPlacesMarkersRef = AutoDisposeFutureProviderRef<Set<Marker>>;
String _$mapControllerHash() => r'fc88824a64488df27702bb770207cc031647be41';

/// 지도 컨트롤러 상태 관리
///
/// GoogleMapController를 Riverpod으로 관리하여
/// 지도 이동, 줌, 마커 표시 등의 기능을 제공합니다.
///
/// ⚠️ keepAlive: true - 지도 화면을 벗어나도 컨트롤러 상태 유지
/// (탭 전환 시 컨트롤러가 null로 리셋되는 문제 방지)
///
/// Copied from [MapController].
@ProviderFor(MapController)
final mapControllerProvider =
    NotifierProvider<MapController, GoogleMapController?>.internal(
      MapController.new,
      name: r'mapControllerProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$mapControllerHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$MapController = Notifier<GoogleMapController?>;
String _$cameraFocusModeHash() => r'574792bd6e6765dd250c554906ed1c0deffb17a6';

/// 현재 카메라 모드 (내 위치 / 저장 장소 전체)
///
/// - true: 내 위치에 포커스된 상태
/// - false: 저장 장소 전체가 보이는 상태 (기본값)
///
/// "내 위치" 버튼을 토글 방식으로 사용:
/// - 저장 장소 모드에서 클릭 → 내 위치로 이동
/// - 내 위치 모드에서 클릭 → 저장 장소 전체 보기
///
/// Copied from [CameraFocusMode].
@ProviderFor(CameraFocusMode)
final cameraFocusModeProvider =
    NotifierProvider<CameraFocusMode, bool>.internal(
      CameraFocusMode.new,
      name: r'cameraFocusModeProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$cameraFocusModeHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$CameraFocusMode = Notifier<bool>;
String _$mapTypeStateHash() => r'd039937081d9bda097dd665181ae98c93e08adc6';

/// 지도 타입 상태 관리 (일반/위성)
///
/// 사용자가 지도 타입을 전환할 수 있도록 상태를 관리합니다.
///
/// Copied from [MapTypeState].
@ProviderFor(MapTypeState)
final mapTypeStateProvider =
    AutoDisposeNotifierProvider<MapTypeState, MapType>.internal(
      MapTypeState.new,
      name: r'mapTypeStateProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$mapTypeStateHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$MapTypeState = AutoDisposeNotifier<MapType>;
String _$mapMarkersHash() => r'95bdcaf8474a81569e78281b942a2606c47ce4d6';

/// 지도 마커 상태 관리
///
/// 지도에 표시할 마커들을 관리합니다.
/// PlaceDetailScreen의 "지도에서 보기" 버튼으로 전환 시
/// 해당 장소의 마커를 지도에 표시합니다.
///
/// Copied from [MapMarkers].
@ProviderFor(MapMarkers)
final mapMarkersProvider =
    AutoDisposeNotifierProvider<MapMarkers, Set<Marker>>.internal(
      MapMarkers.new,
      name: r'mapMarkersProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$mapMarkersHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$MapMarkers = AutoDisposeNotifier<Set<Marker>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
