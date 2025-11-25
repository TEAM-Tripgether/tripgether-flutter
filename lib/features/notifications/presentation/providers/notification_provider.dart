import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../domain/models/notification_item.dart';

part 'notification_provider.g.dart';

/// 알림 목록을 관리하는 Provider
///
/// HomeScreen과 NotificationScreen에서 공유하여 사용합니다.
/// - HomeScreen: URL 분석 요청 후 알림 추가
/// - NotificationScreen: 알림 목록 표시 및 상태 업데이트
@riverpod
class NotificationList extends _$NotificationList {
  @override
  List<NotificationItem> build() {
    // 초기 상태: 빈 리스트
    return [];
  }

  /// 새 알림 추가
  ///
  /// HomeScreen에서 URL 분석 요청 성공 후 호출합니다.
  /// [contentId]: 백엔드에서 반환된 콘텐츠 UUID
  /// [url]: 공유된 SNS URL
  /// [author]: 추출된 작성자명 (없으면 기본값)
  void addNotification({
    required String contentId,
    required String url,
    String author = '알 수 없음',
  }) {
    final notification = NotificationItem(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      contentId: contentId,
      author: author,
      url: url,
      receivedAt: DateTime.now(),
      status: NotificationStatus.pending,
    );

    // 최신 알림을 상단에 추가
    state = [notification, ...state];

    debugPrint('[NotificationProvider] ✅ 알림 추가 완료');
    debugPrint('[NotificationProvider] 📋 contentId: $contentId');
    debugPrint('[NotificationProvider] 📋 현재 알림 개수: ${state.length}');
  }

  /// 알림 상태 업데이트
  ///
  /// FCM 알림 수신 또는 폴링 결과로 상태를 업데이트합니다.
  /// [contentId]: 업데이트할 알림의 콘텐츠 ID
  /// [status]: 새로운 상태
  /// [title]: 콘텐츠 제목 (COMPLETED 시)
  /// [summary]: 콘텐츠 요약 (COMPLETED 시)
  /// [placeCount]: 추출된 장소 개수 (COMPLETED 시)
  void updateNotification({
    required String contentId,
    required NotificationStatus status,
    String? title,
    String? summary,
    int? placeCount,
  }) {
    final index = state.indexWhere((n) => n.contentId == contentId);

    if (index == -1) {
      debugPrint('[NotificationProvider] ⚠️ 알림 찾기 실패: $contentId');
      return;
    }

    final updatedNotification = state[index].copyWith(
      status: status,
      contentTitle: title,
      contentSummary: summary,
      placeCount: placeCount,
    );

    final newState = [...state];
    newState[index] = updatedNotification;
    state = newState;

    debugPrint('[NotificationProvider] ✅ 알림 업데이트 완료');
    debugPrint('[NotificationProvider] 📋 contentId: $contentId');
    debugPrint('[NotificationProvider] 📋 새 상태: ${status.name}');
  }

  /// 알림 삭제
  void removeNotification(String notificationId) {
    state = state.where((n) => n.id != notificationId).toList();
    debugPrint('[NotificationProvider] 🗑️ 알림 삭제: $notificationId');
  }

  /// PENDING/ANALYZING 상태 알림 목록 반환
  List<NotificationItem> get pendingNotifications {
    return state.where((n) => n.isInProgress).toList();
  }

  /// PENDING 알림이 있는지 여부
  bool get hasPendingNotifications {
    return state.any((n) => n.isInProgress);
  }
}
