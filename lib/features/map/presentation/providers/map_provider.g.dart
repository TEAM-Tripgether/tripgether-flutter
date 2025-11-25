// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'map_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$mapControllerHash() => r'5dec08a847e911baf3e9cc19b3ad5f6a21e9fdc8';

/// 지도 컨트롤러 상태 관리
///
/// GoogleMapController를 Riverpod으로 관리하여
/// 지도 이동, 줌, 마커 표시 등의 기능을 제공합니다.
///
/// Copied from [MapController].
@ProviderFor(MapController)
final mapControllerProvider =
    AutoDisposeNotifierProvider<MapController, GoogleMapController?>.internal(
      MapController.new,
      name: r'mapControllerProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$mapControllerHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$MapController = AutoDisposeNotifier<GoogleMapController?>;
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
String _$mapMarkersHash() => r'8b7d808be48f24b97d1bad00a1444e3133810a01';

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
