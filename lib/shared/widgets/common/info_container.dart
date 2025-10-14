import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/theme/app_spacing.dart';

/// 정보 표시용 컨테이너 위젯
///
/// 공유 데이터, 알림 메시지 등 다양한 정보를 일관된 스타일로 표시합니다.
/// 테마 색상과 간격을 활용하여 통일된 디자인을 제공합니다.
class InfoContainer extends StatelessWidget {
  /// 컨테이너 제목 (선택사항)
  final String? title;

  /// 제목 아이콘 (선택사항)
  final IconData? titleIcon;

  /// 제목 영역 trailing 위젯 (예: 로딩 인디케이터)
  final Widget? titleTrailing;

  /// 메인 콘텐츠 위젯
  final Widget child;

  /// 하단 액션 버튼들 (선택사항)
  final List<Widget>? actions;

  /// 컨테이너 배경색 (기본값: 파란색 계열)
  final Color? backgroundColor;

  /// 테두리 색상 (기본값: 파란색 계열)
  final Color? borderColor;

  /// 제목 색상 (기본값: 파란색 계열)
  final Color? titleColor;

  /// 아이콘 색상 (기본값: 파란색 계열)
  final Color? iconColor;

  /// 마진 (기본값: all 16)
  final EdgeInsetsGeometry? margin;

  /// 패딩 (기본값: all 16)
  final EdgeInsetsGeometry? padding;

  const InfoContainer({
    super.key,
    this.title,
    this.titleIcon,
    this.titleTrailing,
    required this.child,
    this.actions,
    this.backgroundColor,
    this.borderColor,
    this.titleColor,
    this.iconColor,
    this.margin,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    // 기본 색상 설정 (파란색 계열)
    final defaultBackgroundColor = Colors.blue.shade50;
    final defaultBorderColor = Colors.blue.shade200;
    final defaultTitleColor = Colors.blue.shade700;
    final defaultIconColor = Colors.blue.shade700;

    return Container(
      margin: margin ?? EdgeInsets.all(AppSpacing.lg),
      padding: padding ?? EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: backgroundColor ?? defaultBackgroundColor,
        borderRadius: AppRadius.allLarge,
        border: Border.all(color: borderColor ?? defaultBorderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // 제목 영역
          if (title != null) ...[
            Row(
              children: [
                if (titleIcon != null) ...[
                  Icon(
                    titleIcon,
                    color: iconColor ?? defaultIconColor,
                    size: 24.w,
                  ),
                  SizedBox(width: AppSpacing.xs),
                ],
                Text(
                  title!,
                  style: TextStyle(
                    fontFamily: 'Pretendard',
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: titleColor ?? defaultTitleColor,
                  ),
                ),
                const Spacer(),
                if (titleTrailing != null) titleTrailing!,
              ],
            ),
            SizedBox(height: AppSpacing.sm),
          ],

          // 메인 콘텐츠
          child,

          // 액션 버튼들
          if (actions != null && actions!.isNotEmpty) ...[
            SizedBox(height: AppSpacing.sm),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: actions!,
            ),
          ],
        ],
      ),
    );
  }
}

/// 성공 메시지용 InfoContainer
class SuccessInfoContainer extends StatelessWidget {
  final String? title;
  final Widget child;
  final List<Widget>? actions;

  const SuccessInfoContainer({
    super.key,
    this.title,
    required this.child,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return InfoContainer(
      title: title,
      titleIcon: Icons.check_circle_outline,
      backgroundColor: Colors.green.shade50,
      borderColor: Colors.green.shade200,
      titleColor: Colors.green.shade700,
      iconColor: Colors.green.shade700,
      actions: actions,
      child: child,
    );
  }
}

/// 경고 메시지용 InfoContainer
class WarningInfoContainer extends StatelessWidget {
  final String? title;
  final Widget child;
  final List<Widget>? actions;

  const WarningInfoContainer({
    super.key,
    this.title,
    required this.child,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return InfoContainer(
      title: title,
      titleIcon: Icons.warning_amber_outlined,
      backgroundColor: Colors.orange.shade50,
      borderColor: Colors.orange.shade200,
      titleColor: Colors.orange.shade700,
      iconColor: Colors.orange.shade700,
      actions: actions,
      child: child,
    );
  }
}

/// 에러 메시지용 InfoContainer
class ErrorInfoContainer extends StatelessWidget {
  final String? title;
  final Widget child;
  final List<Widget>? actions;

  const ErrorInfoContainer({
    super.key,
    this.title,
    required this.child,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return InfoContainer(
      title: title,
      titleIcon: Icons.error_outline,
      backgroundColor: Colors.red.shade50,
      borderColor: Colors.red.shade200,
      titleColor: Colors.red.shade700,
      iconColor: Colors.red.shade700,
      actions: actions,
      child: child,
    );
  }
}
