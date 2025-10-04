# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Tripgether is a Flutter mobile application focused on travel planning and collaboration. The app enables users to discover and save travel content from social media, organize places, and collaborate on travel planning. Core features include Google OAuth authentication, content sharing from external apps, and organized travel content management.

## Technology Stack & Architecture

**State Management**: Flutter Riverpod with @riverpod annotations for code generation
**Routing**: GoRouter with centralized route management via `AppRoutes` class in `lib/core/router/routes.dart`
**Authentication**: Google Sign-In 7.2.0 with event-based API (Completer pattern)
**Network**: Dio + Retrofit for REST API communication
**UI Framework**: Material Design with custom Pretendard font family
**Responsiveness**: flutter_screenutil for consistent sizing across devices
**Image Caching**: cached_network_image for performance optimization
**Loading Effects**: Shimmer for skeleton loading screens
**Animations**: Lottie, Flutter Animate, and Staggered Animations
**Internationalization**: flutter_localizations with ARB files for multi-language support
**Content Sharing**: receive_sharing_intent for receiving shared content from other apps
**Security**: Flutter Secure Storage for sensitive data

## Development Commands

### Core Flutter Commands
```bash
# Run the app in development mode
flutter run

# Run tests
flutter test

# Build APK
flutter build apk

# Build iOS
flutter build ios

# Get dependencies
flutter pub get

# Clean build cache
flutter clean && flutter pub get
```

### Code Generation (Riverpod)
```bash
# Generate Riverpod providers (required after adding @riverpod annotations)
dart run build_runner build

# Watch mode for continuous generation during development
dart run build_runner watch

# Clean generated files
dart run build_runner clean
```

### Linting & Analysis
```bash
# Run static analysis
flutter analyze

# Format code
dart format .
```

### App Management Tools
```bash
# Generate launcher icons (after updating flutter_launcher_icons config)
dart run flutter_launcher_icons:main

# Change app package name
dart run change_app_package_name:main com.new.package.name
```

## Project Structure

```
lib/
├── core/                           # 핵심 공통 기능
│   ├── router/                     # 라우팅 설정
│   │   ├── app_router.dart        # GoRouter 설정 및 라우트 정의
│   │   └── routes.dart            # AppRoutes 클래스 (경로 상수 중앙 관리)
│   ├── services/                   # 공통 서비스
│   │   ├── auth/                  # 인증 서비스
│   │   │   └── google_auth_service.dart  # Google OAuth 처리
│   │   └── sharing_service.dart   # 외부 앱 공유 데이터 수신
│   └── utils/                      # 유틸리티
│       └── url_formatter.dart     # URL 정리 및 타입 판별
├── features/                       # 기능별 모듈
│   ├── auth/                      # 인증 기능
│   │   ├── presentation/          # UI 레이어
│   │   │   ├── screens/          # 로그인 화면
│   │   │   └── widgets/          # 로그인 폼, 소셜 로그인 버튼
│   │   └── providers/            # 상태 관리 (Riverpod)
│   │       └── login_provider.dart
│   ├── home/                      # 홈 화면 기능
│   │   ├── data/models/          # 데이터 모델
│   │   └── presentation/
│   │       └── screens/          # 홈, SNS 콘텐츠, 장소 목록 화면
│   └── debug/                     # 디버깅 도구
├── shared/                        # 공유 위젯 및 리소스
│   └── widgets/
│       ├── common/               # 공통 위젯 (AppBar 등)
│       └── layout/               # 레이아웃 위젯 (카드, 섹션 등)
└── l10n/                         # 다국어 지원
    ├── app_localizations.dart    # 자동 생성된 다국어 클래스
    └── arb/                      # ARB 파일 (ko.arb, en.arb)
```

## Key Dependencies & Usage Patterns

**Riverpod State Management**: Use @riverpod annotations with build_runner for provider code generation
**Centralized Routing**: All routes defined in `AppRoutes` class - never use hardcoded route strings
**Google Sign-In**: Event-based API with Completer pattern for async authentication flow
**Content Sharing**: Unified handling of text, URLs, images, videos from external apps
**Responsive UI**: ScreenUtil (.w, .h, .sp, .r) for all size and spacing values
**Image Loading**: CachedNetworkImage with Shimmer placeholders for all network images
**Internationalization**: AppLocalizations for all user-facing text

## Assets & Fonts

**Logos**:
- `assets/logo.png` - Main app logo
- `assets/app_logo_black.png` - Black logo with tagline for login screen

**Custom Font**: Pretendard family with 9 weights (100-900) located in `assets/fonts/`

Use Pretendard font in widgets:
```dart
TextStyle(fontFamily: 'Pretendard', fontWeight: FontWeight.w500)
```

## Current Implementation Status

### ✅ Completed Features

1. **Authentication System**
   - Google OAuth 2.0 with Sign-In 7.2.0 event-based API
   - LoginProvider with Riverpod for state management
   - Automatic navigation after successful login
   - Proper lifecycle management with ref.mounted checks

2. **Routing System**
   - GoRouter configuration with nested routes
   - Centralized route management via AppRoutes class
   - All hardcoded routes replaced with AppRoutes constants
   - Support for route parameters (:placeId, :contentId)

3. **Content Sharing**
   - receive_sharing_intent integration
   - Support for text, URLs, images, videos, documents
   - URL cleaning and platform detection (YouTube, Instagram)
   - Android and iOS platform configuration

4. **Home Screen**
   - SNS content display with horizontal scroll
   - Saved places with vertical list layout
   - Shared data handling and processing
   - Pull-to-refresh and infinite scroll patterns

5. **UI Components**
   - Responsive design with flutter_screenutil
   - Shimmer loading effects
   - CachedNetworkImage for performance
   - CommonAppBar for consistent navigation
   - Custom card layouts for content and places

6. **Internationalization**
   - Korean and English support
   - ARB-based localization system
   - AppLocalizations throughout the app

### 🚧 Work in Progress

- Backend API integration (currently using dummy data)
- User profile management
- Trip creation and collaboration features
- Map integration for place details
- Push notifications with Firebase Cloud Messaging

### ⚠️ Known Limitations

- Widget tests need updating to match current app structure
- Firebase analytics/crashlytics disabled due to package conflicts
- Some detail screens (place detail, SNS content detail) not fully implemented
- No data persistence layer yet (local database)

## Authentication & Routing

### Google OAuth Implementation

**Service Location**: `lib/core/services/auth/google_auth_service.dart`

```dart
// Google Sign-In with event-based API (7.2.0)
final user = await GoogleAuthService.signIn();
if (user != null) {
  final auth = await user.authentication;
  final idToken = auth.idToken; // Send to backend for validation
}

// Sign out
await GoogleAuthService.signOut();
```

**Provider Location**: `lib/features/auth/providers/login_provider.dart`

```dart
// Login with Google
final success = await ref.read(loginProvider.notifier).loginWithGoogle();
if (success) {
  context.go(AppRoutes.home);
}
```

**Key Implementation Details**:
- Event-based API with Completer pattern for async flow
- No accessToken or serverAuthCode in 7.x (use idToken only)
- Provider lifecycle management with ref.mounted checks
- Automatic navigation after successful authentication

### Routing System

**Route Definition**: `lib/core/router/routes.dart`

```dart
class AppRoutes {
  static const String login = '/auth/login';
  static const String home = '/home';
  static const String snsContentsList = '/home/sns-contents';
  static const String snsContentDetail = '/home/sns-contents/detail/:contentId';
  static const String placeDetail = '/place-detail/:placeId';
  // ... more routes
}
```

**Usage in Navigation**:

```dart
// Simple navigation
context.go(AppRoutes.home);

// With parameters
final detailPath = AppRoutes.placeDetail.replaceFirst(':placeId', place.id);
context.go(detailPath, extra: place);

// Push (preserves back stack)
context.push(AppRoutes.snsContentsList);
```

**⚠️ IMPORTANT**: Never use hardcoded route strings. Always use AppRoutes constants.

## Content Sharing Functionality

**Service Location**: `lib/core/services/sharing_service.dart`

**Supported Types**: Text, URLs, Images, Videos, Documents

**Platform Configuration**:
- Android: `android/app/src/main/AndroidManifest.xml`
- iOS: `ios/Runner/Info.plist`

**Usage Pattern**:

```dart
// Initialize in main.dart
await SharingService.instance.initialize();

// Listen to shared data in HomeScreen
_sharingService.dataStream.listen((SharedData data) {
  if (data.hasTextData) {
    // Handle text/URLs
    for (final text in data.sharedTexts) {
      if (UrlFormatter.isValidUrl(text)) {
        final cleanUrl = UrlFormatter.cleanUrl(text);
        final urlType = UrlFormatter.getUrlType(cleanUrl);
        // Process based on platform (youtube, instagram, etc.)
      }
    }
  }

  if (data.hasMediaData) {
    // Handle images, videos, documents
    final images = data.images;
    final videos = data.videos;
  }
});
```

**URL Processing**:
- Automatic tracking parameter removal (utm_, fbclid, etc.)
- Platform detection (YouTube, Instagram, Blog, etc.)
- Domain extraction for display

## Claude Code 개발 지침

**개발자 역할**: 시니어 플러터 개발자로서 신중하고 자세한 답변을 제공하며 뛰어난 사고력을 바탕으로 개발 지원

### 개발 원칙

1. **단계별 사고와 계획**
   - 사용자 질문에 먼저 단계별로 생각하며 계획을 세워 답변
   - 복잡한 문제는 작은 단위로 분해하여 해결

2. **코드 품질 기준**
   - 올바르고 모범적인 DRY 원칙(Don't Repeat Yourself)을 준수하는 중복 없는 코드
   - 버그 없는 안정적인 코드 작성
   - 가독성을 우선하되, 성능을 고려한 최적화된 코드

3. **기능 구현**
   - 요청된 모든 기능을 완전히 구현
   - 절반만 구현하거나 TODO 주석으로 남기지 않음
   - 실제 동작하는 완성된 코드 제공

4. **솔직한 소통**
   - 모르는 경우는 솔직하게 모른다고 답변
   - 추가 조사가 필요한 경우 이를 명확히 언급
   - 추측이나 불확실한 정보 제공 금지

5. **언어 및 설명**
   - 별도 요청사항이 없으면 모든 응답은 한국어로 작성
   - 사용자가 주니어 개발자라고 가정하고 코드에 대한 자세한 설명 포함
   - 복잡한 개념은 쉽게 풀어서 설명
   - 모든 코드에는 한국어 주석으로 기능과 목적을 명확히 설명
   - 함수나 클래스의 역할, 매개변수, 반환값을 주석으로 문서화
   - 복잡한 비즈니스 로직이나 알고리즘은 단계별로 주석 작성

### Flutter 개발 특화 지침

#### 필수 사항

1. **라우팅**:
   - ❌ 절대 하드코딩된 경로 사용 금지 (`'/home'`, `'/login'` 등)
   - ✅ 반드시 `AppRoutes` 상수 사용 (`AppRoutes.home`, `AppRoutes.login`)
   - 동적 파라미터는 `replaceFirst()` 사용

2. **상태 관리**:
   - Riverpod `@riverpod` 어노테이션 사용
   - Provider disposal 전 `ref.mounted` 체크 필수
   - 비즈니스 로직 성공/실패와 UI 상태 관리 분리

3. **반응형 UI**:
   - 모든 크기 값에 ScreenUtil 사용 (`.w`, `.h`, `.sp`, `.r`)
   - 절대 하드코딩된 픽셀 값 사용 금지

4. **다국어 지원**:
   - 모든 사용자 노출 텍스트는 `AppLocalizations.of(context)` 사용
   - 하드코딩된 문자열 금지

#### 권장 사항

- **로딩 효과**: Shimmer 패키지로 스켈레톤 화면 구현
- **이미지**: CachedNetworkImage + Shimmer placeholder
- **폰트**: Pretendard 폰트 패밀리 사용
- **애니메이션**: Lottie, Flutter Animate 조합
- **SVG 아이콘**: flutter_svg 사용
- **보안**: Flutter Secure Storage로 민감 데이터 관리

## 주요 패키지 사용 예제

### ScreenUtil (반응형 UI)

```dart
// main.dart에서 ScreenUtil 초기화
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      // 디자인 기준 사이즈 (보통 iPhone 6/7/8 Plus 기준)
      designSize: Size(414, 896),
      minTextAdapt: true, // 텍스트 크기 자동 조정
      splitScreenMode: true, // 분할 화면 모드 지원
      builder: (context, child) {
        return MaterialApp(
          title: 'Tripgether',
          home: child,
        );
      },
      child: HomeScreen(),
    );
  }
}

// 위젯에서 ScreenUtil 사용 예제
class ProfileCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      // 너비: 디자인 기준의 300px에 대응하는 반응형 크기
      width: 300.w,
      // 높이: 디자인 기준의 120px에 대응하는 반응형 크기
      height: 120.h,
      // 패딩: 좌우 16px, 상하 12px
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      child: Text(
        '사용자 프로필',
        style: TextStyle(
          fontFamily: 'Pretendard',
          // 폰트 크기: 디자인 기준 18px에 대응
          fontSize: 18.sp,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
```

### Shimmer (스켈레톤 로딩)

```dart
import 'package:shimmer/shimmer.dart';

// 리스트 아이템 스켈레톤
class TripCardSkeleton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!, // 기본 색상
      highlightColor: Colors.grey[100]!, // 하이라이트 색상
      child: Card(
        margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 이미지 플레이스홀더
              Container(
                width: double.infinity,
                height: 200.h,
                color: Colors.white,
              ),
              SizedBox(height: 12.h),
              // 제목 플레이스홀더
              Container(
                width: 200.w,
                height: 16.h,
                color: Colors.white,
              ),
              SizedBox(height: 8.h),
              // 설명 플레이스홀더
              Container(
                width: 150.w,
                height: 14.h,
                color: Colors.white,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// 사용 예제: 데이터 로딩 상태에 따른 분기 처리
class TripListScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tripsAsync = ref.watch(tripListProvider);

    return Scaffold(
      body: tripsAsync.when(
        loading: () => ListView.builder(
          itemCount: 5, // 스켈레톤 개수
          itemBuilder: (context, index) => TripCardSkeleton(),
        ),
        error: (error, stack) => Center(child: Text('오류: $error')),
        data: (trips) => ListView.builder(
          itemCount: trips.length,
          itemBuilder: (context, index) => TripCard(trip: trips[index]),
        ),
      ),
    );
  }
}
```

### CachedNetworkImage (이미지 캐싱)

```dart
import 'package:cached_network_image/cached_network_image.dart';

class TripImageWidget extends StatelessWidget {
  final String imageUrl;

  const TripImageWidget({required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: imageUrl,
      // 이미지 크기 지정 (ScreenUtil 활용)
      width: double.infinity,
      height: 200.h,
      fit: BoxFit.cover,
      // 로딩 중 플레이스홀더 (Shimmer 활용)
      placeholder: (context, url) => Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: Container(
          width: double.infinity,
          height: 200.h,
          color: Colors.white,
        ),
      ),
      // 에러 시 표시할 위젯
      errorWidget: (context, url, error) => Container(
        width: double.infinity,
        height: 200.h,
        color: Colors.grey[200],
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error, color: Colors.grey[400], size: 48.w),
            SizedBox(height: 8.h),
            Text(
              '이미지를 불러올 수 없습니다',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14.sp,
                fontFamily: 'Pretendard',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
```

### Flutter SVG (커스텀 아이콘)

```dart
import 'package:flutter_svg/flutter_svg.dart';

// Bottom Navigation에서 SVG 아이콘 사용
class CustomBottomNavigation extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const CustomBottomNavigation({
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onTap,
      type: BottomNavigationBarType.fixed,
      items: [
        BottomNavigationBarItem(
          icon: SvgPicture.asset(
            'assets/navigation_icons/home_inactive.svg',
            width: 24.w, // ScreenUtil로 크기 조정
            height: 24.h,
          ),
          activeIcon: SvgPicture.asset(
            'assets/navigation_icons/home_active.svg',
            width: 24.w,
            height: 24.h,
          ),
          label: '홈',
        ),
        // ... 다른 탭들
      ],
    );
  }
}

// 일반 위젯에서 SVG 아이콘 사용
class IconButton extends StatelessWidget {
  final VoidCallback onPressed;

  const IconButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 48.w,
        height: 48.h,
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(8.r), // ScreenUtil의 radius
        ),
        child: Center(
          child: SvgPicture.asset(
            'assets/icons/search.svg',
            width: 20.w,
            height: 20.h,
            colorFilter: ColorFilter.mode(
              Theme.of(context).primaryColor,
              BlendMode.srcIn,
            ),
          ),
        ),
      ),
    );
  }
}
```

### InfiniteScrollPagination (무한 스크롤)

```dart
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class InfiniteTripList extends ConsumerStatefulWidget {
  @override
  ConsumerState<InfiniteTripList> createState() => _InfiniteTripListState();
}

class _InfiniteTripListState extends ConsumerState<InfiniteTripList> {
  static const _pageSize = 20; // 한 번에 로드할 아이템 수
  final PagingController<int, Trip> _pagingController =
      PagingController(firstPageKey: 0);

  @override
  void initState() {
    super.initState();
    // 페이지 요청 리스너 등록
    _pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });
  }

  Future<void> _fetchPage(int pageKey) async {
    try {
      // API에서 데이터 가져오기
      final newItems = await ref.read(tripServiceProvider).getTrips(
        page: pageKey,
        pageSize: _pageSize,
      );

      // 마지막 페이지인지 확인
      final isLastPage = newItems.length < _pageSize;
      if (isLastPage) {
        _pagingController.appendLastPage(newItems);
      } else {
        final nextPageKey = pageKey + newItems.length;
        _pagingController.appendPage(newItems, nextPageKey);
      }
    } catch (error) {
      _pagingController.error = error;
    }
  }

  @override
  Widget build(BuildContext context) {
    return PagedListView<int, Trip>(
      pagingController: _pagingController,
      builderDelegate: PagedChildBuilderDelegate<Trip>(
        itemBuilder: (context, item, index) => TripCard(trip: item),
        // 로딩 인디케이터 (Shimmer 활용)
        firstPageProgressIndicatorBuilder: (_) => ListView.builder(
          itemCount: 5,
          itemBuilder: (context, index) => TripCardSkeleton(),
        ),
        // 새 페이지 로딩 인디케이터
        newPageProgressIndicatorBuilder: (_) => Center(
          child: Padding(
            padding: EdgeInsets.all(16.w),
            child: CircularProgressIndicator(),
          ),
        ),
        // 에러 위젯
        firstPageErrorIndicatorBuilder: (_) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '데이터를 불러올 수 없습니다',
                style: TextStyle(fontSize: 16.sp, fontFamily: 'Pretendard'),
              ),
              SizedBox(height: 16.h),
              ElevatedButton(
                onPressed: () => _pagingController.refresh(),
                child: Text('다시 시도'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }
}
```

### PullToRefresh (당겨서 새로고침)

```dart
import 'package:pull_to_refresh/pull_to_refresh.dart';

class RefreshableTripList extends ConsumerStatefulWidget {
  @override
  ConsumerState<RefreshableTripList> createState() => _RefreshableTripListState();
}

class _RefreshableTripListState extends ConsumerState<RefreshableTripList> {
  final RefreshController _refreshController = RefreshController(initialRefresh: false);

  void _onRefresh() async {
    try {
      // 데이터 새로고침
      await ref.refresh(tripListProvider.future);
      _refreshController.refreshCompleted();
    } catch (error) {
      _refreshController.refreshFailed();
    }
  }

  void _onLoading() async {
    try {
      // 추가 데이터 로드
      await ref.read(tripListProvider.notifier).loadMore();
      _refreshController.loadComplete();
    } catch (error) {
      _refreshController.loadFailed();
    }
  }

  @override
  Widget build(BuildContext context) {
    final tripsAsync = ref.watch(tripListProvider);

    return SmartRefresher(
      controller: _refreshController,
      enablePullDown: true, // 당겨서 새로고침 활성화
      enablePullUp: true,   // 위로 당겨서 더 로드 활성화
      onRefresh: _onRefresh,
      onLoading: _onLoading,
      // 커스텀 새로고침 헤더
      header: WaterDropMaterialHeader(
        backgroundColor: Theme.of(context).primaryColor,
      ),
      // 커스텀 로딩 푸터
      footer: CustomFooter(
        builder: (BuildContext context, LoadStatus mode) {
          Widget body;
          if (mode == LoadStatus.idle) {
            body = Text(
              "위로 당겨서 더 보기",
              style: TextStyle(fontSize: 14.sp, fontFamily: 'Pretendard'),
            );
          } else if (mode == LoadStatus.loading) {
            body = CircularProgressIndicator();
          } else if (mode == LoadStatus.failed) {
            body = Text(
              "로드 실패, 다시 시도하세요",
              style: TextStyle(fontSize: 14.sp, fontFamily: 'Pretendard'),
            );
          } else {
            body = Text(
              "더 이상 데이터가 없습니다",
              style: TextStyle(fontSize: 14.sp, fontFamily: 'Pretendard'),
            );
          }
          return Container(
            height: 55.h,
            child: Center(child: body),
          );
        },
      ),
      child: tripsAsync.when(
        loading: () => ListView.builder(
          itemCount: 5,
          itemBuilder: (context, index) => TripCardSkeleton(),
        ),
        error: (error, stack) => Center(child: Text('오류: $error')),
        data: (trips) => ListView.builder(
          itemCount: trips.length,
          itemBuilder: (context, index) => TripCard(trip: trips[index]),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _refreshController.dispose();
    super.dispose();
  }
}
```

## 코드 주석 작성 규칙

### 함수/클래스 문서화

```dart
/// 사용자의 여행 목록을 관리하는 서비스 클래스
///
/// API를 통해 여행 데이터를 가져오고, 로컬 캐시를 관리합니다.
/// Riverpod을 사용하여 상태 관리를 수행합니다.
class TripService {
  final ApiClient _apiClient;
  final CacheManager _cacheManager;

  TripService(this._apiClient, this._cacheManager);

  /// 사용자의 모든 여행 목록을 가져옵니다
  ///
  /// [userId] 사용자 ID (필수)
  /// [includeArchived] 보관된 여행 포함 여부 (기본값: false)
  ///
  /// Returns: 여행 목록 (List<Trip>)
  /// Throws: [ApiException] API 호출 실패 시
  /// Throws: [NetworkException] 네트워크 연결 오류 시
  Future<List<Trip>> fetchTrips({
    required String userId,
    bool includeArchived = false,
  }) async {
    // 1. 캐시에서 먼저 확인
    final cachedTrips = await _cacheManager.getTrips(userId);
    if (cachedTrips != null && !_cacheManager.isExpired(cachedTrips)) {
      return cachedTrips.data;
    }

    // 2. API에서 최신 데이터 가져오기
    try {
      final response = await _apiClient.getTrips(
        userId: userId,
        includeArchived: includeArchived,
      );

      // 3. 캐시에 저장 (1시간 유효)
      await _cacheManager.saveTrips(
        userId,
        response.data,
        duration: Duration(hours: 1),
      );

      return response.data;
    } catch (e) {
      // 4. 에러 발생 시 캐시된 데이터라도 반환 (있다면)
      if (cachedTrips != null) {
        return cachedTrips.data;
      }
      rethrow;
    }
  }
}
```

### 복잡한 UI 위젯 주석

```dart
/// 여행 카드 위젯
///
/// 여행의 기본 정보(제목, 이미지, 날짜, 참가자)를 표시하며,
/// 탭 시 여행 상세 화면으로 이동합니다.
class TripCard extends ConsumerWidget {
  /// 표시할 여행 데이터
  final Trip trip;

  /// 카드 탭 시 실행될 콜백 함수
  final VoidCallback? onTap;

  /// 카드의 마진 여부 (기본값: true)
  final bool hasMargin;

  const TripCard({
    super.key,
    required this.trip,
    this.onTap,
    this.hasMargin = true,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: onTap ?? () {
        // 기본 동작: 여행 상세 화면으로 이동
        context.push('/trips/${trip.id}');
      },
      child: Container(
        // ScreenUtil을 사용하여 반응형 마진 적용
        margin: hasMargin
          ? EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h)
          : EdgeInsets.zero,
        child: Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 여행 대표 이미지 (CachedNetworkImage 사용)
              _buildTripImage(),

              // 여행 정보 영역
              Padding(
                padding: EdgeInsets.all(16.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 여행 제목
                    _buildTripTitle(),

                    SizedBox(height: 8.h),

                    // 여행 날짜 및 기간
                    _buildTripDates(),

                    SizedBox(height: 12.h),

                    // 참가자 아바타 목록
                    _buildParticipants(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 여행 대표 이미지를 구성하는 위젯
  /// Shimmer 로딩 효과와 에러 처리를 포함
  Widget _buildTripImage() {
    return ClipRRect(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(12.r),
        topRight: Radius.circular(12.r),
      ),
      child: CachedNetworkImage(
        imageUrl: trip.imageUrl ?? '',
        height: 200.h,
        width: double.infinity,
        fit: BoxFit.cover,
        placeholder: (context, url) => Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Container(
            height: 200.h,
            width: double.infinity,
            color: Colors.white,
          ),
        ),
        errorWidget: (context, url, error) => Container(
          height: 200.h,
          width: double.infinity,
          color: Colors.grey[200],
          child: Icon(Icons.image_not_supported, size: 48.w),
        ),
      ),
    );
  }

  /// 여행 제목 텍스트 위젯
  Widget _buildTripTitle() {
    return Text(
      trip.title,
      style: TextStyle(
        fontFamily: 'Pretendard',
        fontSize: 18.sp,
        fontWeight: FontWeight.w600,
        color: Colors.black87,
      ),
      maxLines: 2, // 최대 2줄까지 표시
      overflow: TextOverflow.ellipsis, // 넘치는 텍스트는 ... 으로 처리
    );
  }

  // ... 기타 위젯 빌더 메서드들
}
```

### 비즈니스 로직 주석 예시

```dart
/// 여행 공유 서비스
/// 여행 정보를 다양한 플랫폼에 공유하는 기능을 제공합니다
class TripSharingService {
  /// 여행을 이미지와 함께 공유합니다
  ///
  /// 공유 과정:
  /// 1. 여행 정보로 공유용 이미지 생성
  /// 2. 공유 텍스트 구성 (제목, 기간, 딥링크)
  /// 3. 시스템 공유 다이얼로그 표시
  Future<void> shareTrip(Trip trip) async {
    try {
      // 1. 공유용 이미지 생성 (1080x1080, 인스타그램 최적화)
      final shareImage = await _generateShareImage(trip);

      // 2. 공유 텍스트 구성
      final shareText = _buildShareText(trip);

      // 3. 딥링크 생성
      final deepLink = 'https://tripgether.com/trip/${trip.id}';

      // 4. 공유 실행
      await Share.shareXFiles([shareImage], text: '$shareText\n$deepLink');
    } catch (e) {
      // 공유 실패 시 에러 로깅
      debugPrint('여행 공유 실패: $e');
      rethrow;
    }
  }
}