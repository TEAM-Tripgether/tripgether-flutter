// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'place_detail_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$placeDetailHash() => r'42082ea25efb4ebdc6cc6ae39c9f87af916e3d21';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

abstract class _$PlaceDetail
    extends BuildlessAutoDisposeAsyncNotifier<PlaceModel?> {
  late final String placeId;

  FutureOr<PlaceModel?> build(String placeId);
}

/// 장소 상세 정보를 제공하는 Provider
///
/// placeId를 받아 해당 장소의 상세 정보를 로드합니다.
/// ContentRepository의 getSavedPlaces()를 통해 장소 목록을 가져온 후
/// placeId로 필터링하여 반환합니다.
///
/// Copied from [PlaceDetail].
@ProviderFor(PlaceDetail)
const placeDetailProvider = PlaceDetailFamily();

/// 장소 상세 정보를 제공하는 Provider
///
/// placeId를 받아 해당 장소의 상세 정보를 로드합니다.
/// ContentRepository의 getSavedPlaces()를 통해 장소 목록을 가져온 후
/// placeId로 필터링하여 반환합니다.
///
/// Copied from [PlaceDetail].
class PlaceDetailFamily extends Family<AsyncValue<PlaceModel?>> {
  /// 장소 상세 정보를 제공하는 Provider
  ///
  /// placeId를 받아 해당 장소의 상세 정보를 로드합니다.
  /// ContentRepository의 getSavedPlaces()를 통해 장소 목록을 가져온 후
  /// placeId로 필터링하여 반환합니다.
  ///
  /// Copied from [PlaceDetail].
  const PlaceDetailFamily();

  /// 장소 상세 정보를 제공하는 Provider
  ///
  /// placeId를 받아 해당 장소의 상세 정보를 로드합니다.
  /// ContentRepository의 getSavedPlaces()를 통해 장소 목록을 가져온 후
  /// placeId로 필터링하여 반환합니다.
  ///
  /// Copied from [PlaceDetail].
  PlaceDetailProvider call(String placeId) {
    return PlaceDetailProvider(placeId);
  }

  @override
  PlaceDetailProvider getProviderOverride(
    covariant PlaceDetailProvider provider,
  ) {
    return call(provider.placeId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'placeDetailProvider';
}

/// 장소 상세 정보를 제공하는 Provider
///
/// placeId를 받아 해당 장소의 상세 정보를 로드합니다.
/// ContentRepository의 getSavedPlaces()를 통해 장소 목록을 가져온 후
/// placeId로 필터링하여 반환합니다.
///
/// Copied from [PlaceDetail].
class PlaceDetailProvider
    extends AutoDisposeAsyncNotifierProviderImpl<PlaceDetail, PlaceModel?> {
  /// 장소 상세 정보를 제공하는 Provider
  ///
  /// placeId를 받아 해당 장소의 상세 정보를 로드합니다.
  /// ContentRepository의 getSavedPlaces()를 통해 장소 목록을 가져온 후
  /// placeId로 필터링하여 반환합니다.
  ///
  /// Copied from [PlaceDetail].
  PlaceDetailProvider(String placeId)
    : this._internal(
        () => PlaceDetail()..placeId = placeId,
        from: placeDetailProvider,
        name: r'placeDetailProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$placeDetailHash,
        dependencies: PlaceDetailFamily._dependencies,
        allTransitiveDependencies: PlaceDetailFamily._allTransitiveDependencies,
        placeId: placeId,
      );

  PlaceDetailProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.placeId,
  }) : super.internal();

  final String placeId;

  @override
  FutureOr<PlaceModel?> runNotifierBuild(covariant PlaceDetail notifier) {
    return notifier.build(placeId);
  }

  @override
  Override overrideWith(PlaceDetail Function() create) {
    return ProviderOverride(
      origin: this,
      override: PlaceDetailProvider._internal(
        () => create()..placeId = placeId,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        placeId: placeId,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<PlaceDetail, PlaceModel?>
  createElement() {
    return _PlaceDetailProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is PlaceDetailProvider && other.placeId == placeId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, placeId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin PlaceDetailRef on AutoDisposeAsyncNotifierProviderRef<PlaceModel?> {
  /// The parameter `placeId` of this provider.
  String get placeId;
}

class _PlaceDetailProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<PlaceDetail, PlaceModel?>
    with PlaceDetailRef {
  _PlaceDetailProviderElement(super.provider);

  @override
  String get placeId => (origin as PlaceDetailProvider).placeId;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
