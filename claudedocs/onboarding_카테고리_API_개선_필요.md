# 온보딩 카테고리 API 개선 필요

## 📊 현재 상태

**파일**: [interest_categories.dart](../lib/features/onboarding/presentation/constants/interest_categories.dart)
**현황**: ❌ **하드코딩된 카테고리 데이터 사용**

### 현재 구현 방식

```dart
/// 14개 관심사 카테고리 (하드코딩)
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
  // ... 12개 더
];
```

### 문제점

1. **데이터 동기화 문제**
   - 서버 DB에 카테고리 추가/수정 시 앱 업데이트 필요
   - Mock 모드와 Production 모드에서 동일한 하드코딩 데이터 사용

2. **확장성 부족**
   - 새로운 카테고리 추가 시 앱 재배포 필요
   - 다국어 지원 시 번역 파일도 함께 수정 필요

3. **일관성 보장 어려움**
   - 서버 DB의 카테고리 ID와 앱의 ID가 불일치할 가능성
   - 서버에서 반환하는 관심사 ID와 매칭이 안 될 수 있음

---

## 🎯 개선 방향

### API 설계

**Endpoint**: `GET /api/onboarding/categories`

**응답 예시**:
```json
{
  "categories": [
    {
      "id": "food",
      "name": "맛집/푸드",
      "items": [
        {
          "id": "michelin",
          "name": "미슐랭"
        },
        {
          "id": "local",
          "name": "로컬 맛집"
        }
      ]
    },
    {
      "id": "cafe",
      "name": "카페/디저트",
      "items": [
        {
          "id": "emotional_cafe",
          "name": "감성카페"
        }
      ]
    }
  ]
}
```

### 데이터 모델

```dart
// lib/features/onboarding/data/models/category_response.dart
@freezed
class CategoryResponse with _$CategoryResponse {
  const factory CategoryResponse({
    required List<InterestCategoryDto> categories,
  }) = _CategoryResponse;

  factory CategoryResponse.fromJson(Map<String, dynamic> json) =>
      _$CategoryResponseFromJson(json);
}

@freezed
class InterestCategoryDto with _$InterestCategoryDto {
  const factory InterestCategoryDto({
    required String id,
    required String name,
    required List<InterestItemDto> items,
  }) = _InterestCategoryDto;

  factory InterestCategoryDto.fromJson(Map<String, dynamic> json) =>
      _$InterestCategoryDtoFromJson(json);
}

@freezed
class InterestItemDto with _$InterestItemDto {
  const factory InterestItemDto({
    required String id,
    required String name,
  }) = _InterestItemDto;

  factory InterestItemDto.fromJson(Map<String, dynamic> json) =>
      _$InterestItemDtoFromJson(json);
}
```

### API Service

```dart
// lib/features/onboarding/services/category_api_service.dart
class CategoryApiService {
  final Dio _dio = Dio();

  /// 관심사 카테고리 목록 조회
  ///
  /// **Mock 모드**: 하드코딩된 데이터 반환
  /// **Production 모드**: 서버 API 호출
  Future<CategoryResponse> getCategories() async {
    const useRealApi = bool.fromEnvironment('USE_REAL_API', defaultValue: false);

    if (!useRealApi) {
      return _mockGetCategories();
    }

    try {
      final response = await _dio.get(
        'https://api.tripgether.suhsaechan.kr/api/onboarding/categories',
      );

      return CategoryResponse.fromJson(response.data);
    } catch (e) {
      debugPrint('[CategoryApiService] ❌ 카테고리 조회 실패: $e');
      // ✅ 실패 시 Fallback: 로컬 하드코딩 데이터 사용
      return _mockGetCategories();
    }
  }

  /// Mock 카테고리 데이터
  Future<CategoryResponse> _mockGetCategories() async {
    await Future.delayed(const Duration(milliseconds: 500));

    return CategoryResponse(
      categories: [
        InterestCategoryDto(
          id: 'food',
          name: '맛집/푸드',
          items: [
            InterestItemDto(id: 'michelin', name: '미슐랭'),
            InterestItemDto(id: 'local', name: '로컬 맛집'),
            InterestItemDto(id: 'street_food', name: '스트릿푸드'),
            InterestItemDto(id: 'vegan', name: '비건'),
            InterestItemDto(id: 'fine_dining', name: '파인다이닝'),
            InterestItemDto(id: 'traditional', name: '전통요리'),
          ],
        ),
        // ... 나머지 카테고리
      ],
    );
  }
}
```

### Provider 구조

```dart
// lib/features/onboarding/providers/category_provider.dart
@riverpod
Future<List<InterestCategoryDto>> categories(Ref ref) async {
  final service = CategoryApiService();
  final response = await service.getCategories();
  return response.categories;
}
```

### InterestsPage 수정

```dart
// lib/features/onboarding/presentation/pages/interests_page.dart
class _InterestsPageState extends ConsumerState<InterestsPage> {
  @override
  Widget build(BuildContext context) {
    // ✅ API로 카테고리 로드
    final categoriesAsync = ref.watch(categoriesProvider);

    return categoriesAsync.when(
      data: (categories) => _buildCategoryList(categories),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) {
        // ✅ 에러 시 Fallback: 로컬 하드코딩 데이터 사용
        return _buildCategoryList(_getFallbackCategories());
      },
    );
  }

  /// Fallback: 로컬 하드코딩 카테고리
  List<InterestCategoryDto> _getFallbackCategories() {
    // 현재 interest_categories.dart의 데이터를 Dto로 변환
    return interestCategories.map((cat) =>
      InterestCategoryDto(
        id: cat.id,
        name: cat.name,
        items: cat.items.map((item) =>
          InterestItemDto(
            id: item.toLowerCase().replaceAll(' ', '_'),
            name: item,
          ),
        ).toList(),
      ),
    ).toList();
  }
}
```

---

## 🚀 구현 우선순위

### Phase 1: 백엔드 API 개발 (Backend Team)
- [ ] `GET /api/onboarding/categories` API 엔드포인트 구현
- [ ] 카테고리 DB 테이블 생성 및 데이터 마이그레이션
- [ ] API 응답 JSON 스키마 정의

### Phase 2: Flutter 클라이언트 구현 (2시간)
- [ ] `category_response.dart` 데이터 모델 생성 (Freezed)
- [ ] `CategoryApiService` 구현 (Mock + Real API)
- [ ] `categoriesProvider` Riverpod Provider 추가
- [ ] `InterestsPage` 수정 (API 호출 + Fallback)

### Phase 3: 테스트 및 배포
- [ ] Mock 모드에서 기존 기능 유지 확인
- [ ] Production 모드에서 API 호출 테스트
- [ ] 네트워크 오류 시 Fallback 동작 확인

---

## 📝 현재 상태 요약

| 항목 | 현재 | 개선 후 |
|------|------|---------|
| **카테고리 소스** | 하드코딩 | 서버 API |
| **Mock 모드** | 하드코딩 | Mock API |
| **Production 모드** | ❌ 하드코딩 | ✅ Real API |
| **Fallback** | ❌ 없음 | ✅ 로컬 데이터 |
| **확장성** | ❌ 낮음 | ✅ 높음 |
| **데이터 동기화** | ❌ 수동 | ✅ 자동 |

---

## ⚠️ 주의 사항

1. **하위 호환성**
   - 기존 하드코딩 데이터를 Fallback으로 유지하여 API 실패 시에도 동작 보장

2. **ID 매핑**
   - 서버 DB의 카테고리 ID와 클라이언트 하드코딩 ID가 일치해야 함
   - 마이그레이션 시 ID 매핑 테이블 필요

3. **캐싱**
   - 카테고리 데이터는 자주 변경되지 않으므로 캐싱 고려
   - SharedPreferences 또는 Hive로 로컬 캐시 저장

4. **다국어 지원**
   - 서버에서 다국어 카테고리 이름 제공 시 API 스펙 추가 필요
   - 현재는 한국어만 지원

---

## ✅ 결론

**현재 상태**: 하드코딩된 카테고리 데이터 사용 (Mock/Production 모두)

**권장 사항**:
1. **Backend API 개발 우선** → `GET /api/onboarding/categories` 구현
2. **Flutter 클라이언트 수정** → API 호출 + Fallback 로직
3. **점진적 마이그레이션** → Mock 모드는 유지, Production만 API 사용

**예상 작업 시간**: Backend 4시간 + Flutter 2시간 = 총 6시간
