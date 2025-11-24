import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_response.freezed.dart';
part 'auth_response.g.dart';

/// 인증 API 응답 데이터 모델
///
/// 소셜 로그인 및 토큰 재발급 API 응답 시 사용됩니다.
///
/// **Freezed 자동 생성**:
/// - `copyWith()`: 불변 객체 업데이트 (토큰 재발급 시 유용)
/// - `toJson()`, `fromJson()`: JSON 직렬화/역직렬화
/// - `==`, `hashCode`: 동등성 비교
/// - `toString()`: 디버그 출력
@freezed
class AuthResponse with _$AuthResponse {
  const AuthResponse._();

  const factory AuthResponse({
    /// JWT Access Token
    ///
    /// 유효기간: 1시간
    /// API 요청 시 Authorization 헤더에 포함
    /// 형식: Bearer {accessToken}
    required String accessToken,

    /// JWT Refresh Token
    ///
    /// 유효기간: 7일
    /// Access Token 만료 시 재발급에 사용
    required String refreshToken,

    /// 최초 로그인 여부
    ///
    /// - true: 회원가입 (최초 로그인)
    /// - false: 기존 회원 로그인
    ///
    /// **토큰 재발급 API (/api/auth/reissue) 응답에는 포함되지 않을 수 있음**
    /// - 재발급 시에는 기존 회원이므로 항상 false
    @Default(false) bool isFirstLogin,

    /// 온보딩 필요 여부
    ///
    /// - true: 온보딩이 완료되지 않아 온보딩 화면으로 이동 필요
    /// - false: 온보딩 완료, 홈 화면으로 이동
    ///
    /// **토큰 재발급 API (/api/auth/reissue) 응답에는 포함되지 않음**
    /// - 재발급 시에는 이미 온보딩 완료 상태이므로 항상 false
    @Default(false) bool requiresOnboarding,

    /// 현재 온보딩 단계
    ///
    /// **가능한 값**:
    /// - "TERMS": 약관 동의 필요
    /// - "NAME": 이름 입력 필요
    /// - "BIRTH_DATE": 생년월일 입력 필요
    /// - "GENDER": 성별 선택 필요
    /// - "INTERESTS": 관심사 선택 필요
    /// - "COMPLETED": 온보딩 완료
    ///
    /// **토큰 재발급 API (/api/auth/reissue) 응답에는 포함되지 않음**
    /// - 재발급 시에는 항상 "COMPLETED"
    @Default('COMPLETED') String onboardingStep,
  }) = _AuthResponse;

  /// Access Token이 유효한지 확인 (간단한 검증)
  ///
  /// 실제 검증은 서버에서 수행되며, 이 메서드는 기본적인 형식 검증만 수행합니다.
  /// JWT 형식: {header}.{payload}.{signature}
  bool get isAccessTokenValid {
    if (accessToken.isEmpty) return false;
    final parts = accessToken.split('.');
    return parts.length == 3; // JWT는 3개의 부분으로 구성
  }

  /// Refresh Token이 유효한지 확인 (간단한 검증)
  bool get isRefreshTokenValid {
    if (refreshToken.isEmpty) return false;
    final parts = refreshToken.split('.');
    return parts.length == 3; // JWT는 3개의 부분으로 구성
  }

  /// JSON 역직렬화
  ///
  /// API 응답 데이터를 AuthResponse 객체로 변환합니다.
  ///
  /// **예시 JSON**:
  /// ```json
  /// {
  ///   "accessToken": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  ///   "refreshToken": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  ///   "isFirstLogin": true
  /// }
  /// ```
  factory AuthResponse.fromJson(Map<String, dynamic> json) =>
      _$AuthResponseFromJson(json);
}
