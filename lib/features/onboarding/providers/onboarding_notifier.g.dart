// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'onboarding_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$onboardingNotifierHash() =>
    r'91f1548076435883832c20b4405516b06150f2f5';

/// 온보딩 상태 및 API 호출 관리
///
/// **역할**:
/// 1. 5단계 온보딩 API 호출 (약관 → 이름 → 생년월일 → 성별 → 관심사)
/// 2. API 응답 상태 관리 (OnboardingResponse)
/// 3. currentStep을 Secure Storage에 저장 (앱 재시작 시 복원용)
///
/// **OnboardingData vs OnboardingNotifier**:
/// - OnboardingData (onboarding_provider.dart): UI 입력 데이터 임시 저장
/// - OnboardingNotifier (이 파일): API 호출 및 서버 응답 상태 관리
///
/// **사용 예시**:
/// ```dart
/// final response = await ref.read(onboardingNotifierProvider.notifier).agreeTerms(
///   isServiceTermsAndPrivacyAgreed: true,
///   isMarketingAgreed: false,
/// );
///
/// if (response != null) {
///   // response.currentStep에 따라 다음 페이지로 이동
///   _navigateToNextPage(response.currentStep);
/// }
/// ```
///
/// Copied from [OnboardingNotifier].
@ProviderFor(OnboardingNotifier)
final onboardingNotifierProvider =
    AutoDisposeAsyncNotifierProvider<
      OnboardingNotifier,
      OnboardingResponse?
    >.internal(
      OnboardingNotifier.new,
      name: r'onboardingNotifierProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$onboardingNotifierHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$OnboardingNotifier = AutoDisposeAsyncNotifier<OnboardingResponse?>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
