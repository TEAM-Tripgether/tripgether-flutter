import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'locale_provider.g.dart';

/// 언어 설정 상태 관리 Provider
///
/// 사용자가 선택한 언어를 SharedPreferences에 저장하고
/// 앱 전체에서 언어 설정을 관리합니다.
@riverpod
class LocaleNotifier extends _$LocaleNotifier {
  static const String _localeKey = 'app_locale';

  @override
  Locale? build() {
    // 초기 상태: SharedPreferences에서 저장된 언어 설정 불러오기
    _loadLocale();
    return null; // 초기값은 null (시스템 언어 사용)
  }

  /// SharedPreferences에서 저장된 언어 설정 불러오기
  Future<void> _loadLocale() async {
    final prefs = await SharedPreferences.getInstance();
    final localeCode = prefs.getString(_localeKey);

    if (localeCode != null) {
      // 저장된 언어 코드를 Locale 객체로 변환
      state = Locale(localeCode);
    }
  }

  /// 언어 변경 및 저장
  ///
  /// [locale] 변경할 언어 (null이면 시스템 언어 사용)
  Future<void> setLocale(Locale? locale) async {
    final prefs = await SharedPreferences.getInstance();

    if (locale == null) {
      // 시스템 언어로 변경
      await prefs.remove(_localeKey);
      state = null;
    } else {
      // 특정 언어로 변경
      await prefs.setString(_localeKey, locale.languageCode);
      state = locale;
    }
  }

  /// 한국어로 변경
  Future<void> setKorean() async {
    await setLocale(const Locale('ko'));
  }

  /// 영어로 변경
  Future<void> setEnglish() async {
    await setLocale(const Locale('en'));
  }

  /// 시스템 언어로 변경
  Future<void> setSystemLanguage() async {
    await setLocale(null);
  }
}
