import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../animations/page_transitions.dart';

/// Tripgether 앱의 테마 설정
///
/// ⚠️ 중요: 이 파일은 Material 기본값만 설정합니다.
/// 모든 색상, 간격, 스타일은 각 위젯에서 AppColors, AppSpacing 등을 직접 사용하세요.
///
/// **디자인 원칙**:
/// - 디자이너 스펙이 소스 코드의 유일한 진실 (Single Source of Truth)
/// - Theme의 간접적인 추상화 대신 명시적인 색상/스타일 사용
/// - 코드 가독성과 유지보수성 향상
class AppTheme {
  AppTheme._();

  /// 라이트 테마 설정
  ///
  /// Material 3 기본 설정만 포함.
  /// 위젯별 스타일은 각 위젯에서 직접 AppColors, AppSpacing 등을 사용하세요.
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      fontFamily: 'Pretendard-Regular',

      /// 시스템 UI 오버레이 (상태바 스타일)
      appBarTheme: const AppBarTheme(
        systemOverlayStyle: SystemUiOverlayStyle.dark,
      ),

      /// 페이지 전환 애니메이션
      pageTransitionsTheme: AppPageTransitions.noAnimation,
    );
  }

  /// 다크 테마 (향후 확장용)
  static ThemeData get darkTheme => lightTheme;
}
