import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/router/routes.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_colors.dart';

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
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        // 상단에만 그림자 효과 추가
        boxShadow: [
          BoxShadow(
            color: AppColors.textColor1.withValues(alpha: 0.1),
            spreadRadius: 1,
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        bottom: false, // 하단 SafeArea 패딩 제거 - 터치 영역을 화면 끝까지 확장
        child: SizedBox(
          height: AppSizes.navigationBarHeight, // SafeArea 내부에서 높이 제한
          child: Row(
            children: List.generate(
              AppRoutes.getTabLabels(context).length,
              (index) => Expanded(child: _buildNavItem(context, index)),
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

    return InkWell(
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
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center, // 중앙 정렬로 복원
        children: [
          // SVG 아이콘 표시
          _buildIcon(context, index, isSelected),

          AppSpacing.verticalSpaceXS,

          // 탭 라벨 텍스트
          _buildLabel(context, index, isSelected),
          AppSpacing.verticalSpaceLG,
        ],
      ),
    );
  }

  /// SVG 아이콘을 빌드하는 위젯
  ///
  /// [context] BuildContext - 테마 접근용
  /// [index] 탭 인덱스
  /// [isSelected] 선택 여부 (active/inactive 아이콘 결정)
  Widget _buildIcon(BuildContext context, int index, bool isSelected) {
    // 선택 상태에 따른 아이콘 경로 결정
    final String iconPath = isSelected
        ? NavigationIcons.getActiveIcon(index)
        : NavigationIcons.getInactiveIcon(index);

    return SvgPicture.asset(
      iconPath,
      width: AppSizes.iconDefault, // 반응형 아이콘 크기
      height: AppSizes.iconDefault.h,
      // SVG 파일 자체에 색상이 포함되어 있으므로 ColorFilter 사용 안 함
      // active: fill="#5325CB" (mainColor), inactive: stroke="#BBBBBB" (subColor2)
    );
  }

  /// 탭 라벨을 빌드하는 위젯 (국제화 적용)
  ///
  /// [context] BuildContext - 테마 접근 및 국제화용
  /// [index] 탭 인덱스
  /// [isSelected] 선택 여부 (텍스트 스타일 결정)
  Widget _buildLabel(BuildContext context, int index, bool isSelected) {
    return Text(
      AppRoutes.getTabLabels(context)[index],
      style: isSelected
          ? AppTextStyles.buttonSmallSemiBold10.copyWith(
              color: AppColors.mainColor, // 선택된 상태: SemiBold 10, mainColor
            )
          : AppTextStyles.buttonSmallMedium10.copyWith(
              color: AppColors.subColor2, // 비선택 상태: Medium 10, subColor2
            ),
      maxLines: 1, // 한 줄로 제한
      overflow: TextOverflow.ellipsis, // 텍스트가 길 경우 말줄임표 처리
    );
  }
}
