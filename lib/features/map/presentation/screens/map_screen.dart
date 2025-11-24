import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../../shared/widgets/common/common_app_bar.dart';
import '../../../../core/theme/app_colors.dart';
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
              size: 24.w,
              color: AppColors.subColor2,
            ),
            onPressed: () {
              ref.read(mapTypeStateProvider.notifier).toggle();
            },
            tooltip: l10n.mapToggleMapType,
          ),
          SizedBox(width: 4.w),
          // 내 위치로 이동 버튼
          IconButton(
            icon: Icon(
              Icons.my_location_outlined,
              size: 24.w,
              color: AppColors.subColor2,
            ),
            onPressed: () async {
              await ref
                  .read(mapControllerProvider.notifier)
                  .moveToMyLocation();
            },
            tooltip: l10n.mapMyLocationTooltip,
          ),
          SizedBox(width: 8.w),
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
          debugPrint('[MapScreen] 지도 생성 완료');
        },
      ),
    );
  }
}
