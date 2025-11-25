import 'package:flutter/material.dart';

/// Tripgether 앱의 색상 상수 정의
///
/// 디자이너가 정의한 색상 시스템을 기반으로 합니다.
class AppColors {
  AppColors._();

  // ============================================================================
  // 기본 색상
  // ============================================================================

  /// Main Color (#5325CB)
  static const Color mainColor = Color(0xFF5325CB);

  /// Sub Color 2 (#BBBBBB)
  static const Color subColor2 = Color(0xFFBBBBBB);

  /// Text Color 1 (#130537)
  static const Color textColor1 = Color(0xFF130537);

  /// White
  static const Color white = Color(0xFFFFFFFF);

  /// Background Light (#F8F8F8) - 섹션 구분용 연한 회색
  static const Color backgroundLight = Color(0xFFF8F8F8);

  /// Red Accent (#F94C4F) - 강조 색상
  static const Color redAccent = Color(0xFFF94C4F);

  /// Gray Purple (#A5A3AA) - 회색 보라
  static const Color grayPurple = Color(0xFFA5A3AA);

  // ============================================================================
  // 그라데이션 팔레트
  // ============================================================================

  static const Color gradient1 = Color(0xFF1B0062);
  static const Color gradient2 = Color(0xFF5325CB);
  static const Color gradient3 = Color(0xFFB599FF);
  static const Color gradient4 = Color(0xFFBFB8D1);
  static const Color gradient5 = Color(0xFFBBBBBB);
  static const Color gradient6 = Color(0xFFFFFFFF);

  /// 이미지 플레이스홀더 배경색 (#C4C4C4)
  static const Color imagePlaceholder = Color(0xFFC4C4C4);

  // ============================================================================
  // 버튼 (계속하기 등)
  // ============================================================================

  /// 활성: 배경 mainColor, 텍스트 white
  static const Color buttonActive = mainColor;
  static const Color buttonTextActive = white;

  /// 비활성: 텍스트 white
  static const Color buttonTextInactive = white;

  // ============================================================================
  // 선택 버튼 (성별, 관심사 카테고리)
  // ============================================================================

  /// 선택됨: 테두리/텍스트 mainColor
  static const Color selectedBorder = mainColor;
  static const Color selectedText = mainColor;

  // ============================================================================
  // 세부 칩 (관심사 내부 항목)
  // ============================================================================

  /// 선택됨: 배경 mainColor, 텍스트 white
  static const Color chipSelectedBg = mainColor;
  static const Color chipSelectedText = white;

  /// 선택 안 됨: 배경 white
  static const Color chipUnselectedBg = white;

  // ============================================================================
  // 시스템 색상
  // ============================================================================

  static const Color error = redAccent;
  static const Color errorContainer = white;
  static const Color background = white;
  static const Color surface = white;
  static const Color shadow = Color(0xFF000000);

  // ============================================================================
  // 호환성 색상 (Backward Compatibility)
  // ============================================================================

  static Color get shimmerHighlight => white;
  static const Color success = Color(0xFF4CAF50);
  static const Color warning = Color(0xFFFF9800); // 주황색 - 경고/임시휴업

  // ============================================================================
  // Widget State Property
  // ============================================================================

  static WidgetStateProperty<Color> continueButtonColor() {
    return WidgetStateProperty.resolveWith<Color>((states) {
      if (states.contains(WidgetState.disabled)) {
        return mainColor.withValues(alpha: 0.2);
      }
      return buttonActive;
    });
  }

  static WidgetStateProperty<Color> continueButtonTextColor() {
    return WidgetStateProperty.all(buttonTextActive);
  }
}

/// 색상 팔레트 확장
extension AppColorPalette on AppColors {
  /// 대각선 그라데이션 (로그인 화면 등)
  static const List<Color> diagonalGradient = [
    AppColors.gradient1, // #1B0062
    AppColors.gradient2, // #5325CB
    AppColors.gradient3, // #B599FF
  ];

  /// 홈 헤더 그라데이션
  static const List<Color> homeHeaderGradient = [
    AppColors.mainColor,
    AppColors.white,
  ];

  /// 소셜 로그인 버튼 색상 (각 플랫폼의 공식 브랜드 색상)
  static const Color googleButton = Color(0xFFF1F1F1); // 구글 라이트 그레이
  static const Color facebookButton = Color(0xFF4267B2); // 페이스북 블루
  static const Color appleButton = Color(0xFF000000); // 애플 블랙
  static const Color kakaoButton = Color(0xFFFEE500); // 카카오 옐로우
  static const Color naverButton = Color(0xFF03C75A); // 네이버 그린
}
