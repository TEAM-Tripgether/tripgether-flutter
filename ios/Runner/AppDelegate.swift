import Flutter
import UIKit

@main
@objc class AppDelegate: FlutterAppDelegate {

  private let hostAppBundleIdentifier = "com.example.triptogether"
  private let sharedKey = "ShareKey"

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)

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

  // Method Channel 처리
  private func handleMethodCall(call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "getSharedData":
      getSharedData(result: result)
    case "clearSharedData":
      clearSharedData(result: result)
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

  // URL 스킴을 통한 앱 호출 처리 (Share Extension → 메인 앱)
  override func application(
    _ app: UIApplication,
    open url: URL,
    options: [UIApplication.OpenURLOptionsKey : Any] = [:]
  ) -> Bool {

    // ShareMedia:// 스킴 확인 (Share Extension에서 사용)
    if url.scheme == "ShareMedia" {
      // URL에서 데이터 키와 타입 추출: ShareMedia://dataUrl=ShareKey#media
      let urlString = url.absoluteString
      print("[AppDelegate] Share Extension에서 호출됨: \(urlString)")

      // UserDefaults에서 데이터를 읽어 Flutter로 전달하는 것은
      // Flutter의 SharingService에서 주기적으로 확인함
      return true
    }

    // 다른 URL 스킴은 부모 클래스에서 처리
    return super.application(app, open: url, options: options)
  }
}
