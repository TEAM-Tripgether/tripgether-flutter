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
  onboardingStatus: json['onboardingStatus'] as String?,
  isServiceTermsAndPrivacyAgreed:
      json['isServiceTermsAndPrivacyAgreed'] as bool?,
  isMarketingAgreed: json['isMarketingAgreed'] as bool?,
  birthDate: json['birthDate'] as String?,
  gender: json['gender'] as String?,
);

Map<String, dynamic> _$$UserImplToJson(_$UserImpl instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'email': instance.email,
      'nickname': instance.nickname,
      'profileImageUrl': instance.profileImageUrl,
      'loginPlatform': instance.loginPlatform,
      'createdAt': instance.createdAt.toIso8601String(),
      'onboardingStatus': instance.onboardingStatus,
      'isServiceTermsAndPrivacyAgreed': instance.isServiceTermsAndPrivacyAgreed,
      'isMarketingAgreed': instance.isMarketingAgreed,
      'birthDate': instance.birthDate,
      'gender': instance.gender,
    };
