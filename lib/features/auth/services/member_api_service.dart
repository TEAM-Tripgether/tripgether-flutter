import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:tripgether/core/network/auth_interceptor.dart';
import 'package:tripgether/core/utils/api_logger.dart';
import 'package:tripgether/features/auth/data/models/user_model.dart';

/// 회원 정보 API 서비스
///
/// 회원 정보 조회/수정과 관련된 백엔드 API와 통신합니다.
/// Mock/Real API를 Boolean 플래그로 전환할 수 있습니다.
///
/// **Mock 모드**: 백엔드 없이 테스트 가능
/// **Real 모드**: 실제 백엔드 API 연동
///
/// **주요 API**:
/// - GET /api/members/email/{email} - 이메일로 회원 정보 조회
class MemberApiService {
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

  // ════════════════════════════════════════════════════════════════════════
  // Public API Methods
  // ════════════════════════════════════════════════════════════════════════

  /// 이메일로 회원 정보 조회
  ///
  /// **API 명세**:
  /// - Method: GET
  /// - Path: /api/members/email/{email}
  /// - Headers: Authorization: Bearer {accessToken}
  ///
  /// **응답 필드**:
  /// - id: 회원 UUID
  /// - email: 이메일
  /// - name: 닉네임 (⭐ User.nickname으로 매핑)
  /// - onboardingStatus: 온보딩 상태
  /// - isServiceTermsAndPrivacyAgreed: 이용약관 동의 여부
  /// - isMarketingAgreed: 마케팅 수신 동의 여부
  /// - birthDate: 생년월일
  /// - gender: 성별
  ///
  /// [email] 조회할 회원의 이메일 주소
  /// [photoUrl] Google 프로필 이미지 URL (서버에 저장되지 않은 경우 사용)
  /// [loginPlatform] 로그인 플랫폼 ("GOOGLE", "KAKAO")
  ///
  /// Returns: User 객체 (서버 응답 기반)
  /// Throws: Exception - API 호출 실패 시
  Future<User> getMemberByEmail({
    required String email,
    String? photoUrl,
    String? loginPlatform,
  }) async {
    debugPrint('[MemberApiService] 👤 회원 정보 조회 API 호출');
    debugPrint('[MemberApiService] Mode: ${_useMockData ? "MOCK" : "REAL"}');
    debugPrint('[MemberApiService] Email: $email');

    try {
      if (_useMockData) {
        return await _mockGetMemberByEmail(
          email: email,
          photoUrl: photoUrl,
          loginPlatform: loginPlatform,
        );
      } else {
        return await _realGetMemberByEmail(
          email: email,
          photoUrl: photoUrl,
          loginPlatform: loginPlatform,
        );
      }
    } catch (e) {
      debugPrint('[MemberApiService] ❌ 회원 정보 조회 실패: $e');
      rethrow;
    }
  }

  // ════════════════════════════════════════════════════════════════════════
  // Mock API Implementations (백엔드 없이 테스트용)
  // ════════════════════════════════════════════════════════════════════════

  /// Mock 회원 정보 조회
  ///
  /// 실제 백엔드 없이 테스트할 수 있습니다.
  /// 500ms 지연 후 Mock 데이터를 반환합니다.
  Future<User> _mockGetMemberByEmail({
    required String email,
    String? photoUrl,
    String? loginPlatform,
  }) async {
    debugPrint('[MemberApiService - Mock] ✅ Mock 회원 정보 조회 시작');
    debugPrint('[MemberApiService - Mock] 요청 이메일: $email');

    // 네트워크 호출 시뮬레이션 (500ms 지연)
    await Future.delayed(const Duration(milliseconds: 500));

    // Mock 응답 데이터 생성
    // 실제 서버 응답과 동일한 형식
    final mockResponse = {
      'id': '550e8400-e29b-41d4-a716-446655440000',
      'email': email,
      'name': '여행러버', // ⭐ Mock 닉네임 (서버에서 설정한 이름)
      'onboardingStatus': 'COMPLETED',
      'isServiceTermsAndPrivacyAgreed': true,
      'isMarketingAgreed': false,
      'birthDate': '1990-01-01',
      'gender': 'MALE',
    };

    debugPrint('[MemberApiService - Mock] ✅ Mock 응답 데이터:');
    debugPrint('[MemberApiService - Mock]   - id: ${mockResponse['id']}');
    debugPrint('[MemberApiService - Mock]   - name: ${mockResponse['name']}');
    debugPrint(
      '[MemberApiService - Mock]   - onboardingStatus: ${mockResponse['onboardingStatus']}',
    );

    // User.fromMemberApiResponse로 변환
    final user = User.fromMemberApiResponse(
      mockResponse,
      photoUrl: photoUrl,
      loginPlatform: loginPlatform,
    );

    debugPrint('[MemberApiService - Mock] ✅ Mock 회원 정보 조회 성공');
    debugPrint('[MemberApiService - Mock]   - nickname: ${user.nickname}');

    return user;
  }

  // ════════════════════════════════════════════════════════════════════════
  // Real API Implementations (백엔드 연동용)
  // ════════════════════════════════════════════════════════════════════════

  /// 실제 회원 정보 조회 API
  ///
  /// **API 명세**:
  /// - Method: GET
  /// - Path: /api/members/email/{email}
  /// - Headers: Authorization: Bearer {accessToken}
  Future<User> _realGetMemberByEmail({
    required String email,
    String? photoUrl,
    String? loginPlatform,
  }) async {
    debugPrint('[MemberApiService - Real] 🌐 실제 회원 정보 조회 API 호출');
    debugPrint(
      '[MemberApiService - Real] URL: $_baseUrl/api/members/email/$email',
    );

    try {
      // Dio 클라이언트 생성 (AuthInterceptor 포함)
      final dio = Dio(
        BaseOptions(
          baseUrl: _baseUrl,
          connectTimeout: Duration(milliseconds: _timeout),
          receiveTimeout: Duration(milliseconds: _timeout),
          headers: {'Content-Type': 'application/json'},
        ),
      );

      // AuthInterceptor 추가 (JWT 토큰 자동 주입)
      dio.interceptors.add(AuthInterceptor(baseUrl: _baseUrl));

      // GET 요청 전송 (URL 인코딩 적용)
      final encodedEmail = Uri.encodeComponent(email);
      final response = await dio.get('/api/members/email/$encodedEmail');

      debugPrint(
        '[MemberApiService - Real] ✅ 응답 상태: ${response.statusCode}',
      );
      debugPrint('[MemberApiService - Real] 응답 데이터: ${response.data}');

      // 성공 응답 처리
      if (response.statusCode == 200) {
        final user = User.fromMemberApiResponse(
          response.data as Map<String, dynamic>,
          photoUrl: photoUrl,
          loginPlatform: loginPlatform,
        );

        debugPrint('[MemberApiService - Real] ✅ 회원 정보 조회 성공');
        debugPrint('[MemberApiService - Real]   - userId: ${user.userId}');
        debugPrint('[MemberApiService - Real]   - nickname: ${user.nickname}');
        debugPrint(
          '[MemberApiService - Real]   - onboardingStatus: ${user.onboardingStatus}',
        );

        return user;
      } else {
        throw Exception('회원 정보 조회 실패: 상태 코드 ${response.statusCode}');
      }
    } on DioException catch (e) {
      ApiLogger.throwFromDioError(e, context: 'MemberApiService.getMemberByEmail');
    } catch (e) {
      ApiLogger.logException(e, context: 'MemberApiService.getMemberByEmail');
      rethrow;
    }
  }
}
