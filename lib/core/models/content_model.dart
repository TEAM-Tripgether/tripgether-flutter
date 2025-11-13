import 'package:freezed_annotation/freezed_annotation.dart';
import 'place_model.dart';

part 'content_model.freezed.dart';
part 'content_model.g.dart';

/// 콘텐츠 모델
///
/// Instagram, YouTube 등의 외부 플랫폼에서 공유된 콘텐츠 정보를 나타냅니다.
/// 백엔드에서 URL을 분석하여 생성된 데이터를 매핑합니다.
@freezed
class ContentModel with _$ContentModel {
  const factory ContentModel({
    /// 콘텐츠 고유 ID
    required String contentId,

    /// 플랫폼 (INSTAGRAM, YOUTUBE, TIKTOK 등)
    required String platform,

    /// 처리 상태 (PENDING: 분석 중, COMPLETED: 분석 완료, ERROR: 오류)
    @Default('PENDING') String status,

    /// 플랫폼 업로더 (Instagram 계정명, YouTube 채널명 등)
    String? platformUploader,

    /// 콘텐츠 캡션/설명
    String? caption,

    /// 썸네일 이미지 URL
    String? thumbnailUrl,

    /// 원본 콘텐츠 URL
    String? originalUrl,

    /// 콘텐츠 제목 (백엔드에서 생성)
    String? title,

    /// 콘텐츠 요약 (백엔드에서 생성)
    String? summary,

    /// 마지막 확인 시각
    DateTime? lastCheckedAt,

    /// 생성 일시
    DateTime? createdAt,

    /// 수정 일시
    DateTime? updatedAt,

    /// 생성자
    @Default('system') String createdBy,

    /// 수정자
    @Default('system') String updatedBy,

    /// 추출된 장소 목록
    @Default([]) List<PlaceModel> places,

    /// 추가 메타데이터 (확장용)
    Map<String, dynamic>? metadata,
  }) = _ContentModel;

  /// JSON 직렬화/역직렬화를 위한 팩토리 생성자
  factory ContentModel.fromJson(Map<String, dynamic> json) =>
      _$ContentModelFromJson(json);
}

/// 콘텐츠 상태 상수
class ContentStatus {
  static const String pending = 'PENDING';
  static const String completed = 'COMPLETED';
  static const String error = 'ERROR';
}

/// 플랫폼 상수
class ContentPlatform {
  static const String instagram = 'INSTAGRAM';
  static const String youtube = 'YOUTUBE';
  static const String tiktok = 'TIKTOK';
}