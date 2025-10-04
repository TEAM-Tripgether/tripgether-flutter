import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_sign_in/google_sign_in.dart';

/// Google 소셜 로그인 서비스
///
/// iOS와 Android에서 Google 계정을 통한 로그인 기능을 제공합니다.
/// iOS는 .env 파일의 클라이언트 ID를 사용하고,
/// Android는 Google Play Services가 자동으로 처리합니다.
class GoogleAuthService {
  /// Google Sign-In 초기화
  ///
  /// iOS의 경우 .env 파일에서 GOOGLE_IOS_CLIENT_ID를 읽어 초기화합니다.
  /// Android는 자동으로 처리됩니다.
  static Future<void> initialize() async {
    try {
      await GoogleSignIn.instance.initialize(
        // iOS만 클라이언트 ID 필요 (Android는 자동 처리)
        clientId: Platform.isIOS ? dotenv.env['GOOGLE_IOS_CLIENT_ID'] : null,
      );
      debugPrint('[GoogleAuthService] ✅ Google Sign-In 초기화 완료');
    } catch (error) {
      debugPrint('[GoogleAuthService] 🚨 Google Sign-In 초기화 오류: $error');
      rethrow;
    }
  }

  /// Google 로그인을 시작합니다
  ///
  /// Returns:
  /// - 성공 시: GoogleSignInAccount 객체 (사용자 정보 포함)
  /// - 실패 또는 취소 시: null
  ///
  /// Throws:
  /// - Exception: 로그인 프로세스 중 오류 발생 시
  static Future<GoogleSignInAccount?> signIn() async {
    try {
      // authenticate 지원 확인
      if (!GoogleSignIn.instance.supportsAuthenticate()) {
        debugPrint('[GoogleAuthService] ❌ 이 플랫폼은 Google 인증을 지원하지 않습니다');
        return null;
      }

      debugPrint('[GoogleAuthService] 🔄 Google 로그인 시작...');

      GoogleSignInAccount? account;

      // 이벤트 스트림을 먼저 구독한 다음 authenticate 호출
      final completer = Completer<GoogleSignInAccount?>();
      late StreamSubscription<GoogleSignInAuthenticationEvent> subscription;

      subscription = GoogleSignIn.instance.authenticationEvents.listen(
        (event) {
          debugPrint('[GoogleAuthService] 📨 이벤트 수신: ${event.runtimeType}');

          if (event is GoogleSignInAuthenticationEventSignIn) {
            account = event.user;
            debugPrint(
              '[GoogleAuthService] ✅ SignIn 이벤트 - 사용자: ${event.user.email}',
            );
            subscription.cancel();
            completer.complete(account);
          } else if (event is GoogleSignInAuthenticationEventSignOut) {
            debugPrint('[GoogleAuthService] 🚪 SignOut 이벤트 - 로그인 취소됨');
            subscription.cancel();
            completer.complete(null);
          }
        },
        onError: (error) {
          debugPrint('[GoogleAuthService] 🚨 이벤트 스트림 오류: $error');
          subscription.cancel();
          completer.completeError(error);
        },
      );

      // 구독 후 authenticate 호출
      try {
        await GoogleSignIn.instance.authenticate(
          scopeHint: [
            'email', // 이메일 정보 요청
            'profile', // 프로필 정보 요청
          ],
        );
      } catch (e) {
        subscription.cancel();
        rethrow;
      }

      // 이벤트 결과를 최대 10초 대기
      account = await completer.future.timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          debugPrint('[GoogleAuthService] ⏱️ 타임아웃: 10초 내에 인증 이벤트를 받지 못했습니다');
          subscription.cancel();
          return null;
        },
      );

      if (account != null) {
        // 인증 정보 가져오기 (accessToken, idToken)
        final auth = account!.authentication;

        // 디버그 로그 출력
        debugPrint('[GoogleAuthService] ✅ Google 로그인 성공');
        debugPrint('[GoogleAuthService] 📧 Email: ${account!.email}');
        debugPrint(
          '[GoogleAuthService] 👤 Display Name: ${account!.displayName}',
        );
        debugPrint(
          '[GoogleAuthService] 🔑 ID Token: ${auth.idToken?.substring(0, 20)}...',
        );

        return account;
      }

      debugPrint('[GoogleAuthService] ❌ Google 로그인 취소됨');
      return null;
    } catch (error) {
      debugPrint('[GoogleAuthService] 🚨 Google 로그인 오류: $error');
      rethrow;
    }
  }

  /// Google 로그아웃을 수행합니다
  ///
  /// 로그인 상태를 완전히 초기화하고 Google 계정 연결을 해제합니다.
  static Future<void> signOut() async {
    try {
      await GoogleSignIn.instance.disconnect();
      debugPrint('[GoogleAuthService] ✅ Google 로그아웃 성공');
    } catch (error) {
      debugPrint('[GoogleAuthService] 🚨 Google 로그아웃 오류: $error');
      rethrow;
    }
  }
}
