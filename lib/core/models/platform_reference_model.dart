import 'package:freezed_annotation/freezed_annotation.dart';

part 'platform_reference_model.freezed.dart';
part 'platform_reference_model.g.dart';

/// 플랫폼 참조 정보 모델
///
/// 장소의 외부 플랫폼 ID 정보를 저장합니다.
/// 예: Google Places API의 Place ID, Kakao 장소 ID 등
///
/// API 응답 예시:
/// ```json
/// {
///   "placePlatform": "GOOGLE",
///   "placePlatformId": "ChIJ6bYlHTSlfDURtqcO49QcsG0"
/// }
/// ```
@freezed
class PlatformReferenceModel with _$PlatformReferenceModel {
  const factory PlatformReferenceModel({
    /// 플랫폼 종류 (GOOGLE, KAKAO, NAVER 등)
    required String placePlatform,

    /// 해당 플랫폼에서의 장소 고유 ID
    required String placePlatformId,
  }) = _PlatformReferenceModel;

  /// JSON 직렬화/역직렬화를 위한 팩토리 생성자
  factory PlatformReferenceModel.fromJson(Map<String, dynamic> json) =>
      _$PlatformReferenceModelFromJson(json);
}
