import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tripgether/l10n/app_localizations.dart';
import 'package:tripgether/core/theme/app_colors.dart';
import 'package:tripgether/core/theme/app_text_styles.dart';
import 'package:tripgether/core/theme/app_spacing.dart';

/// 실시간 인기 코스 더보기 화면
///
/// 코스마켓 > 실시간 인기 코스 섹션의 "더보기"를 탭했을 때 표시되는 화면
///
/// **TODO**:
/// - 인기 코스 전체 리스트 표시
/// - 필터링 및 정렬 기능
/// - 무한 스크롤 또는 페이지네이션
class PopularCoursesScreen extends ConsumerWidget {
  const PopularCoursesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(l10n.popularCourses),
        titleTextStyle: AppTextStyles.titleLarge,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.construction,
              size: 64.r,
              color: AppColors.textSecondary,
            ),
            AppSpacing.verticalSpaceLG,
            Text(
              l10n.comingSoon,
              style: AppTextStyles.bodyLarge.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
