import Flutter
import UIKit
import UserNotifications

@main
@objc class AppDelegate: FlutterAppDelegate {

  private let hostAppBundleIdentifier = "com.example.triptogether"
  private let sharedKey = "ShareKey"

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)

    // 알림 권한 요청 (Share Extension에서 알림을 발송하기 위해 필요)
    requestNotificationPermission()

    // 알림 델리게이트 설정 (알림 탭 처리를 위해)
    UNUserNotificationCenter.current().delegate = self

    // Flutter Method Channel 설정
    if let controller = window?.rootViewController as? FlutterViewController {
      let sharingChannel = FlutterMethodChannel(
        name: "sharing_service",
        binaryMessenger: controller.binaryMessenger
      )

      sharingChannel.setMethodCallHandler { [weak self] (call, result) in
        self?.handleMethodCall(call: call, result: result)
      }
    }

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  /// 알림 권한 요청
  /// Share Extension에서 Local Notification을 발송하기 위해 필요
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

  // Method Channel 처리
  private func handleMethodCall(call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "getSharedData":
      getSharedData(result: result)
    case "clearSharedData":
      clearSharedData(result: result)
    case "getShareLog":
      getShareLog(result: result)
    case "clearShareLog":
      clearShareLog(result: result)
    default:
      result(FlutterMethodNotImplemented)
    }
  }

  // UserDefaults에서 공유 데이터 읽기
  private func getSharedData(result: @escaping FlutterResult) {
    let userDefaults = UserDefaults(suiteName: "group.\(hostAppBundleIdentifier)")

    if let sharedData = userDefaults?.object(forKey: sharedKey) {
      if let texts = sharedData as? [String] {
        // 텍스트 데이터
        result(["texts": texts])
      } else if let data = sharedData as? Data {
        // JSON 데이터 (미디어 파일)
        do {
          if let jsonObject = try JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]] {
            result(["files": jsonObject])
          } else {
            result(nil)
          }
        } catch {
          print("[AppDelegate] JSON 파싱 오류: \(error)")
          result(nil)
        }
      } else {
        result(nil)
      }
    } else {
      result(nil)
    }
  }

  // UserDefaults에서 공유 데이터 삭제
  private func clearSharedData(result: @escaping FlutterResult) {
    let userDefaults = UserDefaults(suiteName: "group.\(hostAppBundleIdentifier)")

    print("[AppDelegate] 공유 데이터 삭제 시작")

    // 삭제 전 데이터 존재 확인
    let existsBefore = userDefaults?.object(forKey: sharedKey) != nil
    print("[AppDelegate] 삭제 전 데이터 존재: \(existsBefore)")

    // 데이터 삭제
    userDefaults?.removeObject(forKey: sharedKey)

    // 강제 동기화
    let syncSuccess = userDefaults?.synchronize() ?? false
    print("[AppDelegate] 동기화 성공: \(syncSuccess)")

    // 삭제 후 데이터 존재 확인
    let existsAfter = userDefaults?.object(forKey: sharedKey) != nil
    print("[AppDelegate] 삭제 후 데이터 존재: \(existsAfter)")

    if existsAfter {
      print("[AppDelegate] ⚠️ 경고: 데이터가 삭제되지 않았습니다!")
      result(false)
    } else {
      print("[AppDelegate] ✅ 공유 데이터 삭제 완료")
      result(true)
    }
  }

  // URL Scheme 핸들러 - Share Extension에서 앱 열기
  override func application(
    _ app: UIApplication,
    open url: URL,
    options: [UIApplication.OpenURLOptionsKey : Any] = [:]
  ) -> Bool {
    print("[AppDelegate] ✅ URL Scheme 호출됨: \(url.absoluteString)")
    print("[AppDelegate] URL Host/Path: \(url.host ?? "nil")/\(url.path)")

    // triptogether:// 스킴 확인
    if url.scheme == "triptogether" {
      print("[AppDelegate] 🚀 Share Extension에서 앱 실행됨!")

      // 앱이 포그라운드로 전환
      // 공유 데이터는 라이프사이클 리스너에서 자동 로드됨

      return true
    }

    return super.application(app, open: url, options: options)
  }

  // MARK: - UNUserNotificationCenterDelegate
  /// 포그라운드에서 알림을 받았을 때 처리
  /// 앱이 이미 실행 중일 때도 알림을 표시하도록 설정
  override func userNotificationCenter(
    _ center: UNUserNotificationCenter,
    willPresent notification: UNNotification,
    withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
  ) {
    print("[AppDelegate] 🔔 포그라운드 알림 수신: \(notification.request.identifier)")

    // 포그라운드에서도 배너, 사운드, 뱃지 표시
    completionHandler([.banner, .sound, .badge])
  }

  /// 사용자가 알림을 탭했을 때 처리
  /// Share Extension에서 발송한 "share_completed" 알림을 탭하면 앱이 실행되고 공유 데이터를 자동 로드합니다
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

      // 앱이 백그라운드에서 포그라운드로 전환됨
      // HomeScreen의 AppLifecycleListener가 onResume/onShow 이벤트를 감지하여
      // SharingService.checkForData()를 자동으로 호출합니다
      // 따라서 여기서는 별도의 데이터 로드 작업이 필요하지 않습니다
    }

    completionHandler()
  }

  // Share Extension 로그 파일 읽기
  private func getShareLog(result: @escaping FlutterResult) {
    let containerURL = FileManager.default.containerURL(
      forSecurityApplicationGroupIdentifier: "group.\(hostAppBundleIdentifier)"
    )

    guard let logFileURL = containerURL?.appendingPathComponent("share_extension_log.txt") else {
      result("로그 파일 경로를 찾을 수 없습니다")
      return
    }

    do {
      let logContent = try String(contentsOf: logFileURL, encoding: .utf8)
      result(logContent)
    } catch {
      result("로그 파일이 없거나 읽을 수 없습니다\n경로: \(logFileURL.path)")
    }
  }

  // Share Extension 로그 파일 삭제
  private func clearShareLog(result: @escaping FlutterResult) {
    let containerURL = FileManager.default.containerURL(
      forSecurityApplicationGroupIdentifier: "group.\(hostAppBundleIdentifier)"
    )

    guard let logFileURL = containerURL?.appendingPathComponent("share_extension_log.txt") else {
      result(false)
      return
    }

    do {
      if FileManager.default.fileExists(atPath: logFileURL.path) {
        try FileManager.default.removeItem(at: logFileURL)
        result(true)
      } else {
        result(true) // 파일이 없으면 성공으로 간주
      }
    } catch {
      print("[AppDelegate] ❌ 로그 삭제 실패: \(error)")
      result(false)
    }
  }

}

