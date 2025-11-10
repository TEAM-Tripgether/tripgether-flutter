// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fcm_token_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$FcmTokenRequestImpl _$$FcmTokenRequestImplFromJson(
  Map<String, dynamic> json,
) => _$FcmTokenRequestImpl(
  fcmToken: json['fcmToken'] as String,
  deviceType: json['deviceType'] as String,
  deviceName: json['deviceName'] as String,
);

Map<String, dynamic> _$$FcmTokenRequestImplToJson(
  _$FcmTokenRequestImpl instance,
) => <String, dynamic>{
  'fcmToken': instance.fcmToken,
  'deviceType': instance.deviceType,
  'deviceName': instance.deviceName,
};
