# CLAUDE.md

## 🔴 최우선 규칙 (Priority 0)

### Git 커밋 메시지 규칙

**형식**:
```
브랜치명 : feat/fix/etc : 변경 내용 설명 GitHub이슈링크
```

**예시**:
```
firebase의 FCM 탑재 : feat : FCM 푸시 알림 기능 구현 https://github.com/TEAM-Tripgether/tripgether-flutter/issues/77

온보딩 화면 수정 : fix : 성별 선택 버튼 오류 수정 #45
```

**패턴 구성**:
- **브랜치명**: 현재 브랜치 이름 (예: `firebase의 FCM 탑재`, `온보딩 화면 수정`)
- **타입**: `feat`, `fix`, `refactor`, `docs`, `style`, `test`, `chore` 등
- **변경 내용**: 무엇을 변경했는지 간결하게 설명
- **이슈 링크**: GitHub 전체 URL 또는 `#이슈번호`

**절대 금지**:
- ❌ `🤖 Generated with [Claude Code](https://claude.com/claude-code)`
- ❌ `Co-Authored-By: Claude <noreply@anthropic.com>`
- ❌ 불필요한 태그나 서명 추가

## 프로젝트 개요

**Tripgether**: Flutter 여행 계획 협업 앱 (Google OAuth, FCM, 외부 앱 공유)

## 기술 스택

- **상태 관리**: Riverpod (@riverpod 어노테이션)
- **라우팅**: GoRouter + AppRoutes 상수
- **인증**: Google Sign-In 7.2.0 (event-based API)
- **반응형**: flutter_screenutil (.w, .h, .sp, .r)
- **UI**: CachedNetworkImage + Shimmer 로딩
- **다국어**: AppLocalizations (ko, en)
- **보안**: Flutter Secure Storage
- **푸시**: Firebase Cloud Messaging

## 핵심 명령어

```bash
# 개발
flutter run
dart run build_runner watch  # Riverpod 코드 생성

# 분석
flutter analyze
dart format .

# 빌드
flutter build apk
flutter build ios
```

## 프로젝트 구조

```
lib/
├── core/
│   ├── theme/ ⭐           # 중앙화된 디자인 시스템
│   │   ├── app_colors.dart
│   │   ├── app_text_styles.dart
│   │   └── app_theme.dart
│   ├── router/
│   │   └── routes.dart     # AppRoutes 상수
│   ├── services/
│   │   ├── auth/google_auth_service.dart
│   │   ├── fcm/            # Firebase Messaging
│   │   └── sharing_service.dart
│   └── utils/
├── features/               # 기능별 모듈
├── shared/widgets/ ⭐      # 공용 컴포넌트 재사용 필수
└── l10n/                   # 다국어 ARB
```

## 필수 개발 규칙

### 1. 디자인 시스템 (최우선)

**⚠️ CRITICAL**: 모든 UI 개발은 `core/theme/` 시스템 사용 필수!

#### 📁 테마 구조
```
core/theme/
├── app_colors.dart       # 색상 (Primary, Status, Social, Gradient 등)
├── app_text_styles.dart  # 텍스트 (Headline, Title, Body, Label 등)
├── app_spacing.dart      # 간격, Radius, Elevation, Sizes
└── app_theme.dart        # Material 3 통합 테마 (자동 적용)
```

#### 🎨 AppColors 활용

```dart
import 'package:tripgether/core/theme/app_colors.dart';

// Primary
AppColors.primary           // #664BAE 메인
AppColors.buttonDisabled    // #B2A4D6 비활성

// Text
AppColors.textPrimary       // #333333 입력
AppColors.textSecondary     // #828693 부가
AppColors.textDisabled      // #9E9E9E 힌트

// Status
AppColors.success / error / warning / info

// Gradient
LinearGradient(colors: AppColorPalette.diagonalGradient)  // [#1B0062, #5325CB, #B599FF]

// Social
AppColorPalette.googleButton / kakaoButton / naverButton

// Shimmer
Shimmer.fromColors(
  baseColor: AppColors.shimmerBase,
  highlightColor: AppColors.shimmerHighlight,
)
```

#### ✍️ AppTextStyles 활용

```dart
import 'package:tripgether/core/theme/app_text_styles.dart';

// Headline (32/28/24)
AppTextStyles.headlineLarge / Medium / Small

// Title (20/16/14)
AppTextStyles.titleLarge / Medium / Small

// Body (16/14/12)
AppTextStyles.bodyLarge / Medium / Small

// Label (14/12/11)
AppTextStyles.labelLarge / Medium / Small

// Custom
AppTextStyles.buttonText  // 16px, w700
AppTextStyles.caption     // 12px, w400, 보조색
```

#### 📏 AppSpacing 활용

```dart
import 'package:tripgether/core/theme/app_spacing.dart';

// 기본 간격 (xs=4, sm=8, md=12, lg=16, xl=20, xxl=24, xxxl=32, huge=40)
AppSpacing.lg / xl / xxl

// 화면 패딩
AppSpacing.screenPadding           // 18 (기본)
AppSpacing.screenPaddingLarge      // 32 (로그인)

// SizedBox 간격
AppSpacing.verticalSpaceLG,    // 16
AppSpacing.horizontalSpaceMD,  // 12

// Border Radius
AppRadius.allLarge    // 12 (버튼, 카드)
AppRadius.allMedium   // 8 (칩)
AppRadius.topLarge    // 상단만 (바텀시트)

// Elevation
AppElevation.medium   // 2 (카드)
AppElevation.higher   // 6 (다이얼로그)

// Sizes
AppSizes.iconDefault      // 24
AppSizes.buttonHeight     // 54
AppSizes.logoLarge        // 240
```

#### ❌ 금지 사항

```dart
// ❌ WRONG - 절대 금지!
TextStyle(fontSize: 24.sp, fontWeight: FontWeight.w600)
Color(0xFF6366F1) / Colors.grey[300]
EdgeInsets.all(16) / BorderRadius.circular(12)
```

### 2. 공용 위젯 (`shared/widgets/`)

**⚠️ CRITICAL**: 중복 UI 생성 절대 금지! 기존 위젯 필수 재사용!

#### 📦 위젯 카테고리

```
shared/widgets/
├── common/         # AppBar, EmptyState, ChipList, Avatar 등
├── buttons/        # CommonButton, SocialLoginButton
├── cards/          # SnsContentCard, PlaceCard, CourseCard
├── inputs/         # SearchBar, OnboardingTextField
└── layout/         # GradientBackground, SectionHeader, BottomNavigation
```

#### 🧩 Common 위젯

```dart
import 'package:tripgether/shared/widgets/common/common_app_bar.dart';

// 홈 화면 AppBar
CommonAppBar.forHome(
  onMenuPressed: () => _openDrawer(),
  onNotificationPressed: () => _openNotifications(),
)

// 서브 페이지 AppBar
CommonAppBar.forSubPage(
  title: '장소 목록',
  rightActions: [IconButton(...)],
)

// 설정 화면 AppBar
CommonAppBar.forSettings(
  title: '프로필 편집',
  onSavePressed: () => _save(),
)

// 빈 상태 표시
EmptyState(
  icon: Icons.search_off,
  title: '검색 결과가 없습니다',
  message: '다른 키워드로 검색해보세요',
  action: PrimaryButton(...),
)

// 팩토리 메서드
EmptyStates.noSearchResults(title: '...', message: '...')
EmptyStates.noData(title: '데이터 없음')
EmptyStates.networkError(title: '연결 오류', action: ...)
EmptyStates.notYetAdded(title: '아직 추가된 항목이 없습니다')

// 칩 리스트
ChipList(
  items: ['데이트', '산책', '빈티지'],
  onItemTap: (item) => _handleChipTap(item),
)

// 선택 가능 칩
SelectableChipList(
  items: _categories,
  selectedItems: _selectedCategories,
  onSelectionChanged: (selected) => setState(() => _selectedCategories = selected),
  singleSelection: false,  // true면 단일 선택
)

// 프로필 아바타
ProfileAvatar(
  imageUrl: user.profileImageUrl,
  size: AppSizes.avatarLarge,
  onTap: () => _viewProfile(),
)
```

#### 🎛️ Buttons 위젯

```dart
import 'package:tripgether/shared/widgets/buttons/common_button.dart';
import 'package:tripgether/shared/widgets/buttons/social_login_button.dart';

// Primary Button (ElevatedButton)
PrimaryButton(
  text: '저장',
  icon: Icons.check,        // 선택 사항
  onPressed: () => _save(),
  isFullWidth: true,
  isLoading: _isLoading,    // 로딩 상태
)

// Secondary Button (OutlinedButton)
SecondaryButton(
  text: '취소',
  onPressed: () => _cancel(),
  height: AppSizes.buttonHeightSmall,
)

// Tertiary Button (TextButton)
TertiaryButton(
  text: '건너뛰기',
  onPressed: () => _skip(),
)

// Icon Button
CommonIconButton(
  icon: Icons.favorite,
  onPressed: () => _toggleFavorite(),
  tooltip: '좋아요',
  hasBackground: true,
  backgroundColor: AppColors.primary,
)

// Button Group (가로/세로 배치)
ButtonGroup(
  children: [
    SecondaryButton(text: '취소', onPressed: _cancel),
    PrimaryButton(text: '확인', onPressed: _confirm),
  ],
  isHorizontal: true,
  spacing: AppSpacing.md,
)

// 소셜 로그인 버튼
SocialLoginButton(
  text: "Google로 시작하기",
  backgroundColor: AppColorPalette.googleButton,
  textColor: Colors.black,
  icon: SvgPicture.asset('assets/icons/google.svg'),
  onPressed: () => _loginWithGoogle(),
  isLoading: _isGoogleLoading,
)
```

#### 🎴 Cards 위젯

```dart
import 'package:tripgether/shared/widgets/cards/sns_content_card.dart';
import 'package:tripgether/shared/widgets/cards/place_card.dart';

// SNS 콘텐츠 카드 (단일)
SnsContentCard(
  content: snsContent,
  onTap: () => _openContentDetail(),
  width: 120.w,
  isGridLayout: false,
)

// SNS 콘텐츠 가로 스크롤 리스트
SnsContentHorizontalList(
  contents: _snsContents,
  title: '추천 콘텐츠',
  onSeeMoreTap: () => _seeMore(),
  onContentTap: (content, index) => _openDetail(content),
)

// 장소 카드
PlaceCard(
  place: savedPlace,
  onTap: () => _openPlaceDetail(),
  onImageTap: (index) => _viewImage(index),
)

// 장소 그리드 카드
PlaceGridCard(
  place: savedPlace,
  onTap: () => _openDetail(),
  margin: EdgeInsets.all(AppSpacing.sm),
)

// 장소 리스트 섹션
PlaceListSection(
  places: _savedPlaces,
  title: '저장한 장소',
  maxItems: 5,
  onSeeMoreTap: () => _seeMore(),
  onPlaceTap: (place) => _openDetail(place),
)

// 코스 카드
CourseCard(course: courseData, onTap: () => _openCourse())
NearbyCourseCard(course: courseData)
PopularCourseCard(course: courseData)
```

#### 🔤 Inputs 위젯

```dart
import 'package:tripgether/shared/widgets/inputs/search_bar.dart';

// 검색바 (읽기 전용, 탭하여 검색 화면 이동)
TripSearchBar(
  hintText: '키워드·도시·장소를 검색해 보세요',
  readOnly: true,
  onTap: () => context.push(AppRoutes.search),
)

// 검색바 (직접 입력)
TripSearchBar(
  controller: _searchController,
  onChanged: (query) => _handleSearch(query),
  onSubmitted: (query) => _submitSearch(query),
  autofocus: true,
)

// 온보딩 텍스트 필드
OnboardingTextField(
  controller: _nameController,
  hintText: '이름을 입력하세요',
  prefixIcon: Icons.person,
)
```

#### 🎨 Layout 위젯

```dart
import 'package:tripgether/shared/widgets/layout/gradient_background.dart';
import 'package:tripgether/shared/widgets/layout/section_header.dart';

// 그라데이션 배경
GradientBackground(
  padding: EdgeInsets.all(AppSpacing.lg),
  child: TripSearchBar(...),
)

// 섹션 헤더
SectionHeader(
  title: '추천 장소',
  onSeeMoreTap: () => _seeMore(),
)

// 인사말 섹션
GreetingSection(
  userName: user.nickname,
  greeting: '안녕하세요!',
)

// 바텀 네비게이션
BottomNavigation(
  currentIndex: _currentIndex,
  onTap: (index) => setState(() => _currentIndex = index),
)
```

#### ❌ 금지 사항

```dart
// ❌ WRONG - 중복 위젯 생성 절대 금지!
AppBar(title: Text('제목'))  // CommonAppBar 사용 필수!

ElevatedButton(child: Text('확인'))  // PrimaryButton 사용!

Container(  // EmptyState 사용!
  child: Column(
    children: [
      Icon(Icons.inbox),
      Text('데이터 없음'),
    ],
  ),
)

TextField(  // TripSearchBar 사용!
  decoration: InputDecoration(
    hintText: '검색',
    prefixIcon: Icon(Icons.search),
  ),
)
```

### 3. 라우팅
```dart
// ✅ CORRECT
context.go(AppRoutes.home);

// ❌ WRONG - 하드코딩 경로 금지
context.go('/home');
```

### 4. 반응형 UI
```dart
// ✅ CORRECT - ScreenUtil 필수
Container(
  width: 300.w,
  height: 120.h,
  padding: EdgeInsets.all(16.w),
);

// ❌ WRONG - 하드코딩 픽셀 금지
Container(width: 300, height: 120);
```

### 5. 상태 관리
```dart
// Riverpod @riverpod 어노테이션 사용
@riverpod
class UserNotifier extends _$UserNotifier {
  @override
  Future<User?> build() async { ... }
}

// Provider disposal 전 ref.mounted 체크 필수
if (!ref.mounted) return;
```

### 6. 다국어
```dart
// ✅ CORRECT
final l10n = AppLocalizations.of(context);
Text(l10n.loginTitle);

// ❌ WRONG - 하드코딩 문자열 금지
Text('로그인');
```

## 개발 원칙

1. **완전 구현**: TODO 주석 금지, 모든 기능 완성
2. **DRY 원칙**: 코드 중복 최소화
3. **한국어 주석**: 모든 코드에 명확한 주석
4. **재사용 우선**: `shared/widgets/` 확인 후 개발
5. **테마 준수**: `core/theme/` 스타일 필수 사용

## 주요 패키지 사용

### ScreenUtil
```dart
Container(
  width: 300.w,    // 너비
  height: 120.h,   // 높이
  padding: EdgeInsets.all(16.w),
  child: Text('텍스트', style: TextStyle(fontSize: 18.sp)),
);
```

### Shimmer 로딩
```dart
Shimmer.fromColors(
  baseColor: Colors.grey[300]!,
  highlightColor: Colors.grey[100]!,
  child: Container(width: 200.w, height: 16.h, color: Colors.white),
);
```

### CachedNetworkImage
```dart
CachedNetworkImage(
  imageUrl: url,
  placeholder: (context, url) => Shimmer.fromColors(...),
  errorWidget: (context, url, error) => Icon(Icons.error),
);
```

## Firebase Cloud Messaging (FCM)

### 초기화 순서 (main.dart)
```dart
1. Firebase.initializeApp()
2. LocalNotificationsService.init()
3. FirebaseMessagingService.init()
```

### iOS Push 설정
- **APNs 인증서**: Firebase Console에 등록 완료
- **Xcode Capability**: Push Notifications 수동 활성화 필요
- **Entitlements**: `aps-environment: development`
- **Info.plist**: `UIBackgroundModes: remote-notification`

### 테스트
- FCM 토큰: 실제 iOS 디바이스에서만 발급 (시뮬레이터 불가)
- Firebase Console → Cloud Messaging → 테스트 메시지 전송
- 가이드: `docs/fcm_test_guide.md` 참고

## 완료된 기능

✅ Google OAuth 인증
✅ GoRouter 중앙 관리
✅ 외부 앱 공유 수신
✅ FCM 서비스 통합
✅ 반응형 UI (ScreenUtil)
✅ 다국어 지원 (ko, en)

## 진행 중

🚧 백엔드 API 연동
🚧 사용자 프로필 관리
🚧 여행 생성/협업 기능
🚧 iOS Push Notifications 활성화

# WorkFlow
Always follow the instructions in plan.md. When I say "go", find the next unmarked test in plan.md, implement the test, then implement only enough code to make that test pass.

# ROLE AND EXPERTISE

You are a senior software engineer who follows Kent Beck's Test-Driven Development (TDD) and Tidy First principles. Your purpose is to guide development following these methodologies precisely.

# CORE DEVELOPMENT PRINCIPLES

- Always follow the TDD cycle: Red → Green → Refactor
- Write the simplest failing test first
- Implement the minimum code needed to make tests pass
- Refactor only after tests are passing
- Follow Beck's "Tidy First" approach by separating structural changes from behavioral changes
- Maintain high code quality throughout development

# TDD METHODOLOGY GUIDANCE

- Start by writing a failing test that defines a small increment of functionality
- Use meaningful test names that describe behavior (e.g., "shouldSumTwoPositiveNumbers")
- Make test failures clear and informative
- Write just enough code to make the test pass - no more
- Once tests pass, consider if refactoring is needed
- Repeat the cycle for new functionality
- When fixing a defect, first write an API-level failing test then write the smallest possible test that replicates the problem then get both tests to pass.

# TIDY FIRST APPROACH

- Separate all changes into two distinct types:
  1. STRUCTURAL CHANGES: Rearranging code without changing behavior (renaming, extracting methods, moving code)
  2. BEHAVIORAL CHANGES: Adding or modifying actual functionality
- Never mix structural and behavioral changes in the same commit
- Always make structural changes first when both are needed
- Validate structural changes do not alter behavior by running tests before and after

# COMMIT DISCIPLINE

- Only commit when:
  1. ALL tests are passing
  2. ALL compiler/linter warnings have been resolved
  3. The change represents a single logical unit of work
  4. Commit messages clearly state whether the commit contains structural or behavioral changes
- Use small, frequent commits rather than large, infrequent ones

# CODE QUALITY STANDARDS

- Eliminate duplication ruthlessly
- Express intent clearly through naming and structure
- Make dependencies explicit
- Keep methods small and focused on a single responsibility
- Minimize state and side effects
- Use the simplest solution that could possibly work

# REFACTORING GUIDELINES

- Refactor only when tests are passing (in the "Green" phase)
- Use established refactoring patterns with their proper names
- Make one refactoring change at a time
- Run tests after each refactoring step
- Prioritize refactorings that remove duplication or improve clarity

# EXAMPLE WORKFLOW

When approaching a new feature:

1. Write a simple failing test for a small part of the feature
2. Implement the bare minimum to make it pass
3. Run tests to confirm they pass (Green)
4. Make any necessary structural changes (Tidy First), running tests after each change
5. Commit structural changes separately
6. Add another test for the next small increment of functionality
7. Repeat until the feature is complete, committing behavioral changes separately from structural ones

Follow this process precisely, always prioritizing clean, well-tested code over quick implementation.

Always write one test at a time, make it run, then improve structure. Always run all the tests (except long-running tests) each time.