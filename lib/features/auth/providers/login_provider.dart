import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter/foundation.dart';

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
    // 로딩 상태로 전환
    state = const AsyncValue.loading();

    try {
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

      debugPrint('[LoginProvider] ✅ 이메일 로그인 성공: $email');

      // 임시: 성공 상태로 전환
      state = const AsyncValue.data(null);

      return true;
    } catch (e, stack) {
      // 에러 상태로 전환
      state = AsyncValue.error(e, stack);
      debugPrint('[LoginProvider] ❌ 이메일 로그인 실패: $e');
      return false;
    }
  }

  /// 구글 로그인
  ///
  /// Returns: 로그인 성공 시 true, 실패 시 false
  /// Throws: [Exception] 구글 SDK 호출 실패 시
  Future<bool> loginWithGoogle() async {
    state = const AsyncValue.loading();

    try {
      // TODO: 구글 SDK를 통한 로그인
      // 1. 구글 로그인 실행
      // final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      //
      // 2. 구글 인증 정보 가져오기
      // final GoogleSignInAuthentication googleAuth = await googleUser!.authentication;
      //
      // 3. 백엔드에 구글 토큰 전송하여 JWT 발급
      // final response = await ref.read(authServiceProvider).loginWithGoogle(
      //   googleToken: googleAuth.idToken,
      //   googleUserId: googleUser.id,
      // );
      //
      // 4. JWT 토큰 저장
      // await ref.read(secureStorageProvider).write(
      //   key: 'access_token',
      //   value: response.accessToken,
      // );

      debugPrint('[LoginProvider] ✅ 구글 로그인 성공');

      // 임시: 성공 상태로 전환
      state = const AsyncValue.data(null);

      return true;
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
      debugPrint('[LoginProvider] ❌ 구글 로그인 실패: $e');
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
