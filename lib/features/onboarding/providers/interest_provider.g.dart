// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'interest_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$dioHash() => r'97e2f7c7055d4e32a6f7313f15c4cc2499145eb1';

/// Dio 인스턴스 Provider (JWT 토큰 자동 추가)
///
/// **특징**:
/// - Interceptor를 통해 모든 요청에 JWT 토큰 자동 추가
/// - FlutterSecureStorage에서 access_token 읽기
/// - 토큰이 없으면 요청 그대로 진행 (인증 불필요한 API 대응)
///
/// Copied from [dio].
@ProviderFor(dio)
final dioProvider = AutoDisposeProvider<Dio>.internal(
  dio,
  name: r'dioProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$dioHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef DioRef = AutoDisposeProviderRef<Dio>;
String _$interestApiServiceHash() =>
    r'd7d7e5013e7a6cb17cc3405630ad4a5c8e7a17ea';

/// Interest API Service Provider
///
/// Copied from [interestApiService].
@ProviderFor(interestApiService)
final interestApiServiceProvider =
    AutoDisposeProvider<InterestApiService>.internal(
      interestApiService,
      name: r'interestApiServiceProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$interestApiServiceHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef InterestApiServiceRef = AutoDisposeProviderRef<InterestApiService>;
String _$interestsHash() => r'615b39fb7118eaca8cdedbb153a5d3c2e7a88e63';

/// 전체 관심사 목록 조회 Provider
///
/// GET /api/interests
///
/// **특징**:
/// - Redis 캐싱 적용 (서버)
/// - Mock 모드에서는 하드코딩된 데이터 반환
/// - API 실패 시 Fallback으로 Mock 데이터 사용
///
/// Copied from [interests].
@ProviderFor(interests)
final interestsProvider =
    AutoDisposeFutureProvider<GetAllInterestsResponse>.internal(
      interests,
      name: r'interestsProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$interestsHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef InterestsRef = AutoDisposeFutureProviderRef<GetAllInterestsResponse>;
String _$interestByIdHash() => r'19e64bc327a205f2c05893fa20daac44efe32038';

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

/// 관심사 상세 조회 Provider
///
/// GET /api/interests/{interestId}
///
/// Copied from [interestById].
@ProviderFor(interestById)
const interestByIdProvider = InterestByIdFamily();

/// 관심사 상세 조회 Provider
///
/// GET /api/interests/{interestId}
///
/// Copied from [interestById].
class InterestByIdFamily extends Family<AsyncValue<GetInterestByIdResponse>> {
  /// 관심사 상세 조회 Provider
  ///
  /// GET /api/interests/{interestId}
  ///
  /// Copied from [interestById].
  const InterestByIdFamily();

  /// 관심사 상세 조회 Provider
  ///
  /// GET /api/interests/{interestId}
  ///
  /// Copied from [interestById].
  InterestByIdProvider call(String interestId) {
    return InterestByIdProvider(interestId);
  }

  @override
  InterestByIdProvider getProviderOverride(
    covariant InterestByIdProvider provider,
  ) {
    return call(provider.interestId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'interestByIdProvider';
}

/// 관심사 상세 조회 Provider
///
/// GET /api/interests/{interestId}
///
/// Copied from [interestById].
class InterestByIdProvider
    extends AutoDisposeFutureProvider<GetInterestByIdResponse> {
  /// 관심사 상세 조회 Provider
  ///
  /// GET /api/interests/{interestId}
  ///
  /// Copied from [interestById].
  InterestByIdProvider(String interestId)
    : this._internal(
        (ref) => interestById(ref as InterestByIdRef, interestId),
        from: interestByIdProvider,
        name: r'interestByIdProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$interestByIdHash,
        dependencies: InterestByIdFamily._dependencies,
        allTransitiveDependencies:
            InterestByIdFamily._allTransitiveDependencies,
        interestId: interestId,
      );

  InterestByIdProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.interestId,
  }) : super.internal();

  final String interestId;

  @override
  Override overrideWith(
    FutureOr<GetInterestByIdResponse> Function(InterestByIdRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: InterestByIdProvider._internal(
        (ref) => create(ref as InterestByIdRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        interestId: interestId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<GetInterestByIdResponse> createElement() {
    return _InterestByIdProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is InterestByIdProvider && other.interestId == interestId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, interestId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin InterestByIdRef on AutoDisposeFutureProviderRef<GetInterestByIdResponse> {
  /// The parameter `interestId` of this provider.
  String get interestId;
}

class _InterestByIdProviderElement
    extends AutoDisposeFutureProviderElement<GetInterestByIdResponse>
    with InterestByIdRef {
  _InterestByIdProviderElement(super.provider);

  @override
  String get interestId => (origin as InterestByIdProvider).interestId;
}

String _$interestsByCategoryHash() =>
    r'392b9667a876260af28c8d18055806f0ab9e2bea';

/// 특정 카테고리 관심사 조회 Provider
///
/// GET /api/interests/categories/{category}
///
/// Copied from [interestsByCategory].
@ProviderFor(interestsByCategory)
const interestsByCategoryProvider = InterestsByCategoryFamily();

/// 특정 카테고리 관심사 조회 Provider
///
/// GET /api/interests/categories/{category}
///
/// Copied from [interestsByCategory].
class InterestsByCategoryFamily
    extends Family<AsyncValue<GetInterestsByCategoryResponse>> {
  /// 특정 카테고리 관심사 조회 Provider
  ///
  /// GET /api/interests/categories/{category}
  ///
  /// Copied from [interestsByCategory].
  const InterestsByCategoryFamily();

  /// 특정 카테고리 관심사 조회 Provider
  ///
  /// GET /api/interests/categories/{category}
  ///
  /// Copied from [interestsByCategory].
  InterestsByCategoryProvider call(String category) {
    return InterestsByCategoryProvider(category);
  }

  @override
  InterestsByCategoryProvider getProviderOverride(
    covariant InterestsByCategoryProvider provider,
  ) {
    return call(provider.category);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'interestsByCategoryProvider';
}

/// 특정 카테고리 관심사 조회 Provider
///
/// GET /api/interests/categories/{category}
///
/// Copied from [interestsByCategory].
class InterestsByCategoryProvider
    extends AutoDisposeFutureProvider<GetInterestsByCategoryResponse> {
  /// 특정 카테고리 관심사 조회 Provider
  ///
  /// GET /api/interests/categories/{category}
  ///
  /// Copied from [interestsByCategory].
  InterestsByCategoryProvider(String category)
    : this._internal(
        (ref) => interestsByCategory(ref as InterestsByCategoryRef, category),
        from: interestsByCategoryProvider,
        name: r'interestsByCategoryProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$interestsByCategoryHash,
        dependencies: InterestsByCategoryFamily._dependencies,
        allTransitiveDependencies:
            InterestsByCategoryFamily._allTransitiveDependencies,
        category: category,
      );

  InterestsByCategoryProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.category,
  }) : super.internal();

  final String category;

  @override
  Override overrideWith(
    FutureOr<GetInterestsByCategoryResponse> Function(
      InterestsByCategoryRef provider,
    )
    create,
  ) {
    return ProviderOverride(
      origin: this,
      override: InterestsByCategoryProvider._internal(
        (ref) => create(ref as InterestsByCategoryRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        category: category,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<GetInterestsByCategoryResponse>
  createElement() {
    return _InterestsByCategoryProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is InterestsByCategoryProvider && other.category == category;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, category.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin InterestsByCategoryRef
    on AutoDisposeFutureProviderRef<GetInterestsByCategoryResponse> {
  /// The parameter `category` of this provider.
  String get category;
}

class _InterestsByCategoryProviderElement
    extends AutoDisposeFutureProviderElement<GetInterestsByCategoryResponse>
    with InterestsByCategoryRef {
  _InterestsByCategoryProviderElement(super.provider);

  @override
  String get category => (origin as InterestsByCategoryProvider).category;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
