// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'business_hour_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$BusinessHourModelImpl _$$BusinessHourModelImplFromJson(
  Map<String, dynamic> json,
) => _$BusinessHourModelImpl(
  dayOfWeek: json['dayOfWeek'] as String,
  openTime: json['openTime'] as String,
  closeTime: json['closeTime'] as String,
);

Map<String, dynamic> _$$BusinessHourModelImplToJson(
  _$BusinessHourModelImpl instance,
) => <String, dynamic>{
  'dayOfWeek': instance.dayOfWeek,
  'openTime': instance.openTime,
  'closeTime': instance.closeTime,
};
