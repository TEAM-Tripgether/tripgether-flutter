import 'package:flutter_test/flutter_test.dart';
import 'package:tripgether/core/utils/shared_data_parser.dart';

void main() {
  group('SharedDataParser', () {
    group('extractAuthor', () {
      test('Instagram 형식에서 작성자 추출', () {
        // Given
        final texts = [
          '@sejong_student님의 이 Instagram 게시물 보기',
          'https://instagram.com/p/abc123',
        ];

        // When
        final author = SharedDataParser.extractAuthor(texts);

        // Then
        expect(author, 'sejong_student');
      });

      test('다양한 사용자명 패턴 처리', () {
        final testCases = {
          ['@user123님의 게시물', 'url']: 'user123',
          ['@test_user님의 포스트', 'url']: 'test_user',
          ['@CamelCase님의 스토리', 'url']: 'CamelCase',
        };

        testCases.forEach((texts, expected) {
          final result = SharedDataParser.extractAuthor(texts);
          expect(result, expected);
        });
      });

      test('빈 배열일 때 기본값 반환', () {
        // Given
        final texts = <String>[];

        // When
        final author = SharedDataParser.extractAuthor(texts);

        // Then
        expect(author, '사용자');
      });

      test('@username님 패턴이 없을 때 기본값 반환', () {
        // Given
        final texts = ['일반 텍스트', 'https://example.com'];

        // When
        final author = SharedDataParser.extractAuthor(texts);

        // Then
        expect(author, '사용자');
      });

      test('특수문자가 포함된 사용자명은 추출 실패', () {
        // Given: 특수문자는 \w 패턴에 맞지 않음
        final texts = ['@user-name님의 게시물', 'url'];

        // When
        final author = SharedDataParser.extractAuthor(texts);

        // Then
        expect(author, '사용자');
      });
    });

    group('extractUrl', () {
      test('Instagram URL 추출', () {
        // Given
        final texts = [
          '@sejong_student님의 이 Instagram 게시물 보기',
          'https://www.instagram.com/p/abc123/',
        ];

        // When
        final url = SharedDataParser.extractUrl(texts);

        // Then
        expect(url, 'https://www.instagram.com/p/abc123/');
      });

      test('다양한 URL 형식 처리', () {
        final testCases = {
          ['text', 'https://example.com']: 'https://example.com',
          ['text', 'http://test.com/path']: 'http://test.com/path',
          ['text', 'https://site.co.kr/path?query=value']:
              'https://site.co.kr/path?query=value',
        };

        testCases.forEach((texts, expected) {
          final result = SharedDataParser.extractUrl(texts);
          expect(result, expected);
        });
      });

      test('배열이 2개 미만일 때 빈 문자열 반환', () {
        // Given
        final texts = ['only one element'];

        // When
        final url = SharedDataParser.extractUrl(texts);

        // Then
        expect(url, '');
      });

      test('유효하지 않은 URL일 때 빈 문자열 반환', () {
        // Given
        final texts = ['text', 'not a valid url'];

        // When
        final url = SharedDataParser.extractUrl(texts);

        // Then
        expect(url, '');
      });

      test('빈 배열일 때 빈 문자열 반환', () {
        // Given
        final texts = <String>[];

        // When
        final url = SharedDataParser.extractUrl(texts);

        // Then
        expect(url, '');
      });
    });

    group('parse', () {
      test('작성자와 URL을 함께 추출', () {
        // Given
        final texts = [
          '@tripgether_official님의 이 Instagram 게시물 보기',
          'https://www.instagram.com/p/xyz789/',
        ];

        // When
        final result = SharedDataParser.parse(texts);

        // Then
        expect(result['author'], 'tripgether_official');
        expect(result['url'], 'https://www.instagram.com/p/xyz789/');
      });

      test('일부 정보만 있을 때도 안전하게 처리', () {
        // Given
        final texts = ['일반 텍스트'];

        // When
        final result = SharedDataParser.parse(texts);

        // Then
        expect(result['author'], '사용자');
        expect(result['url'], '');
      });

      test('빈 데이터일 때 기본값 반환', () {
        // Given
        final texts = <String>[];

        // When
        final result = SharedDataParser.parse(texts);

        // Then
        expect(result['author'], '사용자');
        expect(result['url'], '');
      });

      test('실제 Instagram 공유 데이터 형식 처리', () {
        // Given: Instagram에서 공유 시 실제 형식
        final texts = [
          '@seoul_travel님의 이 Instagram 게시물 보기',
          'https://www.instagram.com/reel/CxYzAbCdEfG/?igsh=MTc4MmM1YmI2Ng==',
        ];

        // When
        final result = SharedDataParser.parse(texts);

        // Then
        expect(result['author'], 'seoul_travel');
        expect(result['url'], contains('instagram.com'));
        expect(result['url'], contains('reel'));
      });
    });
  });
}
