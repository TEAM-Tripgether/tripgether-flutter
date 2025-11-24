import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';

/// 장소 기본 정보 헤더
///
/// - 카테고리 뱃지 (선택 사항)
/// - 장소 이름 (titleBold24)
/// - 설명 (bodyRegular14, 2줄 ellipsis)
///
/// 재사용 가능: PlaceDetailScreen, PlacePreviewCard 등
class PlaceInfoHeader extends StatelessWidget {
  /// 카테고리 (예: "카페", "음식점", "해변")
  final String? category;

  /// 장소 이름
  final String name;

  /// 장소 설명 (선택 사항, 2줄 제한)
  final String? description;

  const PlaceInfoHeader({
    super.key,
    this.category,
    required this.name,
    this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: AppSpacing.sm), // 8px 왼쪽 들여쓰기
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 카테고리 뱃지
          if (category != null) ...[
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: AppSpacing.sm,
                vertical: AppSpacing.xxs,
              ),
              decoration: BoxDecoration(
                color: AppColors.subColor2.withValues(alpha: 0.2),
                borderRadius: AppRadius.allSmall,
              ),
              child: Text(
                category!,
                style: AppTextStyles.metaMedium12.copyWith(
                  color: AppColors.textColor1.withValues(alpha: 0.4),
                ),
              ),
            ),
            AppSpacing.verticalSpaceXS, // 카테고리 → 이름 간격: 4px
          ],

          // 장소 이름
          Text(
            name,
            style: AppTextStyles.greetingBold20,
          ),

          // 설명
          if (description != null && description!.isNotEmpty) ...[
            AppSpacing.verticalSpaceXS, // 이름 → 설명 간격: 4px
            Text(
              description!,
              style: AppTextStyles.bodyMedium15.copyWith(
                color: AppColors.textColor1.withValues(alpha: 0.7),
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ],
      ),
    );
  }
}
