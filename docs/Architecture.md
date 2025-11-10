# Tripgether 아키텍처 문서

> 🚀 **Flutter 여행 계획 협업 앱의 기술 아키텍처 가이드**

## 📋 목차

- [개요](#개요)
- [기술 스택](#기술-스택)
- [프로젝트 구조](#프로젝트-구조)
- [아키텍처 패턴](#아키텍처-패턴)
- [상태 관리](#상태-관리)
- [라우팅 시스템](#라우팅-시스템)
- [인증 흐름](#인증-흐름)
- [서비스 레이어](#서비스-레이어)
- [데이터 흐름](#데이터-흐름)

---

## 개요

Tripgether는 **Flutter** 기반의 크로스 플랫폼 여행 계획 협업 앱으로, **Clean Architecture** 원칙과 **Feature-First** 구조를 따릅니다.

### 핵심 설계 원칙

- ✅ **관심사의 분리 (Separation of Concerns)**: UI, 비즈니스 로직, 데이터 레이어 명확 분리
- ✅ **재사용성 (Reusability)**: 공용 컴포넌트와 서비스의 중앙 집중식 관리
- ✅ **테스트 가능성 (Testability)**: 의존성 주입과 추상화를 통한 단위 테스트 용이성
- ✅ **확장성 (Scalability)**: Feature 모듈 단위의 독립적 개발 및 확장

---

## 기술 스택

### 핵심 프레임워크

| 영역 | 기술 | 버전 | 용도 |
|------|------|------|------|
| **Framework** | Flutter | 3.24.5+ | 크로스 플랫폼 UI |
| **Language** | Dart | 3.5.4+ | 프로그래밍 언어 |
| **State Management** | Riverpod | 2.6.1 | 선언적 상태 관리 |
| **Code Generation** | build_runner | 2.4.13 | Riverpod 코드 생성 |

### 주요 패키지

#### UI & 디자인

```yaml
flutter_screenutil: ^5.9.3      # 반응형 UI (ScreenUtil)
cached_network_image: ^3.4.1    # 이미지 캐싱 및 로딩
shimmer: ^3.0.0                 # 스켈레톤 로딩 UI
flutter_svg: ^2.0.10+1          # SVG 아이콘 렌더링
```

#### 라우팅 & 내비게이션

```yaml
go_router: ^14.6.2              # 선언적 라우팅 시스템
```

#### 인증 & 보안

```yaml
google_sign_in: ^7.2.0          # Google OAuth 인증
flutter_secure_storage: ^9.2.2  # 보안 토큰 저장
```

#### 푸시 알림

```yaml
firebase_core: ^3.8.1           # Firebase 초기화
firebase_messaging: ^15.1.5     # FCM 푸시 알림
flutter_local_notifications: ^18.0.1  # 로컬 알림 표시
```

#### 다국어 & 환경 설정

```yaml
intl: ^0.19.0                   # 국제화 (i18n)
flutter_dotenv: ^5.2.1          # 환경 변수 관리
```

#### 유틸리티

```yaml
freezed: ^2.5.7                 # Immutable 데이터 클래스
json_serializable: ^6.8.0       # JSON 직렬화
share_plus: ^10.1.2             # 외부 앱 공유
device_info_plus: ^11.1.1       # 디바이스 정보 수집
```

---

## 프로젝트 구조

### 디렉토리 레이아웃

```
lib/
├── core/                       # 핵심 인프라 (앱 전역 리소스)
│   ├── theme/                  # 디자인 시스템 (Colors, TextStyles, Spacing)
│   │   ├── app_colors.dart     # 색상 정의
│   │   ├── app_text_styles.dart # 텍스트 스타일
│   │   ├── app_spacing.dart    # 간격, Radius, Elevation, Sizes
│   │   └── app_theme.dart      # Material 3 통합 테마
│   ├── router/                 # 라우팅 시스템
│   │   ├── router.dart         # GoRouter 설정
│   │   ├── routes.dart         # 라우트 경로 상수
│   │   └── route_guards.dart   # 인증 가드
│   ├── services/               # 비즈니스 서비스
│   │   ├── auth/
│   │   │   └── google_auth_service.dart  # Google OAuth
│   │   ├── fcm/
│   │   │   ├── firebase_messaging_service.dart  # FCM 관리
│   │   │   ├── local_notifications_service.dart # 로컬 알림
│   │   │   └── models/fcm_token_request.dart    # FCM 모델
│   │   ├── sharing_service.dart     # 외부 앱 공유
│   │   └── device_info_service.dart # 디바이스 정보
│   ├── providers/              # 전역 Provider
│   │   └── locale_provider.dart     # 언어 설정
│   ├── utils/                  # 유틸리티 함수
│   │   ├── dialog_utils.dart   # 다이얼로그 헬퍼
│   │   └── url_formatter.dart  # URL 포맷팅
│   └── animations/             # 공용 애니메이션
│       └── page_transitions.dart    # 페이지 전환 효과
│
├── features/                   # 기능별 모듈 (Feature-First)
│   ├── auth/                   # 인증 기능
│   │   ├── models/             # 인증 데이터 모델
│   │   ├── providers/          # 인증 상태 관리
│   │   ├── services/           # 인증 API 서비스
│   │   └── presentation/       # UI 레이어
│   │       ├── pages/          # 화면 (LoginPage)
│   │       └── widgets/        # 화면별 위젯
│   ├── onboarding/             # 온보딩 (첫 로그인 정보 입력)
│   ├── home/                   # 홈 탭
│   ├── course_market/          # 코스마켓 탭
│   ├── map/                    # 지도 탭
│   ├── schedule/               # 일정 탭
│   └── my_page/                # 마이페이지 탭
│
├── shared/                     # 공용 컴포넌트 (재사용 위젯)
│   └── widgets/
│       ├── common/             # 범용 위젯
│       │   ├── common_app_bar.dart       # 공용 AppBar
│       │   ├── empty_state.dart          # 빈 상태 표시
│       │   ├── chip_list.dart            # 칩 리스트
│       │   └── profile_avatar.dart       # 프로필 아바타
│       ├── buttons/            # 버튼 위젯
│       │   ├── common_button.dart        # Primary/Secondary/Tertiary
│       │   └── social_login_button.dart  # 소셜 로그인 버튼
│       ├── cards/              # 카드 위젯
│       │   ├── sns_content_card.dart     # SNS 콘텐츠 카드
│       │   ├── place_card.dart           # 장소 카드
│       │   └── course_card.dart          # 코스 카드
│       ├── inputs/             # 입력 위젯
│       │   ├── search_bar.dart           # 검색바
│       │   └── onboarding_text_field.dart # 온보딩 입력 필드
│       └── layout/             # 레이아웃 위젯
│           ├── gradient_background.dart  # 그라데이션 배경
│           ├── section_header.dart       # 섹션 헤더
│           ├── greeting_section.dart     # 인사말 섹션
│           └── bottom_navigation.dart    # 바텀 네비게이션
│
├── l10n/                       # 다국어 지원 (ARB 파일)
│   ├── app_en.arb              # 영어
│   └── app_ko.arb              # 한국어
│
└── main.dart                   # 앱 진입점
```

### 구조 원칙

#### 1. **Feature-First 구조**
각 기능은 독립적인 모듈로 구성되어 있어, 기능 단위로 개발/테스트/배포가 가능합니다.

```
features/auth/
  ├── models/          # 데이터 모델 (User, AuthState 등)
  ├── providers/       # 상태 관리 (UserNotifier, AuthNotifier)
  ├── services/        # API 통신 (AuthApiService)
  └── presentation/    # UI 레이어 (LoginPage, LoginForm)
```

#### 2. **Core 레이어의 역할**
- **theme/**: 디자인 시스템 (모든 UI는 이 테마를 사용해야 함)
- **router/**: 앱 전체의 라우팅 로직
- **services/**: 비즈니스 로직 (인증, FCM, 공유 등)
- **providers/**: 전역 상태 (언어 설정 등)

#### 3. **Shared 레이어의 역할**
재사용 가능한 UI 컴포넌트를 중앙 집중식으로 관리하여:
- 코드 중복 방지
- 디자인 일관성 유지
- 유지보수 효율성 향상

---

## 아키텍처 패턴

### Clean Architecture + Feature-First

```
┌─────────────────────────────────────────────┐
│           Presentation Layer                │  ← UI (Pages, Widgets)
│  (features/*/presentation/pages, widgets)   │
├─────────────────────────────────────────────┤
│          Business Logic Layer               │  ← State Management (Providers, Notifiers)
│       (features/*/providers/)               │
├─────────────────────────────────────────────┤
│            Service Layer                    │  ← API, External Services
│  (features/*/services, core/services)       │
├─────────────────────────────────────────────┤
│             Data Layer                      │  ← Models, DTOs
│        (features/*/models/)                 │
└─────────────────────────────────────────────┘
```

### 레이어별 책임

#### **Presentation Layer (UI)**
- **책임**: 사용자 인터페이스 렌더링, 사용자 입력 처리
- **의존성**: Providers (상태 읽기), Widgets (재사용 컴포넌트)
- **예시**: `LoginPage`, `HomeScreen`, `CourseCard`

#### **Business Logic Layer (상태 관리)**
- **책임**: 앱 상태 관리, 비즈니스 로직 실행
- **의존성**: Services (API 호출), Models (데이터 구조)
- **예시**: `UserNotifier`, `AuthNotifier`, `LocaleProvider`

#### **Service Layer (외부 통신)**
- **책임**: 외부 API 통신, 플랫폼 기능 호출
- **의존성**: Models (요청/응답 변환)
- **예시**: `GoogleAuthService`, `FirebaseMessagingService`, `AuthApiService`

#### **Data Layer (데이터 모델)**
- **책임**: 데이터 구조 정의, 직렬화/역직렬화
- **의존성**: 없음 (순수 데이터 클래스)
- **예시**: `User`, `FcmTokenRequest`, `AuthState`

---

## 상태 관리

### Riverpod 2.x (@riverpod 어노테이션)

Tripgether는 **Riverpod 2.x**의 코드 생성 기반 어노테이션 방식을 사용합니다.

#### Provider 작성 패턴

```dart
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'user_provider.g.dart';

@riverpod
class UserNotifier extends _$UserNotifier {
  @override
  Future<User?> build() async {
    // 초기 상태 로드
    return await _loadUserFromStorage();
  }

  Future<void> signInWithGoogle() async {
    state = const AsyncValue.loading();

    try {
      final account = await GoogleAuthService.signIn();
      // 백엔드 API 호출 및 사용자 정보 저장
      final user = await _authApiService.socialLogin(account);
      state = AsyncValue.data(user);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }
}
```

#### UI에서 Provider 사용

```dart
class LoginPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userState = ref.watch(userNotifierProvider);

    return userState.when(
      data: (user) => user == null ? _buildLoginForm() : _navigateToHome(),
      loading: () => CircularProgressIndicator(),
      error: (error, stack) => ErrorWidget(error),
    );
  }

  void _handleGoogleLogin(WidgetRef ref) {
    ref.read(userNotifierProvider.notifier).signInWithGoogle();
  }
}
```

#### 코드 생성 명령어

```bash
# 개발 중 자동 감지 및 재생성
dart run build_runner watch

# 일회성 생성
dart run build_runner build

# 기존 파일 삭제 후 재생성
dart run build_runner build --delete-conflicting-outputs
```

---

## 라우팅 시스템

### GoRouter 기반 선언적 라우팅

#### 라우트 경로 상수 관리 (`core/router/routes.dart`)

```dart
class AppRoutes {
  // 인증 화면
  static const String login = '/auth/login';
  static const String onboarding = '/onboarding';

  // 메인 탭들 (ShellRoute로 묶임)
  static const String home = '/home';
  static const String courseMarket = '/course-market';
  static const String map = '/map';
  static const String schedule = '/schedule';
  static const String myPage = '/my-page';

  // 상세 화면
  static const String courseDetail = '/course-market/detail/:courseId';
  static const String placeDetail = '/home/saved-places/:placeId';
}
```

#### GoRouter 설정 (`core/router/router.dart`)

```dart
final goRouterProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(userNotifierProvider);

  return GoRouter(
    initialLocation: AppRoutes.splash,
    redirect: (context, state) {
      final isLoggedIn = authState.value != null;
      final isLoginRoute = state.matchedLocation == AppRoutes.login;

      // 미인증 사용자 → 로그인 화면
      if (!isLoggedIn && !isLoginRoute) {
        return AppRoutes.login;
      }

      // 인증된 사용자 → 홈 화면
      if (isLoggedIn && isLoginRoute) {
        return AppRoutes.home;
      }

      return null; // 변경 없음
    },
    routes: [
      // ShellRoute: 바텀 네비게이션이 있는 레이아웃
      ShellRoute(
        builder: (context, state, child) => MainShell(child: child),
        routes: [
          GoRoute(path: AppRoutes.home, builder: (context, state) => HomePage()),
          GoRoute(path: AppRoutes.courseMarket, builder: (context, state) => CourseMarketPage()),
          // ... 나머지 탭들
        ],
      ),

      // 인증 화면 (ShellRoute 외부)
      GoRoute(path: AppRoutes.login, builder: (context, state) => LoginPage()),
    ],
  );
});
```

#### 네비게이션 사용

```dart
// 화면 이동
context.go(AppRoutes.home);

// 파라미터가 있는 화면 이동
context.go('/course-market/detail/123');

// 뒤로가기 가능한 push
context.push(AppRoutes.settings);

// 뒤로가기
context.pop();
```

---

## 인증 흐름

### Google OAuth 인증 프로세스

```
┌─────────────┐
│ 사용자 탭   │
│ "Google로   │
│  시작하기"  │
└──────┬──────┘
       │
       ▼
┌──────────────────────────────────────┐
│ GoogleAuthService.signIn()           │
│ - authenticate() 호출                │
│ - authenticationEvents 스트림 구독   │
│ - GoogleSignInAccount 반환           │
└──────┬───────────────────────────────┘
       │
       ▼
┌──────────────────────────────────────┐
│ AuthApiService.socialLogin()         │
│ - 백엔드에 Google 인증 정보 전송     │
│ - JWT 토큰 발급 받기                 │
└──────┬───────────────────────────────┘
       │
       ▼
┌──────────────────────────────────────┐
│ FlutterSecureStorage에 JWT 저장      │
│ - accessToken 저장                   │
│ - refreshToken 저장 (있을 경우)      │
└──────┬───────────────────────────────┘
       │
       ▼
┌──────────────────────────────────────┐
│ UserNotifier 상태 업데이트           │
│ - state = AsyncValue.data(user)      │
└──────┬───────────────────────────────┘
       │
       ▼
┌──────────────────────────────────────┐
│ GoRouter 자동 리다이렉트             │
│ - /auth/login → /home                │
└──────────────────────────────────────┘
```

### 인증 서비스 구조

#### GoogleAuthService (플랫폼 인증)

```dart
class GoogleAuthService {
  static Future<void> initialize() async {
    await GoogleSignIn.instance.initialize(
      clientId: Platform.isIOS ? dotenv.env['GOOGLE_IOS_CLIENT_ID'] : null,
      serverClientId: dotenv.env['GOOGLE_WEB_CLIENT_ID'],
    );
  }

  static Future<GoogleSignInAccount?> signIn() async {
    final completer = Completer<GoogleSignInAccount?>();

    GoogleSignIn.instance.authenticationEvents.listen((event) {
      if (event is GoogleSignInAuthenticationEventSignIn) {
        completer.complete(event.user);
      }
    });

    await GoogleSignIn.instance.authenticate(scopeHint: ['email', 'profile']);
    return completer.future;
  }
}
```

#### AuthApiService (백엔드 통신)

```dart
class AuthApiService {
  Future<User> socialLogin({
    required String socialPlatform,
    required String email,
    required String? nickname,
  }) async {
    final response = await http.post(
      Uri.parse('${baseUrl}/api/auth/sign-in'),
      body: jsonEncode({
        'socialPlatform': socialPlatform,
        'email': email,
        'nickname': nickname,
      }),
    );

    final data = jsonDecode(response.body);

    // JWT 토큰 저장
    await _secureStorage.write(key: 'accessToken', value: data['accessToken']);

    return User.fromJson(data['user']);
  }
}
```

---

## 서비스 레이어

### 주요 서비스

#### 1. GoogleAuthService
- **역할**: Google OAuth 인증 처리
- **위치**: `core/services/auth/google_auth_service.dart`
- **주요 메서드**:
  - `initialize()`: Google Sign-In SDK 초기화
  - `signIn()`: Google 로그인 실행
  - `signOut()`: Google 로그아웃

#### 2. FirebaseMessagingService
- **역할**: FCM 푸시 알림 관리
- **위치**: `core/services/fcm/firebase_messaging_service.dart`
- **주요 메서드**:
  - `init()`: FCM 초기화 및 토큰 발급
  - `requestPermission()`: iOS 푸시 권한 요청
  - `onMessageReceived()`: 포그라운드 알림 처리
  - `onBackgroundMessage()`: 백그라운드 알림 처리

#### 3. LocalNotificationsService
- **역할**: 로컬 알림 표시 (FCM 알림을 실제로 표시)
- **위치**: `core/services/fcm/local_notifications_service.dart`
- **주요 메서드**:
  - `init()`: 로컬 알림 플러그인 초기화
  - `showNotification()`: 알림 표시

#### 4. SharingService
- **역할**: 외부 앱으로부터 공유된 링크 수신
- **위치**: `core/services/sharing_service.dart`
- **주요 메서드**:
  - `initialize()`: 공유 수신 리스너 등록
  - `handleSharedUrl()`: 수신한 URL 처리

#### 5. DeviceInfoService
- **역할**: 디바이스 정보 수집 (OS, 모델, 버전 등)
- **위치**: `core/services/device_info_service.dart`
- **주요 메서드**:
  - `getDeviceInfo()`: 플랫폼별 디바이스 정보 반환

---

## 데이터 흐름

### 일반적인 데이터 흐름

```
User Action (버튼 탭)
       │
       ▼
UI Component (ConsumerWidget)
       │
       │ ref.read(provider.notifier).method()
       ▼
Provider (Notifier)
       │
       │ state = AsyncValue.loading()
       ▼
Service Layer (API 호출)
       │
       │ HTTP Request → Backend
       ▼
Service Layer (응답 처리)
       │
       │ Model.fromJson(response)
       ▼
Provider (상태 업데이트)
       │
       │ state = AsyncValue.data(model)
       ▼
UI Component (자동 재렌더링)
       │
       ▼
User Sees Updated UI
```

### 구체적 예시: Google 로그인

1. **사용자 액션**
   ```dart
   PrimaryButton(
     text: 'Google로 시작하기',
     onPressed: () => ref.read(userNotifierProvider.notifier).signInWithGoogle(),
   )
   ```

2. **Provider 메서드 실행**
   ```dart
   Future<void> signInWithGoogle() async {
     state = const AsyncValue.loading(); // 로딩 상태

     try {
       // Google OAuth 인증
       final account = await GoogleAuthService.signIn();

       // 백엔드 API 호출
       final user = await _authApiService.socialLogin(
         socialPlatform: 'GOOGLE',
         email: account.email,
         nickname: account.displayName,
       );

       state = AsyncValue.data(user); // 성공 상태
     } catch (e, stack) {
       state = AsyncValue.error(e, stack); // 에러 상태
     }
   }
   ```

3. **UI 자동 업데이트**
   ```dart
   final userState = ref.watch(userNotifierProvider);

   return userState.when(
     data: (user) => Text('환영합니다, ${user.nickname}님!'),
     loading: () => CircularProgressIndicator(),
     error: (error, _) => Text('로그인 실패: $error'),
   );
   ```

---

## 모범 사례 (Best Practices)

### 1. Provider 사용 시 주의사항

**❌ 잘못된 예시 (ref.mounted 체크 없음)**
```dart
Future<void> loadData() async {
  final data = await apiService.fetchData();
  state = AsyncValue.data(data); // ⚠️ Provider가 이미 dispose된 경우 에러
}
```

**✅ 올바른 예시 (ref.mounted 체크)**
```dart
Future<void> loadData() async {
  final data = await apiService.fetchData();
  if (!ref.mounted) return; // Provider가 유효한지 확인
  state = AsyncValue.data(data);
}
```

### 2. UI 컴포넌트 재사용

**❌ 잘못된 예시 (중복 코드)**
```dart
AppBar(
  title: Text('제목'),
  leading: IconButton(icon: Icons.arrow_back, onPressed: () => context.pop()),
)
```

**✅ 올바른 예시 (공용 위젯 사용)**
```dart
CommonAppBar.forSubPage(
  title: '제목',
  onBackPressed: () => context.pop(),
)
```

### 3. 디자인 시스템 사용

**❌ 잘못된 예시 (하드코딩된 스타일)**
```dart
Text(
  '제목',
  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
)

Container(
  padding: EdgeInsets.all(16),
  decoration: BoxDecoration(
    color: Color(0xFF664BAE),
    borderRadius: BorderRadius.circular(12),
  ),
)
```

**✅ 올바른 예시 (테마 시스템 사용)**
```dart
Text(
  '제목',
  style: AppTextStyles.titleLarge,
)

Container(
  padding: AppSpacing.cardPadding,
  decoration: BoxDecoration(
    color: AppColors.primary,
    borderRadius: AppRadius.allLarge,
  ),
)
```

### 4. 라우팅 경로 관리

**❌ 잘못된 예시 (하드코딩된 경로)**
```dart
context.go('/course-market/detail/123');
```

**✅ 올바른 예시 (상수 사용)**
```dart
context.go(AppRoutes.courseDetail.replaceFirst(':courseId', '123'));
// 또는
context.go('/course-market/detail/$courseId');
```

---

## 개발 워크플로우

### 1. 새로운 Feature 추가

```bash
# 1. Feature 디렉토리 생성
features/new_feature/
  ├── models/
  ├── providers/
  ├── services/
  └── presentation/
      ├── pages/
      └── widgets/

# 2. Provider 작성 (Riverpod 어노테이션 사용)
# 3. Service 작성 (API 통신 로직)
# 4. Model 작성 (Freezed로 불변 데이터 클래스)
# 5. UI 작성 (공용 위젯 재사용)

# 6. 코드 생성
dart run build_runner watch
```

### 2. 빌드 및 실행

```bash
# 개발 서버 실행
flutter run

# 코드 분석
flutter analyze

# 포맷팅
dart format .

# 프로덕션 빌드
flutter build apk           # Android
flutter build ios           # iOS
```

---

## 참고 자료

- [Flutter 공식 문서](https://flutter.dev/docs)
- [Riverpod 공식 문서](https://riverpod.dev)
- [GoRouter 공식 문서](https://pub.dev/packages/go_router)
- [Material Design 3](https://m3.material.io)
- [Firebase Cloud Messaging](https://firebase.google.com/docs/cloud-messaging)

---

**Last Updated**: 2025-11-10
**Version**: 1.0.0
**Maintained by**: [@EM-H20](https://github.com/EM-H20)
