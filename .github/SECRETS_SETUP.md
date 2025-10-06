# GitHub Actions Secrets 설정 가이드

CI 워크플로우를 실행하기 위해 필요한 GitHub Secrets 설정 방법입니다.

**참고**: 현재 프로젝트는 CI(자동 테스트)만 사용하며, CD(배포)는 수동으로 진행합니다.

## 설정 위치

Repository Settings → Secrets and variables → Actions → New repository secret

---

## 🔐 CI 테스트용 Secrets (선택사항)

현재 CI 워크플로우는 **더미 환경 변수**로 실행되므로, 실제 Google OAuth Secrets 설정은 **선택사항**입니다.

### 1. GOOGLE_IOS_CLIENT_ID (선택)
- **설명**: Google OAuth iOS 클라이언트 ID
- **예시**: `123456789-xxxxxxxxxxxxxxxxxxxxx.apps.googleusercontent.com`
- **가져오는 방법**:
  1. Google Cloud Console (https://console.cloud.google.com)
  2. APIs & Services → Credentials
  3. OAuth 2.0 Client IDs에서 **iOS 클라이언트 ID** 복사
- **참고**: CI 테스트에서는 더미 값으로 빌드되므로 실제 값은 필요 없음

### 2. GOOGLE_WEB_CLIENT_ID (선택)
- **설명**: Google OAuth 웹 클라이언트 ID (Android serverClientId 용)
- **예시**: `123456789-xxxxxxxxxxxxxxxxxxxxx.apps.googleusercontent.com`
- **가져오는 방법**:
  1. Google Cloud Console → APIs & Services → Credentials
  2. OAuth 2.0 Client IDs에서 **Web 클라이언트 ID** 복사
- **참고**: CI 테스트에서는 더미 값으로 빌드되므로 실제 값은 필요 없음

### 3. GOOGLE_WEB_CLIENT_SECRET (선택)
- **설명**: Google OAuth 웹 클라이언트 Secret
- **예시**: `GOCSPX-xxxxxxxxxxxxxxxxxxxxxx`
- **가져오는 방법**:
  1. Google Cloud Console → APIs & Services → Credentials
  2. Web Client 선택 → Client Secret 복사
- **참고**: 현재 ID Token 방식이므로 미사용. CI에도 불필요

---

## 📊 코드 커버리지 (선택사항)

### 4. CODECOV_TOKEN (선택)
- **설명**: Codecov 업로드 토큰 (코드 커버리지 추적 시)
- **가져오는 방법**: Codecov.io → Repository Settings → General → Repository Upload Token
- **참고**: 코드 커버리지를 Codecov에 업로드하려는 경우에만 필요

---

## ✅ Secrets 설정 체크리스트

### CI 테스트용 (모두 선택사항)
- [ ] `GOOGLE_IOS_CLIENT_ID` (선택 - 더미 값으로 대체 가능)
- [ ] `GOOGLE_WEB_CLIENT_ID` (선택 - 더미 값으로 대체 가능)
- [ ] `GOOGLE_WEB_CLIENT_SECRET` (선택 - 미사용)
- [ ] `CODECOV_TOKEN` (선택 - 코드 커버리지 추적 시)

---

## 🚀 워크플로우 사용 방법

### 1. CI 워크플로우 (자동 실행)
- **트리거**: PR 생성 또는 main/develop 브랜치에 push
- **동작**: 코드 분석 + 테스트 실행
- **Secrets**: 불필요 (더미 환경 변수 사용)

```bash
# PR 생성 또는 push 시 자동 실행
git push origin main
```

### 2. 빌드 테스트 워크플로우 (수동 실행)
- **트리거**: 수동 (GitHub Actions 탭에서 실행)
- **동작**: Android APK 또는 iOS 빌드 테스트
- **Secrets**: 불필요 (더미 환경 변수 사용)

**실행 방법**:
1. GitHub Repository → Actions 탭
2. "Build Test" 워크플로우 선택
3. "Run workflow" 클릭
4. 플랫폼 선택 (android / ios / both)

---

## 💡 배포(CD)는 어떻게 하나요?

현재 프로젝트는 **수동 배포 방식**을 사용합니다.

### Android APK 배포
```bash
# 로컬에서 직접 빌드
flutter build apk --release

# 빌드된 APK 위치
# build/app/outputs/flutter-apk/app-release.apk
```

### Android AAB 배포 (Google Play)
```bash
# AAB 빌드
flutter build appbundle --release

# 빌드된 AAB 위치
# build/app/outputs/bundle/release/app-release.aab

# Google Play Console에서 수동 업로드
```

### iOS IPA 배포
```bash
# Xcode에서 Archive 생성 후 배포
# 또는 로컬에서 빌드
flutter build ios --release

# Xcode에서 Product → Archive → Distribute App
```

---

## 🔍 참고사항

### CI 워크플로우에서 사용하는 더미 환경 변수

```bash
GOOGLE_IOS_CLIENT_ID=test-ios-client.apps.googleusercontent.com
GOOGLE_WEB_CLIENT_ID=test-web-client.apps.googleusercontent.com
GOOGLE_WEB_CLIENT_SECRET=GOCSPX-test-secret
```

이 더미 값들은 **빌드 테스트 목적**으로만 사용되며, 실제 Google OAuth 기능은 동작하지 않습니다.

### 실제 배포 시 필요한 환경 변수

로컬에서 빌드할 때는 프로젝트 루트의 `.env` 파일에 실제 값을 설정해야 합니다:

```bash
# .env 파일 예시
GOOGLE_IOS_CLIENT_ID=실제-ios-client-id.apps.googleusercontent.com
GOOGLE_WEB_CLIENT_ID=실제-web-client-id.apps.googleusercontent.com
GOOGLE_WEB_CLIENT_SECRET=GOCSPX-실제-client-secret
```

---

## ⚠️ 보안 주의사항

1. **절대 `.env` 파일을 Git에 커밋하지 마세요** (`.gitignore`에 이미 포함됨)
2. **실제 Google OAuth 키는 안전하게 보관하세요**
3. **GitHub Secrets는 선택사항**이지만, 설정하면 CI에서 실제 환경과 동일하게 테스트 가능
