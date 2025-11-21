import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../errors/api_error.dart';

/// API 로깅 유틸리티
///
/// **기능**:
/// - DioException 에러 로깅 통일화
/// - 서버 응답 상세 정보 출력
/// - ApiError 기반 에러 메시지 추출
///
/// **사용 예시**:
/// ```dart
/// try {
///   final response = await dio.get('/api/data');
///   return response.data;
/// } on DioException catch (e) {
///   ApiLogger.logDioError(e, context: 'ContentDataSource.getContents');
///   rethrow;
/// }
/// ```
class ApiLogger {
  /// DioException 에러 로깅
  ///
  /// **출력 정보**:
  /// - 에러 발생 위치 (context)
  /// - 서버 응답 전체 (statusCode, statusMessage, data, headers)
  /// - ApiError 파싱 결과 (code, message)
  /// - 네트워크 에러 메시지
  ///
  /// [e] DioException 객체
  /// [context] 에러 발생 위치 (예: 'AuthApiService.signIn')
  static void logDioError(DioException e, {required String context}) {
    if (e.response != null) {
      // 서버 응답이 있는 경우
      debugPrint('[$context] ❌ 서버 응답 전체:');
      debugPrint("Response body : '${e.response!.toString()}'");
      debugPrint('  - Status Code: ${e.response!.statusCode}');
      debugPrint('  - Status Message: ${e.response!.statusMessage}');
      debugPrint('  - Response Data: ${e.response!.data}');
      debugPrint('  - Headers: ${e.response!.headers}');

      // ApiError 파싱
      final apiError = ApiError.fromDioError(e.response!.data);
      debugPrint('[$context] ❌ 에러 코드: ${apiError.code}');
      debugPrint('[$context] ❌ 에러 메시지: ${apiError.message}');
    } else {
      // 네트워크 에러 (응답 없음)
      debugPrint('[$context] ❌ 네트워크 오류: ${e.message}');
    }
  }

  /// 일반 예외 로깅
  ///
  /// [e] Exception 객체
  /// [context] 에러 발생 위치
  static void logException(Object e, {required String context}) {
    debugPrint('[$context] ❌ 예외 발생: $e');
  }

  /// API 호출 성공 로깅 (선택 사항)
  ///
  /// [context] API 호출 위치
  /// [message] 추가 메시지
  static void logSuccess(String context, {String? message}) {
    debugPrint('[$context] ✅ ${message ?? '성공'}');
  }

  /// API 호출 시작 로깅 (선택 사항)
  ///
  /// [context] API 호출 위치
  /// [message] 추가 메시지
  static void logStart(String context, {String? message}) {
    debugPrint('[$context] 🔄 ${message ?? '시작'}');
  }
}
