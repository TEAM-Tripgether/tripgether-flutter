import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tripgether/core/theme/app_colors.dart';
import 'package:tripgether/core/theme/app_spacing.dart';
import 'package:tripgether/core/theme/app_text_styles.dart';

/// 마이페이지 메뉴 섹션 컨테이너
///
/// **디자인 스펙**:
/// - 배경: backgroundLight (#F8F8F8)
/// - 모서리: radius 8
/// - 섹션 태그: subColor2 (#BBBBBB), titleSemiBold14
///
/// **사용 예시**:
/// ```dart
/// MenuSection(
///   tag: '내 정보',
///   children: [
///     MenuItem(title: '프로필 관리', onTap: () {}),
///     MenuItem(title: '활동 내역', onTap: () {}),
///   ],
/// )
/// ```
class MenuSection extends StatelessWidget {
  const MenuSection({super.key, required this.tag, required this.children});

  /// 섹션 상단에 표시되는 태그 텍스트
  /// 예: "내 정보", "알림 설정", "고객지원"
  final String tag;

  /// 섹션 내부에 들어갈 메뉴 아이템들
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      padding: EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.backgroundLight,
        borderRadius: AppRadius.allMedium,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 섹션 태그 (subColor2, titleSemiBold14)
          Text(
            tag,
            style: AppTextStyles.titleSemiBold14.copyWith(
              color: AppColors.subColor2,
            ),
          ),
          AppSpacing.verticalSpaceMD,
          // 구분선
          Divider(
            height: 1.h,
            thickness: AppSizes.dividerThin,
            color: AppColors.subColor2.withValues(alpha: 0.3),
          ),
          AppSpacing.verticalSpaceSM,
          // 메뉴 아이템들
          ...children,
        ],
      ),
    );
  }
}
