import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:tripgether/core/utils/api_logger.dart';
import '../../../../core/models/content_model.dart';
import 'content_data_source.dart';

/// API 데이터 소스 구현
///
/// 실제 백엔드 API와 통신합니다.
/// USE_MOCK_API=false 일 때 사용됩니다.
class ApiContentDataSource implements ContentDataSource {
  final String baseUrl;
  final Dio dio;

  ApiContentDataSource({String? baseUrl, Dio? dio})
    : baseUrl =
          baseUrl ??
          dotenv.env['API_BASE_URL'] ??
          'https://api.tripgether.suhsaechan.kr',
      dio = dio ?? Dio();

  @override
  Future<List<ContentModel>> getContents() async {
    try {
      final response = await dio.get(
        '$baseUrl/api/contents',
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            // 인증 토큰은 인터셉터에서 처리
          },
        ),
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = response.data as List<dynamic>;
        return jsonList.map((json) {
          return ContentModel.fromJson(json as Map<String, dynamic>);
        }).toList();
      } else {
        throw Exception('Failed to load contents: ${response.statusCode}');
      }
    } on DioException catch (e) {
      ApiLogger.throwFromDioError(
        e,
        context: 'ApiContentDataSource.getContents',
      );
    } catch (e) {
      ApiLogger.logException(e, context: 'ApiContentDataSource.getContents');
      rethrow;
    }
  }

  @override
  Future<ContentModel> getContentById(String contentId) async {
    try {
      final response = await dio.get(
        '$baseUrl/api/contents/$contentId',
        options: Options(headers: {'Content-Type': 'application/json'}),
      );

      if (response.statusCode == 200) {
        return ContentModel.fromJson(response.data);
      } else {
        throw Exception('Failed to load content: ${response.statusCode}');
      }
    } on DioException catch (e) {
      ApiLogger.throwFromDioError(
        e,
        context: 'ApiContentDataSource.getContentById',
      );
    } catch (e) {
      ApiLogger.logException(e, context: 'ApiContentDataSource.getContentById');
      rethrow;
    }
  }

  @override
  Future<ContentModel> addContent({
    required String url,
    required String platform,
  }) async {
    try {
      final response = await dio.post(
        '$baseUrl/api/contents',
        options: Options(headers: {'Content-Type': 'application/json'}),
        data: {'url': url, 'platform': platform},
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        return ContentModel.fromJson(response.data);
      } else {
        throw Exception('Failed to add content: ${response.statusCode}');
      }
    } on DioException catch (e) {
      ApiLogger.throwFromDioError(
        e,
        context: 'ApiContentDataSource.addContent',
      );
    } catch (e) {
      ApiLogger.logException(e, context: 'ApiContentDataSource.addContent');
      rethrow;
    }
  }

  @override
  Future<ContentModel> updateContentStatus({
    required String contentId,
    required String status,
  }) async {
    try {
      final response = await dio.patch(
        '$baseUrl/api/contents/$contentId',
        options: Options(headers: {'Content-Type': 'application/json'}),
        data: {'status': status},
      );

      if (response.statusCode == 200) {
        return ContentModel.fromJson(response.data);
      } else {
        throw Exception('Failed to update content: ${response.statusCode}');
      }
    } on DioException catch (e) {
      ApiLogger.throwFromDioError(
        e,
        context: 'ApiContentDataSource.updateContentStatus',
      );
    } catch (e) {
      ApiLogger.logException(
        e,
        context: 'ApiContentDataSource.updateContentStatus',
      );
      rethrow;
    }
  }

  @override
  Future<void> deleteContent(String contentId) async {
    try {
      final response = await dio.delete(
        '$baseUrl/api/contents/$contentId',
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
  Future<ContentModel> analyzeSharedUrl({required String snsUrl}) async {
    try {
      debugPrint('📤 [ApiContentDataSource] URL 분석 요청: $snsUrl');
      
      // API 요청 데이터 준비
      // Note: API 문서에는 contentId가 필수로 명시되어 있지만,
      // 실제로는 백엔드가 콘텐츠를 생성하므로 snsUrl만 전송
      // 만약 contentId가 필요하다면 백엔드에서 적절히 처리
      final requestData = {'snsUrl': snsUrl};
      
      debugPrint('📤 [ApiContentDataSource] 요청 데이터: $requestData');
      
      final response = await dio.post(
        '$baseUrl/api/content/analyze',
        options: Options(headers: {'Content-Type': 'application/json'}),
        data: requestData,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        // API 응답 데이터 파싱
        final Map<String, dynamic> responseData = response.data as Map<String, dynamic>;
        
        // contentId와 platform이 null일 수 있으므로 안전하게 처리
        final contentId = responseData['contentId'] as String? ?? '';
        final platform = responseData['platform'] as String? ?? 'UNKNOWN';
        final status = responseData['status'] as String? ?? 'PENDING';
        
        // 필수 필드가 없으면 기본값으로 ContentModel 생성
        return ContentModel.fromJson({
          ...responseData,
          'contentId': contentId,
          'platform': platform,
          'status': status,
        });
      } else {
        throw Exception('Failed to analyze shared URL: ${response.statusCode}');
      }
    } on DioException catch (e) {
      ApiLogger.throwFromDioError(
        e,
        context: 'ApiContentDataSource.analyzeSharedUrl',
      );
    } catch (e) {
      debugPrint('[ApiContentDataSource.analyzeSharedUrl] ❌ 예외 발생: $e');
      ApiLogger.logException(e, context: 'ApiContentDataSource.analyzeSharedUrl');
      rethrow;
    }
  }
}
