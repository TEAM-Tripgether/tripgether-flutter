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

class ShareViewController: SLComposeServiceViewController {
    // IMPORTANT: 메인 앱의 Bundle Identifier와 동일하게 설정 (App Group ID 접두사로도 사용)
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

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // viewDidAppear에서는 UI 설정만 수행
    }

    override func didSelectPost() {
        print("[ShareViewController] didSelectPost 호출됨")

        // 사용자가 Post 버튼을 눌렀을 때 공유 데이터 처리
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
        }

        // 첨부파일이 없는 경우 (텍스트만 있는 경우)
        if let content = extensionContext?.inputItems.first as? NSExtensionItem {
            if content.attachments?.isEmpty ?? true {
                // 텍스트 내용 확인
                let sharedTextContent = contentText ?? ""
                if !sharedTextContent.isEmpty {
                    sharedText.append(sharedTextContent)
                    let userDefaults = UserDefaults(suiteName: "group.\(hostAppBundleIdentifier)")
                    userDefaults?.set(sharedText, forKey: sharedKey)
                    userDefaults?.synchronize()
                    showSuccessAndDismiss()
                } else {
                    extensionContext?.completeRequest(returningItems: [], completionHandler: nil)
                }
            }
        }
    }

    override func configurationItems() -> [Any]! {
        return []
    }

    private func handleText(content: NSExtensionItem, attachment: NSItemProvider, index: Int) {
        attachment.loadItem(forTypeIdentifier: textContentType, options: nil) { [weak self] data, error in
            if error == nil, let item = data as? String, let this = self {
                this.sharedText.append(item)
                if index == (content.attachments?.count ?? 1) - 1 {
                    let userDefaults = UserDefaults(suiteName: "group.\(this.hostAppBundleIdentifier)")
                    userDefaults?.set(this.sharedText, forKey: this.sharedKey)
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

    private func handleUrl(content: NSExtensionItem, attachment: NSItemProvider, index: Int) {
        attachment.loadItem(forTypeIdentifier: urlContentType, options: nil) { [weak self] data, error in
            if error == nil, let item = data as? URL, let this = self {
                this.sharedText.append(item.absoluteString)
                if index == (content.attachments?.count ?? 1) - 1 {
                    let userDefaults = UserDefaults(suiteName: "group.\(this.hostAppBundleIdentifier)")
                    userDefaults?.set(this.sharedText, forKey: this.sharedKey)
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

    /// 저장 성공 후 Local Notification 발송
    private func showSuccessAndDismiss() {
        // Local Notification 발송 (앱이 종료되어 있어도 작동)
        sendLocalNotification()

        // Extension 닫기
        extensionContext?.completeRequest(returningItems: [], completionHandler: nil)
    }

    /// Local Notification 발송
    /// 사용자가 알림을 탭하면 앱이 실행됨
    private func sendLocalNotification() {
        let content = UNMutableNotificationContent()
        content.title = "✓ TripTogether에 저장됨"
        content.body = "탭하여 공유된 콘텐츠를 확인하세요"
        content.sound = .default

        // 즉시 발송
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 0.1, repeats: false)
        let request = UNNotificationRequest(identifier: "share_completed", content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("[ShareExtension] ❌ Notification 발송 실패: \(error)")
            } else {
                print("[ShareExtension] ✅ Notification 발송 성공")
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
}

extension Array {
    subscript (safe index: UInt) -> Element? {
        return Int(index) < count ? self[Int(index)] : nil
    }
}
