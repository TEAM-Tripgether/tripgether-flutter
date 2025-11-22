// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'onboarding_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$OnboardingResponseImpl _$$OnboardingResponseImplFromJson(
  Map<String, dynamic> json,
) => _$OnboardingResponseImpl(
  currentStep: json['currentStep'] as String,
  onboardingStatus: json['onboardingStatus'] as String,
  member: MemberDto.fromJson(json['member'] as Map<String, dynamic>),
);

Map<String, dynamic> _$$OnboardingResponseImplToJson(
  _$OnboardingResponseImpl instance,
) => <String, dynamic>{
  'currentStep': instance.currentStep,
  'onboardingStatus': instance.onboardingStatus,
  'member': instance.member,
};

_$MemberDtoImpl _$$MemberDtoImplFromJson(Map<String, dynamic> json) =>
    _$MemberDtoImpl(
      id: json['id'] as String,
      email: json['email'] as String,
      name: json['name'] as String,
      onboardingStatus: json['onboardingStatus'] as String,
      isServiceTermsAndPrivacyAgreed:
          json['isServiceTermsAndPrivacyAgreed'] as bool,
      isMarketingAgreed: json['isMarketingAgreed'] as bool,
      birthDate: json['birthDate'] as String?,
      gender: json['gender'] as String?,
    );

Map<String, dynamic> _$$MemberDtoImplToJson(_$MemberDtoImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'email': instance.email,
      'name': instance.name,
      'onboardingStatus': instance.onboardingStatus,
      'isServiceTermsAndPrivacyAgreed': instance.isServiceTermsAndPrivacyAgreed,
      'isMarketingAgreed': instance.isMarketingAgreed,
      'birthDate': instance.birthDate,
      'gender': instance.gender,
    };
