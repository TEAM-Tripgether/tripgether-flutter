import 'package:freezed_annotation/freezed_annotation.dart';

// freezed가 생성할 파일들
part 'sns_content_model.freezed.dart';
part 'sns_content_model.g.dart';

/// SNS 콘텐츠 데이터 모델
///
/// YouTube, Instagram 등의 SNS 플랫폼에서 가져온
/// 여행 관련 콘텐츠를 표현하는 모델 클래스
@freezed
class SnsContent with _$SnsContent {
  const SnsContent._(); // private constructor for custom methods

  const factory SnsContent({
    /// 콘텐츠 고유 ID
    required String id,

    /// 콘텐츠 제목
    required String title,

    /// 썸네일 이미지 URL
    required String thumbnailUrl,

    /// 콘텐츠 출처 (YouTube, Instagram 등)
    required SnsSource source,

    /// 원본 콘텐츠 URL
    required String contentUrl,

    /// 생성자 이름 (예: 채널명, 인스타그램 사용자명)
    required String creatorName,

    /// 조회수 (YouTube) 또는 좋아요 수 (Instagram)
    required int viewCount,

    /// 콘텐츠 생성 날짜
    required DateTime createdAt,

    /// 콘텐츠 타입 (비디오, 이미지, 릴스 등)
    required ContentType type,
  }) = _SnsContent;

  /// JSON 직렬화 (API 통신용)
  factory SnsContent.fromJson(Map<String, dynamic> json) =>
      _$SnsContentFromJson(json);

  /// 더미 데이터 생성을 위한 팩토리 메서드
  static SnsContent dummy({
    required String id,
    required String title,
    required SnsSource source,
    String? thumbnailUrl,
    String? creatorName,
  }) {
    return SnsContent(
      id: id,
      title: title,
      thumbnailUrl: thumbnailUrl ?? 'https://picsum.photos/400/300?random=$id',
      source: source,
      contentUrl: 'https://example.com/content/$id',
      creatorName:
          creatorName ??
          (source == SnsSource.youtube ? 'Travel Channel' : '@traveler'),
      viewCount: (100 + (id.hashCode % 900)) * 1000, // 100K ~ 999K 랜덤
      createdAt: DateTime.now().subtract(Duration(days: id.hashCode % 30)),
      type: source == SnsSource.youtube ? ContentType.video : ContentType.image,
    );
  }
}

/// SNS 플랫폼 종류
enum SnsSource {
  @JsonValue('youtube')
  youtube('YouTube'),
  @JsonValue('instagram')
  instagram('Instagram'),
  @JsonValue('tiktok')
  tiktok('TikTok');

  final String displayName;
  const SnsSource(this.displayName);
}

/// 콘텐츠 타입
enum ContentType {
  @JsonValue('video')
  video('동영상'),
  @JsonValue('image')
  image('이미지'),
  @JsonValue('reels')
  reels('릴스'),
  @JsonValue('shorts')
  shorts('쇼츠');

  final String displayName;
  const ContentType(this.displayName);
}

/// 더미 데이터 생성 헬퍼
class SnsContentDummyData {
  static List<SnsContent> getSampleContents() {
    return [
      SnsContent.dummy(
        id: '1',
        title: '제주도 3박 4일 여행 코스 추천',
        source: SnsSource.youtube,
        creatorName: '여행유튜버',
      ),
      SnsContent.dummy(
        id: '2',
        title: '부산 해운대 맛집 투어',
        source: SnsSource.instagram,
        creatorName: '@foodie_traveler',
      ),
      SnsContent.dummy(
        id: '3',
        title: '강릉 카페거리 브이로그',
        source: SnsSource.youtube,
        creatorName: '카페투어',
      ),
      SnsContent.dummy(
        id: '4',
        title: '서울 야경 명소 BEST 10',
        source: SnsSource.instagram,
        creatorName: '@seoul_night',
      ),
      SnsContent.dummy(
        id: '5',
        title: '전주 한옥마을 당일치기 코스',
        source: SnsSource.youtube,
        creatorName: '국내여행TV',
      ),
      SnsContent.dummy(
        id: '6',
        title: '경주 벚꽃 명소 추천',
        source: SnsSource.instagram,
        creatorName: '@spring_korea',
      ),
    ];
  }
}
