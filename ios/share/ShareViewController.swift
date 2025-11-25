//
//  ShareViewController.swift
//  Share Extension
//
//  iOS 18+ Compatible Implementation
//  UIViewController 기반 Share Extension
//  바텀 시트 UI 없이 즉시 공유 처리 → 메인 앱에서 폴링으로 확인
//

import UIKit
import UniformTypeIdentifiers

/// Share Extension의 메인 뷰 컨트롤러
/// iOS 18+ 호환 UIViewController 기반 구현
/// 공유 즉시 처리 후 App Group 큐에 저장
@objc(ShareViewController)
class ShareViewController: UIViewController {

    // MARK: - Configuration

    /// 메인 앱의 Bundle Identifier (App Group ID 접두사로도 사용)
    private let hostAppBundleIdentifier = "com.tripgether.alom"

    /// UserDefaults 공유 키 (큐 방식)
    private let queueKey = "ShareQueue"

    /// 최대 큐 크기 (FIFO 방식으로 오래된 항목 자동 제거)
    private let maxQueueSize = 100

    /// 추출된 공유 데이터 (URL 또는 텍스트)
    private var sharedText: [String] = []

    /// iOS 14+ 권장: UTType을 직접 사용하는 현대적인 방식
    /// URL과 텍스트만 지원 (우선순위 순서: URL > PlainText > Text)
    private let supportedTypes: [UTType] = [.url, .plainText, .text]

    // MARK: - Debug Configuration

    #if DEBUG
    private let isDebugLoggingEnabled = true
    #else
    private let isDebugLoggingEnabled = false
    #endif

    // MARK: - App Group State

    private var hasShownAppGroupError = false

    // MARK: - App Group

    private var appGroupIdentifier: String {
        "group.\(hostAppBundleIdentifier)"
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        print("[ShareExtension] 🚀 iOS 18+ Share Extension 시작")

        // View 배경을 투명하게 설정
        view.backgroundColor = .clear

        // 즉시 데이터 처리 시작 (UI 없이)
        Task {
            await processSharedContent()
        }
    }

    // MARK: - Data Processing

    /// 공유 데이터 처리 메인 메서드
    /// async/await 패턴을 활용한 비동기 처리
    private func processSharedContent() async {
        do {
            let sharedItems = try await extractSharedItems()

            if sharedItems.isEmpty {
                print("[ShareExtension] ⚠️ 처리된 데이터 없음 - Extension 종료")
                await MainActor.run {
                    extensionContext?.completeRequest(returningItems: [], completionHandler: nil)
                }
                return
            }

            print("[ShareExtension] ✅ 데이터 추출 완료 - \(sharedItems.count)개 항목")
            self.sharedText = sharedItems

            await MainActor.run {
                self.saveAndComplete()
            }
        } catch {
            print("[ShareExtension] ❌ 데이터 처리 오류: \(error)")
            await MainActor.run {
                self.extensionContext?.completeRequest(returningItems: [], completionHandler: nil)
            }
        }
    }

    /// NSExtensionContext의 inputItems에서 데이터 추출
    /// - Returns: 추출된 텍스트/URL 배열
    /// - Throws: 데이터 추출 중 발생한 오류
    private func extractSharedItems() async throws -> [String] {
        guard let inputItems = extensionContext?.inputItems as? [NSExtensionItem] else {
            print("[ShareExtension] ⚠️ NSExtensionContext에 inputItems 없음")
            return []
        }

        print("[ShareExtension] 📦 InputItem 개수: \(inputItems.count)")

        var extractedItems: [String] = []

        for (itemIndex, inputItem) in inputItems.enumerated() {
            guard let attachments = inputItem.attachments else {
                print("[ShareExtension] ⚠️ InputItem[\(itemIndex)]에 attachments 없음")
                continue
            }

            print("[ShareExtension] 📎 InputItem[\(itemIndex)] - Attachment 개수: \(attachments.count)")

            for (attachmentIndex, attachment) in attachments.enumerated() {
                if let item = try? await extractItem(from: attachment, index: attachmentIndex) {
                    extractedItems.append(item)
                }
            }
        }

        return extractedItems
    }

    /// NSItemProvider에서 지원하는 타입에 따라 데이터 추출
    /// - Parameters:
    ///   - attachment: NSItemProvider
    ///   - index: Attachment 인덱스 (로깅용)
    /// - Returns: 추출된 텍스트 또는 URL 문자열
    private func extractItem(from attachment: NSItemProvider, index: Int) async throws -> String? {
        // 우선순위 1: URL (웹 링크 공유 시 가장 일반적)
        if attachment.hasItemConformingToTypeIdentifier(UTType.url.identifier) {
            print("[ShareExtension] 🔗 URL 타입 감지 (index: \(index))")

            return try await withCheckedThrowingContinuation { continuation in
                attachment.loadItem(forTypeIdentifier: UTType.url.identifier, options: nil) { data, error in
                    if let error = error {
                        print("[ShareExtension] ❌ URL 로드 실패: \(error)")
                        continuation.resume(returning: nil)
                        return
                    }

                    if let url = data as? URL {
                        print("[ShareExtension] ✅ URL 추출 성공: \(url.absoluteString)")
                        continuation.resume(returning: url.absoluteString)
                    } else {
                        print("[ShareExtension] ⚠️ URL 변환 실패")
                        continuation.resume(returning: nil)
                    }
                }
            }
        }

        // 우선순위 2: Plain Text
        if attachment.hasItemConformingToTypeIdentifier(UTType.plainText.identifier) {
            print("[ShareExtension] 📝 Plain Text 타입 감지 (index: \(index))")

            return try await withCheckedThrowingContinuation { continuation in
                attachment.loadItem(forTypeIdentifier: UTType.plainText.identifier, options: nil) { data, error in
                    if let error = error {
                        print("[ShareExtension] ❌ Plain Text 로드 실패: \(error)")
                        continuation.resume(returning: nil)
                        return
                    }

                    if let text = data as? String {
                        print("[ShareExtension] ✅ Plain Text 추출 성공: \(text)")
                        continuation.resume(returning: text)
                    } else {
                        print("[ShareExtension] ⚠️ Plain Text 변환 실패")
                        continuation.resume(returning: nil)
                    }
                }
            }
        }

        // 우선순위 3: 일반 Text
        if attachment.hasItemConformingToTypeIdentifier(UTType.text.identifier) {
            print("[ShareExtension] 📄 Text 타입 감지 (index: \(index))")

            return try await withCheckedThrowingContinuation { continuation in
                attachment.loadItem(forTypeIdentifier: UTType.text.identifier, options: nil) { data, error in
                    if let error = error {
                        print("[ShareExtension] ❌ Text 로드 실패: \(error)")
                        continuation.resume(returning: nil)
                        return
                    }

                    if let text = data as? String {
                        print("[ShareExtension] ✅ Text 추출 성공: \(text)")
                        continuation.resume(returning: text)
                    } else {
                        print("[ShareExtension] ⚠️ Text 변환 실패")
                        continuation.resume(returning: nil)
                    }
                }
            }
        }

        print("[ShareExtension] ⚠️ 지원하지 않는 타입 (index: \(index)) - URL과 텍스트만 지원")
        return nil
    }

    // MARK: - Data Storage & Completion

    /// 데이터 저장 후 즉시 Extension 종료
    private func saveAndComplete() {
        guard !sharedText.isEmpty else {
            print("[ShareExtension] ⚠️ 저장할 데이터가 없습니다")
            extensionContext?.completeRequest(returningItems: [], completionHandler: nil)
            return
        }

        logSecure("💾 큐에 데이터 저장", sensitiveData: sharedText.joined(separator: ", "))

        let saveSuccess = saveToQueue()

        if saveSuccess {
            // 디버그 로그 저장
            let urlsOnly = sharedText.filter { $0.hasPrefix("http://") || $0.hasPrefix("https://") }
            let urlsToLog = urlsOnly.joined(separator: " | ")
            saveDebugLog(message: "URL 큐에 저장: \(urlsToLog)")
        } else {
            print("[ShareExtension] ❌ 큐 저장 실패")
        }

        // 즉시 Extension 종료
        extensionContext?.completeRequest(returningItems: [], completionHandler: nil)
    }

    /// 큐에 공유 데이터를 저장 (FIFO 방식, 최대 100개)
    /// - Returns: 저장 성공 여부
    private func saveToQueue() -> Bool {
        print("[ShareExtension] ═══════════════════════════════════════")
        print("[ShareExtension] 📥 saveToQueue 시작")
        print("[ShareExtension] sharedText 원본: \(sharedText)")

        guard let userDefaults = appGroupUserDefaults() else {
            print("[ShareExtension] ❌ App Group UserDefaults 실패!")
            print("[ShareExtension] App Group ID: group.\(hostAppBundleIdentifier)")
            print("[ShareExtension] ═══════════════════════════════════════")
            return false
        }
        print("[ShareExtension] ✅ UserDefaults 획득 성공")

        guard !sharedText.isEmpty else {
            print("[ShareExtension] ⚠️ sharedText가 비어있음")
            print("[ShareExtension] ═══════════════════════════════════════")
            return false
        }

        // URL만 필터링 (Instagram 텍스트 제목 제외)
        let urls = sharedText.filter { text in
            text.hasPrefix("http://") || text.hasPrefix("https://")
        }

        print("[ShareExtension] 필터링 결과 - 원본: \(sharedText.count)개 → URL: \(urls.count)개")
        print("[ShareExtension] 필터링된 URL들: \(urls)")

        guard !urls.isEmpty else {
            print("[ShareExtension] ❌ 유효한 URL 없음 - 큐에 저장 안 함")
            print("[ShareExtension] sharedText 내용: \(sharedText)")
            print("[ShareExtension] ═══════════════════════════════════════")
            return false
        }

        // 기존 큐 읽기 (2D 배열: [[String]])
        var queue = userDefaults.array(forKey: queueKey) as? [[String]] ?? []
        print("[ShareExtension] 📦 기존 큐 크기: \(queue.count)개")

        // 새 데이터 추가 (URL만)
        queue.append(urls)
        print("[ShareExtension] ➕ 새 데이터 추가: \(urls.count)개 URL")
        print("[ShareExtension] 추가 후 큐 크기: \(queue.count)개")

        // FIFO: 큐 크기가 maxQueueSize를 초과하면 오래된 항목 제거
        if queue.count > maxQueueSize {
            let removeCount = queue.count - maxQueueSize
            queue.removeFirst(removeCount)
            print("[ShareExtension] 🗑️ 오래된 항목 \(removeCount)개 제거 (FIFO)")
        }

        // 큐 저장
        userDefaults.set(queue, forKey: queueKey)
        print("[ShareExtension] 💾 UserDefaults에 큐 저장 완료")

        // 동기화
        let syncSuccess = userDefaults.synchronize()
        print("[ShareExtension] 🔄 동기화 결과: \(syncSuccess ? "✅ 성공" : "❌ 실패")")

        // 저장 직후 즉시 재확인 (검증)
        let verifyQueue = userDefaults.array(forKey: queueKey) as? [[String]] ?? []
        print("[ShareExtension] 🔍 저장 검증 - 큐 크기: \(verifyQueue.count)개")

        if verifyQueue.count != queue.count {
            print("[ShareExtension] ⚠️ 경고: 저장된 큐 크기 불일치!")
            print("[ShareExtension] 예상: \(queue.count)개, 실제: \(verifyQueue.count)개")
        }

        print("[ShareExtension] ✅ saveToQueue 완료")
        print("[ShareExtension] ═══════════════════════════════════════")

        return syncSuccess
    }

    // MARK: - App Group Utilities

    private func appGroupUserDefaults() -> UserDefaults? {
        if let userDefaults = UserDefaults(suiteName: appGroupIdentifier) {
            return userDefaults
        }

        handleMissingAppGroupConfiguration()
        return nil
    }

    private func appGroupContainerURL() -> URL? {
        if let url = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: appGroupIdentifier) {
            return url
        }

        handleMissingAppGroupConfiguration()
        return nil
    }

    private func handleMissingAppGroupConfiguration() {
        guard !hasShownAppGroupError else { return }
        hasShownAppGroupError = true

        let message = """
        App Group \(appGroupIdentifier)을(를) 사용할 수 없습니다.
        Xcode의 Signing & Capabilities와 Apple Developer 계정에서 동일한 App Group을 활성화했는지 확인하세요.
        """
        print("[ShareExtension] ❌ App Group 누락 - \(message)")

        // Extension 즉시 종료 (UI 없이)
        extensionContext?.completeRequest(returningItems: [], completionHandler: nil)
    }

    // MARK: - Debug Utilities

    /// 민감 데이터를 마스킹하여 로깅
    private func logSecure(_ message: String, sensitiveData: String? = nil) {
        guard isDebugLoggingEnabled else { return }

        if let data = sensitiveData {
            let masked = data.prefix(10) + "***" + data.suffix(5)
            print("[ShareExtension] \(message): \(masked)")
        } else {
            print("[ShareExtension] \(message)")
        }
    }

    /// 디버그 로그 파일 생성 (App Groups 컨테이너)
    private func saveDebugLog(message: String) {
        guard let containerURL = appGroupContainerURL() else {
            print("[ShareExtension] ❌ 로그 파일 경로 생성 실패 - App Group 없음")
            return
        }

        let logFileURL = containerURL.appendingPathComponent("share_extension_log.txt")

        let timestamp = DateFormatter.localizedString(from: Date(), dateStyle: .short, timeStyle: .medium)
        let logMessage = "[\(timestamp)] \(message)\n"

        // 기존 로그 읽기
        var existingLog = ""
        if let existing = try? String(contentsOf: logFileURL, encoding: .utf8) {
            existingLog = existing
        }

        // 로그 로테이션: 최신 5개만 유지
        var logEntries = existingLog
            .components(separatedBy: "\n")
            .filter { !$0.trimmingCharacters(in: .whitespaces).isEmpty }

        logEntries.append(logMessage.trimmingCharacters(in: .newlines))

        if logEntries.count > 5 {
            logEntries = Array(logEntries.suffix(5))
        }

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
