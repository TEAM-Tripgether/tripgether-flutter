/// API 에러 처리를 위한 간단한 클래스
///
/// 백엔드에서 제공하는 에러 코드와 메시지를 파싱하여 사용
class ApiError {
  final String? code;
  final String message;
  final int? statusCode;

  ApiError({this.code, required this.message, this.statusCode});

  /// DioException의 response에서 ApiError 생성
  factory ApiError.fromDioError(dynamic error) {
    if (error == null) {
      return ApiError(message: '알 수 없는 오류가 발생했습니다.');
    }

    // DioException의 response.data에서 에러 정보 추출
    if (error is Map<String, dynamic>) {
      return ApiError(
        code: error['code'] as String?,
        message: error['message'] as String? ?? '서버 오류가 발생했습니다.',
        statusCode: error['statusCode'] as int?,
      );
    }

    // 기타 에러 케이스
    return ApiError(message: error.toString());
  }

  /// 에러 코드별 특별한 처리가 필요한지 확인
  bool get isTokenError =>
      code == 'INVALID_TOKEN' ||
      code == 'EXPIRED_TOKEN' ||
      code == 'REFRESH_TOKEN_NOT_FOUND' ||
      code == 'INVALID_REFRESH_TOKEN' ||
      code == 'EXPIRED_REFRESH_TOKEN';

  bool get isAuthError =>
      isTokenError ||
      code == 'UNAUTHORIZED' ||
      code == 'INVALID_SOCIAL_TOKEN' ||
      code == 'SOCIAL_AUTH_FAILED';

  bool get isMemberError =>
      code == 'MEMBER_NOT_FOUND' ||
      code == 'EMAIL_ALREADY_EXISTS' ||
      code == 'NAME_ALREADY_EXISTS' ||
      code == 'MEMBER_TERMS_REQUIRED_NOT_AGREED';

  bool get isValidationError => code == 'INVALID_INPUT_VALUE';

  bool get isServerError =>
      code == 'INTERNAL_SERVER_ERROR' || statusCode == 500;

  @override
  String toString() => message;
}
