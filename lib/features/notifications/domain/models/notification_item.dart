/// 알림 아이템 상태
enum NotificationStatus {
  /// 진행 중 (AI가 분석 중)
  pending,

  /// 완료됨 (분석 완료, 확인 가능)
  completed,
}

/// 알림 아이템 모델
///
/// 외부 앱에서 공유된 링크/데이터를 표현하는 모델
class NotificationItem {
  /// 고유 ID
  final String id;

  /// 작성자명 (예: "sejong_student")
  final String author;

  /// 공유된 URL
  final String url;

  /// 알림 제목 (기본: "공유된 링크")
  final String title;

  /// 현재 상태 (진행 중 / 완료)
  final NotificationStatus status;

  /// 수신 시각
  final DateTime receivedAt;

  const NotificationItem({
    required this.id,
    required this.author,
    required this.url,
    this.title = '공유된 링크',
    this.status = NotificationStatus.pending,
    required this.receivedAt,
  });

  /// 상태 업데이트된 새로운 인스턴스 생성
  NotificationItem copyWith({
    String? id,
    String? author,
    String? url,
    String? title,
    NotificationStatus? status,
    DateTime? receivedAt,
  }) {
    return NotificationItem(
      id: id ?? this.id,
      author: author ?? this.author,
      url: url ?? this.url,
      title: title ?? this.title,
      status: status ?? this.status,
      receivedAt: receivedAt ?? this.receivedAt,
    );
  }

  /// 진행 중 상태 여부
  bool get isPending => status == NotificationStatus.pending;

  /// 완료 상태 여부
  bool get isCompleted => status == NotificationStatus.completed;

  /// 상대적 타임스탬프 반환 (예: "방금", "5분 전")
  ///
  /// [l10n]: AppLocalizations 인스턴스 (국제화 지원)
  String getRelativeTimestamp(dynamic l10n) {
    final now = DateTime.now();
    final difference = now.difference(receivedAt);

    if (difference.inSeconds < 60) {
      return l10n.timestampJustNow;
    } else if (difference.inMinutes < 60) {
      return l10n.timestampMinutesAgo(difference.inMinutes);
    } else if (difference.inHours < 24) {
      return l10n.timestampHoursAgo(difference.inHours);
    } else {
      return l10n.timestampDaysAgo(difference.inDays);
    }
  }
}
