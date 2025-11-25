import 'package:freezed_annotation/freezed_annotation.dart';

part 'business_hour_model.freezed.dart';
part 'business_hour_model.g.dart';

/// 영업시간 정보 모델
///
/// 백엔드 API의 businessHours 배열 내 각 항목을 매핑합니다.
/// 요일별 영업시간 정보를 포함합니다.
@freezed
class BusinessHourModel with _$BusinessHourModel {
  const factory BusinessHourModel({
    /// 요일 (MONDAY, TUESDAY, WEDNESDAY, THURSDAY, FRIDAY, SATURDAY, SUNDAY)
    required String dayOfWeek,

    /// 오픈 시간 (HH:mm 형식, 예: "09:00")
    required String openTime,

    /// 마감 시간 (HH:mm 형식, 예: "22:00")
    required String closeTime,
  }) = _BusinessHourModel;

  /// JSON 직렬화/역직렬화를 위한 팩토리 생성자
  factory BusinessHourModel.fromJson(Map<String, dynamic> json) =>
      _$BusinessHourModelFromJson(json);
}

/// 요일 영문 → 한글 변환 유틸
extension DayOfWeekExtension on String {
  /// 영문 요일을 한글로 변환
  ///
  /// MONDAY → 월요일
  /// TUESDAY → 화요일
  /// ...
  String toKoreanDayOfWeek() {
    const dayMap = {
      'MONDAY': '월요일',
      'TUESDAY': '화요일',
      'WEDNESDAY': '수요일',
      'THURSDAY': '목요일',
      'FRIDAY': '금요일',
      'SATURDAY': '토요일',
      'SUNDAY': '일요일',
    };
    return dayMap[this] ?? this;
  }
}
