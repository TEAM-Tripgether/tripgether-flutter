import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../core/models/content_model.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/platform_icon_mapper.dart';
import '../../../../l10n/app_localizations.dart';
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

  const SnsContentDetailScreen({
    super.key,
    required this.content,
  });

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
            ],
          ),
        ),
      ),
    );
  }

  /// 썸네일 이미지 위젯 (Hero 애니메이션)
  Widget _buildThumbnail(ContentModel content) {
    return Hero(
      tag: 'sns-content-${content.contentId}',
      child: ClipRRect(
        borderRadius: AppRadius.allMedium,
        child: AspectRatio(
          aspectRatio: 16 / 9, // 썸네일 비율
          child: content.thumbnailUrl != null && content.thumbnailUrl!.isNotEmpty
              ? CachedNetworkImage(
                  imageUrl: content.thumbnailUrl!,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => _buildShimmerPlaceholder(),
                  errorWidget: (context, url, error) => _buildErrorPlaceholder(),
                )
              : _buildErrorPlaceholder(),
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

  /// 콘텐츠 정보 컨테이너 (플랫폼 아이콘 + 제목)
  Widget _buildContentInfo(BuildContext context, ContentModel content) {
    return Container(
      padding: EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.backgroundLight,
        borderRadius: AppRadius.allMedium,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 플랫폼 아이콘
          SvgPicture.asset(
            PlatformIconMapper.getIconPath(content.platform),
            width: AppSizes.iconMedium,
            height: AppSizes.iconMedium,
          ),

          SizedBox(width: 8.w),

          // 제목 및 설명 (추후 사용자가 수정 예정)
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 플랫폼 업로더 이름
                if (content.platformUploader != null)
                  Text(
                    content.platformUploader!,
                    style: AppTextStyles.contentTitle,
                  ),

                SizedBox(height: 4.h),

                // 제목
                Text(
                  content.title ?? '제목 없음',
                  style: AppTextStyles.summaryBold18,
                ),

                // TODO: 추가 정보 (캡션, AI 요약 등)는 사용자가 차차 추가 예정
              ],
            ),
          ),
        ],
      ),
    );
  }
}
