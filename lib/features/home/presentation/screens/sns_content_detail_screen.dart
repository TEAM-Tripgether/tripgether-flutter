import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';
import 'package:tripgether/shared/widgets/common/section_divider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/models/content_model.dart';
import '../../../../core/router/routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/platform_icon_mapper.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../shared/widgets/buttons/common_button.dart';
import '../../../../shared/widgets/cards/place_detail_card.dart';
import '../../../../shared/widgets/common/common_app_bar.dart';
import '../../../../shared/widgets/common/app_snackbar.dart';
import '../../../../shared/widgets/layout/section_header.dart';

/// SNS 콘텐츠 상세 화면
///
/// SnsContentCard 클릭 시 이동하는 상세 페이지입니다.
/// Hero 애니메이션으로 부드러운 전환을 제공하며,
/// 썸네일, 플랫폼 정보, 제목, 설명 등을 표시합니다.
///
/// 사용 예시:
/// ```dart
/// context.push(
///   AppRoutes.snsContentDetail.replaceAll(':contentId', content.contentId),
///   extra: content,
/// );
/// ```
class SnsContentDetailScreen extends StatelessWidget {
  /// 표시할 콘텐츠 모델
  final ContentModel content;

  const SnsContentDetailScreen({super.key, required this.content});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      // 뒤로가기 버튼만 있는 AppBar (알림 아이콘 숨김)
      appBar: CommonAppBar.forSubPage(
        title: content.title ?? l10n.snsContentDetail,
        rightActions: [], // 알림 아이콘 숨김
      ),
      backgroundColor: AppColors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 썸네일 이미지 (Hero 애니메이션) - 좌우 패딩 포함
            Padding(
              padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg),
              child: _buildThumbnail(content),
            ),

            AppSpacing.verticalSpaceLG,

            // 플랫폼 정보 + 제목 컨테이너 - 좌우 패딩 포함
            Padding(
              padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg),
              child: _buildContentInfo(context, content),
            ),

            AppSpacing.verticalSpaceSM,

            // AI 콘텐츠 요약 섹션 - 좌우 패딩 포함
            Padding(
              padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg),
              child: _buildContentDescription(context, content),
            ),

            AppSpacing.verticalSpaceLG,

            // Divider - 패딩 없음 (화면 전체 너비)
            const SectionDivider.thick(),

            // 링크에 포함된 장소 - 좌우 패딩 포함
            if (content.places.isNotEmpty)
              Padding(
                padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                child: _buildPlacesSection(context, content),
              ),
          ],
        ),
      ),
    );
  }

  /// 링크에 포함된 장소 섹션
  Widget _buildPlacesSection(BuildContext context, ContentModel content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppSpacing.verticalSpaceLG,

        // 섹션 헤더
        SectionHeader(title: '링크에 포함된 장소', showMoreButton: false),

        AppSpacing.verticalSpaceMD,

        // 장소 카드 리스트
        ...content.places.map((place) {
          return Padding(
            padding: EdgeInsets.only(bottom: AppSpacing.md),
            child: PlaceDetailCard(
              category: place.category ?? '장소',
              placeName: place.name,
              address: place.address,
              rating: place.rating ?? 0.0,
              reviewCount: place.userRatingsTotal ?? 0,
              imageUrls: place.photoUrls,
              onTap: () {
                // 장소 상세 화면으로 이동 (:placeId 파라미터 치환)
                // PlaceModel 객체를 extra로 전달하여 저장되지 않은 장소도 조회 가능하게 함
                context.push(
                  AppRoutes.placeDetail.replaceAll(
                    ':placeId',
                    place.placeId,
                  ),
                  extra: place,
                );
              },
            ),
          );
        }),
      ],
    );
  }

  /// 썸네일 이미지 위젯 (Hero 애니메이션 + 그림자)
  Widget _buildThumbnail(ContentModel content) {
    return Hero(
      tag: 'sns-content-${content.contentId}',
      child: Container(
        decoration: BoxDecoration(
          borderRadius: AppRadius.allMedium,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 10,
              // offset: const Offset(0, 2),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: AppRadius.allMedium,
          child: AspectRatio(
            aspectRatio: 16 / 9, // 썸네일 비율
            child:
                content.thumbnailUrl != null && content.thumbnailUrl!.isNotEmpty
                ? CachedNetworkImage(
                    imageUrl: content.thumbnailUrl!,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => _buildShimmerPlaceholder(),
                    errorWidget: (context, url, error) =>
                        _buildErrorPlaceholder(),
                  )
                : _buildErrorPlaceholder(),
          ),
        ),
      ),
    );
  }

  /// Shimmer 로딩 플레이스홀더
  Widget _buildShimmerPlaceholder() {
    return Shimmer.fromColors(
      baseColor: AppColors.subColor2.withValues(alpha: 0.3),
      highlightColor: AppColors.shimmerHighlight,
      child: Container(color: Colors.white),
    );
  }

  /// 에러 플레이스홀더
  Widget _buildErrorPlaceholder() {
    return Container(
      color: AppColors.imagePlaceholder,
      child: Center(
        child: Icon(
          Icons.image_outlined,
          size: AppSizes.iconLarge,
          color: AppColors.white,
        ),
      ),
    );
  }

  /// AI 콘텐츠 요약 섹션
  Widget _buildContentDescription(BuildContext context, ContentModel content) {
    return Container(
      width: double.infinity, // 전체 너비 차지
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.md,
      ),
      decoration: BoxDecoration(
        color: AppColors.backgroundLight,
        borderRadius: AppRadius.allMedium,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // AI 아이콘 + "AI 콘텐츠 요약" 헤더
          Container(
            padding: EdgeInsets.all(AppSpacing.smd),
            decoration: BoxDecoration(
              color: AppColors.subColor2.withValues(alpha: 0.2),
              borderRadius: AppRadius.allSmall,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SvgPicture.asset(
                  'assets/icons/Ai.svg',
                  width: AppSizes.iconSmall, // 16
                  height: AppSizes.iconSmall,
                ),
                AppSpacing.horizontalSpaceXS, // 4

                Text(
                  'AI 콘텐츠 요약',
                  style: AppTextStyles.metaMedium12.copyWith(
                    color: AppColors.textColor1.withValues(alpha: 0.5),
                  ),
                ),
              ],
            ),
          ),

          AppSpacing.verticalSpaceSMD, // 10
          // 제목 텍스트 (title 또는 caption의 첫 줄)
          if (content.title != null && content.title!.isNotEmpty)
            Text(
              content.title!,
              style: AppTextStyles.summaryBold16.copyWith(
                color: AppColors.mainColor,
              ),
            ),

          // title이 있을 경우에만 간격 추가
          if (content.title != null && content.title!.isNotEmpty)
            AppSpacing.verticalSpaceSMD, // 10
          // 본문 설명 텍스트 (summary 또는 caption)
          Text(
            content.summary ?? content.caption ?? '콘텐츠 요약이 없습니다.',
            style: AppTextStyles.bodyRegular14,
          ),
        ],
      ),
    );
  }

  /// 콘텐츠 정보 컨테이너 (플랫폼 아이콘 + 업로더명 + 링크 버튼)
  Widget _buildContentInfo(BuildContext context, ContentModel content) {
    final l10n = AppLocalizations.of(context);

    return Container(
      padding: EdgeInsets.only(
        left: AppSpacing.lg,
        right: AppSpacing.sm,
        bottom: AppSpacing.sm,
        top: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: AppColors.backgroundLight,
        borderRadius: AppRadius.allMedium,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // 플랫폼 아이콘
          SvgPicture.asset(
            PlatformIconMapper.getIconPath(content.platform ?? 'INSTAGRAM'),
            width: AppSizes.iconMedium,
            height: AppSizes.iconMedium,
          ),

          AppSpacing.horizontalSpaceSM,

          // 업로더명 또는 제목 (한 줄)
          Expanded(
            child: Text(
              content.platformUploader ?? content.title ?? l10n.noTitle,
              style: AppTextStyles.titleSemiBold14,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),

          AppSpacing.horizontalSpaceMD,

          // "링크 바로가기" 버튼
          LinkButton(
            text: '링크 바로가기',
            onPressed: () => _launchUrl(context, content.originalUrl),
          ),
        ],
      ),
    );
  }

  /// 원본 콘텐츠 URL 열기
  Future<void> _launchUrl(BuildContext context, String? url) async {
    if (url == null || url.isEmpty) {
      if (!context.mounted) return;
      AppSnackBar.showError(
        context,
        '링크 정보가 없습니다.',
        duration: const Duration(seconds: 2),
      );
      return;
    }

    try {
      final uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        if (!context.mounted) return;
        AppSnackBar.showError(
          context,
          '링크를 열 수 없습니다.',
          duration: const Duration(seconds: 2),
        );
      }
    } catch (e) {
      if (!context.mounted) return;
      AppSnackBar.showError(
        context,
        '링크 열기에 실패했습니다.',
        duration: const Duration(seconds: 2),
      );
    }
  }
}
