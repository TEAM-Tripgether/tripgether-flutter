import 'package:freezed_annotation/freezed_annotation.dart';

part 'place_model.freezed.dart';
part 'place_model.g.dart';

/// 장소 정보 모델
///
/// Instagram, YouTube 등의 콘텐츠에서 추출된 장소 정보를 나타냅니다.
/// 백엔드 API 응답의 places 배열 내 각 항목을 매핑합니다.
@freezed
class PlaceModel with _$PlaceModel {
  const factory PlaceModel({
    /// 장소 고유 ID
    required String placeId,

    /// 콘텐츠 내에서의 장소 순서 (0부터 시작)
    required int position,

    /// 장소명
    required String name,

    /// 주소 (전체 주소)
    required String address,

    /// 국가 코드 (KR, US 등)
    @Default('KR') String country,

    /// 위도
    required double latitude,

    /// 경도
    required double longitude,

    /// 비즈니스 타입 (restaurant, cafe, beach, tourist_attraction 등)
    String? businessType,

    /// 전화번호
    String? phone,

    /// 장소 설명
    String? description,

    /// 장소 타입들 (Google Places API types)
    @Default([]) List<String> types,

    /// 영업 상태 (OPERATIONAL, CLOSED_TEMPORARILY, CLOSED_PERMANENTLY)
    @Default('OPERATIONAL') String businessStatus,

    /// 아이콘 URL (Google Places 제공)
    String? iconUrl,

    /// 평점 (0.0 ~ 5.0)
    double? rating,

    /// 리뷰 수
    int? userRatingsTotal,

    /// 사진 URL 리스트
    @Default([]) List<String> photoUrls,

    /// 생성 일시
    DateTime? createdAt,

    /// 수정 일시
    DateTime? updatedAt,

    /// 생성자
    @Default('system') String createdBy,

    /// 수정자
    @Default('system') String updatedBy,
  }) = _PlaceModel;

  /// JSON 직렬화/역직렬화를 위한 팩토리 생성자
  factory PlaceModel.fromJson(Map<String, dynamic> json) =>
      _$PlaceModelFromJson(json);
}
