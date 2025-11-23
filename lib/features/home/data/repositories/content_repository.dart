import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../../../../core/models/content_model.dart';
import '../data_sources/content_data_source.dart';
import '../data_sources/mock_content_data_source.dart';
import '../data_sources/api_content_data_source.dart';

/// 콘텐츠 저장소 구현
///
/// 환경 변수에 따라 Mock 또는 API 데이터 소스를 사용합니다.
/// Repository Pattern을 통해 데이터 소스를 추상화합니다.
class ContentRepository {
  late final ContentDataSource _dataSource;

  ContentRepository({ContentDataSource? dataSource}) {
    if (dataSource != null) {
      _dataSource = dataSource;
    } else {
      // 환경 변수에 따라 데이터 소스 선택 (우선순위: dart-define → .env → 기본값)
      _dataSource = _useMockApi() ? MockContentDataSource() : ApiContentDataSource();
    }
  }

  /// Mock API 사용 여부
  ///
  /// **우선순위**:
  /// 1. dart-define: `--dart-define=USE_MOCK_API=true`
  /// 2. .env: `USE_MOCK_API=true`
  /// 3. 기본값: true (Mock 모드)
  bool _useMockApi() {
    // 1순위: dart-define 확인
    const dartDefine = String.fromEnvironment('USE_MOCK_API');
    if (dartDefine.isNotEmpty) {
      debugPrint('[ContentRepository] 🔧 USE_MOCK_API from dart-define: $dartDefine');
      return dartDefine.toLowerCase() == 'true';
    }

    // 2순위: .env 확인
    final envValue = dotenv.env['USE_MOCK_API'];
    if (envValue != null) {
      debugPrint('[ContentRepository] 🔧 USE_MOCK_API from .env: $envValue');
      return envValue.toLowerCase() == 'true';
    }

    // 3순위: 기본값 (Mock 모드)
    debugPrint('[ContentRepository] 🔧 USE_MOCK_API using default: true');
    return true;
  }

  /// 모든 콘텐츠 목록 조회
  Future<List<ContentModel>> getContents() async {
    try {
      return await _dataSource.getContents();
    } catch (e) {
      // 에러 처리 및 로깅
      rethrow;
    }
  }

  /// 특정 콘텐츠 조회
  Future<ContentModel> getContentById(String contentId) async {
    try {
      return await _dataSource.getContentById(contentId);
    } catch (e) {
      rethrow;
    }
  }

  /// 콘텐츠 추가
  Future<ContentModel> addContent({
    required String url,
    required String platform,
  }) async {
    try {
      return await _dataSource.addContent(url: url, platform: platform);
    } catch (e) {
      rethrow;
    }
  }

  /// 콘텐츠 상태 업데이트
  Future<ContentModel> updateContentStatus({
    required String contentId,
    required String status,
  }) async {
    try {
      return await _dataSource.updateContentStatus(
        contentId: contentId,
        status: status,
      );
    } catch (e) {
      rethrow;
    }
  }

  /// 콘텐츠 삭제
  Future<void> deleteContent(String contentId) async {
    try {
      await _dataSource.deleteContent(contentId);
    } catch (e) {
      rethrow;
    }
  }

  /// PENDING 상태인 콘텐츠만 필터링
  Future<List<ContentModel>> getPendingContents() async {
    final contents = await getContents();
    return contents.where((c) => c.status == ContentStatus.pending).toList();
  }

  /// COMPLETED 상태인 콘텐츠만 필터링
  Future<List<ContentModel>> getCompletedContents() async {
    final contents = await getContents();
    return contents.where((c) => c.status == ContentStatus.completed).toList();
  }

  /// 특정 플랫폼의 콘텐츠만 필터링
  Future<List<ContentModel>> getContentsByPlatform(String platform) async {
    final contents = await getContents();
    return contents.where((c) => c.platform == platform).toList();
  }
}
