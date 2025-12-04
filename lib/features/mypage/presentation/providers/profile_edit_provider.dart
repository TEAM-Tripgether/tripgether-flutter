import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tripgether/core/network/auth_interceptor.dart';
import 'package:tripgether/core/utils/api_logger.dart';
import 'package:tripgether/features/auth/providers/user_provider.dart';

part 'profile_edit_provider.g.dart';

/// 프로필 편집 상태
enum ProfileEditState {
  /// 초기 상태
  initial,

  /// 로딩 중
  loading,

  /// 성공
  success,

  /// 실패
  error,
}

/// 프로필 편집 Provider
///
/// **기능**:
/// - 프로필 정보 수정 (POST /api/members/profile)
/// - 회원 탈퇴 (DELETE /api/auth/withdraw)
///
/// **API 문서**: docs/BackendAPI.md
@riverpod
class ProfileEditNotifier extends _$ProfileEditNotifier {
  late final Dio _dio;

  /// API Base URL
  static String get _baseUrl {
    const dartDefine = String.fromEnvironment('API_BASE_URL');
    if (dartDefine.isNotEmpty) return dartDefine;
    return dotenv.env['API_BASE_URL'] ?? 'https://api.tripgether.suhsaechan.kr';
  }

  /// Mock API 사용 여부
  static bool get _useMockData {
    const dartDefine = String.fromEnvironment('USE_MOCK_API');
    if (dartDefine.isNotEmpty) {
      return dartDefine.toLowerCase() == 'true';
    }
    final envValue = dotenv.env['USE_MOCK_API'];
    if (envValue != null) {
      return envValue.toLowerCase() == 'true';
    }
    return true;
  }

  @override
  ProfileEditState build() {
    _dio = Dio(
      BaseOptions(
        baseUrl: _baseUrl,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
      ),
    );
    _dio.interceptors.add(AuthInterceptor(baseUrl: _baseUrl));

    return ProfileEditState.initial;
  }

  /// 프로필 업데이트
  ///
  /// **API**: POST /api/members/profile
  ///
  /// **Request Body**:
  /// - name (필수): 닉네임 (2-50자)
  /// - gender (선택): 성별 (MALE, FEMALE, NOT_SELECTED)
  /// - birthDate (선택): 생년월일 (yyyy-MM-dd)
  /// - interestIds (선택): 관심사 ID 목록
  ///
  /// **Response**: 업데이트된 MemberDto
  Future<void> updateProfile({
    required String name,
    String? gender,
    DateTime? birthDate,
    List<String>? interestIds,
  }) async {
    state = ProfileEditState.loading;

    if (_useMockData) {
      await _mockUpdateProfile(
        name: name,
        gender: gender,
        birthDate: birthDate,
      );
      return;
    }

    try {
      final requestData = <String, dynamic>{
        'name': name,
      };

      if (gender != null) {
        requestData['gender'] = gender;
      }

      if (birthDate != null) {
        // LocalDate 형식: yyyy-MM-dd
        requestData['birthDate'] =
            '${birthDate.year}-${birthDate.month.toString().padLeft(2, '0')}-${birthDate.day.toString().padLeft(2, '0')}';
      }

      if (interestIds != null && interestIds.isNotEmpty) {
        requestData['interestIds'] = interestIds;
      }

      debugPrint('[ProfileEditProvider] 📤 프로필 업데이트 요청: $requestData');

      final response = await _dio.post(
        '/api/members/profile',
        data: requestData,
      );

      debugPrint('[ProfileEditProvider] ✅ 프로필 업데이트 성공: ${response.data}');

      // UserNotifier 업데이트
      await _updateLocalUser(response.data);

      state = ProfileEditState.success;
    } on DioException catch (e) {
      state = ProfileEditState.error;
      ApiLogger.throwFromDioError(
        e,
        context: 'ProfileEditProvider.updateProfile',
      );
    } catch (e) {
      state = ProfileEditState.error;
      debugPrint('[ProfileEditProvider] ❌ 프로필 업데이트 실패: $e');
      rethrow;
    }
  }

  /// 로컬 사용자 정보 업데이트
  Future<void> _updateLocalUser(Map<String, dynamic> responseData) async {
    try {
      final userNotifier = ref.read(userNotifierProvider.notifier);
      final currentUser = ref.read(userNotifierProvider).valueOrNull;

      if (currentUser != null) {
        // 서버 응답으로 User 객체 업데이트
        final updatedUser = currentUser.copyWith(
          nickname: responseData['name'] as String? ?? currentUser.nickname,
          gender: responseData['gender'] as String?,
          birthDate: responseData['birthDate'] as String?,
          onboardingStatus: responseData['onboardingStatus'] as String?,
        );

        await userNotifier.updateUser(updatedUser);
        debugPrint('[ProfileEditProvider] ✅ 로컬 사용자 정보 업데이트 완료');
      }
    } catch (e) {
      debugPrint('[ProfileEditProvider] ⚠️ 로컬 사용자 정보 업데이트 실패: $e');
    }
  }

  /// 닉네임 중복 확인
  ///
  /// **API**: GET /api/members/check-name?name={닉네임}
  ///
  /// **인증**: 불필요
  ///
  /// **Response**: `CheckNameResponse`
  /// ```json
  /// {
  ///   "isAvailable": true,
  ///   "name": "여행러버"
  /// }
  /// ```
  ///
  /// **에러 코드**:
  /// - `INVALID_NAME_LENGTH`: 닉네임은 2자 이상 50자 이하여야 합니다.
  Future<bool> checkNickname(String name) async {
    if (_useMockData) {
      return _mockCheckNickname(name);
    }

    try {
      debugPrint('[ProfileEditProvider] 📤 닉네임 중복 확인: $name');

      final response = await _dio.get(
        '/api/members/check-name',
        queryParameters: {'name': name},
      );

      debugPrint('[ProfileEditProvider] ✅ 닉네임 중복 확인 성공: ${response.data}');

      final isAvailable = response.data['isAvailable'] as bool? ?? false;
      return isAvailable;
    } on DioException catch (e) {
      debugPrint('[ProfileEditProvider] ⚠️ 닉네임 중복 확인 실패: ${e.message}');
      // API 호출 실패 시 false 반환 (안전하게 처리)
      return false;
    } catch (e) {
      debugPrint('[ProfileEditProvider] ⚠️ 닉네임 중복 확인 실패: $e');
      return false;
    }
  }

  /// 사용자 관심사 조회
  ///
  /// **API**: GET /api/members/{memberId}/interests
  ///
  /// **Response**: `List<InterestDto>`
  /// ```json
  /// [
  ///   {"id": "...", "name": "한식"},
  ///   {"id": "...", "name": "카페투어"}
  /// ]
  /// ```
  Future<List<Map<String, dynamic>>?> getUserInterests(String memberId) async {
    if (_useMockData) {
      return _mockGetUserInterests();
    }

    try {
      debugPrint('[ProfileEditProvider] 📤 사용자 관심사 조회: $memberId');

      final response = await _dio.get('/api/members/$memberId/interests');

      debugPrint('[ProfileEditProvider] ✅ 사용자 관심사 조회 성공: ${response.data}');

      if (response.data is List) {
        return (response.data as List)
            .map((e) => e as Map<String, dynamic>)
            .toList();
      }
      return null;
    } on DioException catch (e) {
      debugPrint('[ProfileEditProvider] ⚠️ 사용자 관심사 조회 실패: ${e.message}');
      return null;
    } catch (e) {
      debugPrint('[ProfileEditProvider] ⚠️ 사용자 관심사 조회 실패: $e');
      return null;
    }
  }

  /// 회원 탈퇴
  ///
  /// **API**: DELETE /api/auth/withdraw
  ///
  /// **인증**: 필요 (JWT)
  ///
  /// **동작**:
  /// - 서버에서 회원 정보 소프트 삭제 처리
  /// - 로컬 토큰 및 사용자 정보 삭제는 호출측에서 처리
  Future<void> withdrawMember() async {
    state = ProfileEditState.loading;

    if (_useMockData) {
      await _mockWithdraw();
      return;
    }

    try {
      debugPrint('[ProfileEditProvider] 📤 회원 탈퇴 요청');

      await _dio.delete('/api/auth/withdraw');

      debugPrint('[ProfileEditProvider] ✅ 회원 탈퇴 성공');
      state = ProfileEditState.success;
    } on DioException catch (e) {
      state = ProfileEditState.error;
      ApiLogger.throwFromDioError(
        e,
        context: 'ProfileEditProvider.withdrawMember',
      );
    } catch (e) {
      state = ProfileEditState.error;
      debugPrint('[ProfileEditProvider] ❌ 회원 탈퇴 실패: $e');
      rethrow;
    }
  }

  // ══════════════════════════════════════════════════════════════════════════
  // Mock 메서드
  // ══════════════════════════════════════════════════════════════════════════

  /// Mock 프로필 업데이트
  Future<void> _mockUpdateProfile({
    required String name,
    String? gender,
    DateTime? birthDate,
  }) async {
    debugPrint('[ProfileEditProvider] 🧪 Mock 프로필 업데이트');

    // 네트워크 지연 시뮬레이션
    await Future.delayed(const Duration(milliseconds: 500));

    // 로컬 사용자 정보 업데이트
    final userNotifier = ref.read(userNotifierProvider.notifier);
    final currentUser = ref.read(userNotifierProvider).valueOrNull;

    if (currentUser != null) {
      final updatedUser = currentUser.copyWith(
        nickname: name,
        gender: gender,
        birthDate: birthDate != null
            ? '${birthDate.year}-${birthDate.month.toString().padLeft(2, '0')}-${birthDate.day.toString().padLeft(2, '0')}'
            : currentUser.birthDate,
      );

      await userNotifier.updateUser(updatedUser);
    }

    state = ProfileEditState.success;
    debugPrint('[ProfileEditProvider] ✅ Mock 프로필 업데이트 완료');
  }

  /// Mock 회원 탈퇴
  Future<void> _mockWithdraw() async {
    debugPrint('[ProfileEditProvider] 🧪 Mock 회원 탈퇴');

    // 네트워크 지연 시뮬레이션
    await Future.delayed(const Duration(milliseconds: 500));

    state = ProfileEditState.success;
    debugPrint('[ProfileEditProvider] ✅ Mock 회원 탈퇴 완료');
  }

  /// Mock 사용자 관심사 조회
  Future<List<Map<String, dynamic>>> _mockGetUserInterests() async {
    debugPrint('[ProfileEditProvider] 🧪 Mock 사용자 관심사 조회');

    // 네트워크 지연 시뮬레이션
    await Future.delayed(const Duration(milliseconds: 300));

    // Mock 데이터: 몇 가지 샘플 관심사 반환
    return [
      {'id': 'mock-food-1', 'name': '미슐랭'},
      {'id': 'mock-cafe-1', 'name': '감성카페'},
      {'id': 'mock-culture-1', 'name': '박물관'},
    ];
  }

  /// Mock 닉네임 중복 확인
  ///
  /// 테스트용: "중복테스트" 닉네임만 중복으로 처리
  Future<bool> _mockCheckNickname(String name) async {
    debugPrint('[ProfileEditProvider] 🧪 Mock 닉네임 중복 확인: $name');

    // 네트워크 지연 시뮬레이션
    await Future.delayed(const Duration(milliseconds: 300));

    // Mock: "중복테스트" 닉네임만 중복으로 처리, 나머지는 사용 가능
    final isAvailable = name != '중복테스트';

    debugPrint(
      '[ProfileEditProvider] ✅ Mock 닉네임 중복 확인 결과: ${isAvailable ? '사용 가능' : '중복됨'}',
    );

    return isAvailable;
  }
}
