# Flutter 크로스플랫폼 공유 기능 구현 가이드

> **완전한 iOS + Android 공유 기능 구현 가이드**
> 다른 앱에서 콘텐츠(텍스트, 이미지, 동영상, 파일)를 여러분의 Flutter 앱으로 공유받는 기능을 구현하는 방법을 설명합니다.

## 📋 개요

이 가이드는 Flutter 앱에서 **인바운드 공유 기능**(다른 앱 → 우리 앱)을 구현하는 완전한 방법을 제공합니다. iOS와 Android 모두를 지원하며, 네이티브 코드부터 Flutter 통합까지 모든 단계를 포함합니다.

### 🎯 지원하는 기능

- **📱 iOS**: Share Extension을 통한 네이티브 공유 지원
- **🤖 Android**: Intent System을 통한 네이티브 공유 지원
- **🔄 크로스플랫폼**: 통합된 Flutter 서비스로 양 플랫폼 관리
- **📦 다양한 콘텐츠**: 텍스트, 이미지, 동영상, 파일, URL 지원
- **⚡ 실시간**: 앱 라이프사이클 기반 자동 감지
- **🔧 사용자 친화적**: Pull-to-refresh 및 수동 새로고침 지원

### 🏗️ 아키텍처 개요

```
┌─────────────┐     Native Bridge     ┌─────────────┐
│    iOS      │ ←── UserDefaults ───→ │   Flutter   │
│ ShareExt    │                       │  Sharing    │
└─────────────┘                       │  Service    │
                                      │             │
┌─────────────┐     MethodChannel     │             │
│   Android   │ ←─── Intent API ────→ │             │
│ MainActivity│                       └─────────────┘
└─────────────┘
```

## 🚀 빠른 시작

### 1. 필요한 파일들

이 가이드를 따라하면 다음 파일들을 생성하거나 수정하게 됩니다:

```
project/
├── lib/services/sharing_service.dart          # Flutter 공유 서비스
├── android/app/src/main/AndroidManifest.xml   # Android Intent 설정
├── android/app/src/main/kotlin/.../MainActivity.kt # Android 네이티브 코드
├── ios/Share Extension/                        # iOS Share Extension
│   ├── ShareViewController.swift
│   └── Info.plist
└── ios/Runner/AppDelegate.swift               # iOS 네이티브 코드
```

### 2. 예상 작업 시간

- **신규 프로젝트**: 2-3시간
- **기존 프로젝트**: 1-2시간
- **테스트 및 디버깅**: 30분-1시간

---

## 📱 iOS 구현

### Step 1: Share Extension 생성

#### 1.1 Xcode에서 Share Extension Target 추가

```bash
# Xcode 워크스페이스 열기
cd your_flutter_project
open ios/Runner.xcworkspace
```

**Xcode에서:**
1. **File** → **New** → **Target** 선택
2. **iOS** → **Application Extension** → **Share Extension** 선택
3. **Product Name**: `Share Extension`
4. **Language**: `Swift`
5. **Bundle Identifier**: `com.yourcompany.yourapp.ShareExtension`
   > ⚠️ **중요**: 메인 앱과 동일한 Bundle ID prefix 사용 필수
6. **Activate** 선택

#### 1.2 Share Extension Info.plist 설정

`Share Extension/Info.plist` 파일을 다음과 같이 수정:

```xml
<key>NSExtension</key>
<dict>
    <key>NSExtensionAttributes</key>
    <dict>
        <key>NSExtensionActivationRule</key>
        <dict>
            <!-- 이미지 최대 10개 -->
            <key>NSExtensionActivationSupportsImageWithMaxCount</key>
            <integer>10</integer>
            <!-- 동영상 최대 10개 -->
            <key>NSExtensionActivationSupportsMovieWithMaxCount</key>
            <integer>10</integer>
            <!-- 텍스트 지원 -->
            <key>NSExtensionActivationSupportsText</key>
            <true/>
            <!-- URL 최대 10개 -->
            <key>NSExtensionActivationSupportsWebURLWithMaxCount</key>
            <integer>10</integer>
            <!-- 파일 최대 10개 -->
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

### Step 2: ShareViewController.swift 구현

`Share Extension/ShareViewController.swift` 파일을 생성:

```swift
import UIKit
import Social
import MobileCoreServices
import Photos
import AVFoundation

class ShareViewController: SLComposeServiceViewController {

    // IMPORTANT: 메인 앱의 Bundle Identifier와 정확히 일치해야 함
    let hostAppBundleIdentifier = "com.yourcompany.yourapp"
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
        print("[ShareViewController] 공유 프로세스 시작")

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

    // MARK: - 이미지 처리
    private func handleImages(content: NSExtensionItem, attachment: NSItemProvider, index: Int) {
        attachment.loadItem(forTypeIdentifier: imageContentType, options: nil) { [weak self] data, error in
            if error == nil, let url = data as? URL, let this = self {
                print("[ShareViewController] 이미지 처리: \(url)")
                this.copyFileToSharedContainer(url: url, type: .image)
            }

            self?.checkCompletionStatus(itemsExpected: content.attachments?.count ?? 1)
        }
    }

    // MARK: - 텍스트 처리
    private func handleText(content: NSExtensionItem, attachment: NSItemProvider, index: Int) {
        attachment.loadItem(forTypeIdentifier: textContentType, options: nil) { [weak self] data, error in
            if error == nil, let item = data as? String {
                print("[ShareViewController] 텍스트 처리: \(item)")
                self?.sharedText.append(item)
            }

            self?.checkCompletionStatus(itemsExpected: content.attachments?.count ?? 1)
        }
    }

    // MARK: - 파일 처리
    private func handleFiles(content: NSExtensionItem, attachment: NSItemProvider, index: Int) {
        attachment.loadItem(forTypeIdentifier: fileURLType, options: nil) { [weak self] data, error in
            if error == nil, let url = data as? URL, let this = self {
                print("[ShareViewController] 파일 처리: \(url)")
                this.copyFileToSharedContainer(url: url, type: .file)
            }

            self?.checkCompletionStatus(itemsExpected: content.attachments?.count ?? 1)
        }
    }

    // MARK: - URL 처리
    private func handleUrl(content: NSExtensionItem, attachment: NSItemProvider, index: Int) {
        attachment.loadItem(forTypeIdentifier: urlContentType, options: nil) { [weak self] data, error in
            if error == nil, let item = data as? URL {
                print("[ShareViewController] URL 처리: \(item)")
                self?.sharedText.append(item.absoluteString)
            }

            self?.checkCompletionStatus(itemsExpected: content.attachments?.count ?? 1)
        }
    }

    // MARK: - 동영상 처리
    private func handleVideos(content: NSExtensionItem, attachment: NSItemProvider, index: Int) {
        attachment.loadItem(forTypeIdentifier: videoContentType, options: nil) { [weak self] data, error in
            if error == nil, let url = data as? URL, let this = self {
                print("[ShareViewController] 동영상 처리: \(url)")
                this.copyFileToSharedContainer(url: url, type: .video)
            }

            self?.checkCompletionStatus(itemsExpected: content.attachments?.count ?? 1)
        }
    }

    // MARK: - 파일 복사 및 처리
    private func copyFileToSharedContainer(url: URL, type: SharedMediaType) {
        let fileManager = FileManager.default
        let documentsPath = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
        let fileName = url.lastPathComponent
        let destinationUrl = documentsPath.appendingPathComponent(fileName)

        do {
            if fileManager.fileExists(atPath: destinationUrl.path) {
                try fileManager.removeItem(at: destinationUrl)
            }
            try fileManager.copyItem(at: url, to: destinationUrl)

            var thumbnailPath: String? = nil
            var duration: Double? = nil

            // 이미지인 경우 썸네일 생성
            if type == .image {
                thumbnailPath = generateThumbnail(for: destinationUrl)
            }

            // 동영상인 경우 썸네일 및 길이 정보 생성
            if type == .video {
                let asset = AVAsset(url: destinationUrl)
                duration = asset.duration.seconds
                thumbnailPath = generateVideoThumbnail(for: destinationUrl)
            }

            let sharedFile = SharedMediaFile(
                path: destinationUrl.path,
                thumbnail: thumbnailPath,
                duration: duration,
                type: type
            )
            sharedMedia.append(sharedFile)

        } catch {
            print("[ShareViewController] 파일 복사 오류: \(error)")
        }
    }

    // MARK: - 썸네일 생성
    private func generateThumbnail(for url: URL) -> String? {
        guard let image = UIImage(contentsOfFile: url.path) else { return nil }
        let size = CGSize(width: 100, height: 100)
        let thumbnail = image.resized(to: size)

        let thumbnailName = "thumb_\(url.lastPathComponent)"
        let thumbnailUrl = url.deletingLastPathComponent().appendingPathComponent(thumbnailName)

        if let thumbnailData = thumbnail?.jpegData(compressionQuality: 0.7) {
            try? thumbnailData.write(to: thumbnailUrl)
            return thumbnailUrl.path
        }
        return nil
    }

    private func generateVideoThumbnail(for url: URL) -> String? {
        let asset = AVAsset(url: url)
        let imageGenerator = AVAssetImageGenerator(asset: asset)
        imageGenerator.appliesPreferredTrackTransform = true

        do {
            let cgImage = try imageGenerator.copyCGImage(at: CMTime.zero, actualTime: nil)
            let thumbnail = UIImage(cgImage: cgImage)

            let thumbnailName = "thumb_\(url.lastPathComponent).jpg"
            let thumbnailUrl = url.deletingLastPathComponent().appendingPathComponent(thumbnailName)

            if let thumbnailData = thumbnail.jpegData(compressionQuality: 0.7) {
                try thumbnailData.write(to: thumbnailUrl)
                return thumbnailUrl.path
            }
        } catch {
            print("[ShareViewController] 동영상 썸네일 생성 오류: \(error)")
        }

        return nil
    }

    // MARK: - 완료 확인 및 데이터 저장
    private func checkCompletionStatus(itemsExpected: Int) {
        let totalProcessed = sharedMedia.count + sharedText.count
        if totalProcessed == itemsExpected {
            saveDataToUserDefaults()
            redirectToHostApp(type: .file)
        }
    }

    private func saveDataToUserDefaults() {
        let data: [String: Any] = [
            "texts": sharedText,
            "files": sharedMedia.map { file in
                [
                    "path": file.path,
                    "type": file.type.rawValue,
                    "thumbnail": file.thumbnail as Any,
                    "duration": file.duration as Any
                ]
            }
        ]

        let userDefaults = UserDefaults.standard
        userDefaults.set(data, forKey: sharedKey)
        userDefaults.synchronize()

        print("[ShareViewController] UserDefaults에 저장 완료: \(data)")
    }

    private func redirectToHostApp(type: SharedMediaType) {
        let url = URL(string: "\(hostAppBundleIdentifier)://")
        var responder = self as UIResponder?

        while (responder != nil) {
            if let application = responder as? UIApplication {
                application.perform(#selector(openURL(_:)), with: url)
            }
            responder = responder?.next
        }

        extensionContext!.completeRequest(returningItems: [], completionHandler: nil)
    }
}

// MARK: - 데이터 모델
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

// MARK: - UIImage Extension
extension UIImage {
    func resized(to size: CGSize) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        defer { UIGraphicsEndImageContext() }
        draw(in: CGRect(origin: .zero, size: size))
        return UIGraphicsGetImageFromCurrentImageContext()
    }
}
```

### Step 3: iOS AppDelegate 설정

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
        print("[AppDelegate] SharedData 가져옴: \(sharedData ?? "nil")")
        result(sharedData)
    }

    private func clearSharedData(result: @escaping FlutterResult) {
        let userDefaults = UserDefaults.standard
        userDefaults.removeObject(forKey: "ShareKey")
        let success = userDefaults.synchronize()
        print("[AppDelegate] SharedData 클리어: \(success)")
        result(success)
    }
}
```

---

## 🤖 Android 구현

### Step 1: AndroidManifest.xml 설정

`android/app/src/main/AndroidManifest.xml`을 수정하여 Intent Filter 추가:

```xml
<manifest xmlns:android="http://schemas.android.com/apk/res/android">
    <!-- 파일 공유를 위한 권한 -->
    <uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE"/>

    <application
        android:label="your_app_name"
        android:name="${applicationName}"
        android:icon="@mipmap/ic_launcher">

        <activity
            android:name=".MainActivity"
            android:exported="true"
            android:launchMode="singleTask"
            android:theme="@style/LaunchTheme"
            android:configChanges="orientation|keyboardHidden|keyboard|screenSize|smallestScreenSize|locale|layoutDirection|fontScale|screenLayout|density|uiMode"
            android:hardwareAccelerated="true"
            android:windowSoftInputMode="adjustResize">

            <!-- 기본 런처 인텐트 -->
            <intent-filter>
                <action android:name="android.intent.action.MAIN"/>
                <category android:name="android.intent.category.LAUNCHER"/>
            </intent-filter>

            <!-- 텍스트 공유 지원 -->
            <intent-filter>
               <action android:name="android.intent.action.SEND" />
               <category android:name="android.intent.category.DEFAULT" />
               <data android:mimeType="text/*" />
            </intent-filter>

            <!-- 이미지 공유 (단일) -->
            <intent-filter>
                <action android:name="android.intent.action.SEND" />
                <category android:name="android.intent.category.DEFAULT" />
                <data android:mimeType="image/*" />
            </intent-filter>

            <!-- 이미지 공유 (다중) -->
            <intent-filter>
                <action android:name="android.intent.action.SEND_MULTIPLE" />
                <category android:name="android.intent.category.DEFAULT" />
                <data android:mimeType="image/*" />
            </intent-filter>

            <!-- 동영상 공유 (단일) -->
            <intent-filter>
                <action android:name="android.intent.action.SEND" />
                <category android:name="android.intent.category.DEFAULT" />
                <data android:mimeType="video/*" />
            </intent-filter>

            <!-- 동영상 공유 (다중) -->
            <intent-filter>
                <action android:name="android.intent.action.SEND_MULTIPLE" />
                <category android:name="android.intent.category.DEFAULT" />
                <data android:mimeType="video/*" />
            </intent-filter>

            <!-- 모든 파일 공유 (단일) -->
            <intent-filter>
                <action android:name="android.intent.action.SEND" />
                <category android:name="android.intent.category.DEFAULT" />
                <data android:mimeType="*/*" />
            </intent-filter>

            <!-- 모든 파일 공유 (다중) -->
            <intent-filter>
                <action android:name="android.intent.action.SEND_MULTIPLE" />
                <category android:name="android.intent.category.DEFAULT" />
                <data android:mimeType="*/*" />
            </intent-filter>
        </activity>

        <meta-data
            android:name="flutterEmbedding"
            android:value="2" />
    </application>
</manifest>
```

### Step 2: MainActivity.kt 구현

`android/app/src/main/kotlin/your/package/MainActivity.kt` 파일 수정:

```kotlin
package com.yourcompany.yourapp // 여기를 실제 패키지명으로 변경

import android.content.Intent
import android.net.Uri
import android.os.Bundle
import android.util.Log
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {
    private val SHARING_CHANNEL = "sharing_service"
    private var methodChannel: MethodChannel? = null

    override fun onCreate(savedInstanceState: Bundle?) {
        Log.d("MainActivity", "onCreate - Intent: ${intent?.action}, Type: ${intent?.type}")
        super.onCreate(savedInstanceState)
        handleSharingIntent(intent)
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        methodChannel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, SHARING_CHANNEL)
        methodChannel?.setMethodCallHandler { call, result ->
            when (call.method) {
                "getSharedData" -> {
                    Log.d("MainActivity", "getSharedData 호출됨 (Android에서는 사용 안함)")
                    result.success(null)
                }
                "clearSharedData" -> {
                    Log.d("MainActivity", "clearSharedData 호출됨 (Android에서는 사용 안함)")
                    result.success(true)
                }
                else -> {
                    result.notImplemented()
                }
            }
        }
    }

    override fun onNewIntent(intent: Intent) {
        super.onNewIntent(intent)
        Log.d("MainActivity", "onNewIntent - Intent: ${intent.action}, Type: ${intent.type}")
        setIntent(intent)
        handleSharingIntent(intent)
    }

    private fun handleSharingIntent(intent: Intent?) {
        if (intent == null) return

        val action = intent.action
        val type = intent.type

        Log.d("MainActivity", "처리 중 - Action: $action, Type: $type")

        when (action) {
            Intent.ACTION_SEND -> {
                handleSingleShare(intent, type)
            }
            Intent.ACTION_SEND_MULTIPLE -> {
                handleMultipleShare(intent, type)
            }
            else -> {
                Log.d("MainActivity", "지원하지 않는 Intent Action: $action")
            }
        }
    }

    private fun handleSingleShare(intent: Intent, type: String?) {
        when {
            type?.startsWith("text/") == true -> {
                val sharedText = intent.getStringExtra(Intent.EXTRA_TEXT)
                if (!sharedText.isNullOrEmpty()) {
                    Log.d("MainActivity", "텍스트 공유: $sharedText")
                    sendToFlutter(mapOf(
                        "type" to "text",
                        "text" to sharedText
                    ))
                }
            }
            type?.startsWith("image/") == true -> {
                val imageUri = intent.getParcelableExtra<Uri>(Intent.EXTRA_STREAM)
                if (imageUri != null) {
                    Log.d("MainActivity", "이미지 공유: $imageUri")
                    sendToFlutter(mapOf(
                        "type" to "image",
                        "uri" to imageUri.toString()
                    ))
                }
            }
            type?.startsWith("video/") == true -> {
                val videoUri = intent.getParcelableExtra<Uri>(Intent.EXTRA_STREAM)
                if (videoUri != null) {
                    Log.d("MainActivity", "동영상 공유: $videoUri")
                    sendToFlutter(mapOf(
                        "type" to "video",
                        "uri" to videoUri.toString()
                    ))
                }
            }
            else -> {
                val fileUri = intent.getParcelableExtra<Uri>(Intent.EXTRA_STREAM)
                if (fileUri != null) {
                    Log.d("MainActivity", "파일 공유: $fileUri")
                    sendToFlutter(mapOf(
                        "type" to "file",
                        "uri" to fileUri.toString()
                    ))
                }
            }
        }
    }

    private fun handleMultipleShare(intent: Intent, type: String?) {
        val uris = intent.getParcelableArrayListExtra<Uri>(Intent.EXTRA_STREAM)
        if (uris != null && uris.isNotEmpty()) {
            Log.d("MainActivity", "${uris.size}개 파일 공유")

            val uriList = uris.map { it.toString() }
            sendToFlutter(mapOf(
                "type" to "multiple",
                "uris" to uriList,
                "mimeType" to (type ?: "")
            ))
        }
    }

    private fun sendToFlutter(data: Map<String, Any>) {
        Log.d("MainActivity", "Flutter로 데이터 전송: $data")
        methodChannel?.invokeMethod("onSharedData", data)
    }
}
```

---

## 🔄 Flutter 통합 서비스

### SharingService 구현

`lib/services/sharing_service.dart` 파일 생성:

```dart
import 'dart:async';
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

/// 공유된 미디어 파일의 타입을 나타내는 열거형
enum SharedMediaType { image, video, file, text, url }

/// 공유된 미디어 파일 정보를 담는 클래스
class SharedMediaFile {
  final String path;
  final String? thumbnail;
  final double? duration;
  final SharedMediaType type;

  SharedMediaFile({
    required this.path,
    this.thumbnail,
    this.duration,
    required this.type,
  });

  Map<String, dynamic> toMap() {
    return {
      'path': path,
      'thumbnail': thumbnail,
      'duration': duration,
      'type': type.index,
    };
  }

  factory SharedMediaFile.fromMap(Map<String, dynamic> map) {
    return SharedMediaFile(
      path: map['path'] ?? '',
      thumbnail: map['thumbnail'],
      duration: map['duration']?.toDouble(),
      type: SharedMediaType.values[map['type'] ?? 0],
    );
  }

  @override
  String toString() {
    return 'SharedMediaFile(path: $path, type: $type, thumbnail: $thumbnail, duration: $duration)';
  }
}

/// 공유 데이터를 담는 클래스
class SharedData {
  final List<SharedMediaFile> sharedFiles;
  final List<String> sharedTexts;
  final DateTime receivedAt;

  SharedData({
    required this.sharedFiles,
    required this.sharedTexts,
    DateTime? receivedAt,
  }) : receivedAt = receivedAt ?? DateTime.now();

  bool get hasTextData => sharedTexts.isNotEmpty;
  bool get hasMediaData => sharedFiles.isNotEmpty;
  bool get isEmpty => sharedFiles.isEmpty && sharedTexts.isEmpty;
  bool get isNotEmpty => !isEmpty;

  @override
  String toString() {
    return 'SharedData(files: ${sharedFiles.length}, texts: ${sharedTexts.length}, receivedAt: $receivedAt)';
  }
}

/// 공유 서비스 클래스 (싱글톤)
class SharingService {
  static SharingService? _instance;

  /// 싱글톤 인스턴스 반환
  static SharingService get instance {
    _instance ??= SharingService._internal();
    return _instance!;
  }

  SharingService._internal();

  /// 공유 데이터 스트림 컨트롤러
  final StreamController<SharedData> _dataStreamController =
      StreamController<SharedData>.broadcast();

  /// 현재 공유된 데이터
  SharedData? _currentSharedData;

  /// Native 플랫폼 채널
  static const MethodChannel _channel = MethodChannel('sharing_service');

  /// 공유 데이터 스트림 (외부에서 구독 가능)
  Stream<SharedData> get dataStream => _dataStreamController.stream;

  /// 현재 공유된 데이터 반환
  SharedData? get currentSharedData => _currentSharedData;

  /// 공유 서비스 초기화
  Future<void> initialize() async {
    try {
      debugPrint('[SharingService] 공유 서비스 초기화 시작');

      if (Platform.isIOS) {
        await _processInitialData();
      } else if (Platform.isAndroid) {
        await _initializeAndroidMethodChannel();
      }

      debugPrint('[SharingService] 공유 서비스 초기화 완료');
    } catch (error) {
      debugPrint('[SharingService] 초기화 오류: $error');
    }
  }

  /// 안드로이드용 MethodChannel 초기화
  Future<void> _initializeAndroidMethodChannel() async {
    try {
      debugPrint('[SharingService] 안드로이드 MethodChannel 초기화 시작');

      _channel.setMethodCallHandler((call) async {
        switch (call.method) {
          case 'onSharedData':
            debugPrint('[SharingService] 안드로이드에서 공유 데이터 수신');
            await _processAndroidSharedData(call.arguments);
            break;
          default:
            debugPrint('[SharingService] 지원하지 않는 메서드: ${call.method}');
        }
      });

      debugPrint('[SharingService] 안드로이드 MethodChannel 초기화 완료');
    } catch (error) {
      debugPrint('[SharingService] 안드로이드 MethodChannel 초기화 오류: $error');
    }
  }

  /// 안드로이드에서 받은 공유 데이터 처리
  Future<void> _processAndroidSharedData(dynamic arguments) async {
    try {
      debugPrint('[SharingService] 안드로이드 공유 데이터 처리 시작');

      if (arguments == null) {
        debugPrint('[SharingService] 공유 데이터가 null입니다');
        return;
      }

      final Map<String, dynamic> data = Map<String, dynamic>.from(arguments);
      final String type = data['type'] ?? '';

      debugPrint('[SharingService] 데이터 타입: $type');

      List<SharedMediaFile> sharedFiles = [];
      List<String> sharedTexts = [];

      switch (type) {
        case 'text':
          final String? text = data['text'];
          if (text != null && text.isNotEmpty) {
            sharedTexts.add(text);
            debugPrint('[SharingService] 텍스트 데이터 처리됨: $text');
          }
          break;

        case 'image':
        case 'video':
        case 'file':
          final String? uri = data['uri'];
          if (uri != null && uri.isNotEmpty) {
            final mediaType = _getMediaTypeFromString(type);
            sharedFiles.add(SharedMediaFile(
              path: uri,
              type: mediaType,
            ));
            debugPrint('[SharingService] $type 데이터 처리됨: $uri');
          }
          break;

        case 'multiple':
          final List<dynamic>? uris = data['uris'];
          if (uris != null && uris.isNotEmpty) {
            for (String uri in uris) {
              // MIME 타입에 따라 적절한 타입 결정
              final String mimeType = data['mimeType'] ?? '';
              SharedMediaType mediaType;
              if (mimeType.startsWith('image/')) {
                mediaType = SharedMediaType.image;
              } else if (mimeType.startsWith('video/')) {
                mediaType = SharedMediaType.video;
              } else {
                mediaType = SharedMediaType.file;
              }

              sharedFiles.add(SharedMediaFile(
                path: uri,
                type: mediaType,
              ));
            }
            debugPrint('[SharingService] 다중 파일 처리됨: ${uris.length}개');
          }
          break;

        default:
          debugPrint('[SharingService] 지원하지 않는 데이터 타입: $type');
          return;
      }

      // SharedData 생성 및 스트림에 전달
      if (sharedFiles.isNotEmpty || sharedTexts.isNotEmpty) {
        final sharedData = SharedData(
          sharedFiles: sharedFiles,
          sharedTexts: sharedTexts,
        );

        _currentSharedData = sharedData;
        _dataStreamController.add(sharedData);
        debugPrint('[SharingService] ✅ 안드로이드 공유 데이터 스트림 전달 완료');
      } else {
        debugPrint('[SharingService] ⚠️ 처리할 데이터가 없음');
      }

    } catch (error) {
      debugPrint('[SharingService] ❌ 안드로이드 공유 데이터 처리 오류: $error');
    }
  }

  /// 문자열 타입을 SharedMediaType으로 변환
  SharedMediaType _getMediaTypeFromString(String type) {
    switch (type) {
      case 'image':
        return SharedMediaType.image;
      case 'video':
        return SharedMediaType.video;
      case 'text':
        return SharedMediaType.text;
      default:
        return SharedMediaType.file;
    }
  }

  /// iOS 초기 데이터 처리
  Future<void> _processInitialData() async {
    try {
      debugPrint('[SharingService] iOS 초기 데이터 확인 중...');
      final result = await _channel.invokeMethod('getSharedData');

      if (result != null) {
        debugPrint('[SharingService] iOS 초기 데이터 발견: $result');
        await _processSharedData(result);
      } else {
        debugPrint('[SharingService] iOS 초기 데이터 없음');
      }
    } catch (error) {
      debugPrint('[SharingService] iOS 초기 데이터 처리 오류: $error');
    }
  }

  /// 공유 데이터 처리 (iOS용)
  Future<bool> _processSharedData(dynamic data) async {
    try {
      debugPrint('[SharingService] 공유 데이터 처리 시작: $data');

      if (data == null) return false;

      final Map<String, dynamic> sharedData = Map<String, dynamic>.from(data);
      final List<String> texts = List<String>.from(sharedData['texts'] ?? []);
      final List<dynamic> files = sharedData['files'] ?? [];

      List<SharedMediaFile> sharedFiles = [];
      for (var fileData in files) {
        final Map<String, dynamic> fileMap = Map<String, dynamic>.from(fileData);
        sharedFiles.add(SharedMediaFile.fromMap(fileMap));
      }

      if (texts.isNotEmpty || sharedFiles.isNotEmpty) {
        final newData = SharedData(
          sharedTexts: texts,
          sharedFiles: sharedFiles,
        );

        _currentSharedData = newData;
        _dataStreamController.add(newData);

        debugPrint('[SharingService] ✅ 공유 데이터 처리 완료: $newData');
        return true;
      }

      debugPrint('[SharingService] ⚠️ 처리할 데이터가 없음');
      return false;
    } catch (error) {
      debugPrint('[SharingService] ❌ 공유 데이터 처리 오류: $error');
      return false;
    }
  }

  /// 수동으로 새 공유 데이터 확인
  Future<void> checkForData() async {
    try {
      debugPrint('[SharingService] 수동 데이터 확인 시작');

      if (Platform.isIOS) {
        final result = await _channel.invokeMethod('getSharedData');
        if (result != null) {
          await _processSharedData(result);
        }
      }
      // Android는 Intent를 통해 자동으로 처리되므로 별도 확인 불필요

      debugPrint('[SharingService] 수동 데이터 확인 완료');
    } catch (error) {
      debugPrint('[SharingService] 수동 데이터 확인 오류: $error');
    }
  }

  /// 현재 공유 데이터 지우기
  Future<void> clearCurrentData() async {
    try {
      debugPrint('[SharingService] 현재 데이터 지우기 시작');

      _currentSharedData = null;

      if (Platform.isIOS) {
        await _channel.invokeMethod('clearSharedData');
      }

      debugPrint('[SharingService] ✅ 현재 데이터 지우기 완료');
    } catch (error) {
      debugPrint('[SharingService] 현재 데이터 지우기 오류: $error');
    }
  }

  /// 모든 데이터 완전 초기화
  Future<void> resetAllData() async {
    try {
      debugPrint('[SharingService] 모든 데이터 완전 초기화 시작');

      _currentSharedData = null;

      if (Platform.isIOS) {
        await _channel.invokeMethod('clearSharedData');
      }

      debugPrint('[SharingService] ✅ 모든 데이터 완전 초기화 완료');
    } catch (error) {
      debugPrint('[SharingService] 모든 데이터 초기화 오류: $error');
    }
  }

  /// 서비스 정리
  void dispose() {
    _dataStreamController.close();
  }
}
```

### main.dart에서 초기화

```dart
import 'package:flutter/material.dart';
import 'services/sharing_service.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Your App Name',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
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
  SharedData? _currentSharedData;
  StreamSubscription<SharedData>? _sharingSubscription;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initializeSharing();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _sharingSubscription?.cancel();
    super.dispose();
  }

  Future<void> _initializeSharing() async {
    debugPrint('[HomePage] 공유 서비스 초기화 시작');

    await SharingService.instance.initialize();

    _sharingSubscription = SharingService.instance.dataStream.listen(
      (SharedData data) {
        debugPrint('[HomePage] 공유 데이터 수신됨: $data');
        setState(() {
          _currentSharedData = data;
        });
      },
    );

    debugPrint('[HomePage] 공유 서비스 초기화 완료');
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      debugPrint('[HomePage] 앱 복귀됨 - 새 데이터 확인');
      _checkForNewData();
    }
  }

  Future<void> _checkForNewData() async {
    await SharingService.instance.checkForData();
  }

  Future<void> _onRefresh() async {
    await _checkForNewData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('공유 기능 테스트'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: RefreshIndicator(
        onRefresh: _onRefresh,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 공유 데이터 표시
              if (_currentSharedData != null) ...[
                Card(
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '📤 공유된 콘텐츠',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 12),

                        // 텍스트 데이터
                        if (_currentSharedData!.hasTextData) ...[
                          Text('📝 텍스트:', style: TextStyle(fontWeight: FontWeight.w500)),
                          SizedBox(height: 4),
                          for (String text in _currentSharedData!.sharedTexts)
                            Container(
                              width: double.infinity,
                              padding: EdgeInsets.all(12),
                              margin: EdgeInsets.only(bottom: 8),
                              decoration: BoxDecoration(
                                color: Colors.grey[100],
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(text),
                            ),
                          SizedBox(height: 12),
                        ],

                        // 미디어 파일
                        if (_currentSharedData!.hasMediaData) ...[
                          Text('📁 파일:', style: TextStyle(fontWeight: FontWeight.w500)),
                          SizedBox(height: 8),
                          for (SharedMediaFile file in _currentSharedData!.sharedFiles)
                            Container(
                              width: double.infinity,
                              padding: EdgeInsets.all(12),
                              margin: EdgeInsets.only(bottom: 8),
                              decoration: BoxDecoration(
                                color: Colors.blue[50],
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('타입: ${file.type.name}'),
                                  SizedBox(height: 4),
                                  Text(
                                    '경로: ${file.path}',
                                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                                  ),
                                  if (file.thumbnail != null) ...[
                                    SizedBox(height: 4),
                                    Text('썸네일: 있음', style: TextStyle(fontSize: 12)),
                                  ],
                                  if (file.duration != null) ...[
                                    SizedBox(height: 4),
                                    Text('길이: ${file.duration!.toStringAsFixed(1)}초'),
                                  ],
                                ],
                              ),
                            ),
                        ],

                        SizedBox(height: 16),
                        Text(
                          '수신 시각: ${_currentSharedData!.receivedAt.toString().substring(0, 19)}',
                          style: TextStyle(color: Colors.grey[600], fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 16),
              ] else ...[
                Card(
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Icon(Icons.share, size: 48, color: Colors.grey),
                        SizedBox(height: 8),
                        Text(
                          '공유된 데이터가 없습니다',
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                        SizedBox(height: 8),
                        Text(
                          '다른 앱에서 콘텐츠를 이 앱으로 공유해보세요',
                          style: TextStyle(color: Colors.grey[500], fontSize: 12),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 16),
              ],

              // 제어 버튼들
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _checkForNewData,
                      icon: Icon(Icons.refresh),
                      label: Text('새로고침'),
                    ),
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _currentSharedData != null ? () async {
                        await SharingService.instance.clearCurrentData();
                        setState(() {
                          _currentSharedData = null;
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('현재 데이터가 정리되었습니다')),
                        );
                      } : null,
                      icon: Icon(Icons.clear),
                      label: Text('데이터 정리'),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () async {
                    await SharingService.instance.resetAllData();
                    setState(() {
                      _currentSharedData = null;
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('모든 데이터가 완전히 초기화되었습니다')),
                    );
                  },
                  icon: Icon(Icons.delete_forever),
                  label: Text('완전 초기화'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                  ),
                ),
              ),

              SizedBox(height: 24),
              Text(
                '💡 사용 방법',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                '1. 다른 앱에서 콘텐츠 선택\n'
                '2. 공유 버튼 → "Your App Name" 선택\n'
                '3. 공유 완료 후 이 앱에서 확인\n'
                '4. 화면을 아래로 당겨서 새로고침 가능',
                style: TextStyle(color: Colors.grey[700]),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
```

---

## 🔧 빌드 및 테스트

### iOS 테스트

1. **Xcode에서 빌드**
   ```bash
   open ios/Runner.xcworkspace
   ```
   - Runner 스킴으로 빌드 및 실행

2. **Share Extension 테스트**
   - 사진 앱에서 이미지 선택
   - 공유 버튼 → 당신의 앱 이름 선택
   - 공유 완료 후 앱에서 확인

### Android 테스트

1. **Flutter에서 빌드**
   ```bash
   flutter run
   ```

2. **Intent 테스트**
   - Chrome에서 웹페이지 공유
   - 갤러리에서 이미지/동영상 공유
   - 파일 관리자에서 파일 공유

---

## 🐛 문제 해결

### 일반적인 문제들

#### 1. iOS - Bundle Identifier 불일치
**증상**: Share Extension에서 공유했지만 앱에서 데이터가 보이지 않음
**해결**: ShareViewController.swift의 `hostAppBundleIdentifier`와 메인 앱의 Bundle Identifier 일치 확인

#### 2. Android - Intent Filter 미작동
**증상**: 공유 메뉴에 앱이 나타나지 않음
**해결**: AndroidManifest.xml의 intent-filter 설정과 android:exported="true" 확인

#### 3. MethodChannel 연결 실패
**증상**: MissingPluginException 오류
**해결**: AppDelegate.swift (iOS) 또는 MainActivity.kt (Android)에 Method Channel 코드 추가 확인

### 디버깅 방법

#### iOS - Xcode Console
```swift
// 추가 로그 코드
print("[ShareViewController] 현재 상태: \(sharedMedia.count) 파일, \(sharedText.count) 텍스트")
```

#### Android - Flutter Console
```kotlin
// 추가 로그 코드
Log.d("MainActivity", "현재 Intent 상태: Action=${intent.action}, Type=${intent.type}")
```

#### Flutter - Debug Console
```dart
// 추가 로그 코드
debugPrint('[SharingService] 현재 상태: ${SharingService.instance.currentSharedData}');
```

---

## 📝 사용자 정의

### Bundle ID / Package Name 변경

**iOS**:
- `ShareViewController.swift`의 `hostAppBundleIdentifier` 수정
- Xcode에서 Target 설정의 Bundle Identifier 수정

**Android**:
- `MainActivity.kt`의 package 선언 수정
- `build.gradle`의 applicationId 수정

### 지원할 파일 타입 제한

**iOS Info.plist**:
```xml
<!-- 이미지만 지원하려면 -->
<key>NSExtensionActivationSupportsImageWithMaxCount</key>
<integer>5</integer>
<!-- 다른 타입들은 제거 -->
```

**Android AndroidManifest.xml**:
```xml
<!-- 이미지만 지원하려면 텍스트/동영상 intent-filter 제거 -->
<intent-filter>
    <action android:name="android.intent.action.SEND" />
    <category android:name="android.intent.category.DEFAULT" />
    <data android:mimeType="image/*" />
</intent-filter>
```

### UI 커스터마이징

`main.dart`에서 UI 구성 요소들을 원하는 대로 수정할 수 있습니다:
- 카드 디자인 변경
- 버튼 스타일 수정
- 데이터 표시 형식 변경
- 컬러 테마 적용

---

## 🚀 고급 기능

### 1. 파일 미리보기 추가
```dart
// 이미지 파일 미리보기
if (file.type == SharedMediaType.image) {
  Image.network(file.path, height: 200)
}
```

### 2. 자동 앱 실행
iOS Share Extension에서 공유 완료 후 자동으로 메인 앱 실행:
```swift
// redirectToHostApp 메서드에서
let url = URL(string: "\(hostAppBundleIdentifier)://")
// ... URL 스킴 처리 코드
```

### 3. 공유 데이터 히스토리
```dart
// SharingService에 히스토리 기능 추가
List<SharedData> _dataHistory = [];

void addToHistory(SharedData data) {
  _dataHistory.insert(0, data);
  if (_dataHistory.length > 10) {
    _dataHistory.removeLast();
  }
}
```

### 4. 백그라운드 업로드
공유받은 파일을 서버로 자동 업로드:
```dart
Future<void> uploadSharedFiles(SharedData data) async {
  for (var file in data.sharedFiles) {
    // 서버 업로드 로직
    await uploadToServer(file.path);
  }
}
```

---

## 📋 체크리스트

### iOS 설정 체크리스트
- [ ] Share Extension Target 생성
- [ ] Info.plist 올바르게 설정
- [ ] ShareViewController.swift 구현
- [ ] Bundle Identifier 일치 확인
- [ ] AppDelegate.swift에 Method Channel 추가
- [ ] 시뮬레이터/실제 기기에서 테스트

### Android 설정 체크리스트
- [ ] AndroidManifest.xml에 Intent Filter 추가
- [ ] MainActivity.kt 수정
- [ ] Package name 올바르게 설정
- [ ] 권한 설정 확인
- [ ] 에뮬레이터/실제 기기에서 테스트

### Flutter 설정 체크리스트
- [ ] SharingService 구현
- [ ] main.dart에서 초기화 코드 추가
- [ ] 앱 라이프사이클 관리 설정
- [ ] UI 구성 및 사용자 경험 개선
- [ ] 디버깅 로그 및 오류 처리

---

## 🎉 완료!

축하합니다! 이제 여러분의 Flutter 앱에서 iOS와 Android 모두에서 완벽하게 작동하는 공유 기능을 구현했습니다.

### 다음 단계들:
1. **실제 사용자 테스트**: 다양한 앱에서 공유 기능 테스트
2. **UI/UX 개선**: 사용자에게 친숙한 인터페이스 구성
3. **에러 처리 강화**: 예외 상황 대응 로직 추가
4. **성능 최적화**: 대용량 파일 처리 개선
5. **추가 기능 구현**: 히스토리, 자동 업로드 등

더 궁금한 점이나 문제가 있다면, 각 플랫폼의 공식 문서를 참조하거나 커뮤니티에 질문해보세요!

---

> **작성일**: 2025년 1월
> **버전**: 1.0
> **테스트 환경**: iOS 15+, Android 8.0+, Flutter 3.9+