import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../l10n/app_localizations.dart';

/// 최근 SNS에서 본 콘텐츠 섹션 위젯
///
/// 홈 화면에서 사용자가 최근에 본 SNS 콘텐츠를 표시하는 섹션입니다.
class RecentSnsContentSection extends StatelessWidget {
  const RecentSnsContentSection({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Padding(
      padding: EdgeInsets.only(
        left: AppSpacing.xxl,
        right: AppSpacing.md,
        top: AppSpacing.sm,
        bottom: AppSpacing.lg,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 섹션 타이틀
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                l10n.recentSnsContent,
                style: AppTextStyles.sectionTitle.copyWith(
                  color: AppColors.textColor1,
                ),
              ),
              IconButton(
                onPressed: () {
                  debugPrint('최근 저장한 장소 리스트 화면으로 이동');
                },
                icon: Icon(
                  Icons.chevron_right_rounded,
                  color: AppColors.subColor2,
                  size: AppSizes.iconLarge,
                ),
              ),
            ],
          ),

          AppSpacing.verticalSpaceMD,

          // SNS 콘텐츠 리스트 (추후 구현)
          // TODO: 실제 콘텐츠 데이터 연동 시 Provider와 연결
          SizedBox(
            height: 150.h,
            child: Center(
              child: Text(
                l10n.noSnsContentYet,
                style: AppTextStyles.contentTitle.copyWith(
                  color: AppColors.subColor2,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
