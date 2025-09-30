import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'routes.dart';

/// 라우트 가드 클래스
///
/// 사용자의 인증 상태와 권한을 확인하여
/// 적절한 화면으로 리다이렉트하는 역할을 담당합니다.
class RouteGuard {
  /// 사용자 인증 상태 확인
  /// 실제 구현 시에는 shared/providers/auth_provider.dart와 연동
  static bool get isAuthenticated {
    // TODO: 실제 인증 상태 확인 로직 구현
    // 현재는 MVP를 위해 항상 true 반환
    return true;
  }

  /// 라우트 리다이렉트 로직
  ///
  /// GoRouter의 redirect 콜백에서 사용되며,
  /// 사용자의 인증 상태에 따라 적절한 경로로 리다이렉트합니다.
  ///
  /// [context] BuildContext
  /// [state] GoRouter 상태
  ///
  /// Returns: 리다이렉트할 경로 (null이면 현재 경로 유지)
  static String? redirectLogic(BuildContext context, GoRouterState state) {
    final String location = state.fullPath ?? state.uri.path;

    // 현재 경로가 공개 경로인 경우
    if (AppRoutes.publicRoutes.contains(location)) {
      // 이미 인증된 사용자가 로그인/회원가입 페이지에 접근 시 홈으로 리다이렉트
      if (isAuthenticated && (location == AppRoutes.login || location == AppRoutes.signup)) {
        return AppRoutes.home;
      }
      // 공개 경로는 그대로 허용
      return null;
    }

    // 보호된 경로에 접근하려는 경우
    if (AppRoutes.protectedRoutes.any((route) => location.startsWith(route.split(':')[0]))) {
      // 인증되지 않은 사용자는 로그인 페이지로 리다이렉트
      if (!isAuthenticated) {
        return AppRoutes.login;
      }
    }

    // 루트 경로(/) 접근 시 적절한 페이지로 리다이렉트
    if (location == AppRoutes.root) {
      return isAuthenticated ? AppRoutes.home : AppRoutes.splash;
    }

    // 기본적으로 현재 경로 유지
    return null;
  }

  /// 특정 권한이 필요한 기능에 대한 권한 확인
  ///
  /// [permission] 확인할 권한 타입
  ///
  /// Returns: 권한 보유 여부
  static bool hasPermission(PermissionType permission) {
    if (!isAuthenticated) return false;

    switch (permission) {
      case PermissionType.createSchedule:
        // 일정 생성 권한 확인 로직
        return true;
      case PermissionType.purchaseCourse:
        // 코스 구매 권한 확인 로직
        return true;
      case PermissionType.editProfile:
        // 프로필 편집 권한 확인 로직
        return true;
      case PermissionType.accessMap:
        // 지도 접근 권한 확인 로직
        return true;
      // ignore: unreachable_switch_default
      default:
        return false;
    }
  }

  /// 권한이 없을 때 표시할 에러 메시지
  ///
  /// [permission] 권한 타입
  ///
  /// Returns: 에러 메시지
  static String getPermissionErrorMessage(PermissionType permission) {
    switch (permission) {
      case PermissionType.createSchedule:
        return '일정을 생성하려면 로그인이 필요합니다.';
      case PermissionType.purchaseCourse:
        return '코스를 구매하려면 로그인이 필요합니다.';
      case PermissionType.editProfile:
        return '프로필을 편집하려면 로그인이 필요합니다.';
      case PermissionType.accessMap:
        return '지도를 사용하려면 위치 권한이 필요합니다.';
      // ignore: unreachable_switch_default
      default:
        return '이 기능을 사용하려면 적절한 권한이 필요합니다.';
    }
  }
}

/// 앱에서 사용되는 권한 타입들
enum PermissionType {
  /// 일정 생성 권한
  createSchedule,

  /// 코스 구매 권한
  purchaseCourse,

  /// 프로필 편집 권한
  editProfile,

  /// 지도 접근 권한
  accessMap,
}