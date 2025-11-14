import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/models/content_model.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/platform_icon_mapper.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../shared/widgets/buttons/common_button.dart';
import '../../../../shared/widgets/common/common_app_bar.dart';

/// SNS 콘텐츠 상세 화면
///
/// SnsContentCard 클릭 시 이동하는 상세 페이지입니다.
/// Hero 애니메이션으로 부드러운 전환을 제공하며,
/// 썸네일, 플랫폼 정보, 제목, 설명 등을 표시합니다.
///
/// 사용 예시:
/// ```dart
/// context.push('/home/sns-contents/detail/${content.contentId}');
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
        child: Padding(
          padding: EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 썸네일 이미지 (Hero 애니메이션)
              _buildThumbnail(content),

              AppSpacing.verticalSpaceLG,

              // 플랫폼 정보 + 제목 컨테이너
              _buildContentInfo(context, content),

              AppSpacing.verticalSpaceSM,

              // 설명 텍스트
            ],
          ),
        ),
      ),
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
      baseColor: AppColors.shimmerBase,
      highlightColor: AppColors.shimmerHighlight,
      child: Container(color: Colors.white),
    );
  }

  /// 에러 플레이스홀더
  Widget _buildErrorPlaceholder() {
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
            PlatformIconMapper.getIconPath(content.platform),
            width: AppSizes.iconMedium,
            height: AppSizes.iconMedium,
          ),

          AppSpacing.horizontalSpaceSM,

          // 업로더명 또는 제목 (한 줄)
          Expanded(
            child: Text(
              content.platformUploader ?? content.title ?? l10n.noTitle,
              style: AppTextStyles.contentTitle,
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
      _showErrorSnackBar(context, '링크 정보가 없습니다.');
      return;
    }

    try {
      final uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        if (!context.mounted) return;
        _showErrorSnackBar(context, '링크를 열 수 없습니다.');
      }
    } catch (e) {
      if (!context.mounted) return;
      _showErrorSnackBar(context, '링크 열기에 실패했습니다.');
    }
  }

  /// 에러 메시지 SnackBar 표시
  void _showErrorSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), duration: const Duration(seconds: 2)),
    );
  }
}
