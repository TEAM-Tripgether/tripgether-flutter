import '../../../../core/models/content_model.dart';
import '../../../../core/models/place_model.dart';

/// 콘텐츠 데이터 소스 추상 인터페이스
///
/// Mock 데이터 소스와 실제 API 데이터 소스가 구현할 인터페이스입니다.
/// 백엔드 API 명세(docs/BackendAPI.md)에 따라 정의되었습니다.
abstract class ContentDataSource {
  /// 공유된 SNS URL 분석 요청
  ///
  /// POST /api/content/analyze
  /// 외부 앱에서 공유된 URL을 백엔드로 전송하여 AI 분석을 요청합니다.
  /// 백엔드에서 중복 URL 체크, UUID 생성, AI 분석 등 모든 비즈니스 로직을 처리합니다.
  ///
  /// [snsUrl] 분석할 SNS URL (Instagram, YouTube, TikTok 등)
  /// Returns: PENDING 상태의 ContentModel (분석 진행 중)
  Future<ContentModel> analyzeSharedUrl({required String snsUrl});

  /// 최근 콘텐츠 목록 조회 (최신 10개)
  ///
  /// GET /api/content/recent
  /// 사용자의 최근 공유된 콘텐츠 목록을 조회합니다.
  Future<List<ContentModel>> getRecentContents();

  /// 특정 콘텐츠 상세 조회
  ///
  /// GET /api/content/{contentId}
  /// 특정 콘텐츠의 상세 정보와 추출된 장소 목록을 조회합니다.
  Future<ContentModel> getContentById(String contentId);

  /// 저장된 장소 목록 조회
  ///
  /// GET /api/content/place/saved
  /// 사용자가 저장한 모든 장소 목록을 조회합니다.
  Future<List<PlaceModel>> getSavedPlaces();

  /// 콘텐츠 삭제
  ///
  /// DELETE /api/content/{contentId}
  /// 특정 콘텐츠를 삭제합니다.
  Future<void> deleteContent(String contentId);
}
