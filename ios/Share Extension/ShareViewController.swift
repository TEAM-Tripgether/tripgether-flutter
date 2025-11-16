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
import UniformTypeIdentifiers

/// Share Extension의 메인 뷰 컨트롤러
/// @objc 어노테이션: Swift-Objective-C 브릿징을 명확하게 하여
/// iOS 시스템이 NSExtensionPrincipalClass로부터 이 클래스를 올바르게 인식하도록 함
@objc(ShareViewController)
class ShareViewController: UIViewController {
    // IMPORTANT: 메인 앱의 Bundle Identifier와 동일하게 설정 (App Group ID 접두사로도 사용)
    let hostAppBundleIdentifier = "com.tripgether.alom"
    let sharedKey = "ShareKey"
    var sharedText: [String] = []

    // ✅ iOS 14.0+ UniformTypeIdentifiers 사용 (URL과 텍스트만 처리)
    let textContentType = UTType.text.identifier
    let urlContentType = UTType.url.identifier

    // MARK: - Constants
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

    // UI State
    private var autoDismissTimer: Timer?

    // 🔧 메모리 관리: 그라데이션 레이어를 프로퍼티로 저장하여 명시적으로 정리
    private var gradientLayer: CAGradientLayer?
    private var bottomSheetContainer: UIView?
    private var hasShownAppGroupError = false

    private var appGroupIdentifier: String {
        "group.\(hostAppBundleIdentifier)"
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // ✨ 바텀 시트 UI 모드
        print("[ShareExtension] 🚀 바텀 시트 UI 모드 시작")

        // 🔧 CRITICAL: View 배경을 투명하게 설정 (바텀 시트만 보이도록)
        view.backgroundColor = .clear

        // 바텀 시트 UI 설정 (디밍 배경 포함)
        setupBottomSheetUI()

        // 🔧 UI 설정 완료 후 데이터 처리 시작 (메인 스레드에서 실행)
        DispatchQueue.main.async { [weak self] in
            self?.processSharedContentImmediately()
        }
    }

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

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        print("[ShareExtension] 🎬 viewDidAppear 호출됨")

        // 🔧 TestFlight 이슈 해결: viewDidAppear에서 UI 강제 표시
        // 프로덕션 환경에서는 viewDidLoad만으로는 UI가 제대로 표시되지 않을 수 있음
        view.setNeedsLayout()
        view.layoutIfNeeded()

        // 모든 서브뷰도 강제 표시
        view.subviews.forEach { subview in
            subview.isHidden = false
            subview.alpha = 1.0
            subview.setNeedsLayout()
            subview.layoutIfNeeded()
        }

        print("[ShareExtension] ✅ viewDidAppear 완료 - UI 표시됨")
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

        print("[ShareExtension] 🚪 viewDidDisappear 호출됨 - Extension 종료")

        // 🔧 viewDidDisappear는 Extension이 닫힐 때 호출되므로
        // 여기서는 cancelRequest를 호출하지 않음
        // completeRequest는 사용자 액션(버튼 탭, 타이머)에서만 호출
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        if let bottomSheet = bottomSheetContainer {
            gradientLayer?.frame = bottomSheet.bounds
        }
    }

    deinit {
        print("[ShareExtension] 🗑️ deinit 호출됨 - 메모리 해제")

        // 🔧 메모리 관리: 그라데이션 레이어 명시적 제거
        gradientLayer?.removeFromSuperlayer()
        gradientLayer = nil

        // 타이머 정리
        autoDismissTimer?.invalidate()
        autoDismissTimer = nil
    }

    /// 상단 영역 터치 시 Share Extension 닫기
    private func setupDismissGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleBackgroundTap))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }

    @objc private func handleBackgroundTap(_ gesture: UITapGestureRecognizer) {
        let location = gesture.location(in: view)

        // 하단 영역은 터치 무시 (UI 영역)
        let bottomSheetYPosition = view.bounds.height - UIConstants.bottomSheetHeight

        if location.y < bottomSheetYPosition {
            // 상단 영역 터치 시 Extension 닫기
            print("[ShareExtension] 배경 터치로 닫기")
            cancelAutoDismissTimer() // 타이머 취소
            extensionContext?.completeRequest(returningItems: [], completionHandler: nil)
        }
    }

    /// 바텀 시트 스타일 UI 설정
    private func setupBottomSheetUI() {
        // 바텀 시트 컨테이너 (화면 하단 전체를 채움)
        let bottomSheet = UIView()
        bottomSheet.translatesAutoresizingMaskIntoConstraints = false
        bottomSheet.backgroundColor = .clear
        view.addSubview(bottomSheet)
        bottomSheetContainer = bottomSheet

        // 그라데이션 배경 (반투명)
        gradientLayer = CAGradientLayer()
        gradientLayer?.colors = [
            UIColor(red: 27/255, green: 0/255, blue: 98/255, alpha: 0.85).cgColor,    // #1B0062 - 진한 남보라 (반투명)
            UIColor(red: 83/255, green: 37/255, blue: 203/255, alpha: 0.90).cgColor,  // #5325CB - 선명한 보라 (반투명)
            UIColor(red: 181/255, green: 153/255, blue: 255/255, alpha: 0.95).cgColor, // #B599FF - 밝은 연보라 (반투명)
        ]
        gradientLayer?.locations = [0.0, 0.5, 1.0]
        gradientLayer?.startPoint = CGPoint(x: 0.5, y: 0)
        gradientLayer?.endPoint = CGPoint(x: 0.5, y: 1)
        gradientLayer?.cornerRadius = 28
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

        // 중앙 콘텐츠 영역 (가로 배치)
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

        // "앱에서 보기" 버튼 (underline 스타일)
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
            // 콘텐츠 컨테이너를 바텀 시트 중앙에 배치
            contentContainer.centerXAnchor.constraint(equalTo: bottomSheet.centerXAnchor),
            contentContainer.centerYAnchor.constraint(equalTo: bottomSheet.centerYAnchor, constant: 10),
            contentContainer.leadingAnchor.constraint(greaterThanOrEqualTo: bottomSheet.leadingAnchor, constant: UIConstants.horizontalPadding),
            contentContainer.trailingAnchor.constraint(lessThanOrEqualTo: bottomSheet.trailingAnchor, constant: -UIConstants.horizontalPadding)
        ])
    }


    @objc private func openAppButtonTapped() {
        print("[ShareExtension] 앱에서 보기 버튼 클릭됨")

        // 자동 닫기 타이머 취소 (사용자가 버튼 클릭했으므로)
        cancelAutoDismissTimer()

        guard let url = URL(string: "tripgether://share") else {
            print("[ShareExtension] ❌ URL Scheme 생성 실패")
            extensionContext?.completeRequest(returningItems: [], completionHandler: nil)
            return
        }

        launchMainApp(with: url)
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

            // ✅ URL과 텍스트만 처리 (이미지/비디오/파일은 지원하지 않음)
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
            } else {
                print("[ShareExtension] ⚠️ 지원하지 않는 타입 (index: \(index)) - URL과 텍스트만 지원")
                dispatchGroup.leave()
            }
        }

        // 모든 attachment 처리 완료 후
        dispatchGroup.notify(queue: .main) {
            if hasProcessedAnyItem {
                print("[ShareExtension] ✅ 데이터 처리 완료 - 저장 및 앱 실행")
                self.saveAndLaunchApp()
            } else {
                print("[ShareExtension] ⚠️ 처리된 ��이터 없음 - Extension 종료")
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

    // ✅ 이미지/비디오/파일 처리 메서드 제거됨 (URL과 텍스트만 처리)

    /// UserDefaults에 저장하고 앱 실행 (URL과 텍스트만 처리)
    private func saveAndLaunchApp() {
        guard let userDefaults = appGroupUserDefaults() else {
            print("[ShareExtension] ❌ App Group UserDefaults를 사용할 수 없습니다")
            return
        }

        // ✅ URL/텍스트 데이터 저장
        if !sharedText.isEmpty {
            logSecure("💾 텍스트 데이터 저장", sensitiveData: sharedText.joined(separator: ", "))
            userDefaults.set(sharedText, forKey: sharedKey)

            // 📝 로그에 실제 URL 내용 저장
            let urlsToLog = sharedText.joined(separator: "\n")
            saveDebugLog(message: "URL 저장: \(urlsToLog)")
        }

        // 동기화
        let syncSuccess = userDefaults.synchronize()
        print("[ShareExtension] UserDefaults 동기화: \(syncSuccess ? "성공" : "실패")")

        if syncSuccess {
            // 데이터 저장 완료 후 바텀 시트 UI 표시
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
                    guard let userDefaults = this.appGroupUserDefaults() else {
                        return
                    }

                    print("[ShareExtension] ✅ 단일 데이터 저장: \(this.sharedText)")

                    userDefaults.set(this.sharedText, forKey: this.sharedKey)
                    userDefaults.synchronize()

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
                    guard let userDefaults = this.appGroupUserDefaults() else {
                        return
                    }

                    print("[ShareExtension] ✅ 단일 데이터 저장: \(this.sharedText)")

                    userDefaults.set(this.sharedText, forKey: this.sharedKey)
                    userDefaults.synchronize()

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

    // ✅ Legacy 핸들러 메서드 제거됨 (handleImages, handleVideos, handleFiles)

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

    private func showSuccessAndDismiss() {
        print("[ShareExtension] 데이터 저장 완료 - 바텀 시트 UI 표시 시작")

        // 🔧 즉시 타이머 시작 (UI는 viewDidLoad에서 이미 설정됨)
        // viewDidAppear에서 강제 표시되므로 추가 대기 불필요
        startAutoDismissTimer()
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
    /// Share Extension은 직접 앱을 실행할 수 없으므로 시스템 API를 통해 요청
    @objc private func openMainApp() {
        guard let url = URL(string: "tripgether://share") else {
            print("[ShareExtension] ❌ URL Scheme 생성 실패")
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

            print("[ShareExtension] ⚠️ extensionContext.open 실패 - UIApplication 시도")

            if let application = UIApplication.value(forKeyPath: #keyPath(UIApplication.shared)) as? UIApplication {
                application.open(url, options: [:], completionHandler: { opened in
                    print("[ShareExtension] UIApplication.open 결과: \(opened)")
                })
                self.scheduleExtensionDismissal()
                return
            }

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
        // UIResponder 체인을 따라 올라가며 openURL을 수행할 수 있는 객체 찾기
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

    /// URL 열기 (UIResponder 체인의 상위 객체가 실제로 처리)
    @objc private func openURL(_ url: URL) {
        // 이 메서드는 셀렉터 탐색용으로만 사용됨
        // 실제 URL 열기는 UIResponder 체인의 상위 객체(ExtensionContext)가 처리
    }

    // ✅ 미디어 처리 관련 유틸리티 메서드 및 데이터 모델 제거됨
    // getExtension, getFileName, copyFile, getSharedMediaFile, getThumbnailPath
    // SharedMediaFile, SharedMediaType, toData
    // URL과 텍스트만 처리하므로 불필요

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
