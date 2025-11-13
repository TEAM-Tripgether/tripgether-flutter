import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../shared/widgets/layout/section_header.dart';

/// 최근 저장한 장소 섹션 위젯
///
/// 홈 화면에서 사용자가 최근에 저장한 장소를 표시하는 섹션입니다.
class RecentSavedPlacesSection extends StatelessWidget {
  const RecentSavedPlacesSection({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

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
            title: l10n.recentSavedPlaces,
            onMoreTap: () {
              debugPrint('최근 저장한 장소 리스트 화면으로 이동');
            },
          ),

          AppSpacing.verticalSpaceMD,

          // 저장한 장소 리스트
          // 실제 데이터 연동 시 PlaceModel 리스트와 연결 예정
          SizedBox(
            height: 150.h,
            child: Center(
              child: Text(
                l10n.noSavedPlacesYet,
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
