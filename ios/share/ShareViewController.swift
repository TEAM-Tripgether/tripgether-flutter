//
//  ShareViewController.swift
//  Share Extension
//
//  iOS 26+ Modern Implementation
//  UIViewController 기반 커스텀 Share Extension
//  NSExtensionContext inputItems 표준 처리
//

import UIKit
import UniformTypeIdentifiers
import UserNotifications

/// Share Extension의 메인 뷰 컨트롤러
/// iOS 26+ 표준을 따르는 UIViewController 기반 커스텀 구현
/// NSExtensionContext의 inputItems를 통한 현대적인 데이터 처리 방식
/// @objc 어노테이션: Swift-Objective-C 브릿징을 명확하게 하여
/// iOS 시스템이 NSExtensionPrincipalClass로부터 이 클래스를 올바르게 인식하도록 함
@objc(ShareViewController)
class ShareViewController: UIViewController {

    // MARK: - Configuration

    /// 메인 앱의 Bundle Identifier (App Group ID 접두사로도 사용)
    private let hostAppBundleIdentifier = "com.tripgether.alom"

    /// UserDefaults 공유 키 (큐 방식)
    private let queueKey = "ShareQueue"

    /// 최대 큐 크기 (FIFO 방식으로 오래된 항목 자동 제거)
    private let maxQueueSize = 100

    /// Legacy 호환성을 위한 구 키 (마이그레이션 시에만 사용)
    private let legacyKey = "ShareKey"

    /// 추출된 공유 데이터 (URL 또는 텍스트)
    private var sharedText: [String] = []

    /// iOS 26+ 권장: UTType을 직접 사용하는 현대적인 방식
    /// URL과 텍스트만 지원 (우선순위 순서: URL > PlainText > Text)
    private let supportedTypes: [UTType] = [.url, .plainText, .text]

    // MARK: - UI Constants

    private enum UIConstants {
        static let bottomSheetHeight: CGFloat = 120
        static let handleWidth: CGFloat = 40
        static let handleHeight: CGFloat = 6
        static let cornerRadius: CGFloat = 28
        static let horizontalPadding: CGFloat = 20
    }

    private enum TimingConstants {
        static let autoDismiss: TimeInterval = 5.0  // 5초 후 자동 닫기
        static let extensionDismissal: TimeInterval = 0.5  // Extension 종료 대기 시간
    }

    // MARK: - Debug Configuration

    #if DEBUG
    private let isDebugLoggingEnabled = true
    #else
    private let isDebugLoggingEnabled = false
    #endif

    // MARK: - UI State

    private var autoDismissTimer: Timer?
    private var gradientLayer: CAGradientLayer?
    private var bottomSheetContainer: UIView?
    private var hasShownAppGroupError = false

    // MARK: - App Group

    private var appGroupIdentifier: String {
        "group.\(hostAppBundleIdentifier)"
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        print("[ShareExtension] 🚀 iOS 26+ 현대적인 Share Extension 시작")

        // View 배경을 투명하게 설정 (바텀 시트만 보이도록)
        view.backgroundColor = .clear

        // 바텀 시트 UI 설정
        setupBottomSheetUI()

        // UI 설정 완료 후 데이터 처리 시작
        Task {
            await processSharedContentModern()
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        print("[ShareExtension] 🎬 viewDidAppear 호출됨")

        // TestFlight/프로덕션 환경 UI 강제 표시
        view.setNeedsLayout()
        view.layoutIfNeeded()

        view.subviews.forEach { subview in
            subview.isHidden = false
            subview.alpha = 1.0
            subview.setNeedsLayout()
            subview.layoutIfNeeded()
        }

        print("[ShareExtension] ✅ viewDidAppear 완료 - UI 표시됨")
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        if let bottomSheet = bottomSheetContainer {
            gradientLayer?.frame = bottomSheet.bounds
        }
    }

    deinit {
        print("[ShareExtension] 🗑️ deinit 호출됨 - 메모리 해제")

        gradientLayer?.removeFromSuperlayer()
        gradientLayer = nil

        autoDismissTimer?.invalidate()
        autoDismissTimer = nil
    }

    // MARK: - 현대적인 데이터 처리 (iOS 26+)

    /// iOS 26+ 표준: NSExtensionContext의 inputItems를 통한 현대적인 데이터 처리
    /// async/await 패턴을 활용한 비동기 처리
    /// Share Extension 선택 즉시 데이터 추출 → 저장 → UI 표시
    private func processSharedContentModern() async {
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
                self.saveAndLaunchApp()
            }
        } catch {
            print("[ShareExtension] ❌ 데이터 처리 오류: \(error)")
            await MainActor.run {
                self.extensionContext?.completeRequest(returningItems: [], completionHandler: nil)
            }
        }
    }

    /// iOS 26+ 표준: NSExtensionContext의 inputItems에서 데이터 추출
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
                // iOS 26+ 권장: 우선순위에 따라 타입별로 처리
                if let item = try? await extractItem(from: attachment, index: attachmentIndex) {
                    extractedItems.append(item)
                }
            }
        }

        return extractedItems
    }

    /// NSItemProvider에서 지원하는 타입에 따라 데이터 추출
    /// iOS 26+ 표준 패턴: UTType 우선순위에 따라 처리 (URL > PlainText > Text)
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

    // MARK: - Data Storage & App Launch

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

        // ✅ URL만 필터링 (Instagram 텍스트 제목 제외)
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

    /// UserDefaults에 저장하고 앱 실행 (URL과 텍스트만 처리)
    private func saveAndLaunchApp() {
        // 큐에 데이터 저장
        if !sharedText.isEmpty {
            logSecure("💾 큐에 데이터 저장", sensitiveData: sharedText.joined(separator: ", "))

            // saveToQueue() 호출로 큐에 저장
            let saveSuccess = saveToQueue()

            // 로그에 URL만 저장 (Instagram 텍스트 제목 제외)
            let urlsOnly = sharedText.filter { $0.hasPrefix("http://") || $0.hasPrefix("https://") }
            let urlsToLog = urlsOnly.joined(separator: " | ")
            saveDebugLog(message: "URL 큐에 저장: \(urlsToLog)")

            if saveSuccess {
                // 로컬 알림 발송 (사용자에게 즉각적인 피드백 제공)
                sendLocalNotification()

                // 데이터 저장 완료 후 바텀 시트 UI 표시 및 타이머 시작
                showSuccessAndDismiss()
            } else {
                print("[ShareExtension] ❌ 큐 저장 실패")
                extensionContext?.completeRequest(returningItems: [], completionHandler: nil)
            }
        } else {
            print("[ShareExtension] ⚠️ 저장할 데이터가 없습니다")
            extensionContext?.completeRequest(returningItems: [], completionHandler: nil)
        }
    }

    private func showSuccessAndDismiss() {
        print("[ShareExtension] 데이터 저장 완료 - 바텀 시트 UI 표시 중")
        startAutoDismissTimer()
    }

    /// 로컬 알림 발송 (공유 완료 시 사용자에게 즉각 피드백)
    /// AppDelegate에서 이미 알림 권한을 요청했으므로 Share Extension에서도 동일한 권한 사용
    /// 알림 identifier는 "share_completed"로 설정하여 AppDelegate의 탭 핸들러와 연동
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

    /// 자동 닫기 타이머 시작 (5초 후 자동으로 Extension 닫기)
    private func startAutoDismissTimer() {
        print("[ShareExtension] ⏰ 자동 닫기 타이머 시작 (\(TimingConstants.autoDismiss)초)")

        autoDismissTimer = Timer.scheduledTimer(withTimeInterval: TimingConstants.autoDismiss, repeats: false) { [weak self] _ in
            print("[ShareExtension] ⏰ 자동 닫기 타이머 완료 - Extension 닫기")
            self?.extensionContext?.completeRequest(returningItems: [], completionHandler: nil)
        }
    }

    /// 자동 닫기 타이머 취소
    private func cancelAutoDismissTimer() {
        if autoDismissTimer != nil {
            print("[ShareExtension] ⏰ 자동 닫기 타이머 취소")
            autoDismissTimer?.invalidate()
            autoDismissTimer = nil
        }
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

        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }

            let alert = UIAlertController(
                title: "App Group 설정 필요",
                message: message,
                preferredStyle: .alert
            )

            alert.addAction(UIAlertAction(title: "확인", style: .default) { _ in
                self.extensionContext?.completeRequest(returningItems: [], completionHandler: nil)
            })

            self.present(alert, animated: true, completion: nil)
        }
    }

    // MARK: - UI Setup

    /// 바텀 시트 스타일 UI 설정
    private func setupBottomSheetUI() {
        // 바텀 시트 컨테이너
        let bottomSheet = UIView()
        bottomSheet.translatesAutoresizingMaskIntoConstraints = false
        bottomSheet.backgroundColor = .clear
        view.addSubview(bottomSheet)
        bottomSheetContainer = bottomSheet

        // 그라데이션 배경 (Tripgether 브랜드 색상)
        gradientLayer = CAGradientLayer()
        gradientLayer?.colors = [
            UIColor(red: 27/255, green: 0/255, blue: 98/255, alpha: 0.85).cgColor,
            UIColor(red: 83/255, green: 37/255, blue: 203/255, alpha: 0.90).cgColor,
            UIColor(red: 181/255, green: 153/255, blue: 255/255, alpha: 0.95).cgColor,
        ]
        gradientLayer?.locations = [0.0, 0.5, 1.0]
        gradientLayer?.startPoint = CGPoint(x: 0.5, y: 0)
        gradientLayer?.endPoint = CGPoint(x: 0.5, y: 1)
        gradientLayer?.cornerRadius = UIConstants.cornerRadius
        gradientLayer?.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]

        if let gradientLayer = gradientLayer {
            bottomSheet.layer.insertSublayer(gradientLayer, at: 0)
        }

        NSLayoutConstraint.activate([
            bottomSheet.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bottomSheet.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bottomSheet.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            bottomSheet.heightAnchor.constraint(equalToConstant: UIConstants.bottomSheetHeight)
        ])

        // Handle indicator
        let handle = UIView()
        handle.translatesAutoresizingMaskIntoConstraints = false
        handle.backgroundColor = UIColor.white.withAlphaComponent(0.6)
        handle.layer.cornerRadius = 3
        bottomSheet.addSubview(handle)

        NSLayoutConstraint.activate([
            handle.topAnchor.constraint(equalTo: bottomSheet.topAnchor, constant: 12),
            handle.centerXAnchor.constraint(equalTo: bottomSheet.centerXAnchor),
            handle.widthAnchor.constraint(equalToConstant: UIConstants.handleWidth),
            handle.heightAnchor.constraint(equalToConstant: UIConstants.handleHeight)
        ])

        // 콘텐츠 컨테이너 (메시지 + 버튼)
        let contentContainer = UIStackView()
        contentContainer.axis = .horizontal
        contentContainer.alignment = .center
        contentContainer.spacing = 8
        contentContainer.translatesAutoresizingMaskIntoConstraints = false
        bottomSheet.addSubview(contentContainer)

        // 메시지 레이블
        let messageLabel = UILabel()
        messageLabel.text = "트립게더에서 컨텐츠 분석을 시작합니다."
        messageLabel.textColor = .white
        messageLabel.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        contentContainer.addArrangedSubview(messageLabel)

        // "앱에서 보기" 버튼
        let openAppButton = UIButton(type: .system)
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 15, weight: .medium),
            .foregroundColor: UIColor.white,
            .underlineStyle: NSUnderlineStyle.single.rawValue
        ]
        let attributedString = NSAttributedString(string: "앱에서 보기", attributes: attributes)
        openAppButton.setAttributedTitle(attributedString, for: .normal)
        openAppButton.addTarget(self, action: #selector(openAppButtonTapped), for: .touchUpInside)
        openAppButton.translatesAutoresizingMaskIntoConstraints = false
        contentContainer.addArrangedSubview(openAppButton)

        NSLayoutConstraint.activate([
            contentContainer.centerXAnchor.constraint(equalTo: bottomSheet.centerXAnchor),
            contentContainer.centerYAnchor.constraint(equalTo: bottomSheet.centerYAnchor, constant: 10),
            contentContainer.leadingAnchor.constraint(greaterThanOrEqualTo: bottomSheet.leadingAnchor, constant: UIConstants.horizontalPadding),
            contentContainer.trailingAnchor.constraint(lessThanOrEqualTo: bottomSheet.trailingAnchor, constant: -UIConstants.horizontalPadding)
        ])
    }

    @objc private func openAppButtonTapped() {
        print("[ShareExtension] 앱에서 보기 버튼 클릭됨")

        cancelAutoDismissTimer()

        guard let url = URL(string: "tripgether://share") else {
            print("[ShareExtension] ❌ URL Scheme 생성 실패")
            extensionContext?.completeRequest(returningItems: [], completionHandler: nil)
            return
        }

        launchMainApp(with: url)
    }

    private func launchMainApp(with url: URL) {
        print("[ShareExtension] URL Scheme 호출: \(url.absoluteString)")

        extensionContext?.open(url, completionHandler: { [weak self] success in
            print("[ShareExtension] extensionContext.open 결과: \(success)")

            guard let self = self else { return }

            if success {
                self.scheduleExtensionDismissal()
                return
            }

            // extensionContext.open 실패 시 Responder Chain 시도
            print("[ShareExtension] ⚠️ extensionContext.open 실패 - Responder Chain 시도")
            self.openViaResponderChain(url: url)
            self.scheduleExtensionDismissal()
        })
    }

    private func scheduleExtensionDismissal() {
        DispatchQueue.main.asyncAfter(deadline: .now() + TimingConstants.extensionDismissal) { [weak self] in
            self?.extensionContext?.completeRequest(returningItems: [], completionHandler: nil)
        }
    }

    private func openViaResponderChain(url: URL) {
        var responder: UIResponder? = self as UIResponder
        let selector = #selector(openURL(_:))

        while responder != nil {
            if let responder = responder, responder.responds(to: selector) && responder != self {
                print("[ShareExtension] ✅ URL 실행 가능한 Responder 발견")
                responder.perform(selector, with: url, afterDelay: 0)
                return
            }
            responder = responder?.next
        }

        print("[ShareExtension] ⚠️ URL을 실행할 Responder를 찾지 못함")
    }

    @objc private func openURL(_ url: URL) {
        // 이 메서드는 셀렉터 탐색용으로만 사용됨
        // 실제 URL 열기는 UIResponder 체인의 상위 객체가 처리
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

    /// 백그라운드 저장 확인용 디버그 로그 파일 생성
    /// App Groups 컨테이너에 로그 파일을 저장하여 앱에서 확인 가능
    /// 최신 5개 로그만 유지 (로그 로테이션)
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

// MARK: - Array Extension

extension Array {
    subscript (safe index: UInt) -> Element? {
        return Int(index) < count ? self[Int(index)] : nil
    }
}
