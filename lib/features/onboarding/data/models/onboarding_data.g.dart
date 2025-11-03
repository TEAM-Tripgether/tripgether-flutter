// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'onboarding_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$OnboardingDataImpl _$$OnboardingDataImplFromJson(Map<String, dynamic> json) =>
    _$OnboardingDataImpl(
      nickname: json['nickname'] as String? ?? '',
      gender: json['gender'] as String? ?? 'NONE',
      birthdate: json['birthdate'] as String?,
      interests:
          (json['interests'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$OnboardingDataImplToJson(
  _$OnboardingDataImpl instance,
) => <String, dynamic>{
  'nickname': instance.nickname,
  'gender': instance.gender,
  'birthdate': instance.birthdate,
  'interests': instance.interests,
};
