import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shimmer/shimmer.dart';
import '../../../core/models/content_model.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/utils/platform_icon_mapper.dart';

/// SNS 콘텐츠 카드 위젯
///
/// Instagram, YouTube, TikTok 등의 SNS 콘텐츠를 카드 형태로 표시합니다.
/// 썸네일, 플랫폼 아이콘, 제목을 Stack 레이아웃으로 보여줍니다.
///
/// 사용 예시:
/// ```dart
/// SnsContentCard(
///   content: contentModel,
///   onTap: () => navigateToDetail(contentModel.contentId),
/// )
/// ```
class SnsContentCard extends StatelessWidget {
  /// 표시할 콘텐츠 모델
  final ContentModel content;

  /// 카드 너비 (기본값: AppSizes.snsCardWidth = 100)
  final double? width;

  /// 카드 높이 (기본값: AppSizes.snsCardHeight = 142)
  final double? height;

  /// 카드 클릭 시 콜백
  final VoidCallback? onTap;

  const SnsContentCard({
    super.key,
    required this.content,
    this.width,
    this.height,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cardWidth = width ?? AppSizes.snsCardWidth;
    final cardHeight = height ?? AppSizes.snsCardHeight;

    return GestureDetector(
      onTap: onTap,
      child: Hero(
        tag: 'sns-content-${content.contentId}',
        child: Container(
          width: cardWidth,
          height: cardHeight,
          decoration: BoxDecoration(
            borderRadius: AppRadius.allMedium,
            border: Border.all(
              color: AppColors.whiteBorder,
              width: AppSizes.borderThin,
            ),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(
              AppRadius.medium - AppSizes.borderThin,
            ),
            child: Stack(
              fit: StackFit.expand,
              children: [
                // 배경 썸네일 이미지
                _buildThumbnail(),

                // 하단 그라데이션 오버레이
                _buildGradientOverlay(),

                // 플랫폼 아이콘 + 제목 (그라데이션 위)
                _buildContentInfo(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// 썸네일 이미지 위젯
  Widget _buildThumbnail() {
    if (content.thumbnailUrl == null || content.thumbnailUrl!.isEmpty) {
      return _buildPlaceholder();
    }

    return CachedNetworkImage(
      imageUrl: content.thumbnailUrl!,
      fit: BoxFit.cover,
      placeholder: (context, url) => _buildShimmerPlaceholder(),
      errorWidget: (context, url, error) => _buildPlaceholder(),
    );
  }

  /// 썸네일 로딩 중 Shimmer 효과
  Widget _buildShimmerPlaceholder() {
    return Shimmer.fromColors(
      baseColor: AppColors.shimmerBase,
      highlightColor: AppColors.shimmerHighlight,
      child: Container(color: Colors.white),
    );
  }

  /// 썸네일이 없을 때 기본 플레이스홀더
  Widget _buildPlaceholder() {
    return Container(
      color: AppColors.backgroundLight,
      child: Center(
        child: Icon(
          Icons.image_outlined,
          size: AppSizes.iconLarge,
          color: AppColors.subColor2,
        ),
      ),
    );
  }

  /// 하단 그라데이션 오버레이 (배경 어둡게)
  Widget _buildGradientOverlay() {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: Container(
        height: AppSizes.snsCardOverlayHeight,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.transparent, Colors.black.withValues(alpha: 0.7)],
          ),
        ),
      ),
    );
  }

  /// 콘텐츠 정보 (플랫폼 아이콘 + 제목)
  Widget _buildContentInfo() {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: Padding(
        padding: EdgeInsets.all(AppSpacing.sm),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 플랫폼 아이콘
            _buildPlatformIcon(),

            AppSpacing.verticalSpaceXS,

            // 제목
            _buildTitle(),
          ],
        ),
      ),
    );
  }

  /// 플랫폼 아이콘
  Widget _buildPlatformIcon() {
    return SvgPicture.asset(
      PlatformIconMapper.getIconPath(content.platform),
      width: AppSizes.iconSmall,
      height: AppSizes.iconSmall,
    );
  }

  /// 제목 텍스트
  Widget _buildTitle() {
    final title = content.title ?? content.caption ?? '제목 없음';

    return Text(
      title,
      style: AppTextStyles.metaMedium12.copyWith(color: Colors.white),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }
}
