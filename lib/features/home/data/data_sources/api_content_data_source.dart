import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:tripgether/core/errors/api_error.dart';
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
      ApiLogger.logDioError(e, context: 'ApiContentDataSource.getContents');
      if (e.response != null) {
        final apiError = ApiError.fromDioError(e.response!.data);
        throw Exception(apiError.message);
      } else {
        throw Exception('네트워크 연결을 확인해주세요.');
      }
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
      ApiLogger.logDioError(e, context: 'ApiContentDataSource.getContentById');
      if (e.response != null) {
        final apiError = ApiError.fromDioError(e.response!.data);
        throw Exception(apiError.message);
      } else {
        throw Exception('네트워크 연결을 확인해주세요.');
      }
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
      ApiLogger.logDioError(e, context: 'ApiContentDataSource.addContent');
      if (e.response != null) {
        final apiError = ApiError.fromDioError(e.response!.data);
        throw Exception(apiError.message);
      } else {
        throw Exception('네트워크 연결을 확인해주세요.');
      }
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
      ApiLogger.logDioError(
        e,
        context: 'ApiContentDataSource.updateContentStatus',
      );
      if (e.response != null) {
        final apiError = ApiError.fromDioError(e.response!.data);
        throw Exception(apiError.message);
      } else {
        throw Exception('네트워크 연결을 확인해주세요.');
      }
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
      ApiLogger.logDioError(e, context: 'ApiContentDataSource.deleteContent');
      if (e.response != null) {
        final apiError = ApiError.fromDioError(e.response!.data);
        throw Exception(apiError.message);
      } else {
        throw Exception('네트워크 연결을 확인해주세요.');
      }
    } catch (e) {
      ApiLogger.logException(e, context: 'ApiContentDataSource.deleteContent');
      rethrow;
    }
  }
}
