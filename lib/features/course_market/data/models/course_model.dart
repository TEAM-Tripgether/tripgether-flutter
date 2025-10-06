/// 여행 코스 데이터 모델
///
/// 사용자가 공유하거나 구매할 수 있는 여행 코스 정보를 표현하는 모델 클래스
class Course {
  /// 코스 고유 ID
  final String id;

  /// 코스 제목
  final String title;

  /// 코스 설명
  final String description;

  /// 코스 카테고리 (데이트, 산책, 빈티지 등)
  final CourseCategory category;

  /// 코스에 포함된 장소 수
  final int placeCount;

  /// 예상 소요 시간 (분 단위)
  final int estimatedMinutes;

  /// 코스 썸네일 이미지 URL
  final String thumbnailUrl;

  /// 코스 작성자 이름
  final String authorName;

  /// 작성자 프로필 이미지 URL
  final String? authorProfileUrl;

  /// 코스 가격 (0이면 무료)
  final int price;

  /// 좋아요 수
  final int likeCount;

  /// 구매/다운로드 수
  final int downloadCount;

  /// 평점 (1.0 ~ 5.0)
  final double? rating;

  /// 리뷰 개수
  final int? reviewCount;

  /// 지역 정보 (예: 서울 강진구)
  final String location;

  /// 코스 생성일
  final DateTime createdAt;

  /// 인기 코스 여부
  final bool isPopular;

  /// 프리미엄 코스 여부
  final bool isPremium;

  /// 거리 (km)
  final double? distance;

  const Course({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.placeCount,
    required this.estimatedMinutes,
    required this.thumbnailUrl,
    required this.authorName,
    this.authorProfileUrl,
    required this.price,
    required this.likeCount,
    required this.downloadCount,
    this.rating,
    this.reviewCount,
    required this.location,
    required this.createdAt,
    this.isPopular = false,
    this.isPremium = false,
    this.distance,
  });

  /// 더미 데이터 생성을 위한 팩토리 메서드
  factory Course.dummy({
    required String id,
    required String title,
    required String description,
    required CourseCategory category,
    required String location,
  }) {
    final random = id.hashCode;
    return Course(
      id: id,
      title: title,
      description: description,
      category: category,
      placeCount: 3 + (random % 8), // 3~10개
      estimatedMinutes: 60 + (random % 240), // 1~5시간
      thumbnailUrl: 'https://picsum.photos/600/400?random=$id',
      authorName: _generateAuthorName(random),
      authorProfileUrl: 'https://i.pravatar.cc/150?img=${random % 70}',
      price: _generatePrice(random),
      likeCount: 10 + (random % 990), // 10~1000
      downloadCount: 5 + (random % 495), // 5~500
      rating: 3.5 + (random % 15) * 0.1, // 3.5 ~ 5.0
      reviewCount: 5 + (random % 195), // 5~200
      location: location,
      createdAt: DateTime.now().subtract(Duration(days: random % 90)),
      isPopular: random % 5 == 0, // 20% 확률
      isPremium: random % 10 == 0, // 10% 확률
      distance: (random % 30) / 10 + 0.5, // 0.5 ~ 3.5 km
    );
  }

  /// 작성자 이름 생성 헬퍼
  static String _generateAuthorName(int random) {
    final names = [
      '여행러버',
      '서울탐험가',
      '카페투어',
      '맛집헌터',
      '힐링여행',
      '도심속산책',
      '데이트코스',
      '주말여행',
      '감성여행',
      '로컬탐방',
    ];
    return names[random % names.length];
  }

  /// 가격 생성 헬퍼
  static int _generatePrice(int random) {
    if (random % 3 == 0) return 0; // 33% 무료
    final prices = [1000, 2000, 3000, 5000, 8000, 10000];
    return prices[random % prices.length];
  }

  /// 가격 포맷 문자열
  String get priceText {
    if (price == 0) return '무료';
    return '${(price / 1000).toInt()}천원';
  }

  /// 예상 소요 시간 포맷 문자열
  String get durationText {
    final hours = estimatedMinutes ~/ 60;
    final minutes = estimatedMinutes % 60;
    if (hours == 0) return '$minutes분';
    if (minutes == 0) return '$hours시간';
    return '$hours시간 $minutes분';
  }

  /// 거리 포맷 문자열
  String get distanceText {
    if (distance == null) return '';
    return distance! < 1
        ? '${(distance! * 1000).toInt()}m'
        : '${distance!.toStringAsFixed(1)}km';
  }
}

/// 코스 카테고리
enum CourseCategory {
  date('데이트', '💕', '연인과 함께하는 로맨틱한 코스'),
  walk('산책', '🚶', '여유로운 걷기 좋은 코스'),
  vintage('빈티지', '📷', '감성적인 빈티지 스팟 코스'),
  food('맛집', '🍽️', '미식가를 위한 맛집 투어'),
  cafe('카페', '☕', '카페 호핑 코스'),
  photo('사진', '📸', '인스타 감성 포토존 코스'),
  culture('문화', '🎭', '문화예술 체험 코스'),
  shopping('쇼핑', '🛍️', '쇼핑 명소 투어'),
  night('야경', '🌃', '아름다운 야경 명소'),
  nature('자연', '🌳', '자연 속 힐링 코스');

  final String displayName;
  final String emoji;
  final String description;
  const CourseCategory(this.displayName, this.emoji, this.description);
}

/// 더미 데이터 생성 헬퍼
class CourseDummyData {
  static List<Course> getPopularCourses() {
    return [
      Course.dummy(
        id: 'popular_1',
        title: '빛 없는 밤이 선물, 우산 하나로 충분한',
        description: '비 오는 날 운치있는 데이트 코스',
        category: CourseCategory.date,
        location: '서울 성동구',
      ),
      Course.dummy(
        id: 'popular_2',
        title: '당신 편에서 아기이름 추잡추의',
        description: '감성 빈티지 카페와 소품샵 투어',
        category: CourseCategory.vintage,
        location: '서울 종로구',
      ),
      Course.dummy(
        id: 'popular_3',
        title: '을지로 빈티지 바잉 코스',
        description: '을지로 골목의 숨은 빈티지샵 탐방',
        category: CourseCategory.vintage,
        location: '서울 중구',
      ),
      Course.dummy(
        id: 'popular_4',
        title: '서촌 골목 미술관 코스',
        description: '한옥과 갤러리가 어우러진 문화 산책',
        category: CourseCategory.culture,
        location: '서울 종로구',
      ),
    ];
  }

  static List<Course> getNearbyCoursesById({required String placeId}) {
    // 현재 위치 주변의 코스 (실제로는 위치 기반 필터링 필요)
    return [
      Course.dummy(
        id: 'nearby_1',
        title: '반려견과 함께하는 주말 산책',
        description: '반려동물 친화적인 카페와 공원 코스',
        category: CourseCategory.walk,
        location: '서울 광진구',
      ),
      Course.dummy(
        id: 'nearby_2',
        title: '노을 데이트: 강바람 산책 - 와인 - 야경',
        description: '한강 노을부터 야경까지 완벽한 데이트',
        category: CourseCategory.date,
        location: '서울 영등포구',
      ),
      Course.dummy(
        id: 'nearby_3',
        title: '일본 겁겨: 모닝커피 - 상패할 시작',
        description: '일본풍 카페와 골목 탐방',
        category: CourseCategory.cafe,
        location: '서울 용산구',
      ),
      Course.dummy(
        id: 'nearby_4',
        title: '퇴근 후 2시간, 강변 야경 산책 코스',
        description: '퇴근 후 여유로운 강변 산책',
        category: CourseCategory.night,
        location: '서울 마포구',
      ),
      Course.dummy(
        id: 'nearby_5',
        title: '조용한 밤 산책 & 야식 포장 코스',
        description: '조용한 골목길과 야식 맛집',
        category: CourseCategory.food,
        location: '서울 성북구',
      ),
      Course.dummy(
        id: 'nearby_6',
        title: '필름 포토워크 & 네온싸 코스',
        description: '필름 카메라로 담는 네온사인 감성',
        category: CourseCategory.photo,
        location: '서울 중구',
      ),
      Course.dummy(
        id: 'nearby_7',
        title: '비 오는 날 힐링 코스',
        description: '비 오는 날 더 감성적인 실내 코스',
        category: CourseCategory.date,
        location: '서울 강남구',
      ),
      Course.dummy(
        id: 'nearby_8',
        title: '와인바 소울 나이트 코스',
        description: '분위기 좋은 와인바 투어',
        category: CourseCategory.night,
        location: '서울 강남구',
      ),
    ];
  }
}
