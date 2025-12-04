# 🌏 Tripgether

<!-- 수정하지마세요 자동으로 동기화 됩니다 -->
## 최신 버전 : v1.2.15 (2025-12-04)
[전체 업데이트 내역 보기](CHANGELOG.md)

> 여행 콘텐츠를 발견하고, 장소를 저장하며, 함께 여행을 계획하세요.

**Tripgether**는 소셜 미디어에서 발견한 여행 콘텐츠를 저장하고 정리하며, 다른 여행자들과 함께 여행을 계획할 수 있는 협업 여행 플래닝 모바일 애플리케이션입니다.

---

## 📚 프로젝트 문서

체계적인 개발을 위한 완벽한 기술 문서가 준비되어 있습니다:

| 문서 | 설명 | 대상 독자 |
|------|------|----------|
| **[docs/README.md](docs/README.md)** | 📖 문서 허브 (시작점) | 모든 개발자 |
| **[Architecture.md](docs/Architecture.md)** | 🏗️ 아키텍처 설명 | 신규 개발자, 리뷰어 |
| **[DesignSystem.md](docs/DesignSystem.md)** | 🎨 디자인 시스템 | UI 개발자, 디자이너 |
| **[Widgets.md](docs/Widgets.md)** | 🧩 공용 위젯 API | UI 개발자 |
| **[Services.md](docs/Services.md)** | 🛠️ 핵심 서비스 API | 백엔드 통합 개발자 |
| **[Development.md](docs/Development.md)** | 💻 개발 가이드 | 모든 개발자 |

**신규 개발자 필독 순서**: Development.md → Architecture.md → DesignSystem.md → Widgets.md → Services.md

---

## 📱 주요 기능

### 🔐 간편한 로그인
Google OAuth 2.0 소셜 로그인으로 빠르고 안전하게 시작하세요.

### 📤 콘텐츠 공유 수신
외부 앱(Instagram, YouTube 등)에서 공유한 여행 콘텐츠를 Tripgether로 직접 받아서 저장하고 정리할 수 있습니다.

### 📍 장소 저장 및 관리
- 마음에 드는 여행지를 북마크하여 나만의 여행 리스트 구성
- 저장된 장소를 체계적으로 분류하고 관리
- 여행 계획 시 빠르게 참조 가능

### 🗺️ 코스 마켓
- 다른 사용자들이 만든 여행 코스 탐색
- 검색 기능으로 원하는 여행지의 코스 발견
- 마음에 드는 코스를 내 여행에 활용

### 🌐 다국어 지원
한국어와 영어를 지원하여 글로벌 사용자 경험을 제공합니다.

---

## 🛠️ 기술 스택

### Core Framework
- **Flutter 3.27.2** - 크로스 플랫폼 모바일 앱 개발
- **Dart 3.6.1** - 프로그래밍 언어

### State Management & Architecture
- **Riverpod 2.6.1** - @riverpod 어노테이션 기반 상태 관리
- **Freezed 2.5.9** - 불변 데이터 모델 생성
- **Build Runner** - 코드 생성 자동화

### Navigation
- **GoRouter 14.6.2** - 선언적 라우팅 및 딥링크 지원
- **AppRoutes** - 중앙화된 라우트 상수 관리 (`lib/core/router/routes.dart`)

### Authentication
- **Google Sign-In 7.2.0** - 이벤트 기반 API로 Google OAuth 2.0 인증
- **Flutter Secure Storage** - 민감 데이터 안전 저장

### UI/UX
- **Material Design 3** - 최신 디자인 시스템
- **Pretendard Font** - 커스텀 폰트 (9가지 두께 지원)
- **flutter_screenutil 5.9.3** - 반응형 UI (.w, .h, .sp, .r)
- **cached_network_image** - 이미지 캐싱 및 성능 최적화
- **shimmer 3.0.0** - 스켈레톤 로딩 효과
- **lottie 3.2.1** - Lottie 애니메이션
- **flutter_animate 4.5.0** - 선언적 애니메이션
- **flutter_staggered_animations** - 스태거드 애니메이션

### Content Sharing
- **receive_sharing_intent 1.6.1** - 외부 앱에서 공유된 콘텐츠 수신
- 지원 형식: 텍스트, URL, 이미지, 비디오, 문서

### Internationalization
- **flutter_localizations** - 다국어 지원 기반
- **ARB 파일** - 한국어(ko), 영어(en) 리소스 관리

### Development Tools
- **flutter_launcher_icons 0.15.1** - 앱 아이콘 생성
- **change_app_package_name** - 패키지명 변경 도구

---

## 📂 프로젝트 구조

```
lib/
├── core/                           # 핵심 공통 기능
│   ├── theme/ ⭐                   # 디자인 시스템 (중앙화된 스타일)
│   │   ├── app_colors.dart        # 색상 팔레트 및 그라데이션
│   │   ├── app_text_styles.dart   # 타이포그래피 시스템
│   │   ├── app_spacing.dart       # 간격, 패딩, Border Radius, Elevation, Sizes
│   │   └── app_theme.dart         # 통합 Material 테마 설정
│   │
│   ├── router/                     # 라우팅 설정
│   │   ├── app_router.dart        # GoRouter 설정 및 라우트 정의
│   │   └── routes.dart            # AppRoutes 클래스 (경로 상수 중앙 관리)
│   │
│   ├── services/                   # 공통 서비스
│   │   ├── auth/                  # 인증 서비스
│   │   │   └── google_auth_service.dart  # Google OAuth 처리
│   │   └── sharing_service.dart   # 외부 앱 공유 데이터 수신
│   │
│   └── utils/                      # 유틸리티
│
├── features/                       # 기능별 모듈 (Feature-First Architecture)
│   ├── auth/                      # 인증 기능
│   │   ├── presentation/          # UI 레이어
│   │   │   ├── screens/          # 로그인 화면
│   │   │   └── widgets/          # 로그인 폼, 소셜 로그인 버튼
│   │   └── providers/            # 상태 관리 (Riverpod)
│   │       └── login_provider.dart
│   │
│   ├── home/                      # 홈 화면 기능
│   │   ├── data/models/          # 데이터 모델
│   │   └── presentation/
│   │       └── screens/          # 홈, SNS 콘텐츠, 장소 목록 화면
│   │
│   ├── course_market/             # 코스 마켓 기능
│   │   └── presentation/
│   │       └── screens/          # 코스 마켓 메인 화면
│   │
│   └── debug/                     # 디버깅 도구
│
├── shared/ ⭐                      # 공유 위젯 및 리소스 (재사용 필수)
│   └── widgets/
│       ├── common/               # 공통 위젯 (AppBar, 로딩, 에러 등)
│       ├── layout/               # 레이아웃 위젯 (GradientBackground 등)
│       ├── buttons/              # 버튼 컴포넌트
│       ├── cards/                # 카드 컴포넌트
│       └── inputs/               # 입력 컴포넌트 (TripSearchBar 등)
│
└── l10n/                         # 다국어 지원
    ├── app_localizations.dart    # 자동 생성된 다국어 클래스
    └── arb/                      # ARB 파일 (ko.arb, en.arb)
```

⭐ = 특별히 중요한 디렉토리 (모든 개발에서 우선 확인 필수)

---

## 🎨 디자인 시스템

Tripgether는 **일관된 UI/UX**를 위해 중앙화된 디자인 시스템을 적용합니다.

### 필수 준수 사항

#### ✅ 올바른 사용
```dart
// 색상
Container(color: AppColors.primary)

// 텍스트 스타일
Text('제목', style: AppTextStyles.headlineSmall)

// 간격
Padding(padding: EdgeInsets.all(AppSpacing.lg))

// Border Radius
Container(
  decoration: BoxDecoration(
    borderRadius: AppRadius.allLarge,
  ),
)

// 공유 위젯
GradientBackground(child: TripSearchBar(...))
```

#### ❌ 금지 사항
```dart
// 하드코딩된 색상 (절대 금지!)
Container(color: Color(0xFF664BAE))

// 인라인 텍스트 스타일 (절대 금지!)
Text('제목', style: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.w600))

// 하드코딩된 크기 값 (절대 금지!)
Padding(padding: EdgeInsets.all(16.w))

// 중복 위젯 생성 (공유 위젯 재사용 필수!)
AppBar(title: Text('제목'), backgroundColor: AppColors.primary)
```

### 디자인 시스템 파일

- **`app_colors.dart`** - Primary, Secondary, Neutral, 그라데이션, 상태 색상
- **`app_text_styles.dart`** - Heading, Body, Caption, Label 텍스트 스타일
- **`app_spacing.dart`** - 간격(xs~huge), 패딩, BorderRadius, Elevation, Sizes
- **`shared/widgets/`** - 재사용 가능한 공통 UI 컴포넌트

---

## 🚀 시작하기

### 필수 요구사항
- Flutter SDK 3.27.2 이상
- Dart SDK 3.6.1 이상
- Android Studio / Xcode (각 플랫폼 빌드용)

### 설치 및 실행

```bash
# 저장소 클론
git clone https://github.com/your-repo/tripgether.git
cd tripgether

# 의존성 설치
flutter pub get

# Riverpod 코드 생성 (필수!)
dart run build_runner build

# 앱 실행
flutter run
```

### 코드 생성 (Riverpod)

`@riverpod` 어노테이션을 추가한 후 반드시 코드 생성을 실행해야 합니다:

```bash
# 일회성 생성
dart run build_runner build

# Watch 모드 (개발 중 권장)
dart run build_runner watch

# 기존 파일 삭제 후 재생성
dart run build_runner build --delete-conflicting-outputs
```

### 정적 분석 및 포맷팅

```bash
# 코드 분석
flutter analyze

# 코드 포맷팅
dart format .
```

---

## 📖 개발 가이드

### 라우팅

**절대 하드코딩된 경로를 사용하지 마세요!** 항상 `AppRoutes` 상수를 사용합니다.

```dart
import 'package:tripgether/core/router/routes.dart';

// ✅ 올바른 사용
context.go(AppRoutes.home);
context.push(AppRoutes.courseMarketSearch);

// 동적 파라미터
final path = AppRoutes.placeDetail.replaceFirst(':placeId', placeId);
context.go(path, extra: place);

// ❌ 잘못된 사용 (절대 금지!)
context.go('/home');
context.push('/course-market/search');
```

### 상태 관리 (Riverpod)

```dart
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'my_provider.g.dart';

@riverpod
class MyNotifier extends _$MyNotifier {
  @override
  Future<MyData> build() async {
    // 초기 상태 로드
    return await fetchData();
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      return await fetchData();
    });
  }
}

// 위젯에서 사용
class MyWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dataAsync = ref.watch(myNotifierProvider);

    return dataAsync.when(
      loading: () => ShimmerLoading(),
      error: (error, stack) => ErrorWidget(error),
      data: (data) => DataWidget(data),
    );
  }
}
```

### 반응형 UI (ScreenUtil)

**모든 크기 값에 ScreenUtil을 사용**하되, **디자인 시스템 값에는 중복 적용하지 마세요**.

```dart
// ✅ 올바른 사용
Container(
  width: 300.w,           // 커스텀 크기
  height: 200.h,          // 커스텀 크기
  padding: EdgeInsets.all(AppSpacing.lg),  // 이미 ScreenUtil 적용됨
)

// ❌ 잘못된 사용 (중복 적용 금지!)
Container(
  padding: EdgeInsets.all(AppSpacing.lg.w),  // AppSpacing은 이미 .w 적용됨
)
```

### 다국어 지원

**모든 사용자 노출 텍스트는 `AppLocalizations`를 사용**합니다.

```dart
import 'package:tripgether/l10n/app_localizations.dart';

class MyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Text(l10n.greeting('사용자'));  // ✅ 올바름
    // return Text('안녕하세요');  // ❌ 하드코딩 금지!
  }
}
```

### Import 규칙

**항상 절대 경로를 사용**하고, 상대 경로는 금지합니다.

```dart
// ✅ 올바른 사용 (절대 경로)
import 'package:tripgether/core/theme/app_colors.dart';
import 'package:tripgether/shared/widgets/layout/gradient_background.dart';

// ❌ 잘못된 사용 (상대 경로 금지!)
import '../../../core/theme/app_colors.dart';
import '../../shared/widgets/layout/gradient_background.dart';
```

---

## 🏗️ 구현 완료 기능

### ✅ 인증 시스템
- Google OAuth 2.0 (Sign-In 7.2.0 이벤트 기반 API)
- LoginProvider (Riverpod 상태 관리)
- 로그인 성공 시 자동 홈 화면 이동
- ref.mounted 체크를 통한 안전한 라이프사이클 관리

### ✅ 라우팅 시스템
- GoRouter 기반 선언적 라우팅
- AppRoutes 클래스를 통한 중앙화된 경로 관리
- 모든 하드코딩 경로를 AppRoutes 상수로 대체 완료
- 동적 파라미터 지원 (:placeId, :contentId)

### ✅ 콘텐츠 공유
- receive_sharing_intent 통합
- 텍스트, URL, 이미지, 비디오, 문서 지원
- URL 정리 및 플랫폼 감지 (YouTube, Instagram)
- Android 및 iOS 플랫폼 설정 완료

### ✅ 홈 화면
- SNS 콘텐츠 가로 스크롤 표시
- 저장된 장소 세로 리스트 레이아웃
- 공유 데이터 처리 및 가공
- Pull-to-refresh 및 무한 스크롤 패턴

### ✅ 코스 마켓 화면
- 그라데이션 배경 디자인 적용
- Hero 애니메이션 검색창
- RefreshableTabMixin 적용 (탭 재클릭 시 스크롤 최상단 + 새로고침)
- 디자인 시스템 100% 준수 (품질 점수: 99.75/100)

### ✅ UI 컴포넌트
- ScreenUtil 기반 반응형 디자인
- Shimmer 스켈레톤 로딩 효과
- CachedNetworkImage 성능 최적화
- CommonAppBar 일관된 내비게이션
- GradientBackground 재사용 가능한 그라데이션 위젯
- TripSearchBar 공통 검색 컴포넌트

### ✅ 다국어 지원
- 한국어 및 영어 지원
- ARB 기반 localization 시스템
- AppLocalizations 전체 적용

---

## 🚧 개발 예정 기능

- 백엔드 API 통합 (현재 더미 데이터 사용)
- 사용자 프로필 관리
- 여행 생성 및 협업 기능
- 장소 상세 정보를 위한 지도 통합
- Firebase Cloud Messaging 푸시 알림
- 로컬 데이터베이스 (데이터 영속성)

---

## ⚠️ 알려진 제한사항

- 위젯 테스트가 현재 앱 구조에 맞춰 업데이트 필요
- 패키지 충돌로 인해 Firebase analytics/crashlytics 비활성화
- 일부 상세 화면 (장소 상세, SNS 콘텐츠 상세) 미완성
- 데이터 영속성 레이어 미구현

---

## 📝 개발 원칙

### 코드 품질 기준
1. **DRY 원칙** - 코드 중복 최소화, 공통 기능은 재사용 가능하게 추출
2. **디자인 시스템 준수** - `core/theme/`, `shared/widgets/` 필수 활용
3. **타입 안정성** - Freezed, Riverpod 활용한 타입 안전 코드
4. **반응형 UI** - 모든 크기 값에 ScreenUtil 적용
5. **다국어 지원** - 사용자 노출 텍스트는 AppLocalizations 필수
6. **절대 경로 Import** - 상대 경로 금지

### 개발 워크플로우
1. **기능 브랜치** - 모든 작업은 feature 브랜치에서 진행
2. **코드 생성** - @riverpod 어노테이션 추가 후 build_runner 실행
3. **정적 분석** - flutter analyze 통과 필수
4. **코드 리뷰** - 디자인 시스템 준수 여부 검증

---