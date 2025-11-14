// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'onboarding_data.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

OnboardingData _$OnboardingDataFromJson(Map<String, dynamic> json) {
  return _OnboardingData.fromJson(json);
}

/// @nodoc
mixin _$OnboardingData {
  /// 서비스 이용약관 동의 (필수)
  bool get termsOfService => throw _privateConstructorUsedError;

  /// 개인정보 처리방침 동의 (필수)
  bool get privacyPolicy => throw _privateConstructorUsedError;

  /// 만 14세 이상 확인 (필수)
  bool get ageConfirmation => throw _privateConstructorUsedError;

  /// 마케팅 정보 수신 동의 (선택)
  bool get marketingConsent => throw _privateConstructorUsedError;

  /// 닉네임 (필수, 2-10자)
  ///
  /// **검증 규칙**:
  /// - 최소 2자, 최대 10자
  /// - 비속어/광고 문구 제한 (서버에서 검증)
  String get nickname => throw _privateConstructorUsedError;

  /// 성별 (선택)
  ///
  /// **선택지**:
  /// - 'MALE': 남성
  /// - 'FEMALE': 여성
  /// - 'NONE': 선택 안 함 (기본값)
  String get gender => throw _privateConstructorUsedError;

  /// 생년월일 (선택)
  ///
  /// **형식**: YYYY-MM-DD (예: 1990-01-01)
  /// **용도**: 연령별 콘텐츠 설정 및 추천
  /// **주의**: 다른 유저에게 노출되지 않음
  String? get birthdate => throw _privateConstructorUsedError;

  /// 관심사 목록 (선택, 3-10개 권장)
  ///
  /// **선택 가능한 카테고리**:
  /// - 액티비티: 수영, 등산, 서핑 등
  /// - 음식: 맛집 탐방, 디저트, 비건 등
  /// - 문화: 미술관, 음악, 역사 등
  /// - 기타: 쇼핑, 사진, 힐링 등
  ///
  /// **검증 규칙**:
  /// - 최소 3개 권장 (정확도 향상)
  /// - 최대 10개
  List<String> get interests => throw _privateConstructorUsedError;

  /// Serializes this OnboardingData to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of OnboardingData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $OnboardingDataCopyWith<OnboardingData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OnboardingDataCopyWith<$Res> {
  factory $OnboardingDataCopyWith(
    OnboardingData value,
    $Res Function(OnboardingData) then,
  ) = _$OnboardingDataCopyWithImpl<$Res, OnboardingData>;
  @useResult
  $Res call({
    bool termsOfService,
    bool privacyPolicy,
    bool ageConfirmation,
    bool marketingConsent,
    String nickname,
    String gender,
    String? birthdate,
    List<String> interests,
  });
}

/// @nodoc
class _$OnboardingDataCopyWithImpl<$Res, $Val extends OnboardingData>
    implements $OnboardingDataCopyWith<$Res> {
  _$OnboardingDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of OnboardingData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? termsOfService = null,
    Object? privacyPolicy = null,
    Object? ageConfirmation = null,
    Object? marketingConsent = null,
    Object? nickname = null,
    Object? gender = null,
    Object? birthdate = freezed,
    Object? interests = null,
  }) {
    return _then(
      _value.copyWith(
            termsOfService: null == termsOfService
                ? _value.termsOfService
                : termsOfService // ignore: cast_nullable_to_non_nullable
                      as bool,
            privacyPolicy: null == privacyPolicy
                ? _value.privacyPolicy
                : privacyPolicy // ignore: cast_nullable_to_non_nullable
                      as bool,
            ageConfirmation: null == ageConfirmation
                ? _value.ageConfirmation
                : ageConfirmation // ignore: cast_nullable_to_non_nullable
                      as bool,
            marketingConsent: null == marketingConsent
                ? _value.marketingConsent
                : marketingConsent // ignore: cast_nullable_to_non_nullable
                      as bool,
            nickname: null == nickname
                ? _value.nickname
                : nickname // ignore: cast_nullable_to_non_nullable
                      as String,
            gender: null == gender
                ? _value.gender
                : gender // ignore: cast_nullable_to_non_nullable
                      as String,
            birthdate: freezed == birthdate
                ? _value.birthdate
                : birthdate // ignore: cast_nullable_to_non_nullable
                      as String?,
            interests: null == interests
                ? _value.interests
                : interests // ignore: cast_nullable_to_non_nullable
                      as List<String>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$OnboardingDataImplCopyWith<$Res>
    implements $OnboardingDataCopyWith<$Res> {
  factory _$$OnboardingDataImplCopyWith(
    _$OnboardingDataImpl value,
    $Res Function(_$OnboardingDataImpl) then,
  ) = __$$OnboardingDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    bool termsOfService,
    bool privacyPolicy,
    bool ageConfirmation,
    bool marketingConsent,
    String nickname,
    String gender,
    String? birthdate,
    List<String> interests,
  });
}

/// @nodoc
class __$$OnboardingDataImplCopyWithImpl<$Res>
    extends _$OnboardingDataCopyWithImpl<$Res, _$OnboardingDataImpl>
    implements _$$OnboardingDataImplCopyWith<$Res> {
  __$$OnboardingDataImplCopyWithImpl(
    _$OnboardingDataImpl _value,
    $Res Function(_$OnboardingDataImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of OnboardingData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? termsOfService = null,
    Object? privacyPolicy = null,
    Object? ageConfirmation = null,
    Object? marketingConsent = null,
    Object? nickname = null,
    Object? gender = null,
    Object? birthdate = freezed,
    Object? interests = null,
  }) {
    return _then(
      _$OnboardingDataImpl(
        termsOfService: null == termsOfService
            ? _value.termsOfService
            : termsOfService // ignore: cast_nullable_to_non_nullable
                  as bool,
        privacyPolicy: null == privacyPolicy
            ? _value.privacyPolicy
            : privacyPolicy // ignore: cast_nullable_to_non_nullable
                  as bool,
        ageConfirmation: null == ageConfirmation
            ? _value.ageConfirmation
            : ageConfirmation // ignore: cast_nullable_to_non_nullable
                  as bool,
        marketingConsent: null == marketingConsent
            ? _value.marketingConsent
            : marketingConsent // ignore: cast_nullable_to_non_nullable
                  as bool,
        nickname: null == nickname
            ? _value.nickname
            : nickname // ignore: cast_nullable_to_non_nullable
                  as String,
        gender: null == gender
            ? _value.gender
            : gender // ignore: cast_nullable_to_non_nullable
                  as String,
        birthdate: freezed == birthdate
            ? _value.birthdate
            : birthdate // ignore: cast_nullable_to_non_nullable
                  as String?,
        interests: null == interests
            ? _value._interests
            : interests // ignore: cast_nullable_to_non_nullable
                  as List<String>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$OnboardingDataImpl extends _OnboardingData {
  const _$OnboardingDataImpl({
    this.termsOfService = false,
    this.privacyPolicy = false,
    this.ageConfirmation = false,
    this.marketingConsent = false,
    this.nickname = '',
    this.gender = 'NONE',
    this.birthdate,
    final List<String> interests = const [],
  }) : _interests = interests,
       super._();

  factory _$OnboardingDataImpl.fromJson(Map<String, dynamic> json) =>
      _$$OnboardingDataImplFromJson(json);

  /// 서비스 이용약관 동의 (필수)
  @override
  @JsonKey()
  final bool termsOfService;

  /// 개인정보 처리방침 동의 (필수)
  @override
  @JsonKey()
  final bool privacyPolicy;

  /// 만 14세 이상 확인 (필수)
  @override
  @JsonKey()
  final bool ageConfirmation;

  /// 마케팅 정보 수신 동의 (선택)
  @override
  @JsonKey()
  final bool marketingConsent;

  /// 닉네임 (필수, 2-10자)
  ///
  /// **검증 규칙**:
  /// - 최소 2자, 최대 10자
  /// - 비속어/광고 문구 제한 (서버에서 검증)
  @override
  @JsonKey()
  final String nickname;

  /// 성별 (선택)
  ///
  /// **선택지**:
  /// - 'MALE': 남성
  /// - 'FEMALE': 여성
  /// - 'NONE': 선택 안 함 (기본값)
  @override
  @JsonKey()
  final String gender;

  /// 생년월일 (선택)
  ///
  /// **형식**: YYYY-MM-DD (예: 1990-01-01)
  /// **용도**: 연령별 콘텐츠 설정 및 추천
  /// **주의**: 다른 유저에게 노출되지 않음
  @override
  final String? birthdate;

  /// 관심사 목록 (선택, 3-10개 권장)
  ///
  /// **선택 가능한 카테고리**:
  /// - 액티비티: 수영, 등산, 서핑 등
  /// - 음식: 맛집 탐방, 디저트, 비건 등
  /// - 문화: 미술관, 음악, 역사 등
  /// - 기타: 쇼핑, 사진, 힐링 등
  ///
  /// **검증 규칙**:
  /// - 최소 3개 권장 (정확도 향상)
  /// - 최대 10개
  final List<String> _interests;

  /// 관심사 목록 (선택, 3-10개 권장)
  ///
  /// **선택 가능한 카테고리**:
  /// - 액티비티: 수영, 등산, 서핑 등
  /// - 음식: 맛집 탐방, 디저트, 비건 등
  /// - 문화: 미술관, 음악, 역사 등
  /// - 기타: 쇼핑, 사진, 힐링 등
  ///
  /// **검증 규칙**:
  /// - 최소 3개 권장 (정확도 향상)
  /// - 최대 10개
  @override
  @JsonKey()
  List<String> get interests {
    if (_interests is EqualUnmodifiableListView) return _interests;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_interests);
  }

  @override
  String toString() {
    return 'OnboardingData(termsOfService: $termsOfService, privacyPolicy: $privacyPolicy, ageConfirmation: $ageConfirmation, marketingConsent: $marketingConsent, nickname: $nickname, gender: $gender, birthdate: $birthdate, interests: $interests)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OnboardingDataImpl &&
            (identical(other.termsOfService, termsOfService) ||
                other.termsOfService == termsOfService) &&
            (identical(other.privacyPolicy, privacyPolicy) ||
                other.privacyPolicy == privacyPolicy) &&
            (identical(other.ageConfirmation, ageConfirmation) ||
                other.ageConfirmation == ageConfirmation) &&
            (identical(other.marketingConsent, marketingConsent) ||
                other.marketingConsent == marketingConsent) &&
            (identical(other.nickname, nickname) ||
                other.nickname == nickname) &&
            (identical(other.gender, gender) || other.gender == gender) &&
            (identical(other.birthdate, birthdate) ||
                other.birthdate == birthdate) &&
            const DeepCollectionEquality().equals(
              other._interests,
              _interests,
            ));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    termsOfService,
    privacyPolicy,
    ageConfirmation,
    marketingConsent,
    nickname,
    gender,
    birthdate,
    const DeepCollectionEquality().hash(_interests),
  );

  /// Create a copy of OnboardingData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$OnboardingDataImplCopyWith<_$OnboardingDataImpl> get copyWith =>
      __$$OnboardingDataImplCopyWithImpl<_$OnboardingDataImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$OnboardingDataImplToJson(this);
  }
}

abstract class _OnboardingData extends OnboardingData {
  const factory _OnboardingData({
    final bool termsOfService,
    final bool privacyPolicy,
    final bool ageConfirmation,
    final bool marketingConsent,
    final String nickname,
    final String gender,
    final String? birthdate,
    final List<String> interests,
  }) = _$OnboardingDataImpl;
  const _OnboardingData._() : super._();

  factory _OnboardingData.fromJson(Map<String, dynamic> json) =
      _$OnboardingDataImpl.fromJson;

  /// 서비스 이용약관 동의 (필수)
  @override
  bool get termsOfService;

  /// 개인정보 처리방침 동의 (필수)
  @override
  bool get privacyPolicy;

  /// 만 14세 이상 확인 (필수)
  @override
  bool get ageConfirmation;

  /// 마케팅 정보 수신 동의 (선택)
  @override
  bool get marketingConsent;

  /// 닉네임 (필수, 2-10자)
  ///
  /// **검증 규칙**:
  /// - 최소 2자, 최대 10자
  /// - 비속어/광고 문구 제한 (서버에서 검증)
  @override
  String get nickname;

  /// 성별 (선택)
  ///
  /// **선택지**:
  /// - 'MALE': 남성
  /// - 'FEMALE': 여성
  /// - 'NONE': 선택 안 함 (기본값)
  @override
  String get gender;

  /// 생년월일 (선택)
  ///
  /// **형식**: YYYY-MM-DD (예: 1990-01-01)
  /// **용도**: 연령별 콘텐츠 설정 및 추천
  /// **주의**: 다른 유저에게 노출되지 않음
  @override
  String? get birthdate;

  /// 관심사 목록 (선택, 3-10개 권장)
  ///
  /// **선택 가능한 카테고리**:
  /// - 액티비티: 수영, 등산, 서핑 등
  /// - 음식: 맛집 탐방, 디저트, 비건 등
  /// - 문화: 미술관, 음악, 역사 등
  /// - 기타: 쇼핑, 사진, 힐링 등
  ///
  /// **검증 규칙**:
  /// - 최소 3개 권장 (정확도 향상)
  /// - 최대 10개
  @override
  List<String> get interests;

  /// Create a copy of OnboardingData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$OnboardingDataImplCopyWith<_$OnboardingDataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
