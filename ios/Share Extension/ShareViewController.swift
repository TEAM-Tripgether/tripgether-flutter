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

    // UI Constants
    private let bottomSheetHeight: CGFloat = 300
    private let autoDismissDelay: TimeInterval = 5.0 // 5초 후 자동 닫기
    private var autoDismissTimer: Timer?

    // 🔧 메모리 관리: 그라데이션 레이어를 프로퍼티로 저장하여 명시적으로 정리
    private var gradientLayer: CAGradientLayer?

    override func viewDidLoad() {
        super.viewDidLoad()

        // ✨ 바텀 시트 UI 모드
        print("[ShareExtension] 🚀 바텀 시트 UI 모드 시작")

        // 배경: 투명
        view.backgroundColor = .clear

        // 바텀 시트 스타일 UI 설정
        setupBottomSheetUI()

        // 상단 영역 터치 시 닫기 제스처 추가
        setupDismissGesture()

        // 백그라운드에서 데이터 처리
        processSharedContentImmediately()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        print("[ShareExtension] 🎬 viewDidAppear 호출됨")

        // 부모 뷰 계층을 모두 투명하게 만들기
        makeParentViewsTransparent()

        // 🔧 TestFlight 이슈 해결: viewDidAppear에서 UI 강제 표시
        // 프로덕션 환경에서는 viewDidLoad만으로는 UI가 제대로 표시되지 않을 수 있음
        print("[ShareExtension] 🔄 UI 가시성 강제 적용")

        // 뷰 계층 강제 업데이트
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

        // 🔧 Flutter 문서 권장사항: Extension 종료 보장
        // Extension이 종료될 때 명시적으로 메인 앱으로 제어권 반환
        extensionContext?.cancelRequest(withError: NSError(domain: "ShareExtension", code: 0, userInfo: nil))
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

    /// 부모 뷰 계층을 투명하게 만들기
    private func makeParentViewsTransparent() {
        var currentView: UIView? = view
        while let parentView = currentView?.superview {
            print("[ShareExtension] 부모 뷰 투명화: \(type(of: parentView))")
            parentView.backgroundColor = .clear
            currentView = parentView
        }
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
        let bottomSheetYPosition = view.bounds.height - bottomSheetHeight

        if location.y < bottomSheetYPosition {
            // 상단 영역 터치 시 Extension 닫기
            print("[ShareExtension] 배경 터치로 닫기")
            extensionContext?.completeRequest(returningItems: [], completionHandler: nil)
        }
    }

    /// 바텀 시트 스타일 UI 설정
    private func setupBottomSheetUI() {
        // 바텀시트 높이 설정 (더 높게)
        let yPosition = view.bounds.height - bottomSheetHeight

        // 하단부 그라데이션 - 흰색 추가 (위에서 아래로 흰색이 많아짐)
        // 🔧 메모리 관리: 프로퍼티에 저장하여 나중에 명시적으로 제거
        gradientLayer = CAGradientLayer()
        gradientLayer?.frame = CGRect(
            x: 0,
            y: yPosition,
            width: view.bounds.width,
            height: bottomSheetHeight
        )
        gradientLayer?.colors = [
            UIColor.clear.cgColor, // 최상단: 완전 투명
            UIColor(red: 27/255, green: 0/255, blue: 98/255, alpha: 0.2).cgColor,    // #1B0062 - 진한 남보라 (20%)
            UIColor(red: 83/255, green: 37/255, blue: 203/255, alpha: 0.4).cgColor,  // #5325CB - 선명한 보라 (40%)
            UIColor(red: 181/255, green: 153/255, blue: 255/255, alpha: 0.6).cgColor, // #B599FF - 밝은 연보라 (60%)
            UIColor.white.cgColor // 최하단: 흰색 (100%)
        ]
        gradientLayer?.locations = [0.0, 0.2, 0.4, 0.7, 1.0] // 위→아래로 갈수록 흰색이 많이 차지

        // 레이어 추가
        if let layer = gradientLayer {
            view.layer.insertSublayer(layer, at: 0)
        }

        // 바텀 컨테이너 뷰 (하단에 배치)
        let bottomContainer = UIView()
        bottomContainer.translatesAutoresizingMaskIntoConstraints = false
        bottomContainer.backgroundColor = .clear
        view.addSubview(bottomContainer)

        // 좌측: 메시지 레이블 (흰색 텍스트)
        let messageLabel = UILabel()
        messageLabel.text = "게시물을 추가했어요"
        messageLabel.textColor = .white
        messageLabel.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        bottomContainer.addSubview(messageLabel)

        // 우측: "앱에서 보기" 버튼 (투명 배경 + 흰색 텍스트 + 밑줄)
        let openAppButton = UIButton(type: .system)

        // 밑줄이 있는 텍스트 생성 (흰색)
        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.white,
            .font: UIFont.systemFont(ofSize: 14, weight: .medium),
            .underlineStyle: NSUnderlineStyle.single.rawValue
        ]
        let attributedTitle = NSAttributedString(string: "앱에서 보기", attributes: attributes)
        openAppButton.setAttributedTitle(attributedTitle, for: .normal)

        openAppButton.backgroundColor = .clear
        openAppButton.addTarget(self, action: #selector(openAppButtonTapped), for: .touchUpInside)
        openAppButton.translatesAutoresizingMaskIntoConstraints = false
        bottomContainer.addSubview(openAppButton)

        // Auto Layout 제약조건
        NSLayoutConstraint.activate([
            // 바텀 컨테이너: 화면 하단에 배치
            bottomContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            bottomContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            bottomContainer.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -30),
            bottomContainer.heightAnchor.constraint(equalToConstant: 50),

            // 메시지 레이블: 좌측
            messageLabel.leadingAnchor.constraint(equalTo: bottomContainer.leadingAnchor),
            messageLabel.centerYAnchor.constraint(equalTo: bottomContainer.centerYAnchor),

            // 버튼: 우측
            openAppButton.trailingAnchor.constraint(equalTo: bottomContainer.trailingAnchor),
            openAppButton.centerYAnchor.constraint(equalTo: bottomContainer.centerYAnchor),
            openAppButton.widthAnchor.constraint(equalToConstant: 100),
            openAppButton.heightAnchor.constraint(equalToConstant: 40)
        ])
    }

    @objc private func openAppButtonTapped() {
        print("[ShareExtension] 앱에서 보기 버튼 클릭됨")

        guard let url = URL(string: "tripgether://share") else {
            print("[ShareExtension] ❌ URL Scheme 생성 실패")
            extensionContext?.completeRequest(returningItems: [], completionHandler: nil)
            return
        }

        print("[ShareExtension] URL Scheme: \(url.absoluteString)")

        // iOS 13+ extensionContext.open() 사용
        extensionContext?.open(url, completionHandler: { [weak self] success in
            print("[ShareExtension] extensionContext.open 결과: \(success)")

            if !success {
                print("[ShareExtension] ⚠️ extensionContext.open 실패 - UIApplication 시도")

                // Fallback: UIApplication.shared.open
                // Extension에서 직접 UIApplication에 접근할 수 없으므로 리플렉션 사용
                if let application = UIApplication.value(forKeyPath: #keyPath(UIApplication.shared)) as? UIApplication {
                    application.open(url, options: [:], completionHandler: { opened in
                        print("[ShareExtension] UIApplication.open 결과: \(opened)")
                    })
                }
            }

            // Extension 닫기 (0.5초 후)
            // 앱 전환이 완료될 시간을 확보하기 위한 지연
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self?.extensionContext?.completeRequest(returningItems: [], completionHandler: nil)
            }
        })
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

    private func showSuccessAndDismiss() {
        print("[ShareExtension] 데이터 저장 완료 - 바텀 시트 UI 표시")

        // 🔧 TestFlight 이슈 해결 핵심:
        // 비동기 작업이 완료된 시점에는 이미 UI가 준비되어 있어야 함
        // 하지만 iOS가 Extension을 빠르게 종료하려고 하므로,
        // 명시적으로 UI를 강제 표시하고 레이아웃을 즉시 적용

        // 메인 스레드에서 즉시 실행
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }

            print("[ShareExtension] 🔄 UI 강제 업데이트 시작")

            // 모든 서브뷰를 강제로 레이아웃
            self.view.setNeedsLayout()
            self.view.layoutIfNeeded()

            // 부모 뷰도 강제 레이아웃
            self.view.superview?.setNeedsLayout()
            self.view.superview?.layoutIfNeeded()

            print("[ShareExtension] ✅ 바텀 시트 UI 표시 완료 - 사용자 액션 대기 중")

            // 사용자가 "앱에서 보기" 버튼을 누르거나 배경을 터치할 때까지 유지
            // 타이머 없이 수동 닫기 방식 사용
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
    /// Share Extension은 직접 앱을 실행할 수 없으므로 UIResponder 체인을 통해 시스템에 요청
    @objc private func openMainApp() {
        guard let url = URL(string: "tripgether://share") else {
            print("[ShareExtension] ❌ URL Scheme 생성 실패")
            return
        }

        print("[ShareExtension] URL Scheme 호출: \(url.absoluteString)")

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
