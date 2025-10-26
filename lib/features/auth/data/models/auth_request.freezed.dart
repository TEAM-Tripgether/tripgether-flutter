// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'auth_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

AuthRequest _$AuthRequestFromJson(Map<String, dynamic> json) {
  return _AuthRequest.fromJson(json);
}

/// @nodoc
mixin _$AuthRequest {
  /// 소셜 로그인 플랫폼 (선택)
  ///
  /// 가능한 값: "GOOGLE", "KAKAO"
  /// 소셜 로그인 API 호출 시 필수
  String? get socialPlatform => throw _privateConstructorUsedError;

  /// 사용자 이메일 (선택)
  ///
  /// 소셜 로그인 API 호출 시 필수
  String? get email => throw _privateConstructorUsedError;

  /// 사용자 닉네임 (선택)
  ///
  /// 소셜 로그인 API 호출 시 필수
  String? get nickname => throw _privateConstructorUsedError;

  /// 프로필 이미지 URL (선택)
  ///
  /// 소셜 로그인 시 선택적으로 전송
  /// Google/Kakao에서 받은 프로필 사진 URL
  String? get profileUrl => throw _privateConstructorUsedError;

  /// 리프레시 토큰 (선택)
  ///
  /// 토큰 재발급 및 로그아웃 API 호출 시 필수
  String? get refreshToken => throw _privateConstructorUsedError;

  /// Serializes this AuthRequest to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AuthRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AuthRequestCopyWith<AuthRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AuthRequestCopyWith<$Res> {
  factory $AuthRequestCopyWith(
    AuthRequest value,
    $Res Function(AuthRequest) then,
  ) = _$AuthRequestCopyWithImpl<$Res, AuthRequest>;
  @useResult
  $Res call({
    String? socialPlatform,
    String? email,
    String? nickname,
    String? profileUrl,
    String? refreshToken,
  });
}

/// @nodoc
class _$AuthRequestCopyWithImpl<$Res, $Val extends AuthRequest>
    implements $AuthRequestCopyWith<$Res> {
  _$AuthRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AuthRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? socialPlatform = freezed,
    Object? email = freezed,
    Object? nickname = freezed,
    Object? profileUrl = freezed,
    Object? refreshToken = freezed,
  }) {
    return _then(
      _value.copyWith(
            socialPlatform: freezed == socialPlatform
                ? _value.socialPlatform
                : socialPlatform // ignore: cast_nullable_to_non_nullable
                      as String?,
            email: freezed == email
                ? _value.email
                : email // ignore: cast_nullable_to_non_nullable
                      as String?,
            nickname: freezed == nickname
                ? _value.nickname
                : nickname // ignore: cast_nullable_to_non_nullable
                      as String?,
            profileUrl: freezed == profileUrl
                ? _value.profileUrl
                : profileUrl // ignore: cast_nullable_to_non_nullable
                      as String?,
            refreshToken: freezed == refreshToken
                ? _value.refreshToken
                : refreshToken // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$AuthRequestImplCopyWith<$Res>
    implements $AuthRequestCopyWith<$Res> {
  factory _$$AuthRequestImplCopyWith(
    _$AuthRequestImpl value,
    $Res Function(_$AuthRequestImpl) then,
  ) = __$$AuthRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String? socialPlatform,
    String? email,
    String? nickname,
    String? profileUrl,
    String? refreshToken,
  });
}

/// @nodoc
class __$$AuthRequestImplCopyWithImpl<$Res>
    extends _$AuthRequestCopyWithImpl<$Res, _$AuthRequestImpl>
    implements _$$AuthRequestImplCopyWith<$Res> {
  __$$AuthRequestImplCopyWithImpl(
    _$AuthRequestImpl _value,
    $Res Function(_$AuthRequestImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AuthRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? socialPlatform = freezed,
    Object? email = freezed,
    Object? nickname = freezed,
    Object? profileUrl = freezed,
    Object? refreshToken = freezed,
  }) {
    return _then(
      _$AuthRequestImpl(
        socialPlatform: freezed == socialPlatform
            ? _value.socialPlatform
            : socialPlatform // ignore: cast_nullable_to_non_nullable
                  as String?,
        email: freezed == email
            ? _value.email
            : email // ignore: cast_nullable_to_non_nullable
                  as String?,
        nickname: freezed == nickname
            ? _value.nickname
            : nickname // ignore: cast_nullable_to_non_nullable
                  as String?,
        profileUrl: freezed == profileUrl
            ? _value.profileUrl
            : profileUrl // ignore: cast_nullable_to_non_nullable
                  as String?,
        refreshToken: freezed == refreshToken
            ? _value.refreshToken
            : refreshToken // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$AuthRequestImpl implements _AuthRequest {
  const _$AuthRequestImpl({
    this.socialPlatform,
    this.email,
    this.nickname,
    this.profileUrl,
    this.refreshToken,
  });

  factory _$AuthRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$AuthRequestImplFromJson(json);

  /// 소셜 로그인 플랫폼 (선택)
  ///
  /// 가능한 값: "GOOGLE", "KAKAO"
  /// 소셜 로그인 API 호출 시 필수
  @override
  final String? socialPlatform;

  /// 사용자 이메일 (선택)
  ///
  /// 소셜 로그인 API 호출 시 필수
  @override
  final String? email;

  /// 사용자 닉네임 (선택)
  ///
  /// 소셜 로그인 API 호출 시 필수
  @override
  final String? nickname;

  /// 프로필 이미지 URL (선택)
  ///
  /// 소셜 로그인 시 선택적으로 전송
  /// Google/Kakao에서 받은 프로필 사진 URL
  @override
  final String? profileUrl;

  /// 리프레시 토큰 (선택)
  ///
  /// 토큰 재발급 및 로그아웃 API 호출 시 필수
  @override
  final String? refreshToken;

  @override
  String toString() {
    return 'AuthRequest(socialPlatform: $socialPlatform, email: $email, nickname: $nickname, profileUrl: $profileUrl, refreshToken: $refreshToken)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AuthRequestImpl &&
            (identical(other.socialPlatform, socialPlatform) ||
                other.socialPlatform == socialPlatform) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.nickname, nickname) ||
                other.nickname == nickname) &&
            (identical(other.profileUrl, profileUrl) ||
                other.profileUrl == profileUrl) &&
            (identical(other.refreshToken, refreshToken) ||
                other.refreshToken == refreshToken));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    socialPlatform,
    email,
    nickname,
    profileUrl,
    refreshToken,
  );

  /// Create a copy of AuthRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AuthRequestImplCopyWith<_$AuthRequestImpl> get copyWith =>
      __$$AuthRequestImplCopyWithImpl<_$AuthRequestImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AuthRequestImplToJson(this);
  }
}

abstract class _AuthRequest implements AuthRequest {
  const factory _AuthRequest({
    final String? socialPlatform,
    final String? email,
    final String? nickname,
    final String? profileUrl,
    final String? refreshToken,
  }) = _$AuthRequestImpl;

  factory _AuthRequest.fromJson(Map<String, dynamic> json) =
      _$AuthRequestImpl.fromJson;

  /// 소셜 로그인 플랫폼 (선택)
  ///
  /// 가능한 값: "GOOGLE", "KAKAO"
  /// 소셜 로그인 API 호출 시 필수
  @override
  String? get socialPlatform;

  /// 사용자 이메일 (선택)
  ///
  /// 소셜 로그인 API 호출 시 필수
  @override
  String? get email;

  /// 사용자 닉네임 (선택)
  ///
  /// 소셜 로그인 API 호출 시 필수
  @override
  String? get nickname;

  /// 프로필 이미지 URL (선택)
  ///
  /// 소셜 로그인 시 선택적으로 전송
  /// Google/Kakao에서 받은 프로필 사진 URL
  @override
  String? get profileUrl;

  /// 리프레시 토큰 (선택)
  ///
  /// 토큰 재발급 및 로그아웃 API 호출 시 필수
  @override
  String? get refreshToken;

  /// Create a copy of AuthRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AuthRequestImplCopyWith<_$AuthRequestImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
