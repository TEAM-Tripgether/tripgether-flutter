import 'package:riverpod_annotation/riverpod_annotation.dart';
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
