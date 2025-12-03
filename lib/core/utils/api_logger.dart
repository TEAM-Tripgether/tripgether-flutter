import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../errors/api_error.dart';
import '../errors/refresh_token_exception.dart';

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
  /// **개발 환경 (kDebugMode == true)**:
  /// - 전체 response 데이터 출력 (디버깅용)
  /// - Headers, Body 상세 정보 포함
  ///
  /// **프로덕션 환경 (kReleaseMode)**:
  /// - StatusCode + ApiError 코드/메시지만 출력
  /// - 민감정보 노출 방지
  ///
  /// [e] DioException 객체
  /// [context] 에러 발생 위치 (예: 'AuthApiService.signIn')
  static void logDioError(DioException e, {required String context}) {
    if (kDebugMode) {
      // 개발 환경: 전체 데이터 확인 가능
      _logDebugError(e, context);
    } else {
      // 프로덕션: 최소 정보만
      _logProductionError(e, context);
    }
  }

  /// 개발 환경 상세 로깅 (전체 response 포함)
  static void _logDebugError(DioException e, String context) {
    if (e.response != null) {
      // 서버 응답이 있는 경우
      debugPrint('[$context] ❌ 서버 응답 전체 (Debug):');
      debugPrint("Response Object: '${e.response!.toString()}'");
      debugPrint(
        '  - Status: ${e.response!.statusCode} ${e.response!.statusMessage}',
      );
      debugPrint('  - Data: ${e.response!.data}');
      debugPrint('  - Headers: ${e.response!.headers}');

      // ApiError 파싱
      final apiError = ApiError.fromDioError(e.response!.data);
      debugPrint('  - Error Code: ${apiError.code}');
      debugPrint('  - Error Message: ${apiError.message}');
    } else {
      // 네트워크 에러 (응답 없음)
      debugPrint('[$context] ❌ 네트워크 오류: ${e.message}');
    }
  }

  /// 프로덕션 환경 최소 로깅 (민감정보 제외)
  static void _logProductionError(DioException e, String context) {
    if (e.response != null) {
      final apiError = ApiError.fromDioError(e.response!.data);
      // StatusCode + ApiError만 로깅 (헤더/바디 제외)
      debugPrint(
        '[$context] ❌ API Error: ${e.response!.statusCode} - ${apiError.code}: ${apiError.message}',
      );
    } else {
      // 네트워크 에러 타입만 로깅 (상세 메시지 제외)
      debugPrint('[$context] ❌ Network Error: ${e.type.name}');
    }
  }

  /// 일반 예외 로깅
  ///
  /// **개발 환경**: 상세 예외 스택 트레이스 출력
  /// **프로덕션**: 예외 타입만 로깅
  ///
  /// [e] Exception 객체
  /// [context] 에러 발생 위치
  static void logException(Object e, {required String context}) {
    if (kDebugMode) {
      debugPrint('[$context] ❌ 예외 발생: $e');
    } else {
      debugPrint('[$context] ❌ Exception: ${e.runtimeType}');
    }
  }

  /// API 호출 성공 로깅 (선택 사항)
  ///
  /// **개발 환경에서만 로깅**
  ///
  /// [context] API 호출 위치
  /// [message] 추가 메시지
  static void logSuccess(String context, {String? message}) {
    if (kDebugMode) {
      debugPrint('[$context] ✅ ${message ?? '성공'}');
    }
  }

  /// API 호출 시작 로깅 (선택 사항)
  ///
  /// **개발 환경에서만 로깅**
  ///
  /// [context] API 호출 위치
  /// [message] 추가 메시지
  static void logStart(String context, {String? message}) {
    if (kDebugMode) {
      debugPrint('[$context] 🔄 ${message ?? '시작'}');
    }
  }

  /// Refresh Token 관련 에러 코드인지 확인 (강제 로그아웃 필요)
  ///
  /// **주의**: EXPIRED_ACCESS_TOKEN은 여기에 포함하지 않음!
  /// - Access Token 만료 → AuthInterceptor에서 자동 재발급 처리
  /// - Refresh Token 만료/무효 → 재발급 불가능 → 로그아웃 필요
  ///
  /// **에러 코드**:
  /// - REFRESH_TOKEN_NOT_FOUND: 리프레시 토큰을 찾을 수 없습니다.
  /// - INVALID_REFRESH_TOKEN: 유효하지 않은 리프레시 토큰입니다.
  /// - EXPIRED_REFRESH_TOKEN: 만료된 리프레시 토큰입니다.
  /// - REFRESH_TOKEN_MISMATCH: Redis에 저장된 리프레시 토큰과 일치하지 않습니다.
  /// - MEMBER_NOT_FOUND: 회원 정보를 찾을 수 없습니다.
  /// - TOKEN_BLACKLISTED: 블랙리스트 처리된 토큰입니다. (회원 탈퇴 또는 계정 비활성화)
  /// - MISSING_AUTH_TOKEN: 인증 토큰이 없습니다. (토큰 저장 실패 또는 삭제된 경우)
  static bool _isRefreshTokenError(String? errorCode) {
    if (errorCode == null) return false;

    return errorCode == 'REFRESH_TOKEN_NOT_FOUND' ||
        errorCode == 'INVALID_REFRESH_TOKEN' ||
        errorCode == 'EXPIRED_REFRESH_TOKEN' ||
        errorCode == 'REFRESH_TOKEN_MISMATCH' ||
        errorCode == 'MEMBER_NOT_FOUND' ||
        errorCode == 'TOKEN_BLACKLISTED' ||
        errorCode == 'MISSING_AUTH_TOKEN';
  }

  /// DioException을 처리하고 적절한 Exception을 throw
  ///
  /// **기능**:
  /// - 타임아웃 에러 별도 메시지
  /// - Refresh Token 에러 특수 처리 (RefreshTokenException)
  /// - ApiError 기반 에러 메시지 추출 (백엔드 response message 사용)
  /// - 네트워크 에러 분류 처리
  ///
  /// **에러 메시지 흐름**:
  /// 1. Service Layer: throwFromDioError → Exception(apiError.message)
  /// 2. Notifier Layer: rethrow
  /// 3. Page Layer: handleError 호출
  /// 4. Error Handler: AppSnackBar.showError(context, message)
  ///
  /// **사용 예시**:
  /// ```dart
  /// try {
  ///   final response = await dio.get('/api/data');
  ///   return response.data;
  /// } on DioException catch (e) {
  ///   ApiLogger.throwFromDioError(e, context: 'ContentDataSource.getData');
  /// }
  /// ```
  ///
  /// [e] DioException 객체
  /// [context] 에러 발생 위치 (예: 'AuthApiService.signIn')
  static Never throwFromDioError(DioException e, {required String context}) {
    // 1. debugPrint 로깅 (개발자용)
    logDioError(e, context: context);

    // 2. 타임아웃 에러 처리
    if (e.type == DioExceptionType.connectionTimeout) {
      throw Exception('연결 시간 초과: 서버에 연결할 수 없습니다.');
    }
    if (e.type == DioExceptionType.receiveTimeout) {
      throw Exception('응답 시간 초과: 서버 응답이 없습니다.');
    }

    // 3. 서버 응답이 있는 경우 (백엔드 메시지 사용)
    if (e.response != null) {
      final apiError = ApiError.fromDioError(e.response!.data);

      // 3-1. Refresh Token 에러 특수 처리
      if (_isRefreshTokenError(apiError.code)) {
        throw RefreshTokenException(apiError.message, apiError.code);
      }

      // 3-2. 일반 에러
      throw Exception(apiError.message);
    }

    // 4. 네트워크 에러 (응답 없음)
    throw Exception('네트워크 연결을 확인해주세요.');
  }
}
