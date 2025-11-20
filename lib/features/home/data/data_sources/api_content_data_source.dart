import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:tripgether/core/errors/api_error.dart';
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
          const String.fromEnvironment(
            'API_BASE_URL',
            defaultValue: 'https://api.tripgether.suhsaechan.kr',
          ),
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
      if (e.response != null) {
        debugPrint('[ApiContentDataSource] ❌ 서버 응답 전체:');
        debugPrint("Response body : '${e.response!.toString()}'");

        debugPrint('  - Status Code: ${e.response!.statusCode}');
        debugPrint('  - Status Message: ${e.response!.statusMessage}');
        debugPrint('  - Response Data: ${e.response!.data}');
        debugPrint('  - Headers: ${e.response!.headers}');
        // 서버에서 에러 응답을 받은 경우 - ApiError 활용
        final apiError = ApiError.fromDioError(e.response!.data);
        debugPrint('[ApiContentDataSource] ❌ 에러 코드: ${apiError.code}');
        debugPrint('[ApiContentDataSource] ❌ 에러 메시지: ${apiError.message}');
        throw Exception(apiError.message);
      } else {
        debugPrint('[ApiContentDataSource] ❌ 네트워크 오류: ${e.message}');
        throw Exception('네트워크 연결을 확인해주세요.');
      }
    } catch (e) {
      debugPrint('[ApiContentDataSource] ❌ 예외 발생: $e');
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
      if (e.response != null) {
        debugPrint('[ApiContentDataSource] ❌ 서버 응답 전체:');
        debugPrint("Response body : '${e.response!.toString()}'");

        debugPrint('  - Status Code: ${e.response!.statusCode}');
        debugPrint('  - Status Message: ${e.response!.statusMessage}');
        debugPrint('  - Response Data: ${e.response!.data}');
        debugPrint('  - Headers: ${e.response!.headers}');
        // 서버에서 에러 응답을 받은 경우 - ApiError 활용
        final apiError = ApiError.fromDioError(e.response!.data);
        debugPrint('[ApiContentDataSource] ❌ 에러 코드: ${apiError.code}');
        debugPrint('[ApiContentDataSource] ❌ 에러 메시지: ${apiError.message}');
        throw Exception(apiError.message);
      } else {
        debugPrint('[ApiContentDataSource] ❌ 네트워크 오류: ${e.message}');
        throw Exception('네트워크 연결을 확인해주세요.');
      }
    } catch (e) {
      debugPrint('[ApiContentDataSource] ❌ 예외 발생: $e');
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
      if (e.response != null) {
        debugPrint('[ApiContentDataSource] ❌ 서버 응답 전체:');
        debugPrint("Response body : '${e.response!.toString()}'");

        debugPrint('  - Status Code: ${e.response!.statusCode}');
        debugPrint('  - Status Message: ${e.response!.statusMessage}');
        debugPrint('  - Response Data: ${e.response!.data}');
        debugPrint('  - Headers: ${e.response!.headers}');
        // 서버에서 에러 응답을 받은 경우 - ApiError 활용
        final apiError = ApiError.fromDioError(e.response!.data);
        debugPrint('[ApiContentDataSource] ❌ 에러 코드: ${apiError.code}');
        debugPrint('[ApiContentDataSource] ❌ 에러 메시지: ${apiError.message}');
        throw Exception(apiError.message);
      } else {
        debugPrint('[ApiContentDataSource] ❌ 네트워크 오류: ${e.message}');
        throw Exception('네트워크 연결을 확인해주세요.');
      }
    } catch (e) {
      debugPrint('[ApiContentDataSource] ❌ 예외 발생: $e');
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
      if (e.response != null) {
        debugPrint('[ApiContentDataSource] ❌ 서버 응답 전체:');
        debugPrint("Response body : '${e.response!.toString()}'");

        debugPrint('  - Status Code: ${e.response!.statusCode}');
        debugPrint('  - Status Message: ${e.response!.statusMessage}');
        debugPrint('  - Response Data: ${e.response!.data}');
        debugPrint('  - Headers: ${e.response!.headers}');
        // 서버에서 에러 응답을 받은 경우 - ApiError 활용
        final apiError = ApiError.fromDioError(e.response!.data);
        debugPrint('[ApiContentDataSource] ❌ 에러 코드: ${apiError.code}');
        debugPrint('[ApiContentDataSource] ❌ 에러 메시지: ${apiError.message}');
        throw Exception(apiError.message);
      } else {
        debugPrint('[ApiContentDataSource] ❌ 네트워크 오류: ${e.message}');
        throw Exception('네트워크 연결을 확인해주세요.');
      }
    } catch (e) {
      debugPrint('[ApiContentDataSource] ❌ 예외 발생: $e');
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
      if (e.response != null) {
        debugPrint('[ApiContentDataSource] ❌ 서버 응답 전체:');
        debugPrint("Response body : '${e.response!.toString()}'");

        debugPrint('  - Status Code: ${e.response!.statusCode}');
        debugPrint('  - Status Message: ${e.response!.statusMessage}');
        debugPrint('  - Response Data: ${e.response!.data}');
        debugPrint('  - Headers: ${e.response!.headers}');
        // 서버에서 에러 응답을 받은 경우 - ApiError 활용
        final apiError = ApiError.fromDioError(e.response!.data);
        debugPrint('[ApiContentDataSource] ❌ 에러 코드: ${apiError.code}');
        debugPrint('[ApiContentDataSource] ❌ 에러 메시지: ${apiError.message}');
        throw Exception(apiError.message);
      } else {
        debugPrint('[ApiContentDataSource] ❌ 네트워크 오류: ${e.message}');
        throw Exception('네트워크 연결을 확인해주세요.');
      }
    } catch (e) {
      debugPrint('[ApiContentDataSource] ❌ 예외 발생: $e');
      rethrow;
    }
  }
}
