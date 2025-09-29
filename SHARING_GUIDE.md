# TripTogether 공유 기능 가이드

## 📋 개요

TripTogether 앱의 공유 기능은 다른 앱에서 공유된 콘텐츠(이미지, 동영상, 텍스트, 파일)를 받아서 처리할 수 있도록 구현되었습니다. iOS Share Extension과 Flutter 앱 간의 원활한 데이터 전달을 위해 UserDefaults를 활용하는 방식으로 설계되었습니다.

### 주요 특징
- 📱 iOS Share Extension을 통한 네이티브 공유 지원
- 🔄 앱 라이프사이클 기반 자동 데이터 감지
- 🎯 타이머 없이 효율적인 데이터 확인
- 🔗 다양한 미디어 타입 지원 (이미지, 동영상, 텍스트, URL, 파일)
- 🔧 Pull-to-refresh와 수동 새로고침 지원

## 🏗️ 아키텍처

```
┌─────────────────┐    UserDefaults    ┌──────────────────┐
│  Share Extension │ ──────────────────▶│   Flutter App    │
│  (ShareViewController) │              │  (SharingService) │
└─────────────────┘                    └──────────────────┘
        │                                        │
        ▼                                        ▼
   공유 데이터 수신                           화면에 데이터 표시
   UserDefaults 저장                       자동/수동 새로고침
```

### 데이터 흐름
1. **공유 시작**: 다른 앱에서 "공유" → TripTogether 선택
2. **Share Extension**: ShareViewController.swift가 데이터 처리
3. **데이터 저장**: UserDefaults에 구조화된 데이터 저장
4. **앱 감지**: Flutter 앱이 라이프사이클 기반으로 데이터 확인
5. **화면 표시**: 공유된 콘텐츠를 사용자에게 표시

## 🧩 주요 구성 요소

### 1. iOS Share Extension (`ShareViewController.swift`)

```swift
class ShareViewController: SLComposeServiceViewController {
    let hostAppBundleIdentifier = "com.example.triptogether"
    let sharedKey = "ShareKey"
}
```

**역할:**
- 다른 앱에서 공유된 콘텐츠 수신
- 이미지, 동영상, 텍스트, URL, 파일 처리
- UserDefaults에 구조화된 데이터 저장
- 공유 완료 후 Share Extension 종료

**지원하는 콘텐츠 타입:**
- `kUTTypeImage`: 이미지 파일
- `kUTTypeMovie`: 동영상 파일
- `kUTTypeText`: 텍스트
- `kUTTypeURL`: URL
- `kUTTypeFileURL`: 일반 파일

### 2. Flutter SharingService (`lib/services/sharing_service.dart`)

```dart
class SharingService {
  static SharingService get instance => _instance ??= SharingService._internal();

  /// 수동으로 공유 데이터 확인
  Future<void> checkForData() async { ... }

  /// 공유 서비스 초기화
  Future<void> initialize() async { ... }
}
```

**주요 메서드:**
- `initialize()`: 앱 시작 시 서비스 초기화
- `checkForData()`: 수동으로 새 데이터 확인
- `dataStream`: 공유 데이터 스트림 구독
- `clearCurrentData()`: 현재 데이터 지우기
- `resetAllData()`: 모든 데이터 완전 초기화

### 3. Flutter HomePage (`lib/main.dart`)

```dart
class HomePageState extends State<HomePage> with WidgetsBindingObserver {
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _checkForNewData();
    }
  }
}
```

**특징:**
- `WidgetsBindingObserver`로 앱 라이프사이클 감지
- `RefreshIndicator`로 Pull-to-refresh 지원
- 수동 새로고침 버튼 제공
- 실시간 공유 데이터 표시

## 📊 데이터 구조

### UserDefaults 저장 형식

```json
{
  "texts": ["공유된 텍스트", "https://example.com"],
  "files": [
    {
      "path": "/path/to/image.jpg",
      "type": 0,
      "thumbnail": "/path/to/thumbnail.jpg",
      "duration": null
    }
  ]
}
```

### Flutter에서의 데이터 모델

```dart
class SharedData {
  final List<SharedMediaFile> sharedFiles;
  final List<String> sharedTexts;
  final DateTime receivedAt;

  bool get hasTextData => sharedTexts.isNotEmpty;
  bool get hasMediaData => sharedFiles.isNotEmpty;
}

enum SharedMediaType { image, video, file, text, url }
```

## ⚙️ 초기 설정 방법

### 1. iOS Share Extension 생성

#### Xcode에서 Share Extension Target 추가

1. **Xcode 프로젝트 열기**
   ```bash
   open ios/Runner.xcworkspace
   ```

2. **Share Extension Target 추가**
   - Xcode에서 `File` → `New` → `Target` 선택
   - `iOS` → `Application Extension` → `Share Extension` 선택
   - Product Name: `Share Extension`
   - Language: `Swift`
   - 생성 후 `Activate` 선택

3. **Bundle Identifier 설정**
   - Share Extension Target 선택
   - `Bundle Identifier`: `com.example.triptogether.ShareExtension`
   - 메인 앱과 동일한 prefix 사용 필수

#### Info.plist 구성

`Share Extension/Info.plist` 파일 수정:

```xml
<key>NSExtension</key>
<dict>
    <key>NSExtensionAttributes</key>
    <dict>
        <key>NSExtensionActivationRule</key>
        <dict>
            <key>NSExtensionActivationSupportsImageWithMaxCount</key>
            <integer>10</integer>
            <key>NSExtensionActivationSupportsMovieWithMaxCount</key>
            <integer>10</integer>
            <key>NSExtensionActivationSupportsText</key>
            <true/>
            <key>NSExtensionActivationSupportsWebURLWithMaxCount</key>
            <integer>10</integer>
            <key>NSExtensionActivationSupportsFileWithMaxCount</key>
            <integer>10</integer>
        </dict>
    </dict>
    <key>NSExtensionMainStoryboard</key>
    <string>MainInterface</string>
    <key>NSExtensionPointIdentifier</key>
    <string>com.apple.share-services</string>
</dict>
```

### 2. ShareViewController.swift 구현

`Share Extension/ShareViewController.swift` 파일 생성:

```swift
import UIKit
import Social
import MobileCoreServices
import Photos
import AVFoundation

class ShareViewController: SLComposeServiceViewController {
    // IMPORTANT: 메인 앱의 Bundle Identifier와 동일하게 설정
    let hostAppBundleIdentifier = "com.example.triptogether"
    let sharedKey = "ShareKey"
    var sharedMedia: [SharedMediaFile] = []
    var sharedText: [String] = []
    let imageContentType = kUTTypeImage as String
    let videoContentType = kUTTypeMovie as String
    let textContentType = kUTTypeText as String
    let urlContentType = kUTTypeURL as String
    let fileURLType = kUTTypeFileURL as String

    override func isContentValid() -> Bool {
        return true
    }

    override func didSelectPost() {
        print("[ShareViewController] didSelectPost 호출됨")

        if let content = extensionContext?.inputItems.first as? NSExtensionItem,
           let attachments = content.attachments {
            for (index, attachment) in attachments.enumerated() {
                if attachment.hasItemConformingToTypeIdentifier(imageContentType) {
                    handleImages(content: content, attachment: attachment, index: index)
                } else if attachment.hasItemConformingToTypeIdentifier(textContentType) {
                    handleText(content: content, attachment: attachment, index: index)
                } else if attachment.hasItemConformingToTypeIdentifier(fileURLType) {
                    handleFiles(content: content, attachment: attachment, index: index)
                } else if attachment.hasItemConformingToTypeIdentifier(urlContentType) {
                    handleUrl(content: content, attachment: attachment, index: index)
                } else if attachment.hasItemConformingToTypeIdentifier(videoContentType) {
                    handleVideos(content: content, attachment: attachment, index: index)
                }
            }
        } else {
            self.redirectToHostApp(type: .text)
        }
    }

    // 각 미디어 타입별 처리 메서드들...
    // (전체 코드는 기존 ShareViewController.swift 참고)
}

// SharedMediaFile 구조체 정의
struct SharedMediaFile: Codable {
    var path: String
    var thumbnail: String?
    var duration: Double?
    var type: SharedMediaType
}

enum SharedMediaType: Int, CaseIterable, Codable {
    case image
    case video
    case file
    case text
    case url
}
```

### 3. Flutter 프로젝트 설정

#### pubspec.yaml 의존성 추가

```yaml
dependencies:
  flutter:
    sdk: flutter
  # 기존 의존성들...

dev_dependencies:
  flutter_test:
    sdk: flutter
  # 기존 dev_dependencies들...
```

> **참고**: receive_sharing_intent 패키지는 사용하지 않습니다. UserDefaults를 직접 사용합니다.

#### iOS 앱 Bundle Identifier 확인

`ios/Runner.xcodeproj`에서 메인 앱의 Bundle Identifier가 ShareViewController.swift의 `hostAppBundleIdentifier`와 일치하는지 확인:

1. Xcode에서 Runner 타겟 선택
2. `General` → `Bundle Identifier` 확인
3. `com.example.triptogether` 형태여야 함

### 4. Native 코드 설정

#### iOS Method Channel 구성

`ios/Runner/AppDelegate.swift`에 Method Channel 추가:

```swift
import UIKit
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {

        let controller = window?.rootViewController as! FlutterViewController
        let sharingChannel = FlutterMethodChannel(
            name: "sharing_service",
            binaryMessenger: controller.binaryMessenger
        )

        sharingChannel.setMethodCallHandler { call, result in
            switch call.method {
            case "getSharedData":
                self.getSharedData(result: result)
            case "clearSharedData":
                self.clearSharedData(result: result)
            default:
                result(FlutterMethodNotImplemented)
            }
        }

        GeneratedPluginRegistrant.register(with: self)
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }

    private func getSharedData(result: @escaping FlutterResult) {
        let userDefaults = UserDefaults.standard
        let sharedData = userDefaults.object(forKey: "ShareKey")
        result(sharedData)
    }

    private func clearSharedData(result: @escaping FlutterResult) {
        let userDefaults = UserDefaults.standard
        userDefaults.removeObject(forKey: "ShareKey")
        let success = userDefaults.synchronize()
        result(success)
    }
}
```

### 5. Flutter 앱에서 서비스 통합

#### SharingService 추가

`lib/services/sharing_service.dart` 파일이 이미 구현되어 있으므로 추가 작업 불필요.

#### main.dart에서 초기화

```dart
import 'package:flutter/material.dart';
import 'services/sharing_service.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TripTogether',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        fontFamily: 'Pretendard',
      ),
      home: HomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initializeSharing();
  }

  Future<void> _initializeSharing() async {
    await SharingService.instance.initialize();

    SharingService.instance.dataStream.listen((SharedData data) {
      setState(() {
        _currentSharedData = data;
      });
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      SharingService.instance.checkForData();
    }
  }

  // 나머지 구현...
}
```

### 6. 빌드 및 테스트

#### iOS 시뮬레이터에서 테스트

1. **프로젝트 빌드**
   ```bash
   flutter build ios --debug
   ```

2. **Xcode에서 실행**
   ```bash
   open ios/Runner.xcworkspace
   ```
   - Runner 스킴으로 빌드 및 실행

3. **Share Extension 테스트**
   - 사진 앱에서 이미지 선택
   - 공유 버튼 → TripTogether 선택
   - 공유 완료 후 TripTogether 앱에서 확인

#### 실제 디바이스에서 테스트

1. **Apple Developer 계정 설정**
   - Xcode에서 Team 설정
   - Runner와 Share Extension 모두 동일한 Team 설정

2. **Provisioning Profile 설정**
   - 메인 앱과 Share Extension 각각 프로필 필요
   - App Groups 권한이 있는 프로필 사용

3. **디바이스에 설치**
   ```bash
   flutter install
   ```

### 7. 문제 해결

#### 일반적인 설정 문제

1. **Bundle Identifier 불일치**
   ```
   오류: Share Extension에서 공유했지만 앱에서 데이터가 보이지 않음
   해결: ShareViewController.swift의 hostAppBundleIdentifier와
         메인 앱의 Bundle Identifier가 일치하는지 확인
   ```

2. **Method Channel 오류**
   ```
   오류: MissingPluginException(No implementation found for method getSharedData)
   해결: AppDelegate.swift에 Method Channel 코드가 올바르게 추가되었는지 확인
   ```

3. **권한 문제**
   ```
   오류: Share Extension이 공유 메뉴에 나타나지 않음
   해결: Info.plist의 NSExtensionActivationRule 설정 확인
   ```

#### 디버깅 방법

1. **Xcode Console 로그 확인**
   - Device & Simulators에서 디바이스 로그 확인
   - ShareViewController와 Flutter 앱 로그 모니터링

2. **UserDefaults 직접 확인**
   ```swift
   let defaults = UserDefaults.standard
   print("ShareKey: \(defaults.object(forKey: "ShareKey") ?? "nil")")
   ```

3. **Flutter 디버그 로그**
   ```dart
   debugPrint('[SharingService] 현재 상태: ${SharingService.instance.currentSharedData}');
   ```

## 🚀 사용 방법

### 사용자 관점

1. **공유하기**
   - 다른 앱에서 콘텐츠 선택
   - 공유 버튼 → TripTogether 선택
   - 간단한 메시지 입력 (선택사항)
   - "Post" 버튼으로 공유 완료

2. **공유 내용 확인**
   - TripTogether 앱 실행
   - 자동으로 공유 데이터 표시
   - 또는 화면을 아래로 당겨서 새로고침

3. **데이터 관리**
   - "새로고침" 버튼: 새 데이터 확인
   - "처리 완료" 버튼: 현재 데이터만 지우기
   - "완전 초기화" 버튼: 모든 데이터 지우기

### 개발자 관점

#### 1. 서비스 초기화

```dart
@override
void initState() {
  super.initState();
  WidgetsBinding.instance.addObserver(this);
  _initializeSharing();
}

Future<void> _initializeSharing() async {
  await SharingService.instance.initialize();

  _sharingSubscription = SharingService.instance.dataStream.listen(
    (SharedData data) {
      setState(() {
        _currentSharedData = data;
      });
    },
  );
}
```

#### 2. 라이프사이클 기반 데이터 확인

```dart
@override
void didChangeAppLifecycleState(AppLifecycleState state) {
  if (state == AppLifecycleState.resumed) {
    _checkForNewData();
  }
}

Future<void> _checkForNewData() async {
  await SharingService.instance.checkForData();
}
```

#### 3. Pull-to-refresh 구현

```dart
Widget build(BuildContext context) {
  return RefreshIndicator(
    onRefresh: _onRefresh,
    child: SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: _buildContent(),
    ),
  );
}

Future<void> _onRefresh() async {
  await _checkForNewData();
}
```

## ⚙️ 기술적 세부사항

### App Group 설정

iOS에서는 Share Extension과 메인 앱 간 데이터 공유를 위해 동일한 Bundle Identifier를 사용:

```swift
let hostAppBundleIdentifier = "com.example.triptogether"
```

### UserDefaults 키 구조

- **sharedKey**: `"ShareKey"`
- **저장 위치**: `UserDefaults.standard`
- **데이터 형식**: JSON 구조화된 데이터

### 지원되는 미디어 타입

| 타입 | 확장자 예시 | SharedMediaType |
|------|------------|-----------------|
| 이미지 | jpg, png, gif, heic | `image` |
| 동영상 | mp4, mov, avi | `video` |
| 파일 | pdf, doc, txt | `file` |
| 텍스트 | - | `text` |
| URL | - | `url` |

### 데이터 확인 메커니즘

1. **앱 시작 시**: `_processInitialData()` 한 번 실행
2. **앱 복귀 시**: `didChangeAppLifecycleState()` 감지하여 자동 확인
3. **수동 확인**: `checkForData()` 메서드 직접 호출

## 🐛 문제 해결 가이드

### 공유 데이터가 표시되지 않는 경우

**증상**: Share Extension에서 공유했지만 앱에서 데이터가 보이지 않음

**해결 방법**:
1. 앱을 완전히 종료 후 재시작
2. "새로고침" 버튼 클릭
3. 화면을 아래로 당겨서 Pull-to-refresh
4. "완전 초기화" 후 다시 공유 시도

### 로그 확인 방법

**Xcode Console에서 확인 가능한 로그**:

```
// Share Extension 로그
[ShareViewController] didSelectPost 호출됨
[ShareViewController] 이미지 처리 완료: /path/to/image.jpg

// Flutter 앱 로그
[SharingService] 공유 서비스 초기화 시작
[SharingService] 새로운 공유 데이터 발견: {...}
[HomePage] 공유 데이터 수신됨: SharedData(files: 1, texts: 0)
```

### 일반적인 문제들

#### 1. Bundle Identifier 불일치
**문제**: Share Extension과 메인 앱의 Bundle Identifier가 다름
**해결**: `ShareViewController.swift`의 `hostAppBundleIdentifier` 확인

#### 2. UserDefaults 클리어 실패
**문제**: 데이터 처리 후 UserDefaults가 정리되지 않음
**해결**: `resetAllData()` 메서드로 강제 초기화

#### 3. 앱 라이프사이클 감지 실패
**문제**: 앱 복귀 시 자동으로 데이터가 확인되지 않음
**해결**: `WidgetsBindingObserver` 등록 확인

## 🔧 디버깅 팁

### 1. 상세 로그 활성화

디버그 모드에서는 모든 단계별 로그가 출력됩니다:

```dart
debugPrint('[SharingService] 공유 서비스 초기화 시작');
```

### 2. 수동 테스트 방법

```dart
// 개발 중 테스트용 버튼 추가
ElevatedButton(
  onPressed: () async {
    await SharingService.instance.checkForData();
  },
  child: Text('수동 데이터 확인'),
)
```

### 3. UserDefaults 직접 확인

```swift
// iOS에서 UserDefaults 내용 확인
let defaults = UserDefaults.standard
print("SharedKey content: \(defaults.object(forKey: "ShareKey") ?? "nil")")
```

## 📝 향후 개선 계획

- [ ] Android Share Intent 지원 추가
- [ ] 공유 데이터 히스토리 관리
- [ ] 대용량 파일 처리 최적화
- [ ] 공유 완료 후 자동 앱 실행
- [ ] 공유 데이터 미리보기 개선

---

> **참고**: 이 가이드는 현재 구현된 iOS 공유 기능을 기반으로 작성되었습니다. Android 지원은 향후 추가 예정입니다.