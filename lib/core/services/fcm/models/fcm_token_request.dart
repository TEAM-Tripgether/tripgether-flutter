import 'package:freezed_annotation/freezed_annotation.dart';

part 'fcm_token_request.freezed.dart';
part 'fcm_token_request.g.dart';

/// FCM 토큰 등록/업데이트 요청 모델
///
/// 백엔드 API에 FCM 토큰과 기기 정보를 전송할 때 사용합니다.
///
/// POST /api/members/fcm-token
/// {
///   "fcmToken": "eY-nz7lFR0...",
///   "deviceType": "IOS",
///   "deviceName": "iPhone 17 Pro"
/// }
@freezed
class FcmTokenRequest with _$FcmTokenRequest {
  const factory FcmTokenRequest({
    /// FCM 토큰 (Firebase에서 발급한 기기별 고유 토큰)
    required String fcmToken,

    /// 기기 타입 ("IOS" 또는 "ANDROID")
    required String deviceType,

    /// 기기 이름 (사용자가 설정한 기기명 또는 제조사+모델명)
    /// - iOS: "Elipair's iPhone", "iPad Pro" 등
    /// - Android: "Samsung SM-S911N", "Google Pixel 7" 등
    required String deviceName,
  }) = _FcmTokenRequest;

  /// JSON으로부터 FcmTokenRequest 생성
  factory FcmTokenRequest.fromJson(Map<String, dynamic> json) =>
      _$FcmTokenRequestFromJson(json);
}
