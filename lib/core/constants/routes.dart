/// 앱 내 모든 라우트 경로를 관리하는 상수 클래스
///
/// GoRouter에서 사용되는 라우트 경로들을 중앙에서 관리하여
/// 경로 변경 시 일관성을 유지하고 오타를 방지합니다.
class AppRoutes {
  // 메인 쉘 라우트 (바텀 네비게이션이 있는 기본 레이아웃)
  static const String shell = '/shell';

  // 바텀 네비게이션 탭들의 기본 경로
  static const String home = '/home';
  static const String courseMarket = '/course-market';
  static const String map = '/map';
  static const String schedule = '/schedule';
  static const String myPage = '/my-page';

  /// 모든 바텀 네비게이션 탭의 경로를 리스트로 반환
  /// 탭 인덱스와 경로를 매핑할 때 사용
  static List<String> get bottomNavRoutes => [
        home,
        courseMarket,
        map,
        schedule,
        myPage,
      ];

  /// 바텀 네비게이션 탭의 라벨들
  /// UI에서 탭 제목을 표시할 때 사용
  static List<String> get tabLabels => [
        '홈',
        '코스마켓',
        '지도',
        '스케줄',
        '마이페이지',
      ];
}

/// 네비게이션 아이콘 파일 경로 관리 클래스
///
/// assets/navigation_icons 폴더의 SVG 파일들을 관리하며,
/// active/inactive 상태별 아이콘 경로를 제공합니다.
class NavigationIcons {
  static const String _basePath = 'assets/navigation_icons';

  // 홈 탭 아이콘
  static const String homeActive = '$_basePath/home_active.svg';
  static const String homeInactive = '$_basePath/home_inactive.svg';

  // 코스 마켓 탭 아이콘
  static const String courseMarketActive = '$_basePath/course_market_active.svg';
  static const String courseMarketInactive = '$_basePath/course_market_inactive.svg';

  // 지도 탭 아이콘
  static const String mapActive = '$_basePath/map_active.svg';
  static const String mapInactive = '$_basePath/map_inactive.svg';

  // 스케줄 탭 아이콘
  static const String scheduleActive = '$_basePath/schedule_active.svg';
  static const String scheduleInactive = '$_basePath/schedule_inactive.svg';

  // 마이페이지 탭 아이콘
  static const String myPageActive = '$_basePath/my_page_active.svg';
  static const String myPageInactive = '$_basePath/my_page_inactive.svg';

  /// 탭 인덱스에 따른 active 아이콘 경로 반환
  static String getActiveIcon(int index) {
    switch (index) {
      case 0:
        return homeActive;
      case 1:
        return courseMarketActive;
      case 2:
        return mapActive;
      case 3:
        return scheduleActive;
      case 4:
        return myPageActive;
      default:
        return homeActive; // 기본값으로 홈 아이콘 반환
    }
  }

  /// 탭 인덱스에 따른 inactive 아이콘 경로 반환
  static String getInactiveIcon(int index) {
    switch (index) {
      case 0:
        return homeInactive;
      case 1:
        return courseMarketInactive;
      case 2:
        return mapInactive;
      case 3:
        return scheduleInactive;
      case 4:
        return myPageInactive;
      default:
        return homeInactive; // 기본값으로 홈 아이콘 반환
    }
  }
}