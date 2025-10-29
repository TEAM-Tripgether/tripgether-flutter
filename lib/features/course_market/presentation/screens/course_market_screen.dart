import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tripgether/core/router/routes.dart';
import 'package:tripgether/core/theme/app_colors.dart';
import 'package:tripgether/core/theme/app_spacing.dart';
import 'package:tripgether/core/theme/app_text_styles.dart';
import 'package:tripgether/features/auth/providers/user_provider.dart';
import 'package:tripgether/l10n/app_localizations.dart';
import 'package:tripgether/shared/mixins/refreshable_tab_mixin.dart';
import 'package:tripgether/shared/widgets/inputs/search_bar.dart';
import 'package:tripgether/shared/widgets/layout/gradient_background.dart';

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
            style: AppTextStyles.titleLarge, // AppBar 제목용 스타일
          ),
          pinned: true, // 스크롤해도 항상 고정
          floating: false, // 스크롤 동작 비활성화
          snap: false, // 스냅 효과 비활성화
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

        // TODO: 새로운 디자인으로 콘텐츠 영역 구현 예정
        // 현재는 빈 공간으로 유지 (디자인 작업 완료 후 실제 콘텐츠로 교체)
        const SliverFillRemaining(child: SizedBox.shrink()),
      ],
    );
  }
}
