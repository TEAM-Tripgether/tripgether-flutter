import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../data/models/interest_response.dart';
import '../services/interest_api_service.dart';

part 'interest_provider.g.dart';

/// Dio 인스턴스 Provider
@riverpod
Dio dio(DioRef ref) {
  return Dio(
    BaseOptions(
      baseUrl: 'https://api.tripgether.suhsaechan.kr',
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: {
        'Content-Type': 'application/json',
      },
    ),
  );
}

/// Interest API Service Provider
@riverpod
InterestApiService interestApiService(InterestApiServiceRef ref) {
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
Future<GetAllInterestsResponse> interests(InterestsRef ref) async {
  final service = ref.watch(interestApiServiceProvider);
  return await service.getAllInterests();
}

/// 관심사 상세 조회 Provider
///
/// GET /api/interests/{interestId}
@riverpod
Future<GetInterestByIdResponse> interestById(
  InterestByIdRef ref,
  String interestId,
) async {
  final service = ref.watch(interestApiServiceProvider);
  return await service.getInterestById(interestId);
}

/// 특정 카테고리 관심사 조회 Provider
///
/// GET /api/interests/categories/{category}
@riverpod
Future<GetInterestsByCategoryResponse> interestsByCategory(
  InterestsByCategoryRef ref,
  String category,
) async {
  final service = ref.watch(interestApiServiceProvider);
  return await service.getInterestsByCategory(category);
}
