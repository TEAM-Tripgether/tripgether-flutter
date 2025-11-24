import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../core/models/content_model.dart';
import '../../../../core/models/place_model.dart';
import 'content_provider.dart';

part 'place_detail_provider.g.dart';

/// 장소 상세 정보를 제공하는 Provider
///
/// placeId를 받아 해당 장소의 상세 정보를 로드합니다.
/// ContentRepository의 getSavedPlaces()를 통해 장소 목록을 가져온 후
/// placeId로 필터링하여 반환합니다.
@riverpod
class PlaceDetail extends _$PlaceDetail {
  @override
  Future<PlaceModel?> build(String placeId) async {
    final repository = ref.read(contentRepositoryProvider);

    try {
      // 저장된 장소 목록을 가져옴
      final places = await repository.getSavedPlaces();

      // placeId로 필터링
      final place = places.firstWhere(
        (p) => p.placeId == placeId,
        orElse: () => throw PlaceNotFoundException(placeId),
      );

      return place;
    } catch (e) {
      // PlaceNotFoundException을 다시 던지거나 null 반환
      if (e is PlaceNotFoundException) {
        rethrow;
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
Future<List<ContentModel>> relatedContents(
  Ref ref,
  String placeId,
) async {
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
Future<List<PlaceModel>> otherPlaces(
  Ref ref,
  String currentPlaceId,
) async {
  try {
    // 현재 장소가 포함된 컨텐츠 찾기
    final relatedContentsList =
        await ref.watch(relatedContentsProvider(currentPlaceId).future);

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
