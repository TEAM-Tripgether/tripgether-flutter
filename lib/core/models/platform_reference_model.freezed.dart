// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'platform_reference_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

PlatformReferenceModel _$PlatformReferenceModelFromJson(
  Map<String, dynamic> json,
) {
  return _PlatformReferenceModel.fromJson(json);
}

/// @nodoc
mixin _$PlatformReferenceModel {
  /// 플랫폼 종류 (GOOGLE, KAKAO, NAVER 등)
  String get placePlatform => throw _privateConstructorUsedError;

  /// 해당 플랫폼에서의 장소 고유 ID
  String get placePlatformId => throw _privateConstructorUsedError;

  /// Serializes this PlatformReferenceModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PlatformReferenceModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PlatformReferenceModelCopyWith<PlatformReferenceModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PlatformReferenceModelCopyWith<$Res> {
  factory $PlatformReferenceModelCopyWith(
    PlatformReferenceModel value,
    $Res Function(PlatformReferenceModel) then,
  ) = _$PlatformReferenceModelCopyWithImpl<$Res, PlatformReferenceModel>;
  @useResult
  $Res call({String placePlatform, String placePlatformId});
}

/// @nodoc
class _$PlatformReferenceModelCopyWithImpl<
  $Res,
  $Val extends PlatformReferenceModel
>
    implements $PlatformReferenceModelCopyWith<$Res> {
  _$PlatformReferenceModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PlatformReferenceModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? placePlatform = null, Object? placePlatformId = null}) {
    return _then(
      _value.copyWith(
            placePlatform: null == placePlatform
                ? _value.placePlatform
                : placePlatform // ignore: cast_nullable_to_non_nullable
                      as String,
            placePlatformId: null == placePlatformId
                ? _value.placePlatformId
                : placePlatformId // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$PlatformReferenceModelImplCopyWith<$Res>
    implements $PlatformReferenceModelCopyWith<$Res> {
  factory _$$PlatformReferenceModelImplCopyWith(
    _$PlatformReferenceModelImpl value,
    $Res Function(_$PlatformReferenceModelImpl) then,
  ) = __$$PlatformReferenceModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String placePlatform, String placePlatformId});
}

/// @nodoc
class __$$PlatformReferenceModelImplCopyWithImpl<$Res>
    extends
        _$PlatformReferenceModelCopyWithImpl<$Res, _$PlatformReferenceModelImpl>
    implements _$$PlatformReferenceModelImplCopyWith<$Res> {
  __$$PlatformReferenceModelImplCopyWithImpl(
    _$PlatformReferenceModelImpl _value,
    $Res Function(_$PlatformReferenceModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PlatformReferenceModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? placePlatform = null, Object? placePlatformId = null}) {
    return _then(
      _$PlatformReferenceModelImpl(
        placePlatform: null == placePlatform
            ? _value.placePlatform
            : placePlatform // ignore: cast_nullable_to_non_nullable
                  as String,
        placePlatformId: null == placePlatformId
            ? _value.placePlatformId
            : placePlatformId // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$PlatformReferenceModelImpl implements _PlatformReferenceModel {
  const _$PlatformReferenceModelImpl({
    required this.placePlatform,
    required this.placePlatformId,
  });

  factory _$PlatformReferenceModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$PlatformReferenceModelImplFromJson(json);

  /// 플랫폼 종류 (GOOGLE, KAKAO, NAVER 등)
  @override
  final String placePlatform;

  /// 해당 플랫폼에서의 장소 고유 ID
  @override
  final String placePlatformId;

  @override
  String toString() {
    return 'PlatformReferenceModel(placePlatform: $placePlatform, placePlatformId: $placePlatformId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PlatformReferenceModelImpl &&
            (identical(other.placePlatform, placePlatform) ||
                other.placePlatform == placePlatform) &&
            (identical(other.placePlatformId, placePlatformId) ||
                other.placePlatformId == placePlatformId));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, placePlatform, placePlatformId);

  /// Create a copy of PlatformReferenceModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PlatformReferenceModelImplCopyWith<_$PlatformReferenceModelImpl>
  get copyWith =>
      __$$PlatformReferenceModelImplCopyWithImpl<_$PlatformReferenceModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$PlatformReferenceModelImplToJson(this);
  }
}

abstract class _PlatformReferenceModel implements PlatformReferenceModel {
  const factory _PlatformReferenceModel({
    required final String placePlatform,
    required final String placePlatformId,
  }) = _$PlatformReferenceModelImpl;

  factory _PlatformReferenceModel.fromJson(Map<String, dynamic> json) =
      _$PlatformReferenceModelImpl.fromJson;

  /// 플랫폼 종류 (GOOGLE, KAKAO, NAVER 등)
  @override
  String get placePlatform;

  /// 해당 플랫폼에서의 장소 고유 ID
  @override
  String get placePlatformId;

  /// Create a copy of PlatformReferenceModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PlatformReferenceModelImplCopyWith<_$PlatformReferenceModelImpl>
  get copyWith => throw _privateConstructorUsedError;
}
