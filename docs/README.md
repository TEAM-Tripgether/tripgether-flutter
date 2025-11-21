# 📚 Tripgether 기술 문서

**최종 업데이트**: 2025-01-20
**프로젝트 버전**: 1.0.0
**Flutter SDK**: 3.24.0+

여행 계획을 함께 만들어가는 협업 플랫폼, **Tripgether**의 기술 문서 허브입니다.

---

## 🎯 빠른 시작 가이드

### 신규 개발자를 위한 읽기 순서

1. **[Development.md](Development.md)** - 개발 환경 설정 및 빌드 가이드
2. **[Architecture.md](Architecture.md)** - 프로젝트 아키텍처와 데이터 흐름 이해
3. **[DesignSystem.md](DesignSystem.md)** - 디자인 시스템과 UI 가이드라인
4. **[Widgets.md](Widgets.md)** - 공용 위젯 컴포넌트 API 문서
5. **[Services.md](Services.md)** - 핵심 서비스 모듈 문서
6. **[BackendAPI.md](BackendAPI.md)** - 백엔드 API 명세서

---

## 📖 문서 구조

### 🏗️ [Architecture.md](Architecture.md)
**프로젝트 아키텍처 및 데이터 흐름**
- Clean Architecture 기반 구조 설계
- Riverpod을 활용한 상태 관리 패턴
- GoRouter 기반 네비게이션 시스템
- 데이터 레이어 및 리포지토리 패턴
- 의존성 주입 및 모듈 구조

### 🎨 [DesignSystem.md](DesignSystem.md)
**디자인 시스템 가이드**
- Material 3 기반 테마 시스템
- 색상 팔레트 (Primary, Status, Social, Gradient)
- 타이포그래피 시스템 (Headline, Title, Body, Label)
- 간격 시스템 (Spacing, Radius, Elevation)
- 반응형 디자인 가이드 (ScreenUtil)

### 🧩 [Widgets.md](Widgets.md)
**공용 위젯 컴포넌트 라이브러리**
- Common 위젯 (AppBar, EmptyState, Chip 등)
- Button 컴포넌트 (Primary, Secondary, Social)
- Card 컴포넌트 (SNS, Place, Course)
- Input 컴포넌트 (SearchBar, TextField)
- Layout 컴포넌트 (GradientBackground, SectionHeader)
- Dialog 컴포넌트 (CommonDialog)

### 🛠️ [Services.md](Services.md)
**핵심 서비스 모듈**
- Google OAuth 인증 서비스
- Firebase Cloud Messaging (FCM)
- 외부 앱 공유 수신 (Share Extension)
- 로컬 알림 서비스
- API 클라이언트 및 에러 핸들링

### 💻 [Development.md](Development.md)
**개발 환경 설정 가이드**
- 개발 환경 요구사항
- Flutter 프로젝트 설정
- iOS/Android 빌드 설정
- 디버깅 및 테스트 가이드
- CI/CD 파이프라인

### 🔌 [BackendAPI.md](BackendAPI.md)
**백엔드 API 명세서**
- 인증 API (소셜 로그인, JWT)
- 회원 관리 API
- 온보딩 API (약관, 프로필, 관심사)
- 콘텐츠 API (SNS 콘텐츠 분석)
- AI 서버 연동 API

### 📱 [SharedContent.md](SharedContent.md)
**공유 콘텐츠 처리 가이드**
- iOS Share Extension 구현
- Android Intent Filter 설정
- 딥링크 처리 로직
- 공유 데이터 파싱 및 검증

---

## 🚀 주요 기능

### 완료된 기능 ✅
- Google OAuth 소셜 로그인
- JWT 기반 인증 시스템
- 온보딩 플로우 (약관 → 이름 → 생년월일 → 성별 → 관심사)
- FCM 푸시 알림 (Android 완료, iOS 설정 중)
- 외부 앱 공유 수신 기능
- 반응형 UI (ScreenUtil)
- 다국어 지원 (한국어, 영어)
- 디자인 시스템 구축
- 공용 다이얼로그 시스템 (CommonDialog)

### 진행 중 🚧
- 백엔드 API 통합
- SNS 콘텐츠 장소 추출 기능
- 여행 계획 협업 기능
- 실시간 동기화
- iOS Push Notification 활성화

---

## 🛡️ 기술 스택

### Frontend
- **Framework**: Flutter 3.24.0+
- **Language**: Dart 3.5.0+
- **State Management**: Riverpod 2.5.1 (@riverpod 어노테이션)
- **Routing**: GoRouter 14.6.2
- **DI**: GetIt 8.0.2

### Backend Integration
- **API Client**: Dio 5.7.0
- **Authentication**: JWT + Secure Storage
- **Push Notification**: Firebase Cloud Messaging
- **Social Login**: Google Sign-In 7.2.0

### UI/UX
- **Design System**: Material 3
- **Responsive**: flutter_screenutil 5.9.3
- **Images**: CachedNetworkImage 3.4.1
- **Loading**: Shimmer 3.0.0
- **Icons**: flutter_svg 2.0.14

### Development Tools
- **Code Generation**: build_runner, freezed
- **Localization**: flutter_localizations
- **Linting**: flutter_lints
- **Testing**: flutter_test, mockito

---

## 📂 프로젝트 구조

```
lib/
├── core/                    # 핵심 모듈
│   ├── theme/              # 디자인 시스템
│   ├── router/             # 라우팅 설정
│   ├── services/           # 글로벌 서비스
│   ├── providers/          # 글로벌 프로바이더
│   └── utils/              # 유틸리티
│
├── features/               # 기능별 모듈
│   ├── auth/              # 인증 기능
│   ├── onboarding/        # 온보딩
│   ├── home/              # 홈 화면
│   ├── mypage/            # 마이페이지
│   ├── map/               # 지도
│   └── course_market/     # 코스 마켓
│
├── shared/                 # 공용 컴포넌트
│   └── widgets/           # 재사용 위젯
│       ├── common/        # 공통 위젯
│       ├── buttons/       # 버튼 컴포넌트
│       ├── cards/         # 카드 컴포넌트
│       ├── inputs/        # 입력 컴포넌트
│       ├── layout/        # 레이아웃 컴포넌트
│       └── dialogs/       # 다이얼로그 컴포넌트
│
└── l10n/                   # 다국어 리소스
```

---

## 🔧 개발 규칙

### 코드 컨벤션
- **명명 규칙**: Dart 공식 가이드라인 준수
- **파일 구조**: Feature-first 구조
- **상태 관리**: Riverpod @riverpod 어노테이션 사용
- **에러 처리**: Result 패턴 또는 Exception 활용

### Git 커밋 규칙
```
브랜치명 : 타입 : 설명 #이슈번호

예시:
온보딩 화면 수정 : fix : 성별 선택 버튼 오류 수정 #45
```

### 디자인 시스템 준수
- 모든 UI는 `core/theme/` 디자인 시스템 사용 필수
- 하드코딩된 색상, 크기, 텍스트 스타일 절대 금지
- 공용 위젯 우선 사용 (`shared/widgets/`)
- fontWeight 직접 설정 금지 (AppTextStyles 사용)

---

## 🚀 빠른 시작

### 1. 개발 환경 설정

```bash
# 1. 저장소 클론
git clone https://github.com/TEAM-Tripgether/tripgether-flutter.git
cd tripgether-flutter

# 2. 의존성 설치
flutter pub get

# 3. Riverpod 코드 생성
dart run build_runner build --delete-conflicting-outputs

# 4. 앱 실행
flutter run
```

### 2. 주요 명령어

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

## 📞 연락처

- **GitHub**: [TEAM-Tripgether/tripgether-flutter](https://github.com/TEAM-Tripgether/tripgether-flutter)
- **API Server**: https://api.tripgether.suhsaechan.kr
- **Swagger UI**: https://api.tripgether.suhsaechan.kr/docs/swagger-ui

---

## 📝 문서 관리

이 문서는 프로젝트 진행에 따라 지속적으로 업데이트됩니다.
문서 관련 문의사항이나 개선 제안은 GitHub Issues를 통해 등록해주세요.

**Version**: 1.0.0