# Tripgether 지도 통합 및 통합 콘텐츠 모델 설계

> **작성일**: 2025-10-31
> **상태**: 설계 단계 (미구현)
> **목적**: Instagram 릴스 스타일의 통합 콘텐츠 모델 설계 및 지도 기능 재사용 아키텍처

---

## 📋 핵심 요약

### 문제
- 코스마켓, 지도, 일정 페이지에서 지도 기능 필요
- Course, SavedPlace, SnsContent가 분리되어 중복 로직 발생
- Instagram/TikTok처럼 하나의 콘텐츠가 여러 곳에서 재사용되는 구조 필요

### 해결책
1. **통합 콘텐츠 모델**: Freezed Union Type으로 ContentItem 통합 (PlaceContent, CourseContent, SnsContentItem)
2. **지도 위젯 계층**: BaseMapWidget 공통 레이어 + 페이지별 특화 위젯
3. **Google Maps API 통합**: Maps SDK, Places, Directions, Distance Matrix API 역할 분담

---

## 1. 통합 콘텐츠 모델 (ContentItem)

### Instagram 릴스 패러다임
- 하나의 콘텐츠가 피드, 저장됨, 인기, 탐색 등 여러 곳에서 재사용
- 데이터는 동일, 필터/정렬만 다름
- 공통 액션: 좋아요, 저장, 공유

### Freezed Union Type 설계

```dart
@freezed
class ContentItem with _$ContentItem {
  /// 장소 콘텐츠 (카페, 맛집, 관광지)
  const factory ContentItem.place({
    // 공통 필드
    required String id,
    required String title,
    required String thumbnailUrl,
    required String authorName,
    String? authorProfileUrl,
    required DateTime createdAt,
    required int likeCount,
    required int saveCount,
    @Default(false) bool isLiked,
    @Default(false) bool isSaved,

    // Place 전용
    required PlaceCategory category,
    required String address,
    required double latitude,
    required double longitude,
    List<String>? additionalImages,
    double? rating,
    int? reviewCount,
  }) = PlaceContent;

  /// 코스 콘텐츠 (여러 장소를 묶은 여행 코스)
  const factory ContentItem.course({
    // 공통 필드
    required String id,
    required String title,
    required String thumbnailUrl,
    required String authorName,
    String? authorProfileUrl,
    required DateTime createdAt,
    required int likeCount,
    required int saveCount,
    @Default(false) bool isLiked,
    @Default(false) bool isSaved,

    // Course 전용
    required String description,
    required CourseCategory category,
    required List<PlaceContent> places, // 🆕 코스에 포함된 장소들
    required int estimatedMinutes,
    required String location,
    int? price,
    double? rating,
  }) = CourseContent;

  /// SNS 콘텐츠 (YouTube/Instagram 릴스)
  const factory ContentItem.sns({
    // 공통 필드
    required String id,
    required String title,
    required String thumbnailUrl,
    required String authorName,
    String? authorProfileUrl,
    required DateTime createdAt,
    required int likeCount,
    required int saveCount,
    @Default(false) bool isLiked,
    @Default(false) bool isSaved,

    // SNS 전용
    required SnsSource source, // YouTube, Instagram, TikTok
    required String contentUrl,
    required ContentType type,
    required int viewCount,
    List<PlaceContent>? relatedPlaces, // 🆕 릴스에서 추출한 장소들
  }) = SnsContentItem;

  factory ContentItem.fromJson(Map<String, dynamic> json) =>
      _$ContentItemFromJson(json);
}
```

### Pattern Matching 사용 예시

```dart
// 지도에 마커 표시
Widget buildMapMarkers(ContentItem content) {
  return content.when(
    place: (id, title, ..., latitude, longitude, ...) {
      // 단일 마커
      return Marker(
        markerId: MarkerId(id),
        position: LatLng(latitude, longitude),
      );
    },
    course: (id, title, ..., places, ...) {
      // 여러 마커 (코스의 모든 장소)
      return places.map((p) => Marker(...)).toList();
    },
    sns: (id, title, ..., relatedPlaces, ...) {
      // 관련 장소 마커 (있으면)
      return relatedPlaces?.map((p) => Marker(...)).toList() ?? [];
    },
  );
}
```

---

## 2. 지도 위젯 아키텍처

### 계층 구조

```
BaseMapWidget (공통 기능)
  ├─ Google Maps SDK 통합
  ├─ 마커 표시/관리
  ├─ 현재 위치 트래킹
  └─ 카메라 애니메이션

페이지별 특화 위젯
  ├─ CourseMapWidget (코스마켓 - 읽기 전용)
  ├─ MainMapWidget (지도 탭 - 편집 가능)
  └─ TripMapWidget (일정 - 경로 표시)
```

### BaseMapWidget 핵심 기능

```dart
class BaseMapWidget extends StatefulWidget {
  final LatLng initialPosition;
  final List<Marker> markers;
  final List<Polyline>? polylines;
  final bool enableCurrentLocation;
  final void Function(Marker)? onMarkerTap;

  // 카메라 제어 메서드
  Future<void> animateToPosition(LatLng position);
  Future<void> fitBounds(List<Marker> markers);
}
```

### 페이지별 위젯 역할

| 위젯 | 사용 페이지 | 주요 기능 |
|------|------------|----------|
| **CourseMapWidget** | 코스마켓 | Course.places를 마커로 표시 (읽기 전용) |
| **MainMapWidget** | 지도 탭 | 저장한 장소 표시 + 현재 위치 추적 + 장소 추가/편집 |
| **TripMapWidget** | 일정 | 순서대로 마커 표시 + 경로선 그리기 + 최적 경로 제안 |

---

## 3. Google Maps API 역할

| API | 용도 | 사용 위치 | 우선순위 |
|-----|------|-----------|---------|
| **Maps SDK for iOS** | 기본 지도 표시, 마커, 줌/이동 | 모든 지도 화면 | 🔴 높음 |
| **Geocoding API** | 백엔드에서 주소 → 좌표 변환 (릴스 공유 시) | 백엔드 | 🟢 낮음 |
| **Places API** | 장소 검색, 자동완성, 주변 장소 추천 | 지도 탭 | 🟡 중간 |
| **Directions API** | A→B→C 경로선 그리기 | 일정 페이지 | 🟡 중간 |
| **Distance Matrix API** | 장소 간 거리/시간 계산, 최적 경로 | 일정 페이지 | 🟢 낮음 |

### 데이터 플로우 예시

#### Geocoding (릴스 → 장소)
```
사용자: Instagram 릴스 공유
    ↓
Flutter: receive_sharing_intent로 URL 수신
    ↓
Backend: 릴스 메타데이터 파싱 + Geocoding API (주소 → 좌표)
    ↓
Backend → Flutter: ContentItem.sns (좌표 포함)
    ↓
Flutter: 지도에 마커 표시
```

#### Distance Matrix (최적 경로)
```
사용자: 일정에 여러 장소 추가
    ↓
Flutter: Distance Matrix API로 모든 장소 간 거리/시간 계산
    ↓
Flutter: 최적 경로 알고리즘 실행 (TSP 근사)
    ↓
Flutter: Directions API로 경로선 그리기
```

---

## 4. 디렉토리 구조

```
lib/
├── shared/
│   └── models/
│       └── content_item.dart           # 🆕 통합 콘텐츠 모델
│
├── features/
│   ├── map/                            # 🆕 지도 기능 모듈
│   │   ├── data/services/
│   │   │   ├── google_map_service.dart
│   │   │   ├── places_service.dart
│   │   │   ├── directions_service.dart
│   │   │   └── distance_service.dart
│   │   │
│   │   ├── presentation/
│   │   │   ├── widgets/
│   │   │   │   ├── base_map_widget.dart
│   │   │   │   ├── course_map_widget.dart
│   │   │   │   ├── main_map_widget.dart
│   │   │   │   └── trip_map_widget.dart
│   │   │   └── screens/
│   │   │       └── map_screen.dart
│   │   │
│   │   └── providers/
│   │       ├── map_state_provider.dart
│   │       └── current_location_provider.dart
│   │
│   ├── course_market/
│   │   └── presentation/screens/
│   │       ├── course_market_screen.dart    # ContentItem.course 사용
│   │       └── course_detail_screen.dart    # 🆕 코스 상세 (지도 포함)
│   │
│   └── trip/                           # 🆕 일정 기능 모듈
│       ├── data/models/
│       │   └── trip_model.dart
│       └── presentation/screens/
│           ├── trip_list_screen.dart
│           └── trip_detail_screen.dart
```

---

## 5. 구현 우선순위

### Phase 1: 통합 모델 및 기본 지도 (2주)
- [ ] ContentItem 통합 모델 구현
- [ ] BaseMapWidget 구현 (Google Maps SDK)
- [ ] 기존 모델을 ContentItem으로 마이그레이션
- [ ] 코스마켓에 CourseMapWidget 통합

### Phase 2: 지도 탭 (2주)
- [ ] 지도 탭 메인 화면
- [ ] MainMapWidget (저장한 장소 표시)
- [ ] 현재 위치 추적
- [ ] 장소 추가/편집 UI

### Phase 3: Places API (1주)
- [ ] PlacesService 구현
- [ ] 주변 장소 검색
- [ ] 장소 자동완성

### Phase 4: 일정 기능 (2주)
- [ ] Trip 모델 구현
- [ ] 일정 목록/상세 화면
- [ ] TripMapWidget

### Phase 5: 경로 최적화 (1주)
- [ ] DirectionsService, DistanceService
- [ ] 경로선 표시
- [ ] 최적 경로 알고리즘

---

## 6. 미해결 질문

### 데이터 구조
- [ ] **Q1**: Course가 `List<PlaceContent> places` 포함? vs 별도 API 조회?
- [ ] **Q2**: 일정에 추가 가능한 항목? (Place만? Course도?)
- [ ] **Q3**: Places API 구체적 용도? (검색? 자동완성? 주변 추천?)

### UX/UI
- [ ] **Q4**: 일정 추가 액션 범위? (모든 ContentItem? Place만?)
- [ ] **Q5**: 지도 마커 디자인? (타입별 색상? 카테고리별 아이콘?)
- [ ] **Q6**: Directions API 호출 시점? (자동? 버튼 클릭?)

---

## 7. 다음 단계

### 즉시 필요한 결정
1. Course 구조 확정 (백엔드 API 확인)
2. Trip 모델 설계 (일정에 추가 가능한 항목)
3. Places API 용도 구체화

### 구현 시작 전 준비
1. Google Maps API 키 발급 (iOS용)
2. `google_maps_flutter` 패키지 추가
3. iOS 권한 설정 (`Info.plist`)
4. Freezed 코드 생성 (`build_runner`)

---

**작성**: Claude (2025-10-31)
