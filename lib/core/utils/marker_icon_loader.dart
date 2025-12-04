import 'dart:ui' as ui;

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../theme/app_spacing.dart';

/// 마커 아이콘 로더 유틸리티
///
/// Google Maps 마커에 사용할 커스텀 아이콘을 URL에서 로드합니다.
/// 메모리 캐싱을 지원하여 동일 URL에 대한 중복 다운로드를 방지합니다.
///
/// **사용 예시**:
/// ```dart
/// final icon = await MarkerIconLoader.loadIcon(place.iconUrl);
/// // 또는 캐시 우선 조회
/// final icon = await MarkerIconLoader.loadIconWithCache(place.iconUrl);
/// ```
///
/// **재사용 위치**:
/// - MapScreen: 저장된 장소 마커 표시
/// - PlaceMiniMap: 장소 상세 화면의 미니맵 마커
class MarkerIconLoader {
  /// Dio 인스턴스 (이미지 다운로드용)
  static final Dio _dio = Dio();

  /// 메모리 캐시: URL → BitmapDescriptor 매핑
  ///
  /// 동일 URL에 대한 중복 네트워크 요청을 방지합니다.
  /// 앱 실행 중에만 유지되며, 앱 재시작 시 초기화됩니다.
  static final Map<String, BitmapDescriptor> _iconCache = {};

  /// 기본 마커 아이콘 크기 (픽셀)
  ///
  /// AppSizes.iconSmall(16) * 2 = 32px (레티나 대응)
  static int get _defaultMarkerSize => AppSizes.iconSmall.toInt() * 2;

  // ─────────────────────────────────────────────────────────────────────────
  // Public Methods
  // ─────────────────────────────────────────────────────────────────────────

  /// URL에서 마커 아이콘 로드 (캐시 확인 후 없으면 다운로드)
  ///
  /// [url] 마커 아이콘 이미지 URL
  /// [size] 마커 크기 (픽셀, 기본값: 32)
  ///
  /// 캐시에 있으면 캐시된 아이콘 반환, 없으면 다운로드 후 캐싱합니다.
  /// 실패 시 null 반환 (호출부에서 기본 마커로 폴백 처리 필요)
  static Future<BitmapDescriptor?> loadIconWithCache(
    String? url, {
    int? size,
  }) async {
    if (url == null || url.isEmpty) {
      return null;
    }

    // 캐시 확인
    if (_iconCache.containsKey(url)) {
      debugPrint('[MarkerIconLoader] ✅ 캐시 히트: $url');
      return _iconCache[url];
    }

    // 캐시 미스 → 다운로드
    debugPrint('[MarkerIconLoader] ⏳ 캐시 미스, 다운로드 시작: $url');
    try {
      final icon = await _downloadAndConvert(url, size ?? _defaultMarkerSize);
      _iconCache[url] = icon;
      debugPrint('[MarkerIconLoader] ✅ 다운로드 완료 및 캐싱: $url');
      return icon;
    } catch (e) {
      debugPrint('[MarkerIconLoader] ❌ 아이콘 로드 실패: $e');
      return null;
    }
  }

  /// URL에서 마커 아이콘 로드 (캐시 무시, 항상 새로 다운로드)
  ///
  /// [url] 마커 아이콘 이미지 URL
  /// [size] 마커 크기 (픽셀, 기본값: 32)
  ///
  /// 캐시를 무시하고 항상 새로 다운로드합니다.
  /// 실패 시 예외를 throw합니다.
  static Future<BitmapDescriptor> loadIcon(String url, {int? size}) async {
    return _downloadAndConvert(url, size ?? _defaultMarkerSize);
  }

  /// 캐시 초기화
  ///
  /// 메모리 해제가 필요하거나 아이콘을 새로 로드해야 할 때 호출합니다.
  static void clearCache() {
    debugPrint('[MarkerIconLoader] 🗑️ 캐시 초기화 (${_iconCache.length}개 항목)');
    _iconCache.clear();
  }

  /// 특정 URL의 캐시 제거
  ///
  /// [url] 캐시에서 제거할 URL
  static void removeFromCache(String url) {
    if (_iconCache.containsKey(url)) {
      _iconCache.remove(url);
      debugPrint('[MarkerIconLoader] 🗑️ 캐시에서 제거: $url');
    }
  }

  /// 현재 캐시 크기
  static int get cacheSize => _iconCache.length;

  // ─────────────────────────────────────────────────────────────────────────
  // Private Methods
  // ─────────────────────────────────────────────────────────────────────────

  /// URL에서 이미지 다운로드 및 BitmapDescriptor 변환
  ///
  /// [url] 이미지 URL
  /// [size] 변환할 이미지 크기 (픽셀)
  static Future<BitmapDescriptor> _downloadAndConvert(
    String url,
    int size,
  ) async {
    // Dio를 사용하여 이미지 다운로드
    final response = await _dio.get<List<int>>(
      url,
      options: Options(responseType: ResponseType.bytes),
    );

    if (response.statusCode != 200 || response.data == null) {
      throw Exception('이미지 다운로드 실패: ${response.statusCode}');
    }

    final Uint8List imageData = Uint8List.fromList(response.data!);

    // 이미지 디코딩 및 리사이즈
    final ui.Codec codec = await ui.instantiateImageCodec(
      imageData,
      targetWidth: size,
      targetHeight: size,
    );
    final ui.FrameInfo frameInfo = await codec.getNextFrame();
    final ui.Image image = frameInfo.image;

    // PNG로 인코딩
    final ByteData? byteData = await image.toByteData(
      format: ui.ImageByteFormat.png,
    );
    if (byteData == null) {
      throw Exception('이미지 변환 실패');
    }

    final Uint8List pngBytes = byteData.buffer.asUint8List();

    return BitmapDescriptor.bytes(pngBytes);
  }
}
