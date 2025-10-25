import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter/foundation.dart';
import 'package:tripgether/core/services/auth/google_auth_service.dart';
import 'package:tripgether/features/auth/data/models/user_model.dart';
import 'package:tripgether/features/auth/data/models/auth_request.dart';
import 'package:tripgether/features/auth/services/auth_api_service.dart';
import 'package:tripgether/features/auth/providers/user_provider.dart';

part 'login_provider.g.dart';

/// 로그인 상태 관리 Provider
///
/// 이메일/비밀번호 로그인과 소셜 로그인(카카오, 네이버)을 처리합니다.
/// AsyncNotifier를 사용하여 로딩/에러/성공 상태를 자동으로 관리합니다.
@riverpod
class LoginNotifier extends _$LoginNotifier {
  @override
  FutureOr<void> build() {
    // 초기 상태: 아무것도 하지 않음
  }

  /// ⚠️ 주의: LoginNotifier는 상태 관리를 하지 않습니다.
  ///
  /// - 실제 사용자 상태는 UserNotifier가 관리
  /// - LoginNotifier는 로그인/로그아웃 액션만 제공하는 헬퍼 클래스
  /// - 따라서 state 업데이트가 필요 없음 (AsyncNotifier 사용 불필요)

  /// 이메일/비밀번호 로그인
  ///
  /// [email] 사용자 이메일
  /// [password] 사용자 비밀번호
  ///
  /// Returns: 로그인 성공 시 true, 실패 시 false
  /// Throws: [Exception] 로그인 API 호출 실패 시
  Future<bool> loginWithEmail({
    required String email,
    required String password,
  }) async {
    debugPrint('[LoginProvider] 🔄 이메일 로그인 시도...');
    debugPrint('  📧 Email: $email');
    debugPrint('  🔑 Password: ${"*" * password.length}');

    try {
      // 로딩 상태는 UserNotifier가 관리하므로 여기서는 불필요

      // TODO: 실제 로그인 API 호출
      // final response = await ref.read(authServiceProvider).login(
      //   email: email,
      //   password: password,
      // );
      //
      // TODO: JWT 토큰 저장 (FlutterSecureStorage 사용)
      // await ref.read(secureStorageProvider).write(
      //   key: 'access_token',
      //   value: response.accessToken,
      // );
      //
      // TODO: 사용자 정보 저장
      // ref.read(userProvider.notifier).setUser(response.user);

      // 임시: 1초 대기 (실제 API 호출 시뮬레이션)
      await Future.delayed(const Duration(seconds: 1));

      debugPrint('[LoginProvider] ✅ 이메일 로그인 성공!');
      debugPrint('  👤 사용자: $email');
      debugPrint('  🏠 홈 화면으로 이동 예정');

      // 성공 상태는 UserNotifier가 관리
      return true;
    } catch (e) {
      debugPrint('[LoginProvider] ❌ 이메일 로그인 실패: $e');

      // 에러는 호출자에게 false 반환으로 전달
      return false;
    }
  }

  /// 구글 로그인
  ///
  /// Google OAuth를 통해 사용자 인증을 수행합니다.
  /// 1. GoogleAuthService를 통해 Google 로그인 수행
  /// 2. 사용자가 Google 계정을 선택하고 권한 동의
  /// 3. 로그인 성공 시 사용자 정보 및 토큰 획득
  ///
  /// Returns: 로그인 성공 시 true, 실패 또는 취소 시 false
  Future<bool> loginWithGoogle() async {
    debugPrint('[LoginProvider] 🔄 구글 로그인 시작...');

    try {
      // 로딩 상태는 UserNotifier가 관리하므로 여기서는 불필요

      // 1. GoogleAuthService를 통해 구글 로그인 실행
      final googleUser = await GoogleAuthService.signIn();

      // 사용자가 로그인을 취소한 경우
      if (googleUser == null) {
        debugPrint('[LoginProvider] ℹ️ 구글 로그인 취소됨');
        // 취소는 false 반환
        return false;
      }

      // 2. 구글 인증 정보 가져오기 (accessToken, idToken)
      final googleAuth = googleUser.authentication;

      debugPrint('[LoginProvider] ✅ 구글 인증 정보 획득');
      debugPrint('');
      debugPrint('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
      debugPrint('📦 백엔드로 전송할 데이터:');
      debugPrint('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
      debugPrint('🔑 idToken (필수):');
      debugPrint('   ${googleAuth.idToken}');
      debugPrint('');
      debugPrint('📧 email: ${googleUser.email}');
      debugPrint('👤 displayName: ${googleUser.displayName}');
      debugPrint('🖼️ photoUrl: ${googleUser.photoUrl}');
      debugPrint('🆔 googleId: ${googleUser.id}');
      debugPrint('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
      debugPrint('');

      // 3. AuthApiService로 백엔드 API 호출 (Mock/Real 자동 전환)
      debugPrint('[LoginProvider] 🔐 백엔드 API 호출 시작 (토큰 발급)');

      final authService = AuthApiService();
      final authResponse = await authService.signIn(
        AuthRequest.signIn(
          socialPlatform: 'GOOGLE',
          email: googleUser.email,
          nickname: googleUser.displayName ?? 'Unknown',
          profileUrl: googleUser.photoUrl,
        ),
      );

      debugPrint('[LoginProvider] ✅ JWT 토큰 발급 완료');
      debugPrint(
        '  🔑 Access Token: ${authResponse.accessToken.substring(0, 30)}...',
      );
      debugPrint(
        '  🔄 Refresh Token: ${authResponse.refreshToken.substring(0, 30)}...',
      );
      debugPrint('  🆕 최초 로그인: ${authResponse.isFirstLogin}');

      // 4. User 객체 생성 (Google 정보 기반)
      final user = User.fromGoogleSignIn(
        email: googleUser.email,
        displayName: googleUser.displayName ?? 'Unknown',
        photoUrl: googleUser.photoUrl,
      );

      debugPrint('[LoginProvider] 👤 User 객체 생성 완료');
      debugPrint('  📧 Email: ${user.email}');
      debugPrint('  👤 Nickname: ${user.nickname}');
      debugPrint('  🖼️ Profile: ${user.profileImageUrl ?? "없음"}');

      // 5. UserNotifier에 사용자 정보 + 토큰 저장
      debugPrint('[LoginProvider] 💾 Secure Storage에 정보 저장 중...');

      await ref
          .read(userNotifierProvider.notifier)
          .setUser(
            user: user,
            accessToken: authResponse.accessToken,
            refreshToken: authResponse.refreshToken,
          );

      debugPrint('[LoginProvider] ✅ 사용자 정보 저장 완료 (Secure Storage)');
      debugPrint('  📁 저장 항목: User, Access Token, Refresh Token');

      debugPrint('[LoginProvider] ✅ 구글 로그인 성공!');
      debugPrint('  👤 사용자: ${googleUser.email}');
      debugPrint('  🏠 홈 화면으로 이동 예정');

      // 성공 상태는 UserNotifier가 관리
      return true;
    } catch (e) {
      // 취소 예외 감지: 사용자가 로그인을 취소한 경우
      final errorString = e.toString();
      if (errorString.contains('canceled') ||
          errorString.contains('cancelled') ||
          errorString.contains('GoogleSignInExceptionCode.canceled')) {
        debugPrint('[LoginProvider] ℹ️ 구글 로그인 취소됨 (예외 경로)');
        // 취소는 false 반환
        return false;
      }

      // 실제 에러: false 반환
      debugPrint('[LoginProvider] ❌ 구글 로그인 실패: $e');
      return false;
    }
  }

  /// 로그아웃
  ///
  /// 저장된 토큰을 삭제하고 사용자 정보를 초기화합니다.
  ///
  /// **동작**:
  /// 1. Google 계정 로그아웃
  /// 2. UserNotifier에서 사용자 정보 + 토큰 삭제
  /// 3. Secure Storage 완전 정리
  Future<void> logout() async {
    try {
      debugPrint('[LoginProvider] 🚪 로그아웃 시작');

      // 1. Google 계정 로그아웃
      await GoogleAuthService.signOut();
      debugPrint('[LoginProvider] ✅ Google 계정 로그아웃 완료');

      // 2. UserNotifier에서 사용자 정보 + 토큰 삭제
      // (Secure Storage의 user_info, access_token, refresh_token 모두 삭제됨)
      await ref.read(userNotifierProvider.notifier).clearUser();
      debugPrint('[LoginProvider] ✅ 사용자 정보 및 토큰 삭제 완료');

      debugPrint('[LoginProvider] ✅ 로그아웃 완료');
    } catch (e) {
      debugPrint('[LoginProvider] ❌ 로그아웃 실패: $e');
      rethrow; // 에러를 호출자에게 전파
    }
  }
}

/// 자동 로그인 상태 Provider
///
/// 사용자가 "자동로그인" 체크박스를 선택했는지 여부를 관리합니다.
/// SharedPreferences에 저장되어 앱 재시작 시에도 유지됩니다.
@riverpod
class RememberMeNotifier extends _$RememberMeNotifier {
  @override
  bool build() {
    // TODO: SharedPreferences에서 자동로그인 설정 불러오기
    // final prefs = await SharedPreferences.getInstance();
    // return prefs.getBool('remember_me') ?? false;

    // 임시: 기본값 false
    return false;
  }

  /// 자동로그인 설정 토글
  ///
  /// [value] true: 자동로그인 활성화, false: 비활성화
  Future<void> setRememberMe(bool value) async {
    try {
      // TODO: SharedPreferences에 저장
      // final prefs = await SharedPreferences.getInstance();
      // await prefs.setBool('remember_me', value);

      debugPrint('[RememberMe] 자동로그인 설정: $value');

      // 상태 업데이트
      state = value;
    } catch (e) {
      debugPrint('[RememberMe] ❌ 저장 실패: $e');
    }
  }
}
