import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:go_router/go_router.dart';
import 'package:tripgether/core/theme/app_spacing.dart';
import '../../../../shared/widgets/inputs/search_bar.dart';
import '../../../../shared/widgets/cards/course_card.dart';
import '../../data/models/course_model.dart';
import '../../../../core/router/routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../auth/providers/user_provider.dart';
import '../../../../shared/mixins/refreshable_tab_mixin.dart';

/// 코스마켓 메인 화면
///
/// 실시간 인기 코스와 내 주변 코스를 표시하며
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
  /// Expandable FAB 컨트롤러
  final _fabKey = GlobalKey<ExpandableFabState>();

  /// 인기 코스 더미 데이터
  final List<Course> _popularCourses = CourseDummyData.getPopularCourses();

  /// 내 주변 코스 더미 데이터
  final List<Course> _nearbyCourses = CourseDummyData.getNearbyCoursesById(
    placeId: 'current_location',
  );

  /// 좋아요한 코스 ID 목록 (임시 상태)
  final Set<String> _likedCourseIds = {};

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

    // UI 업데이트 (더미 데이터 재로드)
    if (mounted) {
      setState(() {
        // 데이터 재로드 로직 (현재는 더미 데이터이므로 실제 변경 없음)
      });
    }
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
      floatingActionButtonLocation: ExpandableFab.location,
      floatingActionButton: _buildExpandableFab(),
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

        // SliverAppBar: 스크롤과 함께 움직이는 AppBar
        // floating: true - 아래로 스크롤 시 즉시 나타남
        // snap: true - 완전히 나타나거나 사라지도록 스냅
        // pinned: false - 스크롤 시 완전히 사라짐
        SliverAppBar(
          title: Text(
            l10n.courseMarket, // 다국어 지원 (한국어: "코스마켓", 영어: "Course Market")
            style: AppTextStyles.titleLarge, // AppBar 제목용 스타일
          ),
          floating: true, // 스크롤 다운 시 즉시 나타남
          snap: true, // 스냅 효과 (완전히 나타나거나 사라짐)
          pinned: false, // 스크롤 시 완전히 사라짐
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
                  preferredSize: Size.fromHeight(2.h),
                  child: LinearProgressIndicator(
                    backgroundColor: Colors.transparent,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Theme.of(context).colorScheme.primary,
                    ),
                  ),
                )
              : null,
        ),

        // 검색창 (Hero 애니메이션 적용)
        SliverToBoxAdapter(
          child: Padding(
            padding: AppSpacing.symmetric(horizontal: 16, vertical: 12),
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

        // 실시간 인기 코스 섹션
        SliverToBoxAdapter(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppSpacing.verticalSpaceSM,
              CourseHorizontalList(
                title: l10n.popularCourses,
                courses: _popularCourses,
                onSeeMoreTap: () {
                  debugPrint('인기 코스 더보기');
                },
                onCourseTap: (course) {
                  debugPrint('코스 상세: ${course.title}');
                  // 코스 상세 화면으로 이동
                },
                onLikeTap: (course) {
                  setState(() {
                    if (_likedCourseIds.contains(course.id)) {
                      _likedCourseIds.remove(course.id);
                    } else {
                      _likedCourseIds.add(course.id);
                    }
                  });
                },
                isLiked: (course) => _likedCourseIds.contains(course.id),
              ),
            ],
          ),
        ),

        // 내 주변 코스 섹션
        SliverToBoxAdapter(
          child: Column(
            children: [
              AppSpacing.verticalSpaceXXL,
              CourseHorizontalList(
                title: l10n.nearbyCoursesWithLocation('광진구 군자동'),
                courses: _nearbyCourses,
                onSeeMoreTap: () {
                  debugPrint('내 주변 코스 더보기');
                },
                onCourseTap: (course) {
                  debugPrint('코스 상세: ${course.title}');
                  // 코스 상세 화면으로 이동
                },
                onLikeTap: (course) {
                  setState(() {
                    if (_likedCourseIds.contains(course.id)) {
                      _likedCourseIds.remove(course.id);
                    } else {
                      _likedCourseIds.add(course.id);
                    }
                  });
                },
                isLiked: (course) => _likedCourseIds.contains(course.id),
              ),
              AppSpacing.verticalSpaceXXL,
            ],
          ),
        ),
      ],
    );
  }

  /// Expandable FAB 빌드
  Widget _buildExpandableFab() {
    final l10n = AppLocalizations.of(context);

    return ExpandableFab(
      key: _fabKey,
      type: ExpandableFabType.up,
      distance: 70.w,
      childrenAnimation: ExpandableFabAnimation.none,
      overlayStyle: ExpandableFabOverlayStyle(
        blur: 5,
        color: AppColors.scrim.withValues(alpha: 0.5),
      ),
      openButtonBuilder: RotateFloatingActionButtonBuilder(
        child: Icon(Icons.add, size: 28.w),
        fabSize: ExpandableFabSize.regular,
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.onPrimary,
        shape: const CircleBorder(),
      ),
      closeButtonBuilder: DefaultFloatingActionButtonBuilder(
        child: Icon(Icons.close, size: 28.w),
        fabSize: ExpandableFabSize.regular,
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.onPrimary,
        shape: const CircleBorder(),
      ),
      children: [
        // 장소 추가 버튼
        Row(
          children: [
            // 레이블
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(8.r),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.shadow.withValues(alpha: 0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Text(l10n.addPlace, style: AppTextStyles.labelLarge),
            ),
            SizedBox(width: 12.w),
            // FAB 버튼
            FloatingActionButton.small(
              heroTag: 'add_place',
              backgroundColor: AppColors.surface,
              foregroundColor: AppColors.primary,
              onPressed: () {
                final state = _fabKey.currentState;
                if (state != null) {
                  state.toggle();
                }
                debugPrint('장소 추가 화면으로 이동');
                // 장소 추가 화면으로 이동
              },
              child: Icon(Icons.place, size: 24.w),
            ),
          ],
        ),

        // 코스 생성 버튼
        Row(
          children: [
            // 레이블
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(8.r),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.shadow.withValues(alpha: 0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Text(l10n.createCourse, style: AppTextStyles.labelLarge),
            ),
            SizedBox(width: 12.w),
            // FAB 버튼
            FloatingActionButton.small(
              heroTag: 'create_course',
              backgroundColor: AppColors.surface,
              foregroundColor: AppColors.primary,
              onPressed: () {
                final state = _fabKey.currentState;
                if (state != null) {
                  state.toggle();
                }
                debugPrint('코스 생성 화면으로 이동');
                // 코스 생성 화면으로 이동
              },
              child: Icon(Icons.map, size: 24.w),
            ),
          ],
        ),
      ],
    );
  }
}
