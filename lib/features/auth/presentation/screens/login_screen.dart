import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../core/router/routes.dart';
import '../../../../core/theme/app_colors.dart';
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
class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  /// 구글 로그인 로딩 상태
  bool _isGoogleLoading = false;

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
          content: Text(AppLocalizations.of(context).loginFailedTryAgain),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    }
  }

  /// 구글 로그인 핸들러
  Future<void> _handleGoogleLogin(BuildContext context) async {
    debugPrint('[LoginScreen] 🔘 구글 로그인 버튼 클릭');

    // 로딩 시작
    setState(() => _isGoogleLoading = true);

    // LoginProvider를 통한 구글 로그인
    final success = await ref
        .read(loginNotifierProvider.notifier)
        .loginWithGoogle();

    debugPrint('[LoginScreen] 구글 로그인 결과: ${success ? "성공 ✅" : "실패 ❌"}');

    // 로딩 종료
    if (mounted) {
      setState(() => _isGoogleLoading = false);
    }

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
          content: Text(AppLocalizations.of(context).googleLoginFailed),
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

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(AppLocalizations.of(context).signupScreenPreparation),
      ),
    );
  }

  /// 비밀번호 찾기 핸들러
  void _handleFindPassword(BuildContext context) {
    // TODO: 비밀번호 찾기 화면으로 이동
    debugPrint('[Login] 비밀번호 찾기 이동');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        /// 대각선 그라데이션 배경 (왼쪽 상단 → 오른쪽 하단)
        /// #1B0062 → #5325CB → #B599FF
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter, // 수직 그라데이션 시작 (정확히 위)
            end: Alignment.bottomCenter, // 수직 그라데이션 끝 (정확히 아래)
            colors: AppColorPalette.diagonalGradient,
            stops: const [0.0, 0.25, 0.7], // 25:45:30 비율
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: AppSpacing.xxl),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: AppSpacing.huge),

                /// 앱 로고
                /// app_logo_black.png에 이미 "Tripgether" 텍스트와
                /// "More than tours. Real local moments." 태그라인이 포함되어 있음
                Image.asset(
                  'assets/app_logo_white.png',
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
                  onFindPassword: () => _handleFindPassword(context),
                ),

                SizedBox(height: AppSpacing.huge),

                /// 소셜 로그인 섹션
                /// "10초만에 빠른가입" 배지 + 구글/이메일 가입 버튼
                SocialLoginSection(
                  onGoogleLogin: () => _handleGoogleLogin(context),
                  onEmailSignup: () => _handleEmailSignup(context),
                  isGoogleLoading: _isGoogleLoading,
                ),

                SizedBox(height: AppSpacing.xl),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
