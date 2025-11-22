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

String _$pendingContentsHash() => r'5c76ae7ce3ddc967d6c1fef71093a3645de6d51d';

/// PENDING 상태인 콘텐츠만 제공하는 Provider
///
/// Copied from [pendingContents].
@ProviderFor(pendingContents)
final pendingContentsProvider =
    AutoDisposeFutureProvider<List<ContentModel>>.internal(
      pendingContents,
      name: r'pendingContentsProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$pendingContentsHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef PendingContentsRef = AutoDisposeFutureProviderRef<List<ContentModel>>;
String _$completedContentsHash() => r'312431ab387f1fc8c3b3d6f39e5f7787e7ce5eee';

/// COMPLETED 상태인 콘텐츠만 제공하는 Provider
///
/// Copied from [completedContents].
@ProviderFor(completedContents)
final completedContentsProvider =
    AutoDisposeFutureProvider<List<ContentModel>>.internal(
      completedContents,
      name: r'completedContentsProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$completedContentsHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef CompletedContentsRef = AutoDisposeFutureProviderRef<List<ContentModel>>;
String _$contentsByPlatformHash() =>
    r'992eca8dddce566f2b5a4695d6dc2d5da8b9d4bc';

/// 특정 플랫폼의 콘텐츠만 제공하는 Provider
///
/// Copied from [contentsByPlatform].
@ProviderFor(contentsByPlatform)
const contentsByPlatformProvider = ContentsByPlatformFamily();

/// 특정 플랫폼의 콘텐츠만 제공하는 Provider
///
/// Copied from [contentsByPlatform].
class ContentsByPlatformFamily extends Family<AsyncValue<List<ContentModel>>> {
  /// 특정 플랫폼의 콘텐츠만 제공하는 Provider
  ///
  /// Copied from [contentsByPlatform].
  const ContentsByPlatformFamily();

  /// 특정 플랫폼의 콘텐츠만 제공하는 Provider
  ///
  /// Copied from [contentsByPlatform].
  ContentsByPlatformProvider call(String platform) {
    return ContentsByPlatformProvider(platform);
  }

  @override
  ContentsByPlatformProvider getProviderOverride(
    covariant ContentsByPlatformProvider provider,
  ) {
    return call(provider.platform);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'contentsByPlatformProvider';
}

/// 특정 플랫폼의 콘텐츠만 제공하는 Provider
///
/// Copied from [contentsByPlatform].
class ContentsByPlatformProvider
    extends AutoDisposeFutureProvider<List<ContentModel>> {
  /// 특정 플랫폼의 콘텐츠만 제공하는 Provider
  ///
  /// Copied from [contentsByPlatform].
  ContentsByPlatformProvider(String platform)
    : this._internal(
        (ref) => contentsByPlatform(ref as ContentsByPlatformRef, platform),
        from: contentsByPlatformProvider,
        name: r'contentsByPlatformProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$contentsByPlatformHash,
        dependencies: ContentsByPlatformFamily._dependencies,
        allTransitiveDependencies:
            ContentsByPlatformFamily._allTransitiveDependencies,
        platform: platform,
      );

  ContentsByPlatformProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.platform,
  }) : super.internal();

  final String platform;

  @override
  Override overrideWith(
    FutureOr<List<ContentModel>> Function(ContentsByPlatformRef provider)
    create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ContentsByPlatformProvider._internal(
        (ref) => create(ref as ContentsByPlatformRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        platform: platform,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<ContentModel>> createElement() {
    return _ContentsByPlatformProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ContentsByPlatformProvider && other.platform == platform;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, platform.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin ContentsByPlatformRef
    on AutoDisposeFutureProviderRef<List<ContentModel>> {
  /// The parameter `platform` of this provider.
  String get platform;
}

class _ContentsByPlatformProviderElement
    extends AutoDisposeFutureProviderElement<List<ContentModel>>
    with ContentsByPlatformRef {
  _ContentsByPlatformProviderElement(super.provider);

  @override
  String get platform => (origin as ContentsByPlatformProvider).platform;
}

String _$recentSavedPlacesHash() => r'a8fac3b9da238d2c58d795e93015054cf00a97bb';

/// 최근 저장한 장소를 제공하는 Provider
///
/// COMPLETED 상태인 콘텐츠에서 장소를 추출하여 최근 3개만 반환합니다.
/// USE_MOCK_API 플래그에 따라 Mock 또는 실제 API 데이터를 사용합니다.
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
String _$contentListHash() => r'36f3f018fb16b6c8a6ec9b1d04607ff18e84e25a';

/// 모든 콘텐츠 목록을 제공하는 Provider
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
