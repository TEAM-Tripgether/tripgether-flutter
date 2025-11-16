import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import '../../../../l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../core/services/sharing_service.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/shared_data_parser.dart';
import '../../../../shared/widgets/common/common_app_bar.dart';
import '../../../../shared/widgets/common/empty_state.dart';
import '../../domain/models/notification_item.dart';

/// 알림 화면 위젯
/// 외부 앱에서 공유된 링크 및 데이터를 표시하는 전용 페이지
class NotificationScreen extends ConsumerStatefulWidget {
  const NotificationScreen({super.key});

  @override
  ConsumerState<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends ConsumerState<NotificationScreen> {
  /// 공유 서비스 인스턴스
  late SharingService _sharingService;

  /// 공유 데이터 스트림 구독
  StreamSubscription<SharedData>? _sharingSubscription;

  /// 알림 아이템 리스트
  final List<NotificationItem> _notifications = [];

  /// 자동 완료 타이머들을 관리하는 Map (알림 ID → Timer)
  final Map<String, Timer> _completionTimers = {};

  @override
  void initState() {
    super.initState();
    // 공유 서비스 초기화 및 데이터 스트림 구독
    _initializeSharingService();
  }

  /// 공유 서비스 초기화 및 스트림 구독 설정
  Future<void> _initializeSharingService() async {
    _sharingService = SharingService.instance;

    // 공유 서비스 재개 (이전에 일시정지된 경우 재활성화)
    _sharingService.resume();

    // 공유 데이터 스트림 구독
    _sharingSubscription = _sharingService.dataStream.listen(
      _handleSharedData,
      onError: (error) {
        debugPrint('[NotificationScreen] 공유 데이터 스트림 에러: $error');
      },
    );

    // 이미 저장된 공유 데이터가 있는지 확인
    // context가 준비될 때까지 대기 (첫 프레임 렌더링 후)
    if (_sharingService.currentSharedData != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          _handleSharedData(_sharingService.currentSharedData!);
        }
      });
    }
  }

  /// 공유 데이터 처리
  void _handleSharedData(SharedData sharedData) {
    debugPrint('[NotificationScreen] 공유 데이터 수신: ${sharedData.toString()}');

    // 텍스트 데이터가 있는 경우에만 처리
    if (sharedData.hasTextData) {
      // SharedDataParser로 작성자와 URL 추출
      final author = SharedDataParser.extractAuthor(
        sharedData.sharedTexts,
        context,
      );
      final url = SharedDataParser.extractUrl(sharedData.sharedTexts);

      debugPrint('[NotificationScreen] 파싱 결과 - 작성자: $author, URL: $url');

      // NotificationItem 생성
      final notificationId = DateTime.now().millisecondsSinceEpoch.toString();
      final notification = NotificationItem(
        id: notificationId,
        author: author,
        url: url,
        receivedAt: DateTime.now(),
        status: NotificationStatus.pending,
      );

      // 알림 리스트에 추가
      setState(() {
        _notifications.insert(0, notification); // 최신 알림을 상단에 추가
      });

      // 환경 변수에 따라 처리 방식 결정
      const useMockApi = bool.fromEnvironment(
        'USE_MOCK_API',
        defaultValue: true,
      );

      if (useMockApi) {
        // Mock 모드: 5~10초 후 자동 완료
        debugPrint('[NotificationScreen] Mock 모드: 자동 완료 타이머 시작');
        _startAutoCompletionTimer(notificationId);
      } else {
        // 실제 API 모드: 백엔드로 URL 전송
        debugPrint('[NotificationScreen] API 모드: 백엔드로 URL 전송');
        _sendUrlToBackend(notificationId, url);
      }
    }

    // 미디어 파일 데이터 처리 (필요시 확장)
    if (sharedData.hasMediaData) {
      debugPrint(
        '[NotificationScreen] 미디어 파일 ${sharedData.sharedFiles.length}개 수신',
      );
      // 미디어 처리 로직 (향후 구현)
    }
  }

  /// 백엔드로 URL 전송 (USE_MOCK_API=false일 때)
  ///
  /// [notificationId]: 알림 ID
  /// [url]: 공유받은 URL
  Future<void> _sendUrlToBackend(String notificationId, String url) async {
    try {
      // TODO: 실제 API 연동 구현
      // - 로그인한 사용자 토큰 가져오기
      // - POST /api/shared-content { url, token }
      // - 응답 받으면 알림 상태를 completed로 변경

      debugPrint('[NotificationScreen] 백엔드로 URL 전송: $url');

      // 임시: API 연동 전까지는 바로 완료 처리
      _completeNotification(notificationId);
    } catch (e) {
      debugPrint('[NotificationScreen] 백엔드 전송 실패: $e');
      // 에러 발생 시에도 알림은 표시되도록 유지 (pending 상태)
    }
  }

  /// 자동 완료 타이머 시작
  ///
  /// [notificationId]: 완료 처리할 알림의 ID
  void _startAutoCompletionTimer(String notificationId) {
    // 5~10초 사이의 랜덤 시간 생성
    final random = Random();
    final delaySeconds = 5 + random.nextInt(6); // 5 + (0~5) = 5~10초

    debugPrint(
      '[NotificationScreen] 알림 $notificationId: $delaySeconds초 후 자동 완료',
    );

    // 타이머 시작
    final timer = Timer(Duration(seconds: delaySeconds), () {
      _completeNotification(notificationId);
    });

    // 타이머 Map에 저장 (dispose 시 정리용)
    _completionTimers[notificationId] = timer;
  }

  /// 알림을 완료 상태로 변경
  ///
  /// [notificationId]: 완료 처리할 알림의 ID
  void _completeNotification(String notificationId) {
    if (!mounted) return;

    setState(() {
      final index = _notifications.indexWhere((n) => n.id == notificationId);
      if (index != -1) {
        _notifications[index] = _notifications[index].copyWith(
          status: NotificationStatus.completed,
        );
        debugPrint('[NotificationScreen] 알림 $notificationId 완료 처리됨');
      }
    });

    // 타이머 제거
    _completionTimers.remove(notificationId);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: CommonAppBar.forSubPage(
        title: '', // 타이틀 제거
        rightActions: const [], // 알림 아이콘 숨김
        backgroundColor: AppColors.backgroundLight,
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 알림 헤딩 섹션
            Padding(
              padding: EdgeInsets.only(
                left: AppSpacing.xxl,
                right: AppSpacing.xxl,
                top: AppSpacing.xsm,
                bottom: AppSpacing.lg,
              ),
              child: Text(
                l10n.notifications,
                style: AppTextStyles.titleBold24.copyWith(
                  color: AppColors.textColor1,
                ),
              ),
            ),
            // 알림 리스트
            Expanded(
              child: _notifications.isNotEmpty
                  ? SingleChildScrollView(
                      padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildSectionHeader(l10n.notificationSectionToday),
                          ..._notifications.map(
                            (notification) => _buildNotificationItem(
                              title: notification.title,
                              username: notification.author,
                              url: notification.url,
                              status:
                                  notification.status ==
                                      NotificationStatus.pending
                                  ? l10n.notificationStatusProcessing
                                  : l10n.notificationStatusCheckButton,
                              timestamp: notification.getRelativeTimestamp(
                                l10n,
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  : Center(
                      child: EmptyStates.noData(
                        title: l10n.noNotifications,
                        message: l10n.sharedContentMessage,
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  /// 섹션 헤더 위젯
  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: EdgeInsets.only(
        left: AppSpacing.sm, // 16(lg, ScrollView) + 8(sm) = 24
        bottom: AppSpacing.md,
      ),
      child: Text(
        title,
        style: AppTextStyles.titleSemiBold16.copyWith(
          color: AppColors.textColor1.withValues(alpha: 0.5),
        ),
      ),
    );
  }

  /// 알림 카드 아이템 위젯
  Widget _buildNotificationItem({
    required String title,
    required String username,
    required String url,
    required String status, // localized status string
    required String timestamp,
  }) {
    final l10n = AppLocalizations.of(context);
    final isPending = status == l10n.notificationStatusProcessing;

    return Stack(
      children: [
        // 메인 카드
        Container(
          margin: EdgeInsets.only(bottom: AppSpacing.sm),
          padding: EdgeInsets.all(AppSpacing.md), // 12 카드 안쪽 첫 번째 패딩
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: AppRadius.allMedium,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.01),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // mark_icon 아이콘
              SvgPicture.asset(
                'assets/icons/mark_icon.svg',
                width: AppSizes.iconLarge,
                height: AppSizes.iconLarge,
              ),
              AppSpacing.horizontalSpaceSM, // 8
              // 콘텐츠 영역
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppSpacing
                        .verticalSpaceXS, // 4 : AI가 위치정보를 파악하고 있습니다 <- 메세지 가운데 정렬
                    // Row 1: 상태 메시지 + 타임스탬프
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            isPending
                                ? l10n.aiAnalyzingLocation
                                : l10n.aiAnalyzedLocations('N'),
                            style: AppTextStyles.titleSemiBold16,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Text(
                          timestamp,
                          style: AppTextStyles.bodyMedium12.copyWith(
                            color: AppColors.subColor2,
                          ),
                        ),
                      ],
                    ),
                    AppSpacing.verticalSpaceXSM, // 6
                    // Row 2: 작성자 정보
                    Text(
                      l10n.authorPost(username),
                      style: AppTextStyles.bodyMedium14.copyWith(
                        color: AppColors.mainColor,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    AppSpacing.verticalSpaceXS, // 4
                    // Row 3: URL + 버튼 (같은 Row, spaceBetween)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        // URL (왼쪽, 3줄까지)
                        Expanded(
                          child: Text(
                            url,
                            style: AppTextStyles.bodyMedium12.copyWith(
                              color: AppColors.subColor2,
                            ),
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        // 버튼 (오른쪽)
                        _buildStatusButton(isPending),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        // 빨간 점 배지 (진행 중일 때만)
        if (isPending)
          Positioned(
            right: AppSpacing.sm,
            top: AppSpacing.md,
            child: _buildRedDotBadge(),
          ),
      ],
    );
  }

  /// 빨간 점 배지 (진행 중 표시)
  Widget _buildRedDotBadge() {
    return Container(
      width: AppSpacing.xsm,
      height: AppSpacing.xsm,
      decoration: const BoxDecoration(
        color: AppColors.error,
        shape: BoxShape.circle,
      ),
    );
  }

  /// 상태별 버튼 생성
  Widget _buildStatusButton(bool isPending) {
    if (isPending) {
      return _buildLoadingButton();
    } else {
      return _buildCompletedButton();
    }
  }

  /// 진행 중 버튼 (로딩)
  Widget _buildLoadingButton() {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.smd,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: AppColors.subColor2.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(AppRadius.small),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: AppSpacing.lg,
            height: AppSpacing.lg,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.mainColor),
            ),
          ),
          AppSpacing.horizontalSpaceXS,
          Text(
            AppLocalizations.of(context).notificationStatusProcessing,
            style: AppTextStyles.bodyMedium14.copyWith(
              color: AppColors.textColor1.withValues(alpha: 0.5),
            ),
          ),
        ],
      ),
    );
  }

  /// 완료 버튼
  Widget _buildCompletedButton() {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.smd,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: AppColors.mainColor,
        borderRadius: BorderRadius.circular(AppRadius.small),
      ),
      child: Text(
        AppLocalizations.of(context).notificationStatusCheckButton,
        style: AppTextStyles.bodyMedium14.copyWith(color: AppColors.white),
      ),
    );
  }

  @override
  void dispose() {
    // 스트림 구독 해제
    _sharingSubscription?.cancel();

    // 모든 타이머 취소
    for (final timer in _completionTimers.values) {
      timer.cancel();
    }
    _completionTimers.clear();

    super.dispose();
  }
}
