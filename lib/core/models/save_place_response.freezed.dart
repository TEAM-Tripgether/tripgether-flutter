// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'save_place_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

SavePlaceResponse _$SavePlaceResponseFromJson(Map<String, dynamic> json) {
  return _SavePlaceResponse.fromJson(json);
}

/// @nodoc
mixin _$SavePlaceResponse {
  /// 회원 장소 ID (회원-장소 연결 테이블의 고유 ID)
  String get memberPlaceId => throw _privateConstructorUsedError;

  /// 장소 ID
  String get placeId => throw _privateConstructorUsedError;

  /// 저장 상태 (SAVED, TEMPORARY 등)
  String get savedStatus => throw _privateConstructorUsedError;

  /// 저장 일시 (ISO 8601 형식)
  String get savedAt => throw _privateConstructorUsedError;

  /// Serializes this SavePlaceResponse to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SavePlaceResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SavePlaceResponseCopyWith<SavePlaceResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SavePlaceResponseCopyWith<$Res> {
  factory $SavePlaceResponseCopyWith(
    SavePlaceResponse value,
    $Res Function(SavePlaceResponse) then,
  ) = _$SavePlaceResponseCopyWithImpl<$Res, SavePlaceResponse>;
  @useResult
  $Res call({
    String memberPlaceId,
    String placeId,
    String savedStatus,
    String savedAt,
  });
}

/// @nodoc
class _$SavePlaceResponseCopyWithImpl<$Res, $Val extends SavePlaceResponse>
    implements $SavePlaceResponseCopyWith<$Res> {
  _$SavePlaceResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SavePlaceResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? memberPlaceId = null,
    Object? placeId = null,
    Object? savedStatus = null,
    Object? savedAt = null,
  }) {
    return _then(
      _value.copyWith(
            memberPlaceId: null == memberPlaceId
                ? _value.memberPlaceId
                : memberPlaceId // ignore: cast_nullable_to_non_nullable
                      as String,
            placeId: null == placeId
                ? _value.placeId
                : placeId // ignore: cast_nullable_to_non_nullable
                      as String,
            savedStatus: null == savedStatus
                ? _value.savedStatus
                : savedStatus // ignore: cast_nullable_to_non_nullable
                      as String,
            savedAt: null == savedAt
                ? _value.savedAt
                : savedAt // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$SavePlaceResponseImplCopyWith<$Res>
    implements $SavePlaceResponseCopyWith<$Res> {
  factory _$$SavePlaceResponseImplCopyWith(
    _$SavePlaceResponseImpl value,
    $Res Function(_$SavePlaceResponseImpl) then,
  ) = __$$SavePlaceResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String memberPlaceId,
    String placeId,
    String savedStatus,
    String savedAt,
  });
}

/// @nodoc
class __$$SavePlaceResponseImplCopyWithImpl<$Res>
    extends _$SavePlaceResponseCopyWithImpl<$Res, _$SavePlaceResponseImpl>
    implements _$$SavePlaceResponseImplCopyWith<$Res> {
  __$$SavePlaceResponseImplCopyWithImpl(
    _$SavePlaceResponseImpl _value,
    $Res Function(_$SavePlaceResponseImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of SavePlaceResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? memberPlaceId = null,
    Object? placeId = null,
    Object? savedStatus = null,
    Object? savedAt = null,
  }) {
    return _then(
      _$SavePlaceResponseImpl(
        memberPlaceId: null == memberPlaceId
            ? _value.memberPlaceId
            : memberPlaceId // ignore: cast_nullable_to_non_nullable
                  as String,
        placeId: null == placeId
            ? _value.placeId
            : placeId // ignore: cast_nullable_to_non_nullable
                  as String,
        savedStatus: null == savedStatus
            ? _value.savedStatus
            : savedStatus // ignore: cast_nullable_to_non_nullable
                  as String,
        savedAt: null == savedAt
            ? _value.savedAt
            : savedAt // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$SavePlaceResponseImpl implements _SavePlaceResponse {
  const _$SavePlaceResponseImpl({
    required this.memberPlaceId,
    required this.placeId,
    required this.savedStatus,
    required this.savedAt,
  });

  factory _$SavePlaceResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$SavePlaceResponseImplFromJson(json);

  /// 회원 장소 ID (회원-장소 연결 테이블의 고유 ID)
  @override
  final String memberPlaceId;

  /// 장소 ID
  @override
  final String placeId;

  /// 저장 상태 (SAVED, TEMPORARY 등)
  @override
  final String savedStatus;

  /// 저장 일시 (ISO 8601 형식)
  @override
  final String savedAt;

  @override
  String toString() {
    return 'SavePlaceResponse(memberPlaceId: $memberPlaceId, placeId: $placeId, savedStatus: $savedStatus, savedAt: $savedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SavePlaceResponseImpl &&
            (identical(other.memberPlaceId, memberPlaceId) ||
                other.memberPlaceId == memberPlaceId) &&
            (identical(other.placeId, placeId) || other.placeId == placeId) &&
            (identical(other.savedStatus, savedStatus) ||
                other.savedStatus == savedStatus) &&
            (identical(other.savedAt, savedAt) || other.savedAt == savedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, memberPlaceId, placeId, savedStatus, savedAt);

  /// Create a copy of SavePlaceResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SavePlaceResponseImplCopyWith<_$SavePlaceResponseImpl> get copyWith =>
      __$$SavePlaceResponseImplCopyWithImpl<_$SavePlaceResponseImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$SavePlaceResponseImplToJson(this);
  }
}

abstract class _SavePlaceResponse implements SavePlaceResponse {
  const factory _SavePlaceResponse({
    required final String memberPlaceId,
    required final String placeId,
    required final String savedStatus,
    required final String savedAt,
  }) = _$SavePlaceResponseImpl;

  factory _SavePlaceResponse.fromJson(Map<String, dynamic> json) =
      _$SavePlaceResponseImpl.fromJson;

  /// 회원 장소 ID (회원-장소 연결 테이블의 고유 ID)
  @override
  String get memberPlaceId;

  /// 장소 ID
  @override
  String get placeId;

  /// 저장 상태 (SAVED, TEMPORARY 등)
  @override
  String get savedStatus;

  /// 저장 일시 (ISO 8601 형식)
  @override
  String get savedAt;

  /// Create a copy of SavePlaceResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SavePlaceResponseImplCopyWith<_$SavePlaceResponseImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
