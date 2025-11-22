// ⚠️ DEPRECATED: 하드코딩된 관심사 카테고리 데이터
//
// **사용 금지**: 이 파일은 더 이상 사용되지 않습니다.
// **대체**: GET /api/interests API 사용 (lib/features/onboarding/providers/interest_provider.dart)
//
// **변경 이유**:
// - 서버 DB와 클라이언트 데이터 동기화 문제 해결
// - 카테고리 추가/수정 시 앱 업데이트 불필요
// - Redis 캐싱으로 빠른 응답 보장
//
// **마이그레이션 가이드**:
// 1. `ref.watch(interestsProvider)` 사용하여 API 데이터 로드
// 2. `InterestCategoryDto` 및 `InterestItemDto` 사용
// 3. 관심사 ID는 UUID 형식 (예: "550e8400-e29b-41d4-a716-446655440000")
//
// **삭제 예정일**: 2025-02-01 (모든 코드가 API로 마이그레이션된 후)

@Deprecated('Use GET /api/interests API instead. See interest_provider.dart')
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

/// 14개 관심사 카테고리 (하드코딩)
///
/// ⚠️ DEPRECATED: API 사용 권장
@Deprecated('Use interestsProvider from interest_provider.dart')
const List<InterestCategory> interestCategories = [
  InterestCategory(
    id: 'food',
    name: '맛집/푸드',
    items: ['미슐랭', '로컬 맛집', '스트릿푸드', '비건', '파인다이닝', '전통요리'],
  ),
  InterestCategory(
    id: 'cafe',
    name: '카페/디저트',
    items: ['감성카페', '루프탑카페', '베이커리', '디저트', '브런치', '티하우스'],
  ),
  InterestCategory(
    id: 'culture',
    name: '문화/예술',
    items: ['박물관', '미술관', '전통문화', '공연', '건축', '갤러리'],
  ),
  InterestCategory(
    id: 'nature',
    name: '자연/아웃도어',
    items: ['산', '바다', '호수', '계곡', '캠핑', '트레킹'],
  ),
  InterestCategory(
    id: 'photo',
    name: '도시산책/포토스팟',
    items: ['전망대', '포토스팟', '일몰', '야경', '꽃구경', '랜드마크'],
  ),
  InterestCategory(
    id: 'local',
    name: '로컬시장/골목',
    items: ['전통시장', '골목탐방', '동네맛집', '벼룩시장', '야시장', '로컬푸드'],
  ),
  InterestCategory(
    id: 'history',
    name: '역사/건축/종교',
    items: ['고궁', '성', '사원', '유적지', '역사거리', '종교건축'],
  ),
  InterestCategory(
    id: 'experience',
    name: '체험/클래스',
    items: ['쿠킹클래스', '공방체험', '시티투어', '와이너리', '농장체험', '전통체험'],
  ),
  InterestCategory(
    id: 'shopping',
    name: '쇼핑/패션',
    items: ['백화점', '아울렛', '면세점', '빈티지샵', '명품', '편집샵'],
  ),
  InterestCategory(
    id: 'wellness',
    name: '웰니스/휴식',
    items: ['스파', '마사지', '요가', '명상', '사우나', '힐링리조트'],
  ),
  InterestCategory(
    id: 'nightlife',
    name: '나이트라이프/음주',
    items: ['클럽', '바', '루프탑', '재즈바', 'DJ공연', '칵테일바'],
  ),
  InterestCategory(
    id: 'drive',
    name: '드라이브/근교',
    items: ['드라이브코스', '근교여행', '해안도로', '시골마을', '전원카페', '숨은명소'],
  ),
  InterestCategory(
    id: 'family',
    name: '가족/아이동반',
    items: ['놀이공원', '워터파크', '동물원', '수족관', '키즈카페', '체험학습'],
  ),
  InterestCategory(
    id: 'kpop',
    name: 'K-pop/K-컬처',
    items: ['K-pop명소', '드라마촬영지', '한류스타', 'K-뷰티', 'K-패션', 'K-푸드'],
  ),
];
