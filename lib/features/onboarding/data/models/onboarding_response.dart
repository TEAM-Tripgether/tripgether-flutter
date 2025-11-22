import 'package:freezed_annotation/freezed_annotation.dart';

part 'onboarding_response.freezed.dart';
part 'onboarding_response.g.dart';

/// 온보딩 API 응답 모델
///
/// **백엔드 응답 구조**:
/// ```json
/// {
///   "currentStep": "NAME",
///   "onboardingStatus": "IN_PROGRESS",
///   "member": { MemberDto }
/// }
/// ```
///
/// **currentStep 의미**: "다음에 수행할 단계"
/// - 백엔드는 방금 완료한 작업을 반영한 후, 다음 단계를 알려줌
/// - 예: POST /terms 완료 → response.currentStep = "NAME"
///
/// **라우팅 로직**:
/// ```dart
/// if (currentStep == "COMPLETED" && onboardingStatus == "COMPLETED") {
///   // 온보딩 완료 → Home으로 이동
/// } else {
///   // currentStep에 따라 해당 페이지로 이동
/// }
/// ```
@freezed
class OnboardingResponse with _$OnboardingResponse {
  const factory OnboardingResponse({
    /// 다음 단계 (Next Step to Perform)
    ///
    /// **가능한 값**:
    /// - "TERMS": 약관 동의 필요
    /// - "NAME": 이름 입력 필요
    /// - "BIRTH_DATE": 생년월일 입력 필요
    /// - "GENDER": 성별 선택 필요
    /// - "INTERESTS": 관심사 선택 필요
    /// - "COMPLETED": 온보딩 완료
    ///
    /// **주의**: 이것은 "현재 단계"가 아니라 "다음에 할 단계"입니다!
    required String currentStep,

    /// 전체 온보딩 진행 상태
    ///
    /// **가능한 값**:
    /// - "NOT_STARTED": 아직 시작 안 함
    /// - "IN_PROGRESS": 진행 중
    /// - "COMPLETED": 완료됨
    required String onboardingStatus,

    /// 업데이트된 회원 정보
    ///
    /// API 호출 후 업데이트된 최신 회원 정보가 포함됩니다.
    required MemberDto member,
  }) = _OnboardingResponse;

  /// JSON 역직렬화
  ///
  /// 백엔드 API 응답 JSON을 OnboardingResponse 객체로 변환합니다.
  factory OnboardingResponse.fromJson(Map<String, dynamic> json) =>
      _$OnboardingResponseFromJson(json);
}

/// 회원 정보 DTO (백엔드 MemberDto 구조)
///
/// **백엔드 MemberDto 필드**:
/// - id: 회원 고유 ID (UUID)
/// - email: 이메일 주소
/// - name: 이름/닉네임
/// - onboardingStatus: 온보딩 상태
/// - isServiceTermsAndPrivacyAgreed: 필수 약관 동의
/// - isMarketingAgreed: 마케팅 동의 (선택)
/// - birthDate: 생년월일 (nullable)
/// - gender: 성별 (nullable)
///
/// **사용 목적**:
/// 1. API 응답에서 최신 회원 정보 파싱
/// 2. User 모델과 동기화 (UserNotifier.updateUser)
@freezed
class MemberDto with _$MemberDto {
  const factory MemberDto({
    /// 회원 고유 ID (UUID)
    required String id,

    /// 이메일 주소
    required String email,

    /// 이름/닉네임
    required String name,

    /// 온보딩 상태
    ///
    /// **가능한 값**:
    /// - "NOT_STARTED"
    /// - "IN_PROGRESS"
    /// - "COMPLETED"
    required String onboardingStatus,

    /// 필수 약관 동의 여부 (서비스 이용약관 + 개인정보 처리방침)
    required bool isServiceTermsAndPrivacyAgreed,

    /// 마케팅 동의 여부 (선택 사항)
    required bool isMarketingAgreed,

    /// 생년월일 (nullable)
    ///
    /// **형식**: YYYY-MM-DD (예: 1990-01-01)
    String? birthDate,

    /// 성별 (nullable)
    ///
    /// **가능한 값**:
    /// - "MALE": 남성
    /// - "FEMALE": 여성
    /// - null: 선택 안 함
    String? gender,
  }) = _MemberDto;

  /// JSON 역직렬화
  ///
  /// 백엔드 API 응답 JSON을 MemberDto 객체로 변환합니다.
  factory MemberDto.fromJson(Map<String, dynamic> json) =>
      _$MemberDtoFromJson(json);
}
