import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../auth/providers/user_provider.dart';
import '../data/models/onboarding_response.dart';
import '../services/onboarding_api_service.dart';

part 'onboarding_notifier.g.dart';

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
@riverpod
class OnboardingNotifier extends _$OnboardingNotifier {
  final _storage = const FlutterSecureStorage();
  final _apiService = OnboardingApiService();

  /// Provider 초기화
  ///
  /// 초기 상태: null (온보딩 시작 전)
  @override
  Future<OnboardingResponse?> build() async {
    debugPrint('[OnboardingNotifier] 📱 Provider 초기화');
    return null;
  }

  // ══════════════════════════════════════════════════════════════════════════
  // 온보딩 단계별 API 호출
  // ══════════════════════════════════════════════════════════════════════════

  /// 1. 약관 동의
  ///
  /// **호출 위치**: TermsPage
  ///
  /// **API**: POST /api/members/onboarding/terms
  ///
  /// **응답**: currentStep = "NAME" (다음 단계: 이름 입력)
  ///
  /// **사용 예시**:
  /// ```dart
  /// final response = await ref.read(onboardingNotifierProvider.notifier).agreeTerms(
  ///   isServiceTermsAndPrivacyAgreed: true,
  ///   isMarketingAgreed: false,
  /// );
  ///
  /// if (response != null && response.currentStep == "NAME") {
  ///   widget.pageController.nextPage(...);
  /// }
  /// ```
  Future<OnboardingResponse?> agreeTerms({
    required bool isServiceTermsAndPrivacyAgreed,
    required bool isMarketingAgreed,
  }) async {
    try {
      // 1. Access Token 가져오기 (메모리 캐시에서 즉시 읽기)
      final accessToken = await ref
          .read(userNotifierProvider.notifier)
          .getAccessToken();
      if (accessToken == null) {
        debugPrint('[OnboardingNotifier] ❌ Access Token 없음');
        return null;
      }

      debugPrint('[OnboardingNotifier] 📜 약관 동의 API 호출');

      // 2. API 호출
      final response = await _apiService.agreeTerms(
        accessToken: accessToken,
        isServiceTermsAndPrivacyAgreed: isServiceTermsAndPrivacyAgreed,
        isMarketingAgreed: isMarketingAgreed,
      );

      debugPrint(
        '[OnboardingNotifier] ✅ 약관 동의 성공 → currentStep: ${response.currentStep}',
      );

      // 3. currentStep을 Secure Storage에 저장 (앱 재시작 복원용)
      await _storage.write(key: 'onboardingStep', value: response.currentStep);

      // 4. 상태 업데이트
      state = AsyncValue.data(response);

      return response;
    } catch (e, stack) {
      debugPrint('[OnboardingNotifier] ❌ 약관 동의 실패: $e');
      state = AsyncValue.error(e, stack);
      rethrow; // 에러를 상위로 전파하여 실제 에러 메시지를 UI에서 사용 가능하게 함
    }
  }

  /// 2. 이름 설정
  ///
  /// **호출 위치**: NicknamePage
  ///
  /// **API**: POST /api/members/onboarding/name
  ///
  /// **응답**: currentStep = "BIRTH_DATE" (다음 단계: 생년월일 입력)
  Future<OnboardingResponse?> updateName({required String name}) async {
    try {
      final accessToken = await ref
          .read(userNotifierProvider.notifier)
          .getAccessToken();
      if (accessToken == null) {
        debugPrint('[OnboardingNotifier] ❌ Access Token 없음');
        return null;
      }

      debugPrint('[OnboardingNotifier] 📝 이름 설정 API 호출: $name');

      final response = await _apiService.updateName(
        accessToken: accessToken,
        name: name,
      );

      debugPrint(
        '[OnboardingNotifier] ✅ 이름 설정 성공 → currentStep: ${response.currentStep}',
      );

      await _storage.write(key: 'onboardingStep', value: response.currentStep);
      state = AsyncValue.data(response);

      return response;
    } catch (e, stack) {
      debugPrint('[OnboardingNotifier] ❌ 이름 설정 실패: $e');
      state = AsyncValue.error(e, stack);
      rethrow; // 에러를 상위로 전파하여 실제 에러 메시지를 UI에서 사용 가능하게 함
    }
  }

  /// 3. 생년월일 설정
  ///
  /// **호출 위치**: BirthdatePage
  ///
  /// **API**: POST /api/members/onboarding/birth-date
  ///
  /// **응답**: currentStep = "GENDER" (다음 단계: 성별 선택)
  Future<OnboardingResponse?> updateBirthDate({
    required String birthDate,
  }) async {
    try {
      final accessToken = await ref
          .read(userNotifierProvider.notifier)
          .getAccessToken();
      if (accessToken == null) {
        debugPrint('[OnboardingNotifier] ❌ Access Token 없음');
        return null;
      }

      debugPrint('[OnboardingNotifier] 📅 생년월일 설정 API 호출: $birthDate');

      final response = await _apiService.updateBirthDate(
        accessToken: accessToken,
        birthDate: birthDate,
      );

      debugPrint(
        '[OnboardingNotifier] ✅ 생년월일 설정 성공 → currentStep: ${response.currentStep}',
      );

      await _storage.write(key: 'onboardingStep', value: response.currentStep);
      state = AsyncValue.data(response);

      return response;
    } catch (e, stack) {
      debugPrint('[OnboardingNotifier] ❌ 생년월일 설정 실패: $e');
      state = AsyncValue.error(e, stack);
      rethrow; // 에러를 상위로 전파하여 실제 에러 메시지를 UI에서 사용 가능하게 함
    }
  }

  /// 4. 성별 설정
  ///
  /// **호출 위치**: GenderPage
  ///
  /// **API**: POST /api/members/onboarding/gender
  ///
  /// **응답**: currentStep = "INTERESTS" (다음 단계: 관심사 선택)
  Future<OnboardingResponse?> updateGender({required String gender}) async {
    try {
      final accessToken = await ref
          .read(userNotifierProvider.notifier)
          .getAccessToken();
      if (accessToken == null) {
        debugPrint('[OnboardingNotifier] ❌ Access Token 없음');
        return null;
      }

      debugPrint('[OnboardingNotifier] 👤 성별 설정 API 호출: $gender');

      final response = await _apiService.updateGender(
        accessToken: accessToken,
        gender: gender,
      );

      debugPrint(
        '[OnboardingNotifier] ✅ 성별 설정 성공 → currentStep: ${response.currentStep}',
      );

      await _storage.write(key: 'onboardingStep', value: response.currentStep);
      state = AsyncValue.data(response);

      return response;
    } catch (e, stack) {
      debugPrint('[OnboardingNotifier] ❌ 성별 설정 실패: $e');
      state = AsyncValue.error(e, stack);
      rethrow; // 에러를 상위로 전파하여 실제 에러 메시지를 UI에서 사용 가능하게 함
    }
  }

  /// 5. 관심사 설정
  ///
  /// **호출 위치**: InterestsPage
  ///
  /// **API**: POST /api/members/onboarding/interests
  ///
  /// **응답**: currentStep = "COMPLETED", onboardingStatus = "COMPLETED"
  ///
  /// **중요**: 이 단계에서 온보딩이 완료되면 Home으로 이동해야 함
  Future<OnboardingResponse?> updateInterests({
    required List<String> interestIds,
  }) async {
    try {
      final accessToken = await ref
          .read(userNotifierProvider.notifier)
          .getAccessToken();
      if (accessToken == null) {
        debugPrint('[OnboardingNotifier] ❌ Access Token 없음');
        return null;
      }

      debugPrint(
        '[OnboardingNotifier] 🎯 관심사 설정 API 호출: ${interestIds.length}개',
      );

      final response = await _apiService.updateInterests(
        accessToken: accessToken,
        interestIds: interestIds,
      );

      debugPrint(
        '[OnboardingNotifier] ✅ 관심사 설정 성공 → currentStep: ${response.currentStep}, status: ${response.onboardingStatus}',
      );

      await _storage.write(key: 'onboardingStep', value: response.currentStep);
      state = AsyncValue.data(response);

      return response;
    } catch (e, stack) {
      debugPrint('[OnboardingNotifier] ❌ 관심사 설정 실패: $e');
      state = AsyncValue.error(e, stack);
      rethrow; // 에러를 상위로 전파하여 실제 에러 메시지를 UI에서 사용 가능하게 함
    }
  }

  // ══════════════════════════════════════════════════════════════════════════
  // 헬퍼 메서드
  // ══════════════════════════════════════════════════════════════════════════

  /// 현재 온보딩 단계 읽기 (Secure Storage)
  ///
  /// **사용 위치**: SplashScreen (앱 재시작 시 복원)
  ///
  /// **반환값**:
  /// - "TERMS", "NAME", "BIRTH_DATE", "GENDER", "INTERESTS", "COMPLETED"
  /// - null: 온보딩 시작 전
  Future<String?> getCurrentStep() async {
    return await _storage.read(key: 'onboardingStep');
  }

  /// 온보딩 완료 여부 확인
  ///
  /// **완료 조건**:
  /// - currentStep == "COMPLETED"
  /// - onboardingStatus == "COMPLETED"
  ///
  /// **중요**: 두 조건이 모두 true일 때만 Home으로 이동 가능
  bool isOnboardingCompleted() {
    final currentState = state.value;
    if (currentState == null) return false;

    return currentState.currentStep == 'COMPLETED' &&
        currentState.onboardingStatus == 'COMPLETED';
  }

  /// 온보딩 상태 초기화 (로그아웃 시 호출)
  ///
  /// **사용 위치**: UserNotifier.clearUser()
  Future<void> reset() async {
    debugPrint('[OnboardingNotifier] 🔄 온보딩 상태 초기화');

    // Secure Storage에서 onboardingStep 삭제
    await _storage.delete(key: 'onboardingStep');

    // Provider 상태 초기화
    state = const AsyncValue.data(null);

    debugPrint('[OnboardingNotifier] ✅ 온보딩 상태 초기화 완료');
  }
}
