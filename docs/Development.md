# 📚 Development.md

**최종 업데이트**: 2025-01-20
**프로젝트 버전**: 1.0.0
**Flutter SDK**: 3.24.0+

---

## 📋 목차

- [개발 환경 요구사항](#개발-환경-요구사항)
- [프로젝트 설정](#프로젝트-설정)
- [개발 워크플로우](#개발-워크플로우)
- [코드 스타일 가이드](#코드-스타일-가이드)
- [테스트 가이드](#테스트-가이드)
- [디버깅 가이드](#디버깅-가이드)
- [빌드 및 배포](#빌드-및-배포)
- [CI/CD 파이프라인](#cicd-파이프라인)
- [문제 해결](#문제-해결)

---

## 🔧 개발 환경 요구사항

### 필수 소프트웨어

| 도구 | 최소 버전 | 권장 버전 | 용도 |
|------|----------|----------|------|
| Flutter SDK | 3.24.0 | 3.24.5+ | 프레임워크 |
| Dart SDK | 3.5.0 | 3.5.0+ | 언어 |
| Android Studio | 2022.3 | 최신 버전 | Android 개발 |
| Xcode | 14.0 | 15.0+ | iOS 개발 (macOS) |
| VS Code | 1.80 | 최신 버전 | IDE (선택) |
| CocoaPods | 1.11 | 1.14+ | iOS 의존성 (macOS) |

### Flutter 설치 및 검증

```bash
# Flutter 설치 확인
flutter doctor -v

# 예상 출력:
[✓] Flutter (Channel stable, 3.24.5)
[✓] Android toolchain - develop for Android devices
[✓] Xcode - develop for iOS and macOS (macOS only)
[✓] Chrome - develop for the web
[✓] Android Studio
[✓] VS Code
[✓] Connected device (디바이스 연결 시)

# 문제 해결
flutter doctor --android-licenses  # Android 라이선스 동의
```

### IDE 설정

#### VS Code 필수 확장
- Flutter (Dart-Code.flutter)
- Dart (Dart-Code.dart-code)
- Error Lens (usernamehw.errorlens)
- Flutter Riverpod Snippets (robert-brunhage.flutter-riverpod-snippets)
- GitLens (eamodio.gitlens)

#### Android Studio 필수 플러그인
- Flutter
- Dart
- Rainbow Brackets
- Flutter Intl

---

## 🚀 프로젝트 설정

### 1. 저장소 클론

```bash
# HTTPS
git clone https://github.com/TEAM-Tripgether/tripgether-flutter.git

# SSH (권장)
git clone git@github.com:TEAM-Tripgether/tripgether-flutter.git

cd tripgether-flutter
```

### 2. 환경 변수 설정

**.env 파일 생성** (프로젝트 루트):

```env
# API 설정
API_BASE_URL=https://api.tripgether.suhsaechan.kr

# Google OAuth
GOOGLE_IOS_CLIENT_ID=your-ios-client-id.apps.googleusercontent.com
GOOGLE_WEB_CLIENT_ID=your-web-client-id.apps.googleusercontent.com

# Firebase (선택 - 자동 설정 가능)
FIREBASE_API_KEY=your-firebase-api-key
FIREBASE_PROJECT_ID=your-project-id
```

### 3. Firebase 설정

```bash
# Firebase CLI 설치
npm install -g firebase-tools

# FlutterFire CLI 설치
dart pub global activate flutterfire_cli

# Firebase 프로젝트 설정
flutterfire configure

# 생성되는 파일:
# - android/app/google-services.json
# - ios/Runner/GoogleService-Info.plist
# - lib/firebase_options.dart
```

### 4. 의존성 설치

```bash
# Flutter 패키지 설치
flutter pub get

# iOS 의존성 설치 (macOS)
cd ios && pod install && cd ..

# Riverpod 코드 생성
dart run build_runner build --delete-conflicting-outputs
```

### 5. 플랫폼별 추가 설정

#### iOS (macOS)
```bash
# Xcode 프로젝트 열기
open ios/Runner.xcworkspace

# Signing & Capabilities에서:
1. Team 선택
2. Bundle Identifier 확인: kr.co.tripgether.app
3. Push Notifications capability 추가
4. Background Modes > Remote notifications 체크
```

#### Android
```bash
# 최소 SDK 확인 (android/app/build.gradle)
minSdkVersion 21
targetSdkVersion 34
compileSdkVersion 34

# 서명 키 생성 (배포용)
keytool -genkey -v -keystore ~/tripgether.jks -keyalg RSA -keysize 2048 -validity 10000 -alias tripgether
```

---

## 💻 개발 워크플로우

### Git Flow 전략

```
main (production)
  ├── develop (개발 통합)
  │   ├── feature/기능명 (기능 개발)
  │   ├── fix/버그명 (버그 수정)
  │   └── refactor/개선사항 (리팩토링)
  └── hotfix/긴급수정 (운영 긴급 수정)
```

### 브랜치 명명 규칙

```bash
# 형식: 날짜_#이슈번호_타입_카테고리_설명

# 예시:
20251120_#83_기능개선_온보딩_온보딩_API_1차_수정
20251112_#81_디자인_색상_레이아웃_1차_디자인_피드백
```

### 커밋 메시지 규칙

```bash
# 형식: 브랜치명 : 타입 : 설명 #이슈번호

# 예시:
온보딩 API 1차 수정 : feat : 관심사 API 마이그레이션 및 JWT 인증 추가 #83
온보딩 화면 수정 : fix : 성별 선택 버튼 오류 수정 #45
```

### 개발 프로세스

```bash
# 1. 이슈 생성 (GitHub Issues)
제목: [feat] 코스 상세 화면 구현
레이블: enhancement, frontend

# 2. 브랜치 생성
git checkout -b 20251120_#123_기능개발_코스_상세화면_구현

# 3. 개발 진행
# - TDD 방식으로 테스트 먼저 작성
# - 기능 구현
# - 코드 리뷰 반영

# 4. 커밋
git add .
git commit -m "코스 상세화면 : feat : 코스 정보 표시 및 지도 연동 #123"

# 5. PR 생성
# 제목: [#123] 코스 상세 화면 구현
# 설명: 구현 내용, 스크린샷, 테스트 결과
```

---

## 📝 코드 스타일 가이드

### Dart 명명 규칙

```dart
// 📁 파일명: snake_case
user_profile_page.dart
common_button.dart
auth_service.dart

// 📦 클래스명: PascalCase
class UserProfile {}
class AuthService {}
class CourseDetailPage {}

// 🔤 변수/함수명: camelCase
final userName = 'John';
void getUserData() {}
bool isLoggedIn = false;

// 🔢 상수: camelCase 또는 SCREAMING_SNAKE_CASE
const apiTimeout = 30;
const MAX_RETRY_COUNT = 3;
```

### Import 순서

```dart
// 1. Dart SDK
import 'dart:async';
import 'dart:convert';

// 2. Flutter
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// 3. 외부 패키지 (알파벳 순)
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

// 4. 프로젝트 내부 (상대 경로)
import '../../../core/theme/app_colors.dart';
import '../../models/user.dart';

// 5. Part files
part 'user_provider.g.dart';
```

### 디자인 시스템 준수

```dart
// ✅ CORRECT - 디자인 시스템 사용
import 'package:tripgether/core/theme/app_colors.dart';
import 'package:tripgether/core/theme/app_text_styles.dart';
import 'package:tripgether/core/theme/app_spacing.dart';

Text(
  '제목',
  style: AppTextStyles.titleBold24,
)

Container(
  padding: EdgeInsets.all(AppSpacing.lg),
  decoration: BoxDecoration(
    color: AppColors.primary,
    borderRadius: BorderRadius.circular(AppRadius.large),
  ),
)

// ❌ WRONG - 하드코딩 금지
TextStyle(fontSize: 24, fontWeight: FontWeight.bold)  // 금지!
Color(0xFF6366F1)  // 금지!
EdgeInsets.all(16)  // 금지!
```

### Riverpod 패턴

```dart
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'course_provider.g.dart';

// 1. AsyncNotifier 패턴 (추천)
@riverpod
class CourseDetail extends _$CourseDetail {
  @override
  Future<Course> build(String courseId) async {
    return await ref.read(courseServiceProvider).getCourse(courseId);
  }

  Future<void> updateCourse(Course course) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      return await ref.read(courseServiceProvider).updateCourse(course);
    });
  }
}

// 2. Provider 사용
final courseAsync = ref.watch(courseDetailProvider(courseId));

courseAsync.when(
  data: (course) => CourseDetailView(course: course),
  loading: () => const LoadingIndicator(),
  error: (error, stack) => ErrorView(error: error),
);
```

---

## 🧪 테스트 가이드

### 테스트 구조

```
test/
├── unit/           # 단위 테스트
│   ├── services/
│   └── models/
├── widget/         # 위젯 테스트
│   └── widgets/
├── integration/    # 통합 테스트
│   └── features/
└── fixtures/       # 테스트 데이터
```

### 단위 테스트 예시

```dart
// test/unit/services/auth_service_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthApi extends Mock implements AuthApiService {}

void main() {
  group('AuthService', () {
    late AuthService authService;
    late MockAuthApi mockApi;

    setUp(() {
      mockApi = MockAuthApi();
      authService = AuthService(api: mockApi);
    });

    test('로그인 성공 시 토큰 저장', () async {
      // Given
      when(() => mockApi.signIn(any()))
        .thenAnswer((_) async => AuthResponse(token: 'test-token'));

      // When
      final result = await authService.signIn('test@test.com');

      // Then
      expect(result.isSuccess, true);
      verify(() => mockApi.signIn(any())).called(1);
    });
  });
}
```

### 위젯 테스트 예시

```dart
// test/widget/widgets/common_button_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('PrimaryButton 탭 이벤트 테스트', (tester) async {
    // Given
    var tapped = false;

    await tester.pumpWidget(
      MaterialApp(
        home: PrimaryButton(
          text: '확인',
          onPressed: () => tapped = true,
        ),
      ),
    );

    // When
    await tester.tap(find.text('확인'));
    await tester.pumpAndSettle();

    // Then
    expect(tapped, true);
  });
}
```

### 테스트 실행

```bash
# 모든 테스트 실행
flutter test

# 특정 테스트만 실행
flutter test test/unit/services/

# 커버리지 리포트 생성
flutter test --coverage
lcov --remove coverage/lcov.info '*.g.dart' '*.freezed.dart' -o coverage/lcov.info
genhtml coverage/lcov.info -o coverage/html
open coverage/html/index.html

# 테스트 watch 모드
flutter test --reporter expanded
```

---

## 🐛 디버깅 가이드

### 로깅 전략

```dart
import 'package:flutter/foundation.dart';

// 개발용 로그 (릴리즈에서 자동 제거)
debugPrint('[AuthService] 로그인 시도: $email');

// 조건부 로그
if (kDebugMode) {
  print('디버그 모드에서만 출력');
}

// 에러 로깅
try {
  // 코드
} catch (e, stackTrace) {
  debugPrint('에러 발생: $e');
  debugPrintStack(stackTrace: stackTrace);
}
```

### Flutter Inspector

```bash
# DevTools 실행
flutter pub global activate devtools
flutter pub global run devtools

# 기능:
- Widget Inspector: 위젯 트리 탐색
- Network: HTTP 요청/응답 모니터링
- Performance: 프레임 분석
- Memory: 메모리 누수 감지
- Logging: 콘솔 로그 확인
```

### 디버깅 팁

```dart
// 1. 위젯 경계 표시
void main() {
  debugPaintSizeEnabled = true;  // 위젯 경계
  runApp(MyApp());
}

// 2. 성능 오버레이
MaterialApp(
  showPerformanceOverlay: true,  // FPS 표시
)

// 3. 조건부 중단점
if (user.id == 'debug-user') {
  debugger();  // 여기서 중단
}
```

---

## 📦 빌드 및 배포

### 버전 관리

```yaml
# pubspec.yaml
name: tripgether
version: 1.2.3+45
#        │ │ │  │
#        │ │ │  └── Build number (자동 증가)
#        │ │ └───── Patch (버그 수정)
#        │ └─────── Minor (기능 추가)
#        └───────── Major (대규모 변경)
```

### Android 빌드

```bash
# 개발 빌드
flutter build apk --debug

# 릴리즈 빌드 (APK)
flutter build apk --release --obfuscate --split-debug-info=build/symbols

# 릴리즈 빌드 (App Bundle - Play Store)
flutter build appbundle --release --obfuscate --split-debug-info=build/symbols

# 빌드 결과:
# build/app/outputs/flutter-apk/app-release.apk
# build/app/outputs/bundle/release/app-release.aab
```

### iOS 빌드

```bash
# 개발 빌드
flutter build ios --debug

# 릴리즈 빌드
flutter build ios --release --obfuscate --split-debug-info=build/symbols

# IPA 생성 (App Store)
flutter build ipa --release --obfuscate --split-debug-info=build/symbols

# 빌드 결과:
# build/ios/iphoneos/Runner.app
# build/ios/ipa/tripgether.ipa
```

### 빌드 최적화

```bash
# 앱 크기 분석
flutter build apk --analyze-size
flutter pub global activate devtools
flutter pub global run devtools --appSizeBase=apk-code-size-analysis_01.json

# ProGuard 규칙 (android/app/proguard-rules.pro)
-keep class kr.co.tripgether.** { *; }
-keep class com.google.firebase.** { *; }
```

---

## 🚀 CI/CD 파이프라인

### GitHub Actions 워크플로우

```yaml
# .github/workflows/flutter_ci.yml
name: Flutter CI

on:
  push:
    branches: [main, develop]
  pull_request:
    branches: [main, develop]

jobs:
  test:
    runs-on: ubuntu-latest

    steps:
    - uses: actions/checkout@v3

    - uses: subosito/flutter-action@v2
      with:
        flutter-version: '3.24.5'
        channel: 'stable'

    - name: Install dependencies
      run: flutter pub get

    - name: Run tests
      run: flutter test --coverage

    - name: Upload coverage
      uses: codecov/codecov-action@v3
      with:
        file: coverage/lcov.info
```

### Fastlane 배포 (선택)

```ruby
# ios/fastlane/Fastfile
lane :beta do
  build_app(
    scheme: "Runner",
    export_method: "app-store"
  )
  upload_to_testflight
end

# android/fastlane/Fastfile
lane :beta do
  gradle(
    task: 'bundle',
    build_type: 'Release'
  )
  upload_to_play_store(track: 'beta')
end
```

---

## 🔧 문제 해결

### 자주 발생하는 문제

#### 1. Gradle 빌드 실패
```bash
# 해결:
cd android
./gradlew clean
cd ..
flutter clean
flutter pub get
```

#### 2. iOS 빌드 실패
```bash
# 해결:
cd ios
rm -rf Pods Podfile.lock
pod cache clean --all
pod install --repo-update
cd ..
flutter clean
```

#### 3. Riverpod 코드 생성 오류
```bash
# 해결:
dart run build_runner clean
dart run build_runner build --delete-conflicting-outputs
```

#### 4. 패키지 버전 충돌
```bash
# 해결:
flutter pub deps
flutter pub upgrade --major-versions
```

### 디버깅 체크리스트

- [ ] `flutter doctor` 모든 항목 정상?
- [ ] 최신 stable Flutter 버전 사용?
- [ ] `pubspec.yaml` 의존성 버전 호환?
- [ ] Firebase 설정 파일 올바른 위치?
- [ ] 환경 변수 (.env) 제대로 설정?
- [ ] iOS: 인증서 및 프로비저닝 프로파일 유효?
- [ ] Android: 서명 키스토어 설정?

---

## 📚 참고 자료

### 프로젝트 문서
- [README.md](README.md) - 프로젝트 개요
- [Architecture.md](Architecture.md) - 아키텍처 설명
- [DesignSystem.md](DesignSystem.md) - 디자인 시스템
- [Widgets.md](Widgets.md) - 공용 위젯 가이드
- [Services.md](Services.md) - 서비스 레이어
- [BackendAPI.md](BackendAPI.md) - API 명세

### 외부 링크
- [Flutter 공식 문서](https://docs.flutter.dev)
- [Dart 스타일 가이드](https://dart.dev/effective-dart/style)
- [Riverpod 문서](https://riverpod.dev)
- [Material Design 3](https://m3.material.io)
- [Firebase Flutter](https://firebase.google.com/docs/flutter/setup)

### 팀 리소스
- [GitHub Repository](https://github.com/TEAM-Tripgether/tripgether-flutter)
- [API 문서](https://api.tripgether.suhsaechan.kr/docs)
- [Figma 디자인](https://figma.com/tripgether) *(링크 필요)*
- [Notion 위키](https://notion.so/tripgether) *(링크 필요)*

---

**문서 버전**: 1.0.0
**최종 수정**: 2025-01-20
**작성자**: Claude Code