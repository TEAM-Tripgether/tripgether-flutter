// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile_edit_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$profileEditNotifierHash() =>
    r'a0b720262e864900be1cfafe261042ca7073f8fc';

/// 프로필 편집 Provider
///
/// **기능**:
/// - 프로필 정보 수정 (POST /api/members/profile)
/// - 회원 탈퇴 (DELETE /api/auth/withdraw)
///
/// **API 문서**: docs/BackendAPI.md
///
/// Copied from [ProfileEditNotifier].
@ProviderFor(ProfileEditNotifier)
final profileEditNotifierProvider =
    AutoDisposeNotifierProvider<ProfileEditNotifier, ProfileEditState>.internal(
      ProfileEditNotifier.new,
      name: r'profileEditNotifierProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$profileEditNotifierHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$ProfileEditNotifier = AutoDisposeNotifier<ProfileEditState>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
