import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// JWT 토큰 중앙 관리 서비스 (싱글톤)
///
/// **역할**:
/// 1. 메모리 캐시 + FlutterSecureStorage 통합 관리
/// 2. Race Condition 방지 (메모리 캐시 우선 읽기)
/// 3. UserProvider, AuthInterceptor 모두 이 클래스 사용
///
/// **메모리 캐시 우선 전략**:
/// - 저장: 메모리 즉시 저장 (동기) → FlutterSecureStorage 비동기 저장
/// - 읽기: 메모리 캐시 먼저 확인 → 없으면 Storage에서 읽기 → 캐시에 저장
///
/// **Race Condition 해결**:
/// - 로그인 후 HomeScreen 진입 시 두 API 동시 호출
/// - FlutterSecureStorage 저장 지연 문제 → 메모리 캐시로 즉시 읽기 가능
class TokenManager {
  // ══════════════════════════════════════════════════════════════════════════
  // 싱글톤 패턴
  // ══════════════════════════════════════════════════════════════════════════

  static final TokenManager _instance = TokenManager._internal();

  /// 싱글톤 인스턴스 반환
  factory TokenManager() => _instance;

  TokenManager._internal();

  // ══════════════════════════════════════════════════════════════════════════
  // Storage 및 캐시
  // ══════════════════════════════════════════════════════════════════════════

  /// FlutterSecureStorage 인스턴스
  ///
  /// **플랫폼별 동작**:
  /// - Android: EncryptedSharedPreferences
  /// - iOS: Keychain (unlocked_this_device)
  static const FlutterSecureStorage _storage = FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
    iOptions: IOSOptions(
      accessibility: KeychainAccessibility.unlocked_this_device,
    ),
  );

  /// Access Token 저장 키
  static const String _accessTokenKey = 'access_token';

  /// Refresh Token 저장 키
  static const String _refreshTokenKey = 'refresh_token';

  /// Access Token 메모리 캐시
  ///
  /// FlutterSecureStorage의 비동기 저장 지연 문제를 해결하기 위한 메모리 캐시
  /// - 저장 시 즉시 메모리에 캐싱 (동기) → 즉시 사용 가능
  /// - 읽기 시 메모리 캐시 우선 확인 (즉시 반환)
  String? _accessTokenCache;

  /// Refresh Token 메모리 캐시
  String? _refreshTokenCache;

  // ══════════════════════════════════════════════════════════════════════════
  // Access Token 관리
  // ══════════════════════════════════════════════════════════════════════════

  /// Access Token 저장 (메모리 + Storage)
  ///
  /// **저장 순서**:
  /// 1. 메모리 캐시에 즉시 저장 (동기) → 즉시 사용 가능
  /// 2. FlutterSecureStorage에 비동기 저장 → 영구 보관
  ///
  /// **Race Condition 방지**:
  /// - 저장 직후 즉시 API 호출해도 메모리 캐시에서 읽기 가능
  Future<void> saveAccessToken(String token) async {
    try {
      // 1. 메모리 캐시에 즉시 저장 (동기)
      _accessTokenCache = token;
      debugPrint('[TokenManager] 🔑 Access Token 메모리 캐시 저장 완료');

      // 2. FlutterSecureStorage에 비동기 저장
      await _storage.write(key: _accessTokenKey, value: token);
      debugPrint('[TokenManager] 💾 Access Token Storage 저장 완료');
    } catch (e) {
      debugPrint('[TokenManager] ❌ Access Token 저장 실패: $e');
      rethrow;
    }
  }

  /// Access Token 읽기 (메모리 캐시 우선)
  ///
  /// **읽기 순서**:
  /// 1. 메모리 캐시에서 먼저 확인 → 있으면 즉시 반환 (동기)
  /// 2. 캐시 없으면 FlutterSecureStorage에서 읽기 → 캐시에 저장 후 반환
  ///
  /// **성능 최적화**:
  /// - 메모리 캐시 hit 시 FlutterSecureStorage I/O 스킵
  /// - 로그인 직후 API 호출 시 즉시 토큰 사용 가능
  Future<String?> getAccessToken() async {
    try {
      // 1. 메모리 캐시 우선 확인
      if (_accessTokenCache != null) {
        debugPrint('[TokenManager] 🔍 Access Token 메모리 캐시 hit');
        return _accessTokenCache;
      }

      // 2. 캐시 없으면 Storage에서 읽기
      debugPrint('[TokenManager] 🔍 Access Token Storage에서 읽기');
      _accessTokenCache = await _storage.read(key: _accessTokenKey);

      if (_accessTokenCache != null) {
        debugPrint('[TokenManager] ✅ Access Token 조회 성공 (Storage → 캐시)');
      } else {
        debugPrint('[TokenManager] ⚠️ Access Token 없음 (로그아웃 상태 또는 최초 진입)');
      }

      return _accessTokenCache;
    } catch (e) {
      debugPrint('[TokenManager] ❌ Access Token 읽기 실패: $e');
      return null;
    }
  }

  // ══════════════════════════════════════════════════════════════════════════
  // Refresh Token 관리
  // ══════════════════════════════════════════════════════════════════════════

  /// Refresh Token 저장 (메모리 + Storage)
  Future<void> saveRefreshToken(String token) async {
    try {
      // 1. 메모리 캐시에 즉시 저장
      _refreshTokenCache = token;
      debugPrint('[TokenManager] 🔑 Refresh Token 메모리 캐시 저장 완료');

      // 2. FlutterSecureStorage에 비동기 저장
      await _storage.write(key: _refreshTokenKey, value: token);
      debugPrint('[TokenManager] 💾 Refresh Token Storage 저장 완료');
    } catch (e) {
      debugPrint('[TokenManager] ❌ Refresh Token 저장 실패: $e');
      rethrow;
    }
  }

  /// Refresh Token 읽기 (메모리 캐시 우선)
  Future<String?> getRefreshToken() async {
    try {
      // 1. 메모리 캐시 우선 확인
      if (_refreshTokenCache != null) {
        debugPrint('[TokenManager] 🔍 Refresh Token 메모리 캐시 hit');
        return _refreshTokenCache;
      }

      // 2. 캐시 없으면 Storage에서 읽기
      debugPrint('[TokenManager] 🔍 Refresh Token Storage에서 읽기');
      _refreshTokenCache = await _storage.read(key: _refreshTokenKey);

      if (_refreshTokenCache != null) {
        debugPrint('[TokenManager] ✅ Refresh Token 조회 성공 (Storage → 캐시)');
      } else {
        debugPrint('[TokenManager] ⚠️ Refresh Token 없음');
      }

      return _refreshTokenCache;
    } catch (e) {
      debugPrint('[TokenManager] ❌ Refresh Token 읽기 실패: $e');
      return null;
    }
  }

  // ══════════════════════════════════════════════════════════════════════════
  // 토큰 삭제 (로그아웃)
  // ══════════════════════════════════════════════════════════════════════════

  /// JWT 토큰 삭제 (로그아웃 시)
  ///
  /// **삭제 대상**:
  /// 1. 메모리 캐시 (Access + Refresh)
  /// 2. FlutterSecureStorage (Access + Refresh)
  Future<void> deleteTokens() async {
    try {
      // 1. 메모리 캐시 초기화
      _accessTokenCache = null;
      _refreshTokenCache = null;
      debugPrint('[TokenManager] 🗑️ 메모리 캐시 초기화 완료');

      // 2. FlutterSecureStorage 삭제
      await _storage.delete(key: _accessTokenKey);
      await _storage.delete(key: _refreshTokenKey);
      debugPrint('[TokenManager] 🗑️ Storage 토큰 삭제 완료 (Access + Refresh)');
    } catch (e) {
      debugPrint('[TokenManager] ❌ 토큰 삭제 실패: $e');
      rethrow;
    }
  }

  // ══════════════════════════════════════════════════════════════════════════
  // 토큰 유효성 검증
  // ══════════════════════════════════════════════════════════════════════════

  /// Access Token이 존재하는지 확인 (간단한 검증)
  ///
  /// **주의**: 실제 토큰 유효성은 서버에서 검증
  /// 이 메서드는 토큰 존재 여부만 확인 (빈 문자열 체크)
  Future<bool> hasAccessToken() async {
    final token = await getAccessToken();
    return token != null && token.isNotEmpty;
  }

  /// Refresh Token이 존재하는지 확인
  Future<bool> hasRefreshToken() async {
    final token = await getRefreshToken();
    return token != null && token.isNotEmpty;
  }
}
