import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../shared/widgets/cards/sns_content_card.dart';
import '../../../../shared/widgets/common/common_app_bar.dart';
import '../../../../shared/widgets/common/empty_state.dart';
import '../providers/content_provider.dart';

/// SNS 콘텐츠 리스트 화면
///
/// 완료된 모든 SNS 콘텐츠를 그리드 레이아웃으로 표시합니다.
/// 홈 화면의 "최근 SNS에서 본 콘텐츠" 섹션에서 더보기 버튼을 통해 접근합니다.
class SnsContentsListScreen extends ConsumerWidget {
  const SnsContentsListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final contentListAsync = ref.watch(completedContentsProvider);

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: CommonAppBar.forSubPage(
        title: l10n.recentSnsContent,
        rightActions: [], // 알림 아이콘 숨김
      ),
      body: contentListAsync.when(
        data: (contents) {
          if (contents.isEmpty) {
            // 콘텐츠가 없을 때 빈 상태 표시
            return EmptyStates.noData(
              title: l10n.noSnsContentYet,
              message: l10n.noSnsContentMessage,
            );
          }

          // 콘텐츠 그리드 표시
          return RefreshIndicator(
            onRefresh: () async {
              // Provider를 다시 로드하여 최신 데이터 가져오기
              ref.invalidate(completedContentsProvider);
            },
            child: GridView.builder(
              padding: EdgeInsets.all(AppSpacing.lg),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: AppSpacing.sm,
                crossAxisSpacing: AppSpacing.sm,
                childAspectRatio:
                    AppSizes.snsCardLargeWidth / AppSizes.snsCardLargeHeight,
              ),
              itemCount: contents.length,
              itemBuilder: (context, index) {
                final content = contents[index];
                return SnsContentCard(
                  content: content,
                  width: AppSizes.snsCardLargeWidth,
                  height: AppSizes.snsCardLargeHeight,
                  iconSize: AppSizes.iconLarge,
                  titleStyle: AppTextStyles.summaryBold18.copyWith(
                    color: Colors.white,
                  ),
                  onTap: () {
                    // SNS 콘텐츠 상세 화면으로 이동 (ContentModel을 extra로 전달)
                    context.push(
                      '/home/sns-contents/detail/${content.contentId}',
                      extra: content,
                    );
                  },
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
                  color: AppColors.primary,
                ),
              ),
            ),
          ),
        ),
      ),
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
              color: AppColors.whiteBorder,
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
                baseColor: AppColors.shimmerBase,
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
