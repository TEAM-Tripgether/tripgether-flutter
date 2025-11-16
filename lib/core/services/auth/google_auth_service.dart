import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_sign_in/google_sign_in.dart';

/// Google 소셜 로그인 서비스
///
/// iOS와 Android에서 Google 계정을 통한 로그인 기능을 제공합니다.
///
/// **플랫폼별 설정**:
/// - iOS: GOOGLE_IOS_CLIENT_ID (clientId)
/// - Android: GOOGLE_WEB_CLIENT_ID (serverClientId)
///   - Android Client ID는 google-services.json에서 자동 처리됨
class GoogleAuthService {
  /// Google Sign-In 초기화
  ///
  /// **필수 환경변수**:
  /// - iOS: GOOGLE_IOS_CLIENT_ID
  /// - Android: GOOGLE_WEB_CLIENT_ID
  static Future<void> initialize() async {
    try {
      await GoogleSignIn.instance.initialize(
        // iOS: iOS Client ID 필요
        clientId: Platform.isIOS ? dotenv.env['GOOGLE_IOS_CLIENT_ID'] : null,
        // Android: Web Client ID를 serverClientId로 사용 (필수)
        serverClientId: dotenv.env['GOOGLE_WEB_CLIENT_ID'],
      );
      debugPrint('[GoogleAuthService] ✅ Google Sign-In 초기화 완료');
      debugPrint(
        '[GoogleAuthService] 🔑 Server Client ID: ${dotenv.env['GOOGLE_WEB_CLIENT_ID']?.substring(0, 20)}...',
      );
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
        debugPrint('[GoogleAuthService] 🖼️ Photo URL: ${account!.photoUrl}');
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
  /// 로그인 상태를 초기화합니다.
  /// iOS에서 disconnect()는 HTTP 400 에러를 발생시킬 수 있으므로 signOut()을 사용합니다.
  static Future<void> signOut() async {
    try {
      // iOS에서 disconnect()는 NSConcreteMutableData 직렬화 오류를 발생시킬 수 있음
      // signOut()이 더 안정적이므로 이를 사용
      await GoogleSignIn.instance.signOut();
      debugPrint('[GoogleAuthService] ✅ Google 로그아웃 성공');
    } catch (error) {
      debugPrint('[GoogleAuthService] 🚨 Google 로그아웃 오류: $error');
      rethrow;
    }
  }

  /// Google 계정 연결을 완전히 해제합니다
  ///
  /// **차이점**:
  /// - `signOut()`: 로컬 세션만 제거 (Google 서버 토큰 유지)
  /// - `disconnect()`: 서버 토큰까지 폐기 (완전 연결 해제)
  ///
  /// **사용 시나리오**:
  /// - 회원탈퇴
  /// - 완전한 로그아웃 (앱 삭제 대비)
  /// - 계정 연결 해제
  ///
  /// **주의**: disconnect() 실패 시 signOut()으로 fallback
  static Future<void> disconnect() async {
    try {
      await GoogleSignIn.instance.disconnect();
      debugPrint('[GoogleAuthService] ✅ Google 계정 연결 해제 성공 (토큰 폐기)');
    } catch (error) {
      debugPrint('[GoogleAuthService] ⚠️ disconnect 실패, signOut으로 fallback: $error');
      // disconnect 실패 시 최소한 로컬 세션은 삭제
      await signOut();
    }
  }
}
