import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../core/models/content_model.dart';
import '../../../../core/models/place_model.dart';
import '../../data/repositories/content_repository.dart';

part 'content_provider.g.dart';

/// ContentRepository 인스턴스를 제공하는 Provider
final contentRepositoryProvider = Provider<ContentRepository>((ref) {
  return ContentRepository();
});

/// 최근 콘텐츠 목록을 제공하는 Provider (최신 10개)
@riverpod
class ContentList extends _$ContentList {
  @override
  Future<List<ContentModel>> build() async {
    final repository = ref.read(contentRepositoryProvider);
    return await repository.getRecentContents();
  }

  /// 콘텐츠 목록 새로고침
  Future<void> refresh() async {
    ref.invalidateSelf();
  }

  /// 새 콘텐츠 분석 요청
  ///
  /// Share Extension이나 수동 URL 입력으로 공유된 URL을 백엔드로 전송합니다.
  ///
  /// Returns: 생성된 contentId (백엔드 UUID)
  /// - NotificationScreen에서 알림 아이템에 contentId를 저장할 때 사용
  /// - FCM 알림 수신 시 GET /api/content/{contentId} 호출에 사용
  Future<String> analyzeUrl(String snsUrl) async {
    final repository = ref.read(contentRepositoryProvider);

    try {
      // 백엔드로 URL 전송하고 생성된 콘텐츠 받기
      final newContent = await repository.analyzeSharedUrl(snsUrl);

      // 성공 시 콘텐츠 목록 새로고침
      await refresh();

      // contentId 반환 (NotificationScreen에서 사용)
      return newContent.contentId;
    } catch (e) {
      rethrow;
    }
  }

  /// 콘텐츠 삭제
  Future<void> deleteContent(String contentId) async {
    final repository = ref.read(contentRepositoryProvider);

    // 낙관적 업데이트
    state = AsyncValue.data(
      state.value?.where((c) => c.contentId != contentId).toList() ?? [],
    );

    try {
      await repository.deleteContent(contentId);
    } catch (e) {
      // 실패 시 복원
      await refresh();
      rethrow;
    }
  }
}

/// 특정 콘텐츠를 제공하는 Provider
@riverpod
Future<ContentModel> contentDetail(Ref ref, String contentId) async {
  final repository = ref.read(contentRepositoryProvider);
  return await repository.getContentById(contentId);
}

/// 저장된 장소 목록을 제공하는 Provider
///
/// 백엔드 API (GET /api/content/place/saved)에서 저장된 장소를 조회합니다.
/// USE_MOCK_API 플래그에 따라 Mock 또는 실제 API 데이터를 사용합니다.
@riverpod
Future<List<PlaceModel>> savedPlaces(Ref ref) async {
  final repository = ref.read(contentRepositoryProvider);
  return await repository.getSavedPlaces();
}

/// 최근 저장한 장소 (최신 3개)
///
/// savedPlaces 중에서 최신 3개만 반환합니다.
@riverpod
Future<List<PlaceModel>> recentSavedPlaces(Ref ref) async {
  final repository = ref.read(contentRepositoryProvider);
  final allPlaces = await repository.getSavedPlaces();

  // 최근 3개만 반환
  return allPlaces.take(3).toList();
}
