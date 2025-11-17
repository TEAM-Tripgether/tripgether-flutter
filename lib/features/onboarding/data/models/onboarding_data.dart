import 'package:freezed_annotation/freezed_annotation.dart';

part 'onboarding_data.freezed.dart';
part 'onboarding_data.g.dart';

/// 온보딩 과정에서 수집하는 사용자 데이터 모델
///
/// **수집 데이터**:
/// - 닉네임 (필수): 2-10자, 다른 사용자에게 표시됨
/// - 성별 (선택): MALE, FEMALE, NONE (미선택)
/// - 생년월일 (선택): 연령별 콘텐츠 추천용
/// - 관심사 (선택): 3-10개, 맞춤 추천용
///
/// **사용 목적**:
/// 1. 온보딩 페이지 간 데이터 전달
/// 2. welcome_page에서 개인화된 환영 메시지 표시
/// 3. 백엔드 API 연동 시 한 번에 전송
///
/// **API 연동 예시**:
/// ```dart
/// final onboardingData = ref.read(onboardingProvider);
/// await authApi.updateUserProfile(onboardingData.toJson());
/// ```
@freezed
class OnboardingData with _$OnboardingData {
  // Freezed에서 extension을 사용하려면 const가 아닌 factory를 사용해야 합니다
  const OnboardingData._();

  const factory OnboardingData({
    /// 서비스 이용약관 동의 (필수)
    @Default(false) bool termsOfService,

    /// 개인정보 처리방침 동의 (필수)
    @Default(false) bool privacyPolicy,

    /// 만 14세 이상 확인 (필수)
    @Default(false) bool ageConfirmation,

    /// 마케팅 정보 수신 동의 (선택)
    @Default(false) bool marketingConsent,

    /// 닉네임 (필수, 2-10자)
    ///
    /// **검증 규칙**:
    /// - 최소 2자, 최대 10자
    /// - 비속어/광고 문구 제한 (서버에서 검증)
    @Default('') String nickname,

    /// 성별 (선택)
    ///
    /// **선택지**:
    /// - 'MALE': 남성
    /// - 'FEMALE': 여성
    /// - 'NONE': 선택 안 함 (기본값)
    @Default('NONE') String gender,

    /// 생년월일 (선택)
    ///
    /// **형식**: YYYY-MM-DD (예: 1990-01-01)
    /// **용도**: 연령별 콘텐츠 설정 및 추천
    /// **주의**: 다른 유저에게 노출되지 않음
    String? birthdate,

    /// 관심사 목록 (선택, 3-10개 권장)
    ///
    /// **선택 가능한 카테고리**:
    /// - 액티비티: 수영, 등산, 서핑 등
    /// - 음식: 맛집 탐방, 디저트, 비건 등
    /// - 문화: 미술관, 음악, 역사 등
    /// - 기타: 쇼핑, 사진, 힐링 등
    ///
    /// **검증 규칙**:
    /// - 최소 3개 권장 (정확도 향상)
    /// - 최대 10개
    @Default([]) List<String> interests,
  }) = _OnboardingData;

  /// JSON 직렬화 (백엔드 API 전송용)
  ///
  /// **사용 예시**:
  /// ```dart
  /// final json = onboardingData.toJson();
  /// await dio.post('/api/user/onboarding', data: json);
  /// ```
  factory OnboardingData.fromJson(Map<String, dynamic> json) =>
      _$OnboardingDataFromJson(json);
}

/// 온보딩 데이터 검증 확장 메서드
///
/// **사용 목적**:
/// - 각 페이지에서 입력 데이터 유효성 검증
/// - 온보딩 완료 버튼 활성화 조건 판단
extension OnboardingDataValidation on OnboardingData {
  /// 약관 동의 유효성 검증
  ///
  /// **검증 규칙**: 필수 약관 3개 모두 동의해야 함
  /// - 서비스 이용약관
  /// - 개인정보 처리방침
  /// - 만 14세 이상 확인
  ///
  /// Returns: true if 필수 약관 모두 동의
  bool get isTermsValid {
    return termsOfService && privacyPolicy && ageConfirmation;
  }

  /// 닉네임 유효성 검증
  ///
  /// **검증 규칙**: 2-10자
  ///
  /// Returns: true if 유효한 닉네임
  bool get isNicknameValid {
    return nickname.length >= 2 && nickname.length <= 10;
  }

  /// 관심사 유효성 검증
  ///
  /// **검증 규칙**: 3-10개
  ///
  /// Returns: true if 유효한 관심사 개수
  bool get isInterestsValid {
    return interests.length >= 3 && interests.length <= 10;
  }

  /// 온보딩 완료 가능 여부 (필수 항목 검증)
  ///
  /// **필수 항목**:
  /// - 약관 동의: 필수 약관 3개 동의 (필수)
  /// - 닉네임: 2-10자 (필수)
  /// - 관심사: 3-10개 (필수)
  ///
  /// **선택 항목**:
  /// - 성별: 선택 안 해도 완료 가능
  /// - 생년월일: 입력 안 해도 완료 가능
  /// - 마케팅 동의: 선택 사항
  ///
  /// Returns: true if 필수 항목이 모두 유효
  bool get canComplete {
    return isTermsValid && isNicknameValid && isInterestsValid;
  }

  /// 현재 완료된 단계 개수 (진행률 계산용)
  ///
  /// Returns: 0-5 (약관, 닉네임, 성별, 생년월일, 관심사)
  int get completedSteps {
    int count = 0;
    if (isTermsValid) count++;
    if (isNicknameValid) count++;
    if (gender != 'NONE') count++;
    if (birthdate != null) count++;
    if (isInterestsValid) count++;
    return count;
  }

  /// 진행률 퍼센트 (0-100)
  ///
  /// Returns: 0-100 (완료된 단계 / 전체 단계 * 100)
  double get progressPercent {
    return (completedSteps / 5 * 100).roundToDouble();
  }
}
