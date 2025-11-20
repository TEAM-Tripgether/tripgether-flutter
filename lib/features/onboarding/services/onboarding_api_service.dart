import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:tripgether/core/errors/api_error.dart';
import '../data/models/onboarding_response.dart';

/// 온보딩 API 서비스
///
/// **기능**:
/// 1. Mock/Real API 자동 분기 처리
/// 2. USE_MOCK_API 환경 변수로 제어
/// 3. 5단계 온보딩 API 호출 (약관 → 이름 → 생년월일 → 성별 → 관심사)
///
/// **환경 변수 설정**:
/// - dart-define: `--dart-define=USE_MOCK_API=true`
/// - .env: `USE_MOCK_API=true`
///
/// **사용 예시**:
/// ```dart
/// final service = OnboardingApiService();
/// final response = await service.agreeTerms(
///   accessToken: token,
///   isServiceTermsAndPrivacyAgreed: true,
///   isMarketingAgreed: false,
/// );
/// // response.currentStep → "NAME" (다음 단계)
/// ```
class OnboardingApiService {
  // ══════════════════════════════════════════════════════════════════════════
  // Mock/Real API 전환
  // ══════════════════════════════════════════════════════════════════════════

  /// Mock API 사용 여부
  ///
  /// **우선순위**:
  /// 1. dart-define: `--dart-define=USE_MOCK_API=true`
  /// 2. .env: `USE_MOCK_API=true`
  /// 3. 기본값: true (Mock 모드)
  static bool get _useMockData {
    // 1. dart-define 확인
    const dartDefine = String.fromEnvironment('USE_MOCK_API');
    if (dartDefine.isNotEmpty) {
      return dartDefine.toLowerCase() == 'true';
    }

    // 2. .env 확인
    final envValue = dotenv.env['USE_MOCK_API'];
    if (envValue != null) {
      return envValue.toLowerCase() == 'true';
    }

    // 3. 기본값: Mock 모드
    return true;
  }

  /// API Base URL
  ///
  /// **우선순위**:
  /// 1. dart-define: `--dart-define=API_BASE_URL=https://...`
  /// 2. .env: `API_BASE_URL=https://...`
  /// 3. 기본값: https://api.tripgether.suhsaechan.kr
  static String get _baseUrl {
    // 1. dart-define 확인
    const dartDefine = String.fromEnvironment('API_BASE_URL');
    if (dartDefine.isNotEmpty) return dartDefine;

    // 2. .env 확인 또는 기본값 사용
    return dotenv.env['API_BASE_URL'] ?? 'https://api.tripgether.suhsaechan.kr';
  }

  final Dio _dio;

  OnboardingApiService()
    : _dio = Dio(
        BaseOptions(
          baseUrl: _baseUrl,
          connectTimeout: const Duration(seconds: 10),
          receiveTimeout: const Duration(seconds: 10),
        ),
      );

  // ══════════════════════════════════════════════════════════════════════════
  // API 메서드
  // ══════════════════════════════════════════════════════════════════════════

  /// 1. 약관 동의
  ///
  /// **요청**:
  /// ```json
  /// POST /api/members/onboarding/terms
  /// {
  ///   "isServiceTermsAndPrivacyAgreed": true,
  ///   "isMarketingAgreed": false
  /// }
  /// ```
  ///
  /// **응답**: currentStep = "NAME" (다음 단계: 이름 입력)
  Future<OnboardingResponse> agreeTerms({
    required String accessToken,
    required bool isServiceTermsAndPrivacyAgreed,
    required bool isMarketingAgreed,
  }) async {
    if (_useMockData) {
      return _mockAgreeTerms(
        isServiceTermsAndPrivacyAgreed: isServiceTermsAndPrivacyAgreed,
        isMarketingAgreed: isMarketingAgreed,
      );
    }

    try {
      final response = await _dio.post(
        '/api/members/onboarding/terms',
        options: Options(headers: {'Authorization': 'Bearer $accessToken'}),
        data: {
          'isServiceTermsAndPrivacyAgreed': isServiceTermsAndPrivacyAgreed,
          'isMarketingAgreed': isMarketingAgreed,
        },
      );

      return OnboardingResponse.fromJson(response.data);
    } on DioException catch (e) {
      if (e.response != null) {
        debugPrint('[onboardingApiService] ❌ 서버 응답 전체:');
        debugPrint("Response body : '${e.response!.toString()}'");

        debugPrint('  - Status Code: ${e.response!.statusCode}');
        debugPrint('  - Status Message: ${e.response!.statusMessage}');
        debugPrint('  - Response Data: ${e.response!.data}');
        debugPrint('  - Headers: ${e.response!.headers}');
        // 서버에서 에러 응답을 받은 경우 - ApiError 활용
        final apiError = ApiError.fromDioError(e.response!.data);
        debugPrint('[OnboardingApiService] ❌ 에러 코드: ${apiError.code}');
        debugPrint('[OnboardingApiService] ❌ 에러 메시지: ${apiError.message}');
        throw Exception(apiError.message);
      } else {
        debugPrint('[OnboardingApiService] ❌ 네트워크 오류: ${e.message}');
        throw Exception('네트워크 연결을 확인해주세요.');
      }
    } catch (e) {
      debugPrint('[OnboardingApiService] ❌ 예외 발생: $e');
      rethrow;
    }
  }

  /// 2. 이름 설정
  ///
  /// **요청**:
  /// ```json
  /// POST /api/members/onboarding/name
  /// { "name": "홍길동" }
  /// ```
  ///
  /// **응답**: currentStep = "BIRTH_DATE" (다음 단계: 생년월일 입력)
  Future<OnboardingResponse> updateName({
    required String accessToken,
    required String name,
  }) async {
    if (_useMockData) {
      return _mockUpdateName(name: name);
    }

    try {
      final response = await _dio.post(
        '/api/members/onboarding/name',
        options: Options(headers: {'Authorization': 'Bearer $accessToken'}),
        data: {'name': name},
      );

      return OnboardingResponse.fromJson(response.data);
    } on DioException catch (e) {
      if (e.response != null) {
        debugPrint('[onboardingApiService] ❌ 서버 응답 전체:');
        debugPrint("Response body : '${e.response!.toString()}'");

        debugPrint('  - Status Code: ${e.response!.statusCode}');
        debugPrint('  - Status Message: ${e.response!.statusMessage}');
        debugPrint('  - Response Data: ${e.response!.data}');
        debugPrint('  - Headers: ${e.response!.headers}');
        // 서버에서 에러 응답을 받은 경우 - ApiError 활용
        final apiError = ApiError.fromDioError(e.response!.data);
        debugPrint('[OnboardingApiService] ❌ 에러 코드: ${apiError.code}');
        debugPrint('[OnboardingApiService] ❌ 에러 메시지: ${apiError.message}');
        throw Exception(apiError.message);
      } else {
        debugPrint('[OnboardingApiService] ❌ 네트워크 오류: ${e.message}');
        throw Exception('네트워크 연결을 확인해주세요.');
      }
    } catch (e) {
      debugPrint('[OnboardingApiService] ❌ 예외 발생: $e');
      rethrow;
    }
  }

  /// 3. 생년월일 설정
  ///
  /// **요청**:
  /// ```json
  /// POST /api/members/onboarding/birth-date
  /// { "birthDate": "1990-01-01" }
  /// ```
  ///
  /// **응답**: currentStep = "GENDER" (다음 단계: 성별 선택)
  Future<OnboardingResponse> updateBirthDate({
    required String accessToken,
    required String birthDate,
  }) async {
    if (_useMockData) {
      return _mockUpdateBirthDate(birthDate: birthDate);
    }

    try {
      final response = await _dio.post(
        '/api/members/onboarding/birth-date',
        options: Options(headers: {'Authorization': 'Bearer $accessToken'}),
        data: {'birthDate': birthDate},
      );

      return OnboardingResponse.fromJson(response.data);
    } on DioException catch (e) {
      if (e.response != null) {
        debugPrint('[onboardingApiService] ❌ 서버 응답 전체:');
        debugPrint("Response body : '${e.response!.toString()}'");

        debugPrint('  - Status Code: ${e.response!.statusCode}');
        debugPrint('  - Status Message: ${e.response!.statusMessage}');
        debugPrint('  - Response Data: ${e.response!.data}');
        debugPrint('  - Headers: ${e.response!.headers}');
        // 서버에서 에러 응답을 받은 경우 - ApiError 활용
        final apiError = ApiError.fromDioError(e.response!.data);
        debugPrint('[OnboardingApiService] ❌ 에러 코드: ${apiError.code}');
        debugPrint('[OnboardingApiService] ❌ 에러 메시지: ${apiError.message}');
        throw Exception(apiError.message);
      } else {
        debugPrint('[OnboardingApiService] ❌ 네트워크 오류: ${e.message}');
        throw Exception('네트워크 연결을 확인해주세요.');
      }
    } catch (e) {
      debugPrint('[OnboardingApiService] ❌ 예외 발생: $e');
      rethrow;
    }
  }

  /// 4. 성별 설정
  ///
  /// **요청**:
  /// ```json
  /// POST /api/members/onboarding/gender
  /// { "gender": "MALE" }
  /// ```
  ///
  /// **응답**: currentStep = "INTERESTS" (다음 단계: 관심사 선택)
  Future<OnboardingResponse> updateGender({
    required String accessToken,
    required String gender,
  }) async {
    if (_useMockData) {
      return _mockUpdateGender(gender: gender);
    }

    try {
      final response = await _dio.post(
        '/api/members/onboarding/gender',
        options: Options(headers: {'Authorization': 'Bearer $accessToken'}),
        data: {'gender': gender},
      );

      return OnboardingResponse.fromJson(response.data);
    } on DioException catch (e) {
      if (e.response != null) {
        debugPrint('[onboardingApiService] ❌ 서버 응답 전체:');
        debugPrint("Response body : '${e.response!.toString()}'");

        debugPrint('  - Status Code: ${e.response!.statusCode}');
        debugPrint('  - Status Message: ${e.response!.statusMessage}');
        debugPrint('  - Response Data: ${e.response!.data}');
        debugPrint('  - Headers: ${e.response!.headers}');
        // 서버에서 에러 응답을 받은 경우 - ApiError 활용
        final apiError = ApiError.fromDioError(e.response!.data);
        debugPrint('[OnboardingApiService] ❌ 에러 코드: ${apiError.code}');
        debugPrint('[OnboardingApiService] ❌ 에러 메시지: ${apiError.message}');
        throw Exception(apiError.message);
      } else {
        debugPrint('[OnboardingApiService] ❌ 네트워크 오류: ${e.message}');
        throw Exception('네트워크 연결을 확인해주세요.');
      }
    } catch (e) {
      debugPrint('[OnboardingApiService] ❌ 예외 발생: $e');
      rethrow;
    }
  }

  /// 5. 관심사 설정
  ///
  /// **요청**:
  /// ```json
  /// POST /api/members/onboarding/interests
  /// { "interestIds": ["1", "2", "3"] }
  /// ```
  ///
  /// **응답**: currentStep = "COMPLETED", onboardingStatus = "COMPLETED"
  Future<OnboardingResponse> updateInterests({
    required String accessToken,
    required List<String> interestIds,
  }) async {
    if (_useMockData) {
      return _mockUpdateInterests(interestIds: interestIds);
    }

    try {
      final response = await _dio.post(
        '/api/members/onboarding/interests',
        options: Options(headers: {'Authorization': 'Bearer $accessToken'}),
        data: {'interestIds': interestIds},
      );

      return OnboardingResponse.fromJson(response.data);
    } on DioException catch (e) {
      if (e.response != null) {
        debugPrint('[onboardingApiService] ❌ 서버 응답 전체:');
        debugPrint("Response body : '${e.response!.toString()}'");

        debugPrint('  - Status Code: ${e.response!.statusCode}');
        debugPrint('  - Status Message: ${e.response!.statusMessage}');
        debugPrint('  - Response Data: ${e.response!.data}');
        debugPrint('  - Headers: ${e.response!.headers}');
        // 서버에서 에러 응답을 받은 경우 - ApiError 활용
        final apiError = ApiError.fromDioError(e.response!.data);
        debugPrint('[OnboardingApiService] ❌ 에러 코드: ${apiError.code}');
        debugPrint('[OnboardingApiService] ❌ 에러 메시지: ${apiError.message}');
        throw Exception(apiError.message);
      } else {
        debugPrint('[OnboardingApiService] ❌ 네트워크 오류: ${e.message}');
        throw Exception('네트워크 연결을 확인해주세요.');
      }
    } catch (e) {
      debugPrint('[OnboardingApiService] ❌ 예외 발생: $e');
      rethrow;
    }
  }

  // ══════════════════════════════════════════════════════════════════════════
  // Mock API 응답
  // ══════════════════════════════════════════════════════════════════════════

  /// Mock: 약관 동의
  OnboardingResponse _mockAgreeTerms({
    required bool isServiceTermsAndPrivacyAgreed,
    required bool isMarketingAgreed,
  }) {
    debugPrint('[OnboardingApiService] 🧪 Mock: 약관 동의');
    return OnboardingResponse(
      currentStep: 'NAME',
      onboardingStatus: 'IN_PROGRESS',
      member: MemberDto(
        id: 'mock-user-id',
        email: 'mock@example.com',
        name: '',
        onboardingStatus: 'IN_PROGRESS',
        isServiceTermsAndPrivacyAgreed: isServiceTermsAndPrivacyAgreed,
        isMarketingAgreed: isMarketingAgreed,
      ),
    );
  }

  /// Mock: 이름 설정
  OnboardingResponse _mockUpdateName({required String name}) {
    debugPrint('[OnboardingApiService] 🧪 Mock: 이름 설정 - $name');
    return OnboardingResponse(
      currentStep: 'BIRTH_DATE',
      onboardingStatus: 'IN_PROGRESS',
      member: MemberDto(
        id: 'mock-user-id',
        email: 'mock@example.com',
        name: name,
        onboardingStatus: 'IN_PROGRESS',
        isServiceTermsAndPrivacyAgreed: true,
        isMarketingAgreed: false,
      ),
    );
  }

  /// Mock: 생년월일 설정
  OnboardingResponse _mockUpdateBirthDate({required String birthDate}) {
    debugPrint('[OnboardingApiService] 🧪 Mock: 생년월일 설정 - $birthDate');
    return OnboardingResponse(
      currentStep: 'GENDER',
      onboardingStatus: 'IN_PROGRESS',
      member: MemberDto(
        id: 'mock-user-id',
        email: 'mock@example.com',
        name: 'Mock User',
        onboardingStatus: 'IN_PROGRESS',
        isServiceTermsAndPrivacyAgreed: true,
        isMarketingAgreed: false,
        birthDate: birthDate,
      ),
    );
  }

  /// Mock: 성별 설정
  OnboardingResponse _mockUpdateGender({required String gender}) {
    debugPrint('[OnboardingApiService] 🧪 Mock: 성별 설정 - $gender');
    return OnboardingResponse(
      currentStep: 'INTERESTS',
      onboardingStatus: 'IN_PROGRESS',
      member: MemberDto(
        id: 'mock-user-id',
        email: 'mock@example.com',
        name: 'Mock User',
        onboardingStatus: 'IN_PROGRESS',
        isServiceTermsAndPrivacyAgreed: true,
        isMarketingAgreed: false,
        birthDate: '1990-01-01',
        gender: gender,
      ),
    );
  }

  /// Mock: 관심사 설정
  OnboardingResponse _mockUpdateInterests({required List<String> interestIds}) {
    debugPrint(
      '[OnboardingApiService] 🧪 Mock: 관심사 설정 - ${interestIds.length}개',
    );
    return const OnboardingResponse(
      currentStep: 'COMPLETED',
      onboardingStatus: 'COMPLETED',
      member: MemberDto(
        id: 'mock-user-id',
        email: 'mock@example.com',
        name: 'Mock User',
        onboardingStatus: 'COMPLETED',
        isServiceTermsAndPrivacyAgreed: true,
        isMarketingAgreed: false,
        birthDate: '1990-01-01',
        gender: 'MALE',
      ),
    );
  }
}
