import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'routes.dart';
import 'route_guards.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../theme/app_spacing.dart';
import '../../shared/widgets/layout/bottom_navigation.dart';
import '../../features/splash/presentation/screens/splash_screen.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/onboarding/presentation/screens/onboarding_screen.dart';
import '../../features/notifications/presentation/screens/notification_screen.dart';
import '../../core/models/content_model.dart';
import '../../features/home/presentation/screens/home_screen.dart';
import '../../features/home/presentation/screens/sns_contents_list_screen.dart';
import '../../features/home/presentation/screens/sns_content_detail_screen.dart';
import '../../features/course_market/presentation/screens/course_market_screen.dart';
import '../../features/course_market/presentation/screens/course_search_screen.dart';
import '../../features/course_market/presentation/screens/popular_courses_screen.dart';
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

  /// 각 탭 브랜치별 네비게이터 키 (독립적인 네비게이션 스택 관리)
  static final _homeNavigatorKey = GlobalKey<NavigatorState>(
    debugLabel: 'home',
  );
  static final _courseMarketNavigatorKey = GlobalKey<NavigatorState>(
    debugLabel: 'courseMarket',
  );
  static final _mapNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'map');
  static final _scheduleNavigatorKey = GlobalKey<NavigatorState>(
    debugLabel: 'schedule',
  );
  static final _myPageNavigatorKey = GlobalKey<NavigatorState>(
    debugLabel: 'myPage',
  );

  /// 탭 재클릭 시 실행될 콜백 저장소
  ///
  /// key: 탭 인덱스 (0: 홈, 1: 코스마켓, 2: 지도, 3: 일정, 4: 마이페이지)
  /// value: 탭 재클릭 시 실행될 콜백 함수
  static final Map<int, VoidCallback?> _tabRefreshCallbacks = {};

  /// GoRouter 인스턴스 생성
  ///
  /// [container] ProviderContainer - UserNotifier 상태 감지용 (선택)
  ///
  /// container가 제공되면 refreshListenable을 통해 인증 상태 변화를 감지합니다.
  static GoRouter createRouter([ProviderContainer? container]) {
    return GoRouter(
      navigatorKey: _rootNavigatorKey,
      initialLocation: AppRoutes.splash,
      redirect: RouteGuard.redirectLogic,
      // UserNotifier 상태 변화 감지 (container가 있을 때만)
      refreshListenable: container != null
          ? GoRouterRefreshNotifier(container)
          : null,
      routes: _buildRoutes(),
    );
  }

  /// GoRouter 인스턴스 (기본 - refreshListenable 없음)
  /// 앱 전체에서 사용되는 라우터 설정
  static final GoRouter router = createRouter();

  /// 라우트 목록 생성
  static List<RouteBase> _buildRoutes() => [
    /// 루트 경로 라우트
    ///
    /// 브라우저나 외부에서 '/' 경로로 접근 시 처리
    /// RouteGuard에서 자동으로 스플래시로 리다이렉트됨
    GoRoute(
      path: AppRoutes.root,
      redirect: (context, state) => AppRoutes.splash,
    ),

    /// 스플래시 화면 라우트
    ///
    /// 앱 시작 시 표시되는 브랜딩 화면으로,
    /// 로고와 애니메이션을 보여준 후 자동으로 홈 화면으로 이동합니다.
    GoRoute(
      path: AppRoutes.splash,
      pageBuilder: (context, state) =>
          NoTransitionPage(child: const SplashScreen()),
    ),

    /// 로그인 화면 라우트
    ///
    /// 이메일/비밀번호 로그인과 소셜 로그인(카카오, 네이버)을 제공합니다.
    /// 인증이 필요없는 공개 화면입니다.
    GoRoute(
      path: AppRoutes.login,
      pageBuilder: (context, state) =>
          NoTransitionPage(child: const LoginScreen()),
    ),

    /// 온보딩 화면 라우트
    ///
    /// 첫 로그인 시 사용자 정보를 입력받는 5단계 온보딩 플로우:
    /// 1. 닉네임 입력 (2-10자)
    /// 2. 생년월일 입력 (만 14세 이상)
    /// 3. 성별 선택 (선택사항)
    /// 4. 관심사 선택 (3-10개)
    /// 5. 환영 화면
    /// 인증이 필요없는 공개 화면입니다.
    GoRoute(
      path: AppRoutes.onboarding,
      pageBuilder: (context, state) =>
          NoTransitionPage(child: const OnboardingScreen()),
    ),

    /// 알림 화면 라우트
    ///
    /// 앱 내 알림을 통합 관리하는 화면입니다.
    /// - 외부 앱에서 공유된 링크/데이터 (현재 구현)
    /// - 판매 알림, 활동 알림 등 (향후 추가 예정)
    GoRoute(
      path: AppRoutes.notifications,
      pageBuilder: (context, state) =>
          NoTransitionPage(child: const NotificationScreen()),
    ),

    /// StatefulShellRoute: 상태를 유지하는 바텀 네비게이션 레이아웃
    ///
    /// IndexedStack을 사용하여 각 탭의 상태를 독립적으로 유지합니다.
    /// 탭 전환 시에도 이전 탭의 스크롤 위치와 데이터가 그대로 유지됩니다.
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return Scaffold(
          // StatefulNavigationShell이 각 탭을 IndexedStack으로 관리
          body: navigationShell,
          // 커스텀 바텀 네비게이션 바
          bottomNavigationBar: CustomBottomNavigationBar(
            currentIndex: navigationShell.currentIndex,
            onTap: (index) => navigationShell.goBranch(
              index,
              initialLocation: index == navigationShell.currentIndex,
            ),
            onTabReselected: (index) => _onTabReselected(index),
          ),
        );
      },
      branches: [
        /// 홈 탭 브랜치 (인덱스: 0)
        /// 최근 저장된 장소와 추천 코스를 표시하는 메인 화면
        StatefulShellBranch(
          navigatorKey: _homeNavigatorKey,
          routes: [
            GoRoute(
              path: AppRoutes.home,
              pageBuilder: (context, state) =>
                  NoTransitionPage(child: const HomeScreen()),
              routes: [
                // SNS 콘텐츠 리스트 화면
                GoRoute(
                  path: 'sns-contents',
                  pageBuilder: (context, state) {
                    return NoTransitionPage(
                      child: const SnsContentsListScreen(),
                    );
                  },
                  routes: [
                    // SNS 콘텐츠 상세 화면
                    GoRoute(
                      path: 'detail/:contentId',
                      pageBuilder: (context, state) {
                        final contentId = state.pathParameters['contentId']!;
                        ContentModel? content;

                        // state.extra 타입 안전성 체크
                        if (state.extra is Map<String, dynamic>) {
                          try {
                            content = ContentModel.fromJson(
                              state.extra as Map<String, dynamic>,
                            );
                          } catch (e) {
                            // JSON 파싱 실패 시 에러 페이지 표시
                            debugPrint(
                              '[Router] ContentModel 파싱 실패: $e',
                            );
                            content = null;
                          }
                        } else if (state.extra is ContentModel) {
                          content = state.extra as ContentModel;
                        }

                        // state.extra가 null이거나 잘못된 타입일 경우 에러 페이지 표시
                        if (content == null) {
                          return NoTransitionPage(
                            child: Scaffold(
                              appBar: AppBar(title: const Text('오류')),
                              body: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.error_outline,
                                      size: AppSizes.iconError,
                                      color: AppColors.subColor2,
                                    ),
                                    AppSpacing.verticalSpaceLG,
                                    Text(
                                      '콘텐츠를 찾을 수 없습니다',
                                      style: AppTextStyles.summaryBold18,
                                    ),
                                    AppSpacing.verticalSpaceSM,
                                    Text(
                                      'Content ID: $contentId',
                                      style: AppTextStyles.bodyRegular14
                                          .copyWith(color: AppColors.subColor2),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }

                        return NoTransitionPage(
                          child: SnsContentDetailScreen(content: content),
                        );
                      },
                    ),
                  ],
                ),
              ],
            ), // GoRoute(AppRoutes.home) 닫기
          ], // StatefulShellBranch.routes 닫기
        ), // StatefulShellBranch(홈) 닫기
        /// 코스마켓 탭 브랜치 (인덱스: 1)
        /// 여행 코스 리스트와 상세 정보를 제공하는 마켓플레이스
        StatefulShellBranch(
          navigatorKey: _courseMarketNavigatorKey,
          routes: [
            GoRoute(
              path: AppRoutes.courseMarket,
              pageBuilder: (context, state) =>
                  NoTransitionPage(child: const CourseMarketScreen()),
              routes: [
                // 코스 검색 화면
                GoRoute(
                  path: 'search',
                  pageBuilder: (context, state) {
                    // Fade 애니메이션으로 부드러운 전환
                    return CustomTransitionPage(
                      key: state.pageKey,
                      child: const CourseSearchScreen(),
                      transitionsBuilder:
                          (context, animation, secondaryAnimation, child) {
                            // Fade 애니메이션 (0.0 → 1.0)
                            return FadeTransition(
                              opacity: animation,
                              child: child,
                            );
                          },
                    );
                  },
                ),
                // 실시간 인기 코스 더보기 화면
                GoRoute(
                  path: 'popular',
                  pageBuilder: (context, state) {
                    // 애니메이션 없이 즉시 전환
                    return NoTransitionPage(
                      child: const PopularCoursesScreen(),
                    );
                  },
                ),
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
          ],
        ), // StatefulShellBranch(코스마켓) 닫기
        /// 지도 탭 브랜치 (인덱스: 2)
        /// 저장된 장소들을 지도에서 시각화하여 표시
        StatefulShellBranch(
          navigatorKey: _mapNavigatorKey,
          routes: [
            GoRoute(
              path: AppRoutes.map,
              pageBuilder: (context, state) =>
                  NoTransitionPage(child: const MapScreen()),
            ),
          ],
        ), // StatefulShellBranch(지도) 닫기
        /// 일정 탭 브랜치 (인덱스: 3)
        /// 여행 일정 관리 및 달력 기반 일정링
        StatefulShellBranch(
          navigatorKey: _scheduleNavigatorKey,
          routes: [
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
          ],
        ), // StatefulShellBranch(일정) 닫기
        /// 마이페이지 탭 브랜치 (인덱스: 4)
        /// 사용자 프로필, 내 코스, 설정 등 개인 정보 관리
        StatefulShellBranch(
          navigatorKey: _myPageNavigatorKey,
          routes: [
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
        ), // StatefulShellBranch(마이페이지) 닫기
      ],
    ),
  ];

  /// 탭 재클릭 시 호출되는 메서드
  ///
  /// [index] 재선택된 탭의 인덱스
  static void _onTabReselected(int index) {
    // 해당 탭에 등록된 콜백이 있으면 실행
    _tabRefreshCallbacks[index]?.call();
  }

  /// 탭 새로고침 콜백 등록
  ///
  /// 각 탭 화면의 initState에서 호출하여 탭 재클릭 콜백을 등록합니다.
  ///
  /// [index] 탭 인덱스
  /// [callback] 탭 재클릭 시 실행할 콜백 함수
  static void registerTabRefreshCallback(int index, VoidCallback callback) {
    _tabRefreshCallbacks[index] = callback;
  }

  /// 탭 새로고침 콜백 해제
  ///
  /// 각 탭 화면의 dispose에서 호출하여 콜백을 정리합니다.
  ///
  /// [index] 탭 인덱스
  static void unregisterTabRefreshCallback(int index) {
    _tabRefreshCallbacks.remove(index);
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
