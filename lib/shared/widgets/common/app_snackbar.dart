import 'package:flutter/material.dart';
import 'package:tripgether/core/theme/app_colors.dart';
import 'package:tripgether/core/theme/app_spacing.dart';
import 'package:tripgether/core/theme/app_text_styles.dart';

/// Tripgether 앱의 공용 SnackBar 컴포넌트
///
/// **디자인 스펙**:
/// - 배경색: AppColors.grayPurple (#A5A3AA)
/// - 텍스트: AppTextStyles.titleSemiBold16, 흰색
/// - 크기: 콘텐츠 + 패딩 기반 자동 조정
/// - 마진: 좌우/상하 20px (xl)
/// - 패딩: 20px (xl)
/// - 정렬: start (왼쪽 정렬)
///
/// **사용 예시**:
/// ```dart
/// // 기본 사용
/// AppSnackBar.show(context, message: '로그인되었습니다');
///
/// // 타입별 사용
/// AppSnackBar.showSuccess(context, '저장되었습니다');
/// AppSnackBar.showInfo(context, '언어가 변경되었습니다');
/// AppSnackBar.showError(context, '오류가 발생했습니다');
///
/// // 커스텀 duration
/// AppSnackBar.show(
///   context,
///   message: '잠시 후 다시 시도해주세요',
///   duration: Duration(seconds: 5),
/// );
/// ```
class AppSnackBar {
  AppSnackBar._(); // Private constructor to prevent instantiation

  /// 기본 SnackBar 표시
  ///
  /// [context]: BuildContext
  /// [message]: 표시할 메시지
  /// [duration]: 표시 시간 (기본 3초)
  /// [backgroundColor]: 배경색 (기본 AppColors.grayPurple)
  static void show(
    BuildContext context, {
    required String message,
    Duration duration = const Duration(seconds: 3),
    Color? backgroundColor,
  }) {
    // 기존 SnackBar 제거
    ScaffoldMessenger.of(context).clearSnackBars();

    // SnackBar 표시
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: _buildContent(message),
        backgroundColor: backgroundColor ?? AppColors.grayPurple,
        duration: duration,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: AppRadius.allSmall),
        margin: EdgeInsets.symmetric(
          horizontal: AppSpacing.xl, // 20
          vertical: AppSpacing.xl, // 20
        ),
        padding: EdgeInsets.all(
          AppSpacing.xl, // 20
        ),
        // 크기 제약 (376w × 64h)
        // floating behavior에서는 constraints로 제어
        elevation: AppElevation.medium,
      ),
    );
  }

  /// SnackBar 콘텐츠 빌드
  static Widget _buildContent(String message) {
    return Align(
      alignment: Alignment.centerLeft, // start 정렬
      child: Text(
        message,
        style: AppTextStyles.titleSemiBold16.copyWith(color: AppColors.white),
        textAlign: TextAlign.start,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  /// 성공 메시지 SnackBar (녹색 배경)
  ///
  /// **사용처**: 로그인 성공, 저장 완료 등
  static void showSuccess(
    BuildContext context,
    String message, {
    Duration duration = const Duration(seconds: 3),
  }) {
    show(
      context,
      message: message,
      duration: duration,
      backgroundColor: AppColors.success,
    );
  }

  /// 정보 메시지 SnackBar (기본 grayPurple 배경)
  ///
  /// **사용처**: 언어 변경, 일반 알림 등
  static void showInfo(
    BuildContext context,
    String message, {
    Duration duration = const Duration(seconds: 3),
  }) {
    show(
      context,
      message: message,
      duration: duration,
      backgroundColor: AppColors.grayPurple,
    );
  }

  /// 오류 메시지 SnackBar (빨간색 배경)
  ///
  /// **사용처**: 로그인 실패, 네트워크 오류 등
  static void showError(
    BuildContext context,
    String message, {
    Duration duration = const Duration(seconds: 3),
  }) {
    show(
      context,
      message: message,
      duration: duration,
      backgroundColor: AppColors.error,
    );
  }
}
