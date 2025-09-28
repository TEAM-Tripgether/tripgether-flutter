# TripTogether 공유 기능 가이드

iOS Share Extension이 성공적으로 구현되었습니다! 이 가이드에서는 공유 기능을 사용하는 방법과 구현된 기능들을 설명합니다.

## 🎯 구현된 기능

### ✅ 지원되는 콘텐츠 타입
- **📱 텍스트**: 일반 텍스트, 메모, 메시지
- **🔗 URL**: 웹 링크, 딥링크
- **🖼️ 이미지**: JPEG, PNG, HEIC 등 (최대 100개)
- **🎥 동영상**: MP4, MOV 등 (최대 100개)
- **📄 파일**: 모든 파일 형식 (1개씩)

### ✅ 핵심 컴포넌트
1. **SharingService**: 공유 데이터를 통합 관리하는 싱글톤 서비스
2. **ShareViewController.swift**: iOS Share Extension 처리 로직
3. **Material 3 UI**: 현대적이고 직관적인 사용자 인터페이스

## 🚀 사용 방법

### 1단계: 앱 빌드 및 설치
```bash
# 프로젝트 루트에서 실행
flutter clean && flutter pub get
flutter run
```

### 2단계: 공유 테스트
1. **사진 앱**에서 이미지 선택 → 공유 버튼 → "TripTogether" 선택
2. **Safari**에서 웹페이지 → 공유 버튼 → "TripTogether" 선택
3. **메모 앱**에서 텍스트 선택 → 공유 버튼 → "TripTogether" 선택
4. **파일 앱**에서 문서 선택 → 공유 버튼 → "TripTogether" 선택

### 3단계: 결과 확인
- TripTogether 앱이 자동으로 열림
- 공유된 콘텐츠가 구조화된 형태로 표시
- 타입별로 분류된 정보 확인 가능

## 🔧 기술적 구현 세부사항

### App Groups 설정
- **Group ID**: `group.com.example.triptogether`
- **목적**: 메인 앱과 Share Extension 간 데이터 공유
- **설정 위치**: Runner.entitlements, Share Extension.entitlements

### URL 스킴 설정
- **스킴**: `ShareMedia://`
- **목적**: Share Extension에서 메인 앱으로 자동 이동
- **예시**: `ShareMedia://dataUrl=ShareKey#media`

### Bundle Identifier 구조
```
메인 앱: com.example.triptogether
Share Extension: com.example.triptogether.ShareExtension
```

### 데이터 흐름
1. **사용자가 다른 앱에서 공유 실행**
2. **iOS가 Share Extension 실행**
3. **ShareViewController.swift가 데이터 처리**
   - 타입별 파싱 (이미지/동영상/텍스트/파일)
   - App Group 컨테이너에 저장
   - 메인 앱 호출
4. **Flutter 메인 앱 실행**
   - SharingService가 데이터 감지
   - UI에 구조화된 형태로 표시
   - 사용자 액션 대기

## 📱 UI 구성 요소

### 메인 화면
- **📊 공유 데이터 정보**: 수신 시간, 파일 개수, 타입별 통계
- **📝 텍스트/URL 섹션**: URL과 일반 텍스트 구분 표시
- **📁 미디어 파일 섹션**: 파일명, 경로, 썸네일, 재생시간 정보
- **🔧 액션 버튼**: 데이터 초기화, 처리 완료

### 빈 상태 화면
- 공유 대기 상태 안내
- 지원되는 콘텐츠 타입 안내

## 🛠️ 개발자 정보

### 주요 파일 구조
```
lib/
├── services/
│   └── sharing_service.dart     # 공유 서비스 로직
├── main.dart                    # 메인 앱 및 UI
ios/
├── Runner/
│   ├── Info.plist              # 메인 앱 설정
│   └── Runner.entitlements     # 앱 권한 설정
└── Share Extension/
    ├── ShareViewController.swift # Share Extension 로직
    ├── Info.plist              # Extension 설정
    └── Share Extension.entitlements # Extension 권한
```

### 디버깅 로그
모든 공유 이벤트는 콘솔에 상세 로그가 출력됩니다:
```
[SharingService] 공유 서비스 초기화 시작
[SharingService] 미디어 공유 수신: 2개 파일
[MainApp] 공유 데이터 수신: SharedData(files: 2, texts: 0, receivedAt: ...)
```

### 커스터마이징 포인트

#### Bundle Identifier 변경
1. `ios/Share Extension/ShareViewController.swift`의 `hostAppBundleIdentifier` 수정
2. Xcode에서 메인 앱과 Extension의 Bundle ID 업데이트
3. App Group ID를 새로운 Bundle ID에 맞게 수정

#### 지원 파일 타입 확장
`ios/Share Extension/Info.plist`에서 다음 항목 수정:
- `NSExtensionActivationSupportsImageWithMaxCount`
- `NSExtensionActivationSupportsMovieWithMaxCount`
- `NSExtensionActivationSupportsFileWithMaxCount`
- `PHSupportedMediaTypes` 배열

#### UI 커스터마이징
`lib/main.dart`의 다음 메서드들을 수정:
- `_buildDataInfo()`: 데이터 정보 표시 방식
- `_buildTextSection()`: 텍스트 표시 방식
- `_buildMediaSection()`: 미디어 파일 표시 방식
- `_buildActionButtons()`: 액션 버튼 구성

## 🐛 문제 해결

### 공유 버튼에 앱이 나타나지 않는 경우
1. iOS 설정 → 개인정보 보호 및 보안 → 개발자 모드 활성화
2. Xcode에서 Share Extension 타겟도 함께 빌드되었는지 확인
3. 기기 재시작 후 다시 시도

### 앱이 열리지 않는 경우
1. URL 스킴 설정 확인 (`ShareMedia://`)
2. App Group 설정이 메인 앱과 Extension에서 동일한지 확인
3. Bundle Identifier가 올바르게 설정되었는지 확인

### 데이터가 전달되지 않는 경우
1. App Group ID가 모든 곳에서 일치하는지 확인
2. iOS 시뮬레이터가 아닌 실제 기기에서 테스트
3. 콘솔 로그를 확인하여 오류 메시지 점검

## 🎉 완성!

iOS Share Extension이 성공적으로 구현되었습니다. 이제 다른 앱에서 TripTogether로 콘텐츠를 공유할 수 있습니다!

추가 질문이나 개선사항이 있으시면 언제든지 말씀해 주세요.