// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'place_detail_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$relatedContentsHash() => r'29a27de4961351595d3c10fc35cf680d065b82c4';

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

/// 특정 장소를 포함한 SNS 컨텐츠 목록을 제공하는 Provider
///
/// [placeId]를 포함한 모든 SNS 컨텐츠를 필터링하여 반환합니다.
///
/// Copied from [relatedContents].
@ProviderFor(relatedContents)
const relatedContentsProvider = RelatedContentsFamily();

/// 특정 장소를 포함한 SNS 컨텐츠 목록을 제공하는 Provider
///
/// [placeId]를 포함한 모든 SNS 컨텐츠를 필터링하여 반환합니다.
///
/// Copied from [relatedContents].
class RelatedContentsFamily extends Family<AsyncValue<List<ContentModel>>> {
  /// 특정 장소를 포함한 SNS 컨텐츠 목록을 제공하는 Provider
  ///
  /// [placeId]를 포함한 모든 SNS 컨텐츠를 필터링하여 반환합니다.
  ///
  /// Copied from [relatedContents].
  const RelatedContentsFamily();

  /// 특정 장소를 포함한 SNS 컨텐츠 목록을 제공하는 Provider
  ///
  /// [placeId]를 포함한 모든 SNS 컨텐츠를 필터링하여 반환합니다.
  ///
  /// Copied from [relatedContents].
  RelatedContentsProvider call(String placeId) {
    return RelatedContentsProvider(placeId);
  }

  @override
  RelatedContentsProvider getProviderOverride(
    covariant RelatedContentsProvider provider,
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
  String? get name => r'relatedContentsProvider';
}

/// 특정 장소를 포함한 SNS 컨텐츠 목록을 제공하는 Provider
///
/// [placeId]를 포함한 모든 SNS 컨텐츠를 필터링하여 반환합니다.
///
/// Copied from [relatedContents].
class RelatedContentsProvider
    extends AutoDisposeFutureProvider<List<ContentModel>> {
  /// 특정 장소를 포함한 SNS 컨텐츠 목록을 제공하는 Provider
  ///
  /// [placeId]를 포함한 모든 SNS 컨텐츠를 필터링하여 반환합니다.
  ///
  /// Copied from [relatedContents].
  RelatedContentsProvider(String placeId)
    : this._internal(
        (ref) => relatedContents(ref as RelatedContentsRef, placeId),
        from: relatedContentsProvider,
        name: r'relatedContentsProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$relatedContentsHash,
        dependencies: RelatedContentsFamily._dependencies,
        allTransitiveDependencies:
            RelatedContentsFamily._allTransitiveDependencies,
        placeId: placeId,
      );

  RelatedContentsProvider._internal(
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
  Override overrideWith(
    FutureOr<List<ContentModel>> Function(RelatedContentsRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: RelatedContentsProvider._internal(
        (ref) => create(ref as RelatedContentsRef),
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
  AutoDisposeFutureProviderElement<List<ContentModel>> createElement() {
    return _RelatedContentsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is RelatedContentsProvider && other.placeId == placeId;
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
mixin RelatedContentsRef on AutoDisposeFutureProviderRef<List<ContentModel>> {
  /// The parameter `placeId` of this provider.
  String get placeId;
}

class _RelatedContentsProviderElement
    extends AutoDisposeFutureProviderElement<List<ContentModel>>
    with RelatedContentsRef {
  _RelatedContentsProviderElement(super.provider);

  @override
  String get placeId => (origin as RelatedContentsProvider).placeId;
}

String _$otherPlacesHash() => r'd48bd033c55eed24a5e8df4a4a33d7ba1d9c68ba';

/// 특정 장소와 같은 컨텐츠에 속한 다른 장소들을 제공하는 Provider
///
/// [currentPlaceId]가 포함된 첫 번째 컨텐츠의 나머지 장소들을 반환합니다.
///
/// Copied from [otherPlaces].
@ProviderFor(otherPlaces)
const otherPlacesProvider = OtherPlacesFamily();

/// 특정 장소와 같은 컨텐츠에 속한 다른 장소들을 제공하는 Provider
///
/// [currentPlaceId]가 포함된 첫 번째 컨텐츠의 나머지 장소들을 반환합니다.
///
/// Copied from [otherPlaces].
class OtherPlacesFamily extends Family<AsyncValue<List<PlaceModel>>> {
  /// 특정 장소와 같은 컨텐츠에 속한 다른 장소들을 제공하는 Provider
  ///
  /// [currentPlaceId]가 포함된 첫 번째 컨텐츠의 나머지 장소들을 반환합니다.
  ///
  /// Copied from [otherPlaces].
  const OtherPlacesFamily();

  /// 특정 장소와 같은 컨텐츠에 속한 다른 장소들을 제공하는 Provider
  ///
  /// [currentPlaceId]가 포함된 첫 번째 컨텐츠의 나머지 장소들을 반환합니다.
  ///
  /// Copied from [otherPlaces].
  OtherPlacesProvider call(String currentPlaceId) {
    return OtherPlacesProvider(currentPlaceId);
  }

  @override
  OtherPlacesProvider getProviderOverride(
    covariant OtherPlacesProvider provider,
  ) {
    return call(provider.currentPlaceId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'otherPlacesProvider';
}

/// 특정 장소와 같은 컨텐츠에 속한 다른 장소들을 제공하는 Provider
///
/// [currentPlaceId]가 포함된 첫 번째 컨텐츠의 나머지 장소들을 반환합니다.
///
/// Copied from [otherPlaces].
class OtherPlacesProvider extends AutoDisposeFutureProvider<List<PlaceModel>> {
  /// 특정 장소와 같은 컨텐츠에 속한 다른 장소들을 제공하는 Provider
  ///
  /// [currentPlaceId]가 포함된 첫 번째 컨텐츠의 나머지 장소들을 반환합니다.
  ///
  /// Copied from [otherPlaces].
  OtherPlacesProvider(String currentPlaceId)
    : this._internal(
        (ref) => otherPlaces(ref as OtherPlacesRef, currentPlaceId),
        from: otherPlacesProvider,
        name: r'otherPlacesProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$otherPlacesHash,
        dependencies: OtherPlacesFamily._dependencies,
        allTransitiveDependencies: OtherPlacesFamily._allTransitiveDependencies,
        currentPlaceId: currentPlaceId,
      );

  OtherPlacesProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.currentPlaceId,
  }) : super.internal();

  final String currentPlaceId;

  @override
  Override overrideWith(
    FutureOr<List<PlaceModel>> Function(OtherPlacesRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: OtherPlacesProvider._internal(
        (ref) => create(ref as OtherPlacesRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        currentPlaceId: currentPlaceId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<PlaceModel>> createElement() {
    return _OtherPlacesProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is OtherPlacesProvider &&
        other.currentPlaceId == currentPlaceId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, currentPlaceId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin OtherPlacesRef on AutoDisposeFutureProviderRef<List<PlaceModel>> {
  /// The parameter `currentPlaceId` of this provider.
  String get currentPlaceId;
}

class _OtherPlacesProviderElement
    extends AutoDisposeFutureProviderElement<List<PlaceModel>>
    with OtherPlacesRef {
  _OtherPlacesProviderElement(super.provider);

  @override
  String get currentPlaceId => (origin as OtherPlacesProvider).currentPlaceId;
}

String _$placeDetailHash() => r'903bb46a6045a6eafeaad93d63527d233ad57144';

abstract class _$PlaceDetail
    extends BuildlessAutoDisposeAsyncNotifier<PlaceModel?> {
  late final String placeId;

  FutureOr<PlaceModel?> build(String placeId);
}

/// 장소 상세 정보를 제공하는 Provider
///
/// placeId를 받아 해당 장소의 상세 정보를 로드합니다.
/// GET /api/place/{placeId} API를 호출하여 위치 정보를 포함한 상세 데이터를 가져옵니다.
///
/// Copied from [PlaceDetail].
@ProviderFor(PlaceDetail)
const placeDetailProvider = PlaceDetailFamily();

/// 장소 상세 정보를 제공하는 Provider
///
/// placeId를 받아 해당 장소의 상세 정보를 로드합니다.
/// GET /api/place/{placeId} API를 호출하여 위치 정보를 포함한 상세 데이터를 가져옵니다.
///
/// Copied from [PlaceDetail].
class PlaceDetailFamily extends Family<AsyncValue<PlaceModel?>> {
  /// 장소 상세 정보를 제공하는 Provider
  ///
  /// placeId를 받아 해당 장소의 상세 정보를 로드합니다.
  /// GET /api/place/{placeId} API를 호출하여 위치 정보를 포함한 상세 데이터를 가져옵니다.
  ///
  /// Copied from [PlaceDetail].
  const PlaceDetailFamily();

  /// 장소 상세 정보를 제공하는 Provider
  ///
  /// placeId를 받아 해당 장소의 상세 정보를 로드합니다.
  /// GET /api/place/{placeId} API를 호출하여 위치 정보를 포함한 상세 데이터를 가져옵니다.
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
/// GET /api/place/{placeId} API를 호출하여 위치 정보를 포함한 상세 데이터를 가져옵니다.
///
/// Copied from [PlaceDetail].
class PlaceDetailProvider
    extends AutoDisposeAsyncNotifierProviderImpl<PlaceDetail, PlaceModel?> {
  /// 장소 상세 정보를 제공하는 Provider
  ///
  /// placeId를 받아 해당 장소의 상세 정보를 로드합니다.
  /// GET /api/place/{placeId} API를 호출하여 위치 정보를 포함한 상세 데이터를 가져옵니다.
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
