import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:go_router/go_router.dart';
import 'package:tripgether/core/theme/app_spacing.dart';
import '../../../../shared/widgets/inputs/search_bar.dart';
import '../../../../shared/widgets/cards/course_card.dart';
import '../../../../shared/widgets/common/common_app_bar.dart';
import '../../data/models/course_model.dart';
import '../../../../core/router/routes.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../auth/providers/user_provider.dart';

/// 코스마켓 메인 화면
///
/// 실시간 인기 코스와 내 주변 코스를 표시하며
/// 검색 기능과 코스/장소 추가 기능을 제공
class CourseMarketScreen extends ConsumerStatefulWidget {
  const CourseMarketScreen({super.key});

  @override
  ConsumerState<CourseMarketScreen> createState() => _CourseMarketScreenState();
}

class _CourseMarketScreenState extends ConsumerState<CourseMarketScreen> {
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

  @override
  Widget build(BuildContext context) {
    // Provider 초기화를 위한 참조
    // RouteGuard가 인증 상태를 확인할 때 Provider가 이미 초기화되어 있어야 함
    ref.watch(userNotifierProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      // CommonAppBar 사용으로 일관된 디자인 시스템 적용
      appBar: CommonAppBar.forHome(
        onMenuPressed: () {
          // 메뉴 열기
          debugPrint('메뉴 열기');
        },
        onNotificationPressed: () {
          // 알림 화면으로 이동
          debugPrint('알림 화면으로 이동');
        },
      ),
      body: _buildBody(),
      floatingActionButtonLocation: ExpandableFab.location,
      floatingActionButton: _buildExpandableFab(),
    );
  }

  /// Body 빌드
  Widget _buildBody() {
    final l10n = AppLocalizations.of(context);

    return CustomScrollView(
      slivers: [
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
              child: Text(
                l10n.addPlace,
                style: TextStyle(
                  fontFamily: 'Pretendard',
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.onSurface,
                ),
              ),
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
              child: Text(
                l10n.createCourse,
                style: TextStyle(
                  fontFamily: 'Pretendard',
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.onSurface,
                ),
              ),
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
