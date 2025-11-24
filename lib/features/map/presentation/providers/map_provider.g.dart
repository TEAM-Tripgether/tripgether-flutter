// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'map_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$mapControllerHash() => r'980dc600695170d0e51c8782e68cc2b450ce3650';

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
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
