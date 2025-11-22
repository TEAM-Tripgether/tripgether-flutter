# iOS Share Extension 로컬 알림 가이드

## 📱 개요

iOS Share Extension에서 콘텐츠를 공유할 때 사용자에게 즉각적인 피드백을 제공하기 위한 로컬 알림 시스템입니다.

## 🏗️ 아키텍처

### 데이터 흐름

```
외부 앱 (Safari, 메모 등)
    ↓
Share Extension (ShareViewController)
    ↓
UserDefaults (App Group 공유)
    ↓
로컬 알림 발송 (UserNotifications)
    ↓
사용자 알림 수신
    ↓ (알림 탭 시)
Main App 실행 (AppDelegate)
    ↓
SharingService에서 데이터 로드
```

## 🔧 구현 상세

### 1. ShareViewController.swift

**위치**: `ios/Share Extension/ShareViewController.swift`

**핵심 메서드**:

```swift
/// 로컬 알림 발송 (공유 완료 시 사용자에게 즉각 피드백)
private func sendLocalNotification() {
    // 알림 콘텐츠 구성
    let content = UNMutableNotificationContent()
    content.title = "트립게더에 저장됨"
    content.body = "공유된 콘텐츠를 확인하세요"
    content.sound = .default
    content.badge = 1

    // 즉시 발송 (0.1초 후 트리거)
    let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 0.1, repeats: false)

    // 알림 요청 생성 (identifier는 AppDelegate의 탭 핸들러와 매칭)
    let request = UNNotificationRequest(
        identifier: "share_completed",
        content: content,
        trigger: trigger
    )

    // 알림 스케줄링
    UNUserNotificationCenter.current().add(request) { error in
        if let error = error {
            print("[ShareExtension] ❌ 알림 발송 실패: \(error)")
        } else {
            print("[ShareExtension] ✅ 로컬 알림 발송 성공 (identifier: share_completed)")
        }
    }
}
```

**호출 시점**:

```swift
private func saveAndLaunchApp() {
    // ... UserDefaults 저장 로직 ...

    let syncSuccess = userDefaults.synchronize()

    if syncSuccess {
        // 데이터 저장 성공 즉시 알림 발송
        sendLocalNotification()  // ← 여기서 호출

        // 바텀 시트 UI 표시
        showSuccessAndDismiss()
    }
}
```

### 2. AppDelegate.swift

**위치**: `ios/Runner/AppDelegate.swift`

**알림 권한 요청** (앱 시작 시 자동):

```swift
override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
) -> Bool {
    // ... 다른 초기화 ...

    // 알림 권한 요청 (Share Extension에서 알림을 발송하기 위해 필요)
    requestNotificationPermission()

    // 알림 델리게이트 설정
    if #available(iOS 10.0, *) {
        UNUserNotificationCenter.current().delegate = self
    }

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
}

private func requestNotificationPermission() {
    UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
        if let error = error {
            print("[AppDelegate] ❌ 알림 권한 요청 실패: \(error)")
        } else if granted {
            print("[AppDelegate] ✅ 알림 권한 허용됨")
        } else {
            print("[AppDelegate] ⚠️ 알림 권한 거부됨 - Share Extension에서 알림을 발송할 수 없습니다")
        }
    }
}
```

**알림 탭 처리**:

```swift
override func userNotificationCenter(
    _ center: UNUserNotificationCenter,
    didReceive response: UNNotificationResponse,
    withCompletionHandler completionHandler: @escaping () -> Void
) {
    let identifier = response.notification.request.identifier
    print("[AppDelegate] 🔔 알림 탭됨: \(identifier)")

    // Share Extension에서 발송한 알림인지 확인
    if identifier == "share_completed" {
        print("[AppDelegate] 🚀 공유 완료 알림 탭 - 앱이 실행되었습니다")
        print("[AppDelegate] 💡 공유 데이터는 HomeScreen의 라이프사이클 리스너에서 자동으로 로드됩니다")
    }

    completionHandler()
}
```

**포그라운드에서도 알림 표시**:

```swift
override func userNotificationCenter(
    _ center: UNUserNotificationCenter,
    willPresent notification: UNNotification,
    withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
) {
    print("[AppDelegate] 🔔 포그라운드 알림 수신: \(notification.request.identifier)")

    // 앱이 실행 중이어도 배너, 사운드, 뱃지 표시
    completionHandler([.banner, .sound, .badge])
}
```

## 📋 사용자 시나리오

### 시나리오 1: 앱이 백그라운드에 있을 때

1. **외부 앱에서 공유**: Safari에서 웹페이지 → "공유" → "Tripgether" 선택
2. **Share Extension 실행**: 바텀 시트 UI 표시, 데이터 저장
3. **로컬 알림 발송**: "트립게더에 저장됨" 알림이 0.1초 후 발송
4. **사용자가 알림 탭**:
   - 메인 앱이 포그라운드로 전환
   - AppDelegate의 `didReceive` 메서드 호출
   - SharingService가 공유 데이터 자동 로드 (라이프사이클 리스너)

### 시나리오 2: 앱이 이미 실행 중일 때

1. **외부 앱에서 공유**: 동일
2. **Share Extension 실행**: 동일
3. **로컬 알림 발송**: 동일
4. **앱 내에서 알림 배너 표시**:
   - 앱 상단에 알림 배너 표시 (포그라운드 presentation)
   - 사용자가 배너를 탭하면 알림 탭 핸들러 실행
   - 또는 무시하고 나중에 알림 센터에서 확인 가능

### 시나리오 3: "앱에서 보기" 버튼 사용

1. **외부 앱에서 공유**: 동일
2. **Share Extension 실행**: 바텀 시트 표시
3. **사용자가 "앱에서 보기" 버튼 탭**:
   - URL Scheme 호출 (`tripgether://share`)
   - 메인 앱 즉시 실행
   - 로컬 알림도 발송되지만 사용자는 이미 앱 내부에 있음
   - 5초 자동 닫기 타이머 취소

## 🔑 핵심 포인트

### 1. 알림 Identifier 통일

- **Share Extension**: `identifier: "share_completed"`
- **AppDelegate**: `if identifier == "share_completed"`
- 두 곳에서 동일한 identifier를 사용하여 알림 탭 시 올바른 핸들러 실행

### 2. 알림 권한 공유

- App Group을 통해 메인 앱과 Share Extension이 권한 공유
- 메인 앱에서 한 번만 권한 요청하면 Share Extension에서도 알림 발송 가능
- Share Extension 자체에서 권한 요청 불필요 (메인 앱에서 이미 처리)

### 3. 타이밍 최적화

- **즉시 발송**: `timeInterval: 0.1` (0.1초 후)
- 너무 빠르면 Extension이 닫히기 전에 발송되어 사용자가 못 볼 수 있음
- 너무 느리면 사용자 피드백이 지연됨
- 0.1초는 최적의 타이밍

### 4. 포그라운드 Presentation

```swift
completionHandler([.banner, .sound, .badge])
```

- `.banner`: 앱 상단에 배너 표시
- `.sound`: 알림 사운드 재생
- `.badge`: 앱 아이콘 배지 표시

## 🧪 테스트 가이드

### 1. 기본 테스트

```bash
# iOS 시뮬레이터 실행
flutter run -d "iPhone 17 Pro"

# 1. 앱 백그라운드로 전환 (Cmd+Shift+H)
# 2. Safari 열기 → 웹페이지 이동
# 3. 공유 버튼 → "Tripgether" 선택
# 4. 0.1초 후 알림 확인 (화면 상단)
# 5. 알림 탭 → 메인 앱 실행 확인
```

### 2. 포그라운드 테스트

```bash
# 1. 앱 실행 상태 유지
# 2. Safari로 전환 → 웹페이지 공유
# 3. 트립게더 앱으로 자동 복귀
# 4. 앱 내부에서 알림 배너 표시 확인
```

### 3. 권한 테스트

```bash
# 1. 앱 삭제 (권한 초기화)
# 2. 앱 재설치 및 실행
# 3. 알림 권한 허용/거부 선택
# 4. 공유 테스트
#    - 허용: 알림 정상 발송
#    - 거부: 콘솔에 경고 메시지만 표시, 앱은 정상 동작
```

### 4. 로그 확인

**Xcode Console**:

```
[AppDelegate] ✅ 알림 권한 허용됨
[ShareExtension] 🚀 iOS 26+ 현대적인 Share Extension 시작
[ShareExtension] ✅ URL 추출 성공: https://example.com
[ShareExtension] 💾 텍스트 데이터 저장: https://exa***om.com
[ShareExtension] UserDefaults 동기화: 성공
[ShareExtension] ✅ 로컬 알림 발송 성공 (identifier: share_completed)
[ShareExtension] ⏰ 자동 닫기 타이머 시작 (5.0초)
[AppDelegate] 🔔 포그라운드 알림 수신: share_completed
[AppDelegate] 🔔 알림 탭됨: share_completed
[AppDelegate] 🚀 공유 완료 알림 탭 - 앱이 실행되었습니다
```

## ⚠️ 주의사항

### 1. 시뮬레이터 제한

- iOS 시뮬레이터에서는 알림 배너가 표시되지 않을 수 있음
- 실제 디바이스에서 테스트 권장

### 2. 알림 권한 거부 시

- Share Extension 자체는 정상 동작 (데이터 저장, URL Scheme)
- 알림만 발송되지 않음
- 사용자는 "앱에서 보기" 버튼으로 앱 실행 가능

### 3. 배지 관리

```swift
content.badge = 1
```

- 알림 발송 시 배지 카운트 증가
- 앱에서 배지 초기화 필요:

```swift
// AppDelegate 또는 HomeScreen에서
UIApplication.shared.applicationIconBadgeNumber = 0
```

### 4. 중복 알림 방지

- Share Extension이 여러 번 실행되면 알림도 여러 번 발송
- 현재 구현에서는 identifier가 동일하므로 알림이 덮어쓰기됨
- 필요 시 UUID를 사용한 고유 identifier 생성 고려:

```swift
let identifier = "share_completed_\(UUID().uuidString)"
```

## 📚 참고 자료

### Apple 공식 문서

- [UserNotifications Framework](https://developer.apple.com/documentation/usernotifications)
- [UNUserNotificationCenter](https://developer.apple.com/documentation/usernotifications/unusernotificationcenter)
- [UNNotificationRequest](https://developer.apple.com/documentation/usernotifications/unnotificationrequest)
- [UNUserNotificationCenterDelegate](https://developer.apple.com/documentation/usernotifications/unusernotificationcenterdelegate)

### 프로젝트 문서

- [docs/Services.md](Services.md) - SharingService 통합 가이드
- [docs/iOS_Share_Extension_Migration_iOS26.md](iOS_Share_Extension_Migration_iOS26.md) - Share Extension 리팩토링 가이드
- [SHARE_EXTENSION_REFACTORING_SUMMARY.md](../SHARE_EXTENSION_REFACTORING_SUMMARY.md) - 리팩토링 요약

## 🎯 향후 개선 방향

### 1. 알림 메시지 커스터마이징

```swift
// URL인 경우와 텍스트인 경우 다른 메시지
if sharedText.first?.hasPrefix("http") == true {
    content.body = "링크를 저장했습니다"
} else {
    content.body = "텍스트를 저장했습니다"
}
```

### 2. Rich Notification

```swift
// 이미지 썸네일 추가 (URL 미리보기)
if let imageURL = extractImageFromURL(sharedText.first ?? "") {
    let attachment = try? UNNotificationAttachment(identifier: "preview", url: imageURL, options: nil)
    content.attachments = [attachment].compactMap { $0 }
}
```

### 3. Actionable Notification

```swift
// 알림에 버튼 추가
let viewAction = UNNotificationAction(identifier: "VIEW", title: "앱에서 보기", options: .foreground)
let deleteAction = UNNotificationAction(identifier: "DELETE", title: "삭제", options: .destructive)

let category = UNNotificationCategory(identifier: "SHARE_COMPLETED", actions: [viewAction, deleteAction], intentIdentifiers: [])
UNUserNotificationCenter.current().setNotificationCategories([category])

content.categoryIdentifier = "SHARE_COMPLETED"
```

## ✅ 완료 체크리스트

- [x] UserNotifications 프레임워크 import
- [x] sendLocalNotification() 메서드 구현
- [x] saveAndLaunchApp()에서 알림 호출
- [x] AppDelegate에서 알림 권한 요청
- [x] AppDelegate에서 알림 탭 핸들러 구현
- [x] 포그라운드 알림 presentation 설정
- [x] 빌드 테스트 성공
- [ ] 실제 디바이스에서 테스트
- [ ] TestFlight 배포 후 프로덕션 테스트

---

**작성일**: 2025-11-23
**최종 수정**: 2025-11-23
**작성자**: Claude (SuperClaude Framework)
