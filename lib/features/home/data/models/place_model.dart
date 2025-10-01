/// 저장된 장소 데이터 모델
///
/// 사용자가 저장한 여행 장소 정보를 표현하는 모델 클래스
class SavedPlace {
  /// 장소 고유 ID
  final String id;

  /// 장소명
  final String name;

  /// 업종/카테고리 (카페, 음식점, 관광지 등)
  final PlaceCategory category;

  /// 주소
  final String address;

  /// 상세 주소
  final String? detailAddress;

  /// 위도
  final double latitude;

  /// 경도
  final double longitude;

  /// 장소 설명
  final String? description;

  /// 장소 이미지 URL 리스트
  final List<String> imageUrls;

  /// 평점 (1.0 ~ 5.0)
  final double? rating;

  /// 리뷰 개수
  final int? reviewCount;

  /// 영업 시간
  final String? businessHours;

  /// 전화번호
  final String? phoneNumber;

  /// 저장 날짜
  final DateTime savedAt;

  /// 방문 여부
  final bool isVisited;

  /// 즐겨찾기 여부
  final bool isFavorite;

  const SavedPlace({
    required this.id,
    required this.name,
    required this.category,
    required this.address,
    this.detailAddress,
    required this.latitude,
    required this.longitude,
    this.description,
    required this.imageUrls,
    this.rating,
    this.reviewCount,
    this.businessHours,
    this.phoneNumber,
    required this.savedAt,
    this.isVisited = false,
    this.isFavorite = false,
  });

  /// 더미 데이터 생성을 위한 팩토리 메서드
  factory SavedPlace.dummy({
    required String id,
    required String name,
    required PlaceCategory category,
    required String address,
    List<String>? imageUrls,
  }) {
    final random = id.hashCode;
    return SavedPlace(
      id: id,
      name: name,
      category: category,
      address: address,
      detailAddress: '상세주소 $id',
      latitude: 37.5665 + (random % 100) * 0.001,
      longitude: 126.9780 + (random % 100) * 0.001,
      description: '$name은(는) ${category.displayName} 카테고리의 인기 장소입니다.',
      imageUrls: imageUrls ?? _generateImageUrls(id),
      rating: 3.5 + (random % 15) * 0.1, // 3.5 ~ 5.0
      reviewCount: 50 + (random % 450), // 50 ~ 500
      businessHours: '매일 10:00 - 22:00',
      phoneNumber: '02-${1000 + random % 9000}-${1000 + random % 9000}',
      savedAt: DateTime.now().subtract(Duration(days: random % 30)),
      isVisited: random % 3 == 0,
      isFavorite: random % 2 == 0,
    );
  }

  /// 이미지 URL 리스트 생성 헬퍼
  static List<String> _generateImageUrls(String id) {
    final count = 3 + (id.hashCode % 4); // 3~6개
    return List.generate(
      count,
      (index) => 'https://picsum.photos/300/200?random=${id}_$index',
    );
  }

  /// 거리 표시용 포맷터 (km 단위)
  String get distanceText {
    // 실제로는 현재 위치와의 거리 계산 필요
    final distance = (id.hashCode % 50) / 10; // 0.0 ~ 5.0 km
    return distance < 1
      ? '${(distance * 1000).toInt()}m'
      : '${distance.toStringAsFixed(1)}km';
  }
}

/// 장소 카테고리
enum PlaceCategory {
  restaurant('음식점', '🍽️'),
  cafe('카페', '☕'),
  attraction('관광지', '🏛️'),
  accommodation('숙소', '🏨'),
  shopping('쇼핑', '🛍️'),
  activity('액티비티', '🎯'),
  bar('주점', '🍺'),
  dessert('디저트', '🍰'),
  museum('박물관', '🎨'),
  park('공원', '🌳');

  final String displayName;
  final String emoji;
  const PlaceCategory(this.displayName, this.emoji);
}

/// 더미 데이터 생성 헬퍼
class SavedPlaceDummyData {
  static List<SavedPlace> getSamplePlaces() {
    return [
      SavedPlace.dummy(
        id: '1',
        name: '성수 블루보틀',
        category: PlaceCategory.cafe,
        address: '서울 성동구 아차산로 7',
      ),
      SavedPlace.dummy(
        id: '2',
        name: '광장시장',
        category: PlaceCategory.shopping,
        address: '서울 종로구 창경궁로 88',
      ),
      SavedPlace.dummy(
        id: '3',
        name: '스시 오마카세',
        category: PlaceCategory.restaurant,
        address: '서울 강남구 도산대로 45',
      ),
      SavedPlace.dummy(
        id: '4',
        name: '한강공원',
        category: PlaceCategory.park,
        address: '서울 영등포구 여의동로 330',
      ),
      SavedPlace.dummy(
        id: '5',
        name: '북촌 한옥마을',
        category: PlaceCategory.attraction,
        address: '서울 종로구 계동길 37',
      ),
      SavedPlace.dummy(
        id: '6',
        name: '을지로 맥주집',
        category: PlaceCategory.bar,
        address: '서울 중구 을지로 30길 23',
      ),
      SavedPlace.dummy(
        id: '7',
        name: '남산타워',
        category: PlaceCategory.attraction,
        address: '서울 용산구 남산공원길 105',
      ),
      SavedPlace.dummy(
        id: '8',
        name: '명동 디저트 카페',
        category: PlaceCategory.dessert,
        address: '서울 중구 명동길 14',
      ),
      SavedPlace.dummy(
        id: '9',
        name: '국립중앙박물관',
        category: PlaceCategory.museum,
        address: '서울 용산구 서빙고로 137',
      ),
      SavedPlace.dummy(
        id: '10',
        name: '이태원 브런치',
        category: PlaceCategory.restaurant,
        address: '서울 용산구 이태원로 145',
      ),
    ];
  }
}