import 'package:flutter/material.dart';

/// Tripgether 앱의 페이지 전환 애니메이션 설정
///
/// 페이지 전환과 관련된 모든 애니메이션 로직을 관리합니다.
/// 테마와 분리하여 애니메이션만의 책임을 갖습니다.
class AppPageTransitions {
  AppPageTransitions._();

  /// 애니메이션 없는 페이지 전환 테마
  ///
  /// 즉각적인 화면 전환을 위해 모든 플랫폼에서 애니메이션을 제거합니다.
  static const PageTransitionsTheme noAnimation = PageTransitionsTheme(
    builders: {
      TargetPlatform.android: _NoAnimationPageTransitionsBuilder(),
      TargetPlatform.iOS: _NoAnimationPageTransitionsBuilder(),
      TargetPlatform.macOS: _NoAnimationPageTransitionsBuilder(),
      TargetPlatform.windows: _NoAnimationPageTransitionsBuilder(),
      TargetPlatform.linux: _NoAnimationPageTransitionsBuilder(),
      TargetPlatform.fuchsia: _NoAnimationPageTransitionsBuilder(),
    },
  );

  /// 슬라이드 애니메이션 페이지 전환 테마 (향후 확장용)
  ///
  /// 부드러운 슬라이드 전환 효과를 제공합니다.
  static const PageTransitionsTheme slideAnimation = PageTransitionsTheme(
    builders: {
      TargetPlatform.android: CupertinoPageTransitionsBuilder(),
      TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
      TargetPlatform.macOS: CupertinoPageTransitionsBuilder(),
      TargetPlatform.windows: FadeUpwardsPageTransitionsBuilder(),
      TargetPlatform.linux: FadeUpwardsPageTransitionsBuilder(),
      TargetPlatform.fuchsia: FadeUpwardsPageTransitionsBuilder(),
    },
  );

  /// 페이드 애니메이션 페이지 전환 테마 (향후 확장용)
  ///
  /// 부드러운 페이드 인/아웃 전환 효과를 제공합니다.
  static const PageTransitionsTheme fadeAnimation = PageTransitionsTheme(
    builders: {
      TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
      TargetPlatform.iOS: FadeUpwardsPageTransitionsBuilder(),
      TargetPlatform.macOS: FadeUpwardsPageTransitionsBuilder(),
      TargetPlatform.windows: FadeUpwardsPageTransitionsBuilder(),
      TargetPlatform.linux: FadeUpwardsPageTransitionsBuilder(),
      TargetPlatform.fuchsia: FadeUpwardsPageTransitionsBuilder(),
    },
  );
}

/// 애니메이션 없는 페이지 전환을 위한 커스텀 PageTransitionsBuilder
///
/// 모든 플랫폼에서 페이지 전환 시 애니메이션을 완전히 제거하여
/// 즉각적인 화면 전환을 제공합니다.
class _NoAnimationPageTransitionsBuilder extends PageTransitionsBuilder {
  const _NoAnimationPageTransitionsBuilder();

  @override
  Widget buildTransitions<T extends Object?>(
    PageRoute<T> route,
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    // 애니메이션 없이 즉시 child 위젯 반환
    return child;
  }
}

/// 커스텀 페이지 라우트 (향후 확장용)
///
/// 특별한 전환 효과가 필요한 페이지에서 사용할 수 있는
/// 커스텀 페이지 라우트입니다.
class NoAnimationPageRoute<T> extends PageRouteBuilder<T> {
  final Widget child;

  @override
  final RouteSettings settings;

  NoAnimationPageRoute({required this.child, required this.settings})
    : super(
        settings: settings,
        pageBuilder: (context, animation, secondaryAnimation) => child,
        transitionDuration: Duration.zero,
        reverseTransitionDuration: Duration.zero,
      );

  @override
  Widget buildTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return child;
  }
}

/// 애니메이션 관련 확장 함수들
extension PageRouteExtensions on BuildContext {
  /// 애니메이션 없이 페이지 이동
  Future<T?> pushWithoutAnimation<T extends Object?>(Widget page) {
    return Navigator.of(this).push<T>(
      NoAnimationPageRoute<T>(
        child: page,
        settings: RouteSettings(name: page.runtimeType.toString()),
      ),
    );
  }

  /// 애니메이션 없이 페이지 교체
  Future<T?> pushReplacementWithoutAnimation<
    T extends Object?,
    TO extends Object?
  >(Widget page) {
    return Navigator.of(this).pushReplacement<T, TO>(
      NoAnimationPageRoute<T>(
        child: page,
        settings: RouteSettings(name: page.runtimeType.toString()),
      ),
    );
  }
}
