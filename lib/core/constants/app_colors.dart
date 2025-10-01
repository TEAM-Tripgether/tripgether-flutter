import 'package:flutter/material.dart';

/// TripTogether 앱의 색상 상수 정의
///
/// Material 3 디자인 시스템에 맞춰 앱 전체에서 사용할 색상들을 정의합니다.
/// 사용자 요구사항에 따른 브랜드 색상과 시스템 색상을 포함합니다.
class AppColors {
  // Private constructor to prevent instantiation
  AppColors._();

  /// Primary Colors (주요 브랜드 색상)
  /// 스플래시 배경, 로그인 버튼, 활성화된 버튼에 사용
  static const Color primary = Color(0xFF664BAE); // 664BAE - 메인 브랜드 컬러
  static const Color primaryLight = Color(0xFF8A6BC8); // Primary보다 밝은 톤
  static const Color primaryDark = Color(0xFF4A3689); // Primary보다 어두운 톤
  static const Color primaryContainer = Color(0xFFE8DDFF); // Primary 컨테이너 배경
  static const Color onPrimary = Color(0xFFFFFFFF); // Primary 위의 텍스트 색상
  static const Color onPrimaryContainer = Color(0xFF21005D); // Primary 컨테이너 위의 텍스트

  /// Secondary Colors (보조 색상)
  /// Primary를 보완하는 보조 색상
  static const Color secondary = Color(0xFF625B71); // 보조 브랜드 색상
  static const Color secondaryContainer = Color(0xFFE8DEF8); // Secondary 컨테이너
  static const Color onSecondary = Color(0xFFFFFFFF); // Secondary 위의 텍스트
  static const Color onSecondaryContainer = Color(0xFF1D192B); // Secondary 컨테이너 텍스트

  /// Surface Colors (표면 색상)
  /// 카드, 시트, 메뉴 등의 배경에 사용
  static const Color surface = Color(0xFFFFFBFE); // 기본 표면 색상
  static const Color surfaceVariant = Color(0xFFE7E0EC); // 변형 표면 색상
  static const Color surfaceTint = primary; // 표면 틴트 색상
  static const Color onSurface = Color(0xFF1C1B1F); // 표면 위의 텍스트
  static const Color onSurfaceVariant = Color(0xFF49454F); // 표면 변형 위의 텍스트

  /// Background Colors (배경 색상)
  /// 전체 화면의 배경에 사용
  static const Color background = Color(0xFFFFFBFE); // 기본 배경
  static const Color onBackground = Color(0xFF1C1B1F); // 배경 위의 텍스트

  /// Error Colors (에러 색상) - 사용자 지정
  /// 로그인 실패 등 오류 상태를 나타내는 색상
  static const Color error = Color(0xFFFF1B1B); // FF1B1B - 로그인 실패 타이포
  static const Color errorContainer = Color(0xFFFFD5D5); // FFD5D5 - 로그인 실패창 배경
  static const Color onError = Color(0xFFFFFFFF); // 에러 색상 위의 텍스트
  static const Color onErrorContainer = Color(0xFF8B0000); // 에러 컨테이너 위의 텍스트

  /// Outline Colors (테두리 색상) - 사용자 지정
  /// 입력창, 버튼 등의 테두리에 사용
  static const Color outline = Color(0xFFDBDBDB); // DBDBDB - 입력창 outline
  static const Color outlineVariant = Color(0xFFCAC4D0); // 변형 테두리

  /// Text Colors (텍스트 색상) - 사용자 지정
  /// 다양한 텍스트 상황에 사용되는 색상
  static const Color textPrimary = Color(0xFF333333); // 333333 - 유저입력 타이포
  static const Color textSecondary = Color(0xFF828693); // 828693 - 닫기 관련 색상
  static const Color textTertiary = Color(0xFF878787); // 878787 - 다시보내기 버튼
  static const Color textDisabled = Color(0xFF9E9E9E); // 비활성화된 텍스트

  /// Button State Colors (버튼 상태 색상) - 사용자 지정
  /// 버튼의 다양한 상태를 나타내는 색상
  static const Color buttonEnabled = primary; // 664BAE - 활성화된 버튼
  static const Color buttonDisabled = Color(0xFFB2A4D6); // B2A4D6 - 비활성화된 버튼
  static const Color buttonSecondary = Color(0xFF878787); // 878787 - 보조 버튼 (다시보내기)

  /// Status Colors (상태 색상)
  /// 성공, 정보, 경고 등의 상태를 나타내는 색상
  static const Color success = Color(0xFF4CAF50); // 성공 상태
  static const Color successContainer = Color(0xFFE8F5E8); // 성공 컨테이너
  static const Color warning = Color(0xFFFF9800); // 경고 상태
  static const Color warningContainer = Color(0xFFFFF3E0); // 경고 컨테이너
  static const Color info = Color(0xFF2196F3); // 정보 상태
  static const Color infoContainer = Color(0xFFE3F2FD); // 정보 컨테이너

  /// Neutral Colors (중성 색상)
  /// 회색 계열의 중성 색상들
  static const Color neutral10 = Color(0xFF1A1C1E);
  static const Color neutral20 = Color(0xFF2F3033);
  static const Color neutral30 = Color(0xFF46474A);
  static const Color neutral40 = Color(0xFF5E5E62);
  static const Color neutral50 = Color(0xFF77777A);
  static const Color neutral60 = Color(0xFF919094);
  static const Color neutral70 = Color(0xFFABABAF);
  static const Color neutral80 = Color(0xFFC6C6CA);
  static const Color neutral90 = Color(0xFFE2E2E6);
  static const Color neutral95 = Color(0xFFF1F1F5);
  static const Color neutral99 = Color(0xFFFFFBFE);

  /// Shadow and Elevation Colors (그림자 및 높이 색상)
  /// 카드와 요소들의 그림자 효과에 사용
  static const Color shadow = Color(0xFF000000);
  static const Color scrim = Color(0xFF000000);

  /// Splash Screen Colors (스플래시 스크린 색상)
  /// 앱 시작 시 표시되는 스플래시 화면 전용 색상
  static const Color splashBackground = primary; // 664BAE - 스플래시 배경색
  static const Color splashOnBackground = onPrimary; // 스플래시 배경 위의 요소들

  /// Input Field Colors (입력 필드 색상)
  /// 텍스트 입력 필드와 관련된 색상들
  static const Color inputFillColor = Color(0xFFF8F8F8); // 입력 필드 배경
  static const Color inputBorderColor = outline; // DBDBDB - 입력창 테두리
  static const Color inputFocusedBorderColor = primary; // 포커스된 입력 필드 테두리
  static const Color inputErrorBorderColor = error; // 에러 상태의 입력 필드 테두리
  static const Color inputTextColor = textPrimary; // 333333 - 입력 텍스트 색상
  static const Color inputHintColor = Color(0xFF9E9E9E); // 힌트 텍스트 색상

  /// Chip Colors (칩 색상)
  /// 선택 가능한 칩 요소들의 색상
  static const Color chipBackground = Color(0xFFE8DEF8);
  static const Color chipSelectedBackground = primary;
  static const Color chipText = Color(0xFF1D192B);
  static const Color chipSelectedText = onPrimary;

  /// Card Colors (카드 색상)
  /// 카드 컴포넌트의 색상
  static const Color cardBackground = surface;
  static const Color cardElevation = Color(0x1F000000);

  /// Navigation Colors (내비게이션 색상)
  /// 하단 네비게이션과 앱바 색상
  static const Color navigationBackground = surface;
  static const Color navigationSelected = primary;
  static const Color navigationUnselected = Color(0xFF49454F);

  /// Divider Colors (구분선 색상)
  /// 요소들을 구분하는 선의 색상
  static const Color divider = Color(0xFFE0E0E0);
  static const Color dividerLight = Color(0xFFF5F5F5);

  /// Gradient Colors (그라데이션 색상)
  /// 홈 화면 헤더 그라데이션용 중간 색상
  static const Color gradientMid = Color(0xB28975C1); // 8975C1B2 (70% opacity)

  /// Extension method for Color opacity
  /// 색상의 투명도를 쉽게 조절할 수 있는 확장 메서드
  static Color withOpacity(Color color, double opacity) {
    return color.withValues(alpha: opacity);
  }

  /// Widget State Colors
  /// 버튼과 같은 상호작용 요소의 상태별 색상을 제공하는 메서드들

  /// Primary 버튼의 WidgetStateProperty 색상
  static WidgetStateProperty<Color> primaryButtonColor() {
    return WidgetStateProperty.resolveWith<Color>((states) {
      if (states.contains(WidgetState.disabled)) {
        return buttonDisabled; // B2A4D6
      }
      if (states.contains(WidgetState.pressed)) {
        return primaryDark;
      }
      return buttonEnabled; // 664BAE
    });
  }

  /// Secondary 버튼의 WidgetStateProperty 색상
  static WidgetStateProperty<Color> secondaryButtonColor() {
    return WidgetStateProperty.resolveWith<Color>((states) {
      if (states.contains(WidgetState.disabled)) {
        return neutral80;
      }
      if (states.contains(WidgetState.pressed)) {
        return Color(0xFF6B6B6B);
      }
      return buttonSecondary; // 878787
    });
  }

  /// 텍스트 색상의 WidgetStateProperty
  static WidgetStateProperty<Color> textButtonColor() {
    return WidgetStateProperty.resolveWith<Color>((states) {
      if (states.contains(WidgetState.disabled)) {
        return textDisabled;
      }
      if (states.contains(WidgetState.pressed)) {
        return primaryDark;
      }
      return primary;
    });
  }
}

/// 색상 팔레트 확장
/// 특정 상황에서 사용할 수 있는 추가 색상들
extension AppColorPalette on AppColors {
  /// 그라데이션 색상 조합
  static const List<Color> primaryGradient = [
    AppColors.primary,
    AppColors.primaryLight,
  ];

  static const List<Color> backgroundGradient = [
    AppColors.background,
    AppColors.surfaceVariant,
  ];

  /// 홈 헤더 그라데이션 (위에서 아래로: #664BAE → #8975C1B2 70% → #FFFFFF)
  static const List<Color> homeHeaderGradient = [
    AppColors.primary,        // #664BAE (0%)
    AppColors.gradientMid,    // #8975C1B2 (70%)
    Color(0xFFFFFFFF),        // #FFFFFF (100%)
  ];

  /// 소셜 로그인 버튼 색상
  static const Color googleButton = Color(0xFFDB4437);
  static const Color facebookButton = Color(0xFF4267B2);
  static const Color appleButton = Color(0xFF000000);
  static const Color kakaoButton = Color(0xFFFFE812);
  static const Color naverButton = Color(0xFF03C75A);

  /// 평점 및 리뷰 색상
  static const Color ratingStarFilled = Color(0xFFFFB300);
  static const Color ratingStarEmpty = Color(0xFFE0E0E0);

  /// 온라인/오프라인 상태 색상
  static const Color onlineStatus = AppColors.success;
  static const Color offlineStatus = Color(0xFF757575);
}