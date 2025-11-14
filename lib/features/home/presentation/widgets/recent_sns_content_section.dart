import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../core/router/routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../shared/widgets/cards/sns_content_card.dart';
import '../../../../shared/widgets/layout/section_header.dart';
import '../providers/content_provider.dart';

/// 최근 SNS에서 본 콘텐츠 섹션 위젯
///
/// 홈 화면에서 사용자가 최근에 본 SNS 콘텐츠를 표시하는 섹션입니다.
class RecentSnsContentSection extends ConsumerWidget {
  const RecentSnsContentSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final contentListAsync = ref.watch(completedContentsProvider);

    return Padding(
      padding: EdgeInsets.only(
        left: AppSpacing.lg,
        right: AppSpacing.md,
        top: AppSpacing.sm,
        bottom: AppSpacing.lg,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 섹션 타이틀
          SectionHeader(
            title: l10n.recentSnsContent,
            onMoreTap: () {
              // SNS 콘텐츠 리스트 화면으로 이동
              context.push(AppRoutes.snsContentsList);
            },
          ),

          // SNS 콘텐츠 리스트
          SizedBox(
            height: AppSizes.snsCardHeight,
            child: contentListAsync.when(
              data: (contents) {
                if (contents.isEmpty) {
                  // 콘텐츠가 없을 때 빈 상태 표시
                  return Center(
                    child: Text(
                      l10n.noSnsContentYet,
                      style: AppTextStyles.contentTitle.copyWith(
                        color: AppColors.subColor2,
                      ),
                    ),
                  );
                }

                // 콘텐츠 가로 스크롤 리스트
                return ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: contents.length,
                  itemBuilder: (context, index) {
                    final content = contents[index];
                    return Padding(
                      padding: EdgeInsets.only(
                        right: index < contents.length - 1 ? AppSpacing.sm : 0,
                      ),
                      child: SnsContentCard(
                        content: content,
                        onTap: () {
                          // SNS 콘텐츠 상세 화면으로 이동 (ContentModel을 extra로 전달)
                          context.push(
                            '/home/sns-contents/detail/${content.contentId}',
                            extra: content,
                          );
                        },
                      ),
                    );
                  },
                );
              },
              loading: () => _buildLoadingShimmer(),
              error: (error, stack) => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline,
                      color: AppColors.error,
                      size: AppSizes.iconLarge,
                    ),
                    AppSpacing.verticalSpaceXS,
                    Text(
                      l10n.cannotLoadContent,
                      style: AppTextStyles.caption12.copyWith(
                        color: AppColors.textColor1.withValues(alpha: 0.7),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 로딩 중 Shimmer 효과
  Widget _buildLoadingShimmer() {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: 3,
      padding: EdgeInsets.symmetric(horizontal: AppSpacing.xs),
      itemBuilder: (context, index) {
        return Padding(
          padding: EdgeInsets.only(right: index < 2 ? AppSpacing.md : 0),
          child: Container(
            width: AppSizes.snsCardWidth,
            height: AppSizes.snsCardHeight,
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
          ),
        );
      },
    );
  }
}
