// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserImpl _$$UserImplFromJson(Map<String, dynamic> json) => _$UserImpl(
  userId: json['userId'] as String?,
  email: json['email'] as String,
  nickname: json['nickname'] as String,
  profileImageUrl: json['profileImageUrl'] as String?,
  loginPlatform: json['loginPlatform'] as String?,
  createdAt: DateTime.parse(json['createdAt'] as String),
);

Map<String, dynamic> _$$UserImplToJson(_$UserImpl instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'email': instance.email,
      'nickname': instance.nickname,
      'profileImageUrl': instance.profileImageUrl,
      'loginPlatform': instance.loginPlatform,
      'createdAt': instance.createdAt.toIso8601String(),
    };
