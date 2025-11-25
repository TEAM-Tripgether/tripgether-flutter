import Flutter
import UIKit
import UserNotifications
import flutter_local_notifications
import GoogleMaps

@main
@objc class AppDelegate: FlutterAppDelegate {

  private let hostAppBundleIdentifier = "com.tripgether.alom"

  // Queue Keys
  private let queueKey = "ShareQueue"
  private let legacyKey = "ShareKey"  // 마이그레이션용

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    // Google Maps SDK 초기화
    // Info.plist에서 GMSApiKey 읽기 (환경 변수로부터 주입됨)
    if let apiKey = Bundle.main.object(forInfoDictionaryKey: "GMSApiKey") as? String {
      GMSServices.provideAPIKey(apiKey)
    } else {
      fatalError("Google Maps API Key가 Info.plist에 설정되지 않았습니다")
    }

    GeneratedPluginRegistrant.register(with: self)

    // Flutter Local Notifications Plugin 설정
    // LocalNotificationService에서 사용하는 flutter_local_notifications 패키지를 위한 설정
    FlutterLocalNotificationsPlugin.setPluginRegistrantCallback { (registry) in
      GeneratedPluginRegistrant.register(with: registry)
    }

    // 알림 권한 요청 (Share Extension에서 알림을 발송하기 위해 필요)
    requestNotificationPermission()

    // 알림 델리게이트 설정 (알림 탭 처리를 위해)
    // iOS 10.0 이상에서 UNUserNotificationCenterDelegate 사용
    if #available(iOS 10.0, *) {
      UNUserNotificationCenter.current().delegate = self
    }

    // Legacy 데이터 마이그레이션 (ShareKey → ShareQueue)
    migrateOldShareKey()

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
    case "getPendingUrls":  // 큐 기능
      getPendingUrls(result: result)
    case "clearPendingUrls":  // 큐 기능
      clearPendingUrls(result: result)
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

    if let sharedData = userDefaults?.object(forKey: legacyKey) {
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
    let existsBefore = userDefaults?.object(forKey: legacyKey) != nil
    print("[AppDelegate] 삭제 전 데이터 존재: \(existsBefore)")

    // 데이터 삭제
    userDefaults?.removeObject(forKey: legacyKey)

    // 강제 동기화
    let syncSuccess = userDefaults?.synchronize() ?? false
    print("[AppDelegate] 동기화 성공: \(syncSuccess)")

    // 삭제 후 데이터 존재 확인
    let existsAfter = userDefaults?.object(forKey: legacyKey) != nil
    print("[AppDelegate] 삭제 후 데이터 존재: \(existsAfter)")

    if existsAfter {
      print("[AppDelegate] ⚠️ 경고: 데이터가 삭제되지 않았습니다!")
      result(false)
    } else {
      print("[AppDelegate] ✅ 공유 데이터 삭제 완료")
      result(true)
    }
  }

  // MARK: - Queue Methods

  /// Legacy "ShareKey" 데이터를 "ShareQueue"로 마이그레이션
  /// 앱 시작 시 한 번만 실행되며, 기존 사용자의 데이터 손실 방지
  private func migrateOldShareKey() {
    let userDefaults = UserDefaults(suiteName: "group.\(hostAppBundleIdentifier)")

    // Legacy 키에 데이터가 있는지 확인
    guard let legacyData = userDefaults?.array(forKey: legacyKey) as? [String] else {
      print("[AppDelegate] 🔄 마이그레이션 불필요 - Legacy 데이터 없음")
      return
    }

    print("[AppDelegate] 🔄 Legacy 데이터 발견 - 마이그레이션 시작")
    print("[AppDelegate] Legacy 데이터: \(legacyData.count)개 항목")

    // 기존 큐 읽기
    var queue = userDefaults?.array(forKey: queueKey) as? [[String]] ?? []

    // Legacy 데이터를 큐에 추가
    queue.append(legacyData)

    // 큐 저장
    userDefaults?.set(queue, forKey: queueKey)

    // Legacy 키 삭제
    userDefaults?.removeObject(forKey: legacyKey)

    // 동기화
    let syncSuccess = userDefaults?.synchronize() ?? false
    print("[AppDelegate] 마이그레이션 완료 - 동기화: \(syncSuccess ? "성공" : "실패")")
    print("[AppDelegate] ✅ Legacy 데이터가 큐로 이동됨 (큐 크기: \(queue.count))")
  }

  /// 큐에 저장된 모든 URL 가져오기 (2D 배열 → 1D 배열 변환)
  /// - Parameter result: Flutter로 반환할 결과 ([String] 형태)
  private func getPendingUrls(result: @escaping FlutterResult) {
    print("[AppDelegate] ═══════════════════════════════════════")
    print("[AppDelegate] 📥 getPendingUrls 시작")
    print("[AppDelegate] App Group ID: group.\(hostAppBundleIdentifier)")
    print("[AppDelegate] Queue Key: \(queueKey)")

    let userDefaults = UserDefaults(suiteName: "group.\(hostAppBundleIdentifier)")

    if userDefaults == nil {
      print("[AppDelegate] ❌ UserDefaults 획득 실패 - App Group 설정 확인 필요")
      print("[AppDelegate] ═══════════════════════════════════════")
      result([])
      return
    }
    print("[AppDelegate] ✅ UserDefaults 획득 성공")

    guard let queue = userDefaults?.array(forKey: queueKey) as? [[String]] else {
      print("[AppDelegate] ❌ 큐 없음 또는 타입 불일치")

      // 디버깅: 실제 저장된 값의 타입 확인
      if let rawValue = userDefaults?.object(forKey: queueKey) {
        print("[AppDelegate] 큐 키에 저장된 값 타입: \(type(of: rawValue))")
        print("[AppDelegate] 큐 키에 저장된 값: \(rawValue)")
      } else {
        print("[AppDelegate] 큐 키에 저장된 값 없음 (nil)")
      }

      print("[AppDelegate] ═══════════════════════════════════════")
      result([])
      return
    }

    print("[AppDelegate] ✅ 큐 발견 - 크기: \(queue.count)개")
    print("[AppDelegate] 큐 내용 (2D 배열): \(queue)")

    // 2D 배열을 1D 배열로 평탄화 (flatMap)
    let urls = queue.flatMap { $0 }

    print("[AppDelegate] 평탄화 결과: \(urls.count)개 URL")
    print("[AppDelegate] URL 목록:")
    for (index, url) in urls.enumerated() {
      print("[AppDelegate]   [\(index + 1)] \(url)")
    }

    print("[AppDelegate] ✅ getPendingUrls 완료")
    print("[AppDelegate] ═══════════════════════════════════════")

    result(urls)
  }

  /// 큐 전체 삭제
  /// - Parameter result: Flutter로 반환할 결과 (Bool)
  private func clearPendingUrls(result: @escaping FlutterResult) {
    print("[AppDelegate] ═══════════════════════════════════════")
    print("[AppDelegate] 🗑️ clearPendingUrls 시작")
    print("[AppDelegate] App Group ID: group.\(hostAppBundleIdentifier)")
    print("[AppDelegate] Queue Key: \(queueKey)")

    let userDefaults = UserDefaults(suiteName: "group.\(hostAppBundleIdentifier)")

    if userDefaults == nil {
      print("[AppDelegate] ❌ UserDefaults 획득 실패")
      print("[AppDelegate] ═══════════════════════════════════════")
      result(false)
      return
    }
    print("[AppDelegate] ✅ UserDefaults 획득 성공")

    // 삭제 전 데이터 존재 확인
    let existsBefore = userDefaults?.object(forKey: queueKey) != nil
    print("[AppDelegate] 삭제 전 큐 존재: \(existsBefore)")

    if existsBefore {
      if let queueBefore = userDefaults?.array(forKey: queueKey) as? [[String]] {
        print("[AppDelegate] 삭제 전 큐 크기: \(queueBefore.count)개")
      }
    }

    // 큐 삭제
    print("[AppDelegate] removeObject(forKey:) 호출")
    userDefaults?.removeObject(forKey: queueKey)

    // 강제 동기화
    print("[AppDelegate] synchronize() 호출")
    let syncSuccess = userDefaults?.synchronize() ?? false
    print("[AppDelegate] 동기화 결과: \(syncSuccess ? "✅ 성공" : "❌ 실패")")

    // 삭제 후 데이터 존재 확인
    let existsAfter = userDefaults?.object(forKey: queueKey) != nil
    print("[AppDelegate] 삭제 후 큐 존재: \(existsAfter)")

    if existsAfter {
      print("[AppDelegate] ⚠️ 경고: 큐가 삭제되지 않았습니다!")
      if let queueAfter = userDefaults?.array(forKey: queueKey) as? [[String]] {
        print("[AppDelegate] 삭제 후에도 남아있는 큐 크기: \(queueAfter.count)개")
      }
      print("[AppDelegate] ═══════════════════════════════════════")
      result(false)
    } else {
      print("[AppDelegate] ✅ URL 큐 삭제 완료")
      print("[AppDelegate] ═══════════════════════════════════════")
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

    // tripgether:// 스킴 확인
    if url.scheme == "tripgether" {
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
  /// Share Extension에서 발송한 알림을 탭하면 앱이 실행되고 공유 데이터를 자동 로드합니다
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

    // "앱에서 보기" 버튼으로 발송된 알림
    if identifier == "open_app_notification" {
      print("[AppDelegate] 🚀 앱 열기 알림 탭 - 앱이 실행되었습니다")
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

