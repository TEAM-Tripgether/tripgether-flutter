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
├── common/         # 범용 위젯 (AppBar, EmptyState, Chip, Avatar)
├── buttons/        # 버튼 위젯 (Primary, Secondary, Tertiary, Social Login)
├── cards/          # 카드 위젯 (SNS Content, Place, Course)
├── inputs/         # 입력 위젯 (SearchBar, TextField)
└── layout/         # 레이아웃 위젯 (GradientBackground, SectionHeader, BottomNav)
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

// Button 위젯
import 'package:tripgether/shared/widgets/buttons/common_button.dart';
import 'package:tripgether/shared/widgets/buttons/social_login_button.dart';

// Card 위젯
import 'package:tripgether/shared/widgets/cards/sns_content_card.dart';
import 'package:tripgether/shared/widgets/cards/place_card.dart';
import 'package:tripgether/shared/widgets/cards/course_card.dart';

// Input 위젯
import 'package:tripgether/shared/widgets/inputs/search_bar.dart';
import 'package:tripgether/shared/widgets/inputs/onboarding_text_field.dart';

// Layout 위젯
import 'package:tripgether/shared/widgets/layout/gradient_background.dart';
import 'package:tripgether/shared/widgets/layout/section_header.dart';
import 'package:tripgether/shared/widgets/layout/bottom_navigation.dart';
```

---

## Common 위젯

### CommonAppBar

앱 전체에서 사용하는 일관된 AppBar 컴포넌트

#### 1. 홈 화면 AppBar

```dart
CommonAppBar.forHome(
  onMenuPressed: () => _openDrawer(),
  onNotificationPressed: () => _openNotifications(),
)
```

**특징**:
- 왼쪽: 메뉴 아이콘
- 오른쪽: 알림 아이콘
- Elevation: 0 (기본), 스크롤 시 1

#### 2. 서브 페이지 AppBar

```dart
CommonAppBar.forSubPage(
  title: '장소 목록',
  onBackPressed: () => context.pop(),
  rightActions: [
    IconButton(
      icon: Icon(Icons.filter_list),
      onPressed: () => _showFilter(),
    ),
  ],
)
```

**특징**:
- 왼쪽: 뒤로가기 아이콘
- 중앙: 제목
- 오른쪽: 선택적 액션 버튼들

#### 3. 설정 화면 AppBar

```dart
CommonAppBar.forSettings(
  title: '프로필 편집',
  onBackPressed: () => context.pop(),
  onSavePressed: () => _save(),
  isSaveEnabled: _isFormValid,
)
```

**특징**:
- 왼쪽: 뒤로가기 아이콘
- 중앙: 제목
- 오른쪽: 저장 버튼 (활성화/비활성화 상태)

#### API

| 파라미터 | 타입 | 기본값 | 설명 |
|----------|------|--------|------|
| `title` | `String?` | `null` | AppBar 제목 |
| `onBackPressed` | `VoidCallback?` | `null` | 뒤로가기 버튼 콜백 |
| `onMenuPressed` | `VoidCallback?` | `null` | 메뉴 버튼 콜백 |
| `onNotificationPressed` | `VoidCallback?` | `null` | 알림 버튼 콜백 |
| `onSavePressed` | `VoidCallback?` | `null` | 저장 버튼 콜백 |
| `isSaveEnabled` | `bool` | `true` | 저장 버튼 활성화 여부 |
| `rightActions` | `List<Widget>?` | `null` | 오른쪽 커스텀 액션 버튼 |

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

// 아직 추가된 항목 없음
EmptyStates.notYetAdded(
  title: '아직 추가된 코스가 없습니다',
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
)
```

#### API

**ChipList**

| 파라미터 | 타입 | 기본값 | 설명 |
|----------|------|--------|------|
| `items` | `List<String>` | 필수 | 칩 텍스트 리스트 |
| `onItemTap` | `void Function(String)?` | `null` | 칩 탭 시 콜백 |
| `spacing` | `double?` | `8.w` | 칩 간 가로 간격 |

**SelectableChipList**

| 파라미터 | 타입 | 기본값 | 설명 |
|----------|------|--------|------|
| `items` | `List<String>` | 필수 | 칩 텍스트 리스트 |
| `selectedItems` | `List<String>` | 필수 | 현재 선택된 항목들 |
| `onSelectionChanged` | `void Function(List<String>)` | 필수 | 선택 변경 시 콜백 |
| `singleSelection` | `bool` | `false` | 단일 선택 모드 여부 |

---

### ProfileAvatar

프로필 이미지를 표시하는 아바타 위젯

```dart
ProfileAvatar(
  imageUrl: user.profileImageUrl,
  size: AppSizes.avatarLarge,
  onTap: () => _viewProfile(),
)
```

#### 크기 프리셋

```dart
// 작은 크기 (32)
ProfileAvatar(imageUrl: url, size: AppSizes.avatarSmall)

// 중간 크기 (48)
ProfileAvatar(imageUrl: url, size: AppSizes.avatarMedium)

// 큰 크기 (64)
ProfileAvatar(imageUrl: url, size: AppSizes.avatarLarge)

// 커스텀 크기
ProfileAvatar(imageUrl: url, size: 80.w)
```

#### API

| 파라미터 | 타입 | 기본값 | 설명 |
|----------|------|--------|------|
| `imageUrl` | `String?` | `null` | 프로필 이미지 URL |
| `size` | `double` | `48.w` | 아바타 크기 (정사각형) |
| `onTap` | `VoidCallback?` | `null` | 탭 시 콜백 |
| `placeholder` | `Widget?` | `null` | 이미지 로딩 중 표시할 위젯 |

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
  icon: SvgPicture.asset('assets/icons/google.svg'),
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
| `icon` | `Widget` | 필수 | 왼쪽 아이콘 (SvgPicture 등) |
| `onPressed` | `VoidCallback` | 필수 | 탭 시 콜백 |
| `isLoading` | `bool` | `false` | 로딩 상태 표시 여부 |

---

## Cards 위젯

### SnsContentCard

SNS 콘텐츠를 표시하는 카드 (썸네일, 제목, 플랫폼 아이콘)

```dart
// 단일 카드
SnsContentCard(
  content: snsContent,
  onTap: () => _openContentDetail(snsContent),
  width: 120.w,
  isGridLayout: false,
)

// 그리드용 카드 (세로형)
SnsContentCard(
  content: snsContent,
  onTap: () => _openContentDetail(snsContent),
  isGridLayout: true,
)
```

#### API

| 파라미터 | 타입 | 기본값 | 설명 |
|----------|------|--------|------|
| `content` | `SnsContent` | 필수 | SNS 콘텐츠 데이터 모델 |
| `onTap` | `VoidCallback?` | `null` | 카드 탭 시 콜백 |
| `width` | `double?` | `120.w` | 카드 너비 (isGridLayout=false일 때만) |
| `margin` | `EdgeInsets?` | `EdgeInsets.only(right: 12)` | 카드 외부 여백 |
| `isGridLayout` | `bool` | `false` | 그리드용 세로형 레이아웃 여부 |

---

### SnsContentHorizontalList

SNS 콘텐츠를 가로 스크롤 리스트로 표시

```dart
SnsContentHorizontalList(
  contents: _snsContents,
  title: '추천 콘텐츠',
  onSeeMoreTap: () => _seeMoreContents(),
  onContentTap: (content, index) => _openDetail(content),
)
```

#### API

| 파라미터 | 타입 | 기본값 | 설명 |
|----------|------|--------|------|
| `contents` | `List<SnsContent>` | 필수 | SNS 콘텐츠 리스트 |
| `title` | `String?` | `null` | 섹션 제목 |
| `onSeeMoreTap` | `VoidCallback?` | `null` | 더보기 버튼 탭 시 콜백 |
| `onContentTap` | `void Function(SnsContent, int)?` | `null` | 콘텐츠 탭 시 콜백 |

---

### PlaceCard

저장한 장소를 표시하는 카드

```dart
PlaceCard(
  place: savedPlace,
  onTap: () => _openPlaceDetail(savedPlace),
  onImageTap: (index) => _viewImage(index),
)
```

#### API

| 파라미터 | 타입 | 기본값 | 설명 |
|----------|------|--------|------|
| `place` | `SavedPlace` | 필수 | 저장된 장소 데이터 모델 |
| `onTap` | `VoidCallback?` | `null` | 카드 전체 탭 시 콜백 |
| `onImageTap` | `void Function(int)?` | `null` | 이미지 탭 시 콜백 (인덱스 전달) |

---

### CourseCard

코스를 표시하는 카드

```dart
// 기본 코스 카드
CourseCard(
  course: courseData,
  onTap: () => _openCourse(courseData),
)

// 내 주변 코스 카드 (거리 정보 포함)
NearbyCourseCard(
  course: courseData,
  onTap: () => _openCourse(courseData),
)

// 인기 코스 카드 (좋아요, 조회수 포함)
PopularCourseCard(
  course: courseData,
  onTap: () => _openCourse(courseData),
)
```

#### API

| 파라미터 | 타입 | 기본값 | 설명 |
|----------|------|--------|------|
| `course` | `Course` | 필수 | 코스 데이터 모델 |
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
  prefixIcon: Icons.person,
  keyboardType: TextInputType.name,
)
```

#### API

| 파라미터 | 타입 | 기본값 | 설명 |
|----------|------|--------|------|
| `controller` | `TextEditingController` | 필수 | 텍스트 컨트롤러 |
| `hintText` | `String` | 필수 | 힌트 텍스트 |
| `prefixIcon` | `IconData?` | `null` | 왼쪽 아이콘 |
| `keyboardType` | `TextInputType` | `TextInputType.text` | 키보드 타입 |
| `obscureText` | `bool` | `false` | 비밀번호 입력 모드 |

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
| `padding` | `EdgeInsets?` | `EdgeInsets.all(16)` | 내부 패딩 |
| `gradient` | `Gradient?` | `AppColorPalette.homeHeaderGradient` | 커스텀 그라데이션 |

---

### SectionHeader

섹션 제목과 더보기 버튼을 표시하는 헤더

```dart
SectionHeader(
  title: '추천 장소',
  onSeeMoreTap: () => _seeMorePlaces(),
)

// 더보기 버튼 없이
SectionHeader(
  title: '내 정보',
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
| `onSeeMoreTap` | `VoidCallback?` | `null` | 더보기 버튼 탭 시 콜백 |
| `seeMoreText` | `String?` | `'더보기'` | 더보기 버튼 텍스트 |
| `trailing` | `Widget?` | `null` | 커스텀 우측 위젯 (더보기 대신) |
| `showSeeMoreIcon` | `bool` | `true` | 더보기 아이콘 표시 여부 |

---

### GreetingSection

사용자 인사말 섹션 (홈 화면 상단)

```dart
GreetingSection(
  userName: user.nickname,
  greeting: '안녕하세요!',
)
```

#### API

| 파라미터 | 타입 | 기본값 | 설명 |
|----------|------|--------|------|
| `userName` | `String` | 필수 | 사용자 이름 |
| `greeting` | `String?` | `'안녕하세요!'` | 인사말 텍스트 |

---

### BottomNavigation

바텀 네비게이션 바

```dart
BottomNavigation(
  currentIndex: _currentIndex,
  onTap: (index) {
    setState(() {
      _currentIndex = index;
    });
    _navigateToTab(index);
  },
)
```

#### API

| 파라미터 | 타입 | 기본값 | 설명 |
|----------|------|--------|------|
| `currentIndex` | `int` | 필수 | 현재 선택된 탭 인덱스 (0~4) |
| `onTap` | `void Function(int)` | 필수 | 탭 선택 시 콜백 (인덱스 전달) |

**탭 인덱스**:
- `0`: 홈
- `1`: 코스마켓
- `2`: 지도
- `3`: 일정
- `4`: 마이페이지

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

### 4. 테스트 작성

```dart
// test/widgets/buttons/common_button_test.dart

void main() {
  testWidgets('PrimaryButton renders correctly', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: PrimaryButton(
            text: '확인',
            onPressed: () {},
          ),
        ),
      ),
    );

    expect(find.text('확인'), findsOneWidget);
    expect(find.byType(ElevatedButton), findsOneWidget);
  });

  testWidgets('PrimaryButton shows loading state', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: PrimaryButton(
            text: '저장',
            isLoading: true,
            onPressed: () {},
          ),
        ),
      ),
    );

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });
}
```

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
      onSeeMoreTap: () => _seeMore(),
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

**Last Updated**: 2025-11-10
**Version**: 1.0.0
**Maintained by**: [@EM-H20](https://github.com/EM-H20)
