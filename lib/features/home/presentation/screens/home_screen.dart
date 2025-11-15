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
                  error: (_, __) => '사용자',
                  data: (user) => user?.nickname ?? '사용자',
                );

                return SliverAppBar(
                  expandedHeight: 190.h, // 전체 확장 높이
                  // collapsedHeight: 116.h, // 축소 시 높이 (로고 + 검색바만, 여백 최소화)
                  pinned: true, // 스크롤 시에도 최소 높이 유지
                  backgroundColor: AppColors.backgroundLight,
                  elevation: 0,
                  surfaceTintColor: Colors.transparent,
                  automaticallyImplyLeading: false, // 뒤로가기 버튼 제거
                  toolbarHeight: 56.h,
                  centerTitle: false, // 로고를 왼쪽으로 정렬
                  // 항상 보이는 로고 + 알림
                  title: SvgPicture.asset(
                    'assets/tripgether_text_logo.svg',
                    width: 66.w,
                    height: 24.h,
                    fit: BoxFit.contain,
                  ),
                  titleSpacing: AppSpacing.lg, // 로고 왼쪽 간격
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

                  // LayoutBuilder로 스크롤 정도에 따라 점진적 축소
                  flexibleSpace: LayoutBuilder(
                    builder: (context, constraints) {
                      // 현재 AppBar 높이
                      final currentHeight = constraints.biggest.height;

                      // 최소 높이 (툴바 + 검색바)
                      final minHeight = 56.h + 52.h;

                      // 확장 비율 계산 (0.0 = 완전 축소, 1.0 = 완전 확장)
                      final expandRatio =
                          ((currentHeight - minHeight) / (210.h - minHeight))
                              .clamp(0.0, 1.0);

                      return FlexibleSpaceBar(
                        background: SafeArea(
                          bottom: false,
                          child: Column(
                            mainAxisSize: MainAxisSize.min, // 최소 크기로 축소
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // 상단 여백 (로고 + 알림 영역) - 동적 축소
                              SizedBox(height: 50.h + (10.h * expandRatio)),

                              // 인사말 + 부제목 (점진적으로 축소되며 사라짐)
                              Opacity(
                                opacity: expandRatio,
                                child: Transform.scale(
                                  scale:
                                      0.85 + (0.15 * expandRatio), // 0.85 ~ 1.0
                                  alignment: Alignment.topLeft,
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                      left: AppSpacing.lg + AppSpacing.sm,
                                      bottom: 4.h, // 검색바와의 간격
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          l10n.greeting(nickname),
                                          style: AppTextStyles.greetingBold20
                                              .copyWith(
                                                color: AppColors.mainColor,
                                              ),
                                        ),
                                        Text(
                                          l10n.greetingSubtitle,
                                          style: AppTextStyles.greetingBold20
                                              .copyWith(
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
                        ),
                      );
                    },
                  ),

                  // 항상 보이는 검색바
                  bottom: PreferredSize(
                    preferredSize: Size.fromHeight(52.h),
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
