import 'dart:math';
import 'package:flutter/services.dart';

/// 생년월일 입력을 자동으로 YYYY / MM / DD 형식으로 포맷팅하는 TextInputFormatter
///
/// **사용 예시**:
/// ```dart
/// TextField(
///   inputFormatters: [DateInputFormatter()],
///   keyboardType: TextInputType.number,
/// )
/// ```
///
/// **동작 방식**:
/// - 사용자가 "19980215"를 입력하면 자동으로 "1998 / 02 / 15"로 표시
/// - 숫자만 입력 가능 (슬래시는 자동 추가)
/// - 최대 8자리 숫자까지 입력 가능 (YYYYMMDD)
/// - 백스페이스 시 슬래시를 건너뛰며 자연스럽게 삭제
class DateInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    // 1. 숫자만 추출 (슬래시와 공백 제거)
    final digitsOnly = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');

    // 2. 최대 8자리까지만 허용 (YYYYMMDD)
    final trimmed = digitsOnly.substring(0, min(8, digitsOnly.length));

    // 3. 입력된 숫자가 없으면 빈 문자열 반환
    if (trimmed.isEmpty) {
      return const TextEditingValue(
        text: '',
        selection: TextSelection.collapsed(offset: 0),
      );
    }

    // 4. YYYY / MM / DD 형식으로 포맷팅
    String formatted = '';

    for (int i = 0; i < trimmed.length; i++) {
      // 연도(4자리) 이후에 " / " 추가
      if (i == 4) {
        formatted += ' / ';
      }
      // 월(2자리) 이후에 " / " 추가
      else if (i == 6) {
        formatted += ' / ';
      }
      formatted += trimmed[i];
    }

    // 5. 커서 위치 계산 (중간 편집 지원)
    int cursorPosition;

    // 이전 선택 영역 정보
    final oldSelection = oldValue.selection;
    final oldDigits = oldValue.text.replaceAll(RegExp(r'[^0-9]'), '');

    // 선택 시작 위치까지의 숫자 개수
    final digitsBeforeSelection = oldValue.text
        .substring(0, oldSelection.start)
        .replaceAll(RegExp(r'[^0-9]'), '')
        .length;

    // 선택된 영역의 숫자 개수
    final selectedDigits = oldValue.text
        .substring(oldSelection.start, oldSelection.end)
        .replaceAll(RegExp(r'[^0-9]'), '')
        .length;

    if (trimmed.length > oldDigits.length) {
      // 입력: 끝으로 이동 (연속 입력, 필드가 비어있던 경우)
      cursorPosition = formatted.length;
    } else if (trimmed.length < oldDigits.length) {
      // 삭제: 삭제한 위치에 커서 유지
      final newDigitIndex = digitsBeforeSelection - 1;
      cursorPosition = _calculateCursorPosition(trimmed, newDigitIndex);
    } else {
      // 길이 동일 (교체 또는 동일 입력)
      // 교체된 경우: 선택 시작 + 입력된 숫자 개수
      final addedDigits = trimmed.length - oldDigits.length + selectedDigits;
      final newDigitIndex = digitsBeforeSelection + addedDigits - 1;
      cursorPosition = _calculateCursorPosition(trimmed, newDigitIndex);
    }

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: cursorPosition),
    );
  }

  /// 숫자 인덱스를 기반으로 포맷팅된 텍스트의 커서 위치 계산
  ///
  /// [digits] 숫자만 있는 문자열 (예: "19980215")
  /// [digitIndex] 숫자 인덱스 (예: 4 = "1998"의 끝)
  /// Returns: 포맷팅된 문자열에서의 커서 위치 (슬래시 포함)
  int _calculateCursorPosition(String digits, int digitIndex) {
    if (digitIndex < 0) return 0;
    if (digitIndex >= digits.length) {
      // 끝을 넘어가면 포맷팅된 전체 길이 계산
      int position = digits.length;
      if (digits.length > 4) position += 3; // " / " 추가
      if (digits.length > 6) position += 3; // " / " 추가
      return position;
    }

    // digitIndex까지의 실제 위치 계산
    int position = digitIndex + 1;
    if (digitIndex >= 4) position += 3; // YYYY 이후 " / "
    if (digitIndex >= 6) position += 3; // MM 이후 " / "

    return position;
  }

  /// 포맷팅된 텍스트에서 숫자만 추출하는 헬퍼 메서드
  ///
  /// 예: "1998 / 02 / 15" → "19980215"
  static String getDigitsOnly(String formattedText) {
    return formattedText.replaceAll(RegExp(r'[^0-9]'), '');
  }

  /// 8자리 숫자 문자열을 YYYY-MM-DD 형식으로 변환하는 헬퍼 메서드
  ///
  /// 예: "19980215" → "1998-02-15"
  static String toIsoFormat(String digits) {
    if (digits.length != 8) return '';
    return '${digits.substring(0, 4)}-${digits.substring(4, 6)}-${digits.substring(6, 8)}';
  }

  /// YYYY-MM-DD 형식을 YYYY / MM / DD 형식으로 변환하는 헬퍼 메서드
  ///
  /// 예: "1998-02-15" → "1998 / 02 / 15"
  static String toDisplayFormat(String isoDate) {
    final digits = isoDate.replaceAll('-', '');
    if (digits.length != 8) return '';
    return '${digits.substring(0, 4)} / ${digits.substring(4, 6)} / ${digits.substring(6, 8)}';
  }
}
