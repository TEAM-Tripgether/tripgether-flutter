// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AuthResponseImpl _$$AuthResponseImplFromJson(Map<String, dynamic> json) =>
    _$AuthResponseImpl(
      accessToken: json['accessToken'] as String,
      refreshToken: json['refreshToken'] as String,
      isFirstLogin: json['isFirstLogin'] as bool,
      requiresOnboarding: json['requiresOnboarding'] as bool,
      onboardingStep: json['onboardingStep'] as String,
    );

Map<String, dynamic> _$$AuthResponseImplToJson(_$AuthResponseImpl instance) =>
    <String, dynamic>{
      'accessToken': instance.accessToken,
      'refreshToken': instance.refreshToken,
      'isFirstLogin': instance.isFirstLogin,
      'requiresOnboarding': instance.requiresOnboarding,
      'onboardingStep': instance.onboardingStep,
    };
