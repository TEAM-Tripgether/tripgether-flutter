# 🎨 Tripgether 디자인 시스템

**최종 업데이트**: 2025-01-20
**문서 버전**: 1.0.0

일관된 사용자 경험을 위한 디자인 가이드입니다.

---

## 📋 목차

- [개요](#개요)
- [디자인 원칙](#디자인-원칙)
- [색상 시스템](#색상-시스템)
- [타이포그래피](#타이포그래피)
- [간격 시스템](#간격-시스템)
- [반응형 UI](#반응형-ui)
- [컴포넌트 스타일](#컴포넌트-스타일)
- [사용 예시](#사용-예시)
- [주의사항](#주의사항)

---

## 개요

Tripgether 디자인 시스템은 **Material Design 3** 기반으로 구축되었으며, `core/theme/` 디렉토리에 중앙 집중식으로 관리됩니다.

### 디자인 시스템 구조

```
core/theme/
├── app_colors.dart          # 색상 팔레트 (Primary, Status, Social 등)
├── app_text_styles.dart     # 텍스트 스타일 (Pretendard 폰트 기반)
├── app_spacing.dart         # 간격, Radius, Elevation, Sizes
└── app_theme.dart           # Material 3 통합 테마
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
텍스트 크기와 폰트 패밀리를 통해 정보의 우선순위를 명확히 합니다. fontWeight를 직접 설정하지 않고 AppTextStyles를 사용합니다.

### 3. **Breathing Space**
적절한 간격으로 UI 요소 간 시각적 여유를 제공합니다.

### 4. **Consistent Interaction**
모든 인터랙션 요소는 일관된 피드백과 상태 변화를 제공합니다.

---

## 색상 시스템

### Primary Colors

```dart
// Primary & Button
primary = Color(0xFF664BAE);          // 메인 브랜드 컬러
buttonDisabled = Color(0xFFB2A4D6);   // 비활성 버튼

// Text Colors
textPrimary = Color(0xFF333333);      // 주요 텍스트
textSecondary = Color(0xFF828693);    // 보조 텍스트
textTertiary = Color(0xFFBDBDBD);     // 힌트 텍스트
textDisabled = Color(0xFF9E9E9E);     // 비활성 텍스트

// Background
white = Colors.white;                  // 기본 배경
background = Color(0xFFF5F5F5);       // 서브 배경
```

### Status Colors

```dart
// 상태 표시
success = Color(0xFF66BB6A);      // 성공
error = Color(0xFFEF5350);        // 오류
warning = Color(0xFFFFA726);      // 경고
info = Color(0xFF29B6F6);         // 정보

// 상태 배경
successBackground = Color(0xFFE8F5E9);
errorBackground = Color(0xFFFFEBEE);
warningBackground = Color(0xFFFFF3E0);
infoBackground = Color(0xFFE1F5FE);
```

### Social Colors

```dart
// SNS 플랫폼 색상
AppColorPalette.googleButton = Color(0xFFF1F3F4);   // Google 버튼 배경
AppColorPalette.kakaoButton = Color(0xFFFEE500);    // Kakao 버튼 배경
AppColorPalette.naverButton = Color(0xFF03C75A);    // Naver 버튼 배경
```

### Gradient Colors

```dart
// 그라데이션 (대각선)
AppColorPalette.diagonalGradient = [
  Color(0xFF1B0062),  // 시작
  Color(0xFF5325CB),  // 중간
  Color(0xFFB599FF),  // 끝
];
```

### Shimmer Loading

```dart
// 로딩 효과
shimmerBase = Colors.grey[300]!;
shimmerHighlight = Colors.grey[100]!;
```

---

## 타이포그래피

### Pretendard 폰트 시스템

모든 텍스트는 Pretendard 폰트를 사용하며, **fontWeight를 직접 설정하지 않고** 각 스타일에 맞는 폰트 패밀리를 지정합니다.

```dart
fontFamily: 'Pretendard-Bold'      // Bold
fontFamily: 'Pretendard-SemiBold'  // SemiBold
fontFamily: 'Pretendard-Medium'    // Medium
fontFamily: 'Pretendard-Regular'   // Regular
```

### 텍스트 스타일

#### 제목 (Titles)

```dart
// 큰 제목
AppTextStyles.titleBold24       // Bold 24px - 온보딩, 중요 제목
AppTextStyles.titleSemiBold18   // SemiBold 18px - 다이얼로그 제목
AppTextStyles.titleSemiBold16   // SemiBold 16px - 섹션 제목
AppTextStyles.titleSemiBold14   // SemiBold 14px - 서브 제목

// 인사말
AppTextStyles.greetingBold20      // Bold 20px - 메인 인사
AppTextStyles.greetingSemiBold20  // SemiBold 20px - 서브 인사

// 요약
AppTextStyles.summaryBold18     // Bold 18px - 중요 요약
AppTextStyles.summaryBold16     // Bold 16px - 일반 요약
```

#### 본문 (Body)

```dart
AppTextStyles.bodyMedium16      // Medium 16px - 주요 본문
AppTextStyles.bodyRegular14     // Regular 14px - 일반 본문
AppTextStyles.caption12         // Regular 12px, alpha 0.6 - 캡션
```

#### 버튼 (Buttons)

```dart
AppTextStyles.buttonSelectSemiBold16  // SemiBold 16px - 선택 버튼
AppTextStyles.buttonLargeMedium16     // Medium 16px - 큰 버튼
AppTextStyles.buttonMediumMedium14    // Medium 14px - 중간 버튼
AppTextStyles.buttonSmallBold10       // Bold 10px - 작은 버튼
```

#### 메타 정보

```dart
AppTextStyles.metaMedium12      // Medium 12px - 메타데이터
```

#### 스플래시

```dart
AppTextStyles.splashLogoBold48       // Bold 48px - 로고
AppTextStyles.splashSloganRegular12  // Regular 12px - 슬로건
```

### 사용 규칙

```dart
// ✅ CORRECT - AppTextStyles 사용
Text(
  '제목',
  style: AppTextStyles.titleBold24,
)

// ❌ WRONG - fontWeight 직접 설정 금지
Text(
  '제목',
  style: TextStyle(
    fontSize: 24.sp,
    fontWeight: FontWeight.bold,  // 금지!
  ),
)
```

---

## 간격 시스템

### 기본 간격 (Spacing)

```dart
AppSpacing.xs = 4.w;    // 초소형
AppSpacing.sm = 8.w;    // 소형
AppSpacing.md = 12.w;   // 중형
AppSpacing.lg = 16.w;   // 대형
AppSpacing.xl = 20.w;   // 특대형
AppSpacing.xxl = 24.w;  // 초특대형
AppSpacing.xxxl = 32.w; // 최대형
AppSpacing.huge = 40.w; // 거대형
```

### 화면 패딩

```dart
AppSpacing.screenPadding = 18.w;       // 기본 화면 패딩
AppSpacing.screenPaddingLarge = 32.w;  // 큰 화면 패딩 (로그인 등)
```

### SizedBox 간격

```dart
// 수직 간격
AppSpacing.verticalSpaceXS    // 4
AppSpacing.verticalSpaceSM    // 8
AppSpacing.verticalSpaceMD    // 12
AppSpacing.verticalSpaceLG    // 16
AppSpacing.verticalSpaceXL    // 20
AppSpacing.verticalSpaceXXL   // 24
AppSpacing.verticalSpaceHuge  // 40

// 수평 간격
AppSpacing.horizontalSpaceXS  // 4
AppSpacing.horizontalSpaceSM  // 8
AppSpacing.horizontalSpaceMD  // 12
// ... 등
```

### BorderRadius

```dart
// 모든 모서리
AppRadius.allSmall   // 4.r
AppRadius.allMedium  // 8.r
AppRadius.allLarge   // 12.r
AppRadius.allXLarge  // 16.r
AppRadius.allCard    // 16.r (카드 전용)
AppRadius.allCircle  // 999.r (원형)

// 상단만
AppRadius.topSmall   // topLeft: 4.r, topRight: 4.r
AppRadius.topMedium  // topLeft: 8.r, topRight: 8.r
AppRadius.topLarge   // topLeft: 12.r, topRight: 12.r (바텀시트)
```

### Elevation

```dart
AppElevation.low = 1.0;      // 낮음
AppElevation.medium = 2.0;   // 중간 (카드)
AppElevation.high = 4.0;     // 높음
AppElevation.higher = 6.0;   // 더 높음 (다이얼로그)
AppElevation.extreme = 8.0;  // 최고
```

### 크기 (Sizes)

```dart
// 아이콘
AppSizes.iconXSmall = 12.w;
AppSizes.iconSmall = 16.w;
AppSizes.iconMedium = 20.w;
AppSizes.iconDefault = 24.w;
AppSizes.iconLarge = 32.w;
AppSizes.iconXLarge = 40.w;

// 버튼
AppSizes.buttonHeight = 54.h;
AppSizes.buttonHeightSmall = 40.h;
AppSizes.buttonHeightLarge = 60.h;

// 아바타
AppSizes.avatarSmall = 32.w;
AppSizes.avatarMedium = 48.w;
AppSizes.avatarLarge = 64.w;

// 기타
AppSizes.logoLarge = 240.w;
AppSizes.dividerThin = 0.5.h;
AppSizes.borderThin = 1.0.w;
```

---

## 반응형 UI

### ScreenUtil 사용법

```dart
// 너비 기반
Container(width: 100.w)   // 화면 너비 비율로 조정

// 높이 기반
Container(height: 50.h)   // 화면 높이 비율로 조정

// 폰트 크기
Text('텍스트', style: TextStyle(fontSize: 14.sp))  // 화면 크기에 맞게 조정

// Radius
Container(
  decoration: BoxDecoration(
    borderRadius: BorderRadius.circular(8.r),  // 반응형 radius
  ),
)
```

### 반응형 패딩

```dart
Container(
  padding: EdgeInsets.all(16.w),  // 화면 크기에 맞게 조정
  margin: EdgeInsets.symmetric(
    horizontal: 20.w,
    vertical: 10.h,
  ),
)
```

---

## 컴포넌트 스타일

### 버튼

```dart
// Primary Button (ElevatedButton)
ElevatedButton(
  style: ElevatedButton.styleFrom(
    backgroundColor: AppColors.primary,
    foregroundColor: AppColors.white,
    minimumSize: Size(double.infinity, AppSizes.buttonHeight),
    shape: RoundedRectangleBorder(
      borderRadius: AppRadius.allLarge,
    ),
    elevation: AppElevation.low,
  ),
)

// Secondary Button (OutlinedButton)
OutlinedButton(
  style: OutlinedButton.styleFrom(
    foregroundColor: AppColors.primary,
    minimumSize: Size(double.infinity, AppSizes.buttonHeight),
    side: BorderSide(color: AppColors.primary, width: AppSizes.borderThin),
    shape: RoundedRectangleBorder(
      borderRadius: AppRadius.allLarge,
    ),
  ),
)
```

### 카드

```dart
Container(
  padding: AppSpacing.cardPadding,
  decoration: BoxDecoration(
    color: AppColors.white,
    borderRadius: AppRadius.allCard,
    boxShadow: [
      BoxShadow(
        color: Colors.black.withValues(alpha: 0.1),
        blurRadius: AppElevation.medium,
        offset: Offset(0, 1),
      ),
    ],
  ),
)
```

### 텍스트 필드

```dart
TextField(
  decoration: InputDecoration(
    hintText: '힌트 텍스트',
    hintStyle: AppTextStyles.caption12,
    filled: true,
    fillColor: AppColors.inputBackground,
    border: OutlineInputBorder(
      borderRadius: AppRadius.allMedium,
      borderSide: BorderSide(color: AppColors.inputBorder),
    ),
    contentPadding: EdgeInsets.symmetric(
      horizontal: AppSpacing.lg,
      vertical: AppSpacing.md,
    ),
  ),
)
```

### 다이얼로그

```dart
AlertDialog(
  shape: RoundedRectangleBorder(
    borderRadius: AppRadius.allLarge,
  ),
  title: Text(
    '제목',
    style: AppTextStyles.titleSemiBold18,
  ),
  content: Text(
    '내용',
    style: AppTextStyles.bodyRegular14,
  ),
  actions: [
    TextButton(
      onPressed: () {},
      child: Text(
        '확인',
        style: AppTextStyles.buttonSelectSemiBold16,
      ),
    ),
  ],
)
```

---

## 사용 예시

### 일반적인 화면 구성

```dart
class MyScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CommonAppBar(
        title: '화면 제목',
        backgroundColor: AppColors.white,
      ),
      body: Padding(
        padding: EdgeInsets.all(AppSpacing.screenPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 제목
            Text(
              '섹션 제목',
              style: AppTextStyles.titleSemiBold16,
            ),

            AppSpacing.verticalSpaceMD,

            // 본문
            Text(
              '본문 내용입니다.',
              style: AppTextStyles.bodyRegular14,
            ),

            AppSpacing.verticalSpaceLG,

            // 버튼
            PrimaryButton(
              text: '다음',
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}
```

### 카드 컴포넌트

```dart
Container(
  margin: EdgeInsets.all(AppSpacing.md),
  padding: AppSpacing.cardPadding,
  decoration: BoxDecoration(
    color: AppColors.white,
    borderRadius: AppRadius.allCard,
    boxShadow: [
      BoxShadow(
        color: Colors.black.withValues(alpha: 0.1),
        blurRadius: AppElevation.medium,
        offset: Offset(0, 1),
      ),
    ],
  ),
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        '카드 제목',
        style: AppTextStyles.titleSemiBold14,
      ),
      AppSpacing.verticalSpaceSM,
      Text(
        '카드 내용',
        style: AppTextStyles.bodyRegular14,
      ),
    ],
  ),
)
```

---

## 주의사항

### ⚠️ 절대 하지 말아야 할 것들

```dart
// ❌ 하드코딩된 색상 사용 금지
Container(color: Color(0xFF664BAE))  // 금지!
Container(color: Colors.grey[300])   // 금지!

// ❌ 하드코딩된 크기 사용 금지
Container(width: 100, height: 50)    // 금지!
EdgeInsets.all(16)                   // 금지!

// ❌ fontWeight 직접 설정 금지
TextStyle(fontWeight: FontWeight.bold)  // 금지!

// ❌ 직접 BorderRadius 값 설정 금지
BorderRadius.circular(12)            // 금지!
```

### ✅ 올바른 사용법

```dart
// ✅ 디자인 시스템 사용
Container(color: AppColors.primary)
Container(width: 100.w, height: 50.h)
EdgeInsets.all(AppSpacing.lg)
Text('텍스트', style: AppTextStyles.titleBold24)
BorderRadius.all(AppRadius.allLarge)
```

### 디자인 시스템 수정

디자인 시스템 수정이 필요한 경우:
1. `core/theme/` 폴더의 해당 파일을 수정
2. 개별 화면에서 스타일을 오버라이드하지 않음
3. 새로운 스타일이 필요한 경우 디자인 시스템에 추가

---

## 문서 업데이트 이력

| 날짜 | 버전 | 변경 내용 |
|------|------|----------|
| 2025-01-20 | 1.0.0 | 최신 디자인 시스템 반영 및 fontWeight 규칙 추가 |
| 2025-11-10 | 0.9.0 | 초기 문서 작성 |

---

**Last Updated by**: Claude Code
**Maintained by**: TEAM-Tripgether