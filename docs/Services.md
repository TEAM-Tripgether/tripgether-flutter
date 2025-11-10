# Tripgether 핵심 서비스 API

> 🛠️ **비즈니스 로직 및 외부 통신 서비스 가이드**

## 📋 목차

- [개요](#개요)
- [GoogleAuthService](#googleauthservice)
- [FirebaseMessagingService](#firebasemessagingservice)
- [LocalNotificationsService](#localnotificationsservice)
- [SharingService](#sharingservice)
- [DeviceInfoService](#deviceinfoservice)
- [AuthApiService](#authapiservice)
- [개발 가이드라인](#개발-가이드라인)

---

## 개요

`core/services/` 디렉토리는 앱의 비즈니스 로직과 외부 시스템 통신을 담당하는 서비스 레이어입니다.

### 서비스 레이어 책임

- **외부 API 통신**: 백엔드 서버, Google, Firebase 등과의 통신
- **플랫폼 기능 호출**: 네이티브 기능 (디바이스 정보, 공유, 알림 등)
- **비즈니스 로직 캡슐화**: 복잡한 로직을 재사용 가능한 서비스로 추상화

### 서비스 구조

```
core/services/
├── auth/
│   └── google_auth_service.dart      # Google OAuth 인증
├── fcm/
│   ├── firebase_messaging_service.dart  # FCM 푸시 알림 관리
│   ├── local_notifications_service.dart # 로컬 알림 표시
│   └── models/fcm_token_request.dart    # FCM 모델
├── sharing_service.dart               # 외부 앱 공유 수신
└── device_info_service.dart           # 디바이스 정보 수집
```

---

## GoogleAuthService

Google OAuth 인증을 처리하는 서비스

### 위치
`lib/core/services/auth/google_auth_service.dart`

### 초기화

```dart
// main.dart에서 앱 시작 시 호출
await GoogleAuthService.initialize();
```

**환경 변수 필요**:
- iOS: `GOOGLE_IOS_CLIENT_ID`
- Android: `GOOGLE_WEB_CLIENT_ID`

### API

#### initialize()

Google Sign-In SDK를 초기화합니다.

```dart
static Future<void> initialize() async
```

**사용 예시**:
```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load();
  await GoogleAuthService.initialize();
  runApp(MyApp());
}
```

**에러 처리**:
```dart
try {
  await GoogleAuthService.initialize();
} catch (error) {
  debugPrint('Google Auth 초기화 실패: $error');
}
```

#### signIn()

Google 로그인을 시작합니다.

```dart
static Future<GoogleSignInAccount?> signIn() async
```

**반환값**:
- 성공: `GoogleSignInAccount` (사용자 정보 포함)
- 실패 또는 취소: `null`

**사용 예시**:
```dart
Future<void> _handleGoogleLogin() async {
  try {
    final account = await GoogleAuthService.signIn();

    if (account == null) {
      // 사용자가 로그인 취소
      _showMessage('로그인이 취소되었습니다');
      return;
    }

    // 인증 정보 가져오기
    final auth = await account.authentication;
    final idToken = auth.idToken;
    final accessToken = auth.accessToken;

    // 백엔드 API에 토큰 전송
    await _authApiService.socialLogin(
      socialPlatform: 'GOOGLE',
      email: account.email,
      nickname: account.displayName,
      idToken: idToken,
    );
  } catch (error) {
    _showError('로그인 실패: $error');
  }
}
```

#### signOut()

Google 로그아웃을 수행합니다.

```dart
static Future<void> signOut() async
```

**사용 예시**:
```dart
Future<void> _handleLogout() async {
  try {
    await GoogleAuthService.signOut();
    // 로컬 저장소의 토큰도 삭제
    await _secureStorage.deleteAll();
  } catch (error) {
    debugPrint('로그아웃 실패: $error');
  }
}
```

---

## FirebaseMessagingService

FCM 푸시 알림을 관리하는 서비스 (싱글톤)

### 위치
`lib/core/services/fcm/firebase_messaging_service.dart`

### 초기화

```dart
// main.dart에서 Firebase 초기화 후 호출
await Firebase.initializeApp();
await LocalNotificationsService.init();
await FirebaseMessagingService.instance().init(
  localNotificationsService: LocalNotificationsService.instance(),
);
```

### API

#### init()

Firebase Messaging을 초기화하고 모든 메시지 리스너를 설정합니다.

```dart
Future<void> init({
  required LocalNotificationsService localNotificationsService,
}) async
```

**파라미터**:
- `localNotificationsService`: 알림 표시를 위한 로컬 알림 서비스

**기능**:
1. FCM 토큰 가져오기 및 디바이스 정보 수집
2. iOS 알림 권한 요청
3. 포그라운드 메시지 리스너 등록
4. 백그라운드 메시지 핸들러 등록
5. 알림 탭 이벤트 리스너 등록

**사용 예시**:
```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  final localNotifications = LocalNotificationsService.instance();
  await localNotifications.init();

  await FirebaseMessagingService.instance().init(
    localNotificationsService: localNotifications,
  );

  runApp(MyApp());
}
```

### 메시지 처리 흐름

#### 1. 포그라운드 메시지 (앱 실행 중)

```dart
// 자동 처리됨 (FirebaseMessagingService 내부)
// 수신된 메시지는 LocalNotificationsService로 전달되어 알림으로 표시
```

#### 2. 백그라운드 메시지 (앱 백그라운드)

```dart
// 자동 처리됨 (FirebaseMessagingService 내부)
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  debugPrint('백그라운드 메시지 수신: ${message.messageId}');
}
```

#### 3. 알림 탭 이벤트 (사용자가 알림 탭)

```dart
// Provider에서 구독하여 처리
FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
  debugPrint('알림 탭: ${message.data}');

  // 특정 화면으로 이동
  if (message.data['type'] == 'course') {
    final courseId = message.data['courseId'];
    context.push('/course-market/detail/$courseId');
  }
});
```

### FCM 토큰 관리

#### 토큰 가져오기

```dart
// 서비스 내부에서 자동 처리됨
final token = await FirebaseMessaging.instance.getToken();
debugPrint('FCM Token: $token');

// TODO: 백엔드에 토큰 전송
await _authApiService.registerFcmToken(token);
```

#### 토큰 갱신 이벤트

```dart
// 서비스 내부에서 자동 구독됨
FirebaseMessaging.instance.onTokenRefresh.listen((fcmToken) {
  debugPrint('FCM 토큰 갱신: $fcmToken');
  // TODO: 백엔드에 갱신된 토큰 전송
});
```

### 디바이스 정보 수집

FCM 초기화 시 자동으로 디바이스 정보를 수집합니다:

```dart
// 자동 수집되는 정보
final deviceName = await DeviceInfoService.getDeviceName();
final deviceType = DeviceInfoService.getDeviceType();
final osVersion = await DeviceInfoService.getOSVersion();
final isPhysical = await DeviceInfoService.isPhysicalDevice();

debugPrint('📱 Device Name: $deviceName');
debugPrint('📱 Device Type: $deviceType');
debugPrint('📱 OS Version: $osVersion');
debugPrint('📱 Physical Device: $isPhysical');
```

---

## LocalNotificationsService

로컬 알림을 표시하는 서비스 (FCM 알림을 실제로 표시) (싱글톤)

### 위치
`lib/core/services/fcm/local_notifications_service.dart`

### 초기화

```dart
await LocalNotificationsService.init();
```

### API

#### init()

로컬 알림 플러그인을 초기화합니다.

```dart
static Future<void> init() async
```

**기능**:
- Android: 알림 채널 생성
- iOS: 알림 권한 요청

**사용 예시**:
```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await LocalNotificationsService.init();
  runApp(MyApp());
}
```

#### showNotification()

알림을 표시합니다.

```dart
Future<void> showNotification({
  required String title,
  required String body,
  Map<String, dynamic>? payload,
}) async
```

**파라미터**:
- `title`: 알림 제목
- `body`: 알림 본문
- `payload`: 알림 탭 시 전달할 데이터 (선택)

**사용 예시**:
```dart
await LocalNotificationsService.instance().showNotification(
  title: '새로운 코스 추천',
  body: '서울의 숨겨진 명소 5곳을 탐험해보세요',
  payload: {
    'type': 'course',
    'courseId': '123',
  },
);
```

---

## SharingService

외부 앱에서 공유된 데이터를 수신하는 서비스 (싱글톤)

### 위치
`lib/core/services/sharing_service.dart`

### 초기화

```dart
await SharingService.instance.initialize();
```

### API

#### initialize()

공유 서비스를 초기화하고 공유 데이터 리스너를 설정합니다.

```dart
Future<void> initialize() async
```

**플랫폼별 동작**:
- iOS: UserDefaults를 통한 데이터 수신, 앱 라이프사이클 리스너 등록
- Android: MethodChannel을 통한 Intent 데이터 수신

**사용 예시**:
```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SharingService.instance.initialize();
  runApp(MyApp());
}
```

#### dataStream

공유 데이터 스트림 (구독하여 데이터 수신)

```dart
Stream<SharedData> get dataStream
```

**사용 예시**:
```dart
class HomePage extends ConsumerStatefulWidget {
  @override
  void initState() {
    super.initState();

    // 공유 데이터 스트림 구독
    SharingService.instance.dataStream.listen((sharedData) {
      debugPrint('공유 데이터 수신: ${sharedData.toString()}');

      if (sharedData.hasTextData) {
        final url = sharedData.firstText;
        if (url != null && SharingService.instance.isValidUrl(url)) {
          _handleSharedUrl(url);
        }
      }

      if (sharedData.hasMediaData) {
        final images = sharedData.images;
        _handleSharedImages(images);
      }
    });
  }

  void _handleSharedUrl(String url) {
    debugPrint('공유된 URL: $url');
    // TODO: URL에서 코스 정보 추출 후 상세 화면으로 이동
  }

  void _handleSharedImages(List<SharedMediaFile> images) {
    debugPrint('공유된 이미지 ${images.length}개');
    // TODO: 이미지 업로드 또는 표시
  }
}
```

#### currentSharedData

현재 공유된 데이터를 반환합니다.

```dart
SharedData? get currentSharedData
```

**사용 예시**:
```dart
final currentData = SharingService.instance.currentSharedData;
if (currentData != null && currentData.hasData) {
  debugPrint('현재 공유 데이터: ${currentData.toString()}');
}
```

#### checkForData()

수동으로 공유 데이터를 확인합니다 (iOS만 해당).

```dart
Future<void> checkForData() async
```

**사용 예시**:
```dart
// 사용자가 새로고침 버튼을 눌렀을 때
await SharingService.instance.checkForData();
```

#### clearCurrentData()

현재 공유 데이터를 초기화합니다.

```dart
void clearCurrentData()
```

**사용 예시**:
```dart
// 공유 데이터 처리 완료 후
SharingService.instance.clearCurrentData();
```

#### pause() / resume()

서비스를 일시정지/재개합니다 (화면 전환 시 리소스 절약).

```dart
void pause()
void resume()
```

**사용 예시**:
```dart
@override
void dispose() {
  SharingService.instance.pause();
  super.dispose();
}

@override
void didChangeDependencies() {
  super.didChangeDependencies();
  SharingService.instance.resume();
}
```

### SharedData 모델

```dart
class SharedData {
  final List<SharedMediaFile> sharedFiles;  // 공유된 미디어 파일
  final List<String> sharedTexts;           // 공유된 텍스트/URL
  final DateTime receivedAt;                // 수신 시간

  bool get hasTextData => sharedTexts.isNotEmpty;
  bool get hasMediaData => sharedFiles.isNotEmpty;
  bool get hasData => hasTextData || hasMediaData;

  String? get firstText => sharedTexts.isNotEmpty ? sharedTexts.first : null;
  List<SharedMediaFile> get images => /* 이미지 파일만 필터링 */;
  List<SharedMediaFile> get videos => /* 동영상 파일만 필터링 */;
  List<SharedMediaFile> get files => /* 일반 파일만 필터링 */;
}
```

### SharedMediaFile 모델

```dart
class SharedMediaFile {
  final String path;              // 파일 경로
  final String? thumbnail;        // 썸네일 경로 (선택)
  final double? duration;         // 동영상 길이 (선택)
  final SharedMediaType type;     // 미디어 타입
}

enum SharedMediaType { image, video, file, text, url }
```

---

## DeviceInfoService

디바이스 정보를 수집하는 서비스

### 위치
`lib/core/services/device_info_service.dart`

### API

#### getDeviceName()

디바이스 이름을 반환합니다.

```dart
static Future<String> getDeviceName() async
```

**반환 예시**:
- iOS: "iPhone 15 Pro", "iPad Pro"
- Android: "Samsung Galaxy S24", "Pixel 8 Pro"

**사용 예시**:
```dart
final deviceName = await DeviceInfoService.getDeviceName();
debugPrint('Device Name: $deviceName');
```

#### getDeviceType()

디바이스 타입을 반환합니다 (iOS 또는 Android).

```dart
static String getDeviceType()
```

**반환값**: `"iOS"` 또는 `"Android"`

**사용 예시**:
```dart
final deviceType = DeviceInfoService.getDeviceType();
debugPrint('Device Type: $deviceType'); // "iOS" 또는 "Android"
```

#### getOSVersion()

운영체제 버전을 반환합니다.

```dart
static Future<String> getOSVersion() async
```

**반환 예시**:
- iOS: "17.2.1", "16.5"
- Android: "14", "13"

**사용 예시**:
```dart
final osVersion = await DeviceInfoService.getOSVersion();
debugPrint('OS Version: $osVersion');
```

#### isPhysicalDevice()

물리적 디바이스인지 시뮬레이터/에뮬레이터인지 확인합니다.

```dart
static Future<bool> isPhysicalDevice() async
```

**반환값**:
- `true`: 실제 디바이스
- `false`: 시뮬레이터/에뮬레이터

**사용 예시**:
```dart
final isPhysical = await DeviceInfoService.isPhysicalDevice();
if (!isPhysical) {
  debugPrint('⚠️ 시뮬레이터에서는 FCM 토큰을 발급받을 수 없습니다');
}
```

#### getFullDeviceInfo()

전체 디바이스 정보를 Map으로 반환합니다 (디버깅용).

```dart
static Future<Map<String, dynamic>> getFullDeviceInfo() async
```

**사용 예시**:
```dart
if (kDebugMode) {
  final fullInfo = await DeviceInfoService.getFullDeviceInfo();
  debugPrint('Full Device Info: $fullInfo');
}
```

---

## AuthApiService

백엔드 인증 API와 통신하는 서비스

### 위치
`lib/features/auth/services/auth_api_service.dart`

### API

#### socialLogin()

소셜 로그인 (Google, Kakao, Naver, Apple)을 처리합니다.

```dart
Future<User> socialLogin({
  required String socialPlatform,
  required String email,
  required String? nickname,
  String? idToken,
}) async
```

**파라미터**:
- `socialPlatform`: `"GOOGLE"`, `"KAKAO"`, `"NAVER"`, `"APPLE"`
- `email`: 사용자 이메일
- `nickname`: 사용자 닉네임 (선택)
- `idToken`: ID 토큰 (Google의 경우 필수)

**반환값**: `User` 모델 (사용자 정보)

**사용 예시**:
```dart
Future<void> _loginWithGoogle() async {
  try {
    // 1. Google OAuth 인증
    final account = await GoogleAuthService.signIn();
    if (account == null) return;

    final auth = await account.authentication;

    // 2. 백엔드 API 호출
    final user = await _authApiService.socialLogin(
      socialPlatform: 'GOOGLE',
      email: account.email,
      nickname: account.displayName,
      idToken: auth.idToken,
    );

    // 3. JWT 토큰 저장
    await _secureStorage.write(key: 'accessToken', value: user.accessToken);

    // 4. FCM 토큰 등록 (선택)
    final fcmToken = await FirebaseMessaging.instance.getToken();
    if (fcmToken != null) {
      await _authApiService.registerFcmToken(fcmToken);
    }

    // 5. 홈 화면으로 이동
    context.go(AppRoutes.home);
  } catch (error) {
    _showError('로그인 실패: $error');
  }
}
```

#### registerFcmToken()

FCM 토큰을 백엔드에 등록합니다.

```dart
Future<void> registerFcmToken(String token) async
```

**사용 예시**:
```dart
final fcmToken = await FirebaseMessaging.instance.getToken();
if (fcmToken != null) {
  await _authApiService.registerFcmToken(fcmToken);
}
```

---

## 개발 가이드라인

### 1. 서비스 생성 가이드

```dart
// 1. 서비스 클래스 생성 (Singleton 패턴 권장)
class NewService {
  static NewService? _instance;

  static NewService get instance {
    _instance ??= NewService._internal();
    return _instance!;
  }

  NewService._internal();

  // API 메서드 작성
  Future<void> doSomething() async {
    // 비즈니스 로직
  }
}

// 2. main.dart에서 초기화
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NewService.instance.initialize();
  runApp(MyApp());
}

// 3. Provider에서 사용
@riverpod
class SomeNotifier extends _$SomeNotifier {
  @override
  Future<Data> build() async {
    final result = await NewService.instance.doSomething();
    return result;
  }
}
```

### 2. 에러 처리

```dart
// ✅ CORRECT - 에러를 throw하여 Provider가 처리하도록
Future<User> socialLogin(...) async {
  try {
    final response = await http.post(...);
    if (response.statusCode != 200) {
      throw Exception('로그인 실패: ${response.body}');
    }
    return User.fromJson(jsonDecode(response.body));
  } catch (error) {
    debugPrint('[AuthApiService] 소셜 로그인 오류: $error');
    rethrow; // Provider의 AsyncValue.error로 전달
  }
}

// ❌ WRONG - 에러를 숨기지 말 것
Future<User?> socialLogin(...) async {
  try {
    // ...
  } catch (error) {
    debugPrint('Error: $error');
    return null; // ❌ 에러를 null로 변환하면 Provider가 에러를 감지할 수 없음
  }
}
```

### 3. 디버그 로그 사용

```dart
import 'package:flutter/foundation.dart';

// ✅ CORRECT - debugPrint 사용 (릴리즈 빌드에서 자동 제거)
debugPrint('[ServiceName] 로그 메시지');

// ❌ WRONG - print 사용 (릴리즈 빌드에서도 출력됨)
print('로그 메시지');
```

### 4. 환경 변수 사용

```dart
import 'package:flutter_dotenv/flutter_dotenv.dart';

// .env 파일
GOOGLE_IOS_CLIENT_ID=your-ios-client-id
GOOGLE_WEB_CLIENT_ID=your-web-client-id

// 서비스에서 사용
final clientId = dotenv.env['GOOGLE_IOS_CLIENT_ID'];
if (clientId == null) {
  throw Exception('GOOGLE_IOS_CLIENT_ID가 설정되지 않았습니다');
}
```

### 5. 플랫폼 분기 처리

```dart
import 'dart:io' show Platform;

if (Platform.isIOS) {
  // iOS 전용 로직
  final clientId = dotenv.env['GOOGLE_IOS_CLIENT_ID'];
} else if (Platform.isAndroid) {
  // Android 전용 로직
  final clientId = dotenv.env['GOOGLE_WEB_CLIENT_ID'];
}
```

### 6. 리소스 정리

```dart
class SomeService {
  StreamController<Data>? _streamController;

  void dispose() {
    _streamController?.close();
    _streamController = null;
    debugPrint('[SomeService] 리소스 정리 완료');
  }
}
```

---

## 모범 사례

### ✅ 올바른 예시

```dart
// 1. Singleton 패턴으로 서비스 생성
class MyService {
  static MyService? _instance;
  static MyService get instance {
    _instance ??= MyService._internal();
    return _instance!;
  }
  MyService._internal();
}

// 2. 에러 처리 및 로깅
Future<Data> fetchData() async {
  try {
    debugPrint('[MyService] 데이터 가져오기 시작');
    final result = await _apiCall();
    debugPrint('[MyService] 데이터 가져오기 성공');
    return result;
  } catch (error) {
    debugPrint('[MyService] 데이터 가져오기 실패: $error');
    rethrow;
  }
}

// 3. 리소스 정리
void dispose() {
  _streamController?.close();
  _timer?.cancel();
  debugPrint('[MyService] 리소스 정리 완료');
}
```

### ❌ 잘못된 예시

```dart
// 1. 매번 새 인스턴스 생성 (메모리 낭비)
class MyService {
  MyService(); // ❌ Singleton 사용 권장
}

// 2. 에러 숨김
Future<Data?> fetchData() async {
  try {
    return await _apiCall();
  } catch (error) {
    return null; // ❌ 에러를 throw하여 Provider가 처리하도록
  }
}

// 3. print 사용
print('Log message'); // ❌ debugPrint 사용
```

---

## 참고 자료

- [google_sign_in 패키지](https://pub.dev/packages/google_sign_in)
- [firebase_messaging 패키지](https://pub.dev/packages/firebase_messaging)
- [flutter_local_notifications 패키지](https://pub.dev/packages/flutter_local_notifications)
- [device_info_plus 패키지](https://pub.dev/packages/device_info_plus)

---

**Last Updated**: 2025-11-10
**Version**: 1.0.0
**Maintained by**: [@EM-H20](https://github.com/EM-H20)
