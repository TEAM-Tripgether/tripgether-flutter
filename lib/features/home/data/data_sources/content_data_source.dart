import '../../../../core/models/content_model.dart';

/// 콘텐츠 데이터 소스 추상 인터페이스
///
/// Mock 데이터 소스와 실제 API 데이터 소스가 구현할 인터페이스입니다.
abstract class ContentDataSource {
  /// 모든 콘텐츠 목록 조회
  Future<List<ContentModel>> getContents();

  /// 특정 콘텐츠 조회
  Future<ContentModel> getContentById(String contentId);

  /// 콘텐츠 추가 (외부 URL 공유 시)
  Future<ContentModel> addContent({
    required String url,
    required String platform,
  });

  /// 콘텐츠 상태 업데이트
  Future<ContentModel> updateContentStatus({
    required String contentId,
    required String status,
  });

  /// 콘텐츠 삭제
  Future<void> deleteContent(String contentId);
}
