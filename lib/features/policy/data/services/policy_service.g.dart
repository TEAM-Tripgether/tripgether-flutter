// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'policy_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$policyServiceHash() => r'8d65532710d5a45e0e85596a91337e2d594e8a37';

/// PolicyService Provider
///
/// Copied from [policyService].
@ProviderFor(policyService)
final policyServiceProvider = AutoDisposeProvider<PolicyService>.internal(
  policyService,
  name: r'policyServiceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$policyServiceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef PolicyServiceRef = AutoDisposeProviderRef<PolicyService>;
String _$policyHash() => r'c4371b74cfd8a055cd48004273e24c29b1101d64';

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

/// 특정 약관 데이터 Provider
///
/// **사용 예시**:
/// ```dart
/// final policyAsync = ref.watch(policyProvider(PolicyType.termsOfService));
/// ```
///
/// Copied from [policy].
@ProviderFor(policy)
const policyProvider = PolicyFamily();

/// 특정 약관 데이터 Provider
///
/// **사용 예시**:
/// ```dart
/// final policyAsync = ref.watch(policyProvider(PolicyType.termsOfService));
/// ```
///
/// Copied from [policy].
class PolicyFamily extends Family<AsyncValue<PolicyModel>> {
  /// 특정 약관 데이터 Provider
  ///
  /// **사용 예시**:
  /// ```dart
  /// final policyAsync = ref.watch(policyProvider(PolicyType.termsOfService));
  /// ```
  ///
  /// Copied from [policy].
  const PolicyFamily();

  /// 특정 약관 데이터 Provider
  ///
  /// **사용 예시**:
  /// ```dart
  /// final policyAsync = ref.watch(policyProvider(PolicyType.termsOfService));
  /// ```
  ///
  /// Copied from [policy].
  PolicyProvider call(PolicyType type) {
    return PolicyProvider(type);
  }

  @override
  PolicyProvider getProviderOverride(covariant PolicyProvider provider) {
    return call(provider.type);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'policyProvider';
}

/// 특정 약관 데이터 Provider
///
/// **사용 예시**:
/// ```dart
/// final policyAsync = ref.watch(policyProvider(PolicyType.termsOfService));
/// ```
///
/// Copied from [policy].
class PolicyProvider extends AutoDisposeFutureProvider<PolicyModel> {
  /// 특정 약관 데이터 Provider
  ///
  /// **사용 예시**:
  /// ```dart
  /// final policyAsync = ref.watch(policyProvider(PolicyType.termsOfService));
  /// ```
  ///
  /// Copied from [policy].
  PolicyProvider(PolicyType type)
    : this._internal(
        (ref) => policy(ref as PolicyRef, type),
        from: policyProvider,
        name: r'policyProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$policyHash,
        dependencies: PolicyFamily._dependencies,
        allTransitiveDependencies: PolicyFamily._allTransitiveDependencies,
        type: type,
      );

  PolicyProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.type,
  }) : super.internal();

  final PolicyType type;

  @override
  Override overrideWith(
    FutureOr<PolicyModel> Function(PolicyRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: PolicyProvider._internal(
        (ref) => create(ref as PolicyRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        type: type,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<PolicyModel> createElement() {
    return _PolicyProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is PolicyProvider && other.type == type;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, type.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin PolicyRef on AutoDisposeFutureProviderRef<PolicyModel> {
  /// The parameter `type` of this provider.
  PolicyType get type;
}

class _PolicyProviderElement
    extends AutoDisposeFutureProviderElement<PolicyModel>
    with PolicyRef {
  _PolicyProviderElement(super.provider);

  @override
  PolicyType get type => (origin as PolicyProvider).type;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
