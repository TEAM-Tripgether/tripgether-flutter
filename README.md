# 🌏 Tripgether

<!-- 수정하지마세요 자동으로 동기화 됩니다 -->
## 최신 버전 : v1.0.8 (2025-10-08)

> 여행의 순간을 공유하고 숏폼 콘텐츠를 통해 현지 장소를 발견하세요.

**Tripgether**는 여행 중 발견한 특별한 순간들을 짧은 영상과 사진으로 공유하고, 다른 여행자들의 추천 장소를 실시간으로 탐색할 수 있는 모바일 애플리케이션입니다.

---

## 📱 주요 기능

- ✅ **Google 소셜 로그인** - 간편한 계정 생성 및 로그인
- 🎬 **SNS 콘텐츠 공유** - 여행 순간을 짧은 영상/사진으로 공유
- 📍 **장소 저장 및 추천** - 마음에 드는 여행지 북마크
- 🗺️ **지도 기반 탐색** - 주변 여행 콘텐츠 실시간 발견
- 🌐 **다국어 지원** - 한국어/영어 지원

---

## 🛠️ 기술 스택

### Frontend (Mobile)
- **Framework**: Flutter 3.27.2
- **Language**: Dart 3.6.1
- **State Management**: Riverpod 2.x (@riverpod 어노테이션)
- **Routing**: GoRouter 14.x
- **Network**: Dio + Retrofit
- **Authentication**: Google Sign-In 7.2.0
- **UI/UX**:
  - ScreenUtil (반응형 UI)
  - Shimmer (스켈레톤 로딩)
  - CachedNetworkImage (이미지 캐싱)
  - Lottie + Flutter Animate (애니메이션)

### Backend (추후 구현)
- **API**: REST API with FastAPI (Python) or Express (Node.js)
- **Authentication**: JWT + Google OAuth 2.0
- **Database**: PostgreSQL or MongoDB

### DevOps
- **CI/CD**: GitHub Actions (예정)
- **Deployment**: Firebase Hosting (예정)

---

## 🚀 시작하기

### 필수 요구사항

- Flutter SDK: `>=3.27.0`
- Dart SDK: `>=3.6.0`
- Android Studio / Xcode (플랫폼별)
- Google Cloud Console 계정 (OAuth 설정용)

### 1️⃣ 저장소 클론

```bash
git clone https://github.com/your-username/tripgether.git
cd tripgether
```

### 2️⃣ 의존성 설치

```bash
flutter pub get
```

### 3️⃣ 환경 변수 설정

#### Google OAuth 설정

1. [Google Cloud Console](https://console.cloud.google.com/apis/credentials) 접속
2. 새 프로젝트 생성 또는 기존 프로젝트 선택
3. **APIs & Services** → **Credentials** 이동
4. OAuth 2.0 Client IDs 생성:
   - **iOS Application** (iOS용)
   - **Web Application** (Android serverClientId용)

#### .env 파일 생성

```bash
cp .env.example .env
```

`.env` 파일을 열고 Google Cloud Console에서 발급받은 값으로 교체:

```bash
# iOS Client ID

<!-- 수정하지마세요 자동으로 동기화 됩니다 -->
## 최신 버전 : v1.0.8 (2025-10-08)
GOOGLE_IOS_CLIENT_ID=123456789-xxxxxxxxxxxxx.apps.googleusercontent.com

# Web Client ID (Android용)

<!-- 수정하지마세요 자동으로 동기화 됩니다 -->
## 최신 버전 : v1.0.8 (2025-10-08)
GOOGLE_WEB_CLIENT_ID=123456789-xxxxxxxxxxxxx.apps.googleusercontent.com

# Web Client Secret (백엔드 개발자 참고용)

<!-- 수정하지마세요 자동으로 동기화 됩니다 -->
## 최신 버전 : v1.0.8 (2025-10-08)
GOOGLE_WEB_CLIENT_SECRET=GOCSPX-xxxxxxxxxxxxxx
```

### 4️⃣ 플랫폼별 설정

#### iOS 설정

`ios/Runner/Info.plist`에 URL Scheme 추가:

```xml
<key>CFBundleURLTypes</key>
<array>
  <dict>
    <key>CFBundleURLSchemes</key>
    <array>
      <string>com.googleusercontent.apps.123456789-xxxxx</string>
    </array>
  </dict>
</array>
```

#### Android 설정

`android/app/google-services.json` 파일이 이미 포함되어 있습니다.

### 5️⃣ 앱 실행

```bash
# iOS

<!-- 수정하지마세요 자동으로 동기화 됩니다 -->
## 최신 버전 : v1.0.8 (2025-10-08)
flutter run -d ios

# Android

<!-- 수정하지마세요 자동으로 동기화 됩니다 -->
## 최신 버전 : v1.0.8 (2025-10-08)
flutter run -d android

# 또는 디바이스 자동 선택

<!-- 수정하지마세요 자동으로 동기화 됩니다 -->
## 최신 버전 : v1.0.8 (2025-10-08)
flutter run
```

---

## 📂 프로젝트 구조

```
lib/
├── core/                       # 핵심 기능
│   ├── router/                 # 라우팅 설정
│   │   └── routes.dart         # 중앙화된 라우트 상수
│   └── services/               # 공통 서비스
│       └── auth/               # 인증 서비스
│           └── google_auth_service.dart
│
├── features/                   # 기능별 모듈
│   ├── auth/                   # 인증 기능
│   │   ├── presentation/
│   │   │   └── screens/
│   │   │       └── login_screen.dart
│   │   └── providers/
│   │       └── login_provider.dart
│   │
│   └── home/                   # 홈 화면
│       └── presentation/
│           └── screens/
│               └── home_screen.dart
│
├── shared/                     # 공유 위젯/유틸리티
│   └── widgets/
│
├── l10n/                       # 다국어 지원
│   ├── app_ko.arb              # 한국어
│   └── app_en.arb              # 영어
│
└── main.dart                   # 앱 진입점
```

---

## 🔑 주요 명령어

### 개발

```bash
# 앱 실행 (개발 모드)

<!-- 수정하지마세요 자동으로 동기화 됩니다 -->
## 최신 버전 : v1.0.8 (2025-10-08)
flutter run

# Hot Reload (앱 실행 중 'r' 키)

<!-- 수정하지마세요 자동으로 동기화 됩니다 -->
## 최신 버전 : v1.0.8 (2025-10-08)
r

# Hot Restart (앱 실행 중 'R' 키)

<!-- 수정하지마세요 자동으로 동기화 됩니다 -->
## 최신 버전 : v1.0.8 (2025-10-08)
R

# 코드 생성 (Riverpod providers)

<!-- 수정하지마세요 자동으로 동기화 됩니다 -->
## 최신 버전 : v1.0.8 (2025-10-08)
dart run build_runner build

# 코드 생성 (Watch 모드 - 파일 변경 시 자동 생성)

<!-- 수정하지마세요 자동으로 동기화 됩니다 -->
## 최신 버전 : v1.0.8 (2025-10-08)
dart run build_runner watch

# 코드 분석

<!-- 수정하지마세요 자동으로 동기화 됩니다 -->
## 최신 버전 : v1.0.8 (2025-10-08)
flutter analyze

# 코드 포맷

<!-- 수정하지마세요 자동으로 동기화 됩니다 -->
## 최신 버전 : v1.0.8 (2025-10-08)
dart format .
```

### 빌드

```bash
# Android APK

<!-- 수정하지마세요 자동으로 동기화 됩니다 -->
## 최신 버전 : v1.0.8 (2025-10-08)
flutter build apk

# Android App Bundle (Google Play 배포용)

<!-- 수정하지마세요 자동으로 동기화 됩니다 -->
## 최신 버전 : v1.0.8 (2025-10-08)
flutter build appbundle

# iOS (Mac 전용)

<!-- 수정하지마세요 자동으로 동기화 됩니다 -->
## 최신 버전 : v1.0.8 (2025-10-08)
flutter build ios
```

### 테스트

```bash
# 모든 테스트 실행

<!-- 수정하지마세요 자동으로 동기화 됩니다 -->
## 최신 버전 : v1.0.8 (2025-10-08)
flutter test

# 특정 테스트 파일 실행

<!-- 수정하지마세요 자동으로 동기화 됩니다 -->
## 최신 버전 : v1.0.8 (2025-10-08)
flutter test test/widget_test.dart

# 커버리지 포함

<!-- 수정하지마세요 자동으로 동기화 됩니다 -->
## 최신 버전 : v1.0.8 (2025-10-08)
flutter test --coverage
```

### 클린 빌드

```bash
# 빌드 캐시 정리

<!-- 수정하지마세요 자동으로 동기화 됩니다 -->
## 최신 버전 : v1.0.8 (2025-10-08)
flutter clean

# 의존성 재설치

<!-- 수정하지마세요 자동으로 동기화 됩니다 -->
## 최신 버전 : v1.0.8 (2025-10-08)
flutter pub get

# 완전 재빌드

<!-- 수정하지마세요 자동으로 동기화 됩니다 -->
## 최신 버전 : v1.0.8 (2025-10-08)
flutter clean && flutter pub get && flutter run
```

---

## 🔐 보안 주의사항

### ⚠️ 절대 커밋하지 말 것

- `.env` 파일 (실제 API 키 포함)
- `google-services.json` (Firebase 설정)
- `GoogleService-Info.plist` (iOS Firebase 설정)

### ✅ .gitignore 확인

다음 파일들이 `.gitignore`에 포함되어 있는지 확인:

```
.env
*.env
google-services.json
GoogleService-Info.plist
```

### 🔒 환경변수 관리

- **개발 환경**: `.env` 파일 사용
- **프로덕션**: 환경변수 또는 CI/CD Secret 사용
- **백엔드 Secret**: 절대 앱 코드에 포함 금지

---

## 📚 API 명세서

백엔드 개발자를 위한 API 명세서는 [`claudedocs/api_specification.md`](claudedocs/api_specification.md)를 참고하세요.

### 주요 엔드포인트

| 메서드 | 엔드포인트 | 설명 |
|--------|-----------|------|
| POST | `/auth/google/login` | Google OAuth 로그인 |
| POST | `/users/profile` | 온보딩 완료 (신규 사용자) |

---

## 🤝 기여하기

### 브랜치 전략

- `main`: 프로덕션 배포 브랜치
- `develop`: 개발 통합 브랜치
- `feature/*`: 기능 개발 브랜치
- `bugfix/*`: 버그 수정 브랜치

### 커밋 메시지 규칙

```
feat: 새로운 기능 추가
fix: 버그 수정
docs: 문서 수정
style: 코드 포맷팅, 세미콜론 누락 등
refactor: 코드 리팩토링
test: 테스트 추가/수정
chore: 빌드 프로세스 또는 보조 도구 변경
```

예시:
```bash
git commit -m "feat: Google 로그인 기능 추가"
git commit -m "fix: Android 로그인 시 serverClientId 누락 오류 수정"
```

---

## 🐛 트러블슈팅

### Google 로그인 실패 (Android)

**에러**: `serverClientId must be provided on Android`

**해결**:
1. `.env` 파일에 `GOOGLE_WEB_CLIENT_ID` 설정 확인
2. `google-services.json` 파일 존재 여부 확인
3. 앱 완전 재시작 (`flutter run`)

### 코드 생성 오류

**에러**: `build_runner` 실행 시 오류

**해결**:
```bash
dart run build_runner clean
dart run build_runner build --delete-conflicting-outputs
```

### Hot Reload 실패

**해결**:
```bash
# Hot Restart 시도 (앱 실행 중 'R' 키)

<!-- 수정하지마세요 자동으로 동기화 됩니다 -->
## 최신 버전 : v1.0.8 (2025-10-08)
# 또는 앱 완전 재시작

<!-- 수정하지마세요 자동으로 동기화 됩니다 -->
## 최신 버전 : v1.0.8 (2025-10-08)
flutter run
```

---

