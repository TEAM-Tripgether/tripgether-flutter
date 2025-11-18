// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'onboarding_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

OnboardingResponse _$OnboardingResponseFromJson(Map<String, dynamic> json) {
  return _OnboardingResponse.fromJson(json);
}

/// @nodoc
mixin _$OnboardingResponse {
  /// 다음 단계 (Next Step to Perform)
  ///
  /// **가능한 값**:
  /// - "TERMS": 약관 동의 필요
  /// - "NAME": 이름 입력 필요
  /// - "BIRTH_DATE": 생년월일 입력 필요
  /// - "GENDER": 성별 선택 필요
  /// - "INTERESTS": 관심사 선택 필요
  /// - "COMPLETED": 온보딩 완료
  ///
  /// **주의**: 이것은 "현재 단계"가 아니라 "다음에 할 단계"입니다!
  String get currentStep => throw _privateConstructorUsedError;

  /// 전체 온보딩 진행 상태
  ///
  /// **가능한 값**:
  /// - "NOT_STARTED": 아직 시작 안 함
  /// - "IN_PROGRESS": 진행 중
  /// - "COMPLETED": 완료됨
  String get onboardingStatus => throw _privateConstructorUsedError;

  /// 업데이트된 회원 정보
  ///
  /// API 호출 후 업데이트된 최신 회원 정보가 포함됩니다.
  MemberDto get member => throw _privateConstructorUsedError;

  /// Serializes this OnboardingResponse to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of OnboardingResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $OnboardingResponseCopyWith<OnboardingResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OnboardingResponseCopyWith<$Res> {
  factory $OnboardingResponseCopyWith(
    OnboardingResponse value,
    $Res Function(OnboardingResponse) then,
  ) = _$OnboardingResponseCopyWithImpl<$Res, OnboardingResponse>;
  @useResult
  $Res call({String currentStep, String onboardingStatus, MemberDto member});

  $MemberDtoCopyWith<$Res> get member;
}

/// @nodoc
class _$OnboardingResponseCopyWithImpl<$Res, $Val extends OnboardingResponse>
    implements $OnboardingResponseCopyWith<$Res> {
  _$OnboardingResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of OnboardingResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? currentStep = null,
    Object? onboardingStatus = null,
    Object? member = null,
  }) {
    return _then(
      _value.copyWith(
            currentStep: null == currentStep
                ? _value.currentStep
                : currentStep // ignore: cast_nullable_to_non_nullable
                      as String,
            onboardingStatus: null == onboardingStatus
                ? _value.onboardingStatus
                : onboardingStatus // ignore: cast_nullable_to_non_nullable
                      as String,
            member: null == member
                ? _value.member
                : member // ignore: cast_nullable_to_non_nullable
                      as MemberDto,
          )
          as $Val,
    );
  }

  /// Create a copy of OnboardingResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $MemberDtoCopyWith<$Res> get member {
    return $MemberDtoCopyWith<$Res>(_value.member, (value) {
      return _then(_value.copyWith(member: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$OnboardingResponseImplCopyWith<$Res>
    implements $OnboardingResponseCopyWith<$Res> {
  factory _$$OnboardingResponseImplCopyWith(
    _$OnboardingResponseImpl value,
    $Res Function(_$OnboardingResponseImpl) then,
  ) = __$$OnboardingResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String currentStep, String onboardingStatus, MemberDto member});

  @override
  $MemberDtoCopyWith<$Res> get member;
}

/// @nodoc
class __$$OnboardingResponseImplCopyWithImpl<$Res>
    extends _$OnboardingResponseCopyWithImpl<$Res, _$OnboardingResponseImpl>
    implements _$$OnboardingResponseImplCopyWith<$Res> {
  __$$OnboardingResponseImplCopyWithImpl(
    _$OnboardingResponseImpl _value,
    $Res Function(_$OnboardingResponseImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of OnboardingResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? currentStep = null,
    Object? onboardingStatus = null,
    Object? member = null,
  }) {
    return _then(
      _$OnboardingResponseImpl(
        currentStep: null == currentStep
            ? _value.currentStep
            : currentStep // ignore: cast_nullable_to_non_nullable
                  as String,
        onboardingStatus: null == onboardingStatus
            ? _value.onboardingStatus
            : onboardingStatus // ignore: cast_nullable_to_non_nullable
                  as String,
        member: null == member
            ? _value.member
            : member // ignore: cast_nullable_to_non_nullable
                  as MemberDto,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$OnboardingResponseImpl implements _OnboardingResponse {
  const _$OnboardingResponseImpl({
    required this.currentStep,
    required this.onboardingStatus,
    required this.member,
  });

  factory _$OnboardingResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$OnboardingResponseImplFromJson(json);

  /// 다음 단계 (Next Step to Perform)
  ///
  /// **가능한 값**:
  /// - "TERMS": 약관 동의 필요
  /// - "NAME": 이름 입력 필요
  /// - "BIRTH_DATE": 생년월일 입력 필요
  /// - "GENDER": 성별 선택 필요
  /// - "INTERESTS": 관심사 선택 필요
  /// - "COMPLETED": 온보딩 완료
  ///
  /// **주의**: 이것은 "현재 단계"가 아니라 "다음에 할 단계"입니다!
  @override
  final String currentStep;

  /// 전체 온보딩 진행 상태
  ///
  /// **가능한 값**:
  /// - "NOT_STARTED": 아직 시작 안 함
  /// - "IN_PROGRESS": 진행 중
  /// - "COMPLETED": 완료됨
  @override
  final String onboardingStatus;

  /// 업데이트된 회원 정보
  ///
  /// API 호출 후 업데이트된 최신 회원 정보가 포함됩니다.
  @override
  final MemberDto member;

  @override
  String toString() {
    return 'OnboardingResponse(currentStep: $currentStep, onboardingStatus: $onboardingStatus, member: $member)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OnboardingResponseImpl &&
            (identical(other.currentStep, currentStep) ||
                other.currentStep == currentStep) &&
            (identical(other.onboardingStatus, onboardingStatus) ||
                other.onboardingStatus == onboardingStatus) &&
            (identical(other.member, member) || other.member == member));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, currentStep, onboardingStatus, member);

  /// Create a copy of OnboardingResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$OnboardingResponseImplCopyWith<_$OnboardingResponseImpl> get copyWith =>
      __$$OnboardingResponseImplCopyWithImpl<_$OnboardingResponseImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$OnboardingResponseImplToJson(this);
  }
}

abstract class _OnboardingResponse implements OnboardingResponse {
  const factory _OnboardingResponse({
    required final String currentStep,
    required final String onboardingStatus,
    required final MemberDto member,
  }) = _$OnboardingResponseImpl;

  factory _OnboardingResponse.fromJson(Map<String, dynamic> json) =
      _$OnboardingResponseImpl.fromJson;

  /// 다음 단계 (Next Step to Perform)
  ///
  /// **가능한 값**:
  /// - "TERMS": 약관 동의 필요
  /// - "NAME": 이름 입력 필요
  /// - "BIRTH_DATE": 생년월일 입력 필요
  /// - "GENDER": 성별 선택 필요
  /// - "INTERESTS": 관심사 선택 필요
  /// - "COMPLETED": 온보딩 완료
  ///
  /// **주의**: 이것은 "현재 단계"가 아니라 "다음에 할 단계"입니다!
  @override
  String get currentStep;

  /// 전체 온보딩 진행 상태
  ///
  /// **가능한 값**:
  /// - "NOT_STARTED": 아직 시작 안 함
  /// - "IN_PROGRESS": 진행 중
  /// - "COMPLETED": 완료됨
  @override
  String get onboardingStatus;

  /// 업데이트된 회원 정보
  ///
  /// API 호출 후 업데이트된 최신 회원 정보가 포함됩니다.
  @override
  MemberDto get member;

  /// Create a copy of OnboardingResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$OnboardingResponseImplCopyWith<_$OnboardingResponseImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

MemberDto _$MemberDtoFromJson(Map<String, dynamic> json) {
  return _MemberDto.fromJson(json);
}

/// @nodoc
mixin _$MemberDto {
  /// 회원 고유 ID (UUID)
  String get id => throw _privateConstructorUsedError;

  /// 이메일 주소
  String get email => throw _privateConstructorUsedError;

  /// 이름/닉네임
  String get name => throw _privateConstructorUsedError;

  /// 온보딩 상태
  ///
  /// **가능한 값**:
  /// - "NOT_STARTED"
  /// - "IN_PROGRESS"
  /// - "COMPLETED"
  String get onboardingStatus => throw _privateConstructorUsedError;

  /// 필수 약관 동의 여부 (서비스 이용약관 + 개인정보 처리방침)
  bool get isServiceTermsAndPrivacyAgreed => throw _privateConstructorUsedError;

  /// 마케팅 동의 여부 (선택 사항)
  bool get isMarketingAgreed => throw _privateConstructorUsedError;

  /// 생년월일 (nullable)
  ///
  /// **형식**: YYYY-MM-DD (예: 1990-01-01)
  String? get birthDate => throw _privateConstructorUsedError;

  /// 성별 (nullable)
  ///
  /// **가능한 값**:
  /// - "MALE": 남성
  /// - "FEMALE": 여성
  /// - null: 선택 안 함
  String? get gender => throw _privateConstructorUsedError;

  /// Serializes this MemberDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of MemberDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MemberDtoCopyWith<MemberDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MemberDtoCopyWith<$Res> {
  factory $MemberDtoCopyWith(MemberDto value, $Res Function(MemberDto) then) =
      _$MemberDtoCopyWithImpl<$Res, MemberDto>;
  @useResult
  $Res call({
    String id,
    String email,
    String name,
    String onboardingStatus,
    bool isServiceTermsAndPrivacyAgreed,
    bool isMarketingAgreed,
    String? birthDate,
    String? gender,
  });
}

/// @nodoc
class _$MemberDtoCopyWithImpl<$Res, $Val extends MemberDto>
    implements $MemberDtoCopyWith<$Res> {
  _$MemberDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MemberDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? email = null,
    Object? name = null,
    Object? onboardingStatus = null,
    Object? isServiceTermsAndPrivacyAgreed = null,
    Object? isMarketingAgreed = null,
    Object? birthDate = freezed,
    Object? gender = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            email: null == email
                ? _value.email
                : email // ignore: cast_nullable_to_non_nullable
                      as String,
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            onboardingStatus: null == onboardingStatus
                ? _value.onboardingStatus
                : onboardingStatus // ignore: cast_nullable_to_non_nullable
                      as String,
            isServiceTermsAndPrivacyAgreed:
                null == isServiceTermsAndPrivacyAgreed
                ? _value.isServiceTermsAndPrivacyAgreed
                : isServiceTermsAndPrivacyAgreed // ignore: cast_nullable_to_non_nullable
                      as bool,
            isMarketingAgreed: null == isMarketingAgreed
                ? _value.isMarketingAgreed
                : isMarketingAgreed // ignore: cast_nullable_to_non_nullable
                      as bool,
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
abstract class _$$MemberDtoImplCopyWith<$Res>
    implements $MemberDtoCopyWith<$Res> {
  factory _$$MemberDtoImplCopyWith(
    _$MemberDtoImpl value,
    $Res Function(_$MemberDtoImpl) then,
  ) = __$$MemberDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String email,
    String name,
    String onboardingStatus,
    bool isServiceTermsAndPrivacyAgreed,
    bool isMarketingAgreed,
    String? birthDate,
    String? gender,
  });
}

/// @nodoc
class __$$MemberDtoImplCopyWithImpl<$Res>
    extends _$MemberDtoCopyWithImpl<$Res, _$MemberDtoImpl>
    implements _$$MemberDtoImplCopyWith<$Res> {
  __$$MemberDtoImplCopyWithImpl(
    _$MemberDtoImpl _value,
    $Res Function(_$MemberDtoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of MemberDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? email = null,
    Object? name = null,
    Object? onboardingStatus = null,
    Object? isServiceTermsAndPrivacyAgreed = null,
    Object? isMarketingAgreed = null,
    Object? birthDate = freezed,
    Object? gender = freezed,
  }) {
    return _then(
      _$MemberDtoImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        email: null == email
            ? _value.email
            : email // ignore: cast_nullable_to_non_nullable
                  as String,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        onboardingStatus: null == onboardingStatus
            ? _value.onboardingStatus
            : onboardingStatus // ignore: cast_nullable_to_non_nullable
                  as String,
        isServiceTermsAndPrivacyAgreed: null == isServiceTermsAndPrivacyAgreed
            ? _value.isServiceTermsAndPrivacyAgreed
            : isServiceTermsAndPrivacyAgreed // ignore: cast_nullable_to_non_nullable
                  as bool,
        isMarketingAgreed: null == isMarketingAgreed
            ? _value.isMarketingAgreed
            : isMarketingAgreed // ignore: cast_nullable_to_non_nullable
                  as bool,
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
class _$MemberDtoImpl implements _MemberDto {
  const _$MemberDtoImpl({
    required this.id,
    required this.email,
    required this.name,
    required this.onboardingStatus,
    required this.isServiceTermsAndPrivacyAgreed,
    required this.isMarketingAgreed,
    this.birthDate,
    this.gender,
  });

  factory _$MemberDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$MemberDtoImplFromJson(json);

  /// 회원 고유 ID (UUID)
  @override
  final String id;

  /// 이메일 주소
  @override
  final String email;

  /// 이름/닉네임
  @override
  final String name;

  /// 온보딩 상태
  ///
  /// **가능한 값**:
  /// - "NOT_STARTED"
  /// - "IN_PROGRESS"
  /// - "COMPLETED"
  @override
  final String onboardingStatus;

  /// 필수 약관 동의 여부 (서비스 이용약관 + 개인정보 처리방침)
  @override
  final bool isServiceTermsAndPrivacyAgreed;

  /// 마케팅 동의 여부 (선택 사항)
  @override
  final bool isMarketingAgreed;

  /// 생년월일 (nullable)
  ///
  /// **형식**: YYYY-MM-DD (예: 1990-01-01)
  @override
  final String? birthDate;

  /// 성별 (nullable)
  ///
  /// **가능한 값**:
  /// - "MALE": 남성
  /// - "FEMALE": 여성
  /// - null: 선택 안 함
  @override
  final String? gender;

  @override
  String toString() {
    return 'MemberDto(id: $id, email: $email, name: $name, onboardingStatus: $onboardingStatus, isServiceTermsAndPrivacyAgreed: $isServiceTermsAndPrivacyAgreed, isMarketingAgreed: $isMarketingAgreed, birthDate: $birthDate, gender: $gender)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MemberDtoImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.name, name) || other.name == name) &&
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
    id,
    email,
    name,
    onboardingStatus,
    isServiceTermsAndPrivacyAgreed,
    isMarketingAgreed,
    birthDate,
    gender,
  );

  /// Create a copy of MemberDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MemberDtoImplCopyWith<_$MemberDtoImpl> get copyWith =>
      __$$MemberDtoImplCopyWithImpl<_$MemberDtoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MemberDtoImplToJson(this);
  }
}

abstract class _MemberDto implements MemberDto {
  const factory _MemberDto({
    required final String id,
    required final String email,
    required final String name,
    required final String onboardingStatus,
    required final bool isServiceTermsAndPrivacyAgreed,
    required final bool isMarketingAgreed,
    final String? birthDate,
    final String? gender,
  }) = _$MemberDtoImpl;

  factory _MemberDto.fromJson(Map<String, dynamic> json) =
      _$MemberDtoImpl.fromJson;

  /// 회원 고유 ID (UUID)
  @override
  String get id;

  /// 이메일 주소
  @override
  String get email;

  /// 이름/닉네임
  @override
  String get name;

  /// 온보딩 상태
  ///
  /// **가능한 값**:
  /// - "NOT_STARTED"
  /// - "IN_PROGRESS"
  /// - "COMPLETED"
  @override
  String get onboardingStatus;

  /// 필수 약관 동의 여부 (서비스 이용약관 + 개인정보 처리방침)
  @override
  bool get isServiceTermsAndPrivacyAgreed;

  /// 마케팅 동의 여부 (선택 사항)
  @override
  bool get isMarketingAgreed;

  /// 생년월일 (nullable)
  ///
  /// **형식**: YYYY-MM-DD (예: 1990-01-01)
  @override
  String? get birthDate;

  /// 성별 (nullable)
  ///
  /// **가능한 값**:
  /// - "MALE": 남성
  /// - "FEMALE": 여성
  /// - null: 선택 안 함
  @override
  String? get gender;

  /// Create a copy of MemberDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MemberDtoImplCopyWith<_$MemberDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
