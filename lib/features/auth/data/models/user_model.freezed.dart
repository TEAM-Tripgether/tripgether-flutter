// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

User _$UserFromJson(Map<String, dynamic> json) {
  return _User.fromJson(json);
}

/// @nodoc
mixin _$User {
  /// 사용자 고유 ID (서버에서 발급)
  ///
  /// - 백엔드 API 연동 전: null (로컬에서 Google ID 사용)
  /// - 백엔드 API 연동 후: 서버에서 발급한 UUID
  String? get userId => throw _privateConstructorUsedError;

  /// 이메일 주소 (필수)
  ///
  /// Google 로그인 시 자동으로 받아옵니다.
  String get email => throw _privateConstructorUsedError;

  /// 닉네임 (필수)
  ///
  /// 서버의 name 필드에서 가져오거나, Google displayName 사용
  String get nickname => throw _privateConstructorUsedError;

  /// 프로필 이미지 URL (선택)
  ///
  /// Google 로그인 시 photoUrl로 받아오거나, 사용자가 직접 업로드한 이미지 URL
  /// 형식: https://lh3.googleusercontent.com/a/...
  String? get profileImageUrl => throw _privateConstructorUsedError;

  /// 로그인 플랫폼 (선택)
  ///
  /// 가능한 값: "GOOGLE", "KAKAO"
  /// 추후 Kakao 로그인 추가 시 사용
  String? get loginPlatform => throw _privateConstructorUsedError;

  /// 생성일시 (로컬 저장 시간)
  ///
  /// 사용자 정보가 처음 저장된 시간
  DateTime get createdAt =>
      throw _privateConstructorUsedError; // ════════════════════════════════════════════════════════════════════════
  // 서버 API 응답 필드 (/api/members/email/{email})
  // ════════════════════════════════════════════════════════════════════════
  /// 온보딩 상태 (서버에서 관리)
  ///
  /// 가능한 값: "NOT_STARTED", "IN_PROGRESS", "COMPLETED"
  String? get onboardingStatus => throw _privateConstructorUsedError;

  /// 서비스 이용약관 및 개인정보 처리방침 동의 여부
  bool? get isServiceTermsAndPrivacyAgreed =>
      throw _privateConstructorUsedError;

  /// 마케팅 수신 동의 여부
  bool? get isMarketingAgreed => throw _privateConstructorUsedError;

  /// 생년월일 (yyyy-MM-dd 형식)
  ///
  /// 예: "1990-01-01"
  String? get birthDate => throw _privateConstructorUsedError;

  /// 성별
  ///
  /// 가능한 값: "MALE", "FEMALE"
  String? get gender => throw _privateConstructorUsedError;

  /// Serializes this User to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of User
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UserCopyWith<User> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserCopyWith<$Res> {
  factory $UserCopyWith(User value, $Res Function(User) then) =
      _$UserCopyWithImpl<$Res, User>;
  @useResult
  $Res call({
    String? userId,
    String email,
    String nickname,
    String? profileImageUrl,
    String? loginPlatform,
    DateTime createdAt,
    String? onboardingStatus,
    bool? isServiceTermsAndPrivacyAgreed,
    bool? isMarketingAgreed,
    String? birthDate,
    String? gender,
  });
}

/// @nodoc
class _$UserCopyWithImpl<$Res, $Val extends User>
    implements $UserCopyWith<$Res> {
  _$UserCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of User
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = freezed,
    Object? email = null,
    Object? nickname = null,
    Object? profileImageUrl = freezed,
    Object? loginPlatform = freezed,
    Object? createdAt = null,
    Object? onboardingStatus = freezed,
    Object? isServiceTermsAndPrivacyAgreed = freezed,
    Object? isMarketingAgreed = freezed,
    Object? birthDate = freezed,
    Object? gender = freezed,
  }) {
    return _then(
      _value.copyWith(
            userId: freezed == userId
                ? _value.userId
                : userId // ignore: cast_nullable_to_non_nullable
                      as String?,
            email: null == email
                ? _value.email
                : email // ignore: cast_nullable_to_non_nullable
                      as String,
            nickname: null == nickname
                ? _value.nickname
                : nickname // ignore: cast_nullable_to_non_nullable
                      as String,
            profileImageUrl: freezed == profileImageUrl
                ? _value.profileImageUrl
                : profileImageUrl // ignore: cast_nullable_to_non_nullable
                      as String?,
            loginPlatform: freezed == loginPlatform
                ? _value.loginPlatform
                : loginPlatform // ignore: cast_nullable_to_non_nullable
                      as String?,
            createdAt: null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            onboardingStatus: freezed == onboardingStatus
                ? _value.onboardingStatus
                : onboardingStatus // ignore: cast_nullable_to_non_nullable
                      as String?,
            isServiceTermsAndPrivacyAgreed:
                freezed == isServiceTermsAndPrivacyAgreed
                ? _value.isServiceTermsAndPrivacyAgreed
                : isServiceTermsAndPrivacyAgreed // ignore: cast_nullable_to_non_nullable
                      as bool?,
            isMarketingAgreed: freezed == isMarketingAgreed
                ? _value.isMarketingAgreed
                : isMarketingAgreed // ignore: cast_nullable_to_non_nullable
                      as bool?,
            birthDate: freezed == birthDate
                ? _value.birthDate
                : birthDate // ignore: cast_nullable_to_non_nullable
                      as String?,
            gender: freezed == gender
                ? _value.gender
                : gender // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$UserImplCopyWith<$Res> implements $UserCopyWith<$Res> {
  factory _$$UserImplCopyWith(
    _$UserImpl value,
    $Res Function(_$UserImpl) then,
  ) = __$$UserImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String? userId,
    String email,
    String nickname,
    String? profileImageUrl,
    String? loginPlatform,
    DateTime createdAt,
    String? onboardingStatus,
    bool? isServiceTermsAndPrivacyAgreed,
    bool? isMarketingAgreed,
    String? birthDate,
    String? gender,
  });
}

/// @nodoc
class __$$UserImplCopyWithImpl<$Res>
    extends _$UserCopyWithImpl<$Res, _$UserImpl>
    implements _$$UserImplCopyWith<$Res> {
  __$$UserImplCopyWithImpl(_$UserImpl _value, $Res Function(_$UserImpl) _then)
    : super(_value, _then);

  /// Create a copy of User
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = freezed,
    Object? email = null,
    Object? nickname = null,
    Object? profileImageUrl = freezed,
    Object? loginPlatform = freezed,
    Object? createdAt = null,
    Object? onboardingStatus = freezed,
    Object? isServiceTermsAndPrivacyAgreed = freezed,
    Object? isMarketingAgreed = freezed,
    Object? birthDate = freezed,
    Object? gender = freezed,
  }) {
    return _then(
      _$UserImpl(
        userId: freezed == userId
            ? _value.userId
            : userId // ignore: cast_nullable_to_non_nullable
                  as String?,
        email: null == email
            ? _value.email
            : email // ignore: cast_nullable_to_non_nullable
                  as String,
        nickname: null == nickname
            ? _value.nickname
            : nickname // ignore: cast_nullable_to_non_nullable
                  as String,
        profileImageUrl: freezed == profileImageUrl
            ? _value.profileImageUrl
            : profileImageUrl // ignore: cast_nullable_to_non_nullable
                  as String?,
        loginPlatform: freezed == loginPlatform
            ? _value.loginPlatform
            : loginPlatform // ignore: cast_nullable_to_non_nullable
                  as String?,
        createdAt: null == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        onboardingStatus: freezed == onboardingStatus
            ? _value.onboardingStatus
            : onboardingStatus // ignore: cast_nullable_to_non_nullable
                  as String?,
        isServiceTermsAndPrivacyAgreed:
            freezed == isServiceTermsAndPrivacyAgreed
            ? _value.isServiceTermsAndPrivacyAgreed
            : isServiceTermsAndPrivacyAgreed // ignore: cast_nullable_to_non_nullable
                  as bool?,
        isMarketingAgreed: freezed == isMarketingAgreed
            ? _value.isMarketingAgreed
            : isMarketingAgreed // ignore: cast_nullable_to_non_nullable
                  as bool?,
        birthDate: freezed == birthDate
            ? _value.birthDate
            : birthDate // ignore: cast_nullable_to_non_nullable
                  as String?,
        gender: freezed == gender
            ? _value.gender
            : gender // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$UserImpl implements _User {
  const _$UserImpl({
    this.userId,
    required this.email,
    required this.nickname,
    this.profileImageUrl,
    this.loginPlatform,
    required this.createdAt,
    this.onboardingStatus,
    this.isServiceTermsAndPrivacyAgreed,
    this.isMarketingAgreed,
    this.birthDate,
    this.gender,
  });

  factory _$UserImpl.fromJson(Map<String, dynamic> json) =>
      _$$UserImplFromJson(json);

  /// 사용자 고유 ID (서버에서 발급)
  ///
  /// - 백엔드 API 연동 전: null (로컬에서 Google ID 사용)
  /// - 백엔드 API 연동 후: 서버에서 발급한 UUID
  @override
  final String? userId;

  /// 이메일 주소 (필수)
  ///
  /// Google 로그인 시 자동으로 받아옵니다.
  @override
  final String email;

  /// 닉네임 (필수)
  ///
  /// 서버의 name 필드에서 가져오거나, Google displayName 사용
  @override
  final String nickname;

  /// 프로필 이미지 URL (선택)
  ///
  /// Google 로그인 시 photoUrl로 받아오거나, 사용자가 직접 업로드한 이미지 URL
  /// 형식: https://lh3.googleusercontent.com/a/...
  @override
  final String? profileImageUrl;

  /// 로그인 플랫폼 (선택)
  ///
  /// 가능한 값: "GOOGLE", "KAKAO"
  /// 추후 Kakao 로그인 추가 시 사용
  @override
  final String? loginPlatform;

  /// 생성일시 (로컬 저장 시간)
  ///
  /// 사용자 정보가 처음 저장된 시간
  @override
  final DateTime createdAt;
  // ════════════════════════════════════════════════════════════════════════
  // 서버 API 응답 필드 (/api/members/email/{email})
  // ════════════════════════════════════════════════════════════════════════
  /// 온보딩 상태 (서버에서 관리)
  ///
  /// 가능한 값: "NOT_STARTED", "IN_PROGRESS", "COMPLETED"
  @override
  final String? onboardingStatus;

  /// 서비스 이용약관 및 개인정보 처리방침 동의 여부
  @override
  final bool? isServiceTermsAndPrivacyAgreed;

  /// 마케팅 수신 동의 여부
  @override
  final bool? isMarketingAgreed;

  /// 생년월일 (yyyy-MM-dd 형식)
  ///
  /// 예: "1990-01-01"
  @override
  final String? birthDate;

  /// 성별
  ///
  /// 가능한 값: "MALE", "FEMALE"
  @override
  final String? gender;

  @override
  String toString() {
    return 'User(userId: $userId, email: $email, nickname: $nickname, profileImageUrl: $profileImageUrl, loginPlatform: $loginPlatform, createdAt: $createdAt, onboardingStatus: $onboardingStatus, isServiceTermsAndPrivacyAgreed: $isServiceTermsAndPrivacyAgreed, isMarketingAgreed: $isMarketingAgreed, birthDate: $birthDate, gender: $gender)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserImpl &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.nickname, nickname) ||
                other.nickname == nickname) &&
            (identical(other.profileImageUrl, profileImageUrl) ||
                other.profileImageUrl == profileImageUrl) &&
            (identical(other.loginPlatform, loginPlatform) ||
                other.loginPlatform == loginPlatform) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.onboardingStatus, onboardingStatus) ||
                other.onboardingStatus == onboardingStatus) &&
            (identical(
                  other.isServiceTermsAndPrivacyAgreed,
                  isServiceTermsAndPrivacyAgreed,
                ) ||
                other.isServiceTermsAndPrivacyAgreed ==
                    isServiceTermsAndPrivacyAgreed) &&
            (identical(other.isMarketingAgreed, isMarketingAgreed) ||
                other.isMarketingAgreed == isMarketingAgreed) &&
            (identical(other.birthDate, birthDate) ||
                other.birthDate == birthDate) &&
            (identical(other.gender, gender) || other.gender == gender));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    userId,
    email,
    nickname,
    profileImageUrl,
    loginPlatform,
    createdAt,
    onboardingStatus,
    isServiceTermsAndPrivacyAgreed,
    isMarketingAgreed,
    birthDate,
    gender,
  );

  /// Create a copy of User
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UserImplCopyWith<_$UserImpl> get copyWith =>
      __$$UserImplCopyWithImpl<_$UserImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UserImplToJson(this);
  }
}

abstract class _User implements User {
  const factory _User({
    final String? userId,
    required final String email,
    required final String nickname,
    final String? profileImageUrl,
    final String? loginPlatform,
    required final DateTime createdAt,
    final String? onboardingStatus,
    final bool? isServiceTermsAndPrivacyAgreed,
    final bool? isMarketingAgreed,
    final String? birthDate,
    final String? gender,
  }) = _$UserImpl;

  factory _User.fromJson(Map<String, dynamic> json) = _$UserImpl.fromJson;

  /// 사용자 고유 ID (서버에서 발급)
  ///
  /// - 백엔드 API 연동 전: null (로컬에서 Google ID 사용)
  /// - 백엔드 API 연동 후: 서버에서 발급한 UUID
  @override
  String? get userId;

  /// 이메일 주소 (필수)
  ///
  /// Google 로그인 시 자동으로 받아옵니다.
  @override
  String get email;

  /// 닉네임 (필수)
  ///
  /// 서버의 name 필드에서 가져오거나, Google displayName 사용
  @override
  String get nickname;

  /// 프로필 이미지 URL (선택)
  ///
  /// Google 로그인 시 photoUrl로 받아오거나, 사용자가 직접 업로드한 이미지 URL
  /// 형식: https://lh3.googleusercontent.com/a/...
  @override
  String? get profileImageUrl;

  /// 로그인 플랫폼 (선택)
  ///
  /// 가능한 값: "GOOGLE", "KAKAO"
  /// 추후 Kakao 로그인 추가 시 사용
  @override
  String? get loginPlatform;

  /// 생성일시 (로컬 저장 시간)
  ///
  /// 사용자 정보가 처음 저장된 시간
  @override
  DateTime get createdAt; // ════════════════════════════════════════════════════════════════════════
  // 서버 API 응답 필드 (/api/members/email/{email})
  // ════════════════════════════════════════════════════════════════════════
  /// 온보딩 상태 (서버에서 관리)
  ///
  /// 가능한 값: "NOT_STARTED", "IN_PROGRESS", "COMPLETED"
  @override
  String? get onboardingStatus;

  /// 서비스 이용약관 및 개인정보 처리방침 동의 여부
  @override
  bool? get isServiceTermsAndPrivacyAgreed;

  /// 마케팅 수신 동의 여부
  @override
  bool? get isMarketingAgreed;

  /// 생년월일 (yyyy-MM-dd 형식)
  ///
  /// 예: "1990-01-01"
  @override
  String? get birthDate;

  /// 성별
  ///
  /// 가능한 값: "MALE", "FEMALE"
  @override
  String? get gender;

  /// Create a copy of User
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UserImplCopyWith<_$UserImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
