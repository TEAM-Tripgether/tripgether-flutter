import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tripgether/core/theme/app_colors.dart';
import 'package:tripgether/core/theme/app_spacing.dart';
import 'package:tripgether/core/theme/app_text_styles.dart';

/// 마이페이지 메뉴 아이템 위젯
///
/// **디자인 스펙**:
/// - 텍스트: textColor1 (#130537), bodyMedium16
/// - 기본 trailing: chevron_right 아이콘
///
/// **사용 예시**:
/// ```dart
/// MenuItem(
///   title: '프로필 관리',
///   onTap: () => context.push(AppRoutes.profile),
/// )
///
/// // 위험한 액션 (빨간색 텍스트)
/// MenuItem(
///   title: '회원 탈퇴',
///   titleColor: Colors.redAccent,
///   onTap: () => _showWithdrawDialog(),
/// )
/// ```
class MenuItem extends StatelessWidget {
  const MenuItem({
    super.key,
    required this.title,
    this.onTap,
    this.trailing,
    this.showChevron = true,
    this.titleColor,
  });

  /// 메뉴 항목 제목
  final String title;

  /// 클릭 시 실행되는 콜백
  final VoidCallback? onTap;

  /// 오른쪽에 표시되는 위젯 (기본: chevron 아이콘)
  final Widget? trailing;

  /// chevron 아이콘 표시 여부 (trailing이 없을 때만 적용)
  final bool showChevron;

  /// 제목 텍스트 색상 (기본: AppColors.textColor1)
  /// 위험한 액션(삭제, 탈퇴 등)에 Colors.redAccent 사용 권장
  final Color? titleColor;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8.r),
      child: Padding(
        padding: EdgeInsets.symmetric(
          vertical: AppSpacing.md,
          horizontal: AppSpacing.xs,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // 메뉴 제목 (기본: textColor1, bodyMedium16)
            Text(
              title,
              style: AppTextStyles.bodyMedium16.copyWith(
                color: titleColor ?? AppColors.textColor1,
              ),
            ),

            // 오른쪽 위젯 (trailing 또는 기본 chevron)
            trailing ??
                (showChevron
                    ? Icon(
                        Icons.chevron_right,
                        color: AppColors.subColor2,
                        size: AppSizes.iconDefault,
                      )
                    : const SizedBox.shrink()),
          ],
        ),
      ),
    );
  }
}
