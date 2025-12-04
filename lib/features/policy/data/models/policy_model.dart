import 'package:freezed_annotation/freezed_annotation.dart';

part 'policy_model.freezed.dart';
part 'policy_model.g.dart';

/// 약관/정책 데이터 모델
///
/// **JSON 구조**:
/// ```json
/// {
///   "title": "서비스 이용약관",
///   "version": "1.0",
///   "lastUpdated": "2024-01-01",
///   "sections": [
///     { "heading": "제1조 (목적)", "content": "..." }
///   ]
/// }
/// ```
///
/// **사용처**:
/// - 온보딩 약관 동의 페이지
/// - 마이페이지 "정책 & 안전" 섹션
@freezed
class PolicyModel with _$PolicyModel {
  const factory PolicyModel({
    /// 약관 제목 (예: "서비스 이용약관")
    required String title,

    /// 약관 버전 (예: "1.0")
    required String version,

    /// 최종 수정일 (예: "2024-01-01")
    required String lastUpdated,

    /// 약관 섹션 목록
    required List<PolicySection> sections,
  }) = _PolicyModel;

  factory PolicyModel.fromJson(Map<String, dynamic> json) =>
      _$PolicyModelFromJson(json);
}

/// 약관 섹션 (제목 + 내용)
@freezed
class PolicySection with _$PolicySection {
  const factory PolicySection({
    /// 섹션 제목 (예: "제1조 (목적)")
    required String heading,

    /// 섹션 내용
    required String content,
  }) = _PolicySection;

  factory PolicySection.fromJson(Map<String, dynamic> json) =>
      _$PolicySectionFromJson(json);
}

/// 약관 타입 열거형
///
/// **사용 예시**:
/// ```dart
/// context.push('/policy/${PolicyType.termsOfService.name}');
/// ```
enum PolicyType {
  /// 서비스 이용약관
  termsOfService('terms_of_service', '서비스 이용약관'),

  /// 개인정보 처리방침
  privacyPolicy('privacy_policy', '개인정보 처리방침'),

  /// 만 14세 이상 확인
  ageConfirmation('age_confirmation', '만 14세 이상 확인'),

  /// 마케팅 정보 수신 동의
  marketingConsent('marketing_consent', '마케팅 정보 수신 동의');

  const PolicyType(this.fileName, this.displayName);

  /// JSON 파일명 (확장자 제외)
  final String fileName;

  /// 화면에 표시되는 이름
  final String displayName;

  /// 문자열로부터 PolicyType 변환
  ///
  /// [name]이 유효하지 않으면 null 반환
  static PolicyType? fromString(String? name) {
    if (name == null) return null;
    try {
      return PolicyType.values.firstWhere((e) => e.name == name);
    } catch (_) {
      return null;
    }
  }
}
