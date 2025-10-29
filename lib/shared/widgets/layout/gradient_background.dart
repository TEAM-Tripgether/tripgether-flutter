import 'package:flutter/material.dart';
import 'package:tripgether/core/theme/app_colors.dart';
import 'package:tripgether/core/theme/app_spacing.dart';

/// 앱 전역에서 사용하는 그라데이션 배경 Container
///
/// 홈 화면, 코스마켓 등 여러 화면에서 동일한 보라색 그라데이션을 적용할 때 사용합니다.
/// 그라데이션 색상: #664BAE (상단) → #8975C1B2 (70%) → #FFFFFF (하단)
///
/// **사용 예시:**
/// ```dart
/// GradientBackground(
///   child: SearchBar(...),
/// )
/// ```
///
/// **커스텀 패딩 적용:**
/// ```dart
/// GradientBackground(
///   padding: EdgeInsets.only(
///     left: AppSpacing.lg,
///     right: AppSpacing.lg,
///     top: AppSpacing.xxl,
///     bottom: AppSpacing.lg,
///   ),
///   child: Column(...),
/// )
/// ```
class GradientBackground extends StatelessWidget {
  /// 배경 위에 표시될 자식 위젯
  final Widget child;

  /// 커스텀 패딩 (기본값: 좌우/상하 모두 AppSpacing.lg)
  ///
  /// null일 경우 기본 패딩이 적용됩니다.
  /// 특정 화면에서 다른 패딩이 필요한 경우 EdgeInsets를 전달하세요.
  final EdgeInsetsGeometry? padding;

  const GradientBackground({
    super.key,
    required this.child,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      // 전체 너비를 차지하도록 설정 (그라데이션이 화면 끝까지 확장)
      width: double.infinity,

      // 그라데이션 배경 설정
      // AppColorPalette.homeHeaderGradient를 사용하여
      // 앱 전체에서 일관된 그라데이션 색상 유지
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter, // 위에서 시작
          end: Alignment.bottomCenter, // 아래로 끝
          colors: AppColorPalette.homeHeaderGradient, // 색상 배열
          stops: const [0.0, 0.7, 1.0], // 0%: 진한 보라 → 70%: 중간 보라 → 100%: 흰색
        ),
      ),

      // 기본 패딩: 모든 방향 AppSpacing.lg
      // 커스텀 패딩이 전달되면 해당 값 사용
      padding: padding ?? EdgeInsets.all(AppSpacing.lg),

      child: child,
    );
  }
}
