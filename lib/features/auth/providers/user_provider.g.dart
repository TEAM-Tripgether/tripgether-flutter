// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$accessTokenHash() => r'4273519c7d1790d1178aa1d68f56d1c226932c33';

/// Access Token 읽기 Provider
///
/// API 요청 시 Authorization 헤더에 사용합니다.
///
/// **사용 예시**:
/// ```dart
/// final accessToken = await ref.read(accessTokenProvider.future);
/// if (accessToken != null) {
///   dio.options.headers['Authorization'] = 'Bearer $accessToken';
/// }
/// ```
///
/// Copied from [accessToken].
@ProviderFor(accessToken)
final accessTokenProvider = AutoDisposeFutureProvider<String?>.internal(
  accessToken,
  name: r'accessTokenProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$accessTokenHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef AccessTokenRef = AutoDisposeFutureProviderRef<String?>;
String _$refreshTokenHash() => r'f0d9a2d585eb3035384146c7e6e5a81e22b10848';

/// Refresh Token 읽기 Provider
///
/// Access Token 재발급 시 사용합니다.
///
/// **사용 예시**:
/// ```dart
/// final refreshToken = await ref.read(refreshTokenProvider.future);
/// if (refreshToken != null) {
///   final newTokens = await authService.reissueToken(refreshToken);
/// }
/// ```
///
/// Copied from [refreshToken].
@ProviderFor(refreshToken)
final refreshTokenProvider = AutoDisposeFutureProvider<String?>.internal(
  refreshToken,
  name: r'refreshTokenProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$refreshTokenHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef RefreshTokenRef = AutoDisposeFutureProviderRef<String?>;
String _$userNotifierHash() => r'a77fba9cbedb3820b5d90bded18e95bb51a628ce';

/// 사용자 정보 상태 관리 Provider
///
/// **역할**:
/// - 로그인 시 사용자 정보를 Secure Storage에 저장
/// - 앱 시작 시 저장된 사용자 정보를 자동으로 로드
/// - 로그아웃 시 사용자 정보를 삭제
///
/// **사용 위치**:
/// - LoginProvider: 로그인 성공 시 `setUser()` 호출
/// - ProfileHeader: 사용자 정보 표시를 위해 `watch(userNotifierProvider)` 사용
/// - 전역: 사용자 로그인 상태 확인
///
/// **상태 타입**: `AsyncValue<User?>`
/// - `AsyncValue.data(User)`: 로그인된 사용자
/// - `AsyncValue.data(null)`: 로그인하지 않은 상태
/// - `AsyncValue.loading()`: 로딩 중
/// - `AsyncValue.error()`: 에러 발생
///
/// Copied from [UserNotifier].
@ProviderFor(UserNotifier)
final userNotifierProvider =
    AsyncNotifierProvider<UserNotifier, User?>.internal(
      UserNotifier.new,
      name: r'userNotifierProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$userNotifierHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$UserNotifier = AsyncNotifier<User?>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
