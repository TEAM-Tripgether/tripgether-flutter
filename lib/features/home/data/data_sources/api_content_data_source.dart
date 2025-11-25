import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:tripgether/core/utils/api_logger.dart';
import '../../../../core/models/content_model.dart';
import '../../../../core/models/place_model.dart';
import '../../../../core/network/auth_interceptor.dart';
import 'content_data_source.dart';

/// API 데이터 소스 구현
///
/// 실제 백엔드 API와 통신합니다.
/// USE_MOCK_API=false 일 때 사용됩니다.
/// 백엔드 API 명세(docs/BackendAPI.md)에 따라 구현되었습니다.
class ApiContentDataSource implements ContentDataSource {
  final String baseUrl;
  final Dio dio;

  ApiContentDataSource({String? baseUrl, Dio? dio})
    : baseUrl =
          baseUrl ??
          dotenv.env['API_BASE_URL'] ??
          'https://api.tripgether.suhsaechan.kr',
      dio = dio ?? Dio() {
    // AuthInterceptor 추가 (JWT 토큰 자동 주입 + 자동 토큰 재발급)
    this.dio.interceptors.add(AuthInterceptor(baseUrl: this.baseUrl));
  }

  @override
  Future<ContentModel> analyzeSharedUrl({required String snsUrl}) async {
    try {
      debugPrint('═══════════════════════════════════════════════════════');
      debugPrint('[API] 📤 POST /api/content/analyze 요청');
      debugPrint('[API] 📦 Request Body: {"snsUrl": "$snsUrl"}');

      final response = await dio.post(
        '$baseUrl/api/content/analyze',
        options: Options(headers: {'Content-Type': 'application/json'}),
        data: {'snsUrl': snsUrl},
      );

      debugPrint('[API] 📥 Response Status: ${response.statusCode}');
      debugPrint('[API] 📥 Response Headers: ${response.headers}');
      debugPrint('[API] 📥 Response Data Type: ${response.data.runtimeType}');
      debugPrint('[API] 📥 Response Data: ${response.data}');

      if (response.statusCode == 201 || response.statusCode == 200) {
        // ✅ 안전한 JSON 파싱 (null 값을 명시적으로 처리)
        final Map<String, dynamic> responseData =
            response.data as Map<String, dynamic>;

        debugPrint(
          '[API] 📋 Parsed Response Keys: ${responseData.keys.toList()}',
        );
        debugPrint('[API] 📋 contentId: ${responseData['contentId']}');
        debugPrint('[API] 📋 status: ${responseData['status']}');
        debugPrint('[API] 📋 title: ${responseData['title']}');
        debugPrint('[API] 📋 snsUrl: ${responseData['snsUrl']}');

        // null 값을 안전하게 제거하여 freezed의 기본값 적용
        final safeData = Map<String, dynamic>.from(responseData)
          ..removeWhere((key, value) => value == null);

        debugPrint('[API] ✅ ContentModel 파싱 시작');
        final content = ContentModel.fromJson(safeData);
        debugPrint('[API] ✅ ContentModel 파싱 성공');
        debugPrint(
          '[API] ✅ 파싱 결과 - contentId: ${content.contentId}, status: ${content.status}',
        );
        debugPrint('═══════════════════════════════════════════════════════');

        return content;
      } else {
        debugPrint('[API] ❌ 실패 - Status: ${response.statusCode}');
        debugPrint('═══════════════════════════════════════════════════════');
        throw Exception('Failed to analyze URL: ${response.statusCode}');
      }
    } on DioException catch (e) {
      debugPrint('[API] ❌ DioException 발생');
      debugPrint('[API] ❌ Error Type: ${e.type}');
      debugPrint('[API] ❌ Error Message: ${e.message}');
      debugPrint('[API] ❌ Response: ${e.response?.data}');
      debugPrint('═══════════════════════════════════════════════════════');
      ApiLogger.throwFromDioError(
        e,
        context: 'ApiContentDataSource.analyzeSharedUrl',
      );
    } catch (e) {
      debugPrint('[API] ❌ Exception 발생: $e');
      debugPrint('═══════════════════════════════════════════════════════');
      ApiLogger.logException(
        e,
        context: 'ApiContentDataSource.analyzeSharedUrl',
      );
      rethrow;
    }
  }

  @override
  Future<List<ContentModel>> getRecentContents() async {
    try {
      final response = await dio.get(
        '$baseUrl/api/content/recent',
        options: Options(headers: {'Content-Type': 'application/json'}),
      );

      if (response.statusCode == 200) {
        // 백엔드 응답: { "contents": [ ... ] }
        final Map<String, dynamic> responseData =
            response.data as Map<String, dynamic>;
        final List<dynamic> jsonList =
            responseData['contents'] as List<dynamic>;

        return jsonList.map((json) {
          return ContentModel.fromJson(json as Map<String, dynamic>);
        }).toList();
      } else {
        throw Exception(
          'Failed to load recent contents: ${response.statusCode}',
        );
      }
    } on DioException catch (e) {
      ApiLogger.throwFromDioError(
        e,
        context: 'ApiContentDataSource.getRecentContents',
      );
    } catch (e) {
      ApiLogger.logException(
        e,
        context: 'ApiContentDataSource.getRecentContents',
      );
      rethrow;
    }
  }

  /// 특정 콘텐츠 상세 조회
  ///
  /// GET /api/content/{contentId} API 호출
  /// 응답 구조: { "content": {...}, "places": [...] }
  /// content 객체와 places 배열을 합쳐서 ContentModel로 변환합니다.
  @override
  Future<ContentModel> getContentById(String contentId) async {
    try {
      debugPrint('═══════════════════════════════════════════════════════');
      debugPrint('[API] 📤 GET /api/content/$contentId 요청');

      final response = await dio.get(
        '$baseUrl/api/content/$contentId',
        options: Options(headers: {'Content-Type': 'application/json'}),
      );

      debugPrint('[API] 📥 Response Status: ${response.statusCode}');
      debugPrint('[API] 📥 Response Data: ${response.data}');

      if (response.statusCode == 200) {
        // 백엔드 응답 구조: { "content": {...}, "places": [...] }
        final Map<String, dynamic> responseData =
            response.data as Map<String, dynamic>;

        // content 객체 추출
        final Map<String, dynamic> contentJson =
            responseData['content'] as Map<String, dynamic>;

        // places 배열 추출 (없으면 빈 배열)
        final List<dynamic> placesJson =
            responseData['places'] as List<dynamic>? ?? [];

        debugPrint('[API] 📋 content keys: ${contentJson.keys.toList()}');
        debugPrint('[API] 📋 places count: ${placesJson.length}');

        // places를 content에 추가하여 ContentModel 생성
        contentJson['places'] = placesJson;

        final content = ContentModel.fromJson(contentJson);
        debugPrint('[API] ✅ ContentModel 파싱 성공');
        debugPrint('[API] ✅ contentId: ${content.contentId}');
        debugPrint('[API] ✅ places count: ${content.places.length}');
        debugPrint('═══════════════════════════════════════════════════════');

        return content;
      } else {
        debugPrint('[API] ❌ 실패 - Status: ${response.statusCode}');
        debugPrint('═══════════════════════════════════════════════════════');
        throw Exception('Failed to load content: ${response.statusCode}');
      }
    } on DioException catch (e) {
      debugPrint('[API] ❌ DioException 발생: ${e.message}');
      debugPrint('═══════════════════════════════════════════════════════');
      ApiLogger.throwFromDioError(
        e,
        context: 'ApiContentDataSource.getContentById',
      );
    } catch (e) {
      debugPrint('[API] ❌ Exception 발생: $e');
      debugPrint('═══════════════════════════════════════════════════════');
      ApiLogger.logException(e, context: 'ApiContentDataSource.getContentById');
      rethrow;
    }
  }

  /// 저장한 장소 목록 조회
  ///
  /// GET /api/place/saved API 호출
  /// MemberPlace 기반으로 사용자가 명시적으로 저장한 장소만 조회합니다.
  /// 응답에는 기본 정보(placeId, name, address, rating, photoUrls, description)만 포함됩니다.
  /// 상세 정보(latitude, longitude, businessHours 등)가 필요하면 getPlaceById() 추가 호출 필요.
  @override
  Future<List<PlaceModel>> getSavedPlaces() async {
    try {
      final response = await dio.get(
        '$baseUrl/api/place/saved',
        options: Options(headers: {'Content-Type': 'application/json'}),
      );

      if (response.statusCode == 200) {
        // 백엔드 응답: { "places": [ ... ] }
        final Map<String, dynamic> responseData =
            response.data as Map<String, dynamic>;
        final List<dynamic> jsonList = responseData['places'] as List<dynamic>;

        return jsonList.map((json) {
          return PlaceModel.fromJson(json as Map<String, dynamic>);
        }).toList();
      } else {
        throw Exception('Failed to load saved places: ${response.statusCode}');
      }
    } on DioException catch (e) {
      ApiLogger.throwFromDioError(
        e,
        context: 'ApiContentDataSource.getSavedPlaces',
      );
    } catch (e) {
      ApiLogger.logException(e, context: 'ApiContentDataSource.getSavedPlaces');
      rethrow;
    }
  }

  @override
  Future<void> deleteContent(String contentId) async {
    try {
      final response = await dio.delete(
        '$baseUrl/api/content/$contentId',
        options: Options(headers: {'Content-Type': 'application/json'}),
      );

      if (response.statusCode != 204 && response.statusCode != 200) {
        throw Exception('Failed to delete content: ${response.statusCode}');
      }
    } on DioException catch (e) {
      ApiLogger.throwFromDioError(
        e,
        context: 'ApiContentDataSource.deleteContent',
      );
    } catch (e) {
      ApiLogger.logException(e, context: 'ApiContentDataSource.deleteContent');
      rethrow;
    }
  }

  @override
  Future<PlaceModel> getPlaceById(String placeId) async {
    try {
      debugPrint('═══════════════════════════════════════════════════════');
      debugPrint('[API] 📤 GET /api/place/$placeId 요청');

      final response = await dio.get(
        '$baseUrl/api/place/$placeId',
        options: Options(headers: {'Content-Type': 'application/json'}),
      );

      debugPrint('[API] 📥 Response Status: ${response.statusCode}');
      debugPrint('[API] 📥 Response Data: ${response.data}');

      if (response.statusCode == 200) {
        final place = PlaceModel.fromJson(
          response.data as Map<String, dynamic>,
        );
        debugPrint('[API] ✅ PlaceModel 파싱 성공 - name: ${place.name}');
        debugPrint('═══════════════════════════════════════════════════════');
        return place;
      } else {
        debugPrint('[API] ❌ 실패 - Status: ${response.statusCode}');
        debugPrint('═══════════════════════════════════════════════════════');
        throw Exception('Failed to load place: ${response.statusCode}');
      }
    } on DioException catch (e) {
      debugPrint('[API] ❌ DioException 발생: ${e.message}');
      debugPrint('═══════════════════════════════════════════════════════');
      ApiLogger.throwFromDioError(
        e,
        context: 'ApiContentDataSource.getPlaceById',
      );
    } catch (e) {
      debugPrint('[API] ❌ Exception 발생: $e');
      debugPrint('═══════════════════════════════════════════════════════');
      ApiLogger.logException(e, context: 'ApiContentDataSource.getPlaceById');
      rethrow;
    }
  }
}
