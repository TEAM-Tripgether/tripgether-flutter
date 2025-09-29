트립투게더(TripTogether) – Flutter 프런트엔드 PRD (MVP)

1. 프로젝트 개요
	•	목표: 외부 콘텐츠(숏폼, 링크, 캡처)에서 발견한 장소를 빠르게 앱에 저장하고, 이를 기반으로 코스 탐색·일정 관리·실행까지 매끄러운 경험을 제공.
	•	주요 사용자군
	•	일반 사용자: 핫플 저장, 코스 탐색, 지도 확인, 일정 관리
	•	코스 구매자: 코스 상세 확인 및 실행
	•	MVP 범위: UI/UX 완성도 중심, 다섯 개 탭(홈/코스마켓/지도/일정/마이페이지) 플로우 전부 동작하도록 구현.

⸻

2. 사용자 인터뷰 질문 자동생성 (Flutter UX 관점)
	1.	바텀탭 중 가장 자주 사용할 것 같은 기능은 무엇인가요?
	2.	홈 화면에서 가장 기대하는 정보/동작은 무엇인가요?
	3.	장소 저장 후 바로 보고 싶은 화면은 지도일까요, 일정일까요?
	4.	코스 상세 화면에서 꼭 필요하다고 생각하는 정보는 무엇인가요?
	5.	지도에서 원하는 기본 기능(핀, 리스트뷰, 현재 위치 표시)은 무엇인가요?
	6.	일정 화면은 달력형/리스트형 중 어떤 UI를 선호하나요?
	7.	마이페이지에서 가장 먼저 보고 싶은 정보(내 코스, 내 일정, 설정)는 무엇인가요?
	8.	에러가 발생했을 때 어떤 메시지가 가장 직관적일까요?

⸻

3. 페르소나 템플릿 자동화 (예시)
	•	김여행(23세, 대학생)
	•	목표: SNS에서 본 핫플을 빠르게 저장하고, 지도에서 확인 후 일정에 반영.
	•	페인포인트: 스크린샷/메모가 흩어져 관리 불편.
	•	기술 이해도: 모바일 친숙.
	•	이코스(29세, 회사원)
	•	목표: 테마별 코스를 빠르게 찾아 실행.
	•	페인포인트: 코스 정보가 불완전하거나 실행 가능성이 낮음.

⸻

4. 마이크로카피 초안
	•	홈: “오늘의 추천 코스”, “최근 저장한 장소”
	•	코스마켓: “이 장소 포함 코스 보기”, “구매 전 환불 규정을 확인하세요”
	•	지도: “현재 위치로 이동”, “핀을 눌러 상세 보기”
	•	일정: “+ 일정 추가”, “오늘 일정 없음”
	•	마이페이지: “내 저장소”, “설정 변경”, “로그아웃”

⸻

5. 사용자 여정 맵
	1.	발견: 외부 콘텐츠에서 핫플 공유 → 앱 실행
	2.	저장: 추출된 장소를 확인 → “내 지도에 저장”
	3.	탐색: 홈/코스마켓에서 관련 코스 탐색
	4.	실행: 일정에 반영 → 지도 기반으로 확인
	5.	리뷰: 실행 후 마이페이지에서 피드백

⸻

6. 유저 플로우 (탭 기준 - 변동가능)
	•	홈 → 최근 저장 / 추천 코스 / CTA(코스마켓·지도)
	•	코스마켓 → 코스리스트 → 상세 → 저장/일정 반영
	•	지도 → 핀 표시 / 상세보기 → 일정 추가
	•	일정 → 달력/리스트 → 일정 편집/추가 → 실행
	•	마이페이지 → 내 코스 / 내 일정 / 계정설정

7. 와이어프레임
	•   이미 피그마에 디자인 되어 있음.

⸻

8. 핵심 기능 (MVP 우선순위)
	•	P0 (최우선)
	•	바텀탭 5개 구조 + 라우팅
	•	홈: 최근 저장 / 추천 영역
	•	코스마켓: 리스트·상세
	•	지도: 핀 표시, 저장 장소 시각화
	•	일정: 기본 달력 + 일정 등록
	•	마이페이지: 프로필/설정/내코스
	•	P1
	•	공유 인입 + 장소 추출 결과 반영
	•	코스 상세에 일정 반영 기능
	•	P2
	•	리뷰/평가, 결제 연동, 추천 알고리즘

⸻

9. 기술스택 (Flutter 전용)
	•	UI: Flutter + Material 3 (custom theme)
	•	라우팅: GoRouter (ShellRoute, 상수 라우트 분리)
	•	상태관리: Riverpod
	•	네트워킹: dio
	•	로컬: shared_preferences (후에 Hive/Drift 확장 가능)
	•	지도: google_maps_flutter / kakao_map_plugin
	•	i18n: flutter_localizations + intl
	•	디자인 대응: flutter_screenutil

⸻

10. 폴더 구조 (Clean Architecture + 하이브리드 Provider 패턴)

```
lib/
├── app/                     # 앱 레벨 설정 및 초기화
│   ├── app.dart            # 메인 앱 위젯 (MaterialApp)
│   ├── app_router.dart     # 전역 GoRouter 설정 및 라우트 관리
│   └── app_providers.dart  # 앱 레벨 전역 providers 초기화
│
├── core/                   # 핵심 공통 모듈 (전체 앱에서 사용)
│   ├── constants/         # 상수 정의
│   │   ├── app_colors.dart      # 색상 상수 (브랜드 컬러, 시스템 컬러)
│   │   ├── app_strings.dart     # 문자열 상수 (API 엔드포인트, 키값)
│   │   ├── app_dimensions.dart  # 크기/간격 상수 (padding, margin)
│   │   └── app_assets.dart      # 에셋 경로 상수
│   │
│   ├── theme/            # Material 3 테마 및 스타일 시스템
│   │   ├── app_theme.dart       # 전체 앱 테마 설정
│   │   ├── text_styles.dart     # 타이포그래피 스타일
│   │   └── component_themes.dart # 개별 컴포넌트 테마
│   │
│   ├── router/           # 라우팅 시스템
│   │   ├── routes.dart          # 라우트 상수 정의
│   │   ├── router.dart          # GoRouter 인스턴스
│   │   └── route_guards.dart    # 인증/권한 가드
│   │
│   ├── services/         # 공통 서비스 레이어
│   │   ├── sharing_service.dart # 앱 간 공유 기능
│   │   ├── api_service.dart     # HTTP 클라이언트
│   │   ├── storage_service.dart # 로컬 저장소
│   │   └── location_service.dart # 위치 서비스
│   │
│   ├── utils/           # 유틸리티 함수
│   │   ├── validators.dart      # 입력 검증 함수
│   │   ├── formatters.dart      # 데이터 포맷팅
│   │   ├── extensions.dart      # Dart 확장 메서드
│   │   └── helpers.dart         # 일반 도우미 함수
│   │
│   └── exceptions/      # 커스텀 예외 클래스
│       ├── app_exceptions.dart  # 앱 전용 예외
│       └── api_exceptions.dart  # API 관련 예외
│
├── shared/              # 공유 컴포넌트 (재사용 가능한 요소)
│   ├── widgets/        # 공통 UI 컴포넌트
│   │   ├── buttons/           # 버튼 컴포넌트
│   │   │   ├── primary_button.dart
│   │   │   └── secondary_button.dart
│   │   ├── cards/             # 카드 컴포넌트
│   │   │   ├── place_card.dart
│   │   │   └── course_card.dart
│   │   ├── inputs/            # 입력 컴포넌트
│   │   │   ├── search_field.dart
│   │   │   └── text_field.dart
│   │   ├── loading/           # 로딩 컴포넌트
│   │   │   ├── shimmer_loading.dart
│   │   │   └── progress_indicator.dart
│   │   └── layout/            # 레이아웃 컴포넌트
│   │       ├── app_bar.dart
│   │       └── bottom_navigation.dart
│   │
│   ├── models/         # 공통 데이터 모델
│   │   ├── user.dart          # 사용자 모델
│   │   ├── place.dart         # 장소 모델
│   │   ├── course.dart        # 코스 모델
│   │   └── api_response.dart  # API 응답 모델
│   │
│   └── providers/      # 전역 공유 Providers (2개 이상 feature에서 사용)
│       ├── auth_provider.dart        # 인증 상태 관리
│       ├── user_provider.dart        # 전역 사용자 정보
│       ├── saved_places_provider.dart # 저장된 장소 (지도/일정/홈에서 사용)
│       ├── app_settings_provider.dart # 앱 설정 (테마, 언어 등)
│       └── connectivity_provider.dart # 네트워크 연결 상태
│
├── features/           # Feature별 모듈 (Clean Architecture + 하이브리드 Provider)
│   ├── splash/         # 스플래시 화면 Feature
│   │   └── presentation/
│   │       ├── screens/
│   │       │   └── splash_screen.dart
│   │       └── widgets/
│   │           └── app_logo.dart
│   │
│   ├── auth/           # 인증 Feature (로그인/회원가입)
│   │   ├── presentation/
│   │   │   ├── screens/
│   │   │   │   ├── login_screen.dart
│   │   │   │   └── signup_screen.dart
│   │   │   └── widgets/
│   │   │       ├── login_form.dart
│   │   │       └── social_login_buttons.dart
│   │   ├── providers/     # auth 전용 providers
│   │   │   ├── login_form_provider.dart
│   │   │   └── signup_validation_provider.dart
│   │   ├── domain/
│   │   │   ├── models/
│   │   │   │   ├── login_request.dart
│   │   │   │   └── auth_result.dart
│   │   │   └── repositories/
│   │   │       └── auth_repository.dart
│   │   └── data/
│   │       ├── datasources/
│   │       │   └── auth_remote_datasource.dart
│   │       └── repositories/
│   │           └── auth_repository_impl.dart
│   │
│   ├── home/           # 홈 탭 Feature
│   │   ├── presentation/
│   │   │   ├── screens/
│   │   │   │   └── home_screen.dart
│   │   │   └── widgets/
│   │   │       ├── recent_places_section.dart
│   │   │       ├── recommended_courses_section.dart
│   │   │       └── quick_action_buttons.dart
│   │   ├── providers/     # home 전용 providers
│   │   │   ├── home_state_provider.dart
│   │   │   ├── recent_places_provider.dart
│   │   │   └── recommended_courses_provider.dart
│   │   ├── domain/
│   │   │   ├── models/
│   │   │   │   └── home_data.dart
│   │   │   └── repositories/
│   │   │       └── home_repository.dart
│   │   └── data/
│   │       └── repositories/
│   │           └── home_repository_impl.dart
│   │
│   ├── course_market/  # 코스마켓 탭 Feature
│   │   ├── presentation/
│   │   │   ├── screens/
│   │   │   │   ├── course_list_screen.dart
│   │   │   │   └── course_detail_screen.dart
│   │   │   └── widgets/
│   │   │       ├── course_filter_bar.dart
│   │   │       ├── course_list_item.dart
│   │   │       └── course_detail_info.dart
│   │   ├── providers/     # course_market 전용 providers
│   │   │   ├── course_list_provider.dart
│   │   │   ├── course_filter_provider.dart
│   │   │   ├── course_search_provider.dart
│   │   │   └── course_detail_provider.dart
│   │   ├── domain/
│   │   │   ├── models/
│   │   │   │   ├── course.dart
│   │   │   │   ├── course_filter.dart
│   │   │   │   └── course_detail.dart
│   │   │   └── repositories/
│   │   │       └── course_repository.dart
│   │   └── data/
│   │       └── repositories/
│   │           └── course_repository_impl.dart
│   │
│   ├── map/            # 지도 탭 Feature
│   │   ├── presentation/
│   │   │   ├── screens/
│   │   │   │   └── map_screen.dart
│   │   │   └── widgets/
│   │   │       ├── map_widget.dart
│   │   │       ├── place_markers.dart
│   │   │       ├── place_info_sheet.dart
│   │   │       └── location_search_bar.dart
│   │   ├── providers/     # map 전용 providers
│   │   │   ├── map_controller_provider.dart
│   │   │   ├── map_markers_provider.dart
│   │   │   ├── current_location_provider.dart
│   │   │   └── place_search_provider.dart
│   │   ├── domain/
│   │   │   ├── models/
│   │   │   │   ├── map_marker.dart
│   │   │   │   ├── location.dart
│   │   │   │   └── place_info.dart
│   │   │   └── repositories/
│   │   │       └── map_repository.dart
│   │   └── data/
│   │       └── repositories/
│   │           └── map_repository_impl.dart
│   │
│   ├── schedule/       # 일정 탭 Feature
│   │   ├── presentation/
│   │   │   ├── screens/
│   │   │   │   ├── schedule_screen.dart
│   │   │   │   └── schedule_detail_screen.dart
│   │   │   └── widgets/
│   │   │       ├── calendar_widget.dart
│   │   │       ├── schedule_list.dart
│   │   │       ├── schedule_item.dart
│   │   │       └── add_schedule_form.dart
│   │   ├── providers/     # schedule 전용 providers
│   │   │   ├── calendar_provider.dart
│   │   │   ├── schedule_list_provider.dart
│   │   │   ├── schedule_form_provider.dart
│   │   │   └── selected_date_provider.dart
│   │   ├── domain/
│   │   │   ├── models/
│   │   │   │   ├── schedule.dart
│   │   │   │   ├── schedule_item.dart
│   │   │   │   └── calendar_event.dart
│   │   │   └── repositories/
│   │   │       └── schedule_repository.dart
│   │   └── data/
│   │       └── repositories/
│   │           └── schedule_repository_impl.dart
│   │
│   └── mypage/         # 마이페이지 탭 Feature
│       ├── presentation/
│       │   ├── screens/
│       │   │   ├── mypage_screen.dart
│       │   │   ├── profile_edit_screen.dart
│       │   │   ├── my_courses_screen.dart
│       │   │   └── settings_screen.dart
│       │   └── widgets/
│       │       ├── profile_header.dart
│       │       ├── menu_list.dart
│       │       ├── my_stats.dart
│       │       └── settings_item.dart
│       ├── providers/     # mypage 전용 providers
│       │   ├── profile_provider.dart
│       │   ├── my_courses_provider.dart
│       │   ├── user_stats_provider.dart
│       │   └── settings_provider.dart
│       ├── domain/
│       │   ├── models/
│       │   │   ├── user_profile.dart
│       │   │   ├── user_stats.dart
│       │   │   └── user_settings.dart
│       │   └── repositories/
│       │       └── profile_repository.dart
│       └── data/
│           └── repositories/
│               └── profile_repository_impl.dart
│
└── main.dart           # 앱 엔트리 포인트
```

### Provider 위치 전략 (하이브리드 접근법)

#### Feature별 Provider 배치 기준:
- **Feature 전용 상태**: 해당 feature에서만 사용하는 UI 상태, 폼 상태, 필터링 로직
- **Feature 비즈니스 로직**: 특정 화면/기능에 종속적인 데이터 처리
- **생명주기 연결**: Feature와 동일한 생명주기를 가지는 상태

#### Shared Provider 배치 기준:
- **전역 상태**: 인증, 사용자 정보, 앱 설정 등 앱 전체에서 필요한 상태
- **다중 Feature 사용**: 2개 이상의 feature에서 공통으로 사용하는 데이터
- **시스템 상태**: 네트워크 연결, 위치 권한 등 시스템 레벨 상태

### 확장성 고려사항:
- **수평 확장**: 새로운 feature 추가 시 동일한 구조 패턴 적용
- **수직 확장**: 각 feature 내부에서 복잡도 증가 시 sub-feature로 분리 가능
- **의존성 관리**: core → shared → features 순서로 의존성 방향 고정
- **테스트 용이성**: 각 레이어별 독립적 단위 테스트 가능

### MVP 개발 우선순위:
1. **P0**: core/constants, core/theme, features/splash, features/auth
2. **P1**: 5개 메인 탭 features (home, course_market, map, schedule, mypage)
3. **P2**: shared/widgets 고도화, core/services 확장


⸻

11. MVP 이후 개선사항
	•	자동 장소 추출(AI) → 지도 핀 자동화
	•	일정 공유/협업 기능
	•	인앱 결제 + 환불정책 UI
	•	후기/평가 → 신뢰도 기반 코스 노출
	•	개인화 추천 (저장 장소 기반)

⸻

