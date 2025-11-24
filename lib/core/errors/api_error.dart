/// API 에러 처리를 위한 간단한 클래스
///
/// 백엔드에서 제공하는 에러 코드와 메시지를 그대로 사용
class ApiError {
  final String? code;
  final String message;

  ApiError({this.code, required this.message});

  /// DioException의 response에서 ApiError 생성
  ///
  /// 백엔드 응답 형식: {"errorCode": "EXPIRED_ACCESS_TOKEN", "message": "..."}
  factory ApiError.fromDioError(dynamic error) {
    if (error == null) {
      return ApiError(message: '알 수 없는 오류가 발생했습니다.');
    }

    // DioException의 response.data에서 에러 정보 추출
    if (error is Map<String, dynamic>) {
      return ApiError(
        code: error['errorCode'] as String?,
        message: error['message'] as String? ?? '서버 오류가 발생했습니다.',
      );
    }

    // 기타 에러 케이스
    return ApiError(message: error.toString());
  }

  @override
  String toString() => message;
}
