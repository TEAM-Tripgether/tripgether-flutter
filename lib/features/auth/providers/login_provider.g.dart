// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$loginNotifierHash() => r'f02741eae35d9cc7748eadc4f9a8d4e0ebfc8f47';

/// 로그인 상태 관리 Provider
///
/// 이메일/비밀번호 로그인과 소셜 로그인(카카오, 네이버)을 처리합니다.
/// AsyncNotifier를 사용하여 로딩/에러/성공 상태를 자동으로 관리합니다.
///
/// Copied from [LoginNotifier].
@ProviderFor(LoginNotifier)
final loginNotifierProvider =
    AutoDisposeAsyncNotifierProvider<LoginNotifier, void>.internal(
      LoginNotifier.new,
      name: r'loginNotifierProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$loginNotifierHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$LoginNotifier = AutoDisposeAsyncNotifier<void>;
String _$rememberMeNotifierHash() =>
    r'fcbf99596801a816f7aff1c781db1416f8581f49';

/// 자동 로그인 상태 Provider
///
/// 사용자가 "자동로그인" 체크박스를 선택했는지 여부를 관리합니다.
/// SharedPreferences에 저장되어 앱 재시작 시에도 유지됩니다.
///
/// Copied from [RememberMeNotifier].
@ProviderFor(RememberMeNotifier)
final rememberMeNotifierProvider =
    AutoDisposeNotifierProvider<RememberMeNotifier, bool>.internal(
      RememberMeNotifier.new,
      name: r'rememberMeNotifierProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$rememberMeNotifierHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$RememberMeNotifier = AutoDisposeNotifier<bool>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
