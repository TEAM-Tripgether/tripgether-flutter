import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../core/models/place_model.dart';
import '../../../../core/router/routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../shared/mixins/refreshable_tab_mixin.dart';
import '../../../../shared/widgets/cards/place_detail_card.dart';
import '../../../../shared/widgets/common/empty_state.dart';
import '../../../../shared/widgets/common/chip_list.dart';
import '../providers/content_provider.dart';

/// 저장한 장소 리스트 화면
///
/// 사용자가 저장한 모든 장소를 리스트로 표시합니다.
/// 홈 화면의 "최근 저장한 장소" 섹션에서 더보기 버튼을 통해 접근합니다.
/// 카테고리별 필터링 기능 포함 (전체/카페/음식점/관광지 등)
///
/// **레이아웃 구조**:
/// - SliverAppBar: 스크롤 시 제목 축소
/// - CupertinoSliverRefreshControl: 새로고침
/// - SliverList: 장소 목록
class SavedPlacesListScreen extends ConsumerStatefulWidget {
  const SavedPlacesListScreen({super.key});

  @override
  ConsumerState<SavedPlacesListScreen> createState() =>
      _SavedPlacesListScreenState();
}

class _SavedPlacesListScreenState extends ConsumerState<SavedPlacesListScreen>
    with AutomaticKeepAliveClientMixin, RefreshableTabMixin {
  /// 선택된 카테고리 ('전체', '카페', '음식점', '관광지')
  String _selectedCategory = '전체';

  // ════════════════════════════════════════════════════════════════════════
  // RefreshableTabMixin 필수 구현
  // ════════════════════════════════════════════════════════════════════════

  @override
  int get tabIndex => -1; // 독립 화면 (탭이 아님)

  @override
  bool get wantKeepAlive => false; // 탭이 아니므로 상태 유지 불필요

  @override
  bool get enableAutoRefresh => false; // 탭 재클릭 새로고침 비활성화

  @override
  Future<void> onRefreshData() async {
    // Riverpod provider 새로고침
    ref.invalidate(recentSavedPlacesProvider);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // AutomaticKeepAliveClientMixin 필수 호출

    final l10n = AppLocalizations.of(context);
    final placesAsync = ref.watch(recentSavedPlacesProvider);

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: CustomScrollView(
        controller: scrollController, // RefreshableTabMixin에서 제공
        physics: const AlwaysScrollableScrollPhysics(
          parent: BouncingScrollPhysics(),
        ),
        slivers: [
          // SliverAppBar (제목 축소 효과)
          _buildSliverAppBar(l10n),

          // CupertinoSliverRefreshControl (새로고침)
          CupertinoSliverRefreshControl(
            onRefresh: onRefresh, // RefreshableTabMixin의 onRefresh 사용
          ),

          // SliverList (장소 목록)
          _buildSliverContent(placesAsync, l10n),
        ],
      ),
    );
  }

  /// SliverAppBar 구현
  ///
  /// **구조**:
  /// - Leading: 뒤로가기 버튼
  /// - Title: "저장한 장소" (스크롤 시 표시)
  /// - collapsibleContent: 제목 (스크롤 시 축소)
  /// - Bottom: 카테고리 칩 (전체, 카페, 음식점, 관광지)
  Widget _buildSliverAppBar(AppLocalizations l10n) {
    return SliverAppBar(
      pinned: true,
      expandedHeight: 140.h,
      backgroundColor: AppColors.white,
      elevation: 0,
      surfaceTintColor: Colors.transparent,

      // 뒤로가기 버튼
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new_rounded),
        onPressed: () => Navigator.of(context).pop(),
      ),

      // 축소 시 표시될 타이틀 (동적 opacity)
      title: Builder(
        builder: (context) {
          final settings = context
              .dependOnInheritedWidgetOfExactType<FlexibleSpaceBarSettings>();
          final currentExtent = settings?.currentExtent ?? 140.h;
          final minExtent = settings?.minExtent ?? kToolbarHeight;
          final maxExtent = settings?.maxExtent ?? 140.h;

          // expandRatio 계산 (0.0 = 축소, 1.0 = 확장)
          final expandRatio =
              ((currentExtent - minExtent) / (maxExtent - minExtent)).clamp(
                0.0,
                1.0,
              );

          return Opacity(
            opacity: 1.0 - expandRatio, // 확장 시 숨김, 축소 시 표시
            child: Text(l10n.recentSavedPlaces),
          );
        },
      ),

      // FlexibleSpaceBar: 축소되는 제목 영역
      flexibleSpace: FlexibleSpaceBar(
        collapseMode: CollapseMode.parallax,
        titlePadding: EdgeInsets.zero,
        background: Builder(
          builder: (context) {
            final settings = context
                .dependOnInheritedWidgetOfExactType<FlexibleSpaceBarSettings>();
            final currentExtent = settings?.currentExtent ?? 140.h;
            final minExtent = settings?.minExtent ?? kToolbarHeight;
            final maxExtent = settings?.maxExtent ?? 140.h;

            final expandRatio =
                ((currentExtent - minExtent) / (maxExtent - minExtent)).clamp(
                  0.0,
                  1.0,
                );

            return SafeArea(
              bottom: false,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 상단 여백
                  SizedBox(height: AppSpacing.huge + AppSpacing.md),

                  // "저장한 장소" 제목 (점진적 축소)
                  Opacity(
                    opacity: expandRatio,
                    child: Transform.scale(
                      scale: 0.85 + (0.15 * expandRatio),
                      alignment: Alignment.topLeft,
                      child: Padding(
                        padding: EdgeInsets.only(
                          left: AppSpacing.xxl,
                          right: AppSpacing.xxl,
                          bottom: AppSpacing.sm,
                        ),
                        child: Text(
                          l10n.recentSavedPlaces,
                          style: AppTextStyles.titleBold24.copyWith(
                            color: AppColors.textColor1,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),

      // 하단 고정 카테고리 칩
      bottom: PreferredSize(
        preferredSize: Size.fromHeight(52.h),
        child: Container(
          color: AppColors.white,
          alignment: Alignment.centerLeft,
          padding: EdgeInsets.only(
            left: AppSpacing.lg,
            right: AppSpacing.lg,
            bottom: AppSpacing.sm,
          ),
          child: _buildCategoryChips(l10n),
        ),
      ),
    );
  }

  /// SliverList 콘텐츠 구현
  ///
  /// **상태별 처리**:
  /// - data: SliverList 표시 (필터링 적용)
  /// - loading: SliverToBoxAdapter + Shimmer
  /// - error: SliverFillRemaining + 에러 메시지
  Widget _buildSliverContent(
    AsyncValue<List<PlaceModel>> placesAsync,
    AppLocalizations l10n,
  ) {
    return placesAsync.when(
      data: (places) {
        final filteredPlaces = _getFilteredPlaces(places);

        if (filteredPlaces.isEmpty) {
          // 빈 상태 표시
          return SliverFillRemaining(
            child: Center(
              child: EmptyStates.noData(
                title: _selectedCategory == '전체'
                    ? l10n.noSavedPlacesYet
                    : '해당 카테고리에 저장된 장소가 없습니다',
                message: _selectedCategory == '전체'
                    ? '콘텐츠에서 마음에 드는 장소를 저장해보세요'
                    : '다른 카테고리를 선택해보세요',
              ),
            ),
          );
        }

        // SliverList 표시
        return SliverPadding(
          padding: EdgeInsets.all(AppSpacing.lg),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate((context, index) {
              final place = filteredPlaces[index];
              return Padding(
                padding: EdgeInsets.only(bottom: AppSpacing.sm),
                child: PlaceDetailCard(
                  category: place.category ?? '장소',
                  placeName: place.name,
                  address: place.address,
                  rating: place.rating ?? 0.0,
                  reviewCount: place.userRatingsTotal ?? 0,
                  imageUrls: place.photoUrls,
                  backgroundColor: AppColors.white,
                  onTap: () {
                    // 장소 상세 화면으로 이동
                    context.push(
                      AppRoutes.placeDetail.replaceAll(
                        ':placeId',
                        place.placeId,
                      ),
                    );
                  },
                ),
              );
            }, childCount: filteredPlaces.length),
          ),
        );
      },
      loading: () => SliverToBoxAdapter(child: _buildLoadingShimmer()),
      error: (error, stack) => SliverFillRemaining(
        child: Center(
          child: EmptyStates.networkError(
            title: '장소를 불러올 수 없습니다',
            message: l10n.networkError,
            action: TextButton(
              onPressed: () => ref.invalidate(recentSavedPlacesProvider),
              child: Text(
                l10n.retry,
                style: AppTextStyles.buttonMediumMedium14.copyWith(
                  color: AppColors.mainColor,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// 카테고리 필터 칩 리스트
  ///
  /// 전체/카페/음식점/관광지 카테고리 선택 칩
  Widget _buildCategoryChips(AppLocalizations l10n) {
    final categories = ['전체', '카페', '음식점', '관광지', '숙소'];

    return SelectableChipList(
      items: categories,
      selectedItems: {_selectedCategory},
      onSelectionChanged: (selected) {
        if (selected.isNotEmpty) {
          setState(() {
            _selectedCategory = selected.first;
          });
        }
      },
      singleSelection: true,
      textStyle: AppTextStyles.bodyMedium14,
      horizontalPadding: 0,
      showBorder: false,
      borderRadius: 100,
      horizontalSpacing: AppSpacing.sm,
      chipPadding: EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.sm,
      ),
      unselectedTextColor: AppColors.textColor1.withValues(alpha: 0.4),
    );
  }

  /// 카테고리별 장소 필터링
  ///
  /// - '전체': 모든 장소 반환
  /// - 그 외: category 필드 매칭
  List<PlaceModel> _getFilteredPlaces(List<PlaceModel> places) {
    if (_selectedCategory == '전체') {
      return places;
    }

    return places
        .where((place) => place.category == _selectedCategory)
        .toList();
  }

  /// 로딩 중 Shimmer 효과
  Widget _buildLoadingShimmer() {
    return ListView.builder(
      padding: EdgeInsets.all(AppSpacing.lg),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 5, // 로딩 중 5개의 플레이스홀더 표시
      itemBuilder: (context, index) {
        return Padding(
          padding: EdgeInsets.only(bottom: AppSpacing.sm),
          child: Container(
            height: 120.h,
            decoration: BoxDecoration(
              borderRadius: AppRadius.allMedium,
              border: Border.all(
                color: AppColors.white.withValues(alpha: 0.5),
                width: AppSizes.borderThin,
              ),
            ),
            child: Shimmer.fromColors(
              baseColor: AppColors.subColor2.withValues(alpha: 0.3),
              highlightColor: AppColors.shimmerHighlight,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: AppRadius.allMedium,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
