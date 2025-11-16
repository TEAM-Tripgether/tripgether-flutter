// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'onboarding_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$onboardingHash() => r'a2540393dfc10a6a3a859ed6be5ffab3a435acc1';

/// 온보딩 데이터 상태 관리 Provider
///
/// **역할**:
/// - 온보딩 6단계(약관, 닉네임, 성별, 생년월일, 관심사, 환영)에서 입력받은 데이터를 중앙 관리
/// - 페이지 간 데이터 전달 및 최종 welcome_page에서 개인화된 메시지 표시
/// - 백엔드 API 연동 시 한 번에 모든 데이터 전송 가능
///
/// **사용 위치**:
/// - TermsPage: 약관 동의 시 `updateTermsAgreement()` 호출
/// - NicknamePage: 닉네임 입력 시 `updateNickname()` 호출
/// - GenderPage: 성별 선택 시 `updateGender()` 호출
/// - BirthdatePage: 생년월일 입력 시 `updateBirthdate()` 호출
/// - InterestsPage: 관심사 선택 시 `updateInterests()` 호출
/// - WelcomePage: 저장된 닉네임으로 환영 메시지 표시
///
/// **API 연동 예시** (향후):
/// ```dart
/// final onboardingData = ref.read(onboardingProvider);
/// await authApi.updateUserProfile(onboardingData.toJson());
/// ```
///
/// **상태 타입**: `OnboardingData` (Freezed 모델)
///
/// Copied from [Onboarding].
@ProviderFor(Onboarding)
final onboardingProvider =
    NotifierProvider<Onboarding, OnboardingData>.internal(
      Onboarding.new,
      name: r'onboardingProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$onboardingHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$Onboarding = Notifier<OnboardingData>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
