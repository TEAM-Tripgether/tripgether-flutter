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
                mainAxisSpacing: AppSpacing.sm, // 텍스트 영역을 고려한 간격 증가
                crossAxisSpacing: AppSpacing.sm,
                // childAspectRatio 조정: 카드 + 간격 + 텍스트 2줄
                // 0.60으로 설정하여 overflow 방지 (4.5픽셀 여유 확보)
                childAspectRatio: 0.60,
              ),
              itemCount: contents.length,
              itemBuilder: (context, index) {
                final content = contents[index];
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // SNS 콘텐츠 카드 (썸네일 + 플랫폼 로고만)
                    SnsContentCard(
                      content: content,
                      width: AppSizes.snsCardLargeWidth,
                      height: AppSizes.snsCardLargeHeight,
                      showTextOverlay: false, // 텍스트 오버레이 비활성화
                      logoPadding: EdgeInsets.all(AppSpacing.md), // 로고 패딩 12px
                      logoIconSize: AppSizes.iconDefault, // 플랫폼 로고 크기 32px
                      onTap: () {
                        // SNS 콘텐츠 상세 화면으로 이동 (ContentModel을 extra로 전달)
                        context.push(
                          '/home/sns-contents/detail/${content.contentId}',
                          extra: content,
                        );
                      },
                    ),

                    // 카드와 텍스트 사이 간격
                    AppSpacing.verticalSpaceXSM,

                    // 콘텐츠 메타데이터 (채널명 + 제목)
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
    );
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
          style: AppTextStyles.titleSemiBold14.copyWith(
            color: AppColors.textColor1,
          ),
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
