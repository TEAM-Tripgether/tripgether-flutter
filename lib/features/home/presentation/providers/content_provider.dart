import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../core/models/content_model.dart';
import '../../data/repositories/content_repository.dart';

part 'content_provider.g.dart';

/// ContentRepository 인스턴스를 제공하는 Provider
final contentRepositoryProvider = Provider<ContentRepository>((ref) {
  return ContentRepository();
});

/// 모든 콘텐츠 목록을 제공하는 Provider
@riverpod
class ContentList extends _$ContentList {
  @override
  Future<List<ContentModel>> build() async {
    final repository = ref.read(contentRepositoryProvider);
    return await repository.getContents();
  }

  /// 콘텐츠 목록 새로고침
  Future<void> refresh() async {
    ref.invalidateSelf();
  }

  /// 새 콘텐츠 추가
  Future<void> addContent({
    required String url,
    required String platform,
  }) async {
    final repository = ref.read(contentRepositoryProvider);

    // 낙관적 업데이트를 위해 먼저 PENDING 상태로 추가
    final pendingContent = ContentModel(
      contentId: DateTime.now().millisecondsSinceEpoch.toString(),
      platform: platform,
      status: ContentStatus.pending,
      originalUrl: url,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    // UI 즉시 업데이트
    state = AsyncValue.data([pendingContent, ...state.value ?? []]);

    try {
      // 실제 API 호출
      await repository.addContent(url: url, platform: platform);

      // 성공 시 실제 데이터로 교체
      await refresh();
    } catch (e) {
      // 실패 시 원래 상태로 복원
      await refresh();
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

/// PENDING 상태인 콘텐츠만 제공하는 Provider
@riverpod
Future<List<ContentModel>> pendingContents(Ref ref) async {
  final repository = ref.read(contentRepositoryProvider);
  return await repository.getPendingContents();
}

/// COMPLETED 상태인 콘텐츠만 제공하는 Provider
@riverpod
Future<List<ContentModel>> completedContents(Ref ref) async {
  final repository = ref.read(contentRepositoryProvider);
  return await repository.getCompletedContents();
}

/// 특정 플랫폼의 콘텐츠만 제공하는 Provider
@riverpod
Future<List<ContentModel>> contentsByPlatform(Ref ref, String platform) async {
  final repository = ref.read(contentRepositoryProvider);
  return await repository.getContentsByPlatform(platform);
}
