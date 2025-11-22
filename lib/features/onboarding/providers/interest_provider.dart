import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../data/models/interest_response.dart';
import '../services/interest_api_service.dart';

part 'interest_provider.g.dart';

/// Dio 인스턴스 Provider (JWT 토큰 자동 추가)
///
/// **특징**:
/// - Interceptor를 통해 모든 요청에 JWT 토큰 자동 추가
/// - FlutterSecureStorage에서 access_token 읽기
/// - 토큰이 없으면 요청 그대로 진행 (인증 불필요한 API 대응)
@riverpod
Dio dio(Ref ref) {
  final dio = Dio(
    BaseOptions(
      baseUrl:
          dotenv.env['API_BASE_URL'] ?? 'https://api.tripgether.suhsaechan.kr',
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: {'Content-Type': 'application/json'},
    ),
  );

  // JWT 토큰 자동 추가 Interceptor
  dio.interceptors.add(
    InterceptorsWrapper(
      onRequest: (options, handler) async {
        // FlutterSecureStorage에서 토큰 읽기
        const storage = FlutterSecureStorage();
        final accessToken = await storage.read(key: 'access_token');

        // 토큰이 있으면 Authorization 헤더 추가
        if (accessToken != null && accessToken.isNotEmpty) {
          options.headers['Authorization'] = 'Bearer $accessToken';
        }

        return handler.next(options);
      },
    ),
  );

  return dio;
}

/// Interest API Service Provider
@riverpod
InterestApiService interestApiService(Ref ref) {
  final dio = ref.watch(dioProvider);
  return InterestApiService(dio);
}

/// 전체 관심사 목록 조회 Provider
///
/// GET /api/interests
///
/// **특징**:
/// - Redis 캐싱 적용 (서버)
/// - Mock 모드에서는 하드코딩된 데이터 반환
/// - API 실패 시 Fallback으로 Mock 데이터 사용
@riverpod
Future<GetAllInterestsResponse> interests(Ref ref) async {
  final service = ref.watch(interestApiServiceProvider);
  return await service.getAllInterests();
}

/// 관심사 상세 조회 Provider
///
/// GET /api/interests/{interestId}
@riverpod
Future<GetInterestByIdResponse> interestById(Ref ref, String interestId) async {
  final service = ref.watch(interestApiServiceProvider);
  return await service.getInterestById(interestId);
}

/// 특정 카테고리 관심사 조회 Provider
///
/// GET /api/interests/categories/{category}
@riverpod
Future<GetInterestsByCategoryResponse> interestsByCategory(
  Ref ref,
  String category,
) async {
  final service = ref.watch(interestApiServiceProvider);
  return await service.getInterestsByCategory(category);
}
