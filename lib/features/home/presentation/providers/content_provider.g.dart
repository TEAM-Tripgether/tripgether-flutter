// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'content_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$contentDetailHash() => r'0e566b5590cedd37cf71cc5dc342c2e2cd2f01bb';

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

/// 특정 콘텐츠를 제공하는 Provider
///
/// Copied from [contentDetail].
@ProviderFor(contentDetail)
const contentDetailProvider = ContentDetailFamily();

/// 특정 콘텐츠를 제공하는 Provider
///
/// Copied from [contentDetail].
class ContentDetailFamily extends Family<AsyncValue<ContentModel>> {
  /// 특정 콘텐츠를 제공하는 Provider
  ///
  /// Copied from [contentDetail].
  const ContentDetailFamily();

  /// 특정 콘텐츠를 제공하는 Provider
  ///
  /// Copied from [contentDetail].
  ContentDetailProvider call(String contentId) {
    return ContentDetailProvider(contentId);
  }

  @override
  ContentDetailProvider getProviderOverride(
    covariant ContentDetailProvider provider,
  ) {
    return call(provider.contentId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'contentDetailProvider';
}

/// 특정 콘텐츠를 제공하는 Provider
///
/// Copied from [contentDetail].
class ContentDetailProvider extends AutoDisposeFutureProvider<ContentModel> {
  /// 특정 콘텐츠를 제공하는 Provider
  ///
  /// Copied from [contentDetail].
  ContentDetailProvider(String contentId)
    : this._internal(
        (ref) => contentDetail(ref as ContentDetailRef, contentId),
        from: contentDetailProvider,
        name: r'contentDetailProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$contentDetailHash,
        dependencies: ContentDetailFamily._dependencies,
        allTransitiveDependencies:
            ContentDetailFamily._allTransitiveDependencies,
        contentId: contentId,
      );

  ContentDetailProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.contentId,
  }) : super.internal();

  final String contentId;

  @override
  Override overrideWith(
    FutureOr<ContentModel> Function(ContentDetailRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ContentDetailProvider._internal(
        (ref) => create(ref as ContentDetailRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        contentId: contentId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<ContentModel> createElement() {
    return _ContentDetailProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ContentDetailProvider && other.contentId == contentId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, contentId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin ContentDetailRef on AutoDisposeFutureProviderRef<ContentModel> {
  /// The parameter `contentId` of this provider.
  String get contentId;
}

class _ContentDetailProviderElement
    extends AutoDisposeFutureProviderElement<ContentModel>
    with ContentDetailRef {
  _ContentDetailProviderElement(super.provider);

  @override
  String get contentId => (origin as ContentDetailProvider).contentId;
}

String _$savedPlacesHash() => r'577a11cae1ac4a7ed4ceaf045bd34b0cf1154763';

/// 저장된 장소 목록을 제공하는 Provider
///
/// 백엔드 API (GET /api/content/place/saved)에서 저장된 장소를 조회합니다.
/// USE_MOCK_API 플래그에 따라 Mock 또는 실제 API 데이터를 사용합니다.
///
/// Copied from [savedPlaces].
@ProviderFor(savedPlaces)
final savedPlacesProvider =
    AutoDisposeFutureProvider<List<PlaceModel>>.internal(
      savedPlaces,
      name: r'savedPlacesProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$savedPlacesHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef SavedPlacesRef = AutoDisposeFutureProviderRef<List<PlaceModel>>;
String _$recentSavedPlacesHash() => r'66c488b95394f3b35e2a2ecb18f7d2198feb40dd';

/// 최근 저장한 장소 (최신 3개)
///
/// savedPlaces 중에서 최신 3개만 반환합니다.
///
/// Copied from [recentSavedPlaces].
@ProviderFor(recentSavedPlaces)
final recentSavedPlacesProvider =
    AutoDisposeFutureProvider<List<PlaceModel>>.internal(
      recentSavedPlaces,
      name: r'recentSavedPlacesProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$recentSavedPlacesHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef RecentSavedPlacesRef = AutoDisposeFutureProviderRef<List<PlaceModel>>;
String _$contentListHash() => r'657afd0a4d3d1ca88df0480a18a4a25666bbb83a';

/// 최근 콘텐츠 목록을 제공하는 Provider (최신 10개)
///
/// Copied from [ContentList].
@ProviderFor(ContentList)
final contentListProvider =
    AutoDisposeAsyncNotifierProvider<ContentList, List<ContentModel>>.internal(
      ContentList.new,
      name: r'contentListProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$contentListHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$ContentList = AutoDisposeAsyncNotifier<List<ContentModel>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
