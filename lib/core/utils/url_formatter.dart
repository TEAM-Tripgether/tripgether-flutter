/// URL 정리 및 포맷팅 유틸리티
///
/// 공유된 URL에서 불필요한 추적 파라미터를 제거하여
/// 깔끔한 URL을 제공합니다.
class UrlFormatter {
  /// 제거할 추적 파라미터 목록
  ///
  /// **UTM 파라미터** (Google Analytics 추적):
  /// - utm_source: 트래픽 소스
  /// - utm_medium: 마케팅 매체
  /// - utm_campaign: 캠페인 이름
  /// - utm_term: 검색 키워드
  /// - utm_content: 광고 콘텐츠
  ///
  /// **광고 플랫폼 추적**:
  /// - fbclid: Facebook 클릭 ID
  /// - gclid: Google 광고 클릭 ID
  /// - msclkid: Microsoft 광고 클릭 ID
  ///
  /// **소셜 미디어 추적**:
  /// - igshid: Instagram 공유 ID
  /// - share_id: 일반 공유 추적 ID
  /// - ig_web_button_native_share: Instagram 웹 버튼 공유
  static const List<String> _trackingParams = [
    // UTM 파라미터
    'utm_source',
    'utm_medium',
    'utm_campaign',
    'utm_term',
    'utm_content',
    'utm_id',
    'utm_source_platform',

    // 광고 플랫폼
    'fbclid', // Facebook
    'gclid', // Google Ads
    'msclkid', // Microsoft Ads
    'dclid', // DoubleClick
    // 소셜 미디어
    'igshid', // Instagram
    'share_id', // 일반 공유
    'ig_web_button_native_share', // Instagram 웹
    // 기타 추적
    'ref', // Referral
    'source', // Source tracking
    '_hsenc', // HubSpot
    '_hsmi', // HubSpot
    'mc_cid', // MailChimp
    'mc_eid', // MailChimp
  ];

  /// URL에서 추적 파라미터를 제거합니다
  ///
  /// **동작 방식**:
  /// 1. URL을 파싱하여 scheme, host, path, query 분리
  /// 2. Query 파라미터 중 추적용만 필터링하여 제거
  /// 3. 중요한 파라미터는 유지 (YouTube v=, 네이버 query= 등)
  /// 4. 깔끔한 URL로 재조립
  ///
  /// **예시**:
  /// ```dart
  /// // Instagram
  /// cleanUrl('https://instagram.com/p/ABC/?utm_source=share')
  /// // → 'https://instagram.com/p/ABC/'
  ///
  /// // YouTube (v= 파라미터 유지)
  /// cleanUrl('https://youtube.com/watch?v=abc&utm_source=share')
  /// // → 'https://youtube.com/watch?v=abc'
  ///
  /// // 네이버 검색 (query= 파라미터 유지)
  /// cleanUrl('https://search.naver.com/search?query=flutter&utm_source=share')
  /// // → 'https://search.naver.com/search?query=flutter'
  /// ```
  ///
  /// [url] 정리할 원본 URL
  /// Returns: 추적 파라미터가 제거된 깔끔한 URL
  static String cleanUrl(String url) {
    try {
      final uri = Uri.parse(url);

      // Query 파라미터가 없으면 그대로 반환
      if (uri.queryParameters.isEmpty) {
        return url;
      }

      // 추적 파라미터를 제외한 나머지 파라미터만 필터링
      final cleanedParams = <String, String>{};
      uri.queryParameters.forEach((key, value) {
        // 추적 파라미터 목록에 없으면 유지
        if (!_trackingParams.contains(key.toLowerCase())) {
          cleanedParams[key] = value;
        }
      });

      // 깔끔한 URI 재조립
      final cleanedUri = Uri(
        scheme: uri.scheme,
        host: uri.host,
        port: uri.hasPort ? uri.port : null,
        path: uri.path,
        queryParameters: cleanedParams.isNotEmpty ? cleanedParams : null,
        fragment: uri.fragment.isNotEmpty ? uri.fragment : null,
      );

      return cleanedUri.toString();
    } catch (e) {
      // 파싱 실패 시 원본 URL 반환
      return url;
    }
  }

  /// URL이 유효한지 검증합니다
  ///
  /// **검증 조건**:
  /// - http 또는 https scheme 필수
  /// - host가 존재해야 함
  /// - 올바른 URI 형식
  ///
  /// [url] 검증할 URL 문자열
  /// Returns: 유효하면 true, 아니면 false
  static bool isValidUrl(String url) {
    try {
      final uri = Uri.parse(url);
      return uri.hasScheme &&
          (uri.scheme == 'http' || uri.scheme == 'https') &&
          uri.host.isNotEmpty;
    } catch (e) {
      return false;
    }
  }

  /// URL을 도메인별로 분류합니다
  ///
  /// **지원 플랫폼**:
  /// - instagram.com → UrlType.instagram
  /// - youtube.com, youtu.be → UrlType.youtube
  /// - twitter.com, x.com → UrlType.twitter
  /// - 기타 → UrlType.other
  ///
  /// [url] 분류할 URL
  /// Returns: URL 타입
  static UrlType getUrlType(String url) {
    try {
      final uri = Uri.parse(url);
      final host = uri.host.toLowerCase();

      if (host.contains('instagram.com')) {
        return UrlType.instagram;
      } else if (host.contains('youtube.com') || host.contains('youtu.be')) {
        return UrlType.youtube;
      } else if (host.contains('twitter.com') || host.contains('x.com')) {
        return UrlType.twitter;
      } else if (host.contains('facebook.com') || host.contains('fb.com')) {
        return UrlType.facebook;
      } else if (host.contains('tiktok.com')) {
        return UrlType.tiktok;
      }

      return UrlType.other;
    } catch (e) {
      return UrlType.other;
    }
  }

  /// URL에서 도메인만 추출합니다
  ///
  /// **예시**:
  /// ```dart
  /// extractDomain('https://www.instagram.com/p/ABC/')
  /// // → 'instagram.com'
  /// ```
  ///
  /// [url] 도메인을 추출할 URL
  /// Returns: 도메인 문자열 (추출 실패 시 빈 문자열)
  static String extractDomain(String url) {
    try {
      final uri = Uri.parse(url);
      // www. 제거
      return uri.host.replaceFirst('www.', '');
    } catch (e) {
      return '';
    }
  }
}

/// URL 타입 분류
enum UrlType { instagram, youtube, twitter, facebook, tiktok, other }
