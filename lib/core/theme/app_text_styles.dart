import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

/// Tripgether 앱의 텍스트 스타일 정의
///
/// Material 3 기반 타이포그래피 시스템을 제공하며,
/// Pretendard 폰트 패밀리를 사용합니다.
class AppTextStyles {
  AppTextStyles._(); // Private constructor to prevent instantiation

  /// Pretendard 폰트 패밀리 이름
  static const String fontFamily = 'Pretendard';

  /// Material 3 기반 TextTheme 생성
  ///
  /// Material Design 3의 타이포그래피 가이드라인을 따릅니다.
  /// - Display: 큰 제목용 (57, 45, 36)
  /// - Headline: 제목용 (32, 28, 24)
  /// - Title: 섹션 제목용 (22, 16, 14)
  /// - Label: 라벨 및 캡션용 (14, 12, 11)
  /// - Body: 본문용 (16, 14, 12)
  static TextTheme buildTextTheme() {
    return const TextTheme(
      // ==================== Display Styles (큰 제목용) ====================

      /// displayLarge: 57px, 가벼운 굵기 (300)
      /// 사용처: 히어로 섹션, 랜딩 페이지 주제목
      displayLarge: TextStyle(
        fontFamily: fontFamily,
        fontSize: 57,
        fontWeight: FontWeight.w300,
        height: 1.12,
        letterSpacing: -0.25,
        color: AppColors.onSurface,
      ),

      /// displayMedium: 45px, 가벼운 굵기 (300)
      /// 사용처: 주요 섹션 타이틀
      displayMedium: TextStyle(
        fontFamily: fontFamily,
        fontSize: 45,
        fontWeight: FontWeight.w300,
        height: 1.16,
        color: AppColors.onSurface,
      ),

      /// displaySmall: 36px, 가벼운 굵기 (300)
      /// 사용처: 부제목, 섹션 헤더
      displaySmall: TextStyle(
        fontFamily: fontFamily,
        fontSize: 36,
        fontWeight: FontWeight.w300,
        height: 1.22,
        color: AppColors.onSurface,
      ),

      // ==================== Headline Styles (제목용) ====================

      /// headlineLarge: 32px, 세미볼드 (600)
      /// 사용처: 페이지 제목, 주요 헤딩
      headlineLarge: TextStyle(
        fontFamily: fontFamily,
        fontSize: 32,
        fontWeight: FontWeight.w600,
        height: 1.25,
        color: AppColors.onSurface,
      ),

      /// headlineMedium: 28px, 미디엄 (500)
      /// 사용처: 카드 제목, 서브 헤딩
      headlineMedium: TextStyle(
        fontFamily: fontFamily,
        fontSize: 28,
        fontWeight: FontWeight.w500,
        height: 1.29,
        color: AppColors.onSurface,
      ),

      /// headlineSmall: 24px, 볼드 (700)
      /// 사용처: 다이얼로그 제목, 리스트 헤더
      headlineSmall: TextStyle(
        fontFamily: fontFamily,
        fontSize: 24,
        fontWeight: FontWeight.w700,
        height: 1.33,
        color: AppColors.onSurface,
      ),

      // ==================== Title Styles (섹션 제목용) ====================

      /// titleLarge: 22px, 세미볼드 (600)
      /// 사용처: 앱바 제목, 섹션 타이틀
      titleLarge: TextStyle(
        fontFamily: fontFamily,
        fontSize: 20,
        fontWeight: FontWeight.w600,
        height: 1.27,
        color: AppColors.onSurface,
      ),

      /// titleMedium: 16px, 세미볼드 (600)
      /// 사용처: 카드 제목, 리스트 아이템 타이틀
      titleMedium: TextStyle(
        fontFamily: fontFamily,
        fontSize: 16,
        fontWeight: FontWeight.w600,
        height: 1.50,
        letterSpacing: 0.15,
        color: AppColors.onSurface,
      ),

      /// titleSmall: 14px, 세미볼드 (600)
      /// 사용처: 작은 카드 제목, 탭 라벨
      titleSmall: TextStyle(
        fontFamily: fontFamily,
        fontSize: 14,
        fontWeight: FontWeight.w600,
        height: 1.43,
        letterSpacing: 0.1,
        color: AppColors.onSurface,
      ),

      // ==================== Label Styles (라벨 및 캡션용) ====================

      /// labelLarge: 14px, 세미볼드 (600)
      /// 사용처: 버튼 텍스트, 폼 라벨
      labelLarge: TextStyle(
        fontFamily: fontFamily,
        fontSize: 14,
        fontWeight: FontWeight.w600,
        height: 1.43,
        letterSpacing: 0.1,
        color: AppColors.onSurface,
      ),

      /// labelMedium: 12px, 세미볼드 (600)
      /// 사용처: 칩, 뱃지, 작은 버튼
      labelMedium: TextStyle(
        fontFamily: fontFamily,
        fontSize: 12,
        fontWeight: FontWeight.w600,
        height: 1.33,
        letterSpacing: 0.5,
        color: AppColors.onSurface,
      ),

      /// labelSmall: 11px, 세미볼드 (600)
      /// 사용처: 오버라인, 작은 라벨
      labelSmall: TextStyle(
        fontFamily: fontFamily,
        fontSize: 11,
        fontWeight: FontWeight.w600,
        height: 1.45,
        letterSpacing: 0.5,
        color: AppColors.onSurface,
      ),

      // ==================== Body Styles (본문용) ====================

      /// bodyLarge: 16px, 레귤러 (400)
      /// 사용처: 본문 텍스트, 설명 텍스트
      bodyLarge: TextStyle(
        fontFamily: fontFamily,
        fontSize: 16,
        fontWeight: FontWeight.w400,
        height: 1.50,
        letterSpacing: 0.15,
        color: AppColors.onSurface,
      ),

      /// bodyMedium: 14px, 레귤러 (400)
      /// 사용처: 기본 본문, 리스트 아이템 설명
      bodyMedium: TextStyle(
        fontFamily: fontFamily,
        fontSize: 14,
        fontWeight: FontWeight.w400,
        height: 1.43,
        letterSpacing: 0.25,
        color: AppColors.onSurface,
      ),

      /// bodySmall: 12px, 레귤러 (400)
      /// 사용처: 캡션, 작은 설명 텍스트
      bodySmall: TextStyle(
        fontFamily: fontFamily,
        fontSize: 12,
        fontWeight: FontWeight.w400,
        height: 1.33,
        letterSpacing: 0.4,
        color: AppColors.onSurfaceVariant,
      ),
    );
  }
}

// ==================== 커스텀 텍스트 스타일 확장 ====================

/// 커스텀 텍스트 스타일 확장
///
/// Material 3 TextTheme에 포함되지 않는 특별한 용도의 텍스트 스타일들을
/// extension으로 제공합니다.
extension CustomTextStyles on TextTheme {
  /// 버튼 텍스트 스타일 (16px, 볼드)
  /// 사용처: 모든 버튼의 기본 텍스트
  TextStyle get buttonText => const TextStyle(
    fontFamily: AppTextStyles.fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w700,
    letterSpacing: 0.1,
  );

  /// 입력 필드 텍스트 스타일 (16px, 레귤러)
  /// 사용처: TextField, TextFormField의 입력 텍스트
  TextStyle get inputText => const TextStyle(
    fontFamily: AppTextStyles.fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: AppColors.inputTextColor,
  );

  /// 에러 메시지 스타일 (12px, 세미볼드, 빨강)
  /// 사용처: 폼 유효성 검사 에러, 토스트 에러 메시지
  TextStyle get errorText => const TextStyle(
    fontFamily: AppTextStyles.fontFamily,
    fontSize: 12,
    fontWeight: FontWeight.w600,
    color: AppColors.error,
  );

  /// 성공 메시지 스타일 (12px, 세미볼드, 초록)
  /// 사용처: 성공 토스트, 완료 메시지
  TextStyle get successText => const TextStyle(
    fontFamily: AppTextStyles.fontFamily,
    fontSize: 12,
    fontWeight: FontWeight.w600,
    color: AppColors.success,
  );

  /// 캡션 스타일 (12px, 레귤러, 보조 색상)
  /// 사용처: 작은 설명 텍스트, 힌트 메시지
  TextStyle get caption => const TextStyle(
    fontFamily: AppTextStyles.fontFamily,
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
    height: 1.33,
  );

  /// 오버라인 스타일 (10px, 세미볼드, 상단 라벨)
  /// 사용처: 카드 상단 카테고리, 섹션 라벨
  TextStyle get overline => const TextStyle(
    fontFamily: AppTextStyles.fontFamily,
    fontSize: 10,
    fontWeight: FontWeight.w600,
    color: AppColors.textSecondary,
    letterSpacing: 1.5,
    height: 1.6,
  );

  /// 초경량 스타일 (14px, 얇은 굵기, 섬세한 캡션용)
  /// 사용처: 배경 워터마크, 섬세한 설명
  TextStyle get ultraLight => const TextStyle(
    fontFamily: AppTextStyles.fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w200,
    color: AppColors.textSecondary,
    height: 1.4,
  );

  /// 볼드 스타일 (16px, 볼드, 강조 텍스트용)
  /// 사용처: 중요한 정보 강조, 하이라이트
  TextStyle get bold => const TextStyle(
    fontFamily: AppTextStyles.fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
    height: 1.5,
  );

  /// 블랙 스타일 (20px, 최대 굵기, 브랜딩 텍스트용)
  /// 사용처: 로고 텍스트, 주요 브랜딩 요소
  TextStyle get black => const TextStyle(
    fontFamily: AppTextStyles.fontFamily,
    fontSize: 20,
    fontWeight: FontWeight.w900,
    color: AppColors.textPrimary,
    height: 1.2,
  );
}
