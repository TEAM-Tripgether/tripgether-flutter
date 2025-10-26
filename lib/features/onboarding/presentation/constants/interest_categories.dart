// 관심사 카테고리 상수
//
// UI에서만 사용하는 관심사 카테고리 목록
// 14개 카테고리, 각 카테고리당 여러 항목 포함

class InterestCategory {
  final String id;
  final String name;
  final List<String> items;

  const InterestCategory({
    required this.id,
    required this.name,
    required this.items,
  });
}

/// 14개 관심사 카테고리
const List<InterestCategory> interestCategories = [
  InterestCategory(
    id: 'food',
    name: '맛집/푸드',
    items: ['미슐랭', '로컬 맛집', '스트릿푸드', '비건', '디저트', '카페'],
  ),
  InterestCategory(
    id: 'nature',
    name: '자연/힐링',
    items: ['산', '바다', '호수', '계곡', '온천', '캠핑'],
  ),
  InterestCategory(
    id: 'culture',
    name: '문화/예술',
    items: ['박물관', '미술관', '전통문화', '공연', '건축', '갤러리'],
  ),
  InterestCategory(
    id: 'activity',
    name: '액티비티',
    items: ['서핑', '다이빙', '스키', '트레킹', '사이클링', '패러글라이딩'],
  ),
  InterestCategory(
    id: 'shopping',
    name: '쇼핑',
    items: ['백화점', '아울렛', '로컬마켓', '빈티지샵', '명품', '기념품'],
  ),
  InterestCategory(
    id: 'nightlife',
    name: '나이트라이프',
    items: ['클럽', '바', '루프탑', '재즈바', '와인바', '펍'],
  ),
  InterestCategory(
    id: 'photo',
    name: '사진/인생샷',
    items: ['전망대', '포토스팟', '일몰', '야경', '꽃구경', '건축물'],
  ),
  InterestCategory(
    id: 'history',
    name: '역사/유적',
    items: ['고궁', '성', '사원', '유적지', '역사거리', '기념관'],
  ),
  InterestCategory(
    id: 'experience',
    name: '체험/투어',
    items: ['쿠킹클래스', '공방체험', '시티투어', '와이너리', '농장체험', '전통체험'],
  ),
  InterestCategory(
    id: 'wellness',
    name: '웰니스/스파',
    items: ['스파', '마사지', '요가', '명상', '사우나', '찜질방'],
  ),
  InterestCategory(
    id: 'theme_park',
    name: '테마파크',
    items: ['놀이공원', '워터파크', '동물원', '수족관', '식물원', '키즈카페'],
  ),
  InterestCategory(
    id: 'festival',
    name: '축제/이벤트',
    items: ['음악페스티벌', '전통축제', '푸드페스티벌', '불꽃놀이', '마켓', '파티'],
  ),
  InterestCategory(
    id: 'sports',
    name: '스포츠',
    items: ['골프', '테니스', '요트', '수상스키', '암벽등반', '스포츠관람'],
  ),
  InterestCategory(
    id: 'local',
    name: '로컬/일상',
    items: ['동네산책', '전통시장', '골목탐방', '서점', '레코드샵', '동네카페'],
  ),
];
