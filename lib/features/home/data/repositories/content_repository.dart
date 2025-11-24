import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../../../../core/models/content_model.dart';
import '../../../../core/models/place_model.dart';
import '../data_sources/content_data_source.dart';
import '../data_sources/mock_content_data_source.dart';
import '../data_sources/api_content_data_source.dart';

/// 콘텐츠 저장소 구현
///
/// 환경 변수에 따라 Mock 또는 API 데이터 소스를 사용합니다.
/// Repository Pattern을 통해 데이터 소스를 추상화합니다.
/// 백엔드 API 명세(docs/BackendAPI.md)에 따라 구현되었습니다.
class ContentRepository {
  late final ContentDataSource _dataSource;

  ContentRepository({ContentDataSource? dataSource}) {
    if (dataSource != null) {
      _dataSource = dataSource;
    } else {
      // 환경 변수에 따라 데이터 소스 선택 (우선순위: dart-define → .env → 기본값)
      _dataSource = _useMockApi()
          ? MockContentDataSource()
          : ApiContentDataSource();
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
      debugPrint(
        '[ContentRepository] 🔧 USE_MOCK_API from dart-define: $dartDefine',
      );
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

  /// 공유된 SNS URL 분석 요청
  ///
  /// Share Extension에서 받은 URL을 백엔드로 전송하여 AI 분석을 시작합니다.
  /// 백엔드에서 중복 URL 체크, UUID 생성, AI 분석 등을 처리합니다.
  ///
  /// [snsUrl] 분석할 SNS URL (Instagram, YouTube, TikTok 등)
  /// Returns: PENDING 상태의 ContentModel (분석 진행 중)
  Future<ContentModel> analyzeSharedUrl(String snsUrl) async {
    try {
      debugPrint('📤 [ContentRepository] URL 분석 요청: $snsUrl');
      final result = await _dataSource.analyzeSharedUrl(snsUrl: snsUrl);
      debugPrint('✅ [ContentRepository] URL 분석 요청 완료: ${result.contentId}');
      return result;
    } catch (e) {
      debugPrint('❌ [ContentRepository] URL 분석 실패: $e');
      rethrow;
    }
  }

  /// 최근 콘텐츠 목록 조회 (최신 10개)
  ///
  /// 사용자의 최근 공유된 콘텐츠 목록을 조회합니다.
  /// HomeScreen의 "최근 SNS 콘텐츠" 섹션에서 사용됩니다.
  Future<List<ContentModel>> getRecentContents() async {
    try {
      return await _dataSource.getRecentContents();
    } catch (e) {
      debugPrint('❌ [ContentRepository] 최근 콘텐츠 조회 실패: $e');
      rethrow;
    }
  }

  /// 특정 콘텐츠 상세 조회
  ///
  /// 특정 콘텐츠의 상세 정보와 추출된 장소 목록을 조회합니다.
  /// 콘텐츠 상세 화면에서 사용됩니다.
  Future<ContentModel> getContentById(String contentId) async {
    try {
      return await _dataSource.getContentById(contentId);
    } catch (e) {
      debugPrint('❌ [ContentRepository] 콘텐츠 상세 조회 실패: $e');
      rethrow;
    }
  }

  /// 저장된 장소 목록 조회
  ///
  /// 사용자가 저장한 모든 장소 목록을 조회합니다.
  /// HomeScreen의 "최근 저장한 장소" 섹션에서 사용됩니다.
  Future<List<PlaceModel>> getSavedPlaces() async {
    try {
      return await _dataSource.getSavedPlaces();
    } catch (e) {
      debugPrint('❌ [ContentRepository] 저장된 장소 조회 실패: $e');
      rethrow;
    }
  }

  /// 콘텐츠 삭제
  ///
  /// 특정 콘텐츠를 삭제합니다.
  Future<void> deleteContent(String contentId) async {
    try {
      await _dataSource.deleteContent(contentId);
      debugPrint('✅ [ContentRepository] 콘텐츠 삭제 완료: $contentId');
    } catch (e) {
      debugPrint('❌ [ContentRepository] 콘텐츠 삭제 실패: $e');
      rethrow;
    }
  }
}
