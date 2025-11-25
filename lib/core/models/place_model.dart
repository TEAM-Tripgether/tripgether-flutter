import 'package:freezed_annotation/freezed_annotation.dart';
import 'business_hour_model.dart';

part 'place_model.freezed.dart';
part 'place_model.g.dart';

/// JSON에서 placeId 읽기 - "id" 또는 "placeId" 둘 다 지원
///
/// API 엔드포인트별 필드명 차이 처리:
/// - GET /api/content/place/saved: "id" 필드 사용
/// - Mock 데이터, 일부 API: "placeId" 필드 사용
Object? _readPlaceId(Map<dynamic, dynamic> json, String key) {
  // "id" 필드 우선, 없으면 "placeId" 사용
  return json['id'] ?? json['placeId'];
}

/// 장소 정보 모델
///
/// Instagram, YouTube 등의 콘텐츠에서 추출된 장소 정보를 나타냅니다.
/// 백엔드 API 응답의 places 배열 내 각 항목을 매핑합니다.
@freezed
class PlaceModel with _$PlaceModel {
  const factory PlaceModel({
    /// 장소 고유 ID
    /// - GET /api/content/place/saved: "id" 필드 사용
    /// - Mock 데이터, 일부 API: "placeId" 필드 사용
    /// readValue로 "id" 또는 "placeId" 둘 다 처리
    @JsonKey(readValue: _readPlaceId) required String placeId,

    /// 콘텐츠 내에서의 장소 순서 (0부터 시작)
    /// GET /api/content/place/saved 응답에는 포함되지 않음
    @Default(0) int position,

    /// 장소명
    required String name,

    /// 주소 (전체 주소)
    required String address,

    /// 국가 코드 (KR, US 등)
    /// GET /api/content/place/saved 응답에는 포함되지 않음
    @Default('KR') String country,

    /// 위도
    /// GET /api/content/place/saved 응답에는 포함되지 않음
    double? latitude,

    /// 경도
    /// GET /api/content/place/saved 응답에는 포함되지 않음
    double? longitude,

    /// 비즈니스 타입 (restaurant, cafe, beach, tourist_attraction 등)
    String? businessType,

    /// 카테고리 (한국어, 예: "카페", "음식점", "해변")
    String? category,

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

    /// 영업시간 목록
    @Default([]) List<BusinessHourModel> businessHours,

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
