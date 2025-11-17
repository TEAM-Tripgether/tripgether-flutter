import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:tripgether/core/theme/app_colors.dart';
import '../../../../core/router/routes.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../shared/widgets/common/section_divider.dart';
import '../../../../shared/widgets/inputs/search_bar.dart';
import '../../../../shared/widgets/layout/collapsible_title_sliver_app_bar.dart';
import '../../../../shared/mixins/refreshable_tab_mixin.dart';
import '../../../debug/share_extension_log_screen.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../auth/providers/user_provider.dart';
import '../widgets/recent_sns_content_section.dart';
import '../widgets/recent_saved_places_section.dart';

/// 홈 화면 위젯
/// 앱의 메인 화면으로 최근 SNS 콘텐츠와 저장한 장소를 표시합니다.
class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen>
    with AutomaticKeepAliveClientMixin, RefreshableTabMixin {
  // ════════════════════════════════════════════════════════════════════════
  // RefreshableTabMixin 필수 구현
  // ════════════════════════════════════════════════════════════════════════

  @override
  int get tabIndex => 0; // 홈 탭 (인덱스 0)

  @override
  Future<void> onRefreshData() async {
    // 홈 화면 데이터 새로고침
    if (mounted) {
      setState(() {
        // 데이터 새로고침 로직
      });
    }
  }

  // ════════════════════════════════════════════════════════════════════════
  // AutomaticKeepAliveClientMixin 필수 구현
  // ════════════════════════════════════════════════════════════════════════

  @override
  bool get wantKeepAlive => true; // 탭 전환 시 상태 유지

  @override
  Widget build(BuildContext context) {
    super.build(context); // AutomaticKeepAliveClientMixin 필수 호출

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        // 빈 공간 클릭 시 키보드 포커스 해제
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: AppColors.white,
        body: CustomScrollView(
          controller: scrollController,
          slivers: [
            // SliverAppBar (스크롤 시 점진적 축소)
            Consumer(
              builder: (context, ref, child) {
                final l10n = AppLocalizations.of(context);
                final userAsync = ref.watch(userNotifierProvider);
                final nickname = userAsync.when(
                  loading: () => '사용자',
                  error: (error, _) => '사용자',
                  data: (user) => user?.nickname ?? '사용자',
                );

                return CollapsibleTitleSliverAppBar(
                  expandedHeight: 190.h,
                  toolbarHeight: AppSizes.appBarHeight,
                  backgroundColor: AppColors.backgroundLight,
                  centerTitle: false,
                  titleSpacing: AppSpacing.lg,

                  // 상단 고정 로고
                  title: SvgPicture.asset(
                    'assets/tripgether_text_logo.svg',
                    width: 66.w,
                    height: 24.h,
                    fit: BoxFit.contain,
                  ),

                  // 우측 알림 버튼
                  actions: [
                    Padding(
                      padding: EdgeInsets.only(right: AppSpacing.lg),
                      child: GestureDetector(
                        onTap: () => context.push(AppRoutes.notifications),
                        child: SvgPicture.asset(
                          'assets/icons/alarm_inactive.svg',
                          width: AppSizes.iconXLarge,
                          height: AppSizes.iconXLarge,
                        ),
                      ),
                    ),
                  ],

                  // 축소되는 인사말 영역
                  collapsibleContent: (expandRatio) => Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 상단 여백 (동적 축소)
                      SizedBox(
                        height: AppSpacing.huge + (AppSpacing.lg * expandRatio),
                      ),

                      // 인사말 (Opacity + Transform.scale 애니메이션)
                      Opacity(
                        opacity: expandRatio,
                        child: Transform.scale(
                          scale: 0.85 + (0.15 * expandRatio),
                          alignment: Alignment.topLeft,
                          child: Padding(
                            padding: EdgeInsets.only(
                              left: AppSpacing.lg + AppSpacing.sm,
                              bottom: AppSpacing.xs,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  l10n.greeting(nickname),
                                  style: AppTextStyles.greetingBold20.copyWith(
                                    color: AppColors.mainColor,
                                  ),
                                ),
                                Text(
                                  l10n.greetingSubtitle,
                                  style: AppTextStyles.greetingBold20.copyWith(
                                    color: AppColors.mainColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  // 하단 고정 검색바
                  bottom: PreferredSize(
                    preferredSize: Size.fromHeight(AppSizes.searchBarHeight),
                    child: Container(
                      color: AppColors.backgroundLight,
                      padding: EdgeInsets.only(
                        left: AppSpacing.lg,
                        right: AppSpacing.lg,
                        top: AppSpacing.xs,
                        bottom: AppSpacing.md,
                      ),
                      child: TripSearchBar(
                        hintText: l10n.searchHint,
                        readOnly: false,
                        onTap: () {
                          debugPrint('검색창 클릭 - 검색 화면으로 이동');
                        },
                        onChanged: (text) {
                          debugPrint('검색어 입력: $text');
                        },
                        onSubmitted: (text) {
                          debugPrint('검색 실행: $text');
                        },
                      ),
                    ),
                  ),
                );
              },
            ),

            // 새로고침 컨트롤
            CupertinoSliverRefreshControl(onRefresh: onRefresh),

            // 콘텐츠 영역
            SliverList(
              delegate: SliverChildListDelegate([
                // 최근 SNS에서 본 콘텐츠 섹션
                RecentSnsContentSection(),

                // 섹션 구분선
                const SectionDivider.thick(),

                // 최근 저장한 장소 섹션
                RecentSavedPlacesSection(),

                // 하단 여백
                AppSpacing.verticalSpaceXL,
              ]),
            ),
          ],
        ),
        // 디버그용 FloatingActionButton (Share Extension 로그 확인)
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const ShareExtensionLogScreen(),
              ),
            );
          },
          tooltip: 'Share Extension 로그',
          child: const Icon(Icons.bug_report),
        ),
      ),
    );
  }

  @override
  void dispose() {
    // RefreshableTabMixin이 자동으로 탭 콜백 해제 및 컨트롤러 정리 처리
    super.dispose();
  }
}
