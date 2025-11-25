import 'package:freezed_annotation/freezed_annotation.dart';

part 'save_place_response.freezed.dart';
part 'save_place_response.g.dart';

/// 장소 저장 API 응답 모델
///
/// POST /api/place/{placeId}/save API의 응답을 매핑합니다.
/// 임시 저장 상태(TEMPORARY)의 장소를 저장 상태(SAVED)로 변경한 결과를 반환합니다.
///
/// **API 응답 예시**:
/// ```json
/// {
///   "memberPlaceId": "550e8400-e29b-41d4-a716-446655440000",
///   "placeId": "550e8400-e29b-41d4-a716-446655440000",
///   "savedStatus": "SAVED",
///   "savedAt": "2024-11-24T10:30:00"
/// }
/// ```
@freezed
class SavePlaceResponse with _$SavePlaceResponse {
  const factory SavePlaceResponse({
    /// 회원 장소 ID (회원-장소 연결 테이블의 고유 ID)
    required String memberPlaceId,

    /// 장소 ID
    required String placeId,

    /// 저장 상태 (SAVED, TEMPORARY 등)
    required String savedStatus,

    /// 저장 일시 (ISO 8601 형식)
    required String savedAt,
  }) = _SavePlaceResponse;

  /// JSON에서 SavePlaceResponse 객체 생성
  factory SavePlaceResponse.fromJson(Map<String, dynamic> json) =>
      _$SavePlaceResponseFromJson(json);
}
