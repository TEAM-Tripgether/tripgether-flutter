import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../router/routes.dart';
import '../../shared/widgets/common/app_snackbar.dart';
import '../../features/auth/providers/user_provider.dart';

/// 중복 실행 방지 플래그
/// 여러 API가 동시에 TOKEN_BLACKLISTED를 받았을 때 중복 로그아웃 방지
bool _isHandlingTokenError = false;

/// Refresh Token 에러 처리 유틸리티
///
/// **역할**:
/// 1. SnackBar로 에러 메시지 표시
/// 2. 완전 로그아웃 실행 (Google 연결 해제 + 토큰 삭제)
/// 3. 로그인 화면으로 자동 리다이렉트
/// 4. 중복 실행 방지 (동시 API 호출 시)
///
/// **사용 위치**:
/// - RefreshTokenException이 발생하는 모든 화면
///
/// **사용 예시**:
/// ```dart
/// try {
///   await ref.read(someProvider.future);
/// } on RefreshTokenException catch (e) {
///   if (mounted) {
///     await handleTokenError(context, ref, e);
///   }
/// }
/// ```
Future<void> handleTokenError(
  BuildContext context,
  WidgetRef ref,
  Object error,
) async {
  // 중복 실행 방지
  if (_isHandlingTokenError) {
    debugPrint('[TokenErrorHandler] ⏳ 이미 토큰 에러 처리 진행 중 (중복 실행 방지)');
    return;
  }

  _isHandlingTokenError = true;
  debugPrint('[TokenErrorHandler] ❌ Refresh Token 에러 발생: $error');

  // 1. 에러 메시지 추출 및 SnackBar 표시
  final message = error.toString().replaceAll('Exception: ', '');
  if (context.mounted) {
    AppSnackBar.showError(context, message);
  }

  // 2. 완전 로그아웃 실행
  try {
    debugPrint('[TokenErrorHandler] 🚪 완전 로그아웃 시작');

    // UserNotifier.clearUser() 호출
    // - Google 계정 연결 해제 (disconnect)
    // - Access Token, Refresh Token 삭제
    // - 사용자 정보 삭제
    // - 메모리 캐시 초기화
    await ref.read(userNotifierProvider.notifier).clearUser();
    debugPrint('[TokenErrorHandler] ✅ UserNotifier.clearUser() 완료');
  } catch (logoutError) {
    debugPrint('[TokenErrorHandler] ⚠️ 로그아웃 처리 중 오류: $logoutError');
    // 로그아웃 실패해도 로그인 화면으로 이동
  } finally {
    // 플래그 초기화 (다음 에러 처리를 위해)
    _isHandlingTokenError = false;
  }

  // 3. 로그인 화면으로 리다이렉트
  if (context.mounted) {
    debugPrint('[TokenErrorHandler] 🔄 로그인 화면으로 이동');
    context.go(AppRoutes.login);
  }
}
