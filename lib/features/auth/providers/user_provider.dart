import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tripgether/features/auth/data/models/user_model.dart';

part 'user_provider.g.dart';

/// 사용자 정보 상태 관리 Provider
///
/// **역할**:
/// - 로그인 시 사용자 정보를 Secure Storage에 저장
/// - 앱 시작 시 저장된 사용자 정보를 자동으로 로드
/// - 로그아웃 시 사용자 정보를 삭제
///
/// **사용 위치**:
/// - LoginProvider: 로그인 성공 시 `setUser()` 호출
/// - ProfileHeader: 사용자 정보 표시를 위해 `watch(userNotifierProvider)` 사용
/// - 전역: 사용자 로그인 상태 확인
///
/// **상태 타입**: `AsyncValue<User?>`
/// - `AsyncValue.data(User)`: 로그인된 사용자
/// - `AsyncValue.data(null)`: 로그인하지 않은 상태
/// - `AsyncValue.loading()`: 로딩 중
/// - `AsyncValue.error()`: 에러 발생
@Riverpod(keepAlive: true)
class UserNotifier extends _$UserNotifier {
  /// Flutter Secure Storage 인스턴스
  ///
  /// 사용자 정보와 토큰을 안전하게 저장하는 보안 저장소입니다.
  /// - Android: EncryptedSharedPreferences
  /// - iOS: Keychain
  static const _storage = FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
  );

  /// 사용자 정보 저장 키
  static const String _userKey = 'user_info';

  /// Access Token 저장 키
  static const String _accessTokenKey = 'access_token';

  /// Refresh Token 저장 키
  static const String _refreshTokenKey = 'refresh_token';

  /// Provider 초기화
  ///
  /// 앱 시작 시 자동으로 호출되며, Secure Storage에서 저장된 사용자 정보를 로드합니다.
  ///
  /// **흐름**:
  /// 1. Secure Storage에서 'user_info' 키로 저장된 JSON 문자열 읽기
  /// 2. JSON 문자열을 User 객체로 역직렬화
  /// 3. User 객체 반환 (없으면 null)
  ///
  /// Returns: `AsyncValue<User?>` - 로그인된 사용자 또는 null
  @override
  Future<User?> build() async {
    debugPrint('[UserNotifier] 📱 Provider 초기화 시작');

    try {
      // Secure Storage에서 사용자 정보 로드
      final user = await _loadUserFromStorage();

      if (user != null) {
        debugPrint('[UserNotifier] ✅ 저장된 사용자 정보 로드 성공: ${user.email}');
        return user;
      } else {
        debugPrint('[UserNotifier] ℹ️ 저장된 사용자 정보 없음 (로그인 필요)');
        return null;
      }
    } catch (e, stackTrace) {
      debugPrint('[UserNotifier] ❌ 사용자 정보 로드 실패: $e');
      debugPrint('[UserNotifier] Stack trace: $stackTrace');
      return null;
    }
  }

  /// 로그인 시 사용자 정보 저장
  ///
  /// Google 로그인 성공 후 받은 사용자 정보를 저장합니다.
  ///
  /// **호출 위치**: LoginProvider.loginWithGoogle()
  ///
  /// **저장 내용**:
  /// - 사용자 정보 (User 객체)
  /// - Access Token
  /// - Refresh Token
  ///
  /// **흐름**:
  /// 1. User 객체를 JSON으로 직렬화
  /// 2. Secure Storage에 저장
  /// 3. Provider 상태를 AsyncValue.data(user)로 업데이트
  ///
  /// [user] Google 로그인으로 받은 사용자 정보
  /// [accessToken] JWT Access Token (유효기간: 1시간)
  /// [refreshToken] JWT Refresh Token (유효기간: 7일)
  Future<void> setUser({
    required User user,
    required String accessToken,
    required String refreshToken,
  }) async {
    debugPrint('[UserNotifier] 💾 사용자 정보 저장 시작');
    debugPrint('[UserNotifier] Email: ${user.email}');
    debugPrint('[UserNotifier] Nickname: ${user.nickname}');

    try {
      // 1. Secure Storage에 사용자 정보 저장
      await _saveUserToStorage(user);

      // 2. 토큰 저장
      await _saveTokensToStorage(
        accessToken: accessToken,
        refreshToken: refreshToken,
      );

      // 3. Provider 상태 업데이트 (UI 자동 반영)
      // AsyncNotifier는 자체적으로 lifecycle을 관리하므로 체크 불필요
      state = AsyncValue.data(user);

      debugPrint('[UserNotifier] ✅ 사용자 정보 저장 완료');
    } catch (e, stackTrace) {
      debugPrint('[UserNotifier] ❌ 사용자 정보 저장 실패: $e');
      debugPrint('[UserNotifier] Stack trace: $stackTrace');

      // 에러 상태로 업데이트
      state = AsyncValue.error(e, stackTrace);

      rethrow;
    }
  }

  /// 로그아웃 시 사용자 정보 삭제
  ///
  /// **호출 위치**: LoginProvider.logout()
  ///
  /// **삭제 내용**:
  /// - 사용자 정보 (User 객체)
  /// - Access Token
  /// - Refresh Token
  ///
  /// **흐름**:
  /// 1. Secure Storage에서 모든 키 삭제
  /// 2. Provider 상태를 AsyncValue.data(null)로 업데이트
  /// 3. UI는 자동으로 "로그인 필요" 상태로 전환
  Future<void> clearUser() async {
    debugPrint('[UserNotifier] 🗑️ 사용자 정보 삭제 시작');

    try {
      // 1. Secure Storage에서 사용자 정보 삭제
      await _deleteUserFromStorage();

      // 2. 토큰 삭제
      await _deleteTokensFromStorage();

      // 3. Provider 상태 업데이트 (로그아웃 상태)
      state = const AsyncValue.data(null);

      debugPrint('[UserNotifier] ✅ 사용자 정보 삭제 완료');
    } catch (e, stackTrace) {
      debugPrint('[UserNotifier] ❌ 사용자 정보 삭제 실패: $e');
      debugPrint('[UserNotifier] Stack trace: $stackTrace');

      // 에러가 발생해도 상태는 null로 설정 (로그아웃은 항상 성공해야 함)
      state = const AsyncValue.data(null);
    }
  }

  /// 사용자 정보 업데이트
  ///
  /// 프로필 수정 시 사용합니다.
  ///
  /// **사용 예시**:
  /// ```dart
  /// await ref.read(userNotifierProvider.notifier).updateUser(
  ///   currentUser.copyWith(
  ///     nickname: '새로운 닉네임',
  ///     profileImageUrl: '새로운 이미지 URL',
  ///   ),
  /// );
  /// ```
  ///
  /// [user] 업데이트된 사용자 정보
  Future<void> updateUser(User user) async {
    debugPrint('[UserNotifier] 🔄 사용자 정보 업데이트 시작');

    try {
      // 1. Secure Storage에 업데이트된 정보 저장
      await _saveUserToStorage(user);

      // 2. Provider 상태 업데이트
      state = AsyncValue.data(user);

      debugPrint('[UserNotifier] ✅ 사용자 정보 업데이트 완료');
    } catch (e, stackTrace) {
      debugPrint('[UserNotifier] ❌ 사용자 정보 업데이트 실패: $e');
      debugPrint('[UserNotifier] Stack trace: $stackTrace');

      state = AsyncValue.error(e, stackTrace);

      rethrow;
    }
  }

  // ══════════════════════════════════════════════════════════════════════════
  // Private Helper Methods - Secure Storage 연동
  // ══════════════════════════════════════════════════════════════════════════

  /// Secure Storage에서 사용자 정보 로드
  ///
  /// **동작**:
  /// 1. 'user_info' 키로 저장된 JSON 문자열 읽기
  /// 2. JSON 문자열을 Map으로 파싱
  /// 3. Map을 User 객체로 역직렬화 (Freezed 자동 생성 메서드 사용)
  ///
  /// Returns: User 객체 또는 null (저장된 정보 없음)
  Future<User?> _loadUserFromStorage() async {
    try {
      final userJson = await _storage.read(key: _userKey);

      if (userJson == null || userJson.isEmpty) {
        return null;
      }

      // JSON 문자열 → Map → User 객체
      final decoded = jsonDecode(userJson);

      // 타입 안정성 체크 (List가 아닌 Map인지 확인)
      if (decoded is! Map<String, dynamic>) {
        debugPrint('[UserNotifier] ⚠️ 잘못된 JSON 형식: Map이 아닙니다');
        return null;
      }

      return User.fromJson(decoded);
    } catch (e) {
      debugPrint('[UserNotifier] ⚠️ Storage에서 사용자 정보 로드 실패: $e');
      return null;
    }
  }

  /// Secure Storage에 사용자 정보 저장
  ///
  /// **동작**:
  /// 1. User 객체를 JSON Map으로 직렬화 (Freezed 자동 생성 메서드 사용)
  /// 2. Map을 JSON 문자열로 변환
  /// 3. 'user_info' 키로 Secure Storage에 저장
  ///
  /// [user] 저장할 사용자 정보
  Future<void> _saveUserToStorage(User user) async {
    try {
      // User 객체 → Map → JSON 문자열
      final userMap = user.toJson();
      final userJson = jsonEncode(userMap);

      await _storage.write(key: _userKey, value: userJson);
    } catch (e) {
      debugPrint('[UserNotifier] ⚠️ Storage에 사용자 정보 저장 실패: $e');
      rethrow;
    }
  }

  /// Secure Storage에서 사용자 정보 삭제
  Future<void> _deleteUserFromStorage() async {
    try {
      await _storage.delete(key: _userKey);
    } catch (e) {
      debugPrint('[UserNotifier] ⚠️ Storage에서 사용자 정보 삭제 실패: $e');
      // 삭제 실패는 무시 (이미 없을 수 있음)
    }
  }

  /// Secure Storage에 JWT 토큰 저장
  ///
  /// **저장 내용**:
  /// - Access Token: API 요청 시 Authorization 헤더에 사용
  /// - Refresh Token: Access Token 만료 시 재발급에 사용
  ///
  /// [accessToken] JWT Access Token (유효기간: 1시간)
  /// [refreshToken] JWT Refresh Token (유효기간: 7일)
  Future<void> _saveTokensToStorage({
    required String accessToken,
    required String refreshToken,
  }) async {
    try {
      await _storage.write(key: _accessTokenKey, value: accessToken);
      await _storage.write(key: _refreshTokenKey, value: refreshToken);

      debugPrint('[UserNotifier] 🔑 토큰 저장 완료');
    } catch (e) {
      debugPrint('[UserNotifier] ⚠️ 토큰 저장 실패: $e');
      rethrow;
    }
  }

  /// Secure Storage에서 JWT 토큰 삭제
  Future<void> _deleteTokensFromStorage() async {
    try {
      await _storage.delete(key: _accessTokenKey);
      await _storage.delete(key: _refreshTokenKey);

      debugPrint('[UserNotifier] 🔑 토큰 삭제 완료');
    } catch (e) {
      debugPrint('[UserNotifier] ⚠️ 토큰 삭제 실패: $e');
      // 삭제 실패는 무시
    }
  }
}

/// Access Token 읽기 Provider
///
/// API 요청 시 Authorization 헤더에 사용합니다.
///
/// **사용 예시**:
/// ```dart
/// final accessToken = await ref.read(accessTokenProvider.future);
/// if (accessToken != null) {
///   dio.options.headers['Authorization'] = 'Bearer $accessToken';
/// }
/// ```
@riverpod
Future<String?> accessToken(Ref ref) async {
  try {
    // UserNotifier의 storage 인스턴스 재사용 (메모리 효율)
    return await UserNotifier._storage.read(key: UserNotifier._accessTokenKey);
  } catch (e) {
    debugPrint('[AccessTokenProvider] ❌ Access Token 읽기 실패: $e');
    return null;
  }
}

/// Refresh Token 읽기 Provider
///
/// Access Token 재발급 시 사용합니다.
///
/// **사용 예시**:
/// ```dart
/// final refreshToken = await ref.read(refreshTokenProvider.future);
/// if (refreshToken != null) {
///   final newTokens = await authService.reissueToken(refreshToken);
/// }
/// ```
@riverpod
Future<String?> refreshToken(Ref ref) async {
  try {
    // UserNotifier의 storage 인스턴스 재사용 (메모리 효율)
    return await UserNotifier._storage.read(key: UserNotifier._refreshTokenKey);
  } catch (e) {
    debugPrint('[RefreshTokenProvider] ❌ Refresh Token 읽기 실패: $e');
    return null;
  }
}
