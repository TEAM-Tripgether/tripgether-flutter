import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/router/routes.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';

/// PRD.md 구조에 따른 공유 바텀 네비게이션 바 위젯
///
/// shared/widgets/layout 폴더에 위치하며,
/// SVG 아이콘을 사용하여 바텀 네비게이션을 구성합니다.
/// 여러 feature에서 공통으로 사용되는 레이아웃 컴포넌트입니다.
class CustomBottomNavigationBar extends StatelessWidget {
  /// 현재 선택된 탭의 인덱스
  final int currentIndex;

  /// 탭 선택 시 호출되는 콜백 함수
  final ValueChanged<int> onTap;

  /// 탭 재선택(재클릭) 시 호출되는 콜백 함수
  ///
  /// 현재 활성화된 탭을 다시 클릭했을 때 실행됩니다.
  /// 주로 스크롤을 최상단으로 올리거나 새로고침하는 용도로 사용됩니다.
  final ValueChanged<int>? onTabReselected;

  const CustomBottomNavigationBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    this.onTabReselected,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      // 바텀 네비게이션 바의 전체 높이 (반응형)
      height: AppSizes.navigationBarHeight,
      decoration: BoxDecoration(
        color: colorScheme.surface,
        // 상단에만 그림자 효과 추가
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha: 0.1),
            spreadRadius: 1,
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(top: AppSpacing.sm.h), // 상단에 추가 패딩 적용
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(
              AppRoutes.getTabLabels(context).length,
              (index) => _buildNavItem(context, index),
            ),
          ),
        ),
      ),
    );
  }

  /// 개별 네비게이션 아이템을 구성하는 위젯
  ///
  /// [context] BuildContext - 테마 접근용
  /// [index] 탭의 인덱스 (0: 홈, 1: 코스마켓, 2: 지도, 3: 일정, 4: 마이페이지)
  Widget _buildNavItem(BuildContext context, int index) {
    // 현재 탭이 선택되어 있는지 확인
    final bool isSelected = currentIndex == index;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          // 현재 선택된 탭을 다시 클릭한 경우
          if (currentIndex == index) {
            onTabReselected?.call(index);
          } else {
            // 다른 탭을 선택한 경우
            onTap(index);
          }
        },
        borderRadius: BorderRadius.circular(16.r),
        child: SizedBox(
          width: AppSizes.fabSize, // 각 탭의 최소 너비 보장
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // SVG 아이콘 표시
              _buildIcon(context, index, isSelected),

              SizedBox(height: AppSpacing.xs.h),

              // 탭 라벨 텍스트
              _buildLabel(context, index, isSelected),
            ],
          ),
        ),
      ),
    );
  }

  /// SVG 아이콘을 빌드하는 위젯
  ///
  /// [context] BuildContext - 테마 접근용
  /// [index] 탭 인덱스
  /// [isSelected] 선택 여부 (active/inactive 아이콘 결정)
  Widget _buildIcon(BuildContext context, int index, bool isSelected) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // 선택 상태에 따른 아이콘 경로 결정
    final String iconPath = isSelected
        ? NavigationIcons.getActiveIcon(index)
        : NavigationIcons.getInactiveIcon(index);

    return SvgPicture.asset(
      iconPath,
      width: AppSizes.iconDefault, // 반응형 아이콘 크기
      height: AppSizes.iconDefault.h,
      // SVG 색상 필터링 (필요한 경우)
      colorFilter: isSelected
          ? ColorFilter.mode(
              theme.primaryColor, // 선택된 상태 - 테마의 기본 색상
              BlendMode.srcIn,
            )
          : ColorFilter.mode(
              colorScheme.onSurfaceVariant, // 비선택 상태 - 보조 색상
              BlendMode.srcIn,
            ),
    );
  }

  /// 탭 라벨을 빌드하는 위젯 (국제화 적용)
  ///
  /// [context] BuildContext - 테마 접근 및 국제화용
  /// [index] 탭 인덱스
  /// [isSelected] 선택 여부 (텍스트 스타일 결정)
  Widget _buildLabel(BuildContext context, int index, bool isSelected) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Text(
      AppRoutes.getTabLabels(context)[index],
      style: AppTextStyles.labelSmall.copyWith(
        fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
        color: isSelected
            ? theme
                  .primaryColor // 선택된 상태 색상
            : colorScheme.onSurfaceVariant, // 비선택 상태 색상
      ),
      maxLines: 1, // 한 줄로 제한
      overflow: TextOverflow.ellipsis, // 텍스트가 길 경우 말줄임표 처리
    );
  }
}
