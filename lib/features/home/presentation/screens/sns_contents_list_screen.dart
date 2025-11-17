import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../core/models/content_model.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../shared/widgets/cards/sns_content_card.dart';
import '../../../../shared/widgets/common/common_app_bar.dart';
import '../../../../shared/widgets/common/empty_state.dart';
import '../../../../shared/widgets/common/chip_list.dart';
import '../providers/content_provider.dart';

/// SNS 콘텐츠 리스트 화면
///
/// 완료된 모든 SNS 콘텐츠를 그리드 레이아웃으로 표시합니다.
/// 홈 화면의 "최근 SNS에서 본 콘텐츠" 섹션에서 더보기 버튼을 통해 접근합니다.
/// 카테고리별 필터링 기능 포함 (전체/유튜브/인스타그램/틱톡)
class SnsContentsListScreen extends ConsumerStatefulWidget {
  const SnsContentsListScreen({super.key});

  @override
  ConsumerState<SnsContentsListScreen> createState() =>
      _SnsContentsListScreenState();
}

class _SnsContentsListScreenState extends ConsumerState<SnsContentsListScreen> {
  /// 선택된 카테고리 ('전체', 'YOUTUBE', 'INSTAGRAM', 'TIKTOK')
  String _selectedCategory = '전체';

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final contentListAsync = ref.watch(completedContentsProvider);

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: CommonAppBar.forSubPage(
        title: '', // 타이틀 제거
        rightActions: [
          // 편집 버튼
          IconButton(
            icon: const Icon(Icons.more_vert_rounded),
            onPressed: () {
              // TODO: 편집 모드 구현
              debugPrint('[SnsContentsListScreen] 편집 버튼 클릭');
            },
          ),
        ],
        backgroundColor: AppColors.white,
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 제목 섹션 (notification_screen 패턴)
            Padding(
              padding: EdgeInsets.only(
                left: AppSpacing.xxl,
                right: AppSpacing.xxl,
                bottom: AppSpacing.sm,
              ),
              child: Text(
                l10n.recentViewedContent,
                style: AppTextStyles.titleBold24.copyWith(
                  color: AppColors.textColor1,
                ),
              ),
            ),

            // 카테고리 필터 칩
            Padding(
              padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg),
              child: _buildCategoryChips(l10n),
            ),

            AppSpacing.verticalSpaceSM,

            // 콘텐츠 그리드
            Expanded(
              child: Container(
                color: AppColors.backgroundLight,
                child: contentListAsync.when(
                  data: (contents) {
                    // 카테고리 필터링
                    final filteredContents = _getFilteredContents(contents);

                    if (filteredContents.isEmpty) {
                      // 필터링 결과가 없을 때
                      return Center(
                        child: EmptyStates.noData(
                          title: _selectedCategory == '전체'
                              ? l10n.noSnsContentYet
                              : '해당 카테고리의 콘텐츠가 없습니다',
                          message: _selectedCategory == '전체'
                              ? l10n.noSnsContentMessage
                              : '다른 카테고리를 선택해보세요',
                        ),
                      );
                    }

                    // 콘텐츠 그리드 표시
                    return RefreshIndicator(
                      onRefresh: () async {
                        ref.invalidate(completedContentsProvider);
                      },
                      child: GridView.builder(
                        padding: EdgeInsets.all(AppSpacing.lg),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: AppSpacing.sm,
                          crossAxisSpacing: AppSpacing.sm,
                          childAspectRatio: 0.60,
                        ),
                        itemCount: filteredContents.length,
                        itemBuilder: (context, index) {
                          final content = filteredContents[index];
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // SNS 콘텐츠 카드
                              SnsContentCard(
                                content: content,
                                width: AppSizes.snsCardLargeWidth,
                                height: AppSizes.snsCardLargeHeight,
                                showTextOverlay: false,
                                logoPadding: EdgeInsets.all(AppSpacing.md),
                                logoIconSize: AppSizes.iconDefault,
                                onTap: () {
                                  context.push(
                                    '/home/sns-contents/detail/${content.contentId}',
                                    extra: content,
                                  );
                                },
                              ),

                              AppSpacing.verticalSpaceXSM,

                              // 콘텐츠 메타데이터
                              _buildContentMetadata(content),
                            ],
                          );
                        },
                      ),
                    );
                  },
                  loading: () => _buildLoadingShimmer(),
                  error: (error, stack) => Center(
                    child: EmptyStates.networkError(
                      title: l10n.cannotLoadContent,
                      message: l10n.networkError,
                      action: TextButton(
                        onPressed: () {
                          // Provider를 다시 로드하여 재시도
                          ref.invalidate(completedContentsProvider);
                        },
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
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 카테고리 필터 칩 리스트
  ///
  /// 전체/유튜브/인스타그램 카테고리 선택 칩
  /// - 활성 칩: mainColor 배경 + white 텍스트
  /// - 비활성 칩: subColor2.withAlpha(0.2) 배경 + textColor1.withAlpha(0.4) 텍스트
  Widget _buildCategoryChips(AppLocalizations l10n) {
    final categories = ['전체', '유튜브', '인스타그램'];

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
      textStyle: AppTextStyles.bodyMedium14, // 사용자 요구사항: medium14
      horizontalPadding: 0, // 이미 부모에서 padding 적용
      showBorder: false, // 외곽선 제거
      borderRadius: 100, // 완전한 pill 모양
      horizontalSpacing: AppSpacing.sm, // 칩 간격 8px
      chipPadding: EdgeInsets.symmetric(
        horizontal: AppSpacing.lg, // 16px (기본 8px에서 증가)
        vertical: AppSpacing.sm, // 8px (기본 4px에서 증가)
      ),
      unselectedTextColor: AppColors.textColor1.withValues(
        alpha: 0.4,
      ), // 비활성 칩 텍스트 투명도
    );
  }

  /// 카테고리별 콘텐츠 필터링
  ///
  /// - '전체': 모든 콘텐츠 반환
  /// - '유튜브': platform == 'YOUTUBE'
  /// - '인스타그램': platform == 'INSTAGRAM'
  List<ContentModel> _getFilteredContents(List<ContentModel> contents) {
    if (_selectedCategory == '전체') {
      return contents;
    }

    // 카테고리명을 플랫폼 enum으로 매핑
    final platformMap = {'유튜브': 'YOUTUBE', '인스타그램': 'INSTAGRAM'};

    final platform = platformMap[_selectedCategory];
    if (platform == null) {
      return contents;
    }

    return contents
        .where((content) => content.platform.toUpperCase() == platform)
        .toList();
  }

  /// 콘텐츠 메타데이터 (채널명 + 제목)
  ///
  /// 카드 아래에 표시되는 텍스트 정보:
  /// - Line 1: platformUploader (채널명) - metaMedium12 + subColor2
  /// - Line 2: title 또는 caption (제목) - titleSemiBold14 + textColor1
  Widget _buildContentMetadata(ContentModel content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 채널명 (platformUploader)
        Text(
          content.platformUploader ?? '채널 정보 없음',
          style: AppTextStyles.metaMedium12.copyWith(
            color: AppColors.subColor2,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),

        // 제목 (title 또는 caption)
        Text(
          content.title ?? content.caption ?? '제목 없음',
          style: AppTextStyles.titleSemiBold14,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  /// 로딩 중 Shimmer 효과
  Widget _buildLoadingShimmer() {
    return GridView.builder(
      padding: EdgeInsets.all(AppSpacing.lg),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: AppSpacing.sm,
        crossAxisSpacing: AppSpacing.sm,
        childAspectRatio:
            AppSizes.snsCardLargeWidth / AppSizes.snsCardLargeHeight,
      ),
      itemCount: 6, // 로딩 중 6개의 플레이스홀더 표시
      itemBuilder: (context, index) {
        return Container(
          width: AppSizes.snsCardLargeWidth,
          height: AppSizes.snsCardLargeHeight,
          decoration: BoxDecoration(
            borderRadius: AppRadius.allMedium,
            border: Border.all(
              color: AppColors.white.withValues(alpha: 0.5),
              width: AppSizes.borderThin,
            ),
          ),
          child: Padding(
            padding: EdgeInsets.all(AppSizes.borderThin),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(
                AppRadius.medium - AppSizes.borderThin,
              ),
              child: Shimmer.fromColors(
                baseColor: AppColors.subColor2.withValues(alpha: 0.3),
                highlightColor: AppColors.shimmerHighlight,
                child: Container(color: Colors.white),
              ),
            ),
          ),
        );
      },
    );
  }
}
