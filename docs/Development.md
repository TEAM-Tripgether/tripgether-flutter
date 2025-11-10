# Tripgether 개발 가이드

> 📚 **개발 환경 설정부터 배포까지 완벽 가이드**

## 📋 목차

- [개발 환경 설정](#개발-환경-설정)
- [프로젝트 실행](#프로젝트-실행)
- [개발 워크플로우](#개발-워크플로우)
- [코드 스타일 가이드](#코드-스타일-가이드)
- [테스트 가이드](#테스트-가이드)
- [디버깅 가이드](#디버깅-가이드)
- [빌드 및 배포](#빌드-및-배포)
- [문제 해결](#문제-해결)

---

## 개발 환경 설정

### 필수 도구

#### 1. Flutter SDK

```bash
# Flutter SDK 설치 (버전 3.24.5 이상)
flutter doctor

# 필요한 항목 모두 체크 확인:
# [✓] Flutter (Channel stable, 3.24.5)
# [✓] Android toolchain
# [✓] Xcode (macOS만 해당)
# [✓] Chrome (웹 개발 시)
# [✓] Android Studio / VS Code
```

#### 2. IDE 설정

**VS Code**:
```bash
# 필수 확장 프로그램 설치
- Flutter (by Dart Code)
- Dart (by Dart Code)
- Riverpod Snippets (by Robert Brunhage)
- Error Lens (by Alexander)
```

**Android Studio**:
```bash
# 필수 플러그인 설치
- Flutter
- Dart
- Rainbow Brackets
```

#### 3. 환경 변수 설정

`.env` 파일을 생성하고 다음 정보를 입력합니다:

```env
# Google OAuth
GOOGLE_IOS_CLIENT_ID=your-ios-client-id
GOOGLE_WEB_CLIENT_ID=your-web-client-id

# Firebase (자동으로 생성됨)
# google-services.json (Android)
# GoogleService-Info.plist (iOS)

# 백엔드 API
API_BASE_URL=http://api.tripgether.suhsaechan.kr
```

**환경 변수 획득 방법**:
1. Google Cloud Console → API 및 서비스 → 사용자 인증 정보
2. Firebase Console → 프로젝트 설정 → 앱 추가
3. 백엔드 개발자에게 API URL 요청

### 프로젝트 클론

```bash
# 저장소 클론
git clone https://github.com/TEAM-Tripgether/tripgether-flutter.git
cd tripgether-flutter

# 의존성 설치
flutter pub get

# Riverpod 코드 생성
dart run build_runner build --delete-conflicting-outputs
```

### iOS 설정 (macOS만 해당)

```bash
# 1. CocoaPods 설치
sudo gem install cocoapods

# 2. iOS 의존성 설치
cd ios
pod install
cd ..

# 3. Xcode에서 서명 설정
open ios/Runner.xcworkspace

# Xcode에서:
# - Runner → Signing & Capabilities
# - Team 선택
# - Bundle Identifier 확인 (kr.co.tripgether.app)
```

### Android 설정

```bash
# 1. google-services.json 추가
# Firebase Console에서 다운로드 후 android/app/ 폴더에 복사

# 2. Android SDK 경로 확인
flutter doctor -v

# 3. Gradle 동기화
cd android
./gradlew clean
cd ..
```

---

## 프로젝트 실행

### 기본 실행

```bash
# 개발 서버 실행 (핫 리로드 활성화)
flutter run

# 특정 디바이스에서 실행
flutter devices                     # 연결된 디바이스 목록
flutter run -d <device-id>          # 특정 디바이스에서 실행

# 릴리즈 모드로 실행
flutter run --release
```

### Riverpod 코드 생성 (자동 감지)

```bash
# 파일 변경 시 자동으로 코드 생성 (개발 중 권장)
dart run build_runner watch

# 또는 일회성 생성
dart run build_runner build

# 기존 파일 삭제 후 재생성
dart run build_runner build --delete-conflicting-outputs
```

### 플랫폼별 실행

#### iOS

```bash
# iOS 시뮬레이터 실행
open -a Simulator

# 특정 시뮬레이터 실행
flutter run -d "iPhone 15 Pro"

# 실제 디바이스 실행
flutter run -d <device-id>
```

#### Android

```bash
# 에뮬레이터 목록 확인
flutter emulators

# 에뮬레이터 실행
flutter emulators --launch <emulator-id>

# 실제 디바이스 실행
flutter run -d <device-id>
```

---

## 개발 워크플로우

### 새로운 Feature 개발

```bash
# 1. 새 브랜치 생성
git checkout -b feature/코스-상세-화면

# 2. Feature 디렉토리 생성
features/course_detail/
  ├── models/          # 데이터 모델
  ├── providers/       # 상태 관리
  ├── services/        # API 서비스
  └── presentation/    # UI 레이어
      ├── pages/
      └── widgets/

# 3. Provider 작성 (Riverpod @riverpod 어노테이션)
@riverpod
class CourseDetailNotifier extends _$CourseDetailNotifier {
  @override
  Future<Course> build(String courseId) async {
    return await ref.read(courseServiceProvider).getCourseDetail(courseId);
  }
}

# 4. 코드 생성
dart run build_runner build

# 5. UI 작성 (공용 위젯 재사용)
class CourseDetailPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final courseState = ref.watch(courseDetailNotifierProvider(courseId));

    return courseState.when(
      data: (course) => _buildContent(course),
      loading: () => CircularProgressIndicator(),
      error: (error, _) => ErrorWidget(error),
    );
  }
}

# 6. 코드 포맷팅 및 분석
dart format .
flutter analyze

# 7. 커밋
git add .
git commit -m "feature/코스-상세-화면 : feat : 코스 상세 화면 구현 #123"

# 8. 푸시
git push origin feature/코스-상세-화면
```

### Provider 작성 패턴

```dart
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'my_provider.g.dart';

// 1. 비동기 Provider (데이터 로딩)
@riverpod
class UserNotifier extends _$UserNotifier {
  @override
  Future<User?> build() async {
    // 초기 데이터 로드
    return await _loadUser();
  }

  Future<void> updateUser(User user) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await _api.updateUser(user);
      return user;
    });
  }
}

// 2. 동기 Provider (계산된 값)
@riverpod
String greeting(GreetingRef ref) {
  final user = ref.watch(userNotifierProvider).value;
  return '안녕하세요, ${user?.nickname ?? "게스트"}님!';
}

// 3. Family Provider (파라미터가 있는 Provider)
@riverpod
Future<Course> courseDetail(CourseDetailRef ref, String courseId) async {
  return await ref.read(courseServiceProvider).getCourseDetail(courseId);
}
```

### 라우팅 추가

```dart
// 1. core/router/routes.dart에 경로 추가
class AppRoutes {
  static const String courseDetail = '/course-market/detail/:courseId';
}

// 2. core/router/router.dart에 라우트 추가
GoRoute(
  path: AppRoutes.courseDetail,
  builder: (context, state) {
    final courseId = state.pathParameters['courseId']!;
    return CourseDetailPage(courseId: courseId);
  },
),

// 3. 화면 이동
context.push('/course-market/detail/123');
// 또는
context.go(AppRoutes.courseDetail.replaceFirst(':courseId', '123'));
```

---

## 코드 스타일 가이드

### Dart 스타일 가이드 준수

```dart
// ✅ CORRECT - 변수명은 camelCase
final userName = 'John Doe';
final isLoggedIn = true;

// ✅ CORRECT - 클래스명은 PascalCase
class UserProfile extends StatelessWidget {}

// ✅ CORRECT - 파일명은 snake_case
user_profile_page.dart
common_button.dart

// ❌ WRONG
final UserName = 'John';         // 변수는 camelCase
class userProfile {}             // 클래스는 PascalCase
UserProfilePage.dart             // 파일은 snake_case
```

### 필수 import 순서

```dart
// 1. Dart 표준 라이브러리
import 'dart:async';
import 'dart:io';

// 2. Flutter 라이브러리
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// 3. 외부 패키지 (알파벳 순서)
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

// 4. 프로젝트 내부 (상대 경로)
import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/buttons/common_button.dart';
import '../../models/user.dart';
```

### 주석 작성 규칙

```dart
/// 공개 API에 대한 문서 주석 (3개의 슬래시)
///
/// 사용 예시:
/// ```dart
/// final user = await UserService.getUser('123');
/// ```
class UserService {
  // 구현 상세에 대한 일반 주석 (2개의 슬래시)
  Future<User> getUser(String userId) async {
    // TODO: 캐싱 로직 추가
    return await _api.fetchUser(userId);
  }
}
```

### 한국어 주석 사용

```dart
// ✅ CORRECT - 한국어 주석으로 명확하게
// 사용자가 로그인했는지 확인
if (!isLoggedIn) {
  // 로그인 화면으로 이동
  context.go(AppRoutes.login);
}

// ❌ WRONG - 불필요한 영어 주석
// Check if user is logged in
if (!isLoggedIn) {
  // Navigate to login screen
  context.go(AppRoutes.login);
}
```

---

## 테스트 가이드

### 단위 테스트 (Unit Test)

```dart
// test/services/auth_service_test.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:tripgether/core/services/auth/google_auth_service.dart';

void main() {
  group('GoogleAuthService', () {
    test('initialize should not throw error', () async {
      expect(() async => await GoogleAuthService.initialize(), returnsNormally);
    });

    test('signIn returns null when user cancels', () async {
      final account = await GoogleAuthService.signIn();
      // 사용자가 취소하면 null 반환
      expect(account, isNull);
    });
  });
}
```

### 위젯 테스트 (Widget Test)

```dart
// test/widgets/buttons/common_button_test.dart

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tripgether/shared/widgets/buttons/common_button.dart';

void main() {
  testWidgets('PrimaryButton renders correctly', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: PrimaryButton(
            text: '확인',
            onPressed: () {},
          ),
        ),
      ),
    );

    expect(find.text('확인'), findsOneWidget);
    expect(find.byType(ElevatedButton), findsOneWidget);
  });

  testWidgets('PrimaryButton shows loading state', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: PrimaryButton(
            text: '저장',
            isLoading: true,
            onPressed: () {},
          ),
        ),
      ),
    );

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });
}
```

### 테스트 실행

```bash
# 모든 테스트 실행
flutter test

# 특정 테스트 파일만 실행
flutter test test/services/auth_service_test.dart

# 커버리지 생성
flutter test --coverage
genhtml coverage/lcov.info -o coverage/html
open coverage/html/index.html
```

---

## 디버깅 가이드

### 로그 출력

```dart
import 'package:flutter/foundation.dart';

// ✅ CORRECT - debugPrint 사용 (릴리즈 빌드에서 자동 제거)
debugPrint('[ServiceName] 로그 메시지');

// ❌ WRONG - print 사용 (릴리즈 빌드에서도 출력됨)
print('로그 메시지');
```

### Flutter DevTools

```bash
# DevTools 실행
flutter pub global activate devtools
flutter pub global run devtools

# 또는 IDE에서 실행
# VS Code: 디버그 패널 → "Open DevTools"
# Android Studio: Run → Flutter DevTools
```

**주요 기능**:
- **Flutter Inspector**: 위젯 트리 시각화, 레이아웃 문제 디버깅
- **Network**: HTTP 요청/응답 모니터링
- **Performance**: CPU/GPU 프로파일링
- **Memory**: 메모리 누수 감지

### 브레이크포인트 사용

```dart
// 1. 코드에서 직접 브레이크포인트 설정
debugger(); // 여기서 멈춤

// 2. IDE에서 라인 번호 클릭하여 브레이크포인트 설정

// 3. 조건부 브레이크포인트
if (userId == '123') {
  debugger(); // userId가 '123'일 때만 멈춤
}
```

### 네트워크 디버깅

```dart
// HTTP 요청 로깅
final response = await http.post(
  Uri.parse('$baseUrl/api/auth/sign-in'),
  headers: {'Content-Type': 'application/json'},
  body: jsonEncode(requestData),
);

debugPrint('Request URL: $baseUrl/api/auth/sign-in');
debugPrint('Request Body: ${jsonEncode(requestData)}');
debugPrint('Response Status: ${response.statusCode}');
debugPrint('Response Body: ${response.body}');
```

---

## 빌드 및 배포

### Android 빌드

```bash
# 1. 디버그 빌드 (개발 중)
flutter build apk --debug

# 2. 릴리즈 빌드 (배포용)
flutter build apk --release

# 3. App Bundle 빌드 (Google Play Store 권장)
flutter build appbundle --release

# 빌드 결과 위치:
# build/app/outputs/flutter-apk/app-release.apk
# build/app/outputs/bundle/release/app-release.aab
```

### iOS 빌드 (macOS만 해당)

```bash
# 1. 시뮬레이터용 빌드
flutter build ios --simulator

# 2. 실제 디바이스용 빌드
flutter build ios --release

# 3. Archive 생성 (App Store 배포용)
flutter build ipa --release

# 빌드 결과 위치:
# build/ios/iphoneos/Runner.app
# build/ios/archive/Runner.xcarchive
```

### 버전 관리

```yaml
# pubspec.yaml
version: 1.0.0+1
#        │   │ │
#        │   │ └─ Build number (1, 2, 3, ...)
#        │   └─── Patch version
#        └─────── Major.Minor version

# 버전 업데이트 예시:
# 1.0.0+1 → 1.0.1+2 (버그 수정)
# 1.0.1+2 → 1.1.0+3 (새 기능)
# 1.1.0+3 → 2.0.0+4 (대규모 변경)
```

### 난독화 (Obfuscation)

```bash
# 난독화 포함 릴리즈 빌드
flutter build apk --release --obfuscate --split-debug-info=build/debug-info
flutter build ios --release --obfuscate --split-debug-info=build/debug-info

# 난독화 심볼 저장 (크래시 리포트 분석용)
# build/debug-info/ 디렉토리 백업 필수
```

---

## 문제 해결

### 자주 발생하는 문제

#### 1. "Gradle build failed with exit code 1"

```bash
# 해결 방법:
cd android
./gradlew clean
cd ..
flutter clean
flutter pub get
flutter run
```

#### 2. "CocoaPods not installed"

```bash
# 해결 방법:
sudo gem install cocoapods
cd ios
pod install
cd ..
```

#### 3. "The Flutter SDK is not available"

```bash
# 해결 방법:
flutter doctor
flutter upgrade
```

#### 4. "Build runner conflicts"

```bash
# 해결 방법:
dart run build_runner clean
dart run build_runner build --delete-conflicting-outputs
```

#### 5. "Google Sign-In 실패"

```bash
# 체크리스트:
# 1. .env 파일에 GOOGLE_IOS_CLIENT_ID와 GOOGLE_WEB_CLIENT_ID 설정 확인
# 2. Firebase Console에서 iOS/Android 앱 추가 확인
# 3. google-services.json (Android) 및 GoogleService-Info.plist (iOS) 파일 확인
# 4. iOS: Xcode에서 URL Schemes 설정 확인
```

#### 6. "FCM 토큰 발급 실패 (iOS 시뮬레이터)"

```bash
# 정상 동작:
# iOS 시뮬레이터에서는 FCM 토큰을 발급받을 수 없습니다.
# 실제 iOS 디바이스에서 테스트하세요.

# 확인 방법:
final isPhysical = await DeviceInfoService.isPhysicalDevice();
if (!isPhysical) {
  debugPrint('⚠️ FCM은 실제 디바이스에서만 동작합니다');
}
```

### 로그 분석

```bash
# Android 로그 확인
flutter logs

# iOS 로그 확인
flutter logs -d <ios-device-id>

# 특정 태그만 필터링
flutter logs | grep "\[ServiceName\]"
```

### 성능 프로파일링

```bash
# CPU 프로파일링
flutter run --profile

# 메모리 프로파일링
flutter run --profile --trace-skia

# DevTools에서 분석
flutter pub global run devtools
```

---

## 추가 리소스

### 공식 문서
- [Flutter 공식 문서](https://flutter.dev/docs)
- [Dart 언어 가이드](https://dart.dev/guides)
- [Riverpod 공식 문서](https://riverpod.dev)
- [GoRouter 가이드](https://pub.dev/packages/go_router)

### 프로젝트 문서
- [Architecture.md](Architecture.md) - 아키텍처 설명
- [DesignSystem.md](DesignSystem.md) - 디자인 시스템 가이드
- [Widgets.md](Widgets.md) - 공용 위젯 API
- [Services.md](Services.md) - 핵심 서비스 API

### 유용한 도구
- [Flutter Inspector](https://docs.flutter.dev/tools/devtools/inspector)
- [Dart DevTools](https://dart.dev/tools/dart-devtools)
- [Android Studio Emulator](https://developer.android.com/studio/run/emulator)
- [Xcode Simulator](https://developer.apple.com/documentation/xcode/running-your-app-in-simulator-or-on-a-device)

---

**Last Updated**: 2025-11-10
**Version**: 1.0.0
**Maintained by**: [@EM-H20](https://github.com/EM-H20)
