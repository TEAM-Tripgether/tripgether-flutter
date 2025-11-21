# 🏗️ Tripgether 아키텍처 문서

**최종 업데이트**: 2025-01-20
**문서 버전**: 1.0.0

Flutter 기반 여행 계획 협업 플랫폼의 기술 아키텍처 가이드입니다.

---

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
- [API 통합](#api-통합)

---

## 개요

Tripgether는 **Flutter** 기반의 크로스 플랫폼 여행 계획 협업 앱으로, **Clean Architecture** 원칙과 **Feature-First** 구조를 따릅니다.

### 핵심 설계 원칙

- ✅ **관심사의 분리 (Separation of Concerns)**: UI, 비즈니스 로직, 데이터 레이어 명확 분리
- ✅ **재사용성 (Reusability)**: 공용 컴포넌트와 서비스의 중앙 집중식 관리
- ✅ **테스트 가능성 (Testability)**: 의존성 주입과 추상화를 통한 단위 테스트 용이성
- ✅ **확장성 (Scalability)**: Feature 모듈 단위의 독립적 개발 및 확장
- ✅ **반응형 설계 (Responsive Design)**: ScreenUtil을 활용한 다양한 화면 크기 대응

---

## 기술 스택

### 핵심 프레임워크

| 영역 | 기술 | 버전 | 용도 |
|------|------|------|------|
| **Framework** | Flutter | 3.24.0+ | 크로스 플랫폼 UI |
| **Language** | Dart | 3.5.0+ | 프로그래밍 언어 |
| **State Management** | Riverpod | 2.5.1 | 선언적 상태 관리 |
| **Code Generation** | build_runner | 2.4.13 | Riverpod 코드 생성 |
| **DI Container** | GetIt | 8.0.2 | 의존성 주입 |

### 주요 패키지

#### UI & 디자인

```yaml
flutter_screenutil: ^5.9.3      # 반응형 UI
cached_network_image: ^3.4.1    # 이미지 캐싱 및 로딩
shimmer: ^3.0.0                 # 스켈레톤 로딩 UI
flutter_svg: ^2.0.14            # SVG 아이콘 렌더링
```

#### 라우팅 & 내비게이션

```yaml
go_router: ^14.6.2              # 선언적 라우팅 시스템
```

#### 네트워크 & API

```yaml
dio: ^5.7.0                     # HTTP 클라이언트
retrofit: ^4.4.1                # REST API 타입-세이프 클라이언트
```

#### 인증 & 보안

```yaml
google_sign_in: ^7.2.0          # Google OAuth 인증
flutter_secure_storage: ^9.2.2  # 보안 토큰 저장 (JWT)
```

#### 푸시 알림

```yaml
firebase_core: ^3.8.1           # Firebase 초기화
firebase_messaging: ^15.1.5     # FCM 푸시 알림
flutter_local_notifications: ^18.0.1  # 로컬 알림 표시
```

#### 다국어 & 환경 설정

```yaml
flutter_localizations: SDK      # 다국어 지원 (i18n)
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
│   ├── theme/                  # 디자인 시스템
│   │   ├── app_colors.dart    # 색상 팔레트
│   │   ├── app_text_styles.dart # 타이포그래피
│   │   ├── app_spacing.dart   # 간격 시스템
│   │   └── app_theme.dart     # Material Theme 통합
│   ├── router/                 # 라우팅 설정
│   │   └── routes.dart        # AppRoutes 상수 정의
│   ├── services/               # 글로벌 서비스
│   │   ├── auth/              # 인증 서비스
│   │   ├── fcm/               # FCM 푸시 알림
│   │   └── local_notifications/ # 로컬 알림
│   ├── providers/              # 전역 Provider
│   ├── models/                 # 공용 데이터 모델
│   ├── data/                   # 공용 데이터 소스
│   └── utils/                  # 유틸리티 함수
│
├── features/                   # 기능별 모듈 (Feature-First)
│   ├── auth/                   # 인증 기능
│   │   ├── data/              # 데이터 레이어
│   │   │   ├── models/        # 데이터 모델
│   │   │   └── repositories/  # 리포지토리
│   │   ├── presentation/      # 프레젠테이션 레이어
│   │   │   ├── screens/       # 화면 위젯
│   │   │   └── widgets/       # 기능별 위젯
│   │   ├── providers/          # 상태 관리
│   │   └── services/           # 비즈니스 로직
│   ├── onboarding/             # 온보딩
│   ├── home/                   # 홈 탭
│   ├── mypage/                 # 마이페이지
│   ├── map/                    # 지도 기능
│   ├── course_market/          # 코스 마켓
│   └── notifications/          # 알림
│
├── shared/                     # 공용 컴포넌트
│   └── widgets/               # 재사용 위젯 라이브러리
│       ├── common/            # 공통 위젯 (AppBar, EmptyState)
│       ├── buttons/           # 버튼 컴포넌트
│       ├── cards/             # 카드 컴포넌트
│       ├── inputs/            # 입력 컴포넌트
│       ├── layout/            # 레이아웃 컴포넌트
│       └── dialogs/           # 다이얼로그 컴포넌트
│
├── l10n/                       # 다국어 리소스
│   ├── app_ko.arb            # 한국어
│   └── app_en.arb            # 영어
│
└── main.dart                   # 앱 진입점
```

### Feature 모듈 구조

각 Feature 모듈은 독립적인 기능 단위로 구성됩니다:

```
features/[feature_name]/
├── data/                      # 데이터 레이어
│   ├── models/               # 데이터 모델 (JSON 직렬화)
│   ├── repositories/         # 데이터 소스 추상화
│   └── data_sources/         # API, 로컬 DB 연결
├── presentation/              # 프레젠테이션 레이어
│   ├── screens/              # 전체 화면 위젯
│   ├── widgets/              # 화면 구성 위젯
│   └── providers/            # UI 상태 관리
├── providers/                 # 비즈니스 로직 Provider
└── services/                  # 도메인 서비스
```

---

## 아키텍처 패턴

### Clean Architecture

```
┌─────────────────────────────────────────────────┐
│                  Presentation                   │
│         (UI Components + State Management)      │
├─────────────────────────────────────────────────┤
│                    Domain                       │
│          (Business Logic + Use Cases)           │
├─────────────────────────────────────────────────┤
│                     Data                        │
│      (Repositories + Data Sources + Models)     │
└─────────────────────────────────────────────────┘
```

### 레이어별 책임

#### Presentation Layer
- UI 컴포넌트 및 화면 렌더링
- 사용자 입력 처리
- UI 상태 관리 (Riverpod)
- 라우팅 및 네비게이션

#### Domain Layer
- 비즈니스 로직 구현
- Use Case 정의
- 도메인 엔티티 관리
- 비즈니스 규칙 검증

#### Data Layer
- API 통신 및 데이터 페칭
- 로컬 데이터 저장 및 캐싱
- 데이터 모델 변환 (DTO ↔ Entity)
- 외부 서비스 통합

---

## 상태 관리

### Riverpod 패턴

#### @riverpod 어노테이션 사용

```dart
// 자동 생성 Provider (권장)
@riverpod
class UserNotifier extends _$UserNotifier {
  @override
  Future<User?> build() async {
    return await _loadUser();
  }

  Future<void> updateProfile(ProfileData data) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() =>
      _userRepository.updateProfile(data)
    );
  }
}
```

#### Provider 종류

| Provider 타입 | 용도 | 예시 |
|--------------|------|------|
| **StateNotifier** | 복잡한 상태 관리 | UserNotifier, AuthNotifier |
| **FutureProvider** | 비동기 데이터 페칭 | API 호출, 데이터 로딩 |
| **StreamProvider** | 실시간 데이터 스트림 | 채팅, 알림 |
| **StateProvider** | 단순 상태 값 | 선택 상태, 토글 |

#### Provider Scope

```dart
// 전역 Provider (core/providers)
final userNotifierProvider = ...

// Feature Provider (features/auth/providers)
final loginNotifierProvider = ...

// Screen Provider (presentation/providers)
final searchQueryProvider = ...
```

---

## 라우팅 시스템

### GoRouter 구성

```dart
// core/router/routes.dart
class AppRoutes {
  static const String splash = '/';
  static const String login = '/login';
  static const String onboarding = '/onboarding';
  static const String home = '/home';
  static const String mypage = '/mypage';
  // ... 기타 라우트
}

// 라우터 설정
final appRouter = GoRouter(
  initialLocation: AppRoutes.splash,
  routes: [
    GoRoute(
      path: AppRoutes.home,
      builder: (context, state) => const MainScreen(),
      routes: [
        // 중첩 라우트
        GoRoute(
          path: 'detail/:id',
          builder: (context, state) => DetailScreen(
            id: state.pathParameters['id']!,
          ),
        ),
      ],
    ),
  ],
  redirect: (context, state) {
    // 인증 상태에 따른 리다이렉트
    final isAuthenticated = ref.read(authProvider);
    if (!isAuthenticated && !publicRoutes.contains(state.matchedLocation)) {
      return AppRoutes.login;
    }
    return null;
  },
);
```

### 네비게이션 패턴

```dart
// 이동
context.go(AppRoutes.home);

// 푸시 (스택에 추가)
context.push(AppRoutes.detail);

// 팝
context.pop();

// 파라미터 전달
context.push('/detail/${item.id}');
context.pushNamed('detail', pathParameters: {'id': item.id});
```

---

## 인증 흐름

### Google OAuth + JWT 인증

```
┌──────────┐     ┌────────────┐     ┌─────────┐     ┌──────────┐
│   User   │────▶│Google OAuth│────▶│  Server │────▶│   JWT    │
└──────────┘     └────────────┘     └─────────┘     └──────────┘
     │                  │                 │               │
     │   1. 로그인 요청  │                 │               │
     │─────────────────▶│                 │               │
     │                  │   2. OAuth 인증  │               │
     │                  │────────────────▶│               │
     │                  │                 │  3. JWT 발급  │
     │                  │                 │──────────────▶│
     │                  │                 │               │
     │◀──────────────────────────────────────────────────│
     │              4. Access Token 반환                   │
```

### 토큰 관리

```dart
// JWT 토큰 저장 (Secure Storage)
await secureStorage.write(
  key: 'access_token',
  value: response.accessToken,
);

// 토큰 자동 갱신
if (isTokenExpired) {
  final newToken = await refreshToken();
  await updateStoredToken(newToken);
}
```

---

## 서비스 레이어

### 핵심 서비스

#### GoogleAuthService
```dart
// Google 로그인 처리
final account = await _googleSignIn.signIn();
final authentication = await account?.authentication;
return GoogleAuthResult(
  idToken: authentication?.idToken,
  accessToken: authentication?.accessToken,
);
```

#### FirebaseMessagingService
```dart
// FCM 토큰 등록
final fcmToken = await FirebaseMessaging.instance.getToken();
await _apiClient.registerFCMToken(fcmToken);

// 푸시 알림 처리
FirebaseMessaging.onMessage.listen((message) {
  _showLocalNotification(message);
});
```

#### AuthApiService
```dart
// 백엔드 인증 API
Future<AuthResponse> signIn(SocialLoginRequest request) async {
  final response = await _dio.post('/api/auth/sign-in', data: request);
  return AuthResponse.fromJson(response.data);
}
```

---

## 데이터 흐름

### 일반적인 데이터 흐름

```
User Action → UI Component → Provider → Service → Repository → Data Source
     ↑                                                              ↓
     └──────────────────── State Update ←──────────────────────────┘
```

### 예시: 사용자 프로필 업데이트

```dart
// 1. UI에서 액션 시작
ElevatedButton(
  onPressed: () => ref.read(userNotifierProvider.notifier)
    .updateProfile(profileData),
  child: Text('프로필 저장'),
);

// 2. Provider에서 비즈니스 로직 처리
Future<void> updateProfile(ProfileData data) async {
  state = const AsyncValue.loading();

  try {
    final updatedUser = await _userService.updateProfile(data);
    state = AsyncValue.data(updatedUser);
  } catch (e) {
    state = AsyncValue.error(e, StackTrace.current);
  }
}

// 3. Service에서 API 호출
Future<User> updateProfile(ProfileData data) async {
  final response = await _apiClient.put('/api/members/profile', data: data);
  return User.fromJson(response.data);
}

// 4. UI에서 상태 변경 감지
ref.watch(userNotifierProvider).when(
  data: (user) => ProfileView(user: user),
  loading: () => LoadingIndicator(),
  error: (error, _) => ErrorMessage(error: error),
);
```

---

## API 통합

### Dio 인터셉터

```dart
class AuthInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // JWT 토큰 자동 추가
    final token = secureStorage.read('access_token');
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    super.onRequest(options, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // 401 에러 시 토큰 갱신
    if (err.response?.statusCode == 401) {
      _refreshTokenAndRetry(err.requestOptions);
    }
    super.onError(err, handler);
  }
}
```

### API 에러 처리

```dart
class ApiException implements Exception {
  final String code;
  final String message;
  final int? statusCode;

  ApiException({
    required this.code,
    required this.message,
    this.statusCode,
  });
}

// 에러 처리 예시
try {
  final result = await apiClient.get('/api/data');
  return result;
} on DioException catch (e) {
  throw ApiException(
    code: e.response?.data['code'] ?? 'UNKNOWN_ERROR',
    message: e.response?.data['message'] ?? '알 수 없는 오류가 발생했습니다',
    statusCode: e.response?.statusCode,
  );
}
```

---

## 개발 가이드라인

### 코드 구성 원칙

1. **Feature 독립성**: 각 Feature는 독립적으로 개발/테스트 가능해야 함
2. **의존성 역전**: 상위 레이어는 하위 레이어에 의존하지 않음
3. **단일 책임**: 각 클래스/함수는 하나의 명확한 책임만 가짐
4. **테스트 우선**: 비즈니스 로직은 테스트 가능하게 설계

### 명명 규칙

| 구분 | 규칙 | 예시 |
|------|------|------|
| **파일명** | snake_case | user_profile_screen.dart |
| **클래스명** | PascalCase | UserProfileScreen |
| **변수명** | camelCase | userProfile |
| **상수** | SCREAMING_SNAKE_CASE | MAX_RETRY_COUNT |
| **Provider** | camelCase + Provider | userNotifierProvider |

### 폴더 구조 규칙

- Feature별로 모든 관련 코드를 그룹화
- 공용 컴포넌트는 shared/widgets에 배치
- 전역 서비스는 core/services에 배치
- 디자인 시스템은 core/theme에서 중앙 관리

---

## 성능 최적화

### 위젯 최적화

```dart
// const 생성자 사용
const MyWidget({Key? key}) : super(key: key);

// 불필요한 리빌드 방지
Consumer(
  builder: (context, ref, child) {
    final specificData = ref.watch(provider.select((state) => state.field));
    return Text(specificData);
  },
);

// 메모이제이션
final expensiveComputation = useMemoized(
  () => computeExpensiveValue(),
  [dependency],
);
```

### 이미지 최적화

```dart
// CachedNetworkImage 사용
CachedNetworkImage(
  imageUrl: url,
  placeholder: (context, url) => Shimmer.fromColors(...),
  errorWidget: (context, url, error) => Icon(Icons.error),
  cacheManager: DefaultCacheManager(),
);
```

---

## 문서 업데이트 이력

| 날짜 | 버전 | 변경 내용 |
|------|------|----------|
| 2025-01-20 | 1.0.0 | 최신 프로젝트 구조 반영 및 전체 문서 개선 |
| 2025-11-10 | 0.9.0 | 초기 문서 작성 |

---

**Maintained by**: TEAM-Tripgether