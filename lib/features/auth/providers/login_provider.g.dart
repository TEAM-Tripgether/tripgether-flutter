// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$loginNotifierHash() => r'2a60cd114be702c6f6dd155c26e8fee06db7c2fb';

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
/// ⚠️ **현재 미사용 기능** - 로그인 화면에서 사용하지 않음
/// 자동 로그인 기능이 필요하면 구현, 불필요하면 삭제 권장
///
/// **구현 계획 (필요 시)**:
/// 1. SharedPreferences 패키지 추가
/// 2. 아래 주석 해제하고 로그인 화면에 체크박스 추가
/// 3. 앱 시작 시 토큰 유효성 검사 후 자동 로그인 처리
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
