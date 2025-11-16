// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'onboarding_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$OnboardingDataImpl _$$OnboardingDataImplFromJson(Map<String, dynamic> json) =>
    _$OnboardingDataImpl(
      termsOfService: json['termsOfService'] as bool? ?? false,
      privacyPolicy: json['privacyPolicy'] as bool? ?? false,
      ageConfirmation: json['ageConfirmation'] as bool? ?? false,
      marketingConsent: json['marketingConsent'] as bool? ?? false,
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
  'termsOfService': instance.termsOfService,
  'privacyPolicy': instance.privacyPolicy,
  'ageConfirmation': instance.ageConfirmation,
  'marketingConsent': instance.marketingConsent,
  'nickname': instance.nickname,
  'gender': instance.gender,
  'birthdate': instance.birthdate,
  'interests': instance.interests,
};
