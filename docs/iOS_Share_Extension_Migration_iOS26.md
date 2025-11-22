# iOS Share Extension 마이그레이션 가이드 (iOS 26+)

## 📋 개요

이 문서는 Tripgether iOS Share Extension을 iOS 26+ 표준에 맞게 리팩토링한 내용을 설명합니다.

## 🔄 주요 변경 사항

### 1. **아키텍처 변경**

#### Before (iOS 18 스타일)
```swift
// Legacy: DispatchGroup과 클로저 기반 비동기 처리
let dispatchGroup = DispatchGroup()
for attachment in attachments {
    dispatchGroup.enter()
    processUrlImmediately(attachment: attachment) { success in
        dispatchGroup.leave()
    }
}
dispatchGroup.notify(queue: .main) {
    // 처리 완료
}
```

#### After (iOS 26+ 스타일)
```swift
// Modern: async/await 기반 구조화된 비동기 처리
Task {
    let sharedItems = try await extractSharedItems()
    await MainActor.run {
        saveAndLaunchApp()
    }
}
```

### 2. **NSExtensionContext 데이터 추출**

#### Before
```swift
// Legacy: 직접 loadItem 호출, 타입 문자열 사용
if attachment.hasItemConformingToTypeIdentifier(urlContentType) {
    attachment.loadItem(forTypeIdentifier: urlContentType, options: nil) { data, error in
        // 클로저 콜백
    }
}
```

#### After
```swift
// Modern: UTType 직접 사용, async/await 패턴
if attachment.hasItemConformingToTypeIdentifier(UTType.url.identifier) {
    return try await withCheckedThrowingContinuation { continuation in
        attachment.loadItem(forTypeIdentifier: UTType.url.identifier, options: nil) { data, error in
            if let url = data as? URL {
                continuation.resume(returning: url.absoluteString)
            }
        }
    }
}
```

### 3. **UniformTypeIdentifiers 사용**

#### Before
```swift
// Legacy: 문자열 identifier 저장
let textContentType = UTType.text.identifier
let urlContentType = UTType.url.identifier
```

#### After
```swift
// Modern: UTType 배열 직접 사용 (타입 안전성 향상)
private let supportedTypes: [UTType] = [.url, .plainText, .text]
```

### 4. **Info.plist 최적화**

#### Before
```xml
<!-- 불필요한 미디어 타입 지원 선언 -->
<key>PHSupportedMediaTypes</key>
<array>
    <string>Video</string>
    <string>Image</string>
</array>

<!-- 잘못된 제한 설정 (실제로 처리 안 하지만 활성화됨) -->
<key>NSExtensionActivationSupportsImageWithMaxCount</key>
<integer>100</integer>
```

#### After
```xml
<!-- PHSupportedMediaTypes 완전 제거 -->
<!-- 명확한 activation rule만 사용 -->

<!-- URL과 텍스트만 명시적으로 지원 -->
<key>NSExtensionActivationSupportsText</key>
<true/>
<key>NSExtensionActivationSupportsWebURLWithMaxCount</key>
<integer>1</integer>

<!-- 이미지/비디오는 0으로 설정하여 공유 메뉴에서 제외 -->
<key>NSExtensionActivationSupportsImageWithMaxCount</key>
<integer>0</integer>
```

## 🎯 iOS 26+ 모범 사례

### 1. **UIViewController 기반 커스텀 구현**

- ✅ `UIViewController`를 직접 상속하여 완전한 커스텀 UI/동작 구현
- ❌ `SLComposeServiceViewController` 더 이상 사용 안 함

### 2. **NSExtensionContext inputItems 표준 처리**

```swift
// iOS 26+ 권장 패턴
guard let inputItems = extensionContext?.inputItems as? [NSExtensionItem] else {
    return []
}

for inputItem in inputItems {
    guard let attachments = inputItem.attachments else { continue }

    for attachment in attachments {
        // UTType을 직접 사용한 타입 확인
        if attachment.hasItemConformingToTypeIdentifier(UTType.url.identifier) {
            // async/await로 데이터 추출
        }
    }
}
```

### 3. **App Group 표준 데이터 공유**

```swift
// UserDefaults를 통한 메인 앱과의 데이터 공유
private var appGroupIdentifier: String {
    "group.\(hostAppBundleIdentifier)"
}

private func appGroupUserDefaults() -> UserDefaults? {
    return UserDefaults(suiteName: appGroupIdentifier)
}
```

### 4. **타입 우선순위 처리**

```swift
// iOS 26+ 권장: 명확한 우선순위 순서
// 1순위: URL (웹 링크 공유가 가장 일반적)
// 2순위: PlainText (순수 텍스트)
// 3순위: Text (일반 텍스트)
```

## 📊 성능 개선

### 비동기 처리 최적화

| 항목 | Before (DispatchGroup) | After (async/await) |
|------|----------------------|-------------------|
| 코드 복잡도 | 높음 (중첩 클로저) | 낮음 (선형 흐름) |
| 오류 처리 | 수동 (각 클로저) | 구조화 (try/catch) |
| 메모리 관리 | 수동 (weak self) | 자동 (구조화된 동시성) |
| 가독성 | 낮음 | 높음 |

### 타입 안전성

| Before | After |
|--------|-------|
| 문자열 identifier | UTType 객체 |
| 컴파일 타임 체크 없음 | 컴파일 타임 체크 |
| 오타 가능성 | 타입 안전성 보장 |

## 🔧 마이그레이션 체크리스트

- [x] `UIViewController` 기반 구현 확인
- [x] async/await 패턴 적용
- [x] UTType 직접 사용
- [x] NSExtensionContext inputItems 표준 처리
- [x] Info.plist activation rule 최적화
- [x] PHSupportedMediaTypes 제거
- [x] 이미지/비디오 지원 0으로 설정
- [x] App Group UserDefaults 표준 처리

## 🧪 테스트 가이드

### 1. 공유 메뉴 확인
- Safari에서 웹 페이지 공유 시 Tripgether 표시 확인
- 텍스트 선택 후 공유 시 Tripgether 표시 확인
- **이미지 공유 시 Tripgether가 나타나지 않아야 함** (올바른 동작)

### 2. 데이터 추출 확인
```swift
// 로그 확인 포인트
[ShareExtension] 📦 InputItem 개수: 1
[ShareExtension] 📎 InputItem[0] - Attachment 개수: 1
[ShareExtension] 🔗 URL 타입 감지 (index: 0)
[ShareExtension] ✅ URL 추출 성공: https://example.com
[ShareExtension] 💾 텍스트 데이터 저장
[ShareExtension] UserDefaults 동기화: 성공
```

### 3. 메인 앱 연동 확인
- Share Extension에서 "앱에서 보기" 버튼 클릭
- 메인 앱이 자동으로 실행되는지 확인
- SharingService에서 데이터 수신 확인

## 📝 호환성

| iOS 버전 | 지원 여부 | 비고 |
|---------|----------|------|
| iOS 14+ | ✅ | UniformTypeIdentifiers 최소 요구사항 |
| iOS 15+ | ✅ | async/await 지원 |
| iOS 18+ | ✅ | 기존 패턴 호환 |
| iOS 26+ | ✅ | **최신 표준 완벽 준수** |

## 🔗 참고 자료

- [Apple Developer - NSExtensionContext](https://developer.apple.com/documentation/foundation/nsextensioncontext)
- [Apple Developer - UniformTypeIdentifiers](https://developer.apple.com/documentation/uniformtypeidentifiers)
- [Apple Developer - Share Extensions](https://developer.apple.com/documentation/uikit/share_extensions)

## 📌 추가 개선 사항

### SwiftUI 통합 (선택사항)

iOS 26+에서는 SwiftUI View를 `UIHostingController`로 래핑하여 Share Extension에 사용할 수 있습니다:

```swift
// 향후 SwiftUI 마이그레이션 시 참고
struct ShareExtensionView: View {
    var body: some View {
        // SwiftUI 기반 바텀 시트
    }
}

// UIViewController에서 호스팅
let hostingController = UIHostingController(rootView: ShareExtensionView())
```

## ⚠️ 주의사항

1. **App Group 설정 필수**: Xcode Signing & Capabilities에서 동일한 App Group 활성화 필요
2. **URL Scheme 화이트리스트**: Info.plist에 `LSApplicationQueriesSchemes` 설정 필요
3. **디버그 빌드**: 로그 확인을 위해 `#if DEBUG` 플래그 사용 권장
4. **메모리 관리**: gradientLayer 등 명시적 정리 필수

## 🎉 완료

이제 Tripgether의 iOS Share Extension은 iOS 26+ 표준을 완벽하게 준수하며, 현대적인 Swift 동시성 패턴을 활용한 안전하고 효율적인 구현을 갖추게 되었습니다!
