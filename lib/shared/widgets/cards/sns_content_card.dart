import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shimmer/shimmer.dart';
import '../../../core/models/content_model.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/utils/platform_icon_mapper.dart';
import '../../../l10n/app_localizations.dart';

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

  /// 플랫폼 아이콘 크기 (기본값: AppSizes.iconSmall)
  final double? iconSize;

  /// 제목 텍스트 스타일 (기본값: AppTextStyles.metaMedium12 with white color)
  final TextStyle? titleStyle;

  /// 제목 최대 줄 수 (기본값: 2)
  final int? titleMaxLines;

  /// 텍스트 오버레이 표시 여부 (기본값: true)
  /// - true: 그라데이션 + 플랫폼 아이콘 + 제목 표시 (기존 동작)
  /// - false: 플랫폼 로고만 좌측 하단에 표시 (GridView용)
  final bool showTextOverlay;

  /// 플랫폼 로고 패딩 (showTextOverlay가 false일 때 적용)
  /// - 기본값: EdgeInsets.all(AppSpacing.sm) - 모든 방향 8px
  /// - 좌/우/상/하 각각 다른 간격 설정 가능
  ///
  /// 사용 예시:
  /// - EdgeInsets.all(AppSpacing.md) - 모든 방향 12px
  /// - EdgeInsets.only(left: 16, bottom: 16) - 좌/하단만 16px
  final EdgeInsets? logoPadding;

  /// 플랫폼 로고 아이콘 크기 (showTextOverlay가 false일 때 적용)
  /// - 기본값: AppSizes.iconSmall
  /// - iconSize와 독립적으로 작동 (showTextOverlay=true일 때는 iconSize 사용)
  final double? logoIconSize;

  const SnsContentCard({
    super.key,
    required this.content,
    this.width,
    this.height,
    this.onTap,
    this.iconSize,
    this.titleStyle,
    this.titleMaxLines,
    this.showTextOverlay = true, // 기본값: 기존 동작 유지
    this.logoPadding,
    this.logoIconSize,
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
            boxShadow: [
              BoxShadow(
                color: AppColors.shadow.withValues(alpha: 0.1),
                // color: AppColors.whiteBorder,
                spreadRadius: 1,
                blurRadius: 0,
                offset: Offset.zero,
              ),
            ],
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

                // 하단 그라데이션 오버레이 (showTextOverlay가 true일 때만)
                if (showTextOverlay) _buildGradientOverlay(),

                // 플랫폼 아이콘 + 제목 (또는 로고만)
                if (showTextOverlay)
                  _buildContentInfo(context)
                else
                  _buildPlatformLogoOnly(),
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
      baseColor: AppColors.subColor2.withValues(alpha: 0.3),
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
    return Positioned.fill(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.transparent, Colors.black.withValues(alpha: 0.7)],
            stops: const [0.5, 1.0],
          ),
        ),
      ),
    );
  }

  /// 콘텐츠 정보 (플랫폼 아이콘 + 제목)
  Widget _buildContentInfo(BuildContext context) {
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

            AppSpacing.verticalSpaceXSM,

            // 제목
            _buildTitle(context),
          ],
        ),
      ),
    );
  }

  /// 플랫폼 아이콘
  Widget _buildPlatformIcon() {
    final baseSize = iconSize ?? AppSizes.iconSmall;
    // YouTube 아이콘은 75% 크기로 축소
    final size = content.platform.toUpperCase() == 'YOUTUBE'
        ? baseSize * 0.75
        : baseSize;

    return SvgPicture.asset(
      PlatformIconMapper.getIconPath(content.platform),
      width: size,
      height: size,
    );
  }

  /// 제목 텍스트
  Widget _buildTitle(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final title = content.title ?? content.caption ?? l10n.noTitle;

    return Text(
      title,
      style:
          titleStyle ??
          AppTextStyles.metaMedium12.copyWith(color: Colors.white),
      maxLines: titleMaxLines ?? 2,
      overflow: TextOverflow.ellipsis,
    );
  }

  /// 플랫폼 로고만 표시 (텍스트 오버레이 없이)
  /// showTextOverlay가 false일 때 좌측 하단에 로고만 배치
  Widget _buildPlatformLogoOnly() {
    final baseSize = logoIconSize ?? AppSizes.iconSmall;
    // YouTube 아이콘은 75% 크기로 축소
    final size = content.platform.toUpperCase() == 'YOUTUBE'
        ? baseSize * 0.75
        : baseSize;
    final padding = logoPadding ?? EdgeInsets.all(AppSpacing.sm);

    return Positioned(
      left: padding.left,
      bottom: padding.bottom,
      child: SvgPicture.asset(
        PlatformIconMapper.getIconPath(content.platform),
        width: size,
        height: size,
      ),
    );
  }
}
