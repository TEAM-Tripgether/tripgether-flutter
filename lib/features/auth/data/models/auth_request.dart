import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_request.freezed.dart';
part 'auth_request.g.dart';

/// 인증 API 요청 데이터 모델
///
/// 소셜 로그인, 토큰 재발급, 로그아웃 API 호출 시 사용됩니다.
///
/// **Freezed 자동 생성**:
/// - `copyWith()`: 불변 객체 업데이트
/// - `toJson()`: JSON 직렬화
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

    /// 사용자 이름 (선택)
    ///
    /// 소셜 로그인 API 호출 시 필수
    /// 백엔드 DB의 'name' 컬럼과 매핑됨
    String? name,

    /// 프로필 이미지 URL (선택)
    ///
    /// 소셜 로그인 시 선택적으로 전송
    /// Google/Kakao에서 받은 프로필 사진 URL
    String? profileUrl,

    /// 리프레시 토큰 (선택)
    ///
    /// 토큰 재발급 및 로그아웃 API 호출 시 필수
    String? refreshToken,

    // ═══════════════════════════════════════════════════════════════
    // 🆕 FCM 푸시 알림 필드 (멀티 디바이스 지원)
    // ═══════════════════════════════════════════════════════════════

    /// Firebase Cloud Messaging 토큰 (선택)
    ///
    /// 푸시 알림 발송을 위한 디바이스별 FCM 토큰
    /// - fcmToken, deviceType, deviceId는 **3개 모두 함께 전송** 또는 **모두 생략**
    /// - 일부만 전송 시 백엔드에서 400 Bad Request 반환
    String? fcmToken,

    /// 기기 타입 (선택)
    ///
    /// 가능한 값: "IOS", "ANDROID"
    /// - fcmToken 제공 시 **필수**
    String? deviceType,

    /// 기기 고유 식별자 (선택)
    ///
    /// UUID v4 형식의 디바이스 고유 ID
    /// - fcmToken 제공 시 **필수**
    /// - 한 사용자가 여러 기기(폰, 태블릿)에서 로그인 시 각 기기 식별용
    String? deviceId,
  }) = _AuthRequest;

  /// 소셜 로그인 요청 생성 팩토리
  ///
  /// POST /api/auth/sign-in
  ///
  /// [socialPlatform]: "GOOGLE" 또는 "KAKAO"
  /// [email]: 사용자 이메일
  /// [name]: 사용자 이름 (displayName)
  /// [profileUrl]: 프로필 이미지 URL (선택)
  /// [fcmToken]: FCM 푸시 알림 토큰 (선택)
  /// [deviceType]: 기기 타입 "IOS" 또는 "ANDROID" (fcmToken 제공 시 필수)
  /// [deviceId]: 기기 고유 식별자 UUID (fcmToken 제공 시 필수)
  factory AuthRequest.signIn({
    required String socialPlatform,
    required String email,
    required String name,
    String? profileUrl,
    String? fcmToken,
    String? deviceType,
    String? deviceId,
  }) {
    return AuthRequest(
      socialPlatform: socialPlatform,
      email: email,
      name: name,
      profileUrl: profileUrl,
      fcmToken: fcmToken,
      deviceType: deviceType,
      deviceId: deviceId,
    );
  }

  /// 토큰 재발급 요청 생성 팩토리
  ///
  /// POST /api/auth/reissue
  ///
  /// [refreshToken]: 발급받은 Refresh Token
  factory AuthRequest.reissue({required String refreshToken}) {
    return AuthRequest(refreshToken: refreshToken);
  }

  /// 로그아웃 요청 생성 팩토리
  ///
  /// POST /api/auth/logout
  ///
  /// [refreshToken]: 로그아웃할 Refresh Token
  factory AuthRequest.logout({required String refreshToken}) {
    return AuthRequest(refreshToken: refreshToken);
  }

  /// JSON 역직렬화
  ///
  /// 주로 테스트나 디버깅 목적으로 사용됩니다.
  /// Freezed가 자동으로 생성한 `_$AuthRequestFromJson()` 함수를 사용합니다.
  factory AuthRequest.fromJson(Map<String, dynamic> json) =>
      _$AuthRequestFromJson(json);
}
