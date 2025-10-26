import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'routes.dart';
import '../../features/auth/providers/user_provider.dart';
import '../../features/auth/data/models/user_model.dart';
import '../../l10n/app_localizations.dart';

/// 라우트 가드 클래스
///
/// 사용자의 인증 상태와 권한을 확인하여
/// 적절한 화면으로 리다이렉트하는 역할을 담당합니다.
class RouteGuard {
  /// 사용자 인증 상태 확인
  ///
  /// ProviderContainer를 통해 UserNotifier의 현재 상태를 읽어와서
  /// 로그인 여부를 판단합니다.
  ///
  /// **중요**: AsyncValue의 loading 상태도 고려하여,
  /// 이전에 로그인되어 있었다면 loading 중에도 인증 상태를 유지합니다.
  ///
  /// [context] BuildContext - ProviderScope를 찾기 위해 필요
  ///
  /// Returns: true if 사용자가 로그인되어 있음, false otherwise
  static bool isAuthenticated(BuildContext context) {
    try {
      // BuildContext에서 ProviderScope 찾기
      final container = ProviderScope.containerOf(context);

      // UserNotifier의 현재 상태 읽기
      final userState = container.read(userNotifierProvider);

      // valueOrNull을 사용하여 loading 상태에서도 이전 값 확인
      // loading 중이어도 이전에 로그인되어 있었다면 인증 상태 유지
      final user = userState.valueOrNull;

      return user != null;
    } catch (e) {
      // ProviderScope를 찾을 수 없거나 에러 발생 시 비인증 처리
      return false;
    }
  }

  /// 라우트 리다이렉트 로직
  ///
  /// GoRouter의 redirect 콜백에서 사용되며,
  /// 사용자의 인증 상태에 따라 적절한 경로로 리다이렉트합니다.
  ///
  /// **흐름**:
  /// 1. 루트 경로(/) → 스플래시로 리다이렉트
  /// 2. 공개 경로(스플래시, 로그인) + 인증됨 → 홈으로 리다이렉트
  /// 3. 보호된 경로 + 인증 안 됨 → 로그인으로 리다이렉트
  /// 4. 그 외 → 현재 경로 유지
  ///
  /// [context] BuildContext
  /// [state] GoRouter 상태
  ///
  /// Returns: 리다이렉트할 경로 (null이면 현재 경로 유지)
  static String? redirectLogic(BuildContext context, GoRouterState state) {
    final String location = state.fullPath ?? state.uri.path;
    final bool authenticated = isAuthenticated(context);

    // 루트 경로(/) 접근 시 스플래시로 리다이렉트
    if (location == AppRoutes.root) {
      return AppRoutes.splash;
    }

    // 현재 경로가 공개 경로인 경우
    if (AppRoutes.publicRoutes.contains(location)) {
      // 이미 인증된 사용자가 로그인 페이지에 접근 시 홈으로 리다이렉트
      if (authenticated && location == AppRoutes.login) {
        return AppRoutes.home;
      }
      // 스플래시 화면은 자체적으로 네비게이션 처리하므로 그대로 허용
      // 공개 경로는 그대로 허용
      return null;
    }

    // 보호된 경로에 접근하려는 경우
    // protectedRoutes에 정의된 경로나 그 하위 경로인지 확인
    final isProtectedRoute = AppRoutes.protectedRoutes.any((route) {
      // :param 형식의 동적 경로 처리 (예: /place-detail/:placeId)
      final routePattern = route.split(':')[0];
      return location.startsWith(routePattern);
    });

    if (isProtectedRoute) {
      // 인증되지 않은 사용자는 로그인 페이지로 리다이렉트
      if (!authenticated) {
        return AppRoutes.login;
      }
    }

    // 기본적으로 현재 경로 유지
    return null;
  }

  /// 특정 권한이 필요한 기능에 대한 권한 확인
  ///
  /// [context] BuildContext - 인증 상태 확인을 위해 필요
  /// [permission] 확인할 권한 타입
  ///
  /// Returns: 권한 보유 여부
  static bool hasPermission(BuildContext context, PermissionType permission) {
    if (!isAuthenticated(context)) return false;

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
  /// [context] BuildContext - 다국어 지원을 위해 필요
  /// [permission] 권한 타입
  ///
  /// Returns: 에러 메시지 (다국어 지원)
  static String getPermissionErrorMessage(
    BuildContext context,
    PermissionType permission,
  ) {
    final l10n = AppLocalizations.of(context);

    switch (permission) {
      case PermissionType.createSchedule:
        return l10n.permissionCreateScheduleRequired;
      case PermissionType.purchaseCourse:
        return l10n.permissionPurchaseCourseRequired;
      case PermissionType.editProfile:
        return l10n.permissionEditProfileRequired;
      case PermissionType.accessMap:
        return l10n.permissionAccessMapRequired;
      // ignore: unreachable_switch_default
      default:
        return l10n.permissionGeneralRequired;
    }
  }
}

/// GoRouter의 refreshListenable을 위한 ChangeNotifier
///
/// UserNotifier의 상태 변화를 감지하여 GoRouter에게 알려,
/// 인증 상태가 변경될 때 redirect 로직을 재실행하도록 합니다.
///
/// **문제 해결**:
/// - UserNotifier.build()는 async 함수로 Secure Storage에서 사용자 정보를 로드
/// - GoRouter의 redirect는 즉시 실행되어 loading 상태에서 null 반환
/// - 이로 인해 로그인된 사용자도 로그인 화면으로 리다이렉트되는 문제 발생
///
/// **해결 방법**:
/// - refreshListenable을 통해 UserNotifier 상태 변화 감지
/// - loading → data 전환 시 redirect 재실행하여 올바른 화면으로 이동
class GoRouterRefreshNotifier extends ChangeNotifier {
  /// Riverpod ProviderContainer 참조
  final ProviderContainer _container;

  /// 생성자
  ///
  /// [container] ProviderContainer - UserNotifier 감시용
  GoRouterRefreshNotifier(this._container) {
    // UserNotifier 상태 변화 감지
    _container.listen<AsyncValue<User?>>(
      userNotifierProvider,
      (previous, next) {
        // 상태가 변경되면 GoRouter에게 알림
        notifyListeners();
      },
      fireImmediately: false, // 초기화 시점에는 알리지 않음
    );
  }

  @override
  void dispose() {
    // ProviderContainer는 외부에서 관리하므로 dispose하지 않음
    super.dispose();
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
