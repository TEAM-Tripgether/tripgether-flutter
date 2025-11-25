import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../core/models/content_model.dart';
import '../../../../core/models/place_model.dart';
import 'content_provider.dart';

part 'place_detail_provider.g.dart';

/// 장소 상세 정보를 제공하는 Provider
///
/// placeId를 받아 해당 장소의 상세 정보를 로드합니다.
/// GET /api/place/{placeId} API를 호출하여 위치 정보를 포함한 상세 데이터를 가져옵니다.
@riverpod
class PlaceDetail extends _$PlaceDetail {
  @override
  Future<PlaceModel?> build(String placeId) async {
    debugPrint('═══════════════════════════════════════════════════════');
    debugPrint('[PlaceDetailProvider] 🔍 build() 호출');
    debugPrint('[PlaceDetailProvider] 📍 placeId: $placeId');
    debugPrint('[PlaceDetailProvider] 📏 placeId 길이: ${placeId.length}');
    debugPrint('═══════════════════════════════════════════════════════');

    final repository = ref.read(contentRepositoryProvider);

    try {
      // GET /api/place/{placeId} API 호출
      // latitude, longitude 등 위치 정보가 포함된 상세 데이터 반환
      debugPrint(
        '[PlaceDetailProvider] 📤 repository.getPlaceById($placeId) 호출',
      );
      final place = await repository.getPlaceById(placeId);
      debugPrint('[PlaceDetailProvider] ✅ 장소 로드 성공: ${place.name}');
      return place;
    } catch (e) {
      debugPrint('[PlaceDetailProvider] ❌ 에러 발생: $e');
      // 장소를 찾을 수 없는 경우 PlaceNotFoundException 던지기
      if (e.toString().contains('not found') ||
          e.toString().contains('PLACE_NOT_FOUND')) {
        throw PlaceNotFoundException(placeId);
      }
      throw Exception('Failed to load place details: $e');
    }
  }

  /// 장소 정보 새로고침
  Future<void> refresh() async {
    ref.invalidateSelf();
  }
}

/// 장소를 찾을 수 없을 때 발생하는 예외
class PlaceNotFoundException implements Exception {
  final String placeId;

  PlaceNotFoundException(this.placeId);

  @override
  String toString() => 'Place not found: $placeId';
}

/// 특정 장소를 포함한 SNS 컨텐츠 목록을 제공하는 Provider
///
/// [placeId]를 포함한 모든 SNS 컨텐츠를 필터링하여 반환합니다.
@riverpod
Future<List<ContentModel>> relatedContents(Ref ref, String placeId) async {
  final repository = ref.read(contentRepositoryProvider);

  try {
    // 최근 SNS 컨텐츠를 가져옴 (최신 10개)
    final allContents = await repository.getRecentContents();

    // 해당 placeId를 포함한 컨텐츠만 필터링
    return allContents.where((content) {
      return content.places.any((place) => place.placeId == placeId);
    }).toList();
  } catch (e) {
    throw Exception('Failed to load related contents: $e');
  }
}

/// 특정 장소와 같은 컨텐츠에 속한 다른 장소들을 제공하는 Provider
///
/// [currentPlaceId]가 포함된 첫 번째 컨텐츠의 나머지 장소들을 반환합니다.
@riverpod
Future<List<PlaceModel>> otherPlaces(Ref ref, String currentPlaceId) async {
  try {
    // 현재 장소가 포함된 컨텐츠 찾기
    final relatedContentsList = await ref.watch(
      relatedContentsProvider(currentPlaceId).future,
    );

    if (relatedContentsList.isEmpty) return [];

    // 첫 번째 컨텐츠의 나머지 장소들 반환 (현재 장소 제외)
    final firstContent = relatedContentsList.first;
    return firstContent.places
        .where((place) => place.placeId != currentPlaceId)
        .toList();
  } catch (e) {
    throw Exception('Failed to load other places: $e');
  }
}
