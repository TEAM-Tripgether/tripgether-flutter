import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter/foundation.dart';
import '../../../core/services/auth/google_auth_service.dart';

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

    // ✅ AsyncValue.guard()로 자동 상태 관리 (loading → data/error)
    state = const AsyncValue.loading();

    // guard()는 try-catch를 자동으로 처리하고 AsyncValue를 반환
    state = await AsyncValue.guard(() async {
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
    });

    // state가 성공인지 확인하여 boolean 반환
    return state.hasValue && !state.hasError;
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

    // ✅ 로딩 상태 시작
    state = const AsyncValue.loading();

    try {
      // 1. GoogleAuthService를 통해 구글 로그인 실행
      final googleUser = await GoogleAuthService.signIn();

      // 사용자가 로그인을 취소한 경우
      if (googleUser == null) {
        debugPrint('[LoginProvider] ℹ️ 구글 로그인 취소됨');
        // 취소는 에러가 아니므로 data 상태로 설정
        state = const AsyncValue.data(null);
        return false;
      }

      // 2. guard()로 나머지 로직 실행 (자동 에러 처리)
      state = await AsyncValue.guard(() async {
        // 구글 인증 정보 가져오기 (accessToken, idToken)
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

        // TODO: 3. 백엔드 API에 구글 토큰 전송하여 JWT 발급받기
        // POST /auth/google/login
        // Body:
        // {
        //   "idToken": googleAuth.idToken,        // ⭐ 필수: 백엔드에서 검증
        //   "email": googleUser.email,             // 필수
        //   "displayName": googleUser.displayName, // 선택
        //   "photoUrl": googleUser.photoUrl,       // 선택
        //   "googleId": googleUser.id              // 선택
        // }
        //
        // final response = await ref.read(authServiceProvider).loginWithGoogle(
        //   idToken: googleAuth.idToken!,
        //   email: googleUser.email,
        //   displayName: googleUser.displayName,
        //   photoUrl: googleUser.photoUrl,
        //   googleId: googleUser.id,
        // );
        //
        // TODO: 4. 발급받은 JWT 토큰을 안전하게 저장
        // await ref.read(secureStorageProvider).write(
        //   key: 'access_token',
        //   value: response.accessToken,
        // );
        //
        // TODO: 5. 사용자 정보를 앱 상태에 저장
        // ref.read(userProvider.notifier).setUser(response.user);

        debugPrint('[LoginProvider] ✅ 구글 로그인 성공!');
        debugPrint('  👤 사용자: ${googleUser.email}');
        debugPrint('  🏠 홈 화면으로 이동 예정');
      });

      // state가 성공인지 확인하여 boolean 반환
      return state.hasValue && !state.hasError;
    } catch (e) {
      // 취소 예외 감지: 사용자가 로그인을 취소한 경우
      final errorString = e.toString();
      if (errorString.contains('canceled') ||
          errorString.contains('cancelled') ||
          errorString.contains('GoogleSignInExceptionCode.canceled')) {
        debugPrint('[LoginProvider] ℹ️ 구글 로그인 취소됨 (예외 경로)');
        // 취소는 에러가 아니므로 data 상태로 설정
        state = const AsyncValue.data(null);
        return false;
      }

      // 실제 에러: AsyncValue.error로 상태 업데이트
      debugPrint('[LoginProvider] ❌ 구글 로그인 실패: $e');
      state = AsyncValue.error(e, StackTrace.current);
      return false;
    }
  }

  /// 로그아웃
  ///
  /// 저장된 토큰을 삭제하고 사용자 정보를 초기화합니다.
  Future<void> logout() async {
    try {
      // TODO: 토큰 삭제
      // await ref.read(secureStorageProvider).delete(key: 'access_token');
      //
      // TODO: 사용자 정보 초기화
      // ref.read(userProvider.notifier).clearUser();

      debugPrint('[LoginProvider] ✅ 로그아웃 완료');

      // 상태 초기화
      state = const AsyncValue.data(null);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
      debugPrint('[LoginProvider] ❌ 로그아웃 실패: $e');
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
