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

  /// 사용자 이름 (선택)
  ///
  /// 소셜 로그인 API 호출 시 필수
  /// 백엔드 DB의 'name' 컬럼과 매핑됨
  String? get name => throw _privateConstructorUsedError;

  /// 프로필 이미지 URL (선택)
  ///
  /// 소셜 로그인 시 선택적으로 전송
  /// Google/Kakao에서 받은 프로필 사진 URL
  String? get profileUrl => throw _privateConstructorUsedError;

  /// 리프레시 토큰 (선택)
  ///
  /// 토큰 재발급 및 로그아웃 API 호출 시 필수
  String? get refreshToken =>
      throw _privateConstructorUsedError; // ═══════════════════════════════════════════════════════════════
  // 🆕 FCM 푸시 알림 필드 (멀티 디바이스 지원)
  // ═══════════════════════════════════════════════════════════════
  /// Firebase Cloud Messaging 토큰 (선택)
  ///
  /// 푸시 알림 발송을 위한 디바이스별 FCM 토큰
  /// - fcmToken, deviceType, deviceId는 **3개 모두 함께 전송** 또는 **모두 생략**
  /// - 일부만 전송 시 백엔드에서 400 Bad Request 반환
  String? get fcmToken => throw _privateConstructorUsedError;

  /// 기기 타입 (선택)
  ///
  /// 가능한 값: "IOS", "ANDROID"
  /// - fcmToken 제공 시 **필수**
  String? get deviceType => throw _privateConstructorUsedError;

  /// 기기 고유 식별자 (선택)
  ///
  /// UUID v4 형식의 디바이스 고유 ID
  /// - fcmToken 제공 시 **필수**
  /// - 한 사용자가 여러 기기(폰, 태블릿)에서 로그인 시 각 기기 식별용
  String? get deviceId => throw _privateConstructorUsedError;

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
    String? name,
    String? profileUrl,
    String? refreshToken,
    String? fcmToken,
    String? deviceType,
    String? deviceId,
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
    Object? name = freezed,
    Object? profileUrl = freezed,
    Object? refreshToken = freezed,
    Object? fcmToken = freezed,
    Object? deviceType = freezed,
    Object? deviceId = freezed,
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
            name: freezed == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String?,
            profileUrl: freezed == profileUrl
                ? _value.profileUrl
                : profileUrl // ignore: cast_nullable_to_non_nullable
                      as String?,
            refreshToken: freezed == refreshToken
                ? _value.refreshToken
                : refreshToken // ignore: cast_nullable_to_non_nullable
                      as String?,
            fcmToken: freezed == fcmToken
                ? _value.fcmToken
                : fcmToken // ignore: cast_nullable_to_non_nullable
                      as String?,
            deviceType: freezed == deviceType
                ? _value.deviceType
                : deviceType // ignore: cast_nullable_to_non_nullable
                      as String?,
            deviceId: freezed == deviceId
                ? _value.deviceId
                : deviceId // ignore: cast_nullable_to_non_nullable
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
    String? name,
    String? profileUrl,
    String? refreshToken,
    String? fcmToken,
    String? deviceType,
    String? deviceId,
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
    Object? name = freezed,
    Object? profileUrl = freezed,
    Object? refreshToken = freezed,
    Object? fcmToken = freezed,
    Object? deviceType = freezed,
    Object? deviceId = freezed,
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
        name: freezed == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String?,
        profileUrl: freezed == profileUrl
            ? _value.profileUrl
            : profileUrl // ignore: cast_nullable_to_non_nullable
                  as String?,
        refreshToken: freezed == refreshToken
            ? _value.refreshToken
            : refreshToken // ignore: cast_nullable_to_non_nullable
                  as String?,
        fcmToken: freezed == fcmToken
            ? _value.fcmToken
            : fcmToken // ignore: cast_nullable_to_non_nullable
                  as String?,
        deviceType: freezed == deviceType
            ? _value.deviceType
            : deviceType // ignore: cast_nullable_to_non_nullable
                  as String?,
        deviceId: freezed == deviceId
            ? _value.deviceId
            : deviceId // ignore: cast_nullable_to_non_nullable
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
    this.name,
    this.profileUrl,
    this.refreshToken,
    this.fcmToken,
    this.deviceType,
    this.deviceId,
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

  /// 사용자 이름 (선택)
  ///
  /// 소셜 로그인 API 호출 시 필수
  /// 백엔드 DB의 'name' 컬럼과 매핑됨
  @override
  final String? name;

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
  // ═══════════════════════════════════════════════════════════════
  // 🆕 FCM 푸시 알림 필드 (멀티 디바이스 지원)
  // ═══════════════════════════════════════════════════════════════
  /// Firebase Cloud Messaging 토큰 (선택)
  ///
  /// 푸시 알림 발송을 위한 디바이스별 FCM 토큰
  /// - fcmToken, deviceType, deviceId는 **3개 모두 함께 전송** 또는 **모두 생략**
  /// - 일부만 전송 시 백엔드에서 400 Bad Request 반환
  @override
  final String? fcmToken;

  /// 기기 타입 (선택)
  ///
  /// 가능한 값: "IOS", "ANDROID"
  /// - fcmToken 제공 시 **필수**
  @override
  final String? deviceType;

  /// 기기 고유 식별자 (선택)
  ///
  /// UUID v4 형식의 디바이스 고유 ID
  /// - fcmToken 제공 시 **필수**
  /// - 한 사용자가 여러 기기(폰, 태블릿)에서 로그인 시 각 기기 식별용
  @override
  final String? deviceId;

  @override
  String toString() {
    return 'AuthRequest(socialPlatform: $socialPlatform, email: $email, name: $name, profileUrl: $profileUrl, refreshToken: $refreshToken, fcmToken: $fcmToken, deviceType: $deviceType, deviceId: $deviceId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AuthRequestImpl &&
            (identical(other.socialPlatform, socialPlatform) ||
                other.socialPlatform == socialPlatform) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.profileUrl, profileUrl) ||
                other.profileUrl == profileUrl) &&
            (identical(other.refreshToken, refreshToken) ||
                other.refreshToken == refreshToken) &&
            (identical(other.fcmToken, fcmToken) ||
                other.fcmToken == fcmToken) &&
            (identical(other.deviceType, deviceType) ||
                other.deviceType == deviceType) &&
            (identical(other.deviceId, deviceId) ||
                other.deviceId == deviceId));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    socialPlatform,
    email,
    name,
    profileUrl,
    refreshToken,
    fcmToken,
    deviceType,
    deviceId,
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
    final String? name,
    final String? profileUrl,
    final String? refreshToken,
    final String? fcmToken,
    final String? deviceType,
    final String? deviceId,
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

  /// 사용자 이름 (선택)
  ///
  /// 소셜 로그인 API 호출 시 필수
  /// 백엔드 DB의 'name' 컬럼과 매핑됨
  @override
  String? get name;

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
  String? get refreshToken; // ═══════════════════════════════════════════════════════════════
  // 🆕 FCM 푸시 알림 필드 (멀티 디바이스 지원)
  // ═══════════════════════════════════════════════════════════════
  /// Firebase Cloud Messaging 토큰 (선택)
  ///
  /// 푸시 알림 발송을 위한 디바이스별 FCM 토큰
  /// - fcmToken, deviceType, deviceId는 **3개 모두 함께 전송** 또는 **모두 생략**
  /// - 일부만 전송 시 백엔드에서 400 Bad Request 반환
  @override
  String? get fcmToken;

  /// 기기 타입 (선택)
  ///
  /// 가능한 값: "IOS", "ANDROID"
  /// - fcmToken 제공 시 **필수**
  @override
  String? get deviceType;

  /// 기기 고유 식별자 (선택)
  ///
  /// UUID v4 형식의 디바이스 고유 ID
  /// - fcmToken 제공 시 **필수**
  /// - 한 사용자가 여러 기기(폰, 태블릿)에서 로그인 시 각 기기 식별용
  @override
  String? get deviceId;

  /// Create a copy of AuthRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AuthRequestImplCopyWith<_$AuthRequestImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
