import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tripgether/features/onboarding/data/models/onboarding_data.dart';

part 'onboarding_provider.g.dart';

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
@Riverpod(keepAlive: true)
class Onboarding extends _$Onboarding {
  /// Provider 초기화
  ///
  /// 앱 시작 시 빈 OnboardingData 객체로 초기화됩니다.
  ///
  /// **keepAlive: true 이유**:
  /// - 온보딩 과정 중 페이지 이동 시 상태가 유지되어야 함
  /// - 사용자가 뒤로 가기 시 입력한 값이 그대로 남아있어야 함
  @override
  OnboardingData build() {
    debugPrint('[OnboardingProvider] 🎯 Provider 초기화');
    return const OnboardingData();
  }

  /// 약관 동의 업데이트
  ///
  /// **호출 위치**: TermsPage
  ///
  /// **필수 약관**:
  /// - 서비스 이용약관 (termsOfService)
  /// - 개인정보 처리방침 (privacyPolicy)
  /// - 만 14세 이상 확인 (ageConfirmation)
  ///
  /// **선택 약관**:
  /// - 마케팅 정보 수신 동의 (marketingConsent)
  ///
  /// **사용 예시**:
  /// ```dart
  /// ref.read(onboardingProvider.notifier).updateTermsAgreement(
  ///   termsOfService: true,
  ///   privacyPolicy: true,
  ///   ageConfirmation: true,
  ///   marketingConsent: false,
  /// );
  /// ```
  void updateTermsAgreement({
    required bool termsOfService,
    required bool privacyPolicy,
    required bool ageConfirmation,
    required bool marketingConsent,
  }) {
    debugPrint('[OnboardingProvider] 📜 약관 동의 업데이트');
    debugPrint('  - 서비스 이용약관: $termsOfService');
    debugPrint('  - 개인정보 처리방침: $privacyPolicy');
    debugPrint('  - 만 14세 이상: $ageConfirmation');
    debugPrint('  - 마케팅 동의: $marketingConsent');

    state = state.copyWith(
      termsOfService: termsOfService,
      privacyPolicy: privacyPolicy,
      ageConfirmation: ageConfirmation,
      marketingConsent: marketingConsent,
    );

    debugPrint('[OnboardingProvider] ✅ 약관 동의 업데이트 완료');
  }

  /// 닉네임 업데이트
  ///
  /// **호출 위치**: NicknamePage
  ///
  /// **검증 규칙**:
  /// - 2-10자 (UI에서 검증)
  /// - 비속어/광고 문구 제한 (서버에서 검증)
  ///
  /// **사용 예시**:
  /// ```dart
  /// ref.read(onboardingProvider.notifier).updateNickname('여행러버');
  /// ```
  ///
  /// [nickname] 사용자가 입력한 닉네임 (2-10자)
  void updateNickname(String nickname) {
    debugPrint('[OnboardingProvider] 📝 닉네임 업데이트: $nickname');

    state = state.copyWith(nickname: nickname);

    debugPrint('[OnboardingProvider] ✅ 현재 상태: ${state.nickname}');
  }

  /// 성별 업데이트
  ///
  /// **호출 위치**: GenderPage
  ///
  /// **선택지**:
  /// - 'MALE': 남성
  /// - 'FEMALE': 여성
  /// - 'NONE': 선택 안 함
  ///
  /// **사용 예시**:
  /// ```dart
  /// ref.read(onboardingProvider.notifier).updateGender('MALE');
  /// ```
  ///
  /// [gender] 선택한 성별 ('MALE', 'FEMALE', 'NONE')
  void updateGender(String gender) {
    debugPrint('[OnboardingProvider] 👤 성별 업데이트: $gender');

    state = state.copyWith(gender: gender);

    debugPrint('[OnboardingProvider] ✅ 현재 상태: ${state.gender}');
  }

  /// 생년월일 업데이트
  ///
  /// **호출 위치**: BirthdatePage
  ///
  /// **형식**: YYYY-MM-DD (예: 1990-01-01)
  ///
  /// **사용 예시**:
  /// ```dart
  /// ref.read(onboardingProvider.notifier).updateBirthdate('1990-01-01');
  /// ```
  ///
  /// [birthdate] 생년월일 문자열 (YYYY-MM-DD)
  void updateBirthdate(String? birthdate) {
    debugPrint('[OnboardingProvider] 📅 생년월일 업데이트: $birthdate');

    state = state.copyWith(birthdate: birthdate);

    debugPrint('[OnboardingProvider] ✅ 현재 상태: ${state.birthdate}');
  }

  /// 관심사 목록 업데이트
  ///
  /// **호출 위치**: InterestsPage
  ///
  /// **검증 규칙**:
  /// - 최소 3개 권장 (정확도 향상)
  /// - 최대 10개
  ///
  /// **사용 예시**:
  /// ```dart
  /// ref.read(onboardingProvider.notifier).updateInterests(['수영', '등산', '맛집 탐방']);
  /// ```
  ///
  /// [interests] 선택한 관심사 목록
  void updateInterests(List<String> interests) {
    debugPrint('[OnboardingProvider] 🎯 관심사 업데이트: $interests');

    state = state.copyWith(interests: interests);

    debugPrint('[OnboardingProvider] ✅ 현재 상태: ${state.interests}');
  }

  /// 온보딩 데이터 초기화
  ///
  /// **사용 시점**:
  /// - 온보딩 완료 후 데이터를 백엔드에 전송한 다음
  /// - 사용자가 온보딩을 다시 시작할 때
  ///
  /// **사용 예시**:
  /// ```dart
  /// await authApi.updateUserProfile(state.toJson());
  /// ref.read(onboardingProvider.notifier).reset();
  /// ```
  void reset() {
    debugPrint('[OnboardingProvider] 🔄 온보딩 데이터 초기화');

    state = const OnboardingData();

    debugPrint('[OnboardingProvider] ✅ 초기화 완료');
  }

  /// 온보딩 완료 처리 (백엔드 API 연동용 placeholder)
  ///
  /// **향후 구현 예정**:
  /// ```dart
  /// Future<void> submitOnboarding() async {
  ///   try {
  ///     debugPrint('[OnboardingProvider] 📤 온보딩 데이터 전송 시작');
  ///
  ///     // 백엔드 API 호출
  ///     final response = await ref.read(authApiProvider).updateUserProfile(
  ///       nickname: state.nickname,
  ///       gender: state.gender,
  ///       birthdate: state.birthdate,
  ///       interests: state.interests,
  ///     );
  ///
  ///     // UserProvider에도 닉네임 반영
  ///     final currentUser = await ref.read(userNotifierProvider.future);
  ///     if (currentUser != null) {
  ///       await ref.read(userNotifierProvider.notifier).updateUser(
  ///         currentUser.copyWith(nickname: state.nickname),
  ///       );
  ///     }
  ///
  ///     debugPrint('[OnboardingProvider] ✅ 온보딩 데이터 전송 완료');
  ///
  ///     // 초기화 (선택사항)
  ///     reset();
  ///   } catch (e) {
  ///     debugPrint('[OnboardingProvider] ❌ 온보딩 데이터 전송 실패: $e');
  ///     rethrow;
  ///   }
  /// }
  /// ```
}
