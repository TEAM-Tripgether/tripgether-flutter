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
    /// Backend API는 "id"를 사용하지만 Flutter에서는 명확성을 위해 contentId 사용
    @JsonKey(name: 'id') required String contentId,

    /// 회원 ID (백엔드 응답용, 프론트엔드에서는 미사용)
    /// POST /api/content/analyze PENDING 응답: "memberId": null
    String? memberId,

    /// 플랫폼 (INSTAGRAM, YOUTUBE, TIKTOK 등)
    /// POST /api/content/analyze PENDING 응답에는 포함되지 않음
    String? platform,

    /// 처리 상태 (PENDING: 분석 중, COMPLETED: 분석 완료, FAILED: 실패)
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
///
/// 백엔드 API 명세(docs/BackendAPI.md)에 따른 상태값
class ContentStatus {
  /// 분석 대기 중 (요청이 접수되었으나 아직 시작되지 않음)
  static const String pending = 'PENDING';

  /// 분석 진행 중 (AI가 현재 분석 중)
  static const String analyzing = 'ANALYZING';

  /// 분석 완료 (장소 추출 성공)
  static const String completed = 'COMPLETED';

  /// 분석 실패 (오류 발생)
  static const String failed = 'FAILED';
}

/// 플랫폼 상수
class ContentPlatform {
  static const String instagram = 'INSTAGRAM';
  static const String youtube = 'YOUTUBE';
  static const String tiktok = 'TIKTOK';
}
