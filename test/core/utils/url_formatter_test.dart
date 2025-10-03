import 'package:flutter_test/flutter_test.dart';
import 'package:triptogether/core/utils/url_formatter.dart';

void main() {
  group('UrlFormatter.cleanUrl', () {
    test('Instagram URL에서 utm_source 파라미터 제거', () {
      const original =
          'https://www.instagram.com/p/DPTQUVskp-S/?utm_source=ig_web_button_native_share';
      const expected = 'https://www.instagram.com/p/DPTQUVskp-S/';

      final result = UrlFormatter.cleanUrl(original);

      expect(result, expected);
    });

    test('YouTube URL에서 utm_source는 제거하고 v= 파라미터는 유지', () {
      const original =
          'https://www.youtube.com/watch?v=dQw4w9WgXcQ&utm_source=share';
      const expected = 'https://www.youtube.com/watch?v=dQw4w9WgXcQ';

      final result = UrlFormatter.cleanUrl(original);

      expect(result, expected);
    });

    test('네이버 검색 URL에서 utm 제거하고 query는 유지', () {
      const original =
          'https://search.naver.com/search?query=flutter&utm_source=share';
      const expected = 'https://search.naver.com/search?query=flutter';

      final result = UrlFormatter.cleanUrl(original);

      expect(result, expected);
    });

    test('추적 파라미터가 없는 URL은 그대로 반환', () {
      const url = 'https://example.com/page';

      final result = UrlFormatter.cleanUrl(url);

      expect(result, url);
    });

    test('여러 추적 파라미터 동시 제거', () {
      const original =
          'https://example.com/page?param1=value1&utm_source=share&fbclid=abc123&param2=value2&gclid=xyz789';
      const expected = 'https://example.com/page?param1=value1&param2=value2';

      final result = UrlFormatter.cleanUrl(original);

      expect(result, expected);
    });

    test('fragment(#)는 유지', () {
      const original =
          'https://example.com/page?utm_source=share#section1';
      const expected = 'https://example.com/page#section1';

      final result = UrlFormatter.cleanUrl(original);

      expect(result, expected);
    });
  });

  group('UrlFormatter.isValidUrl', () {
    test('유효한 http URL', () {
      expect(UrlFormatter.isValidUrl('http://example.com'), true);
    });

    test('유효한 https URL', () {
      expect(UrlFormatter.isValidUrl('https://example.com'), true);
    });

    test('scheme이 없는 URL은 유효하지 않음', () {
      expect(UrlFormatter.isValidUrl('example.com'), false);
    });

    test('잘못된 형식의 문자열', () {
      expect(UrlFormatter.isValidUrl('not a url'), false);
    });
  });

  group('UrlFormatter.getUrlType', () {
    test('Instagram URL 타입 감지', () {
      expect(
        UrlFormatter.getUrlType('https://www.instagram.com/p/ABC/'),
        UrlType.instagram,
      );
    });

    test('YouTube URL 타입 감지', () {
      expect(
        UrlFormatter.getUrlType('https://www.youtube.com/watch?v=123'),
        UrlType.youtube,
      );
    });

    test('youtu.be 단축 URL도 YouTube로 감지', () {
      expect(
        UrlFormatter.getUrlType('https://youtu.be/123'),
        UrlType.youtube,
      );
    });

    test('Twitter URL 타입 감지', () {
      expect(
        UrlFormatter.getUrlType('https://twitter.com/user/status/123'),
        UrlType.twitter,
      );
    });

    test('X.com도 Twitter로 감지', () {
      expect(
        UrlFormatter.getUrlType('https://x.com/user/status/123'),
        UrlType.twitter,
      );
    });

    test('알 수 없는 URL은 other 타입', () {
      expect(
        UrlFormatter.getUrlType('https://example.com'),
        UrlType.other,
      );
    });
  });

  group('UrlFormatter.extractDomain', () {
    test('www 제거하여 도메인 추출', () {
      expect(
        UrlFormatter.extractDomain('https://www.instagram.com/p/ABC/'),
        'instagram.com',
      );
    });

    test('www 없는 도메인은 그대로 반환', () {
      expect(
        UrlFormatter.extractDomain('https://youtube.com/watch'),
        'youtube.com',
      );
    });

    test('잘못된 URL은 빈 문자열 반환', () {
      expect(
        UrlFormatter.extractDomain('not a url'),
        '',
      );
    });
  });
}
