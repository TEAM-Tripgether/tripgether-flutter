# Tripgether 디자인 시스템

> 🎨 **일관된 사용자 경험을 위한 디자인 가이드**

## 📋 목차

- [개요](#개요)
- [디자인 원칙](#디자인-원칙)
- [색상 시스템](#색상-시스템)
- [타이포그래피](#타이포그래피)
- [간격 시스템](#간격-시스템)
- [반응형 UI](#반응형-ui)
- [컴포넌트 스타일](#컴포넌트-스타일)
- [사용 예시](#사용-예시)

---

## 개요

Tripgether 디자인 시스템은 **Material Design 3** 기반으로 구축되었으며, `core/theme/` 디렉토리에 중앙 집중식으로 관리됩니다.

### 디자인 시스템 구조

```
core/theme/
├── app_colors.dart          # 색상 팔레트 (Primary, Status, Social 등)
├── app_text_styles.dart     # 텍스트 스타일 (Headline, Title, Body, Label)
├── app_spacing.dart         # 간격, Radius, Elevation, Sizes
└── app_theme.dart           # Material 3 통합 테마 (자동 적용)
```

### 핵심 원칙

- ✅ **일관성 (Consistency)**: 모든 UI는 디자인 시스템을 통해 일관된 스타일 유지
- ✅ **재사용성 (Reusability)**: 중앙 집중식 관리로 스타일 변경 시 전체 앱 동시 업데이트
- ✅ **접근성 (Accessibility)**: WCAG 2.1 기준에 맞춘 색상 대비와 텍스트 크기
- ✅ **반응형 (Responsive)**: ScreenUtil을 통한 다양한 화면 크기 지원

---

## 디자인 원칙

### 1. **Color First**
색상은 브랜드 정체성의 핵심입니다. Primary 색상(`#664BAE`)을 중심으로 모든 UI 요소가 조화를 이룹니다.

### 2. **Clear Hierarchy**
텍스트 크기와 굵기를 통해 정보의 우선순위를 명확히 합니다.

### 3. **Breathing Space**
적절한 간격으로 UI 요소 간 시각적 여유를 제공합니다.

### 4. **Consistent Radius**
모든 UI 요소는 정해진 Border Radius 값(`4r`, `8r`, `12r`, `16r`)만 사용합니다.

---

## 색상 시스템

### Primary Colors (브랜드 색상)

| 색상 | Hex Code | 용도 |
|------|----------|------|
| **Primary** | `#664BAE` | 메인 브랜드 컬러 (버튼, 강조, 선택 상태) |
| **Primary Light** | `#8A6BC8` | Primary보다 밝은 톤 (Hover, Pressed) |
| **Primary Dark** | `#4A3689` | Primary보다 어두운 톤 (Active, Shadow) |
| **Button Disabled** | `#B2A4D6` | 비활성화된 버튼 배경 |

#### 사용 예시

```dart
import 'package:tripgether/core/theme/app_colors.dart';

// Primary 색상 사용
Container(
  color: AppColors.primary,
  child: Text(
    '메인 버튼',
    style: TextStyle(color: AppColors.onPrimary), // 흰색 텍스트
  ),
)

// 버튼 상태별 색상
ElevatedButton(
  style: ElevatedButton.styleFrom(
    backgroundColor: AppColors.primary,        // 활성화
    disabledBackgroundColor: AppColors.buttonDisabled, // 비활성화
  ),
)
```

### Text Colors (텍스트 색상)

| 색상 | Hex Code | 용도 |
|------|----------|------|
| **Text Primary** | `#333333` | 주요 텍스트 (입력, 제목) |
| **Text Secondary** | `#828693` | 부가 텍스트 (설명, 메타 정보) |
| **Text Tertiary** | `#878787` | 보조 버튼 텍스트 (다시보내기) |
| **Text Disabled** | `#9E9E9E` | 비활성화된 텍스트 |

#### 사용 예시

```dart
// 주요 텍스트
Text(
  '사용자가 입력한 내용',
  style: AppTextStyles.bodyLarge.copyWith(color: AppColors.textPrimary),
)

// 부가 설명
Text(
  '선택 사항입니다',
  style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary),
)
```

### Status Colors (상태 색상)

| 색상 | Hex Code | 용도 |
|------|----------|------|
| **Success** | `#4CAF50` | 성공 메시지, 완료 상태 |
| **Error** | `#FF1B1B` | 오류 메시지, 실패 상태 |
| **Warning** | `#FF9800` | 경고 메시지, 주의 필요 |
| **Info** | `#2196F3` | 정보 메시지, 안내 |

#### 사용 예시

```dart
// 성공 메시지
Container(
  color: AppColors.successContainer,
  child: Text(
    '저장되었습니다',
    style: TextStyle(color: AppColors.success),
  ),
)

// 에러 메시지
Container(
  color: AppColors.errorContainer,
  child: Text(
    '로그인에 실패했습니다',
    style: TextStyle(color: AppColors.error),
  ),
)
```

### Gradient Colors (그라데이션)

#### 1. **대각선 그라데이션** (로그인 화면)

```dart
Container(
  decoration: BoxDecoration(
    gradient: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: AppColorPalette.diagonalGradient,
      // [#1B0062 → #5325CB → #B599FF]
    ),
  ),
)
```

#### 2. **홈 헤더 그라데이션** (홈 화면 상단)

```dart
Container(
  decoration: BoxDecoration(
    gradient: LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: AppColorPalette.homeHeaderGradient,
      // [#664BAE → #8975C1B2 70% → #FFFFFF]
    ),
  ),
)
```

### Social Login Colors (소셜 로그인 버튼)

| 플랫폼 | Hex Code | 텍스트 색상 |
|--------|----------|-------------|
| **Google** | `#F1F1F1` | `#000000` (검정) |
| **Kakao** | `#FEE500` | `#000000` (검정) |
| **Naver** | `#03C75A` | `#FFFFFF` (흰색) |
| **Apple** | `#000000` | `#FFFFFF` (흰색) |

#### 사용 예시

```dart
SocialLoginButton(
  text: "Google로 시작하기",
  backgroundColor: AppColorPalette.googleButton,
  textColor: Colors.black,
  icon: SvgPicture.asset('assets/icons/google.svg'),
  onPressed: () => _loginWithGoogle(),
)
```

---

## 타이포그래피

### Pretendard 폰트 패밀리

Tripgether는 **Pretendard** 폰트를 사용합니다. Pretendard는 한글과 영문 모두에서 가독성이 뛰어난 폰트입니다.

### 텍스트 스타일 계층

#### Headline (제목용)

| 스타일 | 크기 | 굵기 | 용도 |
|--------|------|------|------|
| **headlineLarge** | 32px | 600 | 페이지 제목, 주요 헤딩 |
| **headlineMedium** | 28px | 500 | 카드 제목, 서브 헤딩 |
| **headlineSmall** | 24px | 700 | 다이얼로그 제목, 리스트 헤더 |

```dart
Text(
  '여행 계획',
  style: AppTextStyles.headlineLarge,
)
```

#### Title (섹션 제목용)

| 스타일 | 크기 | 굵기 | 용도 |
|--------|------|------|------|
| **titleLarge** | 20px | 600 | 앱바 제목, 섹션 타이틀 |
| **titleMedium** | 16px | 600 | 카드 제목, 리스트 아이템 타이틀 |
| **titleSmall** | 14px | 600 | 작은 카드 제목, 탭 라벨 |

```dart
Text(
  '추천 코스',
  style: AppTextStyles.titleLarge,
)
```

#### Body (본문용)

| 스타일 | 크기 | 굵기 | 용도 |
|--------|------|------|------|
| **bodyLarge** | 16px | 400 | 본문 텍스트, 설명 텍스트 |
| **bodyMedium** | 14px | 400 | 기본 본문, 리스트 아이템 설명 |
| **bodySmall** | 12px | 400 | 캡션, 작은 설명 텍스트 |

```dart
Text(
  '서울의 숨겨진 명소를 탐험해보세요',
  style: AppTextStyles.bodyLarge,
)
```

#### Label (라벨 및 버튼용)

| 스타일 | 크기 | 굵기 | 용도 |
|--------|------|------|------|
| **labelLarge** | 14px | 600 | 버튼 텍스트, 폼 라벨 |
| **labelMedium** | 12px | 600 | 칩, 뱃지, 작은 버튼 |
| **labelSmall** | 11px | 600 | 오버라인, 작은 라벨 |

```dart
Text(
  '확인',
  style: AppTextStyles.labelLarge,
)
```

### 커스텀 텍스트 스타일

#### buttonText (버튼 텍스트)

```dart
Text(
  '저장',
  style: AppTextStyles.buttonText, // 16px, w700
)
```

#### caption (캡션/힌트)

```dart
Text(
  '선택 사항입니다',
  style: AppTextStyles.caption, // 12px, w400, 보조색
)
```

---

## 간격 시스템

### 기본 간격 단위

| 이름 | 값 | 용도 |
|------|-----|------|
| `xs` | 4 | 최소 간격 (아이콘-텍스트 간격) |
| `sm` | 8 | 아주 작은 간격 (밀접한 요소 간격) |
| `md` | 12 | 작은 간격 (카드 내부 요소 간격) |
| `lg` | 16 | 중간 간격 (기본 패딩) |
| `xl` | 20 | 큰 간격 (섹션 간격) |
| `xxl` | 24 | 아주 큰 간격 (다이얼로그 패딩) |
| `xxxl` | 32 | 매우 큰 간격 (화면 가로 패딩) |
| `huge` | 40 | 초대형 간격 (상하단 여백) |

#### 사용 예시

```dart
// 패딩
Container(
  padding: AppSpacing.cardPadding, // EdgeInsets.all(16)
)

// 간격
Column(
  children: [
    Text('제목'),
    AppSpacing.verticalSpaceLG, // SizedBox(height: 16)
    Text('본문'),
  ],
)
```

### Border Radius (모서리 둥글기)

| 이름 | 값 | 용도 |
|------|-----|------|
| `small` | 4r | 체크박스, 라디오 버튼 |
| `medium` | 8r | 칩, 스낵바, 툴팁 |
| `large` | 12r | 버튼, 입력 필드, 카드 |
| `xlarge` | 16r | 다이얼로그, 바텀시트 |
| `circle` | 999r | 아바타, FAB |

#### 사용 예시

```dart
Container(
  decoration: BoxDecoration(
    color: AppColors.primary,
    borderRadius: AppRadius.allLarge, // BorderRadius.circular(12.r)
  ),
)

// 상단만 둥글게 (바텀시트)
Container(
  decoration: BoxDecoration(
    borderRadius: AppRadius.topLarge, // 상단만 12.r
  ),
)
```

### Elevation (그림자 높이)

| 이름 | 값 | 용도 |
|------|-----|------|
| `none` | 0 | AppBar 기본 상태 |
| `low` | 1 | AppBar 스크롤 시, 칩 |
| `medium` | 2 | 카드, ElevatedButton |
| `high` | 3 | Navigation Bar |
| `higher` | 6 | Dialog, FAB |
| `navigation` | 8 | Bottom Navigation Bar, Drawer |

#### 사용 예시

```dart
Card(
  elevation: AppElevation.medium, // 2
)

AppBar(
  elevation: AppElevation.none, // 0
  scrolledUnderElevation: AppElevation.low, // 1
)
```

### Component Sizes (컴포넌트 크기)

#### Icon Sizes

| 이름 | 값 | 용도 |
|------|-----|------|
| `iconSmall` | 16 | 작은 아이콘 (칩 내부) |
| `iconMedium` | 20 | 중간 아이콘 (버튼 내부) |
| `iconDefault` | 24 | 일반 아이콘 (AppBar, ListTile) |
| `iconLarge` | 32 | 큰 아이콘 (카드 헤더) |
| `iconXLarge` | 48 | 매우 큰 아이콘 (EmptyState) |

#### Component Heights

| 이름 | 값 | 용도 |
|------|-----|------|
| `buttonHeight` | 54 | 버튼 기본 높이 |
| `textButtonHeight` | 40 | 텍스트 버튼 높이 |
| `appBarHeight` | 56 | AppBar 높이 |
| `navigationBarHeight` | 90 | 바텀 네비게이션 높이 |

#### 사용 예시

```dart
SizedBox(
  width: double.infinity,
  height: AppSizes.buttonHeight, // 54
  child: ElevatedButton(...),
)

Icon(Icons.favorite, size: AppSizes.iconDefault) // 24
```

---

## 반응형 UI

### ScreenUtil 사용

Tripgether는 **flutter_screenutil** 패키지를 사용하여 다양한 화면 크기에 대응합니다.

#### 기본 사용법

```dart
import 'package:flutter_screenutil/flutter_screenutil.dart';

Container(
  width: 300.w,    // 너비 (화면 너비 기준 비율 적용)
  height: 120.h,   // 높이 (화면 높이 기준 비율 적용)
  padding: EdgeInsets.all(16.w),
  child: Text(
    '텍스트',
    style: TextStyle(fontSize: 18.sp), // 폰트 크기
  ),
);
```

#### 반지름 (Radius)

```dart
Container(
  decoration: BoxDecoration(
    borderRadius: BorderRadius.circular(12.r), // 화면 크기에 비례
  ),
)
```

### ScreenUtil 설정 (`main.dart`)

```dart
void main() {
  runApp(
    ScreenUtilInit(
      designSize: const Size(375, 812), // 디자인 기준 해상도 (iPhone 11 Pro)
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) => MyApp(),
    ),
  );
}
```

---

## 컴포넌트 스타일

### Button Styles

#### Primary Button (ElevatedButton)

```dart
PrimaryButton(
  text: '저장',
  onPressed: () => _save(),
  isFullWidth: true,
  height: AppSizes.buttonHeight,
)
```

**자동 적용되는 스타일**:
- 배경색: `AppColors.primary` (#664BAE)
- 텍스트: `AppTextStyles.buttonText` (16px, w700)
- 높이: `AppSizes.buttonHeight` (54)
- Radius: `AppRadius.large` (12r)

#### Secondary Button (OutlinedButton)

```dart
SecondaryButton(
  text: '취소',
  onPressed: () => _cancel(),
)
```

**자동 적용되는 스타일**:
- 테두리: `AppColors.primary` (#664BAE)
- 텍스트: `AppColors.primary`
- 배경: 투명
- Radius: `AppRadius.large` (12r)

#### Tertiary Button (TextButton)

```dart
TertiaryButton(
  text: '건너뛰기',
  onPressed: () => _skip(),
)
```

**자동 적용되는 스타일**:
- 텍스트: `AppColors.primary`
- 배경: 투명
- 최소 높이: `AppSizes.textButtonHeight` (40)

### Card Styles

#### 기본 카드

```dart
Card(
  elevation: AppElevation.medium,
  shape: RoundedRectangleBorder(
    borderRadius: AppRadius.allLarge,
  ),
  child: Padding(
    padding: AppSpacing.cardPadding,
    child: Column(...),
  ),
)
```

**자동 적용되는 스타일** (from `app_theme.dart`):
- Elevation: `2`
- Radius: `12r`
- 배경색: `AppColors.surface` (#FFFBFE)

### Input Field Styles

#### 기본 TextField

```dart
TextField(
  decoration: InputDecoration(
    hintText: '이름을 입력하세요',
    filled: true,
    fillColor: AppColors.inputFillColor,
    border: OutlineInputBorder(
      borderRadius: AppRadius.allLarge,
      borderSide: BorderSide(color: AppColors.inputBorderColor),
    ),
  ),
  style: Theme.of(context).textTheme.bodyLarge,
)
```

**자동 적용되는 스타일** (from `app_theme.dart`):
- 배경색: `#F8F8F8`
- 테두리: `#BBBBBB`
- 포커스 테두리: `#664BAE`
- Radius: `12r`

---

## 사용 예시

### 완전한 화면 예시

```dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tripgether/core/theme/app_colors.dart';
import 'package:tripgether/core/theme/app_text_styles.dart';
import 'package:tripgether/core/theme/app_spacing.dart';
import 'package:tripgether/shared/widgets/buttons/common_button.dart';

class ExamplePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // AppBar
      appBar: AppBar(
        title: Text(
          '디자인 시스템 예시',
          style: AppTextStyles.titleLarge,
        ),
        elevation: AppElevation.none,
      ),

      // Body
      body: SingleChildScrollView(
        padding: AppSpacing.screenPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 제목
            Text(
              '환영합니다!',
              style: AppTextStyles.headlineLarge,
            ),

            AppSpacing.verticalSpaceLG,

            // 카드
            Card(
              elevation: AppElevation.medium,
              shape: RoundedRectangleBorder(
                borderRadius: AppRadius.allLarge,
              ),
              child: Padding(
                padding: AppSpacing.cardPadding,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 카드 제목
                    Text(
                      '추천 코스',
                      style: AppTextStyles.titleMedium,
                    ),

                    AppSpacing.verticalSpaceSM,

                    // 카드 본문
                    Text(
                      '서울의 숨겨진 명소를 탐험해보세요',
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            AppSpacing.verticalSpaceXXL,

            // 버튼
            PrimaryButton(
              text: '시작하기',
              icon: Icons.arrow_forward,
              onPressed: () => _handleStart(),
            ),

            AppSpacing.verticalSpaceSM,

            SecondaryButton(
              text: '나중에 하기',
              onPressed: () => _handleSkip(),
            ),
          ],
        ),
      ),
    );
  }
}
```

---

## 모범 사례

### ✅ 올바른 예시

```dart
// 1. 테마 시스템 사용
Container(
  padding: AppSpacing.cardPadding,
  decoration: BoxDecoration(
    color: AppColors.primary,
    borderRadius: AppRadius.allLarge,
  ),
  child: Text(
    '제목',
    style: AppTextStyles.titleLarge,
  ),
)

// 2. 반응형 크기 사용
Container(
  width: 300.w,
  height: 120.h,
  padding: EdgeInsets.all(16.w),
)

// 3. 색상 상태별 분리
Container(
  color: _isActive ? AppColors.primary : AppColors.buttonDisabled,
)
```

### ❌ 잘못된 예시

```dart
// 1. 하드코딩된 스타일
Container(
  padding: EdgeInsets.all(16),  // ❌ AppSpacing 사용 필수
  decoration: BoxDecoration(
    color: Color(0xFF664BAE),    // ❌ AppColors.primary 사용
    borderRadius: BorderRadius.circular(12), // ❌ AppRadius 사용
  ),
  child: Text(
    '제목',
    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600), // ❌ AppTextStyles 사용
  ),
)

// 2. 고정 픽셀 크기
Container(
  width: 300,   // ❌ 300.w 사용 필수
  height: 120,  // ❌ 120.h 사용 필수
)

// 3. 커스텀 색상 직접 사용
Colors.grey[300]  // ❌ AppColors.neutral95 사용
Colors.red        // ❌ AppColors.error 사용
```

---

## Shimmer 로딩 UI

### 사용 예시

```dart
import 'package:shimmer/shimmer.dart';
import 'package:tripgether/core/theme/app_colors.dart';

Shimmer.fromColors(
  baseColor: AppColors.shimmerBase,       // #E2E2E6 (grey[300] 대체)
  highlightColor: AppColors.shimmerHighlight, // #FFFBFE (grey[100] 대체)
  child: Container(
    width: 200.w,
    height: 16.h,
    color: Colors.white,
  ),
)
```

---

## 다크 모드 지원 (향후 계획)

현재는 라이트 모드만 지원하지만, 다크 모드 추가 시 `app_theme.dart`에서 다크 테마를 정의할 예정입니다.

```dart
// 향후 다크 모드 추가 예정
ThemeData buildDarkTheme() {
  return ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: ColorScheme.dark(
      primary: AppColors.primary,
      // ... 다크 모드 색상 정의
    ),
  );
}
```

---

## 참고 자료

- [Material Design 3 Color System](https://m3.material.io/styles/color/overview)
- [Material Design 3 Typography](https://m3.material.io/styles/typography/overview)
- [flutter_screenutil 패키지](https://pub.dev/packages/flutter_screenutil)
- [Pretendard 폰트](https://github.com/orioncactus/pretendard)

---

**Last Updated**: 2025-11-10
**Version**: 1.0.0
**Maintained by**: [@EM-H20](https://github.com/EM-H20)
