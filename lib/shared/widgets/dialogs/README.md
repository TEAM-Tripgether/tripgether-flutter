# CommonDialog 사용 가이드

공용 다이얼로그 위젯으로 일관된 디자인의 확인, 삭제, 오류, 성공 다이얼로그를 생성할 수 있습니다.

## 디자인 스펙

- **크기**: 306w × 184h
- **패딩**: 16px
- **Radius**: 8px
- **배경**: 흰색

### 콘텐츠 구조

```
[제목 - titleSemiBold18]
    ↓ 24px
[설명 - medium14]
    ↓ 8px
[서브 설명 - medium12, subColor2] (선택)
    ↓ 24px
[버튼 행 - 간격 8px]
```

### 버튼 스타일

- **왼쪽 버튼 (취소)**: subColor2 배경, textColor1 텍스트
- **오른쪽 버튼 (액션)**: 상황에 따라 다른 색상
  - 삭제: redAccent (#F94C4F)
  - 확인: mainColor (#5325CB)
  - 성공: success (#4CAF50)
- **버튼 패딩**: 상하 14px

## 사용 예시

### 1. 삭제 확인 다이얼로그

```dart
import 'package:tripgether/shared/widgets/dialogs/common_dialog.dart';

showDialog(
  context: context,
  builder: (context) => CommonDialog.forDelete(
    title: '장소를 삭제하시겠습니까?',
    description: '삭제된 장소는 복구할 수 없습니다.',
    subtitle: '연관된 코스도 함께 삭제됩니다.', // 선택 사항
    onConfirm: () {
      // 삭제 로직
      _deletePlace();
    },
    onCancel: () {
      // 취소 로직 (선택 사항)
      print('삭제 취소');
    },
  ),
);
```

### 2. 오류 제보 다이얼로그

```dart
showDialog(
  context: context,
  builder: (context) => CommonDialog.forError(
    title: '오류가 발생했습니다',
    description: '네트워크 연결을 확인해주세요.',
    subtitle: '오류 코드: 500', // 선택 사항
    onConfirm: () {
      // 확인 버튼 클릭 시 로직 (선택 사항)
      _retryRequest();
    },
  ),
);
```

### 3. 일반 확인 다이얼로그

```dart
showDialog(
  context: context,
  builder: (context) => CommonDialog.forConfirm(
    title: '변경사항을 저장하시겠습니까?',
    description: '저장하지 않으면 변경사항이 사라집니다.',
    onConfirm: () {
      _saveChanges();
    },
    onCancel: () {
      _discardChanges();
    },
  ),
);
```

### 4. 성공 알림 다이얼로그

```dart
showDialog(
  context: context,
  builder: (context) => CommonDialog.forSuccess(
    title: '저장 완료',
    description: '변경사항이 성공적으로 저장되었습니다.',
    subtitle: '3초 후 자동으로 닫힙니다.', // 선택 사항
  ),
);
```

### 5. 커스텀 다이얼로그

팩토리 메서드로 제공되지 않는 특수한 경우, 기본 생성자를 사용하여 완전히 커스터마이징할 수 있습니다:

```dart
showDialog(
  context: context,
  builder: (context) => CommonDialog(
    title: '알림',
    description: '새로운 메시지가 도착했습니다.',
    subtitle: '5분 전',
    leftButtonText: '나중에',
    rightButtonText: '확인',
    leftButtonColor: AppColors.grayPurple,
    rightButtonColor: AppColors.mainColor,
    rightButtonTextColor: AppColors.white,
    onLeftPressed: () {
      _postponeNotification();
    },
    onRightPressed: () {
      _viewMessage();
    },
    autoDismiss: true, // 버튼 클릭 시 자동으로 닫기
  ),
);
```

## 팩토리 메서드

### forDelete()

삭제 확인 다이얼로그를 생성합니다.

**파라미터**:
- `title` (required): 제목
- `description` (required): 설명
- `subtitle` (optional): 부가 설명
- `onConfirm` (optional): 삭제 버튼 콜백
- `onCancel` (optional): 취소 버튼 콜백
- `confirmText` (default: '삭제'): 삭제 버튼 텍스트
- `cancelText` (default: '취소'): 취소 버튼 텍스트
- `autoDismiss` (default: true): 자동 닫기 여부

**특징**:
- 삭제 버튼: redAccent (#F94C4F) 배경, 흰색 텍스트
- 취소 버튼: subColor2 배경, textColor1 텍스트

### forError()

오류 제보 다이얼로그를 생성합니다.

**파라미터**:
- `title` (required): 제목
- `description` (required): 설명
- `subtitle` (optional): 오류 코드나 부가 정보
- `onConfirm` (optional): 확인 버튼 콜백
- `confirmText` (default: '확인'): 확인 버튼 텍스트
- `confirmButtonColor` (optional): 확인 버튼 색상 (기본: mainColor)
- `autoDismiss` (default: true): 자동 닫기 여부

**특징**:
- 단일 버튼만 표시 (취소 버튼 없음)
- 확인 버튼: mainColor 배경, 흰색 텍스트

### forConfirm()

일반 확인 다이얼로그를 생성합니다.

**파라미터**:
- `title` (required): 제목
- `description` (required): 설명
- `subtitle` (optional): 부가 설명
- `onConfirm` (optional): 확인 버튼 콜백
- `onCancel` (optional): 취소 버튼 콜백
- `confirmText` (default: '확인'): 확인 버튼 텍스트
- `cancelText` (default: '취소'): 취소 버튼 텍스트
- `autoDismiss` (default: true): 자동 닫기 여부

**특징**:
- 확인 버튼: mainColor 배경, 흰색 텍스트
- 취소 버튼: subColor2 배경, textColor1 텍스트

### forSuccess()

성공 알림 다이얼로그를 생성합니다.

**파라미터**:
- `title` (required): 제목
- `description` (required): 설명
- `subtitle` (optional): 부가 설명
- `onConfirm` (optional): 확인 버튼 콜백
- `confirmText` (default: '확인'): 확인 버튼 텍스트
- `autoDismiss` (default: true): 자동 닫기 여부

**특징**:
- 단일 버튼만 표시 (취소 버튼 없음)
- 확인 버튼: success (#4CAF50) 배경, 흰색 텍스트

## 고급 사용법

### 자동 닫기 비활성화

버튼을 눌러도 다이얼로그가 자동으로 닫히지 않도록 하려면 `autoDismiss: false`를 설정합니다:

```dart
showDialog(
  context: context,
  builder: (context) => CommonDialog.forConfirm(
    title: '로딩 중...',
    description: '작업을 처리하고 있습니다.',
    autoDismiss: false, // 자동으로 닫히지 않음
    onConfirm: () async {
      await _performLongOperation();
      // 수동으로 닫기
      Navigator.of(context).pop();
    },
  ),
);
```

### 다이얼로그 결과 받기

다이얼로그에서 사용자의 선택을 받으려면 `Navigator.pop()`에 값을 전달합니다:

```dart
final result = await showDialog<bool>(
  context: context,
  builder: (context) => CommonDialog.forDelete(
    title: '정말 삭제하시겠습니까?',
    description: '이 작업은 되돌릴 수 없습니다.',
    autoDismiss: false, // 수동 닫기 모드
    onConfirm: () {
      Navigator.of(context).pop(true); // 확인 선택
    },
    onCancel: () {
      Navigator.of(context).pop(false); // 취소 선택
    },
  ),
);

if (result == true) {
  _deleteItem();
}
```

## 디자인 시스템 연동

CommonDialog는 다음 디자인 시스템 요소를 사용합니다:

### 색상 (AppColors)
- `mainColor`: 메인 확인 버튼 (#5325CB)
- `subColor2`: 취소 버튼 배경 (#BBBBBB)
- `textColor1`: 제목 및 취소 버튼 텍스트 (#130537)
- `white`: 배경 및 액션 버튼 텍스트 (#FFFFFF)
- `redAccent`: 삭제 버튼 배경 (#F94C4F)
- `success`: 성공 버튼 배경 (#4CAF50)

### 텍스트 스타일 (AppTextStyles)
- `titleSemiBold18`: 제목
- `bodyMedium14`: 설명
- `bodyMedium12`: 서브 설명
- `bodyMedium16`: 버튼 텍스트

### 간격 (AppSpacing)
- `lg` (16px): 다이얼로그 패딩
- `verticalSpaceXXL` (24px): 제목-설명, 서브설명-버튼 간격
- `verticalSpaceSM` (8px): 설명-서브설명 간격
- `horizontalSpaceSM` (8px): 버튼 간격

### Radius (AppRadius)
- `allMedium` (8px): 다이얼로그 및 버튼 모서리

## 확장 가능성

새로운 다이얼로그 유형이 필요한 경우, 다음과 같이 팩토리 메서드를 추가할 수 있습니다:

```dart
// 예: 경고 다이얼로그 팩토리
factory CommonDialog.forWarning({
  required String title,
  required String description,
  String? subtitle,
  VoidCallback? onConfirm,
  VoidCallback? onCancel,
  String confirmText = '계속',
  String cancelText = '취소',
  bool autoDismiss = true,
}) {
  return CommonDialog(
    title: title,
    description: description,
    subtitle: subtitle,
    leftButtonText: cancelText,
    rightButtonText: confirmText,
    onLeftPressed: onCancel,
    onRightPressed: onConfirm,
    rightButtonColor: AppColors.warning, // 경고 색상
    rightButtonTextColor: AppColors.white,
    autoDismiss: autoDismiss,
  );
}
```

## 접근성

CommonDialog는 다음과 같은 접근성 기능을 제공합니다:

- 시맨틱 구조: 제목, 설명, 버튼이 명확하게 구분됨
- 키보드 네비게이션: 버튼 간 이동 지원
- 스크린 리더 호환: 모든 텍스트가 읽기 가능

## 모범 사례

1. **적절한 팩토리 사용**: 용도에 맞는 팩토리 메서드를 사용하세요 (forDelete, forError 등)
2. **명확한 제목**: 사용자가 다이얼로그의 목적을 즉시 이해할 수 있도록 명확한 제목을 작성하세요
3. **간결한 설명**: 설명은 2-3줄 이내로 간결하게 작성하세요
4. **부가 정보는 subtitle 사용**: 오류 코드, 타임스탬프 등은 subtitle로 표시하세요
5. **일관된 버튼 텍스트**: "확인", "취소", "삭제" 등 일관된 용어를 사용하세요
