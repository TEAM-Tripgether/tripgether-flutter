import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:tripgether/core/errors/api_error.dart';
import 'package:tripgether/core/utils/api_logger.dart';
import '../data/models/interest_response.dart';

/// 관심사 API 서비스
///
/// **Mock 모드**: 하드코딩된 데이터 반환
/// **Production 모드**: 서버 API 호출
///
/// **인증**: Dio Interceptor가 자동으로 JWT 토큰 추가 (interest_provider.dart)
class InterestApiService {
  final Dio _dio;

  InterestApiService(this._dio);

  /// 전체 관심사 목록 조회
  ///
  /// GET /api/interests
  ///
  /// **Mock 모드**: 하드코딩된 14개 카테고리 데이터 반환
  /// **Production 모드**: 서버 API 호출 (Redis 캐싱 적용)
  ///
  /// **인증**: Dio Interceptor가 자동으로 JWT Bearer Token 추가
  Future<GetAllInterestsResponse> getAllInterests() async {
    // USE_MOCK_API 환경 변수 활용 (기존 프로젝트 방식과 통일)
    const useMockApi = bool.fromEnvironment('USE_MOCK_API', defaultValue: true);

    if (useMockApi) {
      return _mockGetAllInterests();
    }

    try {
      debugPrint('[InterestApiService] 📡 전체 관심사 조회 API 호출');

      // Dio Interceptor가 자동으로 Authorization 헤더 추가
      final response = await _dio.get('/api/interests');

      debugPrint('[InterestApiService] ✅ 전체 관심사 조회 성공');

      return GetAllInterestsResponse.fromJson(response.data);
    } on DioException catch (e) {
      ApiLogger.logDioError(e, context: 'InterestApiService.getAllInterests');
      if (e.response != null) {
        final apiError = ApiError.fromDioError(e.response!.data);
        throw Exception(apiError.message);
      } else {
        throw Exception('네트워크 연결을 확인해주세요');
      }
    }
  }

  /// 관심사 상세 조회
  ///
  /// GET /api/interests/{interestId}
  Future<GetInterestByIdResponse> getInterestById(String interestId) async {
    const useRealApi = bool.fromEnvironment(
      'USE_REAL_API',
      defaultValue: false,
    );

    if (!useRealApi) {
      throw UnimplementedError('Mock 모드에서는 관심사 상세 조회를 지원하지 않습니다');
    }

    try {
      debugPrint('[InterestApiService] 📡 관심사 상세 조회 API 호출: $interestId');

      final response = await _dio.get('/api/interests/$interestId');

      debugPrint('[InterestApiService] ✅ 관심사 상세 조회 성공');

      return GetInterestByIdResponse.fromJson(response.data);
    } on DioException catch (e) {
      ApiLogger.logDioError(e, context: 'InterestApiService.getInterestById');
      if (e.response != null) {
        final apiError = ApiError.fromDioError(e.response!.data);
        throw Exception(apiError.message);
      }
      throw Exception('관심사 정보를 가져올 수 없습니다.');
    }
  }

  /// 특정 카테고리 관심사 조회
  ///
  /// GET /api/interests/categories/{category}
  Future<GetInterestsByCategoryResponse> getInterestsByCategory(
    String category,
  ) async {
    const useRealApi = bool.fromEnvironment(
      'USE_REAL_API',
      defaultValue: false,
    );

    if (!useRealApi) {
      throw UnimplementedError('Mock 모드에서는 카테고리별 조회를 지원하지 않습니다');
    }

    try {
      debugPrint('[InterestApiService] 📡 카테고리별 관심사 조회 API 호출: $category');

      final response = await _dio.get('/api/interests/categories/$category');

      debugPrint('[InterestApiService] ✅ 카테고리별 관심사 조회 성공');

      return GetInterestsByCategoryResponse.fromJson(response.data);
    } on DioException catch (e) {
      ApiLogger.logDioError(e, context: 'InterestApiService.getInterestsByCategory');
      if (e.response != null) {
        final apiError = ApiError.fromDioError(e.response!.data);
        throw Exception(apiError.message);
      }
      throw Exception('카테고리 관심사를 가져올 수 없습니다.');
    }
  }

  /// Mock 전체 관심사 데이터
  ///
  /// 실제 API 응답 형식과 동일하게 구성
  Future<GetAllInterestsResponse> _mockGetAllInterests() async {
    await Future.delayed(const Duration(milliseconds: 300));

    debugPrint('[InterestApiService] 🎭 Mock 전체 관심사 데이터 반환');

    return const GetAllInterestsResponse(
      categories: [
        InterestCategoryDto(
          category: 'FOOD',
          displayName: '맛집/푸드',
          interests: [
            InterestItemDto(id: 'mock-food-1', name: '미슐랭'),
            InterestItemDto(id: 'mock-food-2', name: '로컬 맛집'),
            InterestItemDto(id: 'mock-food-3', name: '스트릿푸드'),
            InterestItemDto(id: 'mock-food-4', name: '비건'),
            InterestItemDto(id: 'mock-food-5', name: '파인다이닝'),
            InterestItemDto(id: 'mock-food-6', name: '전통요리'),
          ],
        ),
        InterestCategoryDto(
          category: 'CAFE_DESSERT',
          displayName: '카페/디저트',
          interests: [
            InterestItemDto(id: 'mock-cafe-1', name: '감성카페'),
            InterestItemDto(id: 'mock-cafe-2', name: '루프탑카페'),
            InterestItemDto(id: 'mock-cafe-3', name: '베이커리'),
            InterestItemDto(id: 'mock-cafe-4', name: '디저트'),
            InterestItemDto(id: 'mock-cafe-5', name: '브런치'),
            InterestItemDto(id: 'mock-cafe-6', name: '티하우스'),
          ],
        ),
        InterestCategoryDto(
          category: 'CULTURE_ART',
          displayName: '문화/예술',
          interests: [
            InterestItemDto(id: 'mock-culture-1', name: '박물관'),
            InterestItemDto(id: 'mock-culture-2', name: '미술관'),
            InterestItemDto(id: 'mock-culture-3', name: '전통문화'),
            InterestItemDto(id: 'mock-culture-4', name: '공연'),
            InterestItemDto(id: 'mock-culture-5', name: '건축'),
            InterestItemDto(id: 'mock-culture-6', name: '갤러리'),
          ],
        ),
        InterestCategoryDto(
          category: 'NATURE_OUTDOOR',
          displayName: '자연/아웃도어',
          interests: [
            InterestItemDto(id: 'mock-nature-1', name: '산'),
            InterestItemDto(id: 'mock-nature-2', name: '바다'),
            InterestItemDto(id: 'mock-nature-3', name: '호수'),
            InterestItemDto(id: 'mock-nature-4', name: '계곡'),
            InterestItemDto(id: 'mock-nature-5', name: '캠핑'),
            InterestItemDto(id: 'mock-nature-6', name: '트레킹'),
          ],
        ),
        InterestCategoryDto(
          category: 'URBAN_PHOTOSPOTS',
          displayName: '도시산책/포토스팟',
          interests: [
            InterestItemDto(id: 'mock-photo-1', name: '전망대'),
            InterestItemDto(id: 'mock-photo-2', name: '포토스팟'),
            InterestItemDto(id: 'mock-photo-3', name: '일몰'),
            InterestItemDto(id: 'mock-photo-4', name: '야경'),
            InterestItemDto(id: 'mock-photo-5', name: '꽃구경'),
            InterestItemDto(id: 'mock-photo-6', name: '랜드마크'),
          ],
        ),
        InterestCategoryDto(
          category: 'LOCAL_MARKET',
          displayName: '로컬시장/골목',
          interests: [
            InterestItemDto(id: 'mock-local-1', name: '전통시장'),
            InterestItemDto(id: 'mock-local-2', name: '골목탐방'),
            InterestItemDto(id: 'mock-local-3', name: '동네맛집'),
            InterestItemDto(id: 'mock-local-4', name: '벼룩시장'),
            InterestItemDto(id: 'mock-local-5', name: '야시장'),
            InterestItemDto(id: 'mock-local-6', name: '로컬푸드'),
          ],
        ),
        InterestCategoryDto(
          category: 'HISTORY_ARCHITECTURE',
          displayName: '역사/건축/종교',
          interests: [
            InterestItemDto(id: 'mock-history-1', name: '고궁'),
            InterestItemDto(id: 'mock-history-2', name: '성'),
            InterestItemDto(id: 'mock-history-3', name: '사원'),
            InterestItemDto(id: 'mock-history-4', name: '유적지'),
            InterestItemDto(id: 'mock-history-5', name: '역사거리'),
            InterestItemDto(id: 'mock-history-6', name: '종교건축'),
          ],
        ),
        InterestCategoryDto(
          category: 'EXPERIENCE_CLASS',
          displayName: '체험/클래스',
          interests: [
            InterestItemDto(id: 'mock-exp-1', name: '쿠킹클래스'),
            InterestItemDto(id: 'mock-exp-2', name: '공방체험'),
            InterestItemDto(id: 'mock-exp-3', name: '시티투어'),
            InterestItemDto(id: 'mock-exp-4', name: '와이너리'),
            InterestItemDto(id: 'mock-exp-5', name: '농장체험'),
            InterestItemDto(id: 'mock-exp-6', name: '전통체험'),
          ],
        ),
        InterestCategoryDto(
          category: 'SHOPPING_FASHION',
          displayName: '쇼핑/패션',
          interests: [
            InterestItemDto(id: 'mock-shop-1', name: '백화점'),
            InterestItemDto(id: 'mock-shop-2', name: '아울렛'),
            InterestItemDto(id: 'mock-shop-3', name: '면세점'),
            InterestItemDto(id: 'mock-shop-4', name: '빈티지샵'),
            InterestItemDto(id: 'mock-shop-5', name: '명품'),
            InterestItemDto(id: 'mock-shop-6', name: '편집샵'),
          ],
        ),
        InterestCategoryDto(
          category: 'WELLNESS',
          displayName: '웰니스/휴식',
          interests: [
            InterestItemDto(id: 'mock-wellness-1', name: '스파'),
            InterestItemDto(id: 'mock-wellness-2', name: '마사지'),
            InterestItemDto(id: 'mock-wellness-3', name: '요가'),
            InterestItemDto(id: 'mock-wellness-4', name: '명상'),
            InterestItemDto(id: 'mock-wellness-5', name: '사우나'),
            InterestItemDto(id: 'mock-wellness-6', name: '힐링리조트'),
          ],
        ),
        InterestCategoryDto(
          category: 'NIGHTLIFE',
          displayName: '나이트라이프/음주',
          interests: [
            InterestItemDto(id: 'mock-night-1', name: '클럽'),
            InterestItemDto(id: 'mock-night-2', name: '바'),
            InterestItemDto(id: 'mock-night-3', name: '루프탑'),
            InterestItemDto(id: 'mock-night-4', name: '재즈바'),
            InterestItemDto(id: 'mock-night-5', name: 'DJ공연'),
            InterestItemDto(id: 'mock-night-6', name: '칵테일바'),
          ],
        ),
        InterestCategoryDto(
          category: 'DRIVE_SUBURBS',
          displayName: '드라이브/근교',
          interests: [
            InterestItemDto(id: 'mock-drive-1', name: '드라이브코스'),
            InterestItemDto(id: 'mock-drive-2', name: '근교여행'),
            InterestItemDto(id: 'mock-drive-3', name: '해안도로'),
            InterestItemDto(id: 'mock-drive-4', name: '시골마을'),
            InterestItemDto(id: 'mock-drive-5', name: '전원카페'),
            InterestItemDto(id: 'mock-drive-6', name: '숨은명소'),
          ],
        ),
        InterestCategoryDto(
          category: 'FAMILY_KIDS',
          displayName: '가족/아이동반',
          interests: [
            InterestItemDto(id: 'mock-family-1', name: '놀이공원'),
            InterestItemDto(id: 'mock-family-2', name: '워터파크'),
            InterestItemDto(id: 'mock-family-3', name: '동물원'),
            InterestItemDto(id: 'mock-family-4', name: '수족관'),
            InterestItemDto(id: 'mock-family-5', name: '키즈카페'),
            InterestItemDto(id: 'mock-family-6', name: '체험학습'),
          ],
        ),
        InterestCategoryDto(
          category: 'KPOP_CULTURE',
          displayName: 'K-pop/K-컬처',
          interests: [
            InterestItemDto(id: 'mock-kpop-1', name: 'K-pop명소'),
            InterestItemDto(id: 'mock-kpop-2', name: '드라마촬영지'),
            InterestItemDto(id: 'mock-kpop-3', name: '한류스타'),
            InterestItemDto(id: 'mock-kpop-4', name: 'K-뷰티'),
            InterestItemDto(id: 'mock-kpop-5', name: 'K-패션'),
            InterestItemDto(id: 'mock-kpop-6', name: 'K-푸드'),
          ],
        ),
      ],
    );
  }
}
