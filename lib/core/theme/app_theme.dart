import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'app_colors.dart';
import '../animations/page_transitions.dart';
import 'app_spacing.dart';
import 'app_text_styles.dart';

/// Tripgether 앱의 테마 설정
///
/// Material 3 디자인 시스템을 기반으로 한 라이트/다크 테마를 제공합니다.
/// Pretendard 폰트 패밀리를 사용하여 일관된 타이포그래피를 적용합니다.
///
/// 테마 구성 요소:
/// - app_colors.dart: 모든 색상 정의
/// - app_spacing.dart: 간격, Border Radius, Elevation, Sizes
/// - app_text_styles.dart: 텍스트 스타일
class AppTheme {
  AppTheme._();

  /// 라이트 테마 설정
  static ThemeData get lightTheme {
    // TextTheme을 미리 가져와서 재사용
    final textTheme = AppTextStyles.buildTextTheme();

    return ThemeData(
      useMaterial3: true,
      fontFamily: AppTextStyles.fontFamily,

      /// 색상 스키마 (Material 3 기반)
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        brightness: Brightness.light,
        // 사용자 정의 색상 오버라이드
        primary: AppColors.primary,
        onPrimary: AppColors.onPrimary,
        primaryContainer: AppColors.primaryContainer,
        onPrimaryContainer: AppColors.onPrimaryContainer,
        secondary: AppColors.secondary,
        onSecondary: AppColors.onSecondary,
        secondaryContainer: AppColors.secondaryContainer,
        onSecondaryContainer: AppColors.onSecondaryContainer,
        surface: AppColors.surface,
        onSurface: AppColors.onSurface,
        surfaceContainerHighest: AppColors
            .surfaceVariant, // surfaceVariant는 deprecated, surfaceContainerHighest 사용
        onSurfaceVariant: AppColors.onSurfaceVariant,
        // background는 deprecated, surface 사용
        // onBackground는 deprecated, onSurface 사용
        error: AppColors.error,
        onError: AppColors.onError,
        errorContainer: AppColors.errorContainer,
        onErrorContainer: AppColors.onErrorContainer,
        outline: AppColors.outline,
        outlineVariant: AppColors.outlineVariant,
        shadow: AppColors.shadow,
        scrim: AppColors.scrim,
        surfaceTint: AppColors.surfaceTint,
      ),

      /// 앱바 테마
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.surface,
        foregroundColor: AppColors.onSurface,
        elevation: AppElevation.none,
        scrolledUnderElevation: AppElevation.low,
        surfaceTintColor: AppColors.surfaceTint,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        // titleLarge (22px, w600)를 사용하되 색상만 오버라이드
        titleTextStyle: textTheme.titleLarge?.copyWith(
          color: AppColors.onSurface,
        ),
        iconTheme: IconThemeData(
          color: AppColors.onSurface,
          size: AppSizes.iconDefault,
        ),
      ),

      /// 버튼 테마들
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.gradientMiddle, // #5325CB - 로그인 버튼 색상
          foregroundColor: AppColors.onPrimary,
          disabledBackgroundColor: AppColors.buttonDisabled,
          disabledForegroundColor: AppColors.onPrimary.withValues(alpha: 0.38),
          elevation: AppElevation.medium,
          shadowColor: AppColors.shadow.withValues(alpha: 0.15),
          shape: RoundedRectangleBorder(borderRadius: AppRadius.allLarge),
          minimumSize: Size(AppSizes.buttonMinWidth, AppSizes.buttonHeight),
          // labelLarge (14px, w600)를 기반으로 살짝 조정
          textStyle: textTheme.labelLarge?.copyWith(
            fontWeight: FontWeight.w700,
            letterSpacing: 0.1,
          ),
        ),
      ),

      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.onPrimary,
          disabledBackgroundColor: AppColors.buttonDisabled,
          disabledForegroundColor: AppColors.onPrimary.withValues(alpha: 0.38),
          shape: RoundedRectangleBorder(borderRadius: AppRadius.allLarge),
          minimumSize: Size(AppSizes.buttonMinWidth, AppSizes.buttonHeight),
          textStyle: textTheme.labelLarge?.copyWith(
            fontWeight: FontWeight.w700,
            letterSpacing: 0.1,
          ),
        ),
      ),

      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor:
              AppColors.outline, // #BBBBBB - 밝은 회색 (어두운 배경에서 가독성 확보)
          disabledForegroundColor: AppColors.textDisabled,
          shape: RoundedRectangleBorder(borderRadius: AppRadius.allMedium),
          minimumSize: Size(
            AppSizes.textButtonMinWidth,
            AppSizes.textButtonHeight,
          ),
          // labelLarge 그대로 사용
          textStyle: textTheme.labelLarge,
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primary,
          disabledForegroundColor: AppColors.textDisabled,
          side: BorderSide(
            color: AppColors.outline,
            width: AppSizes.borderThin,
          ),
          shape: RoundedRectangleBorder(borderRadius: AppRadius.allLarge),
          minimumSize: Size(AppSizes.buttonMinWidth, AppSizes.buttonHeight),
          // titleMedium (16px, w600)를 기반으로 조정
          textStyle: textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w500,
            letterSpacing: 0.1,
          ),
        ),
      ),

      /// 입력 필드 테마
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.inputFillColor,
        border: OutlineInputBorder(
          borderRadius: AppRadius.allLarge,
          borderSide: BorderSide(
            color: AppColors.inputBorderColor,
            width: AppSizes.borderThin,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: AppRadius.allLarge,
          borderSide: BorderSide(
            color: AppColors.inputBorderColor,
            width: AppSizes.borderThin,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: AppRadius.allLarge,
          borderSide: BorderSide(
            color: AppColors.inputFocusedBorderColor,
            width: AppSizes.borderMedium,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: AppRadius.allLarge,
          borderSide: BorderSide(
            color: AppColors.inputErrorBorderColor,
            width: AppSizes.borderThin,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: AppRadius.allLarge,
          borderSide: BorderSide(
            color: AppColors.inputErrorBorderColor,
            width: AppSizes.borderMedium,
          ),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: AppRadius.allLarge,
          borderSide: BorderSide(
            color: AppColors.outline.withValues(alpha: 0.38),
            width: AppSizes.borderThin,
          ),
        ),
        contentPadding: EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.lg,
        ),
        // bodyLarge (16px, w400) 사용
        hintStyle: textTheme.bodyLarge?.copyWith(
          color: AppColors.inputHintColor,
        ),
        // titleMedium (16px, w600)를 w500로 조정
        labelStyle: textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.w500,
          color: AppColors.textSecondary,
        ),
        // bodySmall (12px, w400)를 error로 색상만 변경
        errorStyle: textTheme.bodySmall?.copyWith(color: AppColors.error),
      ),

      /// 카드 테마
      cardTheme: CardThemeData(
        color: AppColors.cardBackground,
        elevation: AppElevation.medium,
        shadowColor: AppColors.cardElevation,
        surfaceTintColor: AppColors.surfaceTint,
        shape: RoundedRectangleBorder(borderRadius: AppRadius.allLarge),
        margin: EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.sm,
        ),
      ),

      /// 리스트 타일 테마
      listTileTheme: ListTileThemeData(
        contentPadding: EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.sm,
        ),
        // titleMedium (16px, w600)를 w500로 조정
        titleTextStyle: textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.w500,
          color: AppColors.textPrimary,
        ),
        // bodyMedium (14px, w400) 사용
        subtitleTextStyle: textTheme.bodyMedium?.copyWith(
          color: AppColors.textSecondary,
        ),
      ),

      /// 칩 테마
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.chipBackground,
        selectedColor: AppColors.chipSelectedBackground,
        disabledColor: AppColors.neutral90,
        // labelLarge (14px, w600)를 w500로 조정
        labelStyle: textTheme.labelLarge?.copyWith(
          fontWeight: FontWeight.w500,
          color: AppColors.chipText,
        ),
        secondaryLabelStyle: textTheme.labelLarge?.copyWith(
          fontWeight: FontWeight.w500,
          color: AppColors.chipSelectedText,
        ),
        shape: RoundedRectangleBorder(borderRadius: AppRadius.allMedium),
        side: BorderSide(color: AppColors.outline, width: AppSizes.borderThin),
        padding: EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
      ),

      /// 하단 네비게이션 바 테마
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: AppColors.navigationBackground,
        selectedItemColor: AppColors.navigationSelected,
        unselectedItemColor: AppColors.navigationUnselected,
        // labelMedium (12px, w600) 사용
        selectedLabelStyle: textTheme.labelMedium,
        unselectedLabelStyle: textTheme.labelMedium?.copyWith(
          fontWeight: FontWeight.w500,
        ),
        type: BottomNavigationBarType.fixed,
        elevation: AppElevation.navigation,
      ),

      /// 네비게이션 바 테마 (NavigationBar - Material 3)
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: AppColors.navigationBackground,
        indicatorColor: AppColors.primaryContainer,
        surfaceTintColor: AppColors.surfaceTint,
        elevation: AppElevation.high,
        height: AppSizes.navigationBarHeight,
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            // labelMedium (12px, w600) 사용
            return textTheme.labelMedium?.copyWith(
              color: AppColors.navigationSelected,
            );
          }
          return textTheme.labelMedium?.copyWith(
            fontWeight: FontWeight.w500,
            color: AppColors.navigationUnselected,
          );
        }),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return IconThemeData(
              color: AppColors.navigationSelected,
              size: AppSizes.iconDefault,
            );
          }
          return IconThemeData(
            color: AppColors.navigationUnselected,
            size: AppSizes.iconDefault,
          );
        }),
      ),

      /// 구분선 테마
      dividerTheme: DividerThemeData(
        color: AppColors.divider,
        thickness: AppSizes.borderThin,
        space: AppSizes.borderThin,
      ),

      /// 스낵바 테마
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.neutral20,
        // labelLarge (14px, w600)를 w500로 조정
        contentTextStyle: textTheme.labelLarge?.copyWith(
          fontWeight: FontWeight.w500,
          color: AppColors.neutral99,
        ),
        shape: RoundedRectangleBorder(borderRadius: AppRadius.allMedium),
        behavior: SnackBarBehavior.floating,
        // margin 속성은 Flutter 3.35.3에서 제거됨
        // SnackBar 사용 시 ScaffoldMessenger.of(context).showSnackBar()에서 직접 margin 설정
      ),

      /// 다이얼로그 테마
      dialogTheme: DialogThemeData(
        backgroundColor: AppColors.surface,
        surfaceTintColor: AppColors.surfaceTint,
        elevation: AppElevation.higher,
        shape: RoundedRectangleBorder(borderRadius: AppRadius.allXLarge),
        // titleLarge (22px, w600)를 titleMedium으로 약간 작게 조정
        titleTextStyle: textTheme.titleMedium?.copyWith(
          color: AppColors.onSurface,
        ),
        // bodyMedium (14px, w400) 사용
        contentTextStyle: textTheme.bodyMedium?.copyWith(
          color: AppColors.onSurfaceVariant,
          height: 1.4,
        ),
      ),

      /// 플로팅 액션 버튼 테마
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.onPrimary,
        elevation: AppElevation.higher,
        shape: const CircleBorder(),
      ),

      /// 체크박스 테마
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.primary;
          }
          return AppColors.surface;
        }),
        checkColor: WidgetStateProperty.all(AppColors.onPrimary),
        overlayColor: WidgetStateProperty.all(
          AppColors.primary.withValues(alpha: 0.1),
        ),
        shape: RoundedRectangleBorder(borderRadius: AppRadius.allSmall),
      ),

      /// 라디오 버튼 테마
      radioTheme: RadioThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.primary;
          }
          return AppColors.outline;
        }),
        overlayColor: WidgetStateProperty.all(
          AppColors.primary.withValues(alpha: 0.1),
        ),
      ),

      /// 스위치 테마
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.onPrimary;
          }
          return AppColors.outline;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.primary;
          }
          return AppColors.surfaceVariant;
        }),
        overlayColor: WidgetStateProperty.all(
          AppColors.primary.withValues(alpha: 0.1),
        ),
      ),

      /// 슬라이더 테마
      sliderTheme: SliderThemeData(
        activeTrackColor: AppColors.primary,
        inactiveTrackColor: AppColors.surfaceVariant,
        thumbColor: AppColors.primary,
        overlayColor: AppColors.primary.withValues(alpha: 0.1),
        valueIndicatorColor: AppColors.primary,
        // labelMedium (12px, w600)를 w500로 조정
        valueIndicatorTextStyle: textTheme.labelMedium?.copyWith(
          fontWeight: FontWeight.w500,
          color: AppColors.onPrimary,
        ),
      ),

      /// 프로그레스 인디케이터 테마
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: AppColors.primary,
        linearTrackColor: AppColors.surfaceVariant,
        circularTrackColor: AppColors.surfaceVariant,
      ),

      /// 탭바 테마
      tabBarTheme: TabBarThemeData(
        labelColor: AppColors.primary,
        unselectedLabelColor: AppColors.textSecondary,
        indicatorColor: AppColors.primary,
        indicatorSize: TabBarIndicatorSize.label,
        // labelLarge (14px, w600) 사용
        labelStyle: textTheme.labelLarge,
        unselectedLabelStyle: textTheme.labelLarge?.copyWith(
          fontWeight: FontWeight.w500,
        ),
        overlayColor: const WidgetStatePropertyAll(Colors.transparent),
      ),

      /// 뱃지 테마
      badgeTheme: BadgeThemeData(
        backgroundColor: AppColors.error,
        textColor: AppColors.onError,
        // labelMedium (12px, w600) 사용
        textStyle: textTheme.labelMedium,
      ),

      /// 툴팁 테마
      tooltipTheme: TooltipThemeData(
        decoration: BoxDecoration(
          color: AppColors.neutral20,
          borderRadius: AppRadius.allMedium,
        ),
        // labelMedium (12px, w600)를 w500로 조정
        textStyle: textTheme.labelMedium?.copyWith(
          fontWeight: FontWeight.w500,
          color: AppColors.neutral99,
        ),
        padding: EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
      ),

      /// 텍스트 테마 (전체 타이포그래피)
      textTheme: textTheme,

      /// 페이지 전환 애니메이션 설정
      pageTransitionsTheme: AppPageTransitions.noAnimation,
    );
  }

  /// 다크 테마 설정 (향후 확장용)
  static ThemeData get darkTheme {
    // 현재는 라이트 테마와 동일하게 설정
    // 향후 다크모드 요구사항이 생기면 별도 구현
    return lightTheme.copyWith(
      brightness: Brightness.dark,
      // 다크 테마 전용 색상 스키마 적용 예정
    );
  }
}
