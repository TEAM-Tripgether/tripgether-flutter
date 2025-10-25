import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/router/router.dart';

/// 탭 화면의 스크롤 및 새로고침 기능을 제공하는 Mixin
///
/// Flutter 기본 RefreshIndicator를 사용하여:
/// 1. 탭 재클릭 시 최상단 스크롤 + Pull-to-Refresh UI
/// 2. 각 탭의 스크롤 위치 자동 관리
/// 3. 데이터 새로고침 로직 통합
///
/// **사용 방법**:
/// ```dart
/// class _HomeScreenState extends ConsumerState<HomeScreen>
///     with AutomaticKeepAliveClientMixin, RefreshableTabMixin {
///
///   @override
///   int get tabIndex => 0; // 탭 인덱스 지정
///
///   @override
///   bool get wantKeepAlive => true; // 상태 유지
///
///   @override
///   Future<void> onRefreshData() async {
///     // 데이터 새로고침 로직 구현
///     setState(() {
///       // 데이터 업데이트
///     });
///   }
///
///   @override
///   Widget build(BuildContext context) {
///     super.build(context); // AutomaticKeepAliveClientMixin 필수
///     return Scaffold(
///       body: CustomScrollView(
///         controller: scrollController,  // Mixin에서 제공
///         slivers: [
///           CupertinoSliverRefreshControl(
///             onRefresh: onRefresh,  // Mixin의 onRefresh 사용
///           ),
///           SliverAppBar(title: const Text('제목')),
///           SliverList(/* ... 화면 내용 */),
///         ],
///       ),
///     );
///   }
/// }
/// ```
mixin RefreshableTabMixin<T extends StatefulWidget> on State<T> {
  /// 스크롤 컨트롤러 (탭 재클릭 시 최상단 스크롤용)
  late final ScrollController scrollController = ScrollController();

  /// 현재 탭 클릭 횟수 (내부 추적용)
  int _currentTapCount = 0;

  /// 탭 클릭 카운트 리셋용 타이머
  ///
  /// 마지막 클릭 후 일정 시간(800ms) 내에 다시 클릭하지 않으면 카운트 리셋
  Timer? _tapCountResetTimer;

  /// 현재 탭의 인덱스
  ///
  /// 각 탭 화면에서 반드시 override해야 합니다.
  /// 예: 홈(0), 코스마켓(1), 지도(2), 일정(3), 마이페이지(4)
  int get tabIndex;

  /// 데이터 새로고침 로직
  ///
  /// 각 탭 화면에서 반드시 구현해야 합니다.
  /// 이 메서드에서 실제 데이터를 가져오고 setState를 호출하세요.
  ///
  /// **중요**: RefreshIndicator의 onRefresh에는 이 메서드가 아닌
  /// `onRefresh` getter를 연결해야 합니다. (최소 실행 시간 보장)
  ///
  /// 예시:
  /// ```dart
  /// @override
  /// Future<void> onRefreshData() async {
  ///   // API 호출 또는 Provider 새로고침
  ///   setState(() {
  ///     _data = newData;
  ///   });
  /// }
  ///
  /// // CupertinoSliverRefreshControl 사용 시
  /// CupertinoSliverRefreshControl(
  ///   onRefresh: onRefresh,  // onRefreshData가 아닌 onRefresh 사용!
  /// )
  /// ```
  Future<void> onRefreshData();

  /// 새로고침 상태 변경 콜백
  ///
  /// 프로그래밍 방식(탭 재클릭)으로 새로고침이 시작되거나 완료될 때 호출됩니다.
  /// 이를 통해 커스텀 로딩 인디케이터를 표시할 수 있습니다.
  ///
  /// [isRefreshing] true: 새로고침 시작, false: 새로고침 완료
  ///
  /// **사용 예시**:
  /// ```dart
  /// bool _isProgrammaticRefreshing = false;
  ///
  /// @override
  /// void onRefreshStateChanged(bool isRefreshing) {
  ///   setState(() {
  ///     _isProgrammaticRefreshing = isRefreshing;
  ///   });
  /// }
  ///
  /// // SliverAppBar에 progress indicator 추가
  /// SliverAppBar(
  ///   title: const Text('제목'),
  ///   bottom: _isProgrammaticRefreshing
  ///     ? PreferredSize(
  ///         preferredSize: Size.fromHeight(2.0),
  ///         child: LinearProgressIndicator(),
  ///       )
  ///     : null,
  /// )
  /// ```
  void onRefreshStateChanged(bool isRefreshing) {
    // 기본 구현: 아무것도 하지 않음
    // 서브클래스에서 필요시 override하여 UI 업데이트
  }

  /// 새로고침 최소 실행 시간 (밀리초)
  ///
  /// RefreshIndicator의 로딩 아이콘이 너무 빨리 사라지지 않도록
  /// 최소 실행 시간을 보장합니다.
  ///
  /// 기본값: 800ms
  /// 더 짧은 시간을 원하면 override하여 변경 가능
  int get minRefreshDuration => 800;

  /// RefreshIndicator의 onRefresh에 연결할 메서드
  ///
  /// 이 메서드는 `onRefreshData()`를 래핑하여:
  /// 1. 실제 데이터 새로고침 수행
  /// 2. 최소 실행 시간(minRefreshDuration) 보장
  ///
  /// **사용법**:
  /// ```dart
  /// CupertinoSliverRefreshControl(
  ///   onRefresh: onRefresh,  // 이 메서드를 사용!
  /// )
  /// ```
  Future<void> onRefresh() => _refreshWithMinDuration();

  /// 최소 실행 시간을 보장하는 내부 래퍼 메서드
  Future<void> _refreshWithMinDuration() async {
    final stopwatch = Stopwatch()..start();

    // 실제 데이터 새로고침 실행
    await onRefreshData();

    stopwatch.stop();

    // 최소 실행 시간에 미달하면 나머지 시간만큼 대기
    final remaining = minRefreshDuration - stopwatch.elapsedMilliseconds;
    if (remaining > 0) {
      await Future.delayed(Duration(milliseconds: remaining));
    }
  }

  /// 탭 재클릭 시 자동 새로고침 활성화 여부
  ///
  /// 기본값: true (활성화)
  /// 새로고침이 필요 없는 정적 화면(예: 마이페이지)은 false로 override
  bool get enableAutoRefresh => true;

  /// 새로고침이 실행되기 위한 탭 클릭 횟수
  ///
  /// 기본값: 1 (한 번 클릭 시 즉시 새로고침)
  /// 예시:
  /// - 홈: 1번 클릭 시 새로고침 (기본값)
  /// - 코스마켓: 2번 클릭 시 새로고침
  /// - 마이페이지: 새로고침 비활성화 (enableAutoRefresh = false)
  int get refreshTapCount => 1;

  /// 최상단 스크롤 애니메이션 시간 (밀리초)
  ///
  /// 기본값: 300ms (빠른 반응성)
  /// 더 느린 애니메이션을 원하면 500ms 이상으로 설정
  int get scrollAnimationDuration => 300;

  @override
  void initState() {
    super.initState();
    // 탭 재클릭 콜백 등록
    AppRouter.registerTabRefreshCallback(tabIndex, onTabReselected);
  }

  /// 탭 재클릭 시 호출되는 메서드
  ///
  /// 동작 순서:
  /// 1. 클릭 횟수 증가 및 확인
  /// 2. 최상단으로 부드럽게 스크롤 (scrollAnimationDuration)
  /// 3. 햅틱 피드백
  /// 4. (조건부) RefreshIndicator 트리거 (pull-down 애니메이션 자동 실행)
  Future<void> onTabReselected() async {
    // 1. 클릭 횟수 증가
    _currentTapCount++;

    // 타이머 취소 (이전 타이머가 있다면)
    _tapCountResetTimer?.cancel();

    // 800ms 후 클릭 카운트 리셋 (더블클릭/트리플클릭 감지용)
    _tapCountResetTimer = Timer(const Duration(milliseconds: 800), () {
      _currentTapCount = 0;
    });

    // 2. 최상단으로 스크롤 (스크롤 가능한 경우에만)
    if (scrollController.hasClients) {
      await scrollController.animateTo(
        0,
        duration: Duration(milliseconds: scrollAnimationDuration),
        curve: Curves.easeInOut,
      );
    }

    // 3. 햅틱 피드백
    HapticFeedback.mediumImpact();

    // 4. RefreshIndicator 트리거 (조건부)
    // 활성화된 경우 AND 설정된 클릭 횟수에 도달한 경우
    if (enableAutoRefresh && _currentTapCount >= refreshTapCount) {
      // 클릭 카운트 리셋
      _currentTapCount = 0;
      _tapCountResetTimer?.cancel();

      // 스크롤 완료 후 새로고침 실행
      // CupertinoSliverRefreshControl은 Material의 RefreshIndicator와 달리
      // GlobalKey 기반 show() 메서드가 없으므로 직접 onRefresh() 호출

      // 프로그래밍 방식 새로고침 시작 알림
      onRefreshStateChanged(true);

      // 새로고침 실행 (비동기)
      // try-finally로 성공/실패 관계없이 상태 초기화 보장
      try {
        await onRefresh();
      } finally {
        // 새로고침 완료 알림 (성공/실패 무관하게 항상 실행)
        onRefreshStateChanged(false);
      }
    }
  }

  @override
  void dispose() {
    // 탭 새로고침 콜백 해제
    AppRouter.unregisterTabRefreshCallback(tabIndex);

    // 타이머 정리
    _tapCountResetTimer?.cancel();

    // 스크롤 컨트롤러 정리
    scrollController.dispose();

    super.dispose();
  }
}
