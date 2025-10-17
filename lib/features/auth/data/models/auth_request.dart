import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_request.freezed.dart';
part 'auth_request.g.dart';

/// 인증 API 요청 데이터 모델
///
/// 소셜 로그인, 토큰 재발급, 로그아웃 API 호출 시 사용됩니다.
/// API 명세서: claudedocs/TRIPGETHER_API_SPECIFICATION.md 참고
///
/// **Freezed 자동 생성**:
/// - `copyWith()`: 불변 객체 업데이트
/// - `toJson()`: JSON 직렬화 (null 값 자동 제외)
/// - `fromJson()`: JSON 역직렬화
/// - `==`, `hashCode`: 동등성 비교
/// - `toString()`: 디버그 출력
@freezed
class AuthRequest with _$AuthRequest {
  const factory AuthRequest({
    /// 소셜 로그인 플랫폼 (선택)
    ///
    /// 가능한 값: "GOOGLE", "KAKAO"
    /// 소셜 로그인 API 호출 시 필수
    String? socialPlatform,

    /// 사용자 이메일 (선택)
    ///
    /// 소셜 로그인 API 호출 시 필수
    String? email,

    /// 사용자 닉네임 (선택)
    ///
    /// 소셜 로그인 API 호출 시 필수
    String? nickname,

    /// 프로필 이미지 URL (선택)
    ///
    /// 소셜 로그인 시 선택적으로 전송
    /// Google/Kakao에서 받은 프로필 사진 URL
    String? profileUrl,

    /// 리프레시 토큰 (선택)
    ///
    /// 토큰 재발급 및 로그아웃 API 호출 시 필수
    String? refreshToken,
  }) = _AuthRequest;

  /// 소셜 로그인 요청 생성 팩토리
  ///
  /// POST /api/auth/sign-in
  ///
  /// [socialPlatform]: "GOOGLE" 또는 "KAKAO"
  /// [email]: 사용자 이메일
  /// [nickname]: 사용자 닉네임
  /// [profileUrl]: 프로필 이미지 URL (선택)
  factory AuthRequest.signIn({
    required String socialPlatform,
    required String email,
    required String nickname,
    String? profileUrl,
  }) {
    return AuthRequest(
      socialPlatform: socialPlatform,
      email: email,
      nickname: nickname,
      profileUrl: profileUrl,
    );
  }

  /// 토큰 재발급 요청 생성 팩토리
  ///
  /// POST /api/auth/reissue
  ///
  /// [refreshToken]: 발급받은 Refresh Token
  factory AuthRequest.reissue({
    required String refreshToken,
  }) {
    return AuthRequest(
      refreshToken: refreshToken,
    );
  }

  /// 로그아웃 요청 생성 팩토리
  ///
  /// POST /api/auth/logout
  ///
  /// [refreshToken]: 로그아웃할 Refresh Token
  factory AuthRequest.logout({
    required String refreshToken,
  }) {
    return AuthRequest(
      refreshToken: refreshToken,
    );
  }

  /// JSON 역직렬화
  ///
  /// 주로 테스트나 디버깅 목적으로 사용됩니다.
  /// Freezed가 자동으로 생성한 `_$AuthRequestFromJson()` 함수를 사용합니다.
  factory AuthRequest.fromJson(Map<String, dynamic> json) =>
      _$AuthRequestFromJson(json);
}
