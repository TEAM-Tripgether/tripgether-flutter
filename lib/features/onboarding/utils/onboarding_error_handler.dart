import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/router/routes.dart';
import '../../../shared/widgets/common/app_snackbar.dart';
import '../../auth/providers/user_provider.dart';
import '../providers/onboarding_notifier.dart';

/// 온보딩 에러 처리 유틸리티
///
/// **역할**:
/// 1. SnackBar로 에러 메시지 표시
/// 2. 완전 로그아웃 실행 (Google 연결 해제 + 토큰 삭제)
/// 3. 온보딩 상태 초기화
/// 4. 로그인 화면으로 자동 리다이렉트
///
/// **사용 위치**:
/// - TermsPage
/// - NicknamePage
/// - BirthdatePage
/// - GenderPage
/// - InterestsPage
///
/// **사용 예시**:
/// ```dart
/// try {
///   final response = await ref.read(onboardingNotifierProvider.notifier).updateName(...);
/// } catch (e) {
///   if (mounted) {
///     await handleOnboardingError(context, ref, e);
///   }
/// }
/// ```
Future<void> handleOnboardingError(
  BuildContext context,
  WidgetRef ref,
  Object error,
) async {
  debugPrint('[OnboardingErrorHandler] ❌ 온보딩 에러 발생: $error');

  // 1. 에러 메시지 추출 및 SnackBar 표시
  final message = error.toString().replaceAll('Exception: ', '');
  if (context.mounted) {
    AppSnackBar.showError(context, message);
  }

  // 2. 완전 로그아웃 실행
  try {
    debugPrint('[OnboardingErrorHandler] 🚪 완전 로그아웃 시작');

    // 2-1. UserNotifier.clearUser() 호출
    // - Google 계정 연결 해제 (disconnect)
    // - Access Token, Refresh Token 삭제
    // - 사용자 정보 삭제
    // - 메모리 캐시 초기화
    await ref.read(userNotifierProvider.notifier).clearUser();
    debugPrint('[OnboardingErrorHandler] ✅ UserNotifier.clearUser() 완료');

    // 2-2. OnboardingNotifier.reset() 호출
    // - onboardingStep Secure Storage 삭제
    // - Provider 상태 초기화
    await ref.read(onboardingNotifierProvider.notifier).reset();
    debugPrint('[OnboardingErrorHandler] ✅ OnboardingNotifier.reset() 완료');
  } catch (logoutError) {
    debugPrint(
      '[OnboardingErrorHandler] ⚠️ 로그아웃 처리 중 오류: $logoutError',
    );
    // 로그아웃 실패해도 로그인 화면으로 이동
  }

  // 3. 로그인 화면으로 리다이렉트
  if (context.mounted) {
    debugPrint('[OnboardingErrorHandler] 🔄 로그인 화면으로 이동');
    context.go(AppRoutes.login);
  }
}
