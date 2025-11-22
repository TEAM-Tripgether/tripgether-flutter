# Share Extension 실제 디바이스 문제 해결 가이드

## 🔴 핵심 문제: 실제 디바이스에서 Extension이 안 나타남

### 1단계: Xcode 프로젝트 설정 검증 ✅

**확인된 정상 설정**:
- ✅ Bundle Identifier: `com.tripgether.alom.Share-Extension`
- ✅ App Group: `group.com.tripgether.alom`
- ✅ Embed Extension 설정됨
- ✅ CODE_SIGN_ENTITLEMENTS 설정됨

### 2단계: 실제 디바이스 체크리스트

#### ⚠️ 필수 확인 사항

**A. Apple Developer 계정 설정 (가장 일반적 원인)**
```
1. Apple Developer → Certificates, Identifiers & Profiles
2. Identifiers → App IDs 확인
   - Main App: com.tripgether.alom (Capabilities: App Groups ✓)
   - Extension: com.tripgether.alom.Share-Extension (Capabilities: App Groups ✓)
3. App Groups 확인
   - group.com.tripgether.alom이 두 App ID에 모두 활성화되어 있어야 함
```

**B. Xcode Signing & Capabilities**
```
1. Runner 타겟 선택
   → Signing & Capabilities
   → App Groups: group.com.tripgether.alom 체크 ✓

2. Share Extension 타겟 선택
   → Signing & Capabilities
   → App Groups: group.com.tripgether.alom 체크 ✓
   → Team 설정 (Runner와 동일해야 함)
```

**C. 빌드 설정 확인**
```bash
# Xcode에서 확인
1. Product → Scheme → Edit Scheme
2. Build → Targets 확인
   - Runner ✓
   - Share Extension ✓ (체크되어 있어야 함!)
```

**D. 실제 디바이스 클린 빌드**
```bash
# 터미널에서 실행
cd /Users/luca/workspace/Flutter_Project/tripgether/ios
rm -rf build/
rm -rf ~/Library/Developer/Xcode/DerivedData/Runner-*

# Xcode에서
Product → Clean Build Folder (⌘⇧K)
Product → Build (⌘B)
```

**E. 프로비저닝 프로파일 검증**
```
1. Xcode → Preferences → Accounts
2. Apple ID 선택 → Manage Certificates
3. Download Manual Profiles (또는 Automatic Signing으로 변경)

4. Runner 타겟:
   Signing & Capabilities → Signing Certificate 확인

5. Share Extension 타겟:
   Signing & Capabilities → Signing Certificate 확인
   (Runner와 동일한 Team/Certificate 사용해야 함)
```

### 3단계: iOS 시스템 캐시 문제

**실제 디바이스에서만 발생하는 캐시 이슈**:
```
1. iPhone 설정 → 일반 → iPhone 저장 공간
2. Tripgether 앱 찾기 → 앱 삭제
3. iPhone 재부팅
4. Xcode에서 재빌드 및 설치
```

### 4단계: Info.plist 검증

**Share Extension/Info.plist 필수 설정**:
```xml
<!-- NSExtensionPrincipalClass -->
<key>NSExtension</key>
<dict>
    <key>NSExtensionPrincipalClass</key>
    <string>ShareViewController</string>  <!-- ✅ 모듈명 제거됨 -->

    <key>NSExtensionPointIdentifier</key>
    <string>com.apple.share-services</string>

    <key>NSExtensionAttributes</key>
    <dict>
        <key>NSExtensionActivationRule</key>
        <dict>
            <key>NSExtensionActivationSupportsText</key>
            <true/>
            <key>NSExtensionActivationSupportsWebURLWithMaxCount</key>
            <integer>1</integer>
            <key>NSExtensionActivationSupportsImageWithMaxCount</key>
            <integer>100</integer>
            <key>NSExtensionActivationSupportsMovieWithMaxCount</key>
            <integer>100</integer>
        </dict>
    </dict>
</dict>
```

### 5단계: 디버깅 방법

**Extension이 빌드되었는지 확인**:
```bash
# 빌드된 앱 확인
cd /Users/luca/Library/Developer/Xcode/DerivedData
find . -name "Share Extension.appex"

# 있으면 Extension이 빌드됨
# 없으면 Build Settings 문제
```

**실제 디바이스 로그 확인**:
```
1. Xcode → Window → Devices and Simulators
2. 실제 디바이스 선택
3. Open Console
4. 필터: "ShareExtension"
5. Safari에서 공유 버튼 누르기
6. 로그 확인
```

### 6단계: 실제 디바이스 테스트 절차

```
1. ✅ 앱 완전 삭제 (iPhone 설정에서)
2. ✅ iPhone 재부팅
3. ✅ Xcode Clean Build (⌘⇧K)
4. ✅ Xcode Build & Run (⌘R)
5. ✅ Safari 열기 → 아무 페이지
6. ✅ 공유 버튼 (네모+화살표) 탭
7. ✅ 하단 스크롤하여 "Tripgether" 아이콘 확인
   - 있음: 정상! ✓
   - 없음: "작업" → "Tripgether" 활성화 (토글 ON)
```

### 7단계: 최종 체크리스트

- [ ] Apple Developer 계정에서 App Group 활성화 (Main + Extension)
- [ ] Xcode Signing & Capabilities에서 App Group 체크
- [ ] Build Scheme에서 Share Extension 타겟 활성화
- [ ] 프로비저닝 프로파일 최신 상태
- [ ] 실제 디바이스 앱 삭제 → 재부팅 → 재설치
- [ ] Safari 공유 메뉴에서 "작업" → "Tripgether" 활성화

## 🔧 일반적 오류와 해결

### 오류 1: "Share Extension이 공유 메뉴에 안 나타남"
**원인**: iOS 시스템 캐시
**해결**:
```
1. 앱 삭제
2. iPhone 재부팅
3. 재설치
4. Safari → 공유 → "작업" → "Tripgether" 활성화
```

### 오류 2: "Extension 클릭 시 크래시"
**원인**: App Group 불일치
**해결**:
```
ShareViewController.swift:24
let hostAppBundleIdentifier = "com.tripgether.alom"

Runner.entitlements:
group.com.tripgether.alom

Share Extension.entitlements:
group.com.tripgether.alom

세 곳 모두 동일해야 함!
```

### 오류 3: "Xcode 빌드는 되는데 실제 디바이스에서 안 됨"
**원인**: Provisioning Profile 문제
**해결**:
```
1. Xcode → Preferences → Accounts → Download Manual Profiles
2. 또는 Automatic Signing으로 변경
3. Clean Build → 재빌드
```

## 📱 실제 디바이스 전용 이슈

### viewDidAppear 강제 레이아웃
```swift
// ShareViewController.swift:111-130
override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)

    // 🔧 TestFlight/실제 디바이스 이슈 해결
    view.setNeedsLayout()
    view.layoutIfNeeded()

    view.subviews.forEach { subview in
        subview.isHidden = false
        subview.alpha = 1.0
        subview.setNeedsLayout()
        subview.layoutIfNeeded()
    }
}
```

이 코드가 **시뮬레이터에서는 불필요하지만 실제 디바이스에서는 필수**인 이유:
- 시뮬레이터: 느슨한 검증, 메모리 충분
- 실제 디바이스: 엄격한 검증, 메모리 제한, OS 최적화

## 🎯 최우선 조치 사항

**지금 당장 확인해야 할 3가지**:

1️⃣ **Xcode → Scheme → Edit Scheme → Build**
   - Share Extension 타겟이 체크되어 있는지 확인

2️⃣ **iPhone 설정 → Tripgether 삭제 → 재부팅 → 재설치**
   - iOS 시스템 캐시 완전 초기화

3️⃣ **Apple Developer Portal**
   - App IDs 두 개 모두 App Groups 활성화 확인
   - `group.com.tripgether.alom` 등록 확인

---

**참고**: Share Extension이 실제 디바이스에서 안 나타나는 경우 **90%는 Apple Developer 계정 설정 문제**이고, **10%는 iOS 시스템 캐시 문제**입니다.
