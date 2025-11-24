import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';

/// 장소 상세 정보 섹션
///
/// - 주소 (location_on 아이콘 + 텍스트)
/// - 전화번호 (phone 아이콘 + 텍스트, 탭 가능)
/// - 별점 (star 아이콘 + 평점 + 리뷰 수)
///
/// 재사용 가능: PlaceDetailScreen, PlaceCard 등
class PlaceInfoSection extends StatelessWidget {
  /// 주소
  final String address;

  /// 전화번호 (선택 사항)
  final String? phone;

  /// 별점 (선택 사항)
  final double? rating;

  /// 리뷰 수 (선택 사항)
  final int? reviewCount;

  /// 전화번호 탭 콜백 (선택 사항)
  final VoidCallback? onPhoneTap;

  /// 주소 탭 콜백 (선택 사항)
  final VoidCallback? onAddressTap;

  const PlaceInfoSection({
    super.key,
    required this.address,
    this.phone,
    this.rating,
    this.reviewCount,
    this.onPhoneTap,
    this.onAddressTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 주소
        _InfoRow(
          icon: SvgPicture.asset(
            'assets/icons/location_on.svg',
            width: AppSizes.iconSmall,
            height: AppSizes.iconSmall,
            colorFilter: ColorFilter.mode(
              AppColors.mainColor,
              BlendMode.srcIn,
            ),
          ),
          text: address,
          onTap: onAddressTap,
        ),

        // 전화번호
        if (phone != null) ...[
          SizedBox(height: AppSpacing.sm),
          _InfoRow(
            icon: Icon(
              Icons.phone_outlined,
              size: AppSizes.iconSmall,
              color: AppColors.mainColor,
            ),
            text: phone!,
            onTap: onPhoneTap,
          ),
        ],

        // 별점
        if (rating != null) ...[
          SizedBox(height: AppSpacing.sm),
          Row(
            children: [
              SvgPicture.asset(
                'assets/icons/star.svg',
                width: AppSizes.iconSmall,
                height: AppSizes.iconSmall,
                colorFilter: ColorFilter.mode(
                  AppColors.mainColor,
                  BlendMode.srcIn,
                ),
              ),
              SizedBox(width: AppSpacing.xs),
              Text(
                '$rating ${reviewCount != null ? '($reviewCount)' : ''}',
                style: AppTextStyles.bodyMedium13.copyWith(
                  color: AppColors.textColor1.withValues(alpha: 0.6),
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }
}

/// 정보 행 위젯 (아이콘 + 텍스트)
class _InfoRow extends StatelessWidget {
  final Widget icon;
  final String text;
  final VoidCallback? onTap;

  const _InfoRow({
    required this.icon,
    required this.text,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final content = Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        icon,
        SizedBox(width: AppSpacing.xs),
        Expanded(
          child: Text(
            text,
            style: AppTextStyles.bodyMedium13.copyWith(
              color: AppColors.textColor1.withValues(alpha: 0.6),
            ),
          ),
        ),
      ],
    );

    if (onTap != null) {
      return InkWell(
        onTap: onTap,
        borderRadius: AppRadius.allSmall,
        child: content,
      );
    }

    return content;
  }
}
