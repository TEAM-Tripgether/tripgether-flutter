import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/router/routes.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../providers/login_provider.dart';
import '../widgets/login_form.dart';
import '../widgets/social_login_section.dart';

/// 로그인 화면
///
/// 앱 로고, 이메일/비밀번호 입력 폼, 소셜 로그인 버튼들을 포함하는
/// 메인 로그인 화면입니다.
///
/// **디자인**:
/// - 상단: app_logo_black (Tripgether + 태그라인 포함)
/// - 중단: 이메일/비밀번호 입력 폼
/// - 하단: 소셜 로그인 버튼들 (카카오, 네이버, 이메일 가입)
class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  /// 이메일/비밀번호 로그인 핸들러
  Future<void> _handleEmailLogin(
    BuildContext context,
    WidgetRef ref,
    String email,
    String password,
  ) async {
    debugPrint('[LoginScreen] 📝 이메일 로그인 버튼 클릭');
    debugPrint('[LoginScreen] 📧 Email: $email');

    // LoginProvider를 통한 로그인 API 호출
    final success = await ref
        .read(loginNotifierProvider.notifier)
        .loginWithEmail(email: email, password: password);

    debugPrint('[LoginScreen] 로그인 결과: ${success ? "성공 ✅" : "실패 ❌"}');

    // 로그인 성공 시 홈으로 이동
    if (success && context.mounted) {
      debugPrint('[LoginScreen] 🏠 홈 화면으로 이동 중... (${AppRoutes.home})');
      context.go(AppRoutes.home);
      debugPrint('[LoginScreen] ✅ 화면 전환 완료');
    } else if (context.mounted) {
      // 로그인 실패 시 에러 메시지 표시
      debugPrint('[LoginScreen] ⚠️ 로그인 실패 - 에러 메시지 표시');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('로그인에 실패했습니다. 다시 시도해주세요.'),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    }
  }

  /// 구글 로그인 핸들러
  Future<void> _handleGoogleLogin(BuildContext context, WidgetRef ref) async {
    debugPrint('[LoginScreen] 🔘 구글 로그인 버튼 클릭');

    // LoginProvider를 통한 구글 로그인
    final success = await ref
        .read(loginNotifierProvider.notifier)
        .loginWithGoogle();

    debugPrint('[LoginScreen] 구글 로그인 결과: ${success ? "성공 ✅" : "실패 ❌"}');

    // 로그인 성공 시 홈으로 이동
    if (success && context.mounted) {
      debugPrint('[LoginScreen] 🏠 홈 화면으로 이동 중... (${AppRoutes.home})');
      context.go(AppRoutes.home);
      debugPrint('[LoginScreen] ✅ 화면 전환 완료');
    } else if (!success && context.mounted) {
      // 로그인 실패 시 에러 메시지 표시
      debugPrint('[LoginScreen] ⚠️ 구글 로그인 실패 - 에러 메시지 표시');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('구글 로그인에 실패했습니다.'),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    } else if (!context.mounted) {
      debugPrint('[LoginScreen] ⚠️ context가 unmounted됨 - 화면 전환 불가');
    }
  }

  /// 이메일 회원가입 핸들러
  void _handleEmailSignup(BuildContext context) {
    // TODO: 회원가입 화면으로 이동
    debugPrint('[Login] 이메일 회원가입 이동');

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('회원가입 화면 준비 중입니다')));
  }

  /// 아이디 찾기 핸들러
  void _handleFindId(BuildContext context) {
    // TODO: 아이디 찾기 화면으로 이동
    debugPrint('[Login] 아이디 찾기 이동');
  }

  /// 비밀번호 찾기 핸들러
  void _handleFindPassword(BuildContext context) {
    // TODO: 비밀번호 찾기 화면으로 이동
    debugPrint('[Login] 비밀번호 찾기 이동');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      // 키보드가 올라올 때 화면이 넘치지 않도록 스크롤 가능하게 설정
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: AppSpacing.xxl),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: AppSpacing.huge),

              /// 앱 로그인
              /// app_logo_black.png에 이미 "Tripgether" 텍스트와
              /// "More than tours. Real local moments." 태그라인이 포함되어 있음
              Image.asset(
                'assets/app_logo_black.png',
                width: 240.w,
                height: 240.h,
                fit: BoxFit.contain,
              ),

              /// 로그인 입력 폼
              /// 이메일, 비밀번호 입력 + 자동로그인 + 아이디/비밀번호 찾기
              LoginForm(
                onLogin: (email, password) {
                  _handleEmailLogin(context, ref, email, password);
                },
                onFindId: () => _handleFindId(context),
                onFindPassword: () => _handleFindPassword(context),
              ),

              SizedBox(height: AppSpacing.huge),

              /// 소셜 로그인 섹션
              /// "10초만에 빠른가입" 배지 + 구글/이메일 가입 버튼
              SocialLoginSection(
                onGoogleLogin: () => _handleGoogleLogin(context, ref),
                onEmailSignup: () => _handleEmailSignup(context),
              ),

              SizedBox(height: AppSpacing.xl),
            ],
          ),
        ),
      ),
    );
  }
}
