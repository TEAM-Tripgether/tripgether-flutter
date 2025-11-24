import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../../features/auth/services/auth_api_service.dart';
import '../services/auth/token_manager.dart';

/// JWT 인증 토큰 자동 주입 Interceptor
///
/// **기능**:
/// 1. 모든 API 요청에 자동으로 JWT Bearer 토큰 추가
/// 2. 401 EXPIRED_ACCESS_TOKEN 에러 발생 시 자동 토큰 재발급
/// 3. 재발급 성공 시 원래 요청 재시도
///
/// **토큰 재발급 흐름**:
/// 1. 401 + EXPIRED_ACCESS_TOKEN 감지
/// 2. Refresh Token으로 재발급 API 호출
/// 3. 새 토큰 저장
/// 4. 원래 요청에 새 토큰 적용하여 재시도
class AuthInterceptor extends Interceptor {
  final TokenManager _tokenManager = TokenManager();
  final String _baseUrl;

  /// 토큰 재발급 중 플래그 (동시 요청 시 중복 재발급 방지)
  bool _isRefreshing = false;

  AuthInterceptor({
    required String baseUrl,
  }) : _baseUrl = baseUrl;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // API 호출 정보 (메서드 + 경로)
    final apiInfo = '${options.method} ${options.path}';

    try {
      // TokenManager에서 JWT 토큰 읽기 (메모리 캐시 우선)
      debugPrint('🔍 [AuthInterceptor] $apiInfo → 토큰 조회 시작');
      final token = await _tokenManager.getAccessToken();

      if (token != null && token.isNotEmpty) {
        // Authorization 헤더에 Bearer 토큰 추가
        options.headers['Authorization'] = 'Bearer $token';
        debugPrint('🔐 [AuthInterceptor] $apiInfo → ✅ JWT 토큰 추가 성공');
        debugPrint('   - 토큰 길이: ${token.length}자');
        debugPrint('   - 토큰: ${token.toString()}');
        debugPrint('   - 엔드포인트: ${options.baseUrl}${options.path}');
      } else {
        debugPrint('⚠️ [AuthInterceptor] $apiInfo → ❌ JWT 토큰 없음');
        debugPrint('   - 결과: ${token == null ? "null" : "빈 문자열"}');
        debugPrint('   - 원인 가능성: 저장 전 API 호출 또는 로그아웃 상태');
      }
    } catch (e) {
      debugPrint('❌ [AuthInterceptor] $apiInfo → 토큰 읽기 실패: $e');
    }

    // 다음 interceptor로 진행
    handler.next(options);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    // API 호출 정보 (메서드 + 경로)
    final apiInfo = '${err.requestOptions.method} ${err.requestOptions.path}';

    // 401 Unauthorized 에러 처리
    if (err.response?.statusCode == 401) {
      final errorCode = err.response?.data?['errorCode'];

      // 🔑 EXPIRED_ACCESS_TOKEN 처리 - 자동 토큰 재발급
      if (errorCode == 'EXPIRED_ACCESS_TOKEN') {
        debugPrint('⚠️ [AuthInterceptor] $apiInfo → 401 - Access Token 만료 감지');

        // 중복 재발급 방지
        if (_isRefreshing) {
          debugPrint('⏳ [AuthInterceptor] $apiInfo → 이미 토큰 재발급 진행 중');
          return handler.next(err);
        }

        _isRefreshing = true;
        debugPrint('🔄 [AuthInterceptor] $apiInfo → 토큰 재발급 시작');

        try {
          // 1. Refresh Token 조회 (TokenManager 사용)
          final refreshToken = await _tokenManager.getRefreshToken();

          if (refreshToken == null || refreshToken.isEmpty) {
            debugPrint('❌ [AuthInterceptor] $apiInfo → Refresh Token 없음 → 재발급 불가');
            _isRefreshing = false;
            return handler.next(err);
          }

          debugPrint('[AuthInterceptor] $apiInfo → 📤 Refresh Token으로 재발급 API 호출 중');

          // 2. 토큰 재발급 API 호출 (AuthApiService의 공통 메서드 사용)
          final authResponse =
              await AuthApiService.reissueTokenWithoutInterceptor(
                refreshToken: refreshToken,
                baseUrl: _baseUrl,
              );

          debugPrint('[AuthInterceptor] $apiInfo → ✅ 토큰 재발급 성공');

          // 3. 새 토큰 저장 (TokenManager 사용 - 메모리 캐시 + Storage)
          await _tokenManager.saveAccessToken(authResponse.accessToken);
          await _tokenManager.saveRefreshToken(authResponse.refreshToken);
          debugPrint('[AuthInterceptor] $apiInfo → ✅ 새 토큰 저장 완료');

          // 4. 원래 요청에 새 토큰 적용
          err.requestOptions.headers['Authorization'] =
              'Bearer ${authResponse.accessToken}';

          // 5. 원래 요청 재시도 (Interceptor 없는 별도 Dio 사용)
          debugPrint('[AuthInterceptor] $apiInfo → 🔁 원래 요청 재시도 중');
          final response = await _retryOriginalRequest(err.requestOptions);

          _isRefreshing = false;
          debugPrint('[AuthInterceptor] $apiInfo → ✅ 요청 재시도 성공');

          // 성공 응답 반환
          return handler.resolve(response);
        } catch (e) {
          // 6. 재발급 실패 시 에러 전달
          debugPrint('[AuthInterceptor] $apiInfo → ❌ 토큰 재발급 실패: $e');
          _isRefreshing = false;

          // 재발급 실패 에러는 ApiLogger가 RefreshTokenException으로 변환
          return handler.next(err);
        }
      } else if (errorCode == 'MISSING_AUTH_TOKEN') {
        // ⚠️ 토큰이 없는 경우 (저장 실패 또는 타이밍 이슈)
        debugPrint(
          '⚠️ [AuthInterceptor] $apiInfo → 401 - MISSING_AUTH_TOKEN (토큰 저장 실패 가능성)',
        );
        // ❌ 삭제하지 않음 (아직 저장 중이거나 타이밍 문제일 수 있음)
      } else if (errorCode == 'INVALID_TOKEN' ||
          errorCode == 'EXPIRED_TOKEN' ||
          errorCode == 'TOKEN_BLACKLISTED') {
        // 🚨 토큰이 만료되거나 유효하지 않거나 블랙리스트 처리된 경우
        debugPrint('🚨 [AuthInterceptor] $apiInfo → 401 - $errorCode → 토큰 삭제');
        await deleteToken();
        debugPrint('🗑️ [AuthInterceptor] $apiInfo → JWT 토큰 삭제 완료 ($errorCode)');
      } else {
        // ⚠️ 알 수 없는 401 에러
        debugPrint('🚨 [AuthInterceptor] $apiInfo → 401 - 알 수 없는 인증 오류: $errorCode');
      }
    }

    // 에러를 상위로 전달
    handler.next(err);
  }

  /// 원래 요청 재시도 (Interceptor 없는 별도 Dio 사용)
  ///
  /// Infinite loop 방지를 위해 AuthInterceptor를 추가하지 않은
  /// 별도의 Dio 인스턴스를 사용하여 원래 요청을 재시도합니다.
  Future<Response> _retryOriginalRequest(RequestOptions options) async {
    final dio = Dio(
      BaseOptions(
        baseUrl: _baseUrl,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
      ),
    );

    // RequestOptions를 Options로 변환
    final response = await dio.request(
      options.path,
      data: options.data,
      queryParameters: options.queryParameters,
      options: Options(
        method: options.method,
        headers: options.headers,
        contentType: options.contentType,
        responseType: options.responseType,
      ),
    );

    return response;
  }

  /// JWT Access Token 저장
  ///
  /// **Deprecated**: TokenManager.saveAccessToken() 사용 권장
  static Future<void> saveToken(String token) async {
    await TokenManager().saveAccessToken(token);
  }

  /// JWT Refresh Token 저장
  ///
  /// **Deprecated**: TokenManager.saveRefreshToken() 사용 권장
  static Future<void> saveRefreshToken(String token) async {
    await TokenManager().saveRefreshToken(token);
  }

  /// JWT 토큰 삭제 (로그아웃 시)
  ///
  /// **Deprecated**: TokenManager.deleteTokens() 사용 권장
  static Future<void> deleteToken() async {
    await TokenManager().deleteTokens();
  }

  /// JWT Access Token 조회
  ///
  /// **Deprecated**: TokenManager.getAccessToken() 사용 권장
  static Future<String?> getToken() async {
    return await TokenManager().getAccessToken();
  }

  /// JWT Refresh Token 조회
  ///
  /// **Deprecated**: TokenManager.getRefreshToken() 사용 권장
  static Future<String?> getRefreshToken() async {
    return await TokenManager().getRefreshToken();
  }
}
