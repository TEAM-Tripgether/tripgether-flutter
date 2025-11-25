import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../../../../core/models/save_place_response.dart';
import '../../../../core/network/auth_interceptor.dart';
import '../../../../core/utils/api_logger.dart';

/// 장소 관련 API 서비스
///
/// 장소 저장, 삭제 등의 API를 처리합니다.
/// Mock/Real API를 Boolean 플래그로 전환할 수 있습니다.
class PlaceApiService {
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
  // Dio 인스턴스
  // ════════════════════════════════════════════════════════════════════════

  /// Dio 인스턴스 (싱글톤)
  static Dio? _dio;

  /// Dio 인스턴스 getter (lazy initialization)
  static Dio get _dioInstance {
    if (_dio == null) {
      _dio = Dio(
        BaseOptions(
          baseUrl: _baseUrl,
          connectTimeout: Duration(milliseconds: _timeout),
          receiveTimeout: Duration(milliseconds: _timeout),
          headers: {'Content-Type': 'application/json'},
        ),
      );
      // AuthInterceptor 추가 (JWT 토큰 자동 주입 + 자동 토큰 재발급)
      _dio!.interceptors.add(AuthInterceptor(baseUrl: _baseUrl));
    }
    return _dio!;
  }

  // ════════════════════════════════════════════════════════════════════════
  // Public API Methods
  // ════════════════════════════════════════════════════════════════════════

  /// 장소 저장
  ///
  /// 임시 저장 상태(TEMPORARY)의 장소를 저장 상태(SAVED)로 변경합니다.
  ///
  /// **API**: POST /api/place/{placeId}/save
  /// **인증**: 필요 (JWT)
  ///
  /// [placeId] 저장할 장소 ID
  ///
  /// Returns: [SavePlaceResponse] 저장 결과
  /// Throws: Exception - API 호출 실패 시
  static Future<SavePlaceResponse> savePlace({
    required String placeId,
  }) async {
    debugPrint('═══════════════════════════════════════════════════════');
    debugPrint('[PlaceApiService] 🔄 savePlace 시작');
    debugPrint('[PlaceApiService] 📍 placeId: $placeId');
    debugPrint('[PlaceApiService] 🔧 useMockData: $_useMockData');
    debugPrint('[PlaceApiService] 🌐 baseUrl: $_baseUrl');
    debugPrint('═══════════════════════════════════════════════════════');

    if (_useMockData) {
      return _savePlaceMock(placeId: placeId);
    } else {
      return _savePlaceReal(placeId: placeId);
    }
  }

  // ════════════════════════════════════════════════════════════════════════
  // Mock API Implementation
  // ════════════════════════════════════════════════════════════════════════

  /// Mock: 장소 저장
  static Future<SavePlaceResponse> _savePlaceMock({
    required String placeId,
  }) async {
    debugPrint('[PlaceApiService.Mock] 🎭 Mock 장소 저장 시작');

    // API 지연 시뮬레이션
    await Future.delayed(const Duration(milliseconds: 500));

    final mockResponse = SavePlaceResponse(
      memberPlaceId: 'mock-member-place-${DateTime.now().millisecondsSinceEpoch}',
      placeId: placeId,
      savedStatus: 'SAVED',
      savedAt: DateTime.now().toIso8601String(),
    );

    debugPrint('[PlaceApiService.Mock] ✅ Mock 장소 저장 완료');
    debugPrint('[PlaceApiService.Mock] 📦 Response: $mockResponse');
    debugPrint('═══════════════════════════════════════════════════════');

    return mockResponse;
  }

  // ════════════════════════════════════════════════════════════════════════
  // Real API Implementation
  // ════════════════════════════════════════════════════════════════════════

  /// Real: 장소 저장
  static Future<SavePlaceResponse> _savePlaceReal({
    required String placeId,
  }) async {
    try {
      debugPrint('[PlaceApiService.Real] 📤 POST /api/place/$placeId/save 요청');

      final response = await _dioInstance.post(
        '/api/place/$placeId/save',
      );

      debugPrint('[PlaceApiService.Real] 📥 Response Status: ${response.statusCode}');
      debugPrint('[PlaceApiService.Real] 📥 Response Data: ${response.data}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData =
            response.data as Map<String, dynamic>;

        final result = SavePlaceResponse.fromJson(responseData);

        debugPrint('[PlaceApiService.Real] ✅ 장소 저장 성공');
        debugPrint('[PlaceApiService.Real] 📦 savedStatus: ${result.savedStatus}');
        debugPrint('═══════════════════════════════════════════════════════');

        return result;
      } else {
        debugPrint('[PlaceApiService.Real] ❌ 실패 - Status: ${response.statusCode}');
        debugPrint('═══════════════════════════════════════════════════════');
        throw Exception('장소 저장 실패: ${response.statusCode}');
      }
    } on DioException catch (e) {
      debugPrint('[PlaceApiService.Real] ❌ DioException 발생');
      debugPrint('[PlaceApiService.Real] ❌ Error Type: ${e.type}');
      debugPrint('[PlaceApiService.Real] ❌ Error Message: ${e.message}');
      debugPrint('[PlaceApiService.Real] ❌ Response: ${e.response?.data}');
      debugPrint('═══════════════════════════════════════════════════════');

      ApiLogger.throwFromDioError(
        e,
        context: 'PlaceApiService.savePlace',
      );
    } catch (e) {
      debugPrint('[PlaceApiService.Real] ❌ Exception 발생: $e');
      debugPrint('═══════════════════════════════════════════════════════');
      ApiLogger.logException(
        e,
        context: 'PlaceApiService.savePlace',
      );
      rethrow;
    }
  }
}
