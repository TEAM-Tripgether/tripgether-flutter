# Google Maps API Key 보안 가이드

## 🔐 개요

Google Maps API 키는 민감한 정보이며, Git 저장소에 노출되면 무단 사용과 예상치 못한 요금이 발생할 수 있습니다.
본 프로젝트는 환경 변수를 통한 안전한 API 키 관리 시스템을 사용합니다.

---

## ✅ 구현된 보안 시스템

### iOS 보안 설정

1. **환경 변수 파일**: `ios/Flutter/GoogleEnv.xcconfig`
   - `.gitignore`에 포함되어 Git 추적 제외
   - Google OAuth URL Scheme과 Maps API Key 저장

2. **Info.plist 설정**:
   ```xml
   <key>GMSApiKey</key>
   <string>$(GOOGLE_MAPS_API_KEY)</string>
   ```
   - 하드코딩 대신 환경 변수 참조 사용

3. **AppDelegate.swift**:
   ```swift
   if let apiKey = Bundle.main.object(forInfoDictionaryKey: "GMSApiKey") as? String {
     GMSServices.provideAPIKey(apiKey)
   }
   ```
   - Info.plist에서 동적으로 API 키 읽기

### Android 보안 설정

1. **환경 변수 파일**: `android/local.properties`
   - `.gitignore`에 포함되어 Git 추적 제외
   - Google OAuth Client ID와 Maps API Key 저장

2. **build.gradle.kts 설정**:
   ```kotlin
   val googleMapsApiKey = localProperties.getProperty("GOOGLE_MAPS_API_KEY") ?: ""
   manifestPlaceholders["GOOGLE_MAPS_API_KEY"] = googleMapsApiKey
   ```

3. **AndroidManifest.xml**:
   ```xml
   <meta-data
       android:name="com.google.android.geo.API_KEY"
       android:value="${GOOGLE_MAPS_API_KEY}"/>
   ```
   - Gradle placeholder를 통한 동적 API 키 주입

---

## 🚀 신규 개발자 설정 가이드

### 1. iOS 환경 변수 설정

```bash
cd ios/Flutter
cp GoogleEnv.xcconfig.template GoogleEnv.xcconfig
```

`GoogleEnv.xcconfig` 파일을 열고 실제 값으로 수정:
```
GOOGLE_URL_SCHEME=com.googleusercontent.apps.YOUR_CLIENT_ID
GOOGLE_MAPS_API_KEY=YOUR_IOS_API_KEY_HERE
```

### 2. Android 환경 변수 설정

```bash
cd android
cp local.properties.template local.properties
```

`local.properties` 파일을 열고 실제 값으로 수정:
```
sdk.dir=/Users/YOUR_USERNAME/Library/Android/sdk
GOOGLE_WEB_CLIENT_ID=YOUR_GOOGLE_WEB_CLIENT_ID
GOOGLE_MAPS_API_KEY=YOUR_ANDROID_API_KEY_HERE
flutter.sdk=/Users/YOUR_USERNAME/Documents/flutter
```

### 3. 빌드 및 실행

```bash
# iOS
cd ios && pod install && cd ..
flutter run

# Android
flutter run
```

---

## 🛡️ Google Cloud Console에서 API 키 제한 설정 (필수!)

환경 변수로 관리하더라도, Google Cloud Console에서 API 키 제한을 반드시 설정해야 합니다.

### 1. Google Cloud Console 접속
- [Google Cloud Console](https://console.cloud.google.com/)
- 프로젝트 선택: Tripgether

### 2. API 키 제한 설정

#### iOS API 키 제한:
1. **API 키** 메뉴 → iOS Maps API Key 선택
2. **Application restrictions**:
   - **iOS apps** 선택
   - Bundle ID 추가: `com.tripgether.alom`
3. **API restrictions**:
   - **Restrict key** 선택
   - **Maps SDK for iOS** 체크
4. **저장**

#### Android API 키 제한:
1. **API 키** 메뉴 → Android Maps API Key 선택
2. **Application restrictions**:
   - **Android apps** 선택
   - SHA-1 certificate fingerprint 추가:
     ```bash
     # Debug 키 확인
     keytool -list -v -keystore ~/.android/debug.keystore -alias androiddebugkey -storepass android -keypass android

     # Release 키 확인 (프로덕션 배포 시)
     keytool -list -v -keystore android/app/keystore/release.jks -alias tripgether
     ```
   - Package name 추가: `com.tripgether.alom`
3. **API restrictions**:
   - **Restrict key** 선택
   - **Maps SDK for Android** 체크
4. **저장**

---

## ⚠️ 주의사항

### 절대 금지 행동:
- ❌ `local.properties`, `GoogleEnv.xcconfig` 파일을 Git에 커밋
- ❌ API 키를 코드에 하드코딩
- ❌ 스크린샷이나 로그에 API 키 노출
- ❌ Public repository에 API 키 포함

### 권장 사항:
- ✅ `.gitignore`에 환경 변수 파일이 포함되어 있는지 확인
- ✅ Google Cloud Console에서 API 키 제한 설정
- ✅ 팀원에게 API 키를 안전한 방법으로 공유 (예: 1Password, Slack DM)
- ✅ 정기적으로 API 키 사용량 모니터링

---

## 🔍 보안 점검 체크리스트

실제 API 키가 노출되지 않았는지 확인:

```bash
# 1. Git 히스토리에 API 키 노출 확인
git log -p | grep -i "AIza"

# 2. 현재 코드에 하드코딩된 API 키 확인
grep -r "AIza" --exclude-dir={.git,build,ios/Pods} .

# 3. .gitignore에 환경 변수 파일 포함 확인
grep -E "local.properties|GoogleEnv.xcconfig" .gitignore
```

**결과**:
- ❌ API 키가 발견되면 즉시 Google Cloud Console에서 키 재발급
- ✅ 발견되지 않으면 안전

---

## 📚 참고 문서

- [Google Maps Platform - API Key Best Practices](https://developers.google.com/maps/api-security-best-practices)
- [Flutter - Platform-specific configuration](https://docs.flutter.dev/deployment/android#reviewing-the-gradle-build-configuration)
- [iOS - Using configuration settings file](https://developer.apple.com/documentation/xcode/adding-a-build-configuration-file-to-your-project)

---

## 🆘 문제 해결

### iOS 빌드 실패: "Google Maps API Key가 Info.plist에 설정되지 않았습니다"
**원인**: `GoogleEnv.xcconfig` 파일이 없거나 API 키가 비어있음
**해결**: 위의 "1. iOS 환경 변수 설정" 참고

### Android 빌드 실패: "Google Maps API key not found"
**원인**: `local.properties`에 `GOOGLE_MAPS_API_KEY`가 없음
**해결**: 위의 "2. Android 환경 변수 설정" 참고

### 지도가 로드되지 않음 (회색 화면)
**원인**: API 키 제한 설정 오류 또는 유효하지 않은 API 키
**해결**: Google Cloud Console에서 API 키 제한 설정 확인

---

**마지막 업데이트**: 2024-11-24
**작성자**: Claude Code (Security Implementation)
