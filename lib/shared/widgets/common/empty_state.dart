import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';

/// 빈 상태 표시 위젯
///
/// 검색 결과가 없거나, 리스트가 비어있거나, 데이터를 불러오지 못했을 때
/// 사용자에게 안내 메시지와 함께 표시하는 위젯
///
/// 사용 예시:
/// ```dart
/// EmptyState(
///   icon: Icons.search_off,
///   title: '검색 결과가 없습니다',
///   message: '다른 키워드로 검색해보세요',
/// )
/// ```
class EmptyState extends StatelessWidget {
  /// 표시할 아이콘
  final IconData icon;

  /// 아이콘 크기 (기본값: 64.w)
  final double? iconSize;

  /// 아이콘 색상 (기본값: AppColors.neutral70)
  final Color? iconColor;

  /// 주요 메시지 (제목)
  final String title;

  /// 제목 텍스트 스타일 (null이면 기본 스타일 사용)
  final TextStyle? titleStyle;

  /// 부가 설명 메시지 (선택)
  final String? message;

  /// 메시지 텍스트 스타일 (null이면 기본 스타일 사용)
  final TextStyle? messageStyle;

  /// 액션 버튼 (선택)
  /// 예: "다시 시도" 버튼, "홈으로 가기" 버튼 등
  final Widget? action;

  /// 제목과 메시지 사이 간격 (기본값: 8.h)
  final double? titleMessageSpacing;

  /// 메시지와 액션 사이 간격 (기본값: 24.h)
  final double? messageActionSpacing;

  const EmptyState({
    super.key,
    required this.icon,
    required this.title,
    this.iconSize,
    this.iconColor,
    this.titleStyle,
    this.message,
    this.messageStyle,
    this.action,
    this.titleMessageSpacing,
    this.messageActionSpacing,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    // 기본 제목 스타일
    final effectiveTitleStyle =
        titleStyle ??
        textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.w600,
          color: AppColors.neutral50,
        );

    // 기본 메시지 스타일
    final effectiveMessageStyle =
        messageStyle ??
        textTheme.bodyMedium?.copyWith(
          fontWeight: FontWeight.w400,
          color: AppColors.neutral60,
        );

    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: AppSpacing.xxl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            // 아이콘
            Icon(
              icon,
              size: iconSize ?? 64.w,
              color: iconColor ?? AppColors.neutral70,
            ),

            SizedBox(height: AppSpacing.lg.h),

            // 제목
            Text(
              title,
              style: effectiveTitleStyle,
              textAlign: TextAlign.center,
            ),

            // 메시지 (있는 경우)
            if (message != null) ...[
              SizedBox(height: titleMessageSpacing ?? AppSpacing.xs.h),
              Text(
                message!,
                style: effectiveMessageStyle,
                textAlign: TextAlign.center,
              ),
            ],

            // 액션 버튼 (있는 경우)
            if (action != null) ...[
              SizedBox(height: messageActionSpacing ?? AppSpacing.xxl.h),
              action!,
            ],
          ],
        ),
      ),
    );
  }
}

/// 미리 정의된 빈 상태 위젯 팩토리
///
/// 자주 사용하는 빈 상태 패턴을 간편하게 생성
class EmptyStates {
  /// 검색 결과 없음
  static Widget noSearchResults({
    required String title,
    required String message,
    Widget? action,
  }) {
    return EmptyState(
      icon: Icons.search_off,
      title: title,
      message: message,
      action: action,
    );
  }

  /// 데이터 없음 (일반)
  static Widget noData({
    required String title,
    String? message,
    Widget? action,
  }) {
    return EmptyState(
      icon: Icons.inbox_outlined,
      title: title,
      message: message,
      action: action,
    );
  }

  /// 네트워크 오류
  static Widget networkError({
    required String title,
    String? message,
    Widget? action,
  }) {
    return EmptyState(
      icon: Icons.wifi_off,
      iconColor: AppColors.error,
      title: title,
      message: message,
      action: action,
    );
  }

  /// 권한 없음
  static Widget noPermission({
    required String title,
    String? message,
    Widget? action,
  }) {
    return EmptyState(
      icon: Icons.lock_outline,
      iconColor: AppColors.neutral60,
      title: title,
      message: message,
      action: action,
    );
  }

  /// 아직 데이터가 추가되지 않음
  static Widget notYetAdded({
    required String title,
    String? message,
    Widget? action,
  }) {
    return EmptyState(
      icon: Icons.add_circle_outline,
      iconColor: AppColors.primary,
      title: title,
      message: message,
      action: action,
    );
  }
}
