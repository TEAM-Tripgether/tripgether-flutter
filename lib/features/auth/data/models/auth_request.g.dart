// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AuthRequestImpl _$$AuthRequestImplFromJson(Map<String, dynamic> json) =>
    _$AuthRequestImpl(
      socialPlatform: json['socialPlatform'] as String?,
      email: json['email'] as String?,
      name: json['name'] as String?,
      profileUrl: json['profileUrl'] as String?,
      refreshToken: json['refreshToken'] as String?,
    );

Map<String, dynamic> _$$AuthRequestImplToJson(_$AuthRequestImpl instance) =>
    <String, dynamic>{
      'socialPlatform': instance.socialPlatform,
      'email': instance.email,
      'name': instance.name,
      'profileUrl': instance.profileUrl,
      'refreshToken': instance.refreshToken,
    };
