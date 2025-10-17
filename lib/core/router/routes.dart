import 'package:flutter/material.dart';
import '../../l10n/app_localizations.dart';

/// 앱 내 모든 라우트 경로를 관리하는 상수 클래스
///
/// GoRouter에서 사용되는 라우트 경로들을 중앙에서 관리하여
/// 경로 변경 시 일관성을 유지하고 오타를 방지합니다.
class AppRoutes {
  /// 루트 경로
  static const String root = '/';

  /// 스플래시 화면 경로
  static const String splash = '/splash';

  /// 인증 관련 경로
  static const String login = '/auth/login';
  static const String signup = '/auth/signup';

  /// 메인 쉘 라우트 (바텀 네비게이션이 있는 기본 레이아웃)
  static const String shell = '/shell';

  /// 바텀 네비게이션 탭들의 기본 경로
  /// 각 탭은 ShellRoute 내부에서 관리됩니다.
  static const String home = '/home';
  static const String courseMarket = '/course-market';
  static const String map = '/map';
  static const String schedule = '/schedule';
  static const String myPage = '/my-page';

  /// 홈 탭 하위 경로들
  static const String snsContentsList = '/home/sns-contents';
  static const String snsContentDetail = '/home/sns-contents/detail/:contentId';
  static const String savedPlacesList = '/home/saved-places';

  /// 코스마켓 탭 하위 경로들
  static const String courseMarketSearch = '/course-market/search';

  /// 상세 화면 경로들
  static const String courseDetail = '/course-detail/:courseId';
  static const String placeDetail = '/place-detail/:placeId';
  static const String scheduleDetail = '/schedule-detail/:scheduleId';
  static const String profileEdit = '/profile-edit';
  static const String settings = '/settings';

  /// 모든 바텀 네비게이션 탭의 경로를 리스트로 반환
  /// 탭 인덱스와 경로를 매핑할 때 사용
  static List<String> get bottomNavRoutes => [
    home,
    courseMarket,
    map,
    schedule,
    myPage,
  ];

  /// 바텀 네비게이션 탭의 라벨들 (국제화 적용)
  /// UI에서 탭 제목을 표시할 때 사용
  ///
  /// 사용 예: `AppRoutes.getTabLabels(context)`
  static List<String> getTabLabels(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return [
      l10n.navHome,
      l10n.navCourseMarket,
      l10n.navMap,
      l10n.navSchedule,
      l10n.navMyPage,
    ];
  }

  /// 인증이 필요한 경로들
  /// route_guards.dart에서 사용
  static Set<String> get protectedRoutes => {
    courseDetail,
    scheduleDetail,
    profileEdit,
    settings,
    // 바텀 네비게이션 탭들도 기본적으로 인증 필요
    ...bottomNavRoutes,
  };

  /// 인증이 필요없는 공개 경로들
  /// route_guards.dart에서 사용
  static Set<String> get publicRoutes => {splash, login, signup};
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

  // 코스마켓 탭 아이콘
  static const String courseMarketActive =
      '$_basePath/course_market_active.svg';
  static const String courseMarketInactive =
      '$_basePath/course_market_inactive.svg';

  // 지도 탭 아이콘
  static const String mapActive = '$_basePath/map_active.svg';
  static const String mapInactive = '$_basePath/map_inactive.svg';

  // 일정 탭 아이콘
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
