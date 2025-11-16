import 'package:flutter/material.dart';
import '../../../../l10n/app_localizations.dart';

/// 외부 앱에서 공유된 데이터 파싱 유틸리티
///
/// Instagram 등 소셜 미디어에서 공유된 데이터 형식:
/// `{texts: [@username님의 이 Instagram 게시물 보기, URL]}`
///
/// 이 유틸리티는 최대한 간단하게 작성자와 URL만 추출합니다.
/// 플랫폼 분석 등 복잡한 로직은 백엔드에서 처리합니다.
class SharedDataParser {
  SharedDataParser._(); // Private constructor to prevent instantiation

  /// 공유된 텍스트 배열에서 작성자명 추출
  ///
  /// 예시: "@sejong_student님의 이 Instagram 게시물 보기" → "sejong_student"
  ///
  /// [texts]: 공유 데이터의 텍스트 배열
  /// [context]: BuildContext for localization (optional)
  /// 반환: 작성자명 (추출 실패시 국제화된 기본값)
  static String extractAuthor(List<String> texts, [BuildContext? context]) {
    final defaultAuthor = context != null
        ? AppLocalizations.of(context).defaultAuthor
        : '사용자';

    if (texts.isEmpty) return defaultAuthor;

    final firstText = texts.first;

    // "@username님" 패턴 매칭
    final regex = RegExp(r'@(\w+)님');
    final match = regex.firstMatch(firstText);

    if (match != null && match.groupCount >= 1) {
      return match.group(1) ?? defaultAuthor;
    }

    return defaultAuthor;
  }

  /// 공유된 텍스트 배열에서 URL 추출
  ///
  /// 일반적으로 URL은 배열의 두 번째 요소에 위치합니다.
  ///
  /// [texts]: 공유 데이터의 텍스트 배열
  /// 반환: URL (추출 실패시 빈 문자열)
  static String extractUrl(List<String> texts) {
    if (texts.length < 2) return '';

    final secondText = texts[1];

    // URL 형식 검증 (간단한 체크)
    if (Uri.tryParse(secondText)?.hasScheme ?? false) {
      return secondText;
    }

    return '';
  }

  /// 공유 데이터에서 작성자와 URL을 함께 추출
  ///
  /// [texts]: 공유 데이터의 텍스트 배열
  /// 반환: {author: String, url: String} Map
  static Map<String, String> parse(List<String> texts) {
    return {'author': extractAuthor(texts), 'url': extractUrl(texts)};
  }
}
