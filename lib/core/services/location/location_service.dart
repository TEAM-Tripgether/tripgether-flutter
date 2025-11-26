import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

/// 위치 서비스
///
/// GPS를 통해 현재 위치를 가져오고 위치 권한을 관리하는 서비스입니다.
/// 지도에서 "내 위치로 이동" 기능에 사용됩니다.
///
/// 주요 기능:
/// - 위치 권한 확인 및 요청
/// - 현재 GPS 위치 가져오기
/// - 위치 서비스 활성화 확인
class LocationService {
  /// 서울 시청 좌표 (기본 위치)
  ///
  /// 위치 서비스 비활성화 또는 권한 거부 시 사용되는 fallback 좌표입니다.
  static const LatLng defaultLocation = LatLng(37.5665, 126.9780);

  /// 위치 서비스 활성화 여부 확인
  ///
  /// 기기의 GPS/위치 서비스가 켜져 있는지 확인합니다.
  ///
  /// Returns:
  /// - true: 위치 서비스 활성화됨
  /// - false: 위치 서비스 비활성화됨
  static Future<bool> isLocationServiceEnabled() async {
    try {
      return await Geolocator.isLocationServiceEnabled();
    } catch (e) {
      debugPrint('⚠️ LocationService: 위치 서비스 상태 확인 실패 - $e');
      return false;
    }
  }

  /// 현재 위치 권한 상태 확인
  ///
  /// Returns:
  /// - LocationPermission.denied: 권한 거부됨 (요청 가능)
  /// - LocationPermission.deniedForever: 영구 거부됨 (설정에서 변경 필요)
  /// - LocationPermission.whileInUse: 앱 사용 중 허용
  /// - LocationPermission.always: 항상 허용
  static Future<LocationPermission> checkPermission() async {
    try {
      return await Geolocator.checkPermission();
    } catch (e) {
      debugPrint('⚠️ LocationService: 권한 상태 확인 실패 - $e');
      return LocationPermission.denied;
    }
  }

  /// 위치 권한 요청
  ///
  /// 사용자에게 위치 권한을 요청합니다.
  /// 이미 권한이 있거나 영구 거부된 경우 현재 상태를 반환합니다.
  ///
  /// Returns:
  /// - LocationPermission: 요청 후 권한 상태
  static Future<LocationPermission> requestPermission() async {
    try {
      final permission = await Geolocator.checkPermission();

      // 이미 권한이 있으면 반환
      if (permission == LocationPermission.whileInUse ||
          permission == LocationPermission.always) {
        debugPrint('✅ LocationService: 이미 위치 권한 보유');
        return permission;
      }

      // 영구 거부된 경우 설정으로 안내 필요
      if (permission == LocationPermission.deniedForever) {
        debugPrint('⚠️ LocationService: 위치 권한 영구 거부됨 - 설정에서 변경 필요');
        return permission;
      }

      // 권한 요청
      debugPrint('🔑 LocationService: 위치 권한 요청 중...');
      final result = await Geolocator.requestPermission();
      debugPrint('🔑 LocationService: 권한 요청 결과 - $result');
      return result;
    } catch (e) {
      debugPrint('⚠️ LocationService: 권한 요청 실패 - $e');
      return LocationPermission.denied;
    }
  }

  /// 현재 위치 가져오기
  ///
  /// GPS를 통해 현재 위치를 가져옵니다.
  /// 위치 서비스가 비활성화되어 있거나 권한이 없으면 기본 위치를 반환합니다.
  ///
  /// Returns:
  /// - LatLng: 현재 위치 좌표 (실패 시 서울 시청)
  static Future<LatLng> getCurrentLocation() async {
    debugPrint('═══════════════════════════════════════════════════════');
    debugPrint('📍 LocationService: getCurrentLocation() 시작');

    try {
      // 1. 위치 서비스 활성화 확인
      debugPrint('📍 LocationService: [1/3] 위치 서비스 활성화 상태 확인 중...');
      final serviceEnabled = await isLocationServiceEnabled();
      debugPrint('📍 LocationService: 위치 서비스 활성화: $serviceEnabled');

      if (!serviceEnabled) {
        debugPrint('⚠️ LocationService: 위치 서비스가 비활성화됨 → 기본 위치 반환');
        debugPrint('═══════════════════════════════════════════════════════');
        return defaultLocation;
      }

      // 2. 권한 확인 및 요청
      debugPrint('📍 LocationService: [2/3] 위치 권한 확인 및 요청 중...');
      final permission = await requestPermission();
      debugPrint('📍 LocationService: 권한 상태: $permission');

      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        debugPrint('⚠️ LocationService: 위치 권한 거부됨 ($permission) → 기본 위치 반환');
        debugPrint('═══════════════════════════════════════════════════════');
        return defaultLocation;
      }

      // 3. 현재 위치 가져오기
      debugPrint('📍 LocationService: [3/3] GPS로 현재 위치 가져오는 중...');
      debugPrint('📍 LocationService: Geolocator.getCurrentPosition() 호출...');

      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          timeLimit: Duration(seconds: 10),
        ),
      );

      debugPrint(
        '✅ LocationService: 현재 위치 획득 성공 - '
        '위도: ${position.latitude}, 경도: ${position.longitude}',
      );
      debugPrint('═══════════════════════════════════════════════════════');

      return LatLng(position.latitude, position.longitude);
    } catch (e, stackTrace) {
      debugPrint('❌ LocationService: 위치 가져오기 실패 - $e');
      debugPrint('❌ LocationService: StackTrace - $stackTrace');
      debugPrint('⚠️ LocationService: 기본 위치(서울 시청) 반환');
      debugPrint('═══════════════════════════════════════════════════════');
      return defaultLocation;
    }
  }

  /// 위치 권한이 있는지 빠르게 확인
  ///
  /// 권한 요청 없이 현재 권한 상태만 확인합니다.
  ///
  /// Returns:
  /// - true: whileInUse 또는 always 권한 보유
  /// - false: 권한 없음
  static Future<bool> hasLocationPermission() async {
    final permission = await checkPermission();
    return permission == LocationPermission.whileInUse ||
        permission == LocationPermission.always;
  }

  /// 위치 설정 화면 열기
  ///
  /// 위치 권한이 영구 거부된 경우 앱 설정 화면으로 이동합니다.
  ///
  /// Returns:
  /// - true: 설정 화면 열림
  /// - false: 설정 화면 열기 실패
  static Future<bool> openLocationSettings() async {
    try {
      debugPrint('⚙️ LocationService: 위치 설정 화면 열기');
      return await Geolocator.openLocationSettings();
    } catch (e) {
      debugPrint('⚠️ LocationService: 설정 화면 열기 실패 - $e');
      return false;
    }
  }

  /// 앱 설정 화면 열기
  ///
  /// 위치 권한을 수동으로 변경할 수 있는 앱 설정 화면으로 이동합니다.
  ///
  /// Returns:
  /// - true: 앱 설정 화면 열림
  /// - false: 앱 설정 화면 열기 실패
  static Future<bool> openAppSettings() async {
    try {
      debugPrint('⚙️ LocationService: 앱 설정 화면 열기');
      return await Geolocator.openAppSettings();
    } catch (e) {
      debugPrint('⚠️ LocationService: 앱 설정 화면 열기 실패 - $e');
      return false;
    }
  }
}
