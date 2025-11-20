# 🛠️ Tripgether 핵심 서비스 API

**최종 업데이트**: 2025-01-20
**문서 버전**: 1.0.0

비즈니스 로직 및 외부 통신 서비스 가이드입니다.

---

## 📋 목차

- [개요](#개요)
- [인증 서비스](#인증-서비스)
  - [GoogleAuthService](#googleauthservice)
  - [AuthApiService](#authapiservice)
- [푸시 알림 서비스](#푸시-알림-서비스)
  - [FirebaseMessagingService](#firebasemessagingservice)
  - [LocalNotificationsService](#localnotificationsservice)
- [온보딩 서비스](#온보딩-서비스)
  - [OnboardingApiService](#onboardingapiservice)
  - [InterestApiService](#interestapiservice)
- [유틸리티 서비스](#유틸리티-서비스)
  - [SharingService](#sharingservice)
  - [DeviceInfoService](#deviceinfoservice)
- [개발 가이드라인](#개발-가이드라인)

---

## 개요

서비스 레이어는 앱의 비즈니스 로직과 외부 시스템 통신을 담당합니다.

### 서비스 레이어 책임

- **외부 API 통신**: 백엔드 서버, Google, Firebase 등과의 통신
- **플랫폼 기능 호출**: 네이티브 기능 (디바이스 정보, 공유, 알림 등)
- **비즈니스 로직 캡슐화**: 복잡한 로직을 재사용 가능한 서비스로 추상화
- **에러 처리**: 네트워크 오류, 플랫폼 오류 등의 처리

### 서비스 구조

```
core/services/                         # 글로벌 서비스
├── auth/
│   └── google_auth_service.dart      # Google OAuth 인증
├── fcm/
│   ├── firebase_messaging_service.dart  # FCM 푸시 알림
│   ├── local_notifications_service.dart # 로컬 알림 표시
│   └── models/                          # FCM 데이터 모델
├── sharing_service.dart               # 외부 앱 공유 수신
└── device_info_service.dart           # 디바이스 정보 수집

features/*/services/                   # Feature별 서비스
├── auth/services/
│   └── auth_api_service.dart         # 백엔드 인증 API
├── onboarding/services/
│   ├── onboarding_api_service.dart   # 온보딩 API
│   └── interest_api_service.dart     # 관심사 API
```

---

## 인증 서비스

### GoogleAuthService

Google OAuth 인증을 처리하는 서비스

#### 위치
`lib/core/services/auth/google_auth_service.dart`

#### 주요 기능

| 메서드 | 설명 | 반환 타입 |
|--------|------|-----------|
| `signIn()` | Google 로그인 진행 | `Future<GoogleSignInAccount?>` |
| `signOut()` | Google 로그아웃 | `Future<void>` |
| `getCurrentUser()` | 현재 로그인된 사용자 | `GoogleSignInAccount?` |
| `isSignedIn()` | 로그인 상태 확인 | `Future<bool>` |

#### 사용 예시

```dart
// DI 컨테이너에서 서비스 가져오기
final googleAuthService = GetIt.instance<GoogleAuthService>();

// Google 로그인
try {
  final account = await googleAuthService.signIn();

  if (account != null) {
    // 로그인 성공
    print('로그인 성공: ${account.email}');

    // 인증 정보 가져오기
    final authentication = await account.authentication;
    final idToken = authentication.idToken;

    // 백엔드 서버로 토큰 전송
    await authApiService.signIn(
      socialPlatform: 'GOOGLE',
      email: account.email,
      name: account.displayName ?? '',
    );
  }
} catch (e) {
  print('로그인 실패: $e');
}

// 로그아웃
await googleAuthService.signOut();
```

#### 에러 처리

```dart
// Google Sign-In 에러 타입
- PlatformException: 플랫폼 오류 (iOS/Android)
- GoogleSignInCanceled: 사용자가 로그인 취소
- GoogleSignInFailed: 로그인 실패
```

### AuthApiService

백엔드 서버 인증 API 서비스

#### 위치
`lib/features/auth/services/auth_api_service.dart`

#### 주요 API

| 메서드 | 엔드포인트 | 설명 |
|--------|-----------|------|
| `signIn()` | `POST /api/auth/sign-in` | 소셜 로그인 (JWT 발급) |
| `refreshToken()` | `POST /api/auth/reissue` | 토큰 재발급 |
| `logout()` | `POST /api/auth/logout` | 로그아웃 |

#### 사용 예시

```dart
// 소셜 로그인
final response = await authApiService.signIn(
  socialPlatform: 'GOOGLE',
  email: 'user@example.com',
  name: '홍길동',
);

// JWT 토큰 저장
await secureStorage.write(
  key: 'access_token',
  value: response.accessToken,
);
await secureStorage.write(
  key: 'refresh_token',
  value: response.refreshToken,
);

// 온보딩 필요 여부 확인
if (response.requiresOnboarding) {
  // 온보딩 화면으로 이동
  context.go(AppRoutes.onboarding);
}
```

---

## 푸시 알림 서비스

### FirebaseMessagingService

FCM(Firebase Cloud Messaging) 푸시 알림 관리 서비스

#### 위치
`lib/core/services/fcm/firebase_messaging_service.dart`

#### 주요 기능

| 메서드 | 설명 | 반환 타입 |
|--------|------|-----------|
| `init()` | FCM 서비스 초기화 | `Future<void>` |
| `getToken()` | FCM 토큰 가져오기 | `Future<String?>` |
| `requestPermission()` | 알림 권한 요청 | `Future<bool>` |
| `setupMessageHandlers()` | 메시지 핸들러 설정 | `void` |

#### 메시지 처리

```dart
class FirebaseMessagingService {
  // 초기화
  static Future<void> init() async {
    // iOS 권한 요청
    await _requestIOSPermission();

    // FCM 토큰 가져오기
    final fcmToken = await FirebaseMessaging.instance.getToken();
    debugPrint('FCM Token: $fcmToken');

    // 토큰 갱신 리스너
    FirebaseMessaging.instance.onTokenRefresh.listen((newToken) {
      // 서버에 새 토큰 전송
      _updateTokenOnServer(newToken);
    });

    // 메시지 핸들러 설정
    _setupMessageHandlers();
  }

  static void _setupMessageHandlers() {
    // 포그라운드 메시지
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      _showLocalNotification(message);
    });

    // 백그라운드 메시지 클릭
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      _handleMessageClick(message);
    });

    // 종료 상태에서 메시지 클릭
    FirebaseMessaging.instance
      .getInitialMessage()
      .then((RemoteMessage? message) {
        if (message != null) {
          _handleMessageClick(message);
        }
      });
  }
}
```

### LocalNotificationsService

로컬 알림 표시 서비스

#### 위치
`lib/core/services/fcm/local_notifications_service.dart`

#### 주요 기능

| 메서드 | 설명 | 파라미터 |
|--------|------|----------|
| `init()` | 로컬 알림 초기화 | - |
| `showNotification()` | 알림 표시 | `title`, `body`, `payload` |
| `showBigPictureNotification()` | 이미지 알림 표시 | `title`, `body`, `imageUrl` |
| `cancelNotification()` | 알림 취소 | `id` |

#### 사용 예시

```dart
// 초기화 (main.dart)
await LocalNotificationsService.init();

// 기본 알림 표시
await LocalNotificationsService.showNotification(
  title: '새로운 메시지',
  body: '친구가 메시지를 보냈습니다',
  payload: 'message_id:123',
);

// 이미지 알림 표시
await LocalNotificationsService.showBigPictureNotification(
  title: '새로운 장소 추천',
  body: '오사카 도톤보리를 확인해보세요!',
  imageUrl: 'https://example.com/image.jpg',
);

// 알림 클릭 처리
LocalNotificationsService.onNotificationClick.listen((payload) {
  // payload 파싱 후 해당 화면으로 이동
  if (payload?.startsWith('message_id:') ?? false) {
    final messageId = payload!.split(':')[1];
    context.push('/message/$messageId');
  }
});
```

---

## 온보딩 서비스

### OnboardingApiService

온보딩 단계별 API 서비스

#### 위치
`lib/features/onboarding/services/onboarding_api_service.dart`

#### 주요 API

| 메서드 | 엔드포인트 | 설명 |
|--------|-----------|------|
| `agreeTerms()` | `POST /api/members/onboarding/terms` | 약관 동의 |
| `updateName()` | `POST /api/members/onboarding/name` | 이름 설정 |
| `updateBirthDate()` | `POST /api/members/onboarding/birth-date` | 생년월일 설정 |
| `updateGender()` | `POST /api/members/onboarding/gender` | 성별 설정 |
| `updateInterests()` | `POST /api/members/onboarding/interests` | 관심사 설정 |

#### 사용 예시

```dart
// 약관 동의
final response = await onboardingApiService.agreeTerms(
  isServiceTermsAndPrivacyAgreed: true,
  isMarketingAgreed: false,
);

// 이름 설정
await onboardingApiService.updateName(name: '홍길동');

// 생년월일 설정
await onboardingApiService.updateBirthDate(
  birthDate: DateTime(1990, 1, 1),
);

// 성별 설정
await onboardingApiService.updateGender(gender: 'MALE');

// 관심사 설정
await onboardingApiService.updateInterests(
  interestIds: ['uuid1', 'uuid2', 'uuid3'],
);
```

### InterestApiService

관심사 조회 API 서비스

#### 위치
`lib/features/onboarding/services/interest_api_service.dart`

#### 주요 API

| 메서드 | 엔드포인트 | 설명 |
|--------|-----------|------|
| `getAllInterests()` | `GET /api/interests` | 전체 관심사 목록 조회 |
| `getInterestById()` | `GET /api/interests/{id}` | 특정 관심사 조회 |
| `getInterestsByCategory()` | `GET /api/interests/categories/{category}` | 카테고리별 관심사 조회 |

#### 관심사 카테고리

```dart
enum InterestCategory {
  FOOD,             // 맛집/푸드
  CAFE_DESSERT,     // 카페/디저트
  LOCAL_MARKET,     // 시장/로컬푸드
  NATURE_OUTDOOR,   // 자연/야외활동
  URBAN_PHOTOSPOTS, // 도심/포토스팟
  CULTURE_ART,      // 문화/예술
  HISTORY_ARCHITECTURE, // 역사/건축
  EXPERIENCE_CLASS, // 체험/클래스
  SHOPPING_FASHION, // 쇼핑/패션
  NIGHTLIFE,        // 나이트라이프
  WELLNESS,         // 웰니스/힐링
  FAMILY_KIDS,      // 가족/키즈
  KPOP_CULTURE,     // K-POP/한류
  DRIVE_SUBURBS,    // 드라이브/교외
}
```

---

## 유틸리티 서비스

### SharingService

외부 앱 공유 수신 서비스

#### 위치
`lib/core/services/sharing_service.dart`

#### 주요 기능

| 메서드 | 설명 | 반환 타입 |
|--------|------|-----------|
| `init()` | 공유 서비스 초기화 | `Future<void>` |
| `getInitialSharedData()` | 앱 시작 시 공유 데이터 | `Future<SharedData?>` |
| `getSharedDataStream()` | 공유 데이터 스트림 | `Stream<SharedData>` |
| `processSharedUrl()` | URL 파싱 및 처리 | `SharedContent?` |

#### 공유 데이터 처리

```dart
class SharingService {
  // 공유 데이터 스트림 구독
  static void setupSharedDataListener() {
    getSharedDataStream().listen((sharedData) {
      if (sharedData.type == SharedDataType.url) {
        final url = sharedData.text;

        // Instagram URL 처리
        if (url.contains('instagram.com')) {
          _processInstagramUrl(url);
        }
        // YouTube URL 처리
        else if (url.contains('youtube.com') || url.contains('youtu.be')) {
          _processYoutubeUrl(url);
        }
      }
    });
  }

  // URL 파싱
  static SharedContent? processSharedUrl(String url) {
    final uri = Uri.parse(url);

    return SharedContent(
      platform: _detectPlatform(uri),
      contentId: _extractContentId(uri),
      originalUrl: url,
      timestamp: DateTime.now(),
    );
  }
}
```

#### iOS Share Extension 설정

```swift
// Info.plist 설정
NSExtension
├── NSExtensionAttributes
│   └── NSExtensionActivationSupportsWebURLWithMaxCount: 1
└── NSExtensionPrincipalClass: ShareViewController
```

#### Android Intent Filter 설정

```xml
<!-- AndroidManifest.xml -->
<intent-filter>
  <action android:name="android.intent.action.SEND" />
  <category android:name="android.intent.category.DEFAULT" />
  <data android:mimeType="text/plain" />
</intent-filter>
```

### DeviceInfoService

디바이스 정보 수집 서비스

#### 위치
`lib/core/services/device_info_service.dart`

#### 주요 기능

| 메서드 | 설명 | 반환 타입 |
|--------|------|-----------|
| `getDeviceInfo()` | 디바이스 전체 정보 | `Future<DeviceInfo>` |
| `getPlatform()` | 플랫폼 (iOS/Android) | `String` |
| `getOSVersion()` | OS 버전 | `Future<String>` |
| `getDeviceModel()` | 디바이스 모델명 | `Future<String>` |
| `getUniqueId()` | 디바이스 고유 ID | `Future<String>` |

#### 사용 예시

```dart
// 디바이스 정보 가져오기
final deviceInfo = await DeviceInfoService.getDeviceInfo();

print('플랫폼: ${deviceInfo.platform}');       // iOS/Android
print('OS 버전: ${deviceInfo.osVersion}');     // 14.5/11
print('모델: ${deviceInfo.model}');            // iPhone 12/Galaxy S21
print('고유 ID: ${deviceInfo.uniqueId}');      // UUID

// API 호출 시 디바이스 정보 포함
final headers = {
  'X-Device-Platform': deviceInfo.platform,
  'X-Device-OS': deviceInfo.osVersion,
  'X-Device-Model': deviceInfo.model,
  'X-Device-ID': deviceInfo.uniqueId,
};
```

---

## 개발 가이드라인

### 서비스 생성 규칙

#### 1. 단일 책임 원칙
각 서비스는 하나의 명확한 책임만 가져야 합니다.

```dart
// ✅ GOOD - 단일 책임
class GoogleAuthService {
  // Google 인증만 담당
}

class FacebookAuthService {
  // Facebook 인증만 담당
}

// ❌ BAD - 여러 책임
class SocialAuthService {
  // Google, Facebook, Kakao 모두 담당
}
```

#### 2. 의존성 주입
서비스는 GetIt을 통해 주입되어야 합니다.

```dart
// 등록 (main.dart)
GetIt.instance.registerSingleton<GoogleAuthService>(
  GoogleAuthService(),
);

// 사용
final googleAuthService = GetIt.instance<GoogleAuthService>();
```

#### 3. 에러 처리
모든 서비스 메서드는 적절한 에러 처리를 포함해야 합니다.

```dart
Future<AuthResponse?> signIn() async {
  try {
    final response = await _dio.post('/api/auth/sign-in');
    return AuthResponse.fromJson(response.data);
  } on DioException catch (e) {
    if (e.response?.statusCode == 401) {
      throw UnauthorizedException('인증 실패');
    }
    throw NetworkException('네트워크 오류');
  } catch (e) {
    throw UnknownException('알 수 없는 오류: $e');
  }
}
```

### 테스트 작성

#### 단위 테스트 예시

```dart
// test/services/google_auth_service_test.dart
void main() {
  late GoogleAuthService service;
  late MockGoogleSignIn mockGoogleSignIn;

  setUp(() {
    mockGoogleSignIn = MockGoogleSignIn();
    service = GoogleAuthService(googleSignIn: mockGoogleSignIn);
  });

  test('signIn returns GoogleSignInAccount when successful', () async {
    // Arrange
    final expectedAccount = MockGoogleSignInAccount();
    when(mockGoogleSignIn.signIn())
      .thenAnswer((_) async => expectedAccount);

    // Act
    final result = await service.signIn();

    // Assert
    expect(result, equals(expectedAccount));
    verify(mockGoogleSignIn.signIn()).called(1);
  });
}
```

### 성능 고려사항

#### 1. 캐싱
자주 사용되는 데이터는 캐싱을 고려합니다.

```dart
class InterestApiService {
  Map<String, List<Interest>>? _cachedInterests;

  Future<List<Interest>> getAllInterests() async {
    // 캐시 확인
    if (_cachedInterests != null) {
      return _cachedInterests!;
    }

    // API 호출
    final response = await _dio.get('/api/interests');
    _cachedInterests = response.data;

    // 5분 후 캐시 무효화
    Future.delayed(Duration(minutes: 5), () {
      _cachedInterests = null;
    });

    return _cachedInterests!;
  }
}
```

#### 2. 디바운싱
연속적인 호출을 방지합니다.

```dart
class SearchService {
  Timer? _debounce;

  void search(String query) {
    _debounce?.cancel();
    _debounce = Timer(Duration(milliseconds: 500), () {
      _performSearch(query);
    });
  }
}
```

---

## 문서 업데이트 이력

| 날짜 | 버전 | 변경 내용 |
|------|------|----------|
| 2025-01-20 | 1.0.0 | 최신 서비스 구조 반영 및 온보딩 서비스 추가 |
| 2025-11-10 | 0.9.0 | 초기 문서 작성 |

---

**Last Updated by**: Claude Code
**Maintained by**: TEAM-Tripgether