import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:tripgether/core/errors/api_error.dart';
import 'package:tripgether/features/auth/data/models/auth_request.dart';
import 'package:tripgether/features/auth/data/models/auth_response.dart';

/// 인증 API 서비스
///
/// Google 소셜 로그인 후 백엔드 API와 통신하여 JWT 토큰을 발급받습니다.
/// Mock/Real API를 Boolean 플래그로 전환할 수 있습니다.
///
/// **Mock 모드**: 백엔드 없이 테스트 가능 (Google 로그인 → Mock JWT → 프로필 표시)
/// **Real 모드**: 실제 백엔드 API 연동 (향후 백엔드 완성 시 사용)
class AuthApiService {
  // ════════════════════════════════════════════════════════════════════════
  // Mock/Real API 전환 플래그
  // ════════════════════════════════════════════════════════════════════════

  /// Mock API 사용 여부
  ///
  /// **우선순위**:
  /// 1. launch.json의 --dart-define (VS Code 디버그 설정)
  /// 2. .env 파일의 USE_MOCK_API
  /// 3. 기본값 true (Mock 모드)
  static bool get _useMockData {
    // 1순위: dart-define (launch.json에서 주입)
    const dartDefine = String.fromEnvironment('USE_MOCK_API');
    if (dartDefine.isNotEmpty) {
      return dartDefine.toLowerCase() == 'true';
    }

    // 2순위: .env 파일
    final envValue = dotenv.env['USE_MOCK_API'];
    if (envValue != null) {
      return envValue.toLowerCase() == 'true';
    }

    // 3순위: 기본값 (Mock 모드)
    return true;
  }

  /// 백엔드 API Base URL
  ///
  /// **우선순위**:
  /// 1. launch.json의 --dart-define
  /// 2. .env 파일의 API_BASE_URL
  /// 3. 기본값 https://api.tripgether.suhsaechan.kr
  static String get _baseUrl {
    // 1순위: dart-define
    const dartDefine = String.fromEnvironment('API_BASE_URL');
    if (dartDefine.isNotEmpty) {
      return dartDefine;
    }

    // 2순위: .env 파일
    final envValue = dotenv.env['API_BASE_URL'];
    if (envValue != null) {
      return envValue;
    }

    // 3순위: 기본값
    return 'https://api.tripgether.suhsaechan.kr';
  }

  /// API 요청 타임아웃 (밀리초)
  ///
  /// **우선순위**:
  /// 1. launch.json의 --dart-define
  /// 2. .env 파일의 API_TIMEOUT
  /// 3. 기본값 10000ms (10초)
  static int get _timeout {
    // 1순위: dart-define
    const dartDefine = String.fromEnvironment('API_TIMEOUT');
    if (dartDefine.isNotEmpty) {
      return int.tryParse(dartDefine) ?? 10000;
    }

    // 2순위: .env 파일
    final envValue = dotenv.env['API_TIMEOUT'];
    if (envValue != null) {
      return int.tryParse(envValue) ?? 10000;
    }

    // 3순위: 기본값
    return 10000;
  }

  /// Flutter Secure Storage 인스턴스
  /// Access Token 읽기용 (로그아웃 API에서 Authorization 헤더에 필요)
  static const FlutterSecureStorage _storage = FlutterSecureStorage();

  /// Access Token 저장 키
  /// UserNotifier와 동일한 키 사용
  static const String _accessTokenKey = 'access_token';

  // ════════════════════════════════════════════════════════════════════════
  // Public API Methods
  // ════════════════════════════════════════════════════════════════════════

  /// 소셜 로그인 API
  ///
  /// Google OAuth 인증 후 백엔드에 사용자 정보를 전송하여 JWT 토큰을 발급받습니다.
  ///
  /// **API 명세**:
  /// - Method: POST
  /// - Path: /auth/sign-in
  /// - Body: AuthRequest (socialPlatform, email, nickname, profileUrl)
  ///
  /// **흐름**:
  /// 1. Google OAuth 인증 완료
  /// 2. 사용자 정보를 백엔드에 전송
  /// 3. 백엔드에서 JWT Access Token + Refresh Token 발급
  /// 4. isFirstLogin 플래그 반환 (최초 로그인 여부)
  ///
  /// [request] Google 로그인 정보가 포함된 요청 객체
  ///
  /// Returns: AuthResponse (accessToken, refreshToken, isFirstLogin)
  /// Throws: Exception - API 호출 실패 시
  Future<AuthResponse> signIn(AuthRequest request) async {
    debugPrint('[AuthApiService] 🔐 소셜 로그인 API 호출');
    debugPrint('[AuthApiService] Mode: ${_useMockData ? "MOCK" : "REAL"}');

    try {
      if (_useMockData) {
        return await _mockSignIn(request);
      } else {
        return await _realSignIn(request);
      }
    } catch (e) {
      debugPrint('[AuthApiService] ❌ 로그인 실패: $e');
      rethrow;
    }
  }

  /// 토큰 재발급 API
  ///
  /// Access Token 만료 시 Refresh Token으로 새로운 토큰을 발급받습니다.
  ///
  /// **API 명세**:
  /// - Method: POST
  /// - Path: /auth/reissue
  /// - Body: AuthRequest (refreshToken)
  ///
  /// **사용 시나리오**:
  /// - API 호출 시 401 Unauthorized 에러 발생
  /// - Access Token이 만료되었다고 판단
  /// - 이 메서드로 새로운 Access Token 발급
  /// - 실패한 API 재호출
  ///
  /// [request] Refresh Token이 포함된 요청 객체
  ///
  /// Returns: AuthResponse (새로운 accessToken, refreshToken)
  /// Throws: Exception - 재발급 실패 시 (Refresh Token 만료 등)
  Future<AuthResponse> reissueToken(AuthRequest request) async {
    debugPrint('[AuthApiService] 🔄 토큰 재발급 API 호출');
    debugPrint('[AuthApiService] Mode: ${_useMockData ? "MOCK" : "REAL"}');

    try {
      if (_useMockData) {
        return await _mockReissueToken(request);
      } else {
        return await _realReissueToken(request);
      }
    } catch (e) {
      debugPrint('[AuthApiService] ❌ 토큰 재발급 실패: $e');
      rethrow;
    }
  }

  /// 로그아웃 API
  ///
  /// 백엔드에 로그아웃 요청을 보내 Refresh Token을 무효화합니다.
  ///
  /// **API 명세**:
  /// - Method: POST
  /// - Path: /auth/logout
  /// - Body: AuthRequest (refreshToken)
  ///
  /// **주의사항**:
  /// - API 호출 실패 시에도 로컬 토큰은 삭제해야 함
  /// - 네트워크 오류로 인한 실패는 무시 가능 (토큰은 이미 로컬에서 삭제됨)
  ///
  /// [request] Refresh Token이 포함된 요청 객체
  ///
  /// Returns: true (성공), false (실패)
  Future<bool> logout(AuthRequest request) async {
    debugPrint('[AuthApiService] 👋 로그아웃 API 호출');
    debugPrint('[AuthApiService] Mode: ${_useMockData ? "MOCK" : "REAL"}');

    try {
      if (_useMockData) {
        return await _mockLogout(request);
      } else {
        return await _realLogout(request);
      }
    } catch (e) {
      debugPrint('[AuthApiService] ⚠️ 로그아웃 API 실패 (로컬 토큰은 삭제됨): $e');
      // 로그아웃 API 실패해도 true 반환 (로컬 토큰 삭제가 중요)
      return true;
    }
  }

  // ════════════════════════════════════════════════════════════════════════
  // Mock API Implementations (백엔드 없이 테스트용)
  // ════════════════════════════════════════════════════════════════════════

  /// Mock 소셜 로그인
  ///
  /// 실제 백엔드 없이 Google 로그인 후 프로필 표시를 테스트할 수 있습니다.
  /// 1초 지연 후 Mock JWT 토큰을 반환합니다.
  Future<AuthResponse> _mockSignIn(AuthRequest request) async {
    debugPrint('[AuthApiService - Mock] ✅ Mock 로그인 시작');
    debugPrint('[AuthApiService - Mock] 요청 데이터: ${request.toJson()}');

    // 네트워크 호출 시뮬레이션 (1초 지연)
    await Future.delayed(const Duration(seconds: 1));

    // Mock JWT 토큰 생성
    // (실제 JWT는 아니지만 3개 파트로 구성되어 있어 형식 검증 통과)
    final mockAccessToken =
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.mock_access_token_payload.mock_signature';
    final mockRefreshToken =
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.mock_refresh_token_payload.mock_signature';

    // 최초 로그인 여부 (email 기반 랜덤 결정)
    // 실제로는 백엔드에서 DB 조회 후 결정
    final isFirstLogin = request.email?.contains('first') ?? false;

    // 온보딩 필요 여부와 현재 단계 (Mock 데이터)
    // 실제로는 백엔드 DB에서 회원의 onboardingStatus 조회
    final requiresOnboarding = isFirstLogin; // 첫 로그인이면 온보딩 필요
    final onboardingStep = isFirstLogin ? 'TERMS' : 'COMPLETED';

    final response = AuthResponse(
      accessToken: mockAccessToken,
      refreshToken: mockRefreshToken,
      isFirstLogin: isFirstLogin,
      requiresOnboarding: requiresOnboarding,
      onboardingStep: onboardingStep,
    );

    debugPrint('[AuthApiService - Mock] ✅ Mock 로그인 성공');
    debugPrint('[AuthApiService - Mock] isFirstLogin: $isFirstLogin');
    debugPrint(
      '[AuthApiService - Mock] requiresOnboarding: $requiresOnboarding',
    );
    debugPrint('[AuthApiService - Mock] onboardingStep: $onboardingStep');

    return response;
  }

  /// Mock 토큰 재발급
  ///
  /// 새로운 Mock JWT 토큰을 반환합니다.
  Future<AuthResponse> _mockReissueToken(AuthRequest request) async {
    debugPrint('[AuthApiService - Mock] 🔄 Mock 토큰 재발급 시작');

    // 네트워크 호출 시뮬레이션 (500ms 지연)
    await Future.delayed(const Duration(milliseconds: 500));

    // 새로운 Mock JWT 토큰 생성
    final newAccessToken =
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.new_access_token_payload.new_signature';
    final newRefreshToken =
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.new_refresh_token_payload.new_signature';

    final response = AuthResponse(
      accessToken: newAccessToken,
      refreshToken: newRefreshToken,
      isFirstLogin: false, // 재발급은 기존 사용자이므로 항상 false
      requiresOnboarding: false, // 재발급 시점에는 이미 온보딩 완료
      onboardingStep: 'COMPLETED',
    );

    debugPrint('[AuthApiService - Mock] ✅ Mock 토큰 재발급 성공');

    return response;
  }

  /// Mock 로그아웃
  ///
  /// 500ms 지연 후 성공 반환합니다.
  Future<bool> _mockLogout(AuthRequest request) async {
    debugPrint('[AuthApiService - Mock] 👋 Mock 로그아웃 시작');

    // 네트워크 호출 시뮬레이션 (500ms 지연)
    await Future.delayed(const Duration(milliseconds: 500));

    debugPrint('[AuthApiService - Mock] ✅ Mock 로그아웃 성공');

    return true;
  }

  // ════════════════════════════════════════════════════════════════════════
  // Real API Implementations (백엔드 연동용)
  // ════════════════════════════════════════════════════════════════════════

  /// 실제 소셜 로그인 API
  ///
  /// 백엔드 API에 HTTP POST 요청을 보냅니다.
  ///
  /// **API 명세**:
  /// - Method: POST
  /// - Path: /api/auth/sign-in
  /// - Body: { socialPlatform, email, nickname, profileUrl }
  /// - Response: { accessToken, refreshToken, isFirstLogin }
  Future<AuthResponse> _realSignIn(AuthRequest request) async {
    debugPrint('[AuthApiService - Real] 🌐 실제 로그인 API 호출');
    debugPrint('[AuthApiService - Real] URL: $_baseUrl/api/auth/sign-in');
    debugPrint('[AuthApiService - Real] 요청 데이터: ${request.toJson()}');

    try {
      // Dio 클라이언트 생성 (타임아웃 설정 포함)
      final dio = Dio(
        BaseOptions(
          baseUrl: _baseUrl,
          connectTimeout: Duration(milliseconds: _timeout),
          receiveTimeout: Duration(milliseconds: _timeout),
          headers: {'Content-Type': 'application/json'},
        ),
      );

      // null 값이 포함되지 않도록 payload 정리
      final payload = Map<String, dynamic>.from(request.toJson())
        ..removeWhere((key, value) => value == null);
      debugPrint('[AuthApiService - Real] 정제된 요청 데이터: $payload');

      // POST 요청 전송
      final response = await dio.post('/api/auth/sign-in', data: payload);

      debugPrint('[AuthApiService - Real] ✅ 응답 상태: ${response.statusCode}');
      debugPrint('[AuthApiService - Real] 응답 데이터: ${response.data}');

      // 성공 응답 처리
      if (response.statusCode == 200) {
        return AuthResponse.fromJson(response.data as Map<String, dynamic>);
      } else {
        throw Exception('로그인 실패: 상태 코드 ${response.statusCode}');
      }
    } on DioException catch (e) {
      // Dio 관련 에러 처리
      if (e.type == DioExceptionType.connectionTimeout) {
        throw Exception('연결 시간 초과: 서버에 연결할 수 없습니다.');
      } else if (e.type == DioExceptionType.receiveTimeout) {
        throw Exception('응답 시간 초과: 서버 응답이 없습니다.');
      } else if (e.response != null) {
        // 서버에서 에러 응답을 받은 경우 - ApiError 활용
        final apiError = ApiError.fromDioError(e.response!.data);
        debugPrint('[AuthApiService - Real] ❌ 에러 메시지: ${apiError.statusCode}');
        debugPrint('[AuthApiService - Real] ❌ 에러 코드: ${apiError.code}');
        debugPrint('[AuthApiService - Real] ❌ 에러 메시지: ${apiError.message}');

        // 백엔드에서 제공하는 메시지를 그대로 사용
        throw Exception(apiError.message);
      } else {
        throw Exception('네트워크 오류: ${e.message}');
      }
    } catch (e) {
      // 기타 예외 처리
      debugPrint('[AuthApiService - Real] ❌ 예외 발생: $e');
      rethrow;
    }
  }

  /// 실제 토큰 재발급 API
  ///
  /// Access Token이 만료되었을 때 Refresh Token으로 새 토큰을 발급받습니다.
  ///
  /// **API 명세**:
  /// - Method: POST
  /// - Path: /api/auth/reissue
  /// - Body: { refreshToken }
  /// - Response: { accessToken, refreshToken }
  Future<AuthResponse> _realReissueToken(AuthRequest request) async {
    debugPrint('[AuthApiService - Real] 🌐 실제 토큰 재발급 API 호출');
    debugPrint('[AuthApiService - Real] URL: $_baseUrl/api/auth/reissue');

    try {
      // Dio 클라이언트 생성
      final dio = Dio(
        BaseOptions(
          baseUrl: _baseUrl,
          connectTimeout: Duration(milliseconds: _timeout),
          receiveTimeout: Duration(milliseconds: _timeout),
          headers: {'Content-Type': 'application/json'},
        ),
      );

      // POST 요청 전송
      final response = await dio.post(
        '/api/auth/reissue',
        data: request.toJson(),
      );

      debugPrint('[AuthApiService - Real] ✅ 응답 상태: ${response.statusCode}');

      // 성공 응답 처리
      if (response.statusCode == 200) {
        return AuthResponse.fromJson(response.data as Map<String, dynamic>);
      } else {
        throw Exception('토큰 재발급 실패: 상태 코드 ${response.statusCode}');
      }
    } on DioException catch (e) {
      // Dio 관련 에러 처리
      debugPrint('[AuthApiService - Real] ❌ Dio 에러: ${e.type}');

      if (e.response != null) {
        // 서버에서 에러 응답을 받은 경우 - ApiError 활용
        final apiError = ApiError.fromDioError(e.response!.data);
        debugPrint('[AuthApiService - Real] ❌ 에러 메시지: ${apiError.statusCode}');
        debugPrint('[AuthApiService - Real] ❌ 에러 코드: ${apiError.code}');
        debugPrint('[AuthApiService - Real] ❌ 에러 메시지: ${apiError.message}');

        // Refresh Token 관련 에러는 재로그인 필요
        if (apiError.code == 'REFRESH_TOKEN_NOT_FOUND' ||
            apiError.code == 'INVALID_REFRESH_TOKEN' ||
            apiError.code == 'EXPIRED_REFRESH_TOKEN') {
          throw Exception('${apiError.message} 다시 로그인해주세요.');
        }

        // 백엔드에서 제공하는 메시지를 그대로 사용
        throw Exception(apiError.message);
      } else if (e.type == DioExceptionType.connectionTimeout) {
        throw Exception('연결 시간 초과: 서버에 연결할 수 없습니다.');
      } else {
        throw Exception('네트워크 오류: ${e.message}');
      }
    } catch (e) {
      debugPrint('[AuthApiService - Real] ❌ 예외 발생: $e');
      rethrow;
    }
  }

  /// 실제 로그아웃 API
  ///
  /// 백엔드에 로그아웃 요청을 보내 Refresh Token을 무효화합니다.
  ///
  /// **API 명세**:
  /// - Method: POST
  /// - Path: /api/auth/logout
  /// - Headers: Authorization: Bearer {accessToken}
  /// - Body: { refreshToken }
  ///
  /// **주의사항**:
  /// - Authorization 헤더에 Access Token이 필수입니다.
  /// - 네트워크 오류 시에도 true 반환 (로컬 토큰은 이미 삭제됨)
  Future<bool> _realLogout(AuthRequest request) async {
    debugPrint('[AuthApiService - Real] 🌐 실제 로그아웃 API 호출');
    debugPrint('[AuthApiService - Real] URL: $_baseUrl/api/auth/logout');

    try {
      // ⭐ Secure Storage에서 Access Token 가져오기 (Authorization 헤더용)
      final accessToken = await _storage.read(key: _accessTokenKey);

      if (accessToken == null) {
        debugPrint(
          '[AuthApiService - Real] ⚠️ Access Token이 없습니다. 로그아웃 API 스킵',
        );
        // Access Token이 없으면 API 호출 불가하지만 로컬 토큰은 삭제됨
        return true;
      }

      debugPrint(
        '[AuthApiService - Real] ✅ Access Token 확인: ${accessToken.substring(0, 20)}...',
      );

      // Dio 클라이언트 생성 (Authorization 헤더 포함)
      final dio = Dio(
        BaseOptions(
          baseUrl: _baseUrl,
          connectTimeout: Duration(milliseconds: _timeout),
          receiveTimeout: Duration(milliseconds: _timeout),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $accessToken', // ⭐ 필수 헤더
          },
        ),
      );

      // POST 요청 전송
      final response = await dio.post(
        '/api/auth/logout',
        data: request.toJson(),
      );

      debugPrint('[AuthApiService - Real] ✅ 응답 상태: ${response.statusCode}');

      // 성공 여부 반환
      return response.statusCode == 200;
    } on DioException catch (e) {
      // Dio 관련 에러 처리
      debugPrint('[AuthApiService - Real] ⚠️ Dio 에러: ${e.type}');
      debugPrint('[AuthApiService - Real] ⚠️ 에러 메시지: ${e.message}');

      // 로그아웃 API 실패해도 로컬 토큰은 이미 삭제되었으므로 true 반환
      // 네트워크 오류나 서버 오류는 사용자 경험에 영향을 주지 않음
      return true;
    } catch (e) {
      debugPrint('[AuthApiService - Real] ⚠️ 예외 발생: $e');
      // 로그아웃 API 실패해도 로컬 토큰은 이미 삭제되었으므로 true 반환
      return true;
    }
  }
}
