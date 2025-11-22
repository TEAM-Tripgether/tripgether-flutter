# Tripgether 공용 위젯 API

> 🧩 **재사용 가능한 UI 컴포넌트 가이드**

## 📋 목차

- [개요](#개요)
- [설치 및 import](#설치-및-import)
- [Common 위젯](#common-위젯)
- [Buttons 위젯](#buttons-위젯)
- [Cards 위젯](#cards-위젯)
- [Inputs 위젯](#inputs-위젯)
- [Layout 위젯](#layout-위젯)
- [Dialogs 위젯](#dialogs-위젯)
- [개발 가이드라인](#개발-가이드라인)

---

## 개요

`shared/widgets/` 디렉토리는 앱 전체에서 재사용 가능한 UI 컴포넌트를 중앙 집중식으로 관리합니다.

### 핵심 원칙

- ✅ **DRY (Don't Repeat Yourself)**: 중복 UI 코드 절대 금지
- ✅ **일관성 (Consistency)**: 모든 화면에서 동일한 위젯 사용
- ✅ **유지보수성 (Maintainability)**: 한 곳에서 수정하면 전체 앱 업데이트
- ✅ **테스트 용이성 (Testability)**: 독립적으로 테스트 가능한 컴포넌트

### 디렉토리 구조

```
shared/widgets/
├── common/         # 범용 위젯 (AppBar, EmptyState, Chip, Avatar, ListTile, SnackBar)
├── buttons/        # 버튼 위젯 (Primary, Secondary, Tertiary, Social Login, Link)
├── cards/          # 카드 위젯 (SNS Content, Place Detail)
├── inputs/         # 입력 위젯 (SearchBar, OnboardingTextField)
├── layout/         # 레이아웃 위젯 (Gradient, SectionHeader, BottomNav, CollapsibleAppBar)
└── dialogs/        # 다이얼로그 위젯 (CommonDialog)
```

---

## 설치 및 import

### 공용 위젯 사용

```dart
// Common 위젯
import 'package:tripgether/shared/widgets/common/common_app_bar.dart';
import 'package:tripgether/shared/widgets/common/empty_state.dart';
import 'package:tripgether/shared/widgets/common/chip_list.dart';
import 'package:tripgether/shared/widgets/common/profile_avatar.dart';
import 'package:tripgether/shared/widgets/common/custom_list_tile.dart';
import 'package:tripgether/shared/widgets/common/app_snackbar.dart';
import 'package:tripgether/shared/widgets/common/section_divider.dart';
import 'package:tripgether/shared/widgets/common/info_container.dart';

// Button 위젯
import 'package:tripgether/shared/widgets/buttons/common_button.dart';
import 'package:tripgether/shared/widgets/buttons/social_login_button.dart';

// Card 위젯
import 'package:tripgether/shared/widgets/cards/sns_content_card.dart';
import 'package:tripgether/shared/widgets/cards/place_detail_card.dart';

// Input 위젯
import 'package:tripgether/shared/widgets/inputs/search_bar.dart';
import 'package:tripgether/shared/widgets/inputs/onboarding_text_field.dart';

// Layout 위젯
import 'package:tripgether/shared/widgets/layout/gradient_background.dart';
import 'package:tripgether/shared/widgets/layout/section_header.dart';
import 'package:tripgether/shared/widgets/layout/bottom_navigation.dart';
import 'package:tripgether/shared/widgets/layout/collapsible_title_sliver_app_bar.dart';

// Dialogs 위젯
import 'package:tripgether/shared/widgets/dialogs/common_dialog.dart';
```

---

## Common 위젯

### CommonAppBar

앱 전체에서 사용하는 일관된 AppBar 컴포넌트

#### 1. 홈 화면 AppBar

```dart
CommonAppBar.forHome(
  title: 'Tripgether',
  onMenuPressed: () => _openDrawer(),
  onNotificationPressed: () => _openNotifications(),
)
```

**특징**:
- 왼쪽: 햄버거 메뉴 또는 뒤로가기 (자동 감지)
- 중앙: 제목 (기본값: "Tripgether")
- 오른쪽: 알림 아이콘
- Elevation: 0 (기본), 스크롤 시 1

#### 2. 서브 페이지 AppBar

```dart
CommonAppBar.forSubPage(
  title: '장소 목록',
  rightActions: [
    IconButton(
      icon: Icon(Icons.filter_list),
      onPressed: () => _showFilter(),
    ),
  ],
)
```

**특징**:
- 왼쪽: 뒤로가기 아이콘 (자동)
- 중앙: 제목
- 오른쪽: 커스텀 액션 버튼들

#### 3. 설정 화면 AppBar

```dart
CommonAppBar.forSettings(
  context: context,
  title: '프로필 편집',
  onSavePressed: () => _save(),
)
```

**특징**:
- 왼쪽: 뒤로가기 아이콘
- 중앙: 제목
- 오른쪽: 체크 아이콘 (저장)

#### 4. 온보딩 화면 AppBar

```dart
CommonAppBar.forOnboarding(
  pageController: _pageController,
  count: 5,
  currentPage: _currentPage,
  onBackPressed: () => _pageController.previousPage(),
)
```

**특징**:
- 중앙: 진행도 인디케이터
- 왼쪽: 조건부 뒤로가기 (첫 페이지가 아닐 때만)
- 배경 투명

#### API

| 파라미터 | 타입 | 기본값 | 설명 |
|----------|------|--------|------|
| `title` | `String?` | `null` | AppBar 제목 |
| `titleWidget` | `Widget?` | `null` | 커스텀 제목 위젯 |
| `leftAction` | `Widget?` | `null` | 왼쪽 커스텀 액션 |
| `rightActions` | `List<Widget>?` | `null` | 오른쪽 액션 버튼들 |
| `onMenuPressed` | `VoidCallback?` | `null` | 메뉴 버튼 콜백 |
| `onNotificationPressed` | `VoidCallback?` | `null` | 알림 버튼 콜백 |
| `showBackButton` | `bool?` | `null` | 뒤로가기 버튼 강제 표시 |
| `showMenuButton` | `bool` | `true` | 메뉴 버튼 표시 여부 |
| `showNotificationIcon` | `bool` | `true` | 알림 아이콘 표시 여부 |
| `elevation` | `double` | `0` | 그림자 높이 |

---

### EmptyState

빈 상태를 표시하는 위젯 (데이터 없음, 검색 결과 없음, 네트워크 오류 등)

#### 기본 사용

```dart
EmptyState(
  icon: Icons.search_off,
  title: '검색 결과가 없습니다',
  message: '다른 키워드로 검색해보세요',
)
```

#### 액션 버튼 포함

```dart
EmptyState(
  icon: Icons.wifi_off,
  title: '연결 오류',
  message: '네트워크 연결을 확인해주세요',
  action: PrimaryButton(
    text: '다시 시도',
    onPressed: () => _retry(),
  ),
)
```

#### 팩토리 메서드

```dart
// 검색 결과 없음
EmptyStates.noSearchResults(
  title: '검색 결과가 없습니다',
  message: '다른 키워드로 검색해보세요',
)

// 데이터 없음
EmptyStates.noData(
  title: '데이터가 없습니다',
)

// 네트워크 오류
EmptyStates.networkError(
  title: '연결 오류',
  action: PrimaryButton(text: '다시 시도', onPressed: _retry),
)

// 권한 없음
EmptyStates.noPermission(
  title: '접근 권한이 없습니다',
  message: '관리자에게 문의하세요',
)

// 아직 추가된 항목 없음
EmptyStates.notYetAdded(
  title: '아직 추가된 코스가 없습니다',
  action: PrimaryButton(text: '코스 추가하기', onPressed: _addCourse),
)
```

#### API

| 파라미터 | 타입 | 기본값 | 설명 |
|----------|------|--------|------|
| `icon` | `IconData` | 필수 | 표시할 아이콘 |
| `title` | `String` | 필수 | 주요 메시지 (제목) |
| `message` | `String?` | `null` | 부가 설명 메시지 |
| `action` | `Widget?` | `null` | 액션 버튼 (예: 다시 시도) |
| `iconSize` | `double?` | `64.w` | 아이콘 크기 |
| `iconColor` | `Color?` | `AppColors.neutral70` | 아이콘 색상 |

---

### ChipList & SelectableChipList

#### ChipList (읽기 전용, 탭 가능)

```dart
ChipList(
  items: ['데이트', '산책', '빈티지', '카페'],
  onItemTap: (item) => _handleChipTap(item),
  horizontalSpacing: AppSpacing.xs.w,
  verticalSpacing: AppSpacing.xs.h,
)
```

#### SelectableChipList (선택 가능)

```dart
SelectableChipList(
  items: ['전체', '맛집', '카페', '관광지', '숙소'],
  selectedItems: _selectedCategories,
  onSelectionChanged: (selectedItems) {
    setState(() {
      _selectedCategories = selectedItems;
    });
  },
  singleSelection: false, // true면 단일 선택, false면 다중 선택
  showBorder: true, // 외곽선 표시 여부
)
```

**외곽선 없는 SNS 필터 예시**:
```dart
SelectableChipList(
  items: ['전체', '유튜브', '인스타그램'],
  selectedItems: {_selectedCategory},
  singleSelection: true,
  showBorder: false,
  onSelectionChanged: (selected) {
    setState(() => _selectedCategory = selected.first);
  },
)
```

#### API

**ChipList**

| 파라미터 | 타입 | 기본값 | 설명 |
|----------|------|--------|------|
| `items` | `List<String>` | 필수 | 칩 텍스트 리스트 |
| `onItemTap` | `void Function(String)?` | `null` | 칩 탭 시 콜백 |
| `horizontalSpacing` | `double?` | `8.w` | 칩 간 가로 간격 |
| `verticalSpacing` | `double?` | `8.h` | 칩 간 세로 간격 |
| `backgroundColor` | `Color?` | `AppColors.subColor2.withAlpha(0.95)` | 칩 배경색 |
| `borderColor` | `Color?` | `AppColors.subColor2.withAlpha(0.9)` | 칩 테두리 색상 |

**SelectableChipList**

| 파라미터 | 타입 | 기본값 | 설명 |
|----------|------|--------|------|
| `items` | `List<String>` | 필수 | 칩 텍스트 리스트 |
| `selectedItems` | `Set<String>` | 필수 | 현재 선택된 항목들 |
| `onSelectionChanged` | `void Function(Set<String>)` | 필수 | 선택 변경 시 콜백 |
| `singleSelection` | `bool` | `false` | 단일 선택 모드 여부 |
| `showBorder` | `bool` | `true` | 외곽선 표시 여부 |

---

### ProfileAvatar

프로필 이미지를 표시하는 아바타 위젯

```dart
// 기본 아바타
ProfileAvatar(
  imageUrl: user.profileImageUrl,
  size: ProfileAvatarSize.large,
  onTap: () => _viewProfile(),
)

// 테두리 포함
ProfileAvatar(
  imageUrl: user.profileImageUrl,
  size: ProfileAvatarSize.medium,
  showBorder: true,
)

// 뱃지 포함
ProfileAvatarWithBadge(
  imageUrl: user.profileImageUrl,
  size: ProfileAvatarSize.medium,
  badgeIcon: Icons.verified,
  badgeColor: Colors.blue,
)

// 편집 버튼 포함
ProfileAvatarWithEdit(
  imageUrl: user.profileImageUrl,
  size: ProfileAvatarSize.xLarge,
  onEditPressed: () => _pickImage(),
)
```

#### 크기 프리셋 (ProfileAvatarSize)

```dart
ProfileAvatarSize.small   // 32dp (댓글, 채팅 리스트)
ProfileAvatarSize.medium  // 56dp (앱바, 네비게이션 헤더)
ProfileAvatarSize.large   // 80dp (프로필 헤더)
ProfileAvatarSize.xLarge  // 120dp (프로필 수정 화면)
```

#### API

| 파라미터 | 타입 | 기본값 | 설명 |
|----------|------|--------|------|
| `imageUrl` | `String?` | `null` | 프로필 이미지 URL |
| `size` | `ProfileAvatarSize` | `ProfileAvatarSize.medium` | 아바타 크기 |
| `showBorder` | `bool` | `false` | 테두리 표시 여부 |
| `onTap` | `VoidCallback?` | `null` | 탭 시 콜백 |
| `backgroundColor` | `Color?` | `null` | 기본 아이콘 배경색 |

---

### CustomListTile, IconListTile, ActionListTile

리스트 아이템을 일관된 스타일로 표시하는 위젯

#### 기본 ListTile

```dart
CustomListTile(
  leading: Icon(Icons.history),
  title: '최근 검색어',
  subtitle: '데이트 코스',
  trailing: Text('2분 전'),
  onTap: () => _navigateToSearch(),
)
```

#### 아이콘 ListTile

```dart
IconListTile(
  icon: Icons.history,
  iconColor: AppColors.neutral60,
  title: '최근 검색어',
  subtitle: '데이트 코스',
  trailing: Text('2분 전'),
  onTap: () => _navigateToSearch(),
)
```

#### 액션 버튼 ListTile

```dart
ActionListTile(
  leading: Icon(Icons.search),
  title: '데이트 코스',
  subtitle: '방금 검색',
  actionIcon: Icons.close,
  onActionTap: () => _removeSearch(),
  onTap: () => _navigateToSearch(),
)
```

#### API

| 파라미터 | 타입 | 기본값 | 설명 |
|----------|------|--------|------|
| `title` | `String` | 필수 | 제목 텍스트 |
| `subtitle` | `String?` | `null` | 부제목 텍스트 |
| `leading` | `Widget?` | `null` | 왼쪽 위젯 |
| `trailing` | `Widget?` | `null` | 오른쪽 위젯 |
| `onTap` | `VoidCallback?` | `null` | 타일 탭 시 콜백 |

---

### AppSnackBar

앱 전체에서 사용하는 공용 SnackBar

```dart
// 기본 사용
AppSnackBar.show(context, message: '로그인되었습니다');

// 성공 메시지
AppSnackBar.showSuccess(context, '저장되었습니다');

// 정보 메시지
AppSnackBar.showInfo(context, '언어가 변경되었습니다');

// 오류 메시지
AppSnackBar.showError(context, '오류가 발생했습니다');

// 커스텀 duration
AppSnackBar.show(
  context,
  message: '잠시 후 다시 시도해주세요',
  duration: Duration(seconds: 5),
);
```

#### API

| 파라미터 | 타입 | 기본값 | 설명 |
|----------|------|--------|------|
| `message` | `String` | 필수 | 표시할 메시지 |
| `duration` | `Duration` | `Duration(seconds: 3)` | 표시 시간 |
| `backgroundColor` | `Color?` | `AppColors.grayPurple` | 배경색 |

---

### SectionDivider

섹션 구분선 위젯

```dart
// 얇은 라인 구분선
SectionDivider.thin()

// 커스텀 패딩
SectionDivider.thin(
  horizontalPadding: AppSpacing.xxl,
)

// 두꺼운 배경 구분선
SectionDivider.thick()

// 커스텀 높이
SectionDivider.thick(
  height: AppSpacing.lg.h,
)
```

#### API

| 파라미터 | 타입 | 기본값 | 설명 |
|----------|------|--------|------|
| `type` | `SectionDividerType` | `thin` | 구분선 타입 (thin/thick) |
| `horizontalPadding` | `double?` | `AppSpacing.lg` | 좌우 패딩 (thin 타입) |
| `height` | `double?` | `AppSpacing.xs.h` | 높이 (thick 타입) |
| `color` | `Color?` | `null` | 커스텀 색상 |

---

### InfoContainer

정보 표시용 컨테이너 위젯

```dart
// 기본 사용
InfoContainer(
  title: '공유된 데이터',
  titleIcon: Icons.info,
  child: Text('콘텐츠 정보가 여기에 표시됩니다.'),
  actions: [
    TextButton(child: Text('확인'), onPressed: () {}),
  ],
)

// 성공 메시지
SuccessInfoContainer(
  title: '저장 완료',
  child: Text('변경사항이 성공적으로 저장되었습니다.'),
)

// 경고 메시지
WarningInfoContainer(
  title: '주의',
  child: Text('이 작업은 되돌릴 수 없습니다.'),
)

// 에러 메시지
ErrorInfoContainer(
  title: '오류 발생',
  child: Text('네트워크 연결을 확인해주세요.'),
)
```

#### API

| 파라미터 | 타입 | 기본값 | 설명 |
|----------|------|--------|------|
| `title` | `String?` | `null` | 제목 |
| `titleIcon` | `IconData?` | `null` | 제목 아이콘 |
| `child` | `Widget` | 필수 | 메인 콘텐츠 |
| `actions` | `List<Widget>?` | `null` | 하단 액션 버튼들 |

---

## Buttons 위젯

### PrimaryButton

주요 액션을 위한 버튼 (ElevatedButton 기반)

```dart
PrimaryButton(
  text: '저장',
  onPressed: () => _save(),
)

// 아이콘 포함
PrimaryButton(
  text: '다음',
  icon: Icons.arrow_forward,
  onPressed: () => _goNext(),
)

// 로딩 상태
PrimaryButton(
  text: '저장 중...',
  isLoading: true,
  onPressed: () => _save(),
)

// 전체 너비가 아닌 컨텐츠 크기
PrimaryButton(
  text: '확인',
  isFullWidth: false,
  onPressed: () => _confirm(),
)
```

#### API

| 파라미터 | 타입 | 기본값 | 설명 |
|----------|------|--------|------|
| `text` | `String` | 필수 | 버튼 텍스트 |
| `onPressed` | `VoidCallback?` | 필수 | 탭 시 콜백 (null이면 비활성화) |
| `icon` | `IconData?` | `null` | 왼쪽에 표시할 아이콘 |
| `isFullWidth` | `bool` | `true` | 화면 전체 너비 사용 여부 |
| `height` | `double?` | `AppSizes.buttonHeight` | 버튼 높이 |
| `isLoading` | `bool` | `false` | 로딩 상태 표시 여부 |

---

### SecondaryButton

보조 액션을 위한 버튼 (OutlinedButton 기반)

```dart
SecondaryButton(
  text: '취소',
  onPressed: () => _cancel(),
)

// 작은 높이
SecondaryButton(
  text: '닫기',
  height: AppSizes.buttonHeightSmall,
  onPressed: () => context.pop(),
)
```

#### API

| 파라미터 | 타입 | 기본값 | 설명 |
|----------|------|--------|------|
| `text` | `String` | 필수 | 버튼 텍스트 |
| `onPressed` | `VoidCallback?` | 필수 | 탭 시 콜백 |
| `icon` | `IconData?` | `null` | 왼쪽에 표시할 아이콘 |
| `isFullWidth` | `bool` | `true` | 화면 전체 너비 사용 여부 |
| `height` | `double?` | `AppSizes.buttonHeight` | 버튼 높이 |

---

### TertiaryButton

텍스트만 있는 버튼 (TextButton 기반)

```dart
TertiaryButton(
  text: '건너뛰기',
  onPressed: () => _skip(),
)
```

#### API

| 파라미터 | 타입 | 기본값 | 설명 |
|----------|------|--------|------|
| `text` | `String` | 필수 | 버튼 텍스트 |
| `onPressed` | `VoidCallback?` | 필수 | 탭 시 콜백 |

---

### CommonIconButton

일관된 스타일의 아이콘 버튼

```dart
CommonIconButton(
  icon: Icons.favorite,
  onPressed: () => _toggleFavorite(),
  tooltip: '좋아요',
  hasBackground: true,
  backgroundColor: AppColors.primary,
)
```

#### API

| 파라미터 | 타입 | 기본값 | 설명 |
|----------|------|--------|------|
| `icon` | `IconData` | 필수 | 표시할 아이콘 |
| `onPressed` | `VoidCallback?` | 필수 | 탭 시 콜백 |
| `tooltip` | `String?` | `null` | 접근성 툴팁 |
| `hasBackground` | `bool` | `false` | 배경 표시 여부 |

---

### LinkButton

링크 바로가기 버튼

```dart
LinkButton(
  text: '링크 바로가기',
  onPressed: () => _openUrl(),
)

// 커스텀 아이콘
LinkButton(
  text: '상세보기',
  iconPath: 'assets/icons/open.svg',
  textStyle: AppTextStyles.labelMedium,
  onPressed: () => _openDetail(),
)
```

#### API

| 파라미터 | 타입 | 기본값 | 설명 |
|----------|------|--------|------|
| `text` | `String` | 필수 | 버튼 텍스트 |
| `onPressed` | `VoidCallback?` | 필수 | 탭 시 콜백 |
| `iconPath` | `String?` | `'assets/icons/link.svg'` | SVG 아이콘 경로 |

---

### ButtonGroup

여러 버튼을 그룹화하여 표시 (가로/세로 배치)

```dart
// 가로 배치 (취소 | 확인)
ButtonGroup(
  children: [
    SecondaryButton(text: '취소', onPressed: _cancel),
    PrimaryButton(text: '확인', onPressed: _confirm),
  ],
  isHorizontal: true,
  spacing: AppSpacing.md,
)

// 세로 배치
ButtonGroup(
  children: [
    PrimaryButton(text: '저장', onPressed: _save),
    SecondaryButton(text: '취소', onPressed: _cancel),
  ],
  isHorizontal: false,
  spacing: AppSpacing.sm,
)
```

#### API

| 파라미터 | 타입 | 기본값 | 설명 |
|----------|------|--------|------|
| `children` | `List<Widget>` | 필수 | 버튼 위젯 리스트 |
| `isHorizontal` | `bool` | `true` | 가로 배치 여부 (false면 세로) |
| `spacing` | `double` | `AppSpacing.sm` | 버튼 간 간격 |

---

### SocialLoginButton

소셜 로그인 버튼 (Google, Kakao, Naver, Apple)

```dart
SocialLoginButton(
  text: "Google로 시작하기",
  backgroundColor: AppColorPalette.googleButton,
  textColor: Colors.black,
  icon: SvgPicture.asset('assets/icons/google.svg', width: 20.w),
  onPressed: () => _loginWithGoogle(),
  isLoading: _isGoogleLoading,
)
```

#### 플랫폼별 색상

```dart
// Google
SocialLoginButton(
  text: "Google로 시작하기",
  backgroundColor: AppColorPalette.googleButton,  // #F1F1F1
  textColor: Colors.black,
)

// Kakao
SocialLoginButton(
  text: "Kakao로 시작하기",
  backgroundColor: AppColorPalette.kakaoButton,   // #FEE500
  textColor: Colors.black,
)

// Naver
SocialLoginButton(
  text: "Naver로 시작하기",
  backgroundColor: AppColorPalette.naverButton,   // #03C75A
  textColor: Colors.white,
)

// Apple
SocialLoginButton(
  text: "Apple로 시작하기",
  backgroundColor: AppColorPalette.appleButton,   // #000000
  textColor: Colors.white,
)
```

#### API

| 파라미터 | 타입 | 기본값 | 설명 |
|----------|------|--------|------|
| `text` | `String` | 필수 | 버튼 텍스트 |
| `backgroundColor` | `Color` | 필수 | 배경색 |
| `textColor` | `Color` | 필수 | 텍스트 색상 |
| `icon` | `Widget?` | `null` | 왼쪽 아이콘 (SvgPicture 등) |
| `onPressed` | `VoidCallback` | 필수 | 탭 시 콜백 |
| `isLoading` | `bool` | `false` | 로딩 상태 표시 여부 |

---

## Cards 위젯

### SnsContentCard

SNS 콘텐츠를 표시하는 카드 (썸네일, 제목, 플랫폼 아이콘)

```dart
// 기본 사용 (텍스트 오버레이 포함)
SnsContentCard(
  content: snsContent,
  onTap: () => _openContentDetail(snsContent),
  width: AppSizes.snsCardWidth,
  height: AppSizes.snsCardHeight,
)

// 플랫폼 로고만 표시 (GridView용)
SnsContentCard(
  content: snsContent,
  showTextOverlay: false,
  logoIconSize: AppSizes.iconSmall,
  logoPadding: EdgeInsets.all(AppSpacing.sm),
  onTap: () => _openContentDetail(snsContent),
)
```

#### API

| 파라미터 | 타입 | 기본값 | 설명 |
|----------|------|--------|------|
| `content` | `ContentModel` | 필수 | SNS 콘텐츠 데이터 모델 |
| `onTap` | `VoidCallback?` | `null` | 카드 탭 시 콜백 |
| `width` | `double?` | `AppSizes.snsCardWidth` | 카드 너비 |
| `height` | `double?` | `AppSizes.snsCardHeight` | 카드 높이 |
| `showTextOverlay` | `bool` | `true` | 텍스트 오버레이 표시 여부 |
| `logoIconSize` | `double?` | `AppSizes.iconSmall` | 로고 아이콘 크기 (showTextOverlay=false) |
| `logoPadding` | `EdgeInsets?` | `EdgeInsets.all(AppSpacing.sm)` | 로고 패딩 (showTextOverlay=false) |

---

### PlaceDetailCard

장소 상세 정보를 표시하는 카드

```dart
PlaceDetailCard(
  category: '카페',
  placeName: '스타벅스 강남점',
  address: '서울 강남구 테헤란로 123',
  rating: 4.5,
  reviewCount: 92,
  imageUrls: [
    'https://example.com/image1.jpg',
    'https://example.com/image2.jpg',
  ],
  onTap: () => _openPlaceDetail(),
)
```

#### API

| 파라미터 | 타입 | 기본값 | 설명 |
|----------|------|--------|------|
| `category` | `String` | 필수 | 카테고리 (예: "카페") |
| `placeName` | `String` | 필수 | 장소 이름 |
| `address` | `String` | 필수 | 주소 |
| `rating` | `double` | 필수 | 평점 (예: 4.5) |
| `reviewCount` | `int` | 필수 | 리뷰 수 (예: 92) |
| `imageUrls` | `List<String>` | 필수 | 이미지 URL 리스트 |
| `onTap` | `VoidCallback?` | `null` | 카드 탭 시 콜백 |

---

## Inputs 위젯

### TripSearchBar

검색바 위젯 (키워드, 도시, 장소 검색)

#### 읽기 전용 (탭하여 검색 화면 이동)

```dart
TripSearchBar(
  hintText: '키워드·도시·장소를 검색해 보세요',
  readOnly: true,
  onTap: () => context.push(AppRoutes.search),
)
```

#### 직접 입력

```dart
TripSearchBar(
  controller: _searchController,
  onChanged: (query) => _handleSearch(query),
  onSubmitted: (query) => _submitSearch(query),
  autofocus: true,
)
```

#### API

| 파라미터 | 타입 | 기본값 | 설명 |
|----------|------|--------|------|
| `hintText` | `String` | `'키워드·도시·장소를 검색해 보세요'` | 힌트 텍스트 |
| `readOnly` | `bool` | `false` | 읽기 전용 모드 (탭만 가능) |
| `onTap` | `VoidCallback?` | `null` | 탭 시 콜백 (readOnly=true일 때 유용) |
| `onChanged` | `void Function(String)?` | `null` | 텍스트 변경 시 콜백 |
| `onSubmitted` | `void Function(String)?` | `null` | 검색 제출 시 콜백 |
| `autofocus` | `bool` | `false` | 자동 포커스 여부 |
| `controller` | `TextEditingController?` | `null` | 텍스트 컨트롤러 (외부 관리) |

---

### OnboardingTextField

온보딩 화면용 텍스트 입력 필드

```dart
OnboardingTextField(
  controller: _nameController,
  hintText: '이름을 입력하세요',
  maxLength: 10,
  keyboardType: TextInputType.name,
)
```

#### API

| 파라미터 | 타입 | 기본값 | 설명 |
|----------|------|--------|------|
| `controller` | `TextEditingController?` | `null` | 텍스트 컨트롤러 |
| `hintText` | `String?` | `null` | 힌트 텍스트 |
| `maxLength` | `int?` | `null` | 최대 입력 길이 |
| `textAlign` | `TextAlign` | `TextAlign.center` | 텍스트 정렬 |
| `keyboardType` | `TextInputType?` | `null` | 키보드 타입 |
| `onChanged` | `void Function(String)?` | `null` | 값 변경 콜백 |

---

## Layout 위젯

### GradientBackground

그라데이션 배경 위젯 (주로 홈 화면 상단에 사용)

```dart
GradientBackground(
  padding: EdgeInsets.all(AppSpacing.lg),
  child: Column(
    children: [
      GreetingSection(userName: user.nickname),
      AppSpacing.verticalSpaceLG,
      TripSearchBar(readOnly: true, onTap: () => _goToSearch()),
    ],
  ),
)
```

#### API

| 파라미터 | 타입 | 기본값 | 설명 |
|----------|------|--------|------|
| `child` | `Widget` | 필수 | 그라데이션 배경 위에 표시할 위젯 |
| `padding` | `EdgeInsetsGeometry?` | `EdgeInsets.all(AppSpacing.lg)` | 내부 패딩 |

---

### SectionHeader

섹션 제목과 더보기 버튼을 표시하는 헤더

```dart
SectionHeader(
  title: '추천 장소',
  onMoreTap: () => _seeMorePlaces(),
)

// 더보기 버튼 없이
SectionHeader(
  title: '내 정보',
  showMoreButton: false,
)

// 커스텀 trailing 위젯
SectionHeader(
  title: '필터',
  trailing: IconButton(
    icon: Icon(Icons.filter_list),
    onPressed: () => _showFilter(),
  ),
)
```

#### API

| 파라미터 | 타입 | 기본값 | 설명 |
|----------|------|--------|------|
| `title` | `String` | 필수 | 섹션 제목 |
| `onMoreTap` | `VoidCallback?` | `null` | 더보기 버튼 탭 시 콜백 |
| `showMoreButton` | `bool` | `true` | 더보기 버튼 표시 여부 |
| `trailing` | `Widget?` | `null` | 커스텀 우측 위젯 |

---

### CustomBottomNavigationBar

바텀 네비게이션 바

```dart
CustomBottomNavigationBar(
  currentIndex: _currentIndex,
  onTap: (index) {
    setState(() {
      _currentIndex = index;
    });
    _navigateToTab(index);
  },
  onTabReselected: (index) {
    // 같은 탭을 다시 클릭했을 때 스크롤을 최상단으로
    _scrollToTop();
  },
)
```

#### API

| 파라미터 | 타입 | 기본값 | 설명 |
|----------|------|--------|------|
| `currentIndex` | `int` | 필수 | 현재 선택된 탭 인덱스 (0~4) |
| `onTap` | `void Function(int)` | 필수 | 탭 선택 시 콜백 (인덱스 전달) |
| `onTabReselected` | `void Function(int)?` | `null` | 탭 재선택 시 콜백 |

**탭 인덱스**:
- `0`: 홈
- `1`: 코스마켓
- `2`: 지도
- `3`: 일정
- `4`: 마이페이지

---

### CollapsibleTitleSliverAppBar

스크롤 시 제목이 점진적으로 축소되며 사라지는 SliverAppBar

```dart
// 홈 화면: 인사말 2줄 축소
CollapsibleTitleSliverAppBar(
  expandedHeight: 190.h,
  title: SvgPicture.asset('logo.svg'),
  actions: [NotificationButton()],
  collapsibleContent: (expandRatio) => Opacity(
    opacity: expandRatio,
    child: Text('안녕하세요!'),
  ),
  bottom: PreferredSize(child: SearchBar()),
)

// SNS 콘텐츠: 제목 1줄 축소
CollapsibleTitleSliverAppBar(
  expandedHeight: 140.h,
  actions: [PopupMenuButton()],
  collapsibleContent: (expandRatio) => Opacity(
    opacity: expandRatio,
    child: Text('최근 본 콘텐츠'),
  ),
  bottom: PreferredSize(child: CategoryChips()),
)
```

#### API

| 파라미터 | 타입 | 기본값 | 설명 |
|----------|------|--------|------|
| `collapsibleContent` | `Widget Function(double)` | 필수 | 축소되는 제목 영역 빌더 (expandRatio: 0.0~1.0) |
| `expandedHeight` | `double` | 필수 | SliverAppBar 확장 높이 |
| `title` | `Widget?` | `null` | 상단 고정 타이틀 위젯 |
| `actions` | `List<Widget>?` | `null` | 우측 액션 버튼들 |
| `bottom` | `PreferredSizeWidget?` | `null` | 하단 고정 영역 |
| `pinned` | `bool` | `true` | 스크롤 시 최소 높이 유지 여부 |

---

## Dialogs 위젯

### CommonDialog

공용 다이얼로그 컴포넌트

#### 삭제 확인 다이얼로그

```dart
showDialog(
  context: context,
  builder: (context) => CommonDialog.forDelete(
    title: '장소를 삭제하시겠습니까?',
    description: '삭제된 장소는 복구할 수 없습니다.',
    subtitle: '연관된 코스도 함께 삭제됩니다.',
    onConfirm: () => _deletePlace(),
  ),
);
```

#### 오류 제보 다이얼로그

```dart
showDialog(
  context: context,
  builder: (context) => CommonDialog.forError(
    title: '오류가 발생했습니다',
    description: '네트워크 연결을 확인해주세요.',
    subtitle: '오류 코드: 500',
  ),
);
```

#### 확인 다이얼로그

```dart
showDialog(
  context: context,
  builder: (context) => CommonDialog.forConfirm(
    title: '변경사항을 저장하시겠습니까?',
    description: '저장하지 않으면 변경사항이 사라집니다.',
    onConfirm: () => _saveChanges(),
  ),
);
```

#### 성공 알림 다이얼로그

```dart
showDialog(
  context: context,
  builder: (context) => CommonDialog.forSuccess(
    title: '저장 완료',
    description: '변경사항이 성공적으로 저장되었습니다.',
  ),
);
```

#### 텍스트 입력 다이얼로그

```dart
final controller = TextEditingController();
showDialog(
  context: context,
  builder: (_) => CommonDialog.forInput(
    title: '오류 제보',
    subtitle: '작은 오류 제보도 큰 개선으로 이어집니다.\n자유롭게 적어주세요',
    inputHint: '오류 내용을 입력해주세요',
    controller: controller,
    onSubmit: (text) => _submitReport(text),
  ),
).then((_) => controller.dispose());
```

#### API

| 파라미터 | 타입 | 기본값 | 설명 |
|----------|------|--------|------|
| `title` | `String` | 필수 | 다이얼로그 제목 |
| `description` | `String` | 필수 | 메인 설명 텍스트 |
| `subtitle` | `String?` | `null` | 부가 설명 텍스트 |
| `leftButtonText` | `String?` | `null` | 왼쪽 버튼 텍스트 |
| `rightButtonText` | `String?` | `null` | 오른쪽 버튼 텍스트 |
| `onLeftPressed` | `VoidCallback?` | `null` | 왼쪽 버튼 콜백 |
| `onRightPressed` | `VoidCallback?` | `null` | 오른쪽 버튼 콜백 |
| `autoDismiss` | `bool` | `true` | 자동 닫기 여부 |

---

## 개발 가이드라인

### 1. 새로운 공용 위젯 추가 시

```dart
// 1. shared/widgets/ 내 적절한 카테고리 디렉토리에 추가
// 예: shared/widgets/cards/new_card.dart

// 2. 위젯 클래스 작성 (문서 주석 필수)
/// 새로운 카드 위젯
///
/// 특정 데이터를 카드 형태로 표시합니다.
///
/// 사용 예시:
/// ```dart
/// NewCard(
///   data: myData,
///   onTap: () => _handleTap(),
/// )
/// ```
class NewCard extends StatelessWidget {
  // ...
}

// 3. 디자인 시스템 사용 (AppColors, AppTextStyles, AppSpacing)
// 4. 반응형 크기 사용 (ScreenUtil: .w, .h, .sp, .r)
// 5. 문서 업데이트 (이 파일 Widgets.md)
```

### 2. 기존 위젯 수정 시

```dart
// ❌ WRONG - 직접 수정하지 말고 팀과 논의
// 기존 위젯을 수정하면 전체 앱에 영향을 미칩니다.

// ✅ RIGHT - 새로운 Variant 추가 또는 파라미터 확장
class ExistingCard extends StatelessWidget {
  // 기존 파라미터 유지
  final String title;

  // 새로운 파라미터 추가 (기본값 설정으로 기존 코드 호환성 유지)
  final bool showBadge;

  const ExistingCard({
    required this.title,
    this.showBadge = false, // 기본값으로 기존 동작 유지
  });
}
```

### 3. 재사용 위젯 선택 기준

**공용 위젯으로 만들어야 하는 경우**:
- ✅ 3개 이상의 화면에서 사용될 UI 컴포넌트
- ✅ 디자인 일관성이 중요한 공통 요소 (버튼, 카드, 입력 필드 등)
- ✅ 복잡한 UI 로직을 캡슐화하여 재사용할 필요가 있는 경우

**화면 전용 위젯으로 유지해야 하는 경우**:
- ❌ 해당 화면에서만 사용되는 특수한 UI
- ❌ 비즈니스 로직이 화면에 종속된 위젯
- ❌ 디자인이 자주 변경될 가능성이 높은 실험적 UI

---

## 모범 사례

### ✅ 올바른 예시

```dart
// 1. 공용 위젯 재사용
import 'package:tripgether/shared/widgets/buttons/common_button.dart';

PrimaryButton(
  text: '저장',
  onPressed: () => _save(),
)

// 2. 공용 위젯 조합
Column(
  children: [
    SectionHeader(
      title: '추천 장소',
      onMoreTap: () => _seeMore(),
    ),
    AppSpacing.verticalSpaceLG,
    PlaceListSection(places: _places),
  ],
)
```

### ❌ 잘못된 예시

```dart
// 1. 중복 UI 생성 (공용 위젯 있음에도 직접 작성)
AppBar(
  title: Text('제목'),
  leading: IconButton(
    icon: Icon(Icons.arrow_back),
    onPressed: () => context.pop(),
  ),
)
// ❌ CommonAppBar.forSubPage 사용 필수!

// 2. 하드코딩된 스타일
ElevatedButton(
  style: ElevatedButton.styleFrom(
    backgroundColor: Color(0xFF664BAE), // ❌ AppColors.primary
    padding: EdgeInsets.all(16), // ❌ AppSpacing
  ),
  child: Text('확인'),
)
// ❌ PrimaryButton 사용 필수!

// 3. 직접 구현한 빈 상태 표시
Center(
  child: Column(
    children: [
      Icon(Icons.inbox),
      Text('데이터 없음'),
    ],
  ),
)
// ❌ EmptyState 사용 필수!
```

---

## 참고 자료

- [DesignSystem.md](DesignSystem.md) - 디자인 시스템 가이드
- [Architecture.md](Architecture.md) - 아키텍처 문서
- [Flutter 공식 위젯 카탈로그](https://docs.flutter.dev/ui/widgets)

---

**Last Updated**: 2025-11-20
**Version**: 2.0.0
**Maintained by**: [@EM-H20](https://github.com/EM-H20)
