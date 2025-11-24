import 'dart:convert';
import 'package:flutter/services.dart';
import '../../../../core/models/content_model.dart';
import '../../../../core/models/place_model.dart';
import 'content_data_source.dart';

/// Mock 데이터 소스 구현
///
/// 개발 중에 mockData.json 파일에서 데이터를 읽어옵니다.
/// USE_MOCK_API=true 일 때 사용됩니다.
/// 백엔드 API 명세(docs/BackendAPI.md)와 동일한 인터페이스를 제공합니다.
class MockContentDataSource implements ContentDataSource {
  static const String _mockDataPath = 'lib/core/data/mock/mockData.json';

  // 메모리에 캐시된 콘텐츠 목록
  List<ContentModel>? _cachedContents;

  // 메모리에 캐시된 장소 목록
  List<PlaceModel>? _cachedPlaces;

  /// 모든 콘텐츠 목록 조회 (내부용)
  Future<List<ContentModel>> _getAllContents() async {
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
  Future<ContentModel> analyzeSharedUrl({required String snsUrl}) async {
    // Mock에서는 새 콘텐츠를 메모리에만 추가
    final newContent = ContentModel(
      contentId: DateTime.now().millisecondsSinceEpoch.toString(),
      platform: _detectPlatform(snsUrl),
      status: ContentStatus.pending,
      originalUrl: snsUrl,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    _cachedContents ??= [];
    _cachedContents!.insert(0, newContent); // 최신 항목이 위로

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
          places: [
            PlaceModel(
              placeId: 'mock_place_1',
              position: 0,
              name: 'Mock 장소',
              address: '서울시 강남구',
              latitude: 37.5172,
              longitude: 127.0473,
            ),
          ],
        );
      }
    });

    return newContent;
  }

  @override
  Future<List<ContentModel>> getRecentContents() async {
    final contents = await _getAllContents();

    // 최신 10개만 반환 (생성일 기준 내림차순)
    final sorted = List<ContentModel>.from(contents)
      ..sort((a, b) {
        final aDate = a.createdAt ?? DateTime(2000);
        final bDate = b.createdAt ?? DateTime(2000);
        return bDate.compareTo(aDate);
      });

    return sorted.take(10).toList();
  }

  @override
  Future<ContentModel> getContentById(String contentId) async {
    final contents = await _getAllContents();
    return contents.firstWhere(
      (content) => content.contentId == contentId,
      orElse: () => throw Exception('Content not found: $contentId'),
    );
  }

  @override
  Future<List<PlaceModel>> getSavedPlaces() async {
    // 캐시된 장소가 있으면 반환
    if (_cachedPlaces != null) {
      return _cachedPlaces!;
    }

    // 백엔드 API 응답 구조에 맞는 Mock 데이터
    // GET /api/place/{id} 응답 형식
    final mockPlaceData = {
      "placeId": "550e8400-e29b-41d4-a716-446655440000",
      "name": "제주 카페 쿠모",
      "address": "제주특별자치도 제주시 애월읍",
      "country": "KR",
      "latitude": 33.4996213,
      "longitude": 126.5311884,
      "businessType": "카페",
      "category": "카페",
      "phone": "010-1234-5678",
      "description": "제주 바다를 바라보며 커피를 즐길 수 있는 카페",
      "types": ["cafe", "restaurant"],
      "businessStatus": "OPERATIONAL",
      "iconUrl":
          "https://maps.gstatic.com/mapfiles/place_api/icons/cafe-71.png",
      "rating": 4.5,
      "userRatingsTotal": 123,
      "photoUrls": [
        "https://images.unsplash.com/photo-1554118811-1e0d58224f24?w=800&q=80",
        "https://images.unsplash.com/photo-1495474472287-4d71bcdd2085?w=800&q=80",
      ],
    };

    // PlaceModel.fromJson()으로 변환
    final place = PlaceModel.fromJson(mockPlaceData);

    _cachedPlaces = [place];
    return _cachedPlaces!;
  }

  @override
  Future<void> deleteContent(String contentId) async {
    _cachedContents?.removeWhere((c) => c.contentId == contentId);
  }

  /// URL에서 플랫폼 감지
  String _detectPlatform(String url) {
    if (url.contains('instagram.com')) {
      return ContentPlatform.instagram;
    } else if (url.contains('youtube.com') || url.contains('youtu.be')) {
      return ContentPlatform.youtube;
    } else if (url.contains('tiktok.com')) {
      return ContentPlatform.tiktok;
    }
    return 'UNKNOWN';
  }

  /// 캐시 초기화 (테스트용)
  void clearCache() {
    _cachedContents = null;
    _cachedPlaces = null;
  }
}
