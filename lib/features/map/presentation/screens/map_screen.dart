import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../../shared/widgets/common/common_app_bar.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../l10n/app_localizations.dart';
import '../providers/map_provider.dart';

/// 지도 화면
///
/// 여행지 위치 정보를 Google Maps로 확인할 수 있는 화면입니다.
/// 전체 화면을 지도가 차지하므로 미니멀한 AppBar를 사용합니다.
class MapScreen extends ConsumerStatefulWidget {
  const MapScreen({super.key});

  @override
  ConsumerState<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends ConsumerState<MapScreen> {
  /// 지도 생성 완료 여부
  bool _isMapCreated = false;

  @override
  void initState() {
    super.initState();
    // 지도 화면 진입 시 저장된 장소 마커 로드
    _loadSavedPlaceMarkers();
  }

  /// 저장된 장소 마커 로드
  ///
  /// 비동기로 저장 장소를 조회하고 마커로 변환하여 지도에 표시합니다.
  Future<void> _loadSavedPlaceMarkers() async {
    debugPrint('[MapScreen] 📍 저장 장소 마커 로드 시작');

    // savedPlacesMarkersProvider에서 마커 가져오기
    final markersAsync = ref.read(savedPlacesMarkersProvider);

    markersAsync.when(
      data: (markers) {
        debugPrint('[MapScreen] ✅ 저장 장소 마커 ${markers.length}개 로드 완료');
        // 마커를 MapMarkers에 추가
        ref.read(mapMarkersProvider.notifier).replaceWithSavedPlaceMarkers(markers);
        // 지도가 이미 생성되었으면 카메라 이동
        _fitCameraToMarkersIfReady(markers);
      },
      loading: () {
        debugPrint('[MapScreen] ⏳ 저장 장소 마커 로딩 중...');
      },
      error: (error, stack) {
        debugPrint('[MapScreen] ❌ 저장 장소 마커 로드 실패: $error');
      },
    );
  }

  /// 지도와 마커가 모두 준비되면 카메라 이동
  ///
  /// 지도 생성 완료 + 마커 로드 완료 시에만 카메라를 이동합니다.
  Future<void> _fitCameraToMarkersIfReady(Set<Marker> markers) async {
    if (!_isMapCreated) {
      debugPrint('[MapScreen] ⏳ 지도 미생성 - 카메라 이동 대기');
      return;
    }

    if (markers.isEmpty) {
      debugPrint('[MapScreen] ⚠️ 마커 없음 - 카메라 이동 스킵');
      return;
    }

    debugPrint('[MapScreen] 🎯 모든 마커 보이도록 카메라 이동 시작');
    await ref.read(mapControllerProvider.notifier).fitBoundsToMarkers(markers);
  }

  @override
  void dispose() {
    // 지도 컨트롤러 정리
    ref.read(mapControllerProvider.notifier).disposeController();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final initialPosition = ref.watch(initialCameraPositionProvider);
    final mapType = ref.watch(mapTypeStateProvider);
    final markers = ref.watch(mapMarkersProvider);

    // 저장 장소 마커 상태 감시 (로딩 완료 시 자동 업데이트 + 카메라 이동)
    ref.listen<AsyncValue<Set<Marker>>>(savedPlacesMarkersProvider, (_, next) {
      next.whenData((savedMarkers) {
        debugPrint('[MapScreen] 🔄 저장 장소 마커 업데이트: ${savedMarkers.length}개');
        ref.read(mapMarkersProvider.notifier).replaceWithSavedPlaceMarkers(savedMarkers);
        // 마커 업데이트 시 카메라 이동
        _fitCameraToMarkersIfReady(savedMarkers);
      });
    });

    return Scaffold(
      // 지도 화면에 최적화된 커스텀 AppBar
      appBar: CommonAppBar(
        title: '', // 제목 없음으로 지도 공간 극대화
        backgroundColor: AppColors.surface,
        elevation: 0,
        showMenuButton: true,
        showNotificationIcon: false,
        onMenuPressed: () {
          debugPrint('[MapScreen] 메뉴 버튼 클릭');
          // TODO: Drawer 또는 메뉴 표시
        },
        rightActions: [
          // 지도 타입 변경 버튼 (일반/위성)
          IconButton(
            icon: Icon(
              mapType == MapType.normal
                  ? Icons.satellite_alt_outlined
                  : Icons.map_outlined,
              size: AppSizes.iconDefault,
              color: AppColors.subColor2,
            ),
            onPressed: () {
              ref.read(mapTypeStateProvider.notifier).toggle();
            },
            tooltip: l10n.mapToggleMapType,
          ),
          AppSpacing.horizontalSpaceXS,
          // 내 위치 / 저장 장소 전체 보기 토글 버튼
          Consumer(
            builder: (context, ref, _) {
              final isMyLocationMode = ref.watch(cameraFocusModeProvider);

              return IconButton(
                icon: Icon(
                  // 현재 모드에 따라 아이콘 변경
                  isMyLocationMode
                      ? Icons.zoom_out_map_outlined // 내 위치 모드 → 전체 보기 아이콘
                      : Icons.my_location_outlined, // 저장 장소 모드 → 내 위치 아이콘
                  size: AppSizes.iconDefault,
                  color: AppColors.subColor2,
                ),
                onPressed: () async {
                  if (isMyLocationMode) {
                    // 현재 내 위치 모드 → 저장 장소 전체 보기로 전환
                    debugPrint('[MapScreen] 🔄 저장 장소 전체 보기로 전환');
                    final savedMarkers = ref.read(mapMarkersProvider);
                    if (savedMarkers.isNotEmpty) {
                      await ref
                          .read(mapControllerProvider.notifier)
                          .fitBoundsToMarkers(savedMarkers);
                    }
                    ref.read(cameraFocusModeProvider.notifier).setSavedPlacesMode();
                  } else {
                    // 현재 저장 장소 모드 → 내 위치로 이동
                    debugPrint('[MapScreen] 🔄 내 위치로 이동');
                    await ref.read(mapControllerProvider.notifier).moveToMyLocation();
                    ref.read(cameraFocusModeProvider.notifier).setMyLocationMode();
                  }
                },
                tooltip: isMyLocationMode
                    ? l10n.mapShowAllPlacesTooltip
                    : l10n.mapMyLocationTooltip,
              );
            },
          ),
          AppSpacing.horizontalSpaceSM,
        ],
      ),
      body: GoogleMap(
        initialCameraPosition: initialPosition,
        mapType: mapType,
        markers: markers, // 장소 마커 표시
        myLocationEnabled: true, // 내 위치 표시
        myLocationButtonEnabled: false, // 기본 버튼 숨김 (커스텀 버튼 사용)
        zoomControlsEnabled: false, // 기본 줌 컨트롤 숨김
        compassEnabled: true, // 나침반 표시
        mapToolbarEnabled: false, // Android 지도 툴바 숨김
        onMapCreated: (GoogleMapController controller) {
          ref.read(mapControllerProvider.notifier).setController(controller);
          _isMapCreated = true;
          debugPrint('[MapScreen] 지도 생성 완료');

          // 지도 생성 완료 후, 이미 로드된 마커가 있으면 카메라 이동
          final currentMarkers = ref.read(mapMarkersProvider);
          if (currentMarkers.isNotEmpty) {
            debugPrint('[MapScreen] 📍 지도 생성 완료 - 기존 마커로 카메라 이동');
            _fitCameraToMarkersIfReady(currentMarkers);
          }
        },
      ),
    );
  }
}
