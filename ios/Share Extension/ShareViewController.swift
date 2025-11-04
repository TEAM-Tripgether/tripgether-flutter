// Share Extension은 더 이상 receive_sharing_intent 패키지를 사용하지 않음
// UserDefaults를 통해 메인 앱과 직접 통신

//
//  ShareViewController.swift
//  Share Extension
//
//  Created by Hong_EuiMin on 9/28/25.
//

import UIKit
import Social
import MobileCoreServices
import Photos
import AVFoundation
import UserNotifications

class ShareViewController: UIViewController {
    // IMPORTANT: 메인 앱의 Bundle Identifier와 동일하게 설정 (App Group ID 접두사로도 사용)
    let hostAppBundleIdentifier = "com.tripgether.alom"
    let sharedKey = "ShareKey"
    var sharedMedia: [SharedMediaFile] = []
    var sharedText: [String] = []
    let imageContentType = kUTTypeImage as String
    let videoContentType = kUTTypeMovie as String
    let textContentType = kUTTypeText as String
    let urlContentType = kUTTypeURL as String
    let fileURLType = kUTTypeFileURL as String

    // 커스텀 UI 요소
    private var customContainerView: UIView?

    override func viewDidLoad() {
        super.viewDidLoad()

        // ✨ 즉시 처리 모드: 커스텀 UI와 함께 바로 데이터 처리
        // Share Extension을 선택하면 즉시 공유 데이터를 추출하고 저장
        print("[ShareExtension] 🚀 즉시 처리 모드 시작")

        // 커스텀 UI 설정
        setupCustomUI()

        // 백그라운드에서 데이터 처리
        processSharedContentImmediately()
    }

    // MARK: - 즉시 처리 모드

    /// 즉시 처리 모드: UI 표시 없이 공유 데이터를 바로 처리
    /// Share Extension 선택 즉시 데이터 추출 → 저장 → 앱 실행
    private func processSharedContentImmediately() {
        guard let extensionItem = extensionContext?.inputItems.first as? NSExtensionItem else {
            print("[ShareExtension] ⚠️ Extension Item이 없음")
            extensionContext?.completeRequest(returningItems: [], completionHandler: nil)
            return
        }

        guard let attachments = extensionItem.attachments, !attachments.isEmpty else {
            print("[ShareExtension] ⚠️ Attachment가 없음")
            extensionContext?.completeRequest(returningItems: [], completionHandler: nil)
            return
        }

        print("[ShareExtension] 📦 Attachment 개수: \(attachments.count)")

        // 모든 attachment를 비동기로 처리
        let dispatchGroup = DispatchGroup()
        var hasProcessedAnyItem = false

        for (index, attachment) in attachments.enumerated() {
            dispatchGroup.enter()

            // 우선순위: URL > 텍스트 > 이미지 > 비디오 > 파일
            if attachment.hasItemConformingToTypeIdentifier(urlContentType) {
                print("[ShareExtension] 🔗 URL 타입 감지 (index: \(index))")
                processUrlImmediately(attachment: attachment) { success in
                    if success { hasProcessedAnyItem = true }
                    dispatchGroup.leave()
                }
            } else if attachment.hasItemConformingToTypeIdentifier(textContentType) {
                print("[ShareExtension] 📝 텍스트 타입 감지 (index: \(index))")
                processTextImmediately(attachment: attachment) { success in
                    if success { hasProcessedAnyItem = true }
                    dispatchGroup.leave()
                }
            } else if attachment.hasItemConformingToTypeIdentifier(imageContentType) {
                print("[ShareExtension] 🖼️ 이미지 타입 감지 (index: \(index))")
                processImageImmediately(attachment: attachment) { success in
                    if success { hasProcessedAnyItem = true }
                    dispatchGroup.leave()
                }
            } else if attachment.hasItemConformingToTypeIdentifier(videoContentType) {
                print("[ShareExtension] 🎥 비디오 타입 감지 (index: \(index))")
                processVideoImmediately(attachment: attachment) { success in
                    if success { hasProcessedAnyItem = true }
                    dispatchGroup.leave()
                }
            } else if attachment.hasItemConformingToTypeIdentifier(fileURLType) {
                print("[ShareExtension] 📄 파일 타입 감지 (index: \(index))")
                processFileImmediately(attachment: attachment) { success in
                    if success { hasProcessedAnyItem = true }
                    dispatchGroup.leave()
                }
            } else {
                print("[ShareExtension] ⚠️ 알 수 없는 타입 (index: \(index))")
                dispatchGroup.leave()
            }
        }

        // 모든 attachment 처리 완료 후
        dispatchGroup.notify(queue: .main) {
            if hasProcessedAnyItem {
                print("[ShareExtension] ✅ 데이터 처리 완료 - 저장 및 앱 실행")
                self.saveAndLaunchApp()
            } else {
                print("[ShareExtension] ⚠️ 처리된 데이터 없음 - Extension 종료")
                self.extensionContext?.completeRequest(returningItems: [], completionHandler: nil)
            }
        }
    }

    /// URL을 즉시 처리 (비동기)
    private func processUrlImmediately(attachment: NSItemProvider, completion: @escaping (Bool) -> Void) {
        attachment.loadItem(forTypeIdentifier: urlContentType, options: nil) { [weak self] data, error in
            guard let self = self else {
                completion(false)
                return
            }

            if let error = error {
                print("[ShareExtension] ❌ URL 로드 실패: \(error)")
                completion(false)
                return
            }

            if let url = data as? URL {
                print("[ShareExtension] ✅ URL 추출 성공: \(url.absoluteString)")
                self.sharedText.append(url.absoluteString)
                completion(true)
            } else {
                print("[ShareExtension] ⚠️ URL 변환 실패")
                completion(false)
            }
        }
    }

    /// 텍스트를 즉시 처리 (비동기)
    private func processTextImmediately(attachment: NSItemProvider, completion: @escaping (Bool) -> Void) {
        attachment.loadItem(forTypeIdentifier: textContentType, options: nil) { [weak self] data, error in
            guard let self = self else {
                completion(false)
                return
            }

            if let error = error {
                print("[ShareExtension] ❌ 텍스트 로드 실패: \(error)")
                completion(false)
                return
            }

            if let text = data as? String {
                print("[ShareExtension] ✅ 텍스트 추출 성공: \(text)")
                self.sharedText.append(text)
                completion(true)
            } else {
                print("[ShareExtension] ⚠️ 텍스트 변환 실패")
                completion(false)
            }
        }
    }

    /// 이미지를 즉시 처리 (비동기)
    private func processImageImmediately(attachment: NSItemProvider, completion: @escaping (Bool) -> Void) {
        attachment.loadItem(forTypeIdentifier: imageContentType, options: nil) { [weak self] data, error in
            guard let self = self else {
                completion(false)
                return
            }

            if let error = error {
                print("[ShareExtension] ❌ 이미지 로드 실패: \(error)")
                completion(false)
                return
            }

            if let url = data as? URL {
                print("[ShareExtension] ✅ 이미지 URL 추출: \(url.path)")

                let fileName = self.getFileName(from: url, type: .image)
                let newPath = FileManager.default
                    .containerURL(forSecurityApplicationGroupIdentifier: "group.\(self.hostAppBundleIdentifier)")!
                    .appendingPathComponent(fileName)

                if self.copyFile(at: url, to: newPath) {
                    self.sharedMedia.append(SharedMediaFile(path: newPath.absoluteString, thumbnail: nil, duration: nil, type: .image))
                    completion(true)
                } else {
                    completion(false)
                }
            } else {
                print("[ShareExtension] ⚠️ 이미지 URL 변환 실패")
                completion(false)
            }
        }
    }

    /// 비디오를 즉시 처리 (비동기)
    private func processVideoImmediately(attachment: NSItemProvider, completion: @escaping (Bool) -> Void) {
        attachment.loadItem(forTypeIdentifier: videoContentType, options: nil) { [weak self] data, error in
            guard let self = self else {
                completion(false)
                return
            }

            if let error = error {
                print("[ShareExtension] ❌ 비디오 로드 실패: \(error)")
                completion(false)
                return
            }

            if let url = data as? URL {
                print("[ShareExtension] ✅ 비디오 URL 추출: \(url.path)")

                let fileName = self.getFileName(from: url, type: .video)
                let newPath = FileManager.default
                    .containerURL(forSecurityApplicationGroupIdentifier: "group.\(self.hostAppBundleIdentifier)")!
                    .appendingPathComponent(fileName)

                if self.copyFile(at: url, to: newPath) {
                    if let sharedFile = self.getSharedMediaFile(forVideo: newPath) {
                        self.sharedMedia.append(sharedFile)
                        completion(true)
                    } else {
                        completion(false)
                    }
                } else {
                    completion(false)
                }
            } else {
                print("[ShareExtension] ⚠️ 비디오 URL 변환 실패")
                completion(false)
            }
        }
    }

    /// 파일을 즉시 처리 (비동기)
    private func processFileImmediately(attachment: NSItemProvider, completion: @escaping (Bool) -> Void) {
        attachment.loadItem(forTypeIdentifier: fileURLType, options: nil) { [weak self] data, error in
            guard let self = self else {
                completion(false)
                return
            }

            if let error = error {
                print("[ShareExtension] ❌ 파일 로드 실패: \(error)")
                completion(false)
                return
            }

            if let url = data as? URL {
                print("[ShareExtension] ✅ 파일 URL 추출: \(url.path)")

                let fileName = self.getFileName(from: url, type: .file)
                let newPath = FileManager.default
                    .containerURL(forSecurityApplicationGroupIdentifier: "group.\(self.hostAppBundleIdentifier)")!
                    .appendingPathComponent(fileName)

                if self.copyFile(at: url, to: newPath) {
                    self.sharedMedia.append(SharedMediaFile(path: newPath.absoluteString, thumbnail: nil, duration: nil, type: .file))
                    completion(true)
                } else {
                    completion(false)
                }
            } else {
                print("[ShareExtension] ⚠️ 파일 URL 변환 실패")
                completion(false)
            }
        }
    }

    /// UserDefaults에 저장하고 앱 실행
    private func saveAndLaunchApp() {
        let userDefaults = UserDefaults(suiteName: "group.\(hostAppBundleIdentifier)")

        // 텍스트 데이터가 있으면 저장
        if !sharedText.isEmpty {
            print("[ShareExtension] 💾 텍스트 데이터 저장: \(sharedText)")
            userDefaults?.set(sharedText, forKey: sharedKey)
            saveDebugLog(message: "텍스트 저장 완료: \(sharedText.joined(separator: ", "))")
        }

        // 미디어 파일이 있으면 저장
        if !sharedMedia.isEmpty {
            print("[ShareExtension] 💾 미디어 데이터 저장: \(sharedMedia.count)개")
            userDefaults?.set(toData(data: sharedMedia), forKey: sharedKey)
            saveDebugLog(message: "미디어 저장 완료: \(sharedMedia.count)개")
        }

        // 동기화
        let syncSuccess = userDefaults?.synchronize() ?? false
        print("[ShareExtension] UserDefaults 동기화: \(syncSuccess ? "성공" : "실패")")

        if syncSuccess {
            // 앱 실행 (URL Scheme 방식)
            showSuccessAndDismiss()
        } else {
            print("[ShareExtension] ❌ 저장 실패")
            extensionContext?.completeRequest(returningItems: [], completionHandler: nil)
        }
    }

    private func handleText(content: NSExtensionItem, attachment: NSItemProvider, index: Int) {
        attachment.loadItem(forTypeIdentifier: textContentType, options: nil) { [weak self] data, error in
            if error == nil, let item = data as? String, let this = self {
                this.sharedText.append(item)
                if index == (content.attachments?.count ?? 1) - 1 {
                    let userDefaults = UserDefaults(suiteName: "group.\(this.hostAppBundleIdentifier)")

                    // 💾 단일 데이터 방식: 마지막 공유만 저장 (메모리 효율)
                    print("[ShareExtension] ✅ 단일 데이터 저장: \(this.sharedText)")

                    userDefaults?.set(this.sharedText, forKey: this.sharedKey)
                    userDefaults?.synchronize()

                    // 📝 로그 파일 생성
                    this.saveDebugLog(message: "텍스트 저장 완료: \(item)")

                    // UI 업데이트는 메인 스레드에서 실행
                    DispatchQueue.main.async {
                        this.showSuccessAndDismiss()
                    }
                }
            } else {
                DispatchQueue.main.async {
                    self?.dismissWithError()
                }
            }
        }
    }

    private func handleUrl(content: NSExtensionItem, attachment: NSItemProvider, index: Int) {
        attachment.loadItem(forTypeIdentifier: urlContentType, options: nil) { [weak self] data, error in
            if error == nil, let item = data as? URL, let this = self {
                this.sharedText.append(item.absoluteString)
                if index == (content.attachments?.count ?? 1) - 1 {
                    let userDefaults = UserDefaults(suiteName: "group.\(this.hostAppBundleIdentifier)")

                    // 💾 단일 데이터 방식: 마지막 공유만 저장 (메모리 효율)
                    print("[ShareExtension] ✅ 단일 데이터 저장: \(this.sharedText)")

                    userDefaults?.set(this.sharedText, forKey: this.sharedKey)
                    userDefaults?.synchronize()

                    // 📝 로그 파일 생성
                    this.saveDebugLog(message: "URL 저장 완료: \(item.absoluteString)")

                    // UI 업데이트는 메인 스레드에서 실행
                    DispatchQueue.main.async {
                        this.showSuccessAndDismiss()
                    }
                }
            } else {
                DispatchQueue.main.async {
                    self?.dismissWithError()
                }
            }
        }
    }

    private func handleImages(content: NSExtensionItem, attachment: NSItemProvider, index: Int) {
        attachment.loadItem(forTypeIdentifier: imageContentType, options: nil) { [weak self] data, error in
            if error == nil, let url = data as? URL, let this = self {
                let fileName = this.getFileName(from: url, type: .image)
                let newPath = FileManager.default
                    .containerURL(forSecurityApplicationGroupIdentifier: "group.\(this.hostAppBundleIdentifier)")!
                    .appendingPathComponent(fileName)
                let copied = this.copyFile(at: url, to: newPath)
                if copied {
                    this.sharedMedia.append(SharedMediaFile(path: newPath.absoluteString, thumbnail: nil, duration: nil, type: .image))
                }
                if index == (content.attachments?.count ?? 1) - 1 {
                    let userDefaults = UserDefaults(suiteName: "group.\(this.hostAppBundleIdentifier)")
                    userDefaults?.set(this.toData(data: this.sharedMedia), forKey: this.sharedKey)
                    userDefaults?.synchronize()

                    // UI 업데이트는 메인 스레드에서 실행
                    DispatchQueue.main.async {
                        this.showSuccessAndDismiss()
                    }
                }
            } else {
                DispatchQueue.main.async {
                    self?.dismissWithError()
                }
            }
        }
    }

    private func handleVideos(content: NSExtensionItem, attachment: NSItemProvider, index: Int) {
        attachment.loadItem(forTypeIdentifier: videoContentType, options: nil) { [weak self] data, error in
            if error == nil, let url = data as? URL, let this = self {
                let fileName = this.getFileName(from: url, type: .video)
                let newPath = FileManager.default
                    .containerURL(forSecurityApplicationGroupIdentifier: "group.\(this.hostAppBundleIdentifier)")!
                    .appendingPathComponent(fileName)
                let copied = this.copyFile(at: url, to: newPath)
                if copied {
                    guard let sharedFile = this.getSharedMediaFile(forVideo: newPath) else { return }
                    this.sharedMedia.append(sharedFile)
                }
                if index == (content.attachments?.count ?? 1) - 1 {
                    let userDefaults = UserDefaults(suiteName: "group.\(this.hostAppBundleIdentifier)")
                    userDefaults?.set(this.toData(data: this.sharedMedia), forKey: this.sharedKey)
                    userDefaults?.synchronize()

                    // UI 업데이트는 메인 스레드에서 실행
                    DispatchQueue.main.async {
                        this.showSuccessAndDismiss()
                    }
                }
            } else {
                DispatchQueue.main.async {
                    self?.dismissWithError()
                }
            }
        }
    }

    private func handleFiles(content: NSExtensionItem, attachment: NSItemProvider, index: Int) {
        attachment.loadItem(forTypeIdentifier: fileURLType, options: nil) { [weak self] data, error in
            if error == nil, let url = data as? URL, let this = self {
                let fileName = this.getFileName(from: url, type: .file)
                let newPath = FileManager.default
                    .containerURL(forSecurityApplicationGroupIdentifier: "group.\(this.hostAppBundleIdentifier)")!
                    .appendingPathComponent(fileName)
                let copied = this.copyFile(at: url, to: newPath)
                if copied {
                    this.sharedMedia.append(SharedMediaFile(path: newPath.absoluteString, thumbnail: nil, duration: nil, type: .file))
                }
                if index == (content.attachments?.count ?? 1) - 1 {
                    let userDefaults = UserDefaults(suiteName: "group.\(this.hostAppBundleIdentifier)")
                    userDefaults?.set(this.toData(data: this.sharedMedia), forKey: this.sharedKey)
                    userDefaults?.synchronize()

                    // UI 업데이트는 메인 스레드에서 실행
                    DispatchQueue.main.async {
                        this.showSuccessAndDismiss()
                    }
                }
            } else {
                DispatchQueue.main.async {
                    self?.dismissWithError()
                }
            }
        }
    }

    private func dismissWithError() {
        print("[ERROR] Error loading data!")
        let alert = UIAlertController(title: "Error", message: "Error loading data", preferredStyle: .alert)
        let action = UIAlertAction(title: "Error", style: .cancel) { _ in
            self.dismiss(animated: true, completion: nil)
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        extensionContext?.completeRequest(returningItems: [], completionHandler: nil)
    }

    /// 저장 성공 후 알림 제거 (UI는 수동으로 닫을 때까지 유지)
    /// 사용자가 "앱에서 보기" 버튼을 누르거나 스와이프로 닫기 전까지 UI 유지
    private func showSuccessAndDismiss() {
        print("[ShareExtension] 데이터 저장 완료 - UI는 사용자가 닫을 때까지 유지")

        // ⚠️ 알림 발송 제거 (커스텀 UI로 대체)
        // sendLocalNotification()

        // ⚠️ 자동 앱 실행 제거 (사용자가 버튼을 누를 때만 실행)
        // openMainApp()

        // ⚠️ 자동 닫기 제거 - UI는 ��용자가 수동으로 닫을 때까지 유지
        // 사용자는 다음 방법으로 닫을 수 있음:
        // 1. "앱에서 보기" 버튼 클릭 → openAppAndDismiss() 실행
        // 2. 아래로 스와이프 → handlePanGesture() 실행
        // 3. 배경 탭 → handleBackgroundTap() 실행

        print("[ShareExtension] ✅ UI 표시 완료 - 사용자 조작 대기 중")
    }

    /// Local Notification 발송
    /// 앱이 백그라운드/종료 상태일 때 사용자에게 저장 완료 피드백 제공
    /// 포그라운드일 때는 URL Scheme이 우선 동작하므로 알림은 자동 무시됨
    private func sendLocalNotification() {
        let content = UNMutableNotificationContent()
        content.title = "✓ Tripgether에 저장됨"
        content.body = "탭하여 공유된 콘텐츠를 확인하세요"
        content.sound = .default

        // 즉시 발송 (0.1초 후)
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 0.1, repeats: false)
        let request = UNNotificationRequest(
            identifier: "share_completed", // AppDelegate에서 이 ID로 탭 감지
            content: content,
            trigger: trigger
        )

        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("[ShareExtension] ❌ Notification 발송 실패: \(error)")
            } else {
                print("[ShareExtension] ✅ Notification 발송 성공")
            }
        }
    }

    /// URL Scheme를 통해 메인 앱 실행
    /// 여러 방법을 순차적으로 시도하여 앱 실행 성공률 극대화
    @objc private func openMainApp() {
        guard let url = URL(string: "tripgether://share") else {
            print("[ShareExtension] ❌ URL Scheme 생성 실패")
            return
        }

        print("[ShareExtension] 🚀 메인 앱 실행 시도: \(url.absoluteString)")

        // iOS 10+ 방���: UIApplication.shared를 통한 canOpenURL 체크 후 open
        if let application = UIApplication.value(forKeyPath: #keyPath(UIApplication.shared)) as? NSObject {
            let canOpenSelector = NSSelectorFromString("canOpenURL:")
            let openSelector = NSSelectorFromString("openURL:options:completionHandler:")

            // canOpenURL 체크
            if application.responds(to: canOpenSelector),
               let canOpen = application.perform(canOpenSelector, with: url)?.takeUnretainedValue() as? Bool,
               canOpen {
                print("[ShareExtension] ✅ URL Scheme 사용 가능 확인됨")

                // openURL 실행 (iOS 10+ 스타일)
                // ⚠️ perform은 최대 2개의 with 파라미터만 지원하므로 간소화
                if application.responds(to: openSelector) {
                    print("[ShareExtension] ⚠️ UIApplication.open() 호출 시도 (샌드박스 제약으로 실패 가능)")
                    // perform으로는 3개 인자를 전달할 수 없어 주석 처리
                    // application.perform(openSelector, with: url, with: options, with: nil)
                    return
                }
            } else {
                print("[ShareExtension] ⚠️ canOpenURL 체크 실패 - URL Scheme 접근 불가")
            }
        }

        // 방법 1 실패: NSExtensionContext.open() 시도 (iOS 13+)
        print("[ShareExtension] 🔄 Fallback: extensionContext.open() 시도")
        extensionContext?.open(url, completionHandler: { [weak self] success in
            if success {
                print("[ShareExtension] ✅ Method 2 성공: extensionContext.open()")
            } else {
                print("[ShareExtension] ⚠️ Method 2 실패: extensionContext.open()")
                // 최후의 수단: 알림 발송
                self?.fallbackToNotification()
            }
        })
    }

    /// Selector를 통한 URL 열기 (fallback method)
    private func openURLViaSelector(_ url: URL) {
        print("[ShareExtension] 🔄 Method 2 시도: Selector 방식")

        // UIApplication.shared.openURL 호출 시도
        let selector = NSSelectorFromString("openURL:")

        // UIApplication.shared를 동적으로 가져오기
        if let application = UIApplication.value(forKeyPath: #keyPath(UIApplication.shared)) as? NSObject {
            if application.responds(to: selector) {
                // perform 메서드로 openURL 실행
                application.perform(selector, with: url)
                print("[ShareExtension] ✅ Method 2 성공: UIApplication.shared.openURL()")
                return
            }
        }

        print("[ShareExtension] ⚠️ Method 2 실패: UIApplication 접근 불가")

        // 방법 3: 알림 발송 (최후의 수단)
        fallbackToNotification()
    }

    /// 알림 발송 (최후의 수단)
    private func fallbackToNotification() {
        print("[ShareExtension] 🔄 Method 3 시도: Notification 발송 (fallback)")

        let content = UNMutableNotificationContent()
        content.title = "✓ Tripgether에 저장됨"
        content.body = "탭하여 공유된 콘텐츠를 확인하세요"
        content.sound = .default

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 0.1, repeats: false)
        let request = UNNotificationRequest(
            identifier: "share_completed",
            content: content,
            trigger: trigger
        )

        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("[ShareExtension] ❌ Method 3 실패: Notification 발송 실패 - \(error)")
            } else {
                print("[ShareExtension] ✅ Method 3 성공: Notification 발송 완료")
            }
        }
    }

    func getExtension(from url: URL, type: SharedMediaType) -> String {
        let parts = url.lastPathComponent.components(separatedBy: ".")
        var ex: String? = parts.count > 1 ? parts.last : nil
        if ex == nil {
            switch type {
            case .image: ex = "PNG"
            case .video: ex = "MP4"
            case .file: ex = "TXT"
            }
        }
        return ex ?? "Unknown"
    }

    func getFileName(from url: URL, type: SharedMediaType) -> String {
        var name = url.lastPathComponent
        if name.isEmpty {
            name = UUID().uuidString + "." + getExtension(from: url, type: type)
        }
        return name
    }

    func copyFile(at srcURL: URL, to dstURL: URL) -> Bool {
        do {
            if FileManager.default.fileExists(atPath: dstURL.path) {
                try FileManager.default.removeItem(at: dstURL)
            }
            try FileManager.default.copyItem(at: srcURL, to: dstURL)
        } catch {
            print("Cannot copy item at \(srcURL) to \(dstURL): \(error)")
            return false
        }
        return true
    }

    private func getSharedMediaFile(forVideo: URL) -> SharedMediaFile? {
        let asset = AVAsset(url: forVideo)
        let duration = (CMTimeGetSeconds(asset.duration) * 1000).rounded()
        let thumbnailPath = getThumbnailPath(for: forVideo)
        if FileManager.default.fileExists(atPath: thumbnailPath.path) {
            return SharedMediaFile(path: forVideo.absoluteString, thumbnail: thumbnailPath.absoluteString, duration: duration, type: .video)
        }
        var saved = false
        let generator = AVAssetImageGenerator(asset: asset)
        generator.appliesPreferredTrackTransform = true
        generator.maximumSize = CGSize(width: 360, height: 360)
        do {
            let img = try generator.copyCGImage(at: CMTimeMakeWithSeconds(600, preferredTimescale: Int32(1.0)), actualTime: nil)
            try UIImage(cgImage: img).pngData()?.write(to: thumbnailPath)
            saved = true
        } catch {
            saved = false
        }
        return saved ? SharedMediaFile(path: forVideo.absoluteString, thumbnail: thumbnailPath.absoluteString, duration: duration, type: .video) : nil
    }

    private func getThumbnailPath(for url: URL) -> URL {
        let fileName = Data(url.lastPathComponent.utf8).base64EncodedString().replacingOccurrences(of: "==", with: "")
        let path = FileManager.default
            .containerURL(forSecurityApplicationGroupIdentifier: "group.\(hostAppBundleIdentifier)")!
            .appendingPathComponent("\(fileName).jpg")
        return path
    }

    class SharedMediaFile: Codable {
        var path: String
        var thumbnail: String?
        var duration: Double?
        var type: SharedMediaType

        init(path: String, thumbnail: String?, duration: Double?, type: SharedMediaType) {
            self.path = path
            self.thumbnail = thumbnail
            self.duration = duration
            self.type = type
        }

        func toString() {
            print("[SharedMediaFile]\n\tpath: \(self.path)\n\tthumbnail: \(String(describing: self.thumbnail))\n\tduration: \(String(describing: self.duration))\n\ttype: \(self.type)")
        }
    }

    enum SharedMediaType: Int, Codable {
        case image
        case video
        case file
    }

    func toData(data: [SharedMediaFile]) -> Data {
        let encodedData = try? JSONEncoder().encode(data)
        return encodedData ?? Data()
    }

    // MARK: - 커스텀 UI 설정

    /// 커스텀 Share Extension UI 설정
    /// 앱 대표 컬러(#664BAE) 바텀 시트 스타일의 "게시물을 추가했어요" 메시지와 "앱에서 보기" 버튼 표시
    /// 사용자가 수동으로 닫기 전까지 UI 유지 (자동 닫기 X)
    private func setupCustomUI() {
        // 배경 반투명 처리 (뒤에 공유하는 앱이 보이도록)
        view.backgroundColor = UIColor.black.withAlphaComponent(0.4)

        // 배경 탭 제스처 추가 (배경 탭 시 닫기)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleBackgroundTap))
        view.addGestureRecognizer(tapGesture)

        // 컨테이너 뷰 (앱 대표 컬러 #664BAE 바텀 시트)
        let containerView = UIView()
        containerView.backgroundColor = UIColor(red: 102/255, green: 75/255, blue: 174/255, alpha: 1.0) // #664BAE (앱 대표 컬러)
        containerView.layer.cornerRadius = 16
        containerView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner] // 상단 모서리만 둥글게
        containerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(containerView)
        self.customContainerView = containerView

        // 컨테이너 뷰 팬 제스처 추가 (아래로 스와이프 시 닫기)
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
        containerView.addGestureRecognizer(panGesture)

        // 상단 인디케이터 (스와이프 힌트)
        let indicatorView = UIView()
        indicatorView.backgroundColor = UIColor.white.withAlphaComponent(0.5)
        indicatorView.layer.cornerRadius = 2.5
        indicatorView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(indicatorView)

        // 아이콘 (체크마크)
        let iconImageView = UIImageView()
        iconImageView.image = UIImage(systemName: "checkmark.circle.fill")
        iconImageView.tintColor = .white
        iconImageView.contentMode = .scaleAspectFit
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(iconImageView)

        // 메시지 레이블
        let messageLabel = UILabel()
        messageLabel.text = "게시물을 추가했어요"
        messageLabel.textColor = .white
        messageLabel.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        messageLabel.textAlignment = .center
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(messageLabel)

        // "앱에서 보기" 버튼
        let openAppButton = UIButton(type: .system)
        openAppButton.setTitle("앱에서 보기", for: .normal)
        openAppButton.setTitleColor(UIColor(red: 102/255, green: 75/255, blue: 174/255, alpha: 1.0), for: .normal) // #664BAE
        openAppButton.backgroundColor = .white
        openAppButton.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        openAppButton.layer.cornerRadius = 8
        openAppButton.addTarget(self, action: #selector(openAppAndDismiss), for: .touchUpInside)
        openAppButton.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(openAppButton)

        // Auto Layout 제약조건
        NSLayoutConstraint.activate([
            // 컨테이너 뷰: 화면 하단에 배치
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            containerView.heightAnchor.constraint(equalToConstant: 180),

            // 상단 인디케이터: 스와이프 힌트
            indicatorView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 8),
            indicatorView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            indicatorView.widthAnchor.constraint(equalToConstant: 36),
            indicatorView.heightAnchor.constraint(equalToConstant: 5),

            // 아이콘: 상단 중앙
            iconImageView.topAnchor.constraint(equalTo: indicatorView.bottomAnchor, constant: 16),
            iconImageView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            iconImageView.widthAnchor.constraint(equalToConstant: 32),
            iconImageView.heightAnchor.constraint(equalToConstant: 32),

            // 메시지 레이블: 아이콘 아래
            messageLabel.topAnchor.constraint(equalTo: iconImageView.bottomAnchor, constant: 12),
            messageLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            messageLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),

            // 버튼: 하단
            openAppButton.topAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: 16),
            openAppButton.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            openAppButton.widthAnchor.constraint(equalToConstant: 120),
            openAppButton.heightAnchor.constraint(equalToConstant: 40)
        ])

        print("[ShareExtension] ✅ 커스텀 UI 설정 완료 (앱 대표 컬러 #664BAE)")
    }

    /// 배경 탭 시 Extension 닫기
    @objc private func handleBackgroundTap() {
        print("[ShareExtension] 배경 탭으로 Extension 닫기")
        extensionContext?.completeRequest(returningItems: [], completionHandler: nil)
    }

    /// 팬 제스처 처리 (아래로 스와이프 시 닫기)
    @objc private func handlePanGesture(_ gesture: UIPanGestureRecognizer) {
        guard let containerView = customContainerView else { return }

        let translation = gesture.translation(in: view)
        let velocity = gesture.velocity(in: view)

        switch gesture.state {
        case .changed:
            // 아래로만 드래그 가능 (위로는 막기)
            if translation.y > 0 {
                containerView.transform = CGAffineTransform(translationX: 0, y: translation.y)
            }

        case .ended:
            // 드래그 거리가 100pt 이상이거나 속도가 빠르면 닫기
            if translation.y > 100 || velocity.y > 500 {
                print("[ShareExtension] 스와이프로 Extension 닫기")
                UIView.animate(withDuration: 0.3, animations: {
                    containerView.transform = CGAffineTransform(translationX: 0, y: self.view.bounds.height)
                }) { _ in
                    self.extensionContext?.completeRequest(returningItems: [], completionHandler: nil)
                }
            } else {
                // 원래 위치로 되돌리기
                UIView.animate(withDuration: 0.3) {
                    containerView.transform = .identity
                }
            }

        case .cancelled, .failed:
            // 제스처 취소 시 원래 위치로
            UIView.animate(withDuration: 0.3) {
                containerView.transform = .identity
            }

        default:
            break
        }
    }

    /// "앱에서 보기" 버튼 클릭 시: 바로 앱 실행 + Extension 닫기
    @objc private func openAppAndDismiss() {
        print("[ShareExtension] '앱에서 보기' 버튼 클릭 - 앱으로 바로 이동 시도")

        guard let url = URL(string: "tripgether://share") else {
            print("[ShareExtension] ❌ URL Scheme 생성 실패")
            extensionContext?.completeRequest(returningItems: [], completionHandler: nil)
            return
        }

        // iOS 13+ extensionContext.open() 메서드로 앱 실행
        extensionContext?.open(url, completionHandler: { [weak self] success in
            if success {
                print("[ShareExtension] ✅ 앱 실행 성공!")
            } else {
                print("[ShareExtension] ⚠️ extensionContext.open() 실패 - URL Scheme 방식 시도")

                // Fallback: URL Scheme 직접 실행 시도
                if let application = UIApplication.value(forKeyPath: #keyPath(UIApplication.shared)) as? UIApplication {
                    application.open(url, options: [:], completionHandler: { opened in
                        print("[ShareExtension] UIApplication.open 결과: \(opened)")
                    })
                }
            }

            // Extension 닫기
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                self?.extensionContext?.completeRequest(returningItems: [], completionHandler: nil)
            }
        })
    }

    /// 백그라운드 저장 확인용 디버그 로그 파일 생성
    /// App Groups 컨테이너에 로그 파일을 저장하여 앱에서 확인 가능
    /// 최신 5개 로그만 유지 (로그 로테이션)
    private func saveDebugLog(message: String) {
        let containerURL = FileManager.default.containerURL(
            forSecurityApplicationGroupIdentifier: "group.\(hostAppBundleIdentifier)"
        )

        guard let logFileURL = containerURL?.appendingPathComponent("share_extension_log.txt") else {
            print("[ShareExtension] ❌ 로그 파일 경로 생성 실패")
            return
        }

        let timestamp = DateFormatter.localizedString(from: Date(), dateStyle: .short, timeStyle: .medium)
        let logMessage = "[\(timestamp)] \(message)\n"

        // 기존 로그 읽기
        var existingLog = ""
        if let existing = try? String(contentsOf: logFileURL, encoding: .utf8) {
            existingLog = existing
        }

        // 로그 로테이션: 최신 5개만 유지
        // 1. 기존 로그를 줄 단위로 분리 (빈 줄 제외)
        var logEntries = existingLog
            .components(separatedBy: "\n")
            .filter { !$0.trimmingCharacters(in: .whitespaces).isEmpty }

        // 2. 새 로그 메시지 추가 (개행 문자 제거하여 추가)
        logEntries.append(logMessage.trimmingCharacters(in: .newlines))

        // 3. 5개 초과 시 오래된 것부터 제거 (suffix로 최신 5개만 유지)
        if logEntries.count > 5 {
            logEntries = Array(logEntries.suffix(5))
        }

        // 4. 최종 로그 문자열 생성 (각 엔트리를 줄바꿈으로 연결)
        let updatedLog = logEntries.joined(separator: "\n") + "\n"

        // 로그 파일 저장
        do {
            try updatedLog.write(to: logFileURL, atomically: true, encoding: .utf8)
            print("[ShareExtension] 📝 로그 저장 완료: \(logFileURL.path)")
        } catch {
            print("[ShareExtension] ❌ 로그 저장 실패: \(error)")
        }
    }
}

extension Array {
    subscript (safe index: UInt) -> Element? {
        return Int(index) < count ? self[Int(index)] : nil
    }
}
