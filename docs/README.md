# Tripgether 프로젝트 문서

> 📚 **Tripgether Flutter 앱의 완벽한 기술 문서**

## 📋 문서 목록

### 1. [Architecture.md](Architecture.md)
**프로젝트 아키텍처 설명서**

- 기술 스택 및 핵심 패키지
- 프로젝트 구조 (Feature-First)
- Clean Architecture + Riverpod 상태 관리
- 라우팅 시스템 (GoRouter)
- 인증 흐름 (Google OAuth + 백엔드 API)
- 서비스 레이어 구조
- 데이터 흐름 및 모범 사례

**대상 독자**: 신규 개발자, 아키텍처 리뷰어, 기술 리더

---

### 2. [DesignSystem.md](DesignSystem.md)
**디자인 시스템 가이드**

- 색상 시스템 (Primary, Status, Social 등)
- 타이포그래피 (Pretendard 폰트)
- 간격 시스템 (Spacing, Radius, Elevation, Sizes)
- 반응형 UI (ScreenUtil)
- 컴포넌트 스타일 (Button, Card, Input 등)
- 사용 예시 및 모범 사례

**대상 독자**: UI 개발자, 디자이너, 신규 개발자

---

### 3. [Widgets.md](Widgets.md)
**공용 위젯 API 문서**

- **Common**: AppBar, EmptyState, ChipList, ProfileAvatar
- **Buttons**: Primary, Secondary, Tertiary, SocialLogin
- **Cards**: SnsContent, Place, Course
- **Inputs**: SearchBar, TextField
- **Layout**: GradientBackground, SectionHeader, BottomNavigation
- 사용 예시 및 개발 가이드라인

**대상 독자**: UI 개발자, 신규 개발자

---

### 4. [Services.md](Services.md)
**핵심 서비스 API 문서**

- **GoogleAuthService**: Google OAuth 인증
- **FirebaseMessagingService**: FCM 푸시 알림
- **LocalNotificationsService**: 로컬 알림 표시
- **SharingService**: 외부 앱 공유 수신
- **DeviceInfoService**: 디바이스 정보 수집
- **AuthApiService**: 백엔드 인증 API
- 사용 예시 및 모범 사례

**대상 독자**: 백엔드 통합 개발자, 신규 개발자

---

### 5. [Development.md](Development.md)
**개발 환경 설정 및 워크플로우**

- 개발 환경 설정 (Flutter SDK, IDE, 환경 변수)
- 프로젝트 실행 (iOS/Android)
- 개발 워크플로우 (Feature 개발, Provider 작성, 라우팅)
- 코드 스타일 가이드
- 테스트 가이드 (Unit, Widget)
- 디버깅 가이드 (DevTools, 로그 분석)
- 빌드 및 배포 (APK, IPA, App Bundle)
- 문제 해결 (FAQ)

**대상 독자**: 모든 개발자, 신규 팀원

---

## 🚀 빠른 시작 가이드

### 1. 개발 환경 설정

```bash
# 1. 저장소 클론
git clone https://github.com/TEAM-Tripgether/tripgether-flutter.git
cd tripgether-flutter

# 2. 의존성 설치
flutter pub get

# 3. 환경 변수 설정 (.env 파일 생성)
# 자세한 내용은 Development.md 참고

# 4. Riverpod 코드 생성
dart run build_runner build --delete-conflicting-outputs

# 5. 앱 실행
flutter run
```

### 2. 필수 읽기 순서 (신규 개발자)

1. **[Development.md](Development.md)** - 개발 환경 설정
2. **[Architecture.md](Architecture.md)** - 프로젝트 구조 이해
3. **[DesignSystem.md](DesignSystem.md)** - 디자인 시스템 학습
4. **[Widgets.md](Widgets.md)** - 공용 위젯 활용
5. **[Services.md](Services.md)** - 서비스 레이어 이해

### 3. 주요 명령어

```bash
# 개발 서버 실행
flutter run

# Riverpod 코드 생성 (자동 감지)
dart run build_runner watch

# 코드 포맷팅
dart format .

# 코드 분석
flutter analyze

# 테스트 실행
flutter test

# 빌드 (Android)
flutter build apk --release

# 빌드 (iOS)
flutter build ios --release
```

---

## 📁 프로젝트 구조 개요

```
lib/
├── core/                    # 핵심 인프라
│   ├── theme/               # 디자인 시스템 (필수 사용!)
│   ├── router/              # 라우팅 (GoRouter)
│   ├── services/            # 비즈니스 서비스
│   ├── providers/           # 전역 Provider
│   └── utils/               # 유틸리티 함수
├── features/                # 기능별 모듈 (Feature-First)
│   ├── auth/                # 인증
│   ├── onboarding/          # 온보딩
│   ├── home/                # 홈 탭
│   ├── course_market/       # 코스마켓 탭
│   └── ...
├── shared/widgets/          # 공용 위젯 (재사용 필수!)
│   ├── common/              # AppBar, EmptyState, Chip 등
│   ├── buttons/             # Primary, Secondary, Tertiary
│   ├── cards/               # SNS, Place, Course 카드
│   ├── inputs/              # SearchBar, TextField
│   └── layout/              # GradientBackground, SectionHeader
├── l10n/                    # 다국어 (ARB)
└── main.dart                # 앱 진입점
```

---

## 🎯 핵심 원칙

### 1. 디자인 시스템 필수 사용
모든 UI 개발은 `core/theme/` 시스템을 사용해야 합니다.

```dart
// ✅ CORRECT
Container(
  color: AppColors.primary,
  padding: AppSpacing.cardPadding,
  child: Text('제목', style: AppTextStyles.titleLarge),
)

// ❌ WRONG
Container(
  color: Color(0xFF664BAE),
  padding: EdgeInsets.all(16),
  child: Text('제목', style: TextStyle(fontSize: 20)),
)
```

### 2. 공용 위젯 재사용
중복 UI 생성 절대 금지! `shared/widgets/`의 공용 위젯을 재사용하세요.

```dart
// ✅ CORRECT
PrimaryButton(text: '저장', onPressed: _save)

// ❌ WRONG
ElevatedButton(child: Text('저장'), onPressed: _save)
```

### 3. Feature-First 구조
기능별로 독립적인 모듈을 생성합니다.

```
features/auth/
  ├── models/          # User, AuthState
  ├── providers/       # UserNotifier
  ├── services/        # AuthApiService
  └── presentation/    # LoginPage, LoginForm
```

---

## 🛠️ 개발 도구

### IDE 확장 프로그램 (권장)

**VS Code**:
- Flutter
- Dart
- Riverpod Snippets
- Error Lens

**Android Studio**:
- Flutter
- Dart
- Rainbow Brackets

### 유용한 링크
- [Flutter DevTools](https://docs.flutter.dev/tools/devtools)
- [Riverpod 공식 문서](https://riverpod.dev)
- [Material Design 3](https://m3.material.io)
- [Firebase Console](https://console.firebase.google.com)

---

## 📞 문의 및 지원

### GitHub Issues
버그 리포트 및 기능 요청: [GitHub Issues](https://github.com/TEAM-Tripgether/tripgether-flutter/issues)

### 팀 연락처
- 프로젝트 매니저: [PM 이메일]
- 기술 리더: [Tech Lead 이메일]

---

## 📝 문서 업데이트 이력

| 날짜 | 버전 | 변경 내용 |
|------|------|----------|
| 2025-11-10 | 1.0.0 | 초기 문서 작성 (Architecture, DesignSystem, Widgets, Services, Development) |

---

**Last Updated**: 2025-11-10
**Maintained by**: [@EM-H20](https://github.com/EM-H20)
