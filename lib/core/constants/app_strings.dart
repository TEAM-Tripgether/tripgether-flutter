import 'package:flutter/material.dart';
import '../../l10n/app_localizations.dart';

/// 앱 전반에서 사용하는 국제화된 문자열을 쉽게 접근할 수 있는 유틸리티 클래스
///
/// 기존의 하드코딩된 문자열 상수를 국제화된 다국어 지원 시스템으로 대체합니다.
/// ARB 파일을 통해 한국어와 영어를 지원하며, 필요시 추가 언어를 쉽게 추가할 수 있습니다.
///
/// 사용법:
/// - Text(AppStrings.of(context).appTitle)
/// - AppStrings.of(context).navHome
/// - if (AppStrings.isKorean(context)) { ... }
class AppStrings {
  AppStrings._();

  // ================================
  // 국제화 문자열 접근 메서드
  // ================================

  /// BuildContext에서 AppLocalizations 인스턴스를 가져옵니다
  ///
  /// [context] BuildContext 인스턴스 (필수)
  /// Returns: AppLocalizations 인스턴스
  static AppLocalizations of(BuildContext context) {
    return AppLocalizations.of(context);
  }

  // ================================
  // 언어 감지 유틸리티
  // ================================

  /// 현재 설정된 언어가 한국어인지 확인합니다
  ///
  /// [context] BuildContext 인스턴스
  /// Returns: 한국어인 경우 true, 그렇지 않으면 false
  static bool isKorean(BuildContext context) {
    return Localizations.localeOf(context).languageCode == 'ko';
  }

  /// 현재 설정된 언어가 영어인지 확인합니다
  ///
  /// [context] BuildContext 인스턴스
  /// Returns: 영어인 경우 true, 그렇지 않으면 false
  static bool isEnglish(BuildContext context) {
    return Localizations.localeOf(context).languageCode == 'en';
  }

  /// 현재 설정된 언어 코드를 반환합니다
  ///
  /// [context] BuildContext 인스턴스
  /// Returns: 언어 코드 (예: 'ko', 'en')
  static String getCurrentLanguageCode(BuildContext context) {
    return Localizations.localeOf(context).languageCode;
  }

  // ================================
  // 포맷팅 유틸리티
  // ================================

  /// 현재 언어에 따른 날짜 포맷을 반환합니다
  ///
  /// [context] BuildContext 인스턴스
  /// Returns: 언어별 날짜 포맷 문자열
  static String getDateFormat(BuildContext context) {
    return of(context).dateFormat;
  }

  /// 현재 언어에 따른 시간 포맷을 반환합니다
  ///
  /// [context] BuildContext 인스턴스
  /// Returns: 언어별 시간 포맷 문자열
  static String getTimeFormat(BuildContext context) {
    return of(context).timeFormat;
  }

  // ================================
  // 사용 예제 및 마이그레이션 가이드
  // ================================

  /*
  기존 하드코딩된 문자열을 국제화된 버전으로 마이그레이션하는 방법:

  🔴 기존 (Hard-coded)
  Text('TripTogether')
  Text('홈')
  AppBar(title: Text('지도 화면'))

  ✅ 새로운 방식 (Internationalized)
  Text(AppStrings.of(context).appTitle)
  Text(AppStrings.of(context).navHome)
  AppBar(title: Text(AppStrings.of(context).navMap))

  🌍 언어별 조건부 처리
  if (AppStrings.isKorean(context)) {
    // 한국어 전용 로직
  } else if (AppStrings.isEnglish(context)) {
    // 영어 전용 로직
  }

  📅 날짜/시간 포맷팅
  String datePattern = AppStrings.getDateFormat(context);
  String timePattern = AppStrings.getTimeFormat(context);
  */

  // ================================
  // 레거시 상수들 (제거 예정)
  // ================================

  // 아래 상수들은 국제화 마이그레이션 후 제거될 예정입니다.
  // 새로운 코드에서는 AppStrings.of(context)를 사용하세요.

  @Deprecated('Use AppStrings.of(context).appTitle instead')
  static const String appName = 'TripTogether';

  @Deprecated('Use AppStrings.of(context).appTitle instead')
  static const String appTitle = 'TripTogether';
}
