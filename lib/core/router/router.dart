import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'routes.dart';
import 'route_guards.dart';
import '../../shared/widgets/layout/bottom_navigation.dart';
import '../../features/splash/presentation/screens/splash_screen.dart';
import '../../features/home/presentation/screens/home_screen.dart';
import '../../features/course_market/presentation/screens/course_market_screen.dart';
import '../../features/map/presentation/screens/map_screen.dart';
import '../../features/schedule/presentation/screens/schedule_screen.dart';
import '../../features/mypage/presentation/screens/mypage_screen.dart';

/// 앱 전체의 라우팅을 관리하는 GoRouter 설정
///
/// ShellRoute를 사용하여 바텀 네비게이션이 있는 메인 레이아웃과
/// 각 탭의 독립적인 네비게이션 스택을 관리합니다.
///
/// PRD.md에 명시된 Clean Architecture 구조에 따라
/// core/router 폴더에 위치합니다.
class AppRouter {
  /// 루트 네비게이터 키
  static final _rootNavigatorKey = GlobalKey<NavigatorState>();

  /// 쉘 네비게이터 키 (바텀 네비게이션용)
  static final _shellNavigatorKey = GlobalKey<NavigatorState>();

  /// GoRouter 인스턴스
  /// 앱 전체에서 사용되는 라우터 설정
  static final GoRouter router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: AppRoutes.splash, // 앱 시작 시 스플래시 화면으로 이동
    redirect: RouteGuard.redirectLogic, // 인증/권한 가드 적용
    routes: [
      /// 스플래시 화면 라우트
      ///
      /// 앱 시작 시 표시되는 브랜딩 화면으로,
      /// 로고와 애니메이션을 보여준 후 자동으로 홈 화면으로 이동합니다.
      GoRoute(
        path: AppRoutes.splash,
        pageBuilder: (context, state) =>
            NoTransitionPage(child: const SplashScreen()),
      ),

      /// ShellRoute: 바텀 네비게이션이 있는 메인 레이아웃
      ///
      /// 모든 메인 탭들이 이 ShellRoute 내부에서 관리되며,
      /// 바텀 네비게이션 바는 항상 화면 하단에 유지됩니다.
      ShellRoute(
        navigatorKey: _shellNavigatorKey,
        builder: (context, state, child) {
          // 현재 경로를 기반으로 탭 인덱스 계산
          final currentIndex = _calculateTabIndex(state.uri.path);

          return Scaffold(
            // 각 탭의 화면 내용
            body: child,
            // 커스텀 바텀 네비게이션 바
            bottomNavigationBar: CustomBottomNavigationBar(
              currentIndex: currentIndex,
              onTap: (index) => _onBottomNavTap(context, index),
            ),
          );
        },
        routes: [
          /// 홈 탭 (인덱스: 0)
          /// 최근 저장된 장소와 추천 코스를 표시하는 메인 화면
          GoRoute(
            path: AppRoutes.home,
            pageBuilder: (context, state) =>
                NoTransitionPage(child: const HomeScreen()),
          ),

          /// 코스 마켓 탭 (인덱스: 1)
          /// 여행 코스 리스트와 상세 정보를 제공하는 마켓플레이스
          GoRoute(
            path: AppRoutes.courseMarket,
            pageBuilder: (context, state) =>
                NoTransitionPage(child: const CourseMarketScreen()),
            routes: [
              // 코스 상세 화면 (ShellRoute 내부의 서브 라우트)
              GoRoute(
                path: 'detail/:courseId',
                builder: (context, state) {
                  final courseId = state.pathParameters['courseId']!;
                  return CourseDetailScreen(courseId: courseId);
                },
              ),
            ],
          ),

          /// 지도 탭 (인덱스: 2)
          /// 저장된 장소들을 지도에서 시각화하여 표시
          GoRoute(
            path: AppRoutes.map,
            pageBuilder: (context, state) =>
                NoTransitionPage(child: const MapScreen()),
            routes: [
              // 장소 상세 화면
              GoRoute(
                path: 'place/:placeId',
                builder: (context, state) {
                  final placeId = state.pathParameters['placeId']!;
                  return PlaceDetailScreen(placeId: placeId);
                },
              ),
            ],
          ),

          /// 일정 탭 (인덱스: 3)
          /// 여행 일정 관리 및 달력 기반 일정링
          GoRoute(
            path: AppRoutes.schedule,
            pageBuilder: (context, state) =>
                NoTransitionPage(child: const ScheduleScreen()),
            routes: [
              // 일정 상세 화면
              GoRoute(
                path: 'detail/:scheduleId',
                builder: (context, state) {
                  final scheduleId = state.pathParameters['scheduleId']!;
                  return ScheduleDetailScreen(scheduleId: scheduleId);
                },
              ),
            ],
          ),

          /// 마이페이지 탭 (인덱스: 4)
          /// 사용자 프로필, 내 코스, 설정 등 개인 정보 관리
          GoRoute(
            path: AppRoutes.myPage,
            pageBuilder: (context, state) =>
                NoTransitionPage(child: const MyPageScreen()),
            routes: [
              // 프로필 편집 화면
              GoRoute(
                path: 'profile-edit',
                builder: (context, state) => const ProfileEditScreen(),
              ),
              // 설정 화면
              GoRoute(
                path: 'settings',
                builder: (context, state) => const SettingsScreen(),
              ),
              // 내 코스 목록 화면
              GoRoute(
                path: 'my-courses',
                builder: (context, state) => const MyCoursesScreen(),
              ),
            ],
          ),
        ],
      ),

    ],
  );

  /// 현재 경로를 기반으로 바텀 네비게이션 탭 인덱스 계산
  ///
  /// [location] 현재 라우트 경로
  ///
  /// Returns: 탭 인덱스 (0-4)
  static int _calculateTabIndex(String location) {
    if (location.startsWith(AppRoutes.home)) return 0;
    if (location.startsWith(AppRoutes.courseMarket)) return 1;
    if (location.startsWith(AppRoutes.map)) return 2;
    if (location.startsWith(AppRoutes.schedule)) return 3;
    if (location.startsWith(AppRoutes.myPage)) return 4;
    return 0; // 기본값으로 홈 탭 반환
  }

  /// 바텀 네비게이션 탭 선택 시 호출되는 메서드
  ///
  /// [context] BuildContext
  /// [index] 선택된 탭의 인덱스 (0: 홈, 1: 코스마켓, 2: 지도, 3: 일정, 4: 마이페이지)
  static void _onBottomNavTap(BuildContext context, int index) {
    final String route = AppRoutes.bottomNavRoutes[index];
    context.go(route);
  }
}

/// 임시 스크린들 (실제 구현 전까지 플레이스홀더)
///
/// 실제 구현 시에는 features 폴더의 각 도메인별 화면들로 교체됩니다.

class CourseDetailScreen extends StatelessWidget {
  final String courseId;

  const CourseDetailScreen({super.key, required this.courseId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('코스 상세 - $courseId')),
      body: Center(child: Text('코스 상세 화면\nID: $courseId')),
    );
  }
}

class PlaceDetailScreen extends StatelessWidget {
  final String placeId;

  const PlaceDetailScreen({super.key, required this.placeId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('장소 상세 - $placeId')),
      body: Center(child: Text('장소 상세 화면\nID: $placeId')),
    );
  }
}

class ScheduleDetailScreen extends StatelessWidget {
  final String scheduleId;

  const ScheduleDetailScreen({super.key, required this.scheduleId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('일정 상세 - $scheduleId')),
      body: Center(child: Text('일정 상세 화면\nID: $scheduleId')),
    );
  }
}

class ProfileEditScreen extends StatelessWidget {
  const ProfileEditScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('프로필 편집')),
      body: const Center(child: Text('프로필 편집 화면')),
    );
  }
}

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('설정')),
      body: const Center(child: Text('설정 화면')),
    );
  }
}

class MyCoursesScreen extends StatelessWidget {
  const MyCoursesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('내 코스')),
      body: const Center(child: Text('내 코스 화면')),
    );
  }
}
