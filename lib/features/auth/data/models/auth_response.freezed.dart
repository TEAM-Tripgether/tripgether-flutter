// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'auth_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

AuthResponse _$AuthResponseFromJson(Map<String, dynamic> json) {
  return _AuthResponse.fromJson(json);
}

/// @nodoc
mixin _$AuthResponse {
  /// JWT Access Token
  ///
  /// 유효기간: 1시간
  /// API 요청 시 Authorization 헤더에 포함
  /// 형식: Bearer {accessToken}
  String get accessToken => throw _privateConstructorUsedError;

  /// JWT Refresh Token
  ///
  /// 유효기간: 7일
  /// Access Token 만료 시 재발급에 사용
  String get refreshToken => throw _privateConstructorUsedError;

  /// 최초 로그인 여부
  ///
  /// - true: 회원가입 (최초 로그인)
  /// - false: 기존 회원 로그인
  ///
  /// 최초 로그인 시 추가 프로필 설정 화면으로 이동할 수 있습니다.
  bool get isFirstLogin => throw _privateConstructorUsedError;

  /// Serializes this AuthResponse to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AuthResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AuthResponseCopyWith<AuthResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AuthResponseCopyWith<$Res> {
  factory $AuthResponseCopyWith(
    AuthResponse value,
    $Res Function(AuthResponse) then,
  ) = _$AuthResponseCopyWithImpl<$Res, AuthResponse>;
  @useResult
  $Res call({String accessToken, String refreshToken, bool isFirstLogin});
}

/// @nodoc
class _$AuthResponseCopyWithImpl<$Res, $Val extends AuthResponse>
    implements $AuthResponseCopyWith<$Res> {
  _$AuthResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AuthResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? accessToken = null,
    Object? refreshToken = null,
    Object? isFirstLogin = null,
  }) {
    return _then(
      _value.copyWith(
            accessToken: null == accessToken
                ? _value.accessToken
                : accessToken // ignore: cast_nullable_to_non_nullable
                      as String,
            refreshToken: null == refreshToken
                ? _value.refreshToken
                : refreshToken // ignore: cast_nullable_to_non_nullable
                      as String,
            isFirstLogin: null == isFirstLogin
                ? _value.isFirstLogin
                : isFirstLogin // ignore: cast_nullable_to_non_nullable
                      as bool,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$AuthResponseImplCopyWith<$Res>
    implements $AuthResponseCopyWith<$Res> {
  factory _$$AuthResponseImplCopyWith(
    _$AuthResponseImpl value,
    $Res Function(_$AuthResponseImpl) then,
  ) = __$$AuthResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String accessToken, String refreshToken, bool isFirstLogin});
}

/// @nodoc
class __$$AuthResponseImplCopyWithImpl<$Res>
    extends _$AuthResponseCopyWithImpl<$Res, _$AuthResponseImpl>
    implements _$$AuthResponseImplCopyWith<$Res> {
  __$$AuthResponseImplCopyWithImpl(
    _$AuthResponseImpl _value,
    $Res Function(_$AuthResponseImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AuthResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? accessToken = null,
    Object? refreshToken = null,
    Object? isFirstLogin = null,
  }) {
    return _then(
      _$AuthResponseImpl(
        accessToken: null == accessToken
            ? _value.accessToken
            : accessToken // ignore: cast_nullable_to_non_nullable
                  as String,
        refreshToken: null == refreshToken
            ? _value.refreshToken
            : refreshToken // ignore: cast_nullable_to_non_nullable
                  as String,
        isFirstLogin: null == isFirstLogin
            ? _value.isFirstLogin
            : isFirstLogin // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$AuthResponseImpl extends _AuthResponse {
  const _$AuthResponseImpl({
    required this.accessToken,
    required this.refreshToken,
    required this.isFirstLogin,
  }) : super._();

  factory _$AuthResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$AuthResponseImplFromJson(json);

  /// JWT Access Token
  ///
  /// 유효기간: 1시간
  /// API 요청 시 Authorization 헤더에 포함
  /// 형식: Bearer {accessToken}
  @override
  final String accessToken;

  /// JWT Refresh Token
  ///
  /// 유효기간: 7일
  /// Access Token 만료 시 재발급에 사용
  @override
  final String refreshToken;

  /// 최초 로그인 여부
  ///
  /// - true: 회원가입 (최초 로그인)
  /// - false: 기존 회원 로그인
  ///
  /// 최초 로그인 시 추가 프로필 설정 화면으로 이동할 수 있습니다.
  @override
  final bool isFirstLogin;

  @override
  String toString() {
    return 'AuthResponse(accessToken: $accessToken, refreshToken: $refreshToken, isFirstLogin: $isFirstLogin)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AuthResponseImpl &&
            (identical(other.accessToken, accessToken) ||
                other.accessToken == accessToken) &&
            (identical(other.refreshToken, refreshToken) ||
                other.refreshToken == refreshToken) &&
            (identical(other.isFirstLogin, isFirstLogin) ||
                other.isFirstLogin == isFirstLogin));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, accessToken, refreshToken, isFirstLogin);

  /// Create a copy of AuthResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AuthResponseImplCopyWith<_$AuthResponseImpl> get copyWith =>
      __$$AuthResponseImplCopyWithImpl<_$AuthResponseImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AuthResponseImplToJson(this);
  }
}

abstract class _AuthResponse extends AuthResponse {
  const factory _AuthResponse({
    required final String accessToken,
    required final String refreshToken,
    required final bool isFirstLogin,
  }) = _$AuthResponseImpl;
  const _AuthResponse._() : super._();

  factory _AuthResponse.fromJson(Map<String, dynamic> json) =
      _$AuthResponseImpl.fromJson;

  /// JWT Access Token
  ///
  /// 유효기간: 1시간
  /// API 요청 시 Authorization 헤더에 포함
  /// 형식: Bearer {accessToken}
  @override
  String get accessToken;

  /// JWT Refresh Token
  ///
  /// 유효기간: 7일
  /// Access Token 만료 시 재발급에 사용
  @override
  String get refreshToken;

  /// 최초 로그인 여부
  ///
  /// - true: 회원가입 (최초 로그인)
  /// - false: 기존 회원 로그인
  ///
  /// 최초 로그인 시 추가 프로필 설정 화면으로 이동할 수 있습니다.
  @override
  bool get isFirstLogin;

  /// Create a copy of AuthResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AuthResponseImplCopyWith<_$AuthResponseImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
