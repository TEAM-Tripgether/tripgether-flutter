// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'business_hour_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

BusinessHourModel _$BusinessHourModelFromJson(Map<String, dynamic> json) {
  return _BusinessHourModel.fromJson(json);
}

/// @nodoc
mixin _$BusinessHourModel {
  /// 요일 (MONDAY, TUESDAY, WEDNESDAY, THURSDAY, FRIDAY, SATURDAY, SUNDAY)
  String get dayOfWeek => throw _privateConstructorUsedError;

  /// 오픈 시간 (HH:mm 형식, 예: "09:00")
  String get openTime => throw _privateConstructorUsedError;

  /// 마감 시간 (HH:mm 형식, 예: "22:00")
  String get closeTime => throw _privateConstructorUsedError;

  /// Serializes this BusinessHourModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of BusinessHourModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BusinessHourModelCopyWith<BusinessHourModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BusinessHourModelCopyWith<$Res> {
  factory $BusinessHourModelCopyWith(
    BusinessHourModel value,
    $Res Function(BusinessHourModel) then,
  ) = _$BusinessHourModelCopyWithImpl<$Res, BusinessHourModel>;
  @useResult
  $Res call({String dayOfWeek, String openTime, String closeTime});
}

/// @nodoc
class _$BusinessHourModelCopyWithImpl<$Res, $Val extends BusinessHourModel>
    implements $BusinessHourModelCopyWith<$Res> {
  _$BusinessHourModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of BusinessHourModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? dayOfWeek = null,
    Object? openTime = null,
    Object? closeTime = null,
  }) {
    return _then(
      _value.copyWith(
            dayOfWeek: null == dayOfWeek
                ? _value.dayOfWeek
                : dayOfWeek // ignore: cast_nullable_to_non_nullable
                      as String,
            openTime: null == openTime
                ? _value.openTime
                : openTime // ignore: cast_nullable_to_non_nullable
                      as String,
            closeTime: null == closeTime
                ? _value.closeTime
                : closeTime // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$BusinessHourModelImplCopyWith<$Res>
    implements $BusinessHourModelCopyWith<$Res> {
  factory _$$BusinessHourModelImplCopyWith(
    _$BusinessHourModelImpl value,
    $Res Function(_$BusinessHourModelImpl) then,
  ) = __$$BusinessHourModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String dayOfWeek, String openTime, String closeTime});
}

/// @nodoc
class __$$BusinessHourModelImplCopyWithImpl<$Res>
    extends _$BusinessHourModelCopyWithImpl<$Res, _$BusinessHourModelImpl>
    implements _$$BusinessHourModelImplCopyWith<$Res> {
  __$$BusinessHourModelImplCopyWithImpl(
    _$BusinessHourModelImpl _value,
    $Res Function(_$BusinessHourModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of BusinessHourModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? dayOfWeek = null,
    Object? openTime = null,
    Object? closeTime = null,
  }) {
    return _then(
      _$BusinessHourModelImpl(
        dayOfWeek: null == dayOfWeek
            ? _value.dayOfWeek
            : dayOfWeek // ignore: cast_nullable_to_non_nullable
                  as String,
        openTime: null == openTime
            ? _value.openTime
            : openTime // ignore: cast_nullable_to_non_nullable
                  as String,
        closeTime: null == closeTime
            ? _value.closeTime
            : closeTime // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$BusinessHourModelImpl implements _BusinessHourModel {
  const _$BusinessHourModelImpl({
    required this.dayOfWeek,
    required this.openTime,
    required this.closeTime,
  });

  factory _$BusinessHourModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$BusinessHourModelImplFromJson(json);

  /// 요일 (MONDAY, TUESDAY, WEDNESDAY, THURSDAY, FRIDAY, SATURDAY, SUNDAY)
  @override
  final String dayOfWeek;

  /// 오픈 시간 (HH:mm 형식, 예: "09:00")
  @override
  final String openTime;

  /// 마감 시간 (HH:mm 형식, 예: "22:00")
  @override
  final String closeTime;

  @override
  String toString() {
    return 'BusinessHourModel(dayOfWeek: $dayOfWeek, openTime: $openTime, closeTime: $closeTime)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BusinessHourModelImpl &&
            (identical(other.dayOfWeek, dayOfWeek) ||
                other.dayOfWeek == dayOfWeek) &&
            (identical(other.openTime, openTime) ||
                other.openTime == openTime) &&
            (identical(other.closeTime, closeTime) ||
                other.closeTime == closeTime));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, dayOfWeek, openTime, closeTime);

  /// Create a copy of BusinessHourModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BusinessHourModelImplCopyWith<_$BusinessHourModelImpl> get copyWith =>
      __$$BusinessHourModelImplCopyWithImpl<_$BusinessHourModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$BusinessHourModelImplToJson(this);
  }
}

abstract class _BusinessHourModel implements BusinessHourModel {
  const factory _BusinessHourModel({
    required final String dayOfWeek,
    required final String openTime,
    required final String closeTime,
  }) = _$BusinessHourModelImpl;

  factory _BusinessHourModel.fromJson(Map<String, dynamic> json) =
      _$BusinessHourModelImpl.fromJson;

  /// 요일 (MONDAY, TUESDAY, WEDNESDAY, THURSDAY, FRIDAY, SATURDAY, SUNDAY)
  @override
  String get dayOfWeek;

  /// 오픈 시간 (HH:mm 형식, 예: "09:00")
  @override
  String get openTime;

  /// 마감 시간 (HH:mm 형식, 예: "22:00")
  @override
  String get closeTime;

  /// Create a copy of BusinessHourModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BusinessHourModelImplCopyWith<_$BusinessHourModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
