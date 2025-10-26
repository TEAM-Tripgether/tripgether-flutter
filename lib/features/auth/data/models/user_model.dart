import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

/// 사용자 정보 모델
///
/// Google 소셜 로그인을 통해 받은 사용자 정보를 저장하고 관리합니다.
/// Flutter Secure Storage에 JSON 형태로 저장되며, 앱 전역에서 사용됩니다.
///
/// **저장 위치**: Flutter Secure Storage (보안 저장소)
/// **사용 위치**: UserProvider를 통해 전역 상태로 관리
///
/// **Freezed 자동 생성**:
/// - `copyWith()`: 불변 객체 업데이트
/// - `toJson()`, `fromJson()`: JSON 직렬화/역직렬화
/// - `==`, `hashCode`: 동등성 비교
/// - `toString()`: 디버그 출력
@freezed
class User with _$User {
  const factory User({
    /// 사용자 고유 ID (서버에서 발급)
    ///
    /// - 백엔드 API 연동 전: null (로컬에서 Google ID 사용)
    /// - 백엔드 API 연동 후: 서버에서 발급한 UUID
    String? userId,

    /// 이메일 주소 (필수)
    ///
    /// Google 로그인 시 자동으로 받아옵니다.
    required String email,

    /// 닉네임 (필수)
    ///
    /// Google displayName 또는 사용자가 직접 설정한 이름
    required String nickname,

    /// 프로필 이미지 URL (선택)
    ///
    /// Google 로그인 시 photoUrl로 받아오거나, 사용자가 직접 업로드한 이미지 URL
    /// 형식: https://lh3.googleusercontent.com/a/...
    String? profileImageUrl,

    /// 로그인 플랫폼 (선택)
    ///
    /// 가능한 값: "GOOGLE", "KAKAO"
    /// 추후 Kakao 로그인 추가 시 사용
    String? loginPlatform,

    /// 생성일시 (로컬 저장 시간)
    ///
    /// 사용자 정보가 처음 저장된 시간
    required DateTime createdAt,
  }) = _User;

  /// Google 로그인 정보로 User 생성
  ///
  /// Google OAuth 인증 후 받은 사용자 정보로 User 객체를 생성합니다.
  ///
  /// [email]: Google 이메일 주소
  /// [displayName]: Google 계정 이름
  /// [photoUrl]: Google 프로필 사진 URL
  factory User.fromGoogleSignIn({
    required String email,
    required String displayName,
    String? photoUrl,
  }) {
    return User(
      email: email,
      nickname: displayName,
      profileImageUrl: photoUrl,
      loginPlatform: 'GOOGLE',
      createdAt: DateTime.now(),
    );
  }

  /// JSON 역직렬화
  ///
  /// Flutter Secure Storage에서 불러온 JSON 데이터를 User 객체로 변환합니다.
  /// Freezed가 자동으로 생성한 `_$UserFromJson()` 함수를 사용합니다.
  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
}
