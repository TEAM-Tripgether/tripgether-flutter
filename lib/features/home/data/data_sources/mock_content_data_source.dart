import 'dart:convert';
import 'package:flutter/services.dart';
import '../../../../core/models/content_model.dart';
import 'content_data_source.dart';

/// Mock 데이터 소스 구현
///
/// 개발 중에 mockData.json 파일에서 데이터를 읽어옵니다.
/// USE_MOCK_API=true 일 때 사용됩니다.
class MockContentDataSource implements ContentDataSource {
  static const String _mockDataPath = 'lib/core/data/mock/mockData.json';

  // 메모리에 캐시된 콘텐츠 목록
  List<ContentModel>? _cachedContents;

  @override
  Future<List<ContentModel>> getContents() async {
    // 캐시가 있으면 반환
    if (_cachedContents != null) {
      return _cachedContents!;
    }

    try {
      // JSON 파일 읽기
      final jsonString = await rootBundle.loadString(_mockDataPath);
      final List<dynamic> jsonList = json.decode(jsonString);

      // JSON을 ContentModel 리스트로 변환
      _cachedContents = jsonList.map((json) {
        return ContentModel.fromJson(json as Map<String, dynamic>);
      }).toList();

      return _cachedContents!;
    } catch (e) {
      // 에러 발생 시 빈 리스트 반환
      return [];
    }
  }

  @override
  Future<ContentModel> getContentById(String contentId) async {
    final contents = await getContents();
    return contents.firstWhere(
      (content) => content.contentId == contentId,
      orElse: () => throw Exception('Content not found: $contentId'),
    );
  }

  @override
  Future<ContentModel> addContent({
    required String url,
    required String platform,
  }) async {
    // Mock에서는 새 콘텐츠를 메모리에만 추가
    final newContent = ContentModel(
      contentId: DateTime.now().millisecondsSinceEpoch.toString(),
      platform: platform,
      status: ContentStatus.pending,
      originalUrl: url,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    _cachedContents ??= [];
    _cachedContents!.add(newContent);

    // 3초 후 상태를 COMPLETED로 변경 (백엔드 분석 시뮬레이션)
    Future.delayed(const Duration(seconds: 3), () {
      final index = _cachedContents!.indexWhere(
        (c) => c.contentId == newContent.contentId,
      );
      if (index != -1) {
        _cachedContents![index] = newContent.copyWith(
          status: ContentStatus.completed,
          title: 'Mock 분석 완료',
          summary: '테스트용 콘텐츠입니다.',
        );
      }
    });

    return newContent;
  }

  @override
  Future<ContentModel> updateContentStatus({
    required String contentId,
    required String status,
  }) async {
    final contents = await getContents();
    final index = contents.indexWhere((c) => c.contentId == contentId);

    if (index == -1) {
      throw Exception('Content not found: $contentId');
    }

    final updatedContent = contents[index].copyWith(
      status: status,
      updatedAt: DateTime.now(),
    );

    _cachedContents![index] = updatedContent;
    return updatedContent;
  }

  @override
  Future<void> deleteContent(String contentId) async {
    _cachedContents?.removeWhere((c) => c.contentId == contentId);
  }

  /// 캐시 초기화 (테스트용)
  void clearCache() {
    _cachedContents = null;
  }
}