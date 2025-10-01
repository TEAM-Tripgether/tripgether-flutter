/// SNS 콘텐츠 데이터 모델
///
/// YouTube, Instagram 등의 SNS 플랫폼에서 가져온
/// 여행 관련 콘텐츠를 표현하는 모델 클래스
class SnsContent {
  /// 콘텐츠 고유 ID
  final String id;

  /// 콘텐츠 제목
  final String title;

  /// 썸네일 이미지 URL
  final String thumbnailUrl;

  /// 콘텐츠 출처 (YouTube, Instagram 등)
  final SnsSource source;

  /// 원본 콘텐츠 URL
  final String contentUrl;

  /// 생성자 이름 (예: 채널명, 인스타그램 사용자명)
  final String creatorName;

  /// 조회수 (YouTube) 또는 좋아요 수 (Instagram)
  final int viewCount;

  /// 콘텐츠 생성 날짜
  final DateTime createdAt;

  /// 콘텐츠 타입 (비디오, 이미지, 릴스 등)
  final ContentType type;

  const SnsContent({
    required this.id,
    required this.title,
    required this.thumbnailUrl,
    required this.source,
    required this.contentUrl,
    required this.creatorName,
    required this.viewCount,
    required this.createdAt,
    required this.type,
  });

  /// 더미 데이터 생성을 위한 팩토리 메서드
  factory SnsContent.dummy({
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
      creatorName: creatorName ?? (source == SnsSource.youtube ? 'Travel Channel' : '@traveler'),
      viewCount: (100 + (id.hashCode % 900)) * 1000, // 100K ~ 999K 랜덤
      createdAt: DateTime.now().subtract(Duration(days: id.hashCode % 30)),
      type: source == SnsSource.youtube ? ContentType.video : ContentType.image,
    );
  }
}

/// SNS 플랫폼 종류
enum SnsSource {
  youtube('YouTube'),
  instagram('Instagram'),
  tiktok('TikTok');

  final String displayName;
  const SnsSource(this.displayName);
}

/// 콘텐츠 타입
enum ContentType {
  video('동영상'),
  image('이미지'),
  reels('릴스'),
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