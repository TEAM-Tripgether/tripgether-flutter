import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tripgether/core/router/routes.dart';
import 'package:tripgether/core/theme/app_colors.dart';
import 'package:tripgether/core/theme/app_spacing.dart';
import 'package:tripgether/core/theme/app_text_styles.dart';
import 'package:tripgether/features/auth/providers/user_provider.dart';
import 'package:tripgether/features/course_market/presentation/widgets/popular_courses_section.dart';
import 'package:tripgether/features/course_market/presentation/widgets/nearby_section.dart';
import 'package:tripgether/l10n/app_localizations.dart';
import 'package:tripgether/shared/mixins/refreshable_tab_mixin.dart';
import 'package:tripgether/shared/widgets/inputs/search_bar.dart';
import 'package:tripgether/shared/widgets/layout/gradient_background.dart';
import 'package:tripgether/shared/widgets/common/section_divider.dart';

/// 코스마켓 메인 화면
///
/// 실시간 인기 코스를 표시하며
/// 검색 기능과 코스/장소 추가 기능을 제공
///
/// **기능:**
/// - 탭 재클릭 시 최상단 스크롤 + 새로고침
/// - Pull-to-Refresh 지원 (CupertinoSliverRefreshControl)
/// - 새로고침 진행 상태 시각화 (LinearProgressIndicator)
class CourseMarketScreen extends ConsumerStatefulWidget {
  const CourseMarketScreen({super.key});

  @override
  ConsumerState<CourseMarketScreen> createState() => _CourseMarketScreenState();
}

class _CourseMarketScreenState extends ConsumerState<CourseMarketScreen>
    with AutomaticKeepAliveClientMixin, RefreshableTabMixin {
  /// 프로그래밍 방식(탭 재클릭) 새로고침 진행 중 상태
  ///
  /// 탭을 재클릭하여 프로그래밍 방식으로 새로고침이 시작되면 true,
  /// 새로고침이 완료되면 false로 설정됩니다.
  /// 이 값에 따라 AppBar 하단에 LinearProgressIndicator를 표시합니다.
  bool _isProgrammaticRefreshing = false;

  // ============================================================================
  // RefreshableTabMixin 필수 구현
  // ============================================================================

  /// 현재 탭 인덱스 (코스마켓 = 1)
  ///
  /// 홈(0), 코스마켓(1), 지도(2), 일정(3), 마이페이지(4)
  @override
  int get tabIndex => 1;

  /// 탭 전환 시 위젯 상태 유지 여부
  ///
  /// true로 설정하면 다른 탭으로 이동했다가 돌아와도
  /// 스크롤 위치와 데이터가 유지됩니다.
  @override
  bool get wantKeepAlive => true;

  /// 데이터 새로고침 로직
  ///
  /// 탭 재클릭 또는 Pull-to-Refresh 시 호출됩니다.
  /// 실제 API 호출 또는 Provider 새로고침을 구현합니다.
  @override
  Future<void> onRefreshData() async {
    // TODO: 실제 API 연동 시 구현
    // 예시:
    // await ref.refresh(popularCoursesProvider.future);
    // await ref.refresh(nearbyCoursesProvider.future);

    // 현재는 더미 데이터를 사용하므로 1초 대기 (새로고침 시뮬레이션)
    await Future.delayed(const Duration(seconds: 1));

    // 참고: API 연동 전까지는 상태 변경이 없으므로 setState 호출 불필요
    // Provider 새로고침 시 자동으로 UI가 업데이트됩니다.
  }

  /// 프로그래밍 방식(탭 재클릭) 새로고침 상태 변경 콜백
  ///
  /// RefreshableTabMixin에서 탭 재클릭으로 새로고침을 시작하거나
  /// 완료할 때 호출됩니다.
  ///
  /// [isRefreshing] true: 새로고침 시작, false: 새로고침 완료
  @override
  void onRefreshStateChanged(bool isRefreshing) {
    if (mounted) {
      setState(() {
        _isProgrammaticRefreshing = isRefreshing;
      });
    }
  }

  // ============================================================================
  // Build Methods
  // ============================================================================

  @override
  Widget build(BuildContext context) {
    super.build(context); // AutomaticKeepAliveClientMixin 필수 호출
    // Provider 초기화를 위한 참조
    // RouteGuard가 인증 상태를 확인할 때 Provider가 이미 초기화되어 있어야 함
    ref.watch(userNotifierProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      // CustomScrollView + CupertinoSliverRefreshControl로 iOS 스타일 Pull-to-Refresh 구현
      // AppBar도 SliverAppBar로 변경하여 CustomScrollView에 통합
      body: _buildBody(),
    );
  }

  /// Body 빌드
  Widget _buildBody() {
    final l10n = AppLocalizations.of(context);

    return CustomScrollView(
      controller: scrollController, // RefreshableTabMixin에서 제공
      slivers: [
        // CupertinoSliverRefreshControl: iOS 스타일 Pull-to-Refresh
        // 콘텐츠를 실제로 밀어내며 공간을 생성하는 효과
        CupertinoSliverRefreshControl(
          onRefresh:
              onRefresh, // 탭 재클릭 시 또는 Pull-to-Refresh 시 데이터 새로고침 (최소 실행 시간 보장)
        ),

        // SliverAppBar: 화면 최상단에 고정된 AppBar
        // pinned: true - 스크롤해도 항상 화면 최상단에 고정
        // floating: false - 스크롤 동작 비활성화
        // snap: false - 스냅 효과 비활성화
        SliverAppBar(
          title: Text(
            l10n.courseMarket, // 다국어 지원 (한국어: "코스마켓", 영어: "Course Market")
            style: AppTextStyles.greetingBold20, // AppBar 제목용 스타일
          ),
          pinned: true, // 스크롤해도 항상 고정
          floating: false, // 스크롤 동작 비활성화
          snap: false, // 스냅 효과 비활성화
          backgroundColor: AppColors.white, // 항상 흰색
          foregroundColor: AppColors.textColor1, // 어두운 텍스트
          surfaceTintColor: Colors.transparent, // Material 3 색상 변경 방지
          leading: IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () {
              debugPrint('코스마켓 화면 메뉴 버튼 클릭');
            },
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.notifications_outlined),
              onPressed: () {
                debugPrint('코스마켓 화면 알림 버튼 클릭');
              },
            ),
          ],
          // 프로그래밍 방식(탭 재클릭) 새로고침 시 진행 표시
          // iOS/Android 공통으로 AppBar 하단에 얇은 진행 바 표시
          bottom: _isProgrammaticRefreshing
              ? PreferredSize(
                  preferredSize: Size.fromHeight(
                    AppSizes.progressIndicatorHeight,
                  ),
                  child: LinearProgressIndicator(
                    backgroundColor: Colors.transparent,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      AppColors.primary,
                    ),
                  ),
                )
              : null,
        ),

        // 그라데이션 배경 + 검색창 (Hero 애니메이션 적용)
        SliverToBoxAdapter(
          child: GradientBackground(
            // 코스마켓은 검색창만 있으므로 균등한 패딩 적용
            // AppSpacing.lg는 이미 ScreenUtil(.w)이 적용되어 있음
            padding: EdgeInsets.all(AppSpacing.lg),
            child: Hero(
              tag: 'course_search_bar', // Hero 애니메이션을 위한 고유 태그
              child: TripSearchBar(
                hintText: l10n.searchPlaceholder,
                readOnly: true,
                onTap: () {
                  // GoRouter로 검색 화면 이동 (Fade 애니메이션 자동 적용)
                  context.push(AppRoutes.courseMarketSearch);
                },
              ),
            ),
          ),
        ),

        // 콘텐츠 영역 (실시간 인기 코스 + 내 주변)
        SliverList(
          delegate: SliverChildListDelegate([
            SizedBox(height: AppSpacing.md),

            // 실시간 인기 코스 섹션
            _buildPopularCoursesSection(),

            // 섹션 구분선 (실시간 인기 코스 ↔ 내 주변)
            SizedBox(height: AppSpacing.huge),
            const SectionDivider.thick(),
            SizedBox(height: AppSpacing.xl),

            // 내 주변 섹션
            _buildNearbySection(),

            // 하단 여백 (스크롤 끝 시 여유 공간)
            SizedBox(height: AppSpacing.xl),
          ]),
        ),
      ],
    );
  }

  /// 실시간 인기 코스 섹션 빌드
  Widget _buildPopularCoursesSection() {
    // TODO: 실제 API 연동 시 Provider로 교체
    final popularCourses = _getDummyPopularCourses();

    return PopularCoursesSection(
      courses: popularCourses,
      onSeeMoreTap: () {
        // 실시간 인기 코스 더보기 페이지로 이동
        context.push(AppRoutes.popularCourses);
      },
      onCourseTap: (course) {
        debugPrint('인기 코스 선택: ${course.title}');
      },
    );
  }

  /// 내 주변 섹션 빌드
  Widget _buildNearbySection() {
    // TODO: 실제 위치 정보를 Provider에서 가져오기
    const currentLocation = '광진구 군자동';

    // TODO: 실제 API 연동 시 Provider로 교체
    final nearbyCourses = _getDummyNearbyCourses();

    return NearbySection(
      location: currentLocation,
      courses: nearbyCourses,
      onSeeMoreTap: () {
        debugPrint('내 주변 코스 더보기');
      },
      onCourseTap: (course) {
        debugPrint('내 주변 코스 선택: ${course.title}');
      },
    );
  }

  /// 더미 인기 코스 데이터
  List<PopularCourse> _getDummyPopularCourses() {
    return [
      const PopularCourse(
        id: '1',
        imageUrl: 'https://picsum.photos/seed/course1/400/600',
        title: '익선동 골목 데이트 산책코스',
        description: '비 오는 날이 설렘 추억 하나로 충분한',
      ),
      const PopularCourse(
        id: '2',
        imageUrl: 'https://picsum.photos/seed/course2/400/600',
        title: '을지로 빈티지 바잉 코스',
        description: '데님 편애자 아카이브 수집가의 추억',
      ),
      const PopularCourse(
        id: '3',
        imageUrl: 'https://picsum.photos/seed/course3/400/600',
        title: '서촌 감성 카페 미술관 코스',
        description: '소도시 같은 오래 머물고 싶은 동네',
      ),
    ];
  }

  /// 더미 내 주변 코스 데이터
  List<NearbyCourse> _getDummyNearbyCourses() {
    return [
      const NearbyCourse(
        id: '1',
        imageUrl: 'https://picsum.photos/seed/nearby1/200/200',
        title: '소담 한식당',
        categories: ['식당', '한식'],
      ),
      const NearbyCourse(
        id: '2',
        imageUrl: 'https://picsum.photos/seed/nearby2/200/200',
        title: '모던 감성 카페',
        categories: ['카페', '디저트'],
      ),
      const NearbyCourse(
        id: '3',
        imageUrl: 'https://picsum.photos/seed/nearby3/200/200',
        title: '아트 갤러리',
        categories: ['전시', '문화'],
      ),
      const NearbyCourse(
        id: '4',
        imageUrl: 'https://picsum.photos/seed/nearby4/200/200',
        title: '이탈리안 레스토랑',
        categories: ['식당', '양식'],
      ),
      const NearbyCourse(
        id: '5',
        imageUrl: 'https://picsum.photos/seed/nearby5/200/200',
        title: '북 카페',
        categories: ['카페', '도서'],
      ),
      const NearbyCourse(
        id: '6',
        imageUrl: 'https://picsum.photos/seed/nearby6/200/200',
        title: '브런치 맛집',
        categories: ['식당', '브런치'],
      ),
      const NearbyCourse(
        id: '7',
        imageUrl: 'https://picsum.photos/seed/nearby7/200/200',
        title: '플라워 카페',
        categories: ['카페', '기타'],
      ),
      const NearbyCourse(
        id: '8',
        imageUrl: 'https://picsum.photos/seed/nearby8/200/200',
        title: '매우매우매우매우 긴 제목을 가진 코스 이름 테스트용 매장',
        categories: ['카페', '전통차', '테스트'],
      ),
    ];
  }
}
