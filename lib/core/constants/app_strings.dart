/// TripTogether 앱에서 사용되는 모든 문자열 상수
///
/// 하드코딩된 문자열들을 중앙에서 관리하여 일관성과 유지보수성을 향상시킵니다.
/// 향후 다국어 지원을 위한 기반이 됩니다.
class AppStrings {
  AppStrings._();

  // ================================
  // 앱 기본 정보
  // ================================

  /// 앱 이름
  static const String appName = 'Tripgether';

  /// 앱 기본 제목 (AppBar용)
  static const String appTitle = 'Tripgether';

  // ================================
  // 화면 제목들
  // ================================

  /// 지도 화면 제목
  static const String screenMap = '지도 화면';

  /// 코스마켓 화면 제목
  static const String screenCourseMarket = '코스마켓';

  /// 일정 화면 제목
  static const String screenSchedule = '내 일정';

  /// 마이페이지 화면 제목
  static const String screenMyPage = '마이페이지';

  // ================================
  // TODO(human): 여기에 추가 상수들을 정리해주세요
  // ================================

  // 버튼 텍스트
  // 알림 메시지
  // 플레이스홀더 텍스트
  // 툴팁 텍스트
  // 에러 메시지
  // 네비게이션 라벨

  // ================================
  // 알림 관련
  // ================================

  /// 알림 다이얼로그 제목
  static const String notificationTitle = '알림';

  /// 기본 알림 메시지
  static const String notificationEmpty = '현재 새로운 알림이 없습니다.';

  // ================================
  // 공통 버튼 텍스트
  // ================================

  /// 확인 버튼
  static const String buttonConfirm = '확인';

  /// 취소 버튼
  static const String buttonCancel = '취소';

  /// 저장 버튼
  static const String buttonSave = '저장';

  // ================================
  // 툴팁 텍스트
  // ================================

  /// 뒤로가기 툴팁
  static const String tooltipBack = '뒤로가기';

  /// 메뉴 툴팁
  static const String tooltipMenu = '메뉴';

  /// 알림 툴팁
  static const String tooltipNotification = '알림';

  /// 검색 툴팁
  static const String tooltipSearch = '검색';

  /// 필터 툴팁
  static const String tooltipFilter = '필터';

  /// 설정 툴팁
  static const String tooltipSettings = '설정';

  /// 내 위치 툴팁
  static const String tooltipMyLocation = '내 위치';

  /// 캘린더 툴팁
  static const String tooltipCalendar = '캘린더';

  /// 일정 추가 툴팁
  static const String tooltipAddSchedule = '일정 추가';

  // ================================
  // 플레이스홀더 텍스트
  // ================================

  /// 지도 API 연동 예정 메시지
  static const String placeholderMapApi = '지도 API 연동 예정';

  /// 코스마켓 콘텐츠 예정 메시지
  static const String placeholderCourseMarket = '여행 코스 목록 및 상세 정보 표시 예정';

  /// 일정 콘텐츠 예정 메시지
  static const String placeholderSchedule = '여행 일정 목록 및 캘린더 뷰 표시 예정';

  /// 마이페이지 콘텐츠 예정 메시지
  static const String placeholderMyPage = '사용자 프로필 및 설정 메뉴 표시 예정';

  // ================================
  // 시맨틱 라벨 (접근성용)
  // ================================

  /// 뒤로가기 버튼 시맨틱 라벨
  static const String semanticBackButton = '뒤로가기 버튼';

  /// 메뉴 버튼 시맨틱 라벨
  static const String semanticMenuButton = '메뉴 버튼';

  /// 알림 버튼 시맨틱 라벨
  static const String semanticNotificationButton = '알림 버튼';

  /// 검색 버튼 시맨틱 라벨
  static const String semanticSearchButton = '검색 버튼';

  /// 필터 버튼 시맨틱 라벨
  static const String semanticFilterButton = '필터 버튼';

  /// 설정 버튼 시맨틱 라벨
  static const String semanticSettingsButton = '설정 버튼';

  /// 캘린더 뷰 버튼 시맨틱 라벨
  static const String semanticCalendarButton = '캘린더 뷰 버튼';

  /// 일정 추가 버튼 시맨틱 라벨
  static const String semanticAddScheduleButton = '일정 추가 버튼';

  // ================================
  // 디버그 메시지
  // ================================

  /// 지도 메뉴 버튼 클릭 로그
  static const String debugMapMenuClicked = '지도 메뉴 버튼 클릭';

  /// 내 위치 버튼 클릭 로그
  static const String debugMyLocationClicked = '내 위치 버튼 클릭';

  /// 코스마켓 메뉴 버튼 클릭 로그
  static const String debugCourseMarketMenuClicked = '코스마켓 메뉴 버튼 클릭';

  /// 코스마켓 검색 버튼 클릭 로그
  static const String debugCourseMarketSearchClicked = '코스마켓 검색 버튼 클릭';

  /// 코스마켓 필터 버튼 클릭 로그
  static const String debugCourseMarketFilterClicked = '코스마켓 필터 버튼 클릭';

  /// 일정 메뉴 버튼 클릭 로그
  static const String debugScheduleMenuClicked = '일정 화면 메뉴 버튼 클릭';

  /// 일정 알림 버튼 클릭 로그
  static const String debugScheduleNotificationClicked = '일정 화면 알림 버튼 클릭';

  /// 캘린더 뷰 버튼 클릭 로그
  static const String debugCalendarViewClicked = '캘린더 뷰 버튼 클릭';

  /// 일정 추가 버튼 클릭 로그
  static const String debugAddScheduleClicked = '일정 추가 버튼 클릭';

  /// 마이페이지 알림 버튼 클릭 로그
  static const String debugMyPageNotificationClicked = '마이페이지 알림 버튼 클릭';

  /// 마이페이지 설정 버튼 클릭 로그
  static const String debugMyPageSettingsClicked = '마이페이지 설정 버튼 클릭';
}
