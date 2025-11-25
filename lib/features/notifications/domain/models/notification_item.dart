/// 알림 아이템 상태
enum NotificationStatus {
  /// 대기 중 (요청 접수됨, 아직 분석 시작 안 됨)
  pending,

  /// 분석 중 (AI가 현재 분석 중)
  analyzing,

  /// 완료됨 (분석 성공, 장소 추출 완료)
  completed,

  /// 실패 (분석 오류 발생)
  failed,
}

/// 알림 아이템 모델
///
/// 외부 앱에서 공유된 링크/데이터를 표현하는 모델
class NotificationItem {
  /// 고유 ID
  final String id;

  /// 백엔드 콘텐츠 ID (UUID)
  ///
  /// POST /api/content/analyze 응답에서 받은 contentId
  /// FCM 알림 수신 시 GET /api/content/{contentId} 호출에 사용
  final String? contentId;

  /// 작성자명 (예: "sejong_student")
  final String author;

  /// 공유된 URL
  final String url;

  /// 콘텐츠 제목 (분석 완료 후 백엔드에서 생성)
  ///
  /// PENDING 상태: null
  /// COMPLETED 상태: 백엔드 AI가 생성한 제목
  final String? contentTitle;

  /// 콘텐츠 요약 (분석 완료 후 백엔드에서 생성)
  ///
  /// PENDING 상태: null
  /// COMPLETED 상태: 백엔드 AI가 생성한 요약
  final String? contentSummary;

  /// 추출된 장소 개수
  ///
  /// PENDING 상태: null
  /// COMPLETED 상태: places.length
  final int? placeCount;

  /// 현재 상태 (진행 중 / 완료)
  final NotificationStatus status;

  /// 수신 시각
  final DateTime receivedAt;

  const NotificationItem({
    required this.id,
    this.contentId,
    required this.author,
    required this.url,
    this.contentTitle,
    this.contentSummary,
    this.placeCount,
    this.status = NotificationStatus.pending,
    required this.receivedAt,
  });

  /// 상태 업데이트된 새로운 인스턴스 생성
  NotificationItem copyWith({
    String? id,
    String? contentId,
    String? author,
    String? url,
    String? contentTitle,
    String? contentSummary,
    int? placeCount,
    NotificationStatus? status,
    DateTime? receivedAt,
  }) {
    return NotificationItem(
      id: id ?? this.id,
      contentId: contentId ?? this.contentId,
      author: author ?? this.author,
      url: url ?? this.url,
      contentTitle: contentTitle ?? this.contentTitle,
      contentSummary: contentSummary ?? this.contentSummary,
      placeCount: placeCount ?? this.placeCount,
      status: status ?? this.status,
      receivedAt: receivedAt ?? this.receivedAt,
    );
  }

  /// 대기 중 상태 여부 (PENDING)
  bool get isPending => status == NotificationStatus.pending;

  /// 분석 중 상태 여부 (ANALYZING)
  bool get isAnalyzing => status == NotificationStatus.analyzing;

  /// 완료 상태 여부 (COMPLETED)
  bool get isCompleted => status == NotificationStatus.completed;

  /// 실패 상태 여부 (FAILED)
  bool get isFailed => status == NotificationStatus.failed;

  /// 진행 중 상태 여부 (PENDING 또는 ANALYZING)
  bool get isInProgress => isPending || isAnalyzing;

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
