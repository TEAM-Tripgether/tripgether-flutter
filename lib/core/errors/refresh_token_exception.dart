/// Refresh Token 관련 에러 전용 예외 클래스
///
/// **용도**:
/// - Access Token 만료 또는 Refresh Token 재발급 실패 시 발생
/// - UI에서 자동 로그아웃 처리를 위한 마커 역할
///
/// **에러 코드**:
/// - EXPIRED_ACCESS_TOKEN: 액세스 토큰이 만료되었습니다.
/// - REFRESH_TOKEN_NOT_FOUND: 리프레시 토큰을 찾을 수 없습니다.
/// - INVALID_REFRESH_TOKEN: 유효하지 않은 리프레시 토큰입니다.
/// - EXPIRED_REFRESH_TOKEN: 만료된 리프레시 토큰입니다.
/// - MEMBER_NOT_FOUND: 회원 정보를 찾을 수 없습니다.
class RefreshTokenException implements Exception {
  final String message;
  final String? errorCode;

  RefreshTokenException(this.message, this.errorCode);

  @override
  String toString() => message;
}
