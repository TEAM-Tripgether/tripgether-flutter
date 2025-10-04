// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// 로그인 상태 관리 Provider
///
/// 이메일/비밀번호 로그인과 소셜 로그인(카카오, 네이버)을 처리합니다.
/// AsyncNotifier를 사용하여 로딩/에러/성공 상태를 자동으로 관리합니다.

@ProviderFor(LoginNotifier)
const loginProvider = LoginNotifierProvider._();

/// 로그인 상태 관리 Provider
///
/// 이메일/비밀번호 로그인과 소셜 로그인(카카오, 네이버)을 처리합니다.
/// AsyncNotifier를 사용하여 로딩/에러/성공 상태를 자동으로 관리합니다.
final class LoginNotifierProvider
    extends $AsyncNotifierProvider<LoginNotifier, void> {
  /// 로그인 상태 관리 Provider
  ///
  /// 이메일/비밀번호 로그인과 소셜 로그인(카카오, 네이버)을 처리합니다.
  /// AsyncNotifier를 사용하여 로딩/에러/성공 상태를 자동으로 관리합니다.
  const LoginNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'loginProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$loginNotifierHash();

  @$internal
  @override
  LoginNotifier create() => LoginNotifier();
}

String _$loginNotifierHash() => r'154d4847b5245806f553104654989dc8b2c1b4bf';

/// 로그인 상태 관리 Provider
///
/// 이메일/비밀번호 로그인과 소셜 로그인(카카오, 네이버)을 처리합니다.
/// AsyncNotifier를 사용하여 로딩/에러/성공 상태를 자동으로 관리합니다.

abstract class _$LoginNotifier extends $AsyncNotifier<void> {
  FutureOr<void> build();
  @$mustCallSuper
  @override
  void runBuild() {
    build();
    final ref = this.ref as $Ref<AsyncValue<void>, void>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<void>, void>,
              AsyncValue<void>,
              Object?,
              Object?
            >;
    element.handleValue(ref, null);
  }
}

/// 자동 로그인 상태 Provider
///
/// 사용자가 "자동로그인" 체크박스를 선택했는지 여부를 관리합니다.
/// SharedPreferences에 저장되어 앱 재시작 시에도 유지됩니다.

@ProviderFor(RememberMeNotifier)
const rememberMeProvider = RememberMeNotifierProvider._();

/// 자동 로그인 상태 Provider
///
/// 사용자가 "자동로그인" 체크박스를 선택했는지 여부를 관리합니다.
/// SharedPreferences에 저장되어 앱 재시작 시에도 유지됩니다.
final class RememberMeNotifierProvider
    extends $NotifierProvider<RememberMeNotifier, bool> {
  /// 자동 로그인 상태 Provider
  ///
  /// 사용자가 "자동로그인" 체크박스를 선택했는지 여부를 관리합니다.
  /// SharedPreferences에 저장되어 앱 재시작 시에도 유지됩니다.
  const RememberMeNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'rememberMeProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$rememberMeNotifierHash();

  @$internal
  @override
  RememberMeNotifier create() => RememberMeNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$rememberMeNotifierHash() =>
    r'fcbf99596801a816f7aff1c781db1416f8581f49';

/// 자동 로그인 상태 Provider
///
/// 사용자가 "자동로그인" 체크박스를 선택했는지 여부를 관리합니다.
/// SharedPreferences에 저장되어 앱 재시작 시에도 유지됩니다.

abstract class _$RememberMeNotifier extends $Notifier<bool> {
  bool build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<bool, bool>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<bool, bool>,
              bool,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
