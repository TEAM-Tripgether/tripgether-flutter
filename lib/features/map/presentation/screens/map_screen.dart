import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../shared/widgets/common/common_app_bar.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../l10n/app_localizations.dart';

/// 지도 화면
///
/// 여행지 위치 정보를 지도로 확인할 수 있는 화면입니다.
/// 전체 화면을 지도가 차지하므로 미니멀한 AppBar를 사용합니다.
class MapScreen extends ConsumerWidget {
  const MapScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      // 지도 화면에 최적화된 커스텀 AppBar
      // 제목 없이 미니멀하게 구성하여 지도 공간을 극대화
      appBar: CommonAppBar(
        title: '', // 제목 없음으로 지도 공간 극대화
        backgroundColor: AppColors.surface.withValues(
          alpha: 0.95,
        ), // 반투명 배경으로 지도 일부가 보이도록
        elevation: 0, // 그림자 없음
        showMenuButton: true, // 햄버거 메뉴는 유지 (다른 화면 접근용)
        showNotificationIcon: false, // 알림 아이콘 제거로 공간 확보
        onMenuPressed: () {
          debugPrint("임시 디버그 메시지");
          // TODO: 사이드 메뉴 열기 또는 드로어 표시
        },
        rightActions: [
          // 내 위치로 이동 버튼
          IconButton(
            icon: Icon(
              Icons.my_location_outlined,
              size: 24.w,
              color: AppColors.subColor2.withValues(alpha: 0.7),
            ),
            onPressed: () {
              debugPrint("임시 디버그 메시지");
              // TODO: 현재 위치로 지도 중심 이동
            },
            tooltip: l10n.mapMyLocationTooltip,
          ),
          SizedBox(width: 8.w),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.map_outlined,
              size: 64.w,
              color: AppColors.subColor2.withValues(alpha: 0.6),
            ),
            AppSpacing.verticalSpaceLG,
            Text(
              l10n.navMap,
              style: AppTextStyles.summaryBold18.copyWith(
                color: AppColors.subColor2.withValues(alpha: 0.7),
              ),
            ),
            AppSpacing.verticalSpaceSM,
            Text(
              l10n.mapPlaceholder,
              style: AppTextStyles.bodyRegular14.copyWith(
                color: AppColors.subColor2.withValues(alpha: 0.5),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
