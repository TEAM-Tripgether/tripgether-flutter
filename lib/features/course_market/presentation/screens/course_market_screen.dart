import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import '../../../../shared/widgets/inputs/search_bar.dart';
import '../../../../shared/widgets/cards/course_card.dart';
import '../../data/models/course_model.dart';
import 'course_search_screen.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../l10n/app_localizations.dart';

/// 코스마켓 메인 화면
///
/// 실시간 인기 코스와 내 주변 코스를 표시하며
/// 검색 기능과 코스/장소 추가 기능을 제공
class CourseMarketScreen extends StatefulWidget {
  const CourseMarketScreen({super.key});

  @override
  State<CourseMarketScreen> createState() => _CourseMarketScreenState();
}

class _CourseMarketScreenState extends State<CourseMarketScreen> {
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
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: _buildAppBar(),
      body: _buildBody(),
      floatingActionButtonLocation: ExpandableFab.location,
      floatingActionButton: _buildExpandableFab(),
    );
  }

  /// AppBar 빌드
  PreferredSizeWidget _buildAppBar() {
    final l10n = AppLocalizations.of(context);

    return AppBar(
      backgroundColor: AppColors.background,
      elevation: 0,
      centerTitle: true,
      title: Text(
        l10n.appTitle,
        style: TextStyle(
          fontFamily: 'Pretendard',
          fontSize: 20.sp,
          fontWeight: FontWeight.w700,
          color: AppColors.onSurface,
        ),
      ),
      leading: IconButton(
        icon: Icon(Icons.menu, color: AppColors.onSurface),
        onPressed: () {
          // 메뉴 열기
          debugPrint('메뉴 열기');
        },
      ),
      actions: [
        IconButton(
          icon: Icon(Icons.notifications_outlined, color: AppColors.onSurface),
          onPressed: () {
            // 알림 화면으로 이동
            debugPrint('알림 화면으로 이동');
          },
        ),
      ],
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
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            child: Hero(
              tag: 'course_search_bar', // Hero 애니메이션을 위한 고유 태그
              child: TripSearchBar(
                hintText: l10n.searchPlaceholder,
                readOnly: true,
                onTap: () {
                  // 검색 화면으로 이동 (커스텀 페이지 라우트로 부드러운 전환)
                  Navigator.push(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (context, animation, secondaryAnimation) =>
                          const CourseSearchScreen(),
                      transitionsBuilder:
                          (context, animation, secondaryAnimation, child) {
                            // 페이드 인 애니메이션 (Hero 애니메이션과 조화)
                            return FadeTransition(
                              opacity: animation,
                              child: child,
                            );
                          },
                      transitionDuration: const Duration(
                        milliseconds: 300,
                      ), // 전환 시간
                    ),
                  );
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
              SizedBox(height: 8.h),
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
              SizedBox(height: 24.h),
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
              SizedBox(height: 24.h),
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
