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
      // 환경 변수에 따라 데이터 소스 선택
      const useMock = bool.fromEnvironment('USE_MOCK_API', defaultValue: true);
      _dataSource = useMock
          ? MockContentDataSource()
          : ApiContentDataSource();
    }
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
      return await _dataSource.addContent(
        url: url,
        platform: platform,
      );
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