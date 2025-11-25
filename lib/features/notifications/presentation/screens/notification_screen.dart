import 'dart:async';
import 'package:flutter/material.dart';
import '../../../../l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../core/services/sharing_service.dart';
import '../../../../core/services/fcm/firebase_messaging_service.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/shared_data_parser.dart';
import '../../../../core/utils/token_error_handler.dart';
import '../../../../core/errors/refresh_token_exception.dart';
import '../../../../shared/widgets/common/common_app_bar.dart';
import '../../../../shared/widgets/common/empty_state.dart';
import '../../domain/models/notification_item.dart';
import '../../../home/presentation/providers/content_provider.dart';
import '../providers/notification_provider.dart';

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

  /// FCM 콘텐츠 완료 알림 스트림 구독
  StreamSubscription<String>? _fcmSubscription;

  /// 자동 완료 타이머들을 관리하는 Map (알림 ID → Timer)
  final Map<String, Timer> _completionTimers = {};

  /// PENDING 알림 폴링 타이머
  Timer? _pollingTimer;

  @override
  void initState() {
    super.initState();
    // 공유 서비스 초기화 및 데이터 스트림 구독
    _initializeSharingService();
    // FCM 알림 리스너 초기화
    _initializeFcmListener();
    // 기존 PENDING 알림들 상태 체크
    _checkPendingNotifications();
    // PENDING 알림 폴링 시작
    _startPollingPendingNotifications();
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

  /// FCM 알림 리스너 초기화
  ///
  /// FirebaseMessagingService의 contentCompletedStream을 구독하여
  /// 백엔드에서 콘텐츠 분석 완료 알림을 받으면 자동으로 UI를 업데이트합니다.
  void _initializeFcmListener() {
    _fcmSubscription = FirebaseMessagingService.contentCompletedStream.listen((
      contentId,
    ) {
      debugPrint('[NotificationScreen] FCM 알림 수신 - contentId: $contentId');
      _updateNotificationFromApi(contentId);
    });
  }

  /// PENDING 알림 단일 폴링
  ///
  /// 화면 진입 5초 후 한 번만 폴링을 실행합니다.
  /// 이후 상태 업데이트는 FCM 알림으로 처리됩니다.
  void _startPollingPendingNotifications() {
    debugPrint('[NotificationScreen] 🔄 단일 폴링 예약 (5초 후)');

    _pollingTimer = Timer(const Duration(seconds: 5), () async {
      if (!mounted) return;

      // PENDING 또는 ANALYZING 상태 알림이 있는지 확인
      final notifications = ref.read(notificationListProvider);
      final hasPendingNotifications = notifications.any((n) => n.isInProgress);

      if (!hasPendingNotifications) {
        debugPrint('[NotificationScreen] ✅ 폴링할 PENDING 알림 없음');
        return;
      }

      debugPrint('[NotificationScreen] 🔄 단일 폴링 실행');
      await _pollPendingNotifications();
    });
  }

  /// PENDING 알림들 폴링 (타이머용 - postFrameCallback 없이 즉시 실행)
  ///
  /// _checkPendingNotifications()와 동일한 로직이지만 WidgetsBinding.instance.addPostFrameCallback 없이
  /// 즉시 실행되도록 수정한 버전입니다.
  Future<void> _pollPendingNotifications() async {
    if (!mounted) return;

    debugPrint('═══════════════════════════════════════════════════════');
    debugPrint('[NotificationScreen] 🔄 PENDING 알림 폴링 체크');

    // PENDING 또는 ANALYZING 상태인 알림들 필터링 (Provider에서)
    final notifications = ref.read(notificationListProvider);
    final pendingNotifications = notifications
        .where((n) => n.isInProgress)
        .toList();

    if (pendingNotifications.isEmpty) {
      debugPrint('[NotificationScreen] ✅ 폴링할 PENDING 알림 없음');
      debugPrint('═══════════════════════════════════════════════════════');
      return;
    }

    debugPrint(
      '[NotificationScreen] 📋 폴링 대상: ${pendingNotifications.length}개',
    );

    int completedCount = 0;
    int stillPendingCount = 0;

    // 각 PENDING 알림의 contentId로 API 호출
    for (final notification in pendingNotifications) {
      // contentId가 null이면 스킵
      final contentId = notification.contentId;
      if (contentId == null) {
        debugPrint('[NotificationScreen] ⚠️ contentId가 null - 스킵');
        stillPendingCount++;
        continue;
      }

      try {
        debugPrint('[NotificationScreen] 📤 상태 확인 중: $contentId');

        // GET /api/content/{contentId} 호출
        final content = await ref.read(contentDetailProvider(contentId).future);

        debugPrint('[NotificationScreen] 📥 응답 수신 - status: ${content.status}');

        // 상태 변경 감지를 위해 이전 상태 저장
        final oldStatus = notification.status;

        // API 응답으로 알림 상태 업데이트
        await _updateNotificationFromApi(contentId);

        // 상태 변경 통계 업데이트 (Provider에서 다시 읽기)
        final updatedNotifications = ref.read(notificationListProvider);
        final updatedNotification = updatedNotifications.firstWhere(
          (n) => n.contentId == contentId,
          orElse: () => notification,
        );
        final newStatus = updatedNotification.status;

        if (oldStatus != newStatus) {
          switch (newStatus) {
            case NotificationStatus.analyzing:
              debugPrint('[NotificationScreen] 🔄 ANALYZING 상태로 변경');
              stillPendingCount++;
              break;
            case NotificationStatus.completed:
              debugPrint('[NotificationScreen] ✅ COMPLETED 상태로 변경');
              completedCount++;
              break;
            case NotificationStatus.failed:
              debugPrint('[NotificationScreen] ❌ FAILED 상태로 변경');
              completedCount++; // 실패도 "완료된" 카운트에 포함
              break;
            default:
              stillPendingCount++;
              break;
          }
        } else {
          debugPrint('[NotificationScreen] ⏳ 상태 변화 없음: ${content.status}');
          stillPendingCount++;
        }
      } on RefreshTokenException catch (e) {
        // Refresh Token 에러 → 자동 로그아웃 처리
        debugPrint('[NotificationScreen] 🚨 Refresh Token 에러 감지: $e');
        if (mounted) {
          await handleTokenError(context, ref, e);
        }
        return; // 로그아웃 후 더 이상 처리하지 않음
      } catch (e) {
        debugPrint('[NotificationScreen] ❌ 상태 체크 실패: $contentId - $e');
        stillPendingCount++;
      }
    }

    debugPrint(
      '[NotificationScreen] 📊 폴링 결과: 완료 $completedCount개, 진행중 $stillPendingCount개',
    );
    debugPrint('═══════════════════════════════════════════════════════');
  }

  /// 기존 PENDING 알림들의 상태 체크
  ///
  /// NotificationScreen 진입 시 PENDING 상태 알림들이 백엔드에서 완료되었는지 확인합니다.
  /// GET /api/content/{contentId}를 호출하여 status를 체크하고,
  /// COMPLETED 상태면 알림 UI를 업데이트합니다.
  Future<void> _checkPendingNotifications() async {
    // 첫 프레임 렌더링 후 실행
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!mounted) return;

      debugPrint('═══════════════════════════════════════════════════════');
      debugPrint('[NotificationScreen] 🔄 PENDING 알림 상태 체크 시작');

      // PENDING 상태인 알림들 필터링 (Provider에서)
      final notifications = ref.read(notificationListProvider);
      final pendingNotifications = notifications
          .where((n) => n.isPending)
          .toList();

      if (pendingNotifications.isEmpty) {
        debugPrint('[NotificationScreen] ✅ 체크할 PENDING 알림 없음');
        debugPrint('═══════════════════════════════════════════════════════');
        return;
      }

      debugPrint(
        '[NotificationScreen] 📋 체크할 PENDING 알림 ${pendingNotifications.length}개',
      );

      int completedCount = 0;
      int stillPendingCount = 0;

      // 각 PENDING 알림의 contentId로 API 호출
      for (final notification in pendingNotifications) {
        // contentId가 null이면 스킵
        final contentId = notification.contentId;
        if (contentId == null) {
          debugPrint('[NotificationScreen] ⚠️ contentId가 null - 스킵');
          stillPendingCount++;
          continue;
        }

        try {
          debugPrint('[NotificationScreen] 📤 상태 확인 중: $contentId');

          // GET /api/content/{contentId} 호출
          final content = await ref.read(
            contentDetailProvider(contentId).future,
          );

          debugPrint(
            '[NotificationScreen] 📥 응답 수신 - status: ${content.status}',
          );

          // 상태 변경 감지를 위해 이전 상태 저장
          final oldStatus = notification.status;

          // API 응답으로 알림 상태 업데이트
          await _updateNotificationFromApi(contentId);

          // 상태 변경 통계 업데이트 (Provider에서 다시 읽기)
          final updatedNotifications = ref.read(notificationListProvider);
          final newStatus = updatedNotifications
              .firstWhere((n) => n.contentId == contentId)
              .status;
          if (oldStatus != newStatus) {
            switch (newStatus) {
              case NotificationStatus.analyzing:
                debugPrint('[NotificationScreen] 🔄 ANALYZING 상태로 변경');
                stillPendingCount++;
                break;
              case NotificationStatus.completed:
                debugPrint('[NotificationScreen] ✅ COMPLETED 상태로 변경');
                completedCount++;
                break;
              case NotificationStatus.failed:
                debugPrint('[NotificationScreen] ❌ FAILED 상태로 변경');
                completedCount++; // 실패도 "완료된" 카운트에 포함
                break;
              default:
                stillPendingCount++;
                break;
            }
          } else {
            debugPrint('[NotificationScreen] ⏳ 상태 변화 없음: ${content.status}');
            stillPendingCount++;
          }
        } on RefreshTokenException catch (e) {
          // Refresh Token 에러 → 자동 로그아웃 처리
          debugPrint('[NotificationScreen] 🚨 Refresh Token 에러 감지: $e');
          if (mounted) {
            await handleTokenError(context, ref, e);
          }
          return; // 로그아웃 후 더 이상 처리하지 않음
        } catch (e) {
          debugPrint('[NotificationScreen] ❌ 상태 체크 실패: $contentId - $e');
          stillPendingCount++;
        }
      }

      debugPrint(
        '[NotificationScreen] 📊 체크 결과: 완료 $completedCount개, 진행중 $stillPendingCount개',
      );
      debugPrint('═══════════════════════════════════════════════════════');
    });
  }

  /// 공유 데이터 처리
  void _handleSharedData(SharedData sharedData) async {
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

      try {
        // 백엔드로 URL 전송하고 contentId 받기
        final contentProvider = ref.read(contentListProvider.notifier);
        final contentId = await contentProvider.analyzeUrl(url);

        debugPrint('[NotificationScreen] contentId 수신: $contentId');

        // 알림 리스트에 추가 (Provider 사용)
        ref
            .read(notificationListProvider.notifier)
            .addNotification(contentId: contentId, url: url, author: author);

        debugPrint('[NotificationScreen] 알림 추가 완료 (PENDING 상태)');
      } on RefreshTokenException catch (e) {
        // Refresh Token 에러 → 자동 로그아웃 처리
        debugPrint('[NotificationScreen] 🚨 Refresh Token 에러 감지: $e');
        if (mounted) {
          await handleTokenError(context, ref, e);
        }
      } catch (e) {
        debugPrint('[NotificationScreen] URL 분석 요청 실패: $e');
        // 에러 시 사용자에게 알림 표시 (SnackBar 등)
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('링크 분석 요청 중 오류가 발생했습니다: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
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

  /// API 응답으로 알림 상태 업데이트
  ///
  /// [contentId]: 백엔드 콘텐츠 UUID
  /// GET /api/content/{contentId}를 호출하여 최신 상태를 가져와 알림을 업데이트합니다.
  ///
  /// 상태별 동작:
  /// - PENDING → PENDING 유지 (변화 없음)
  /// - ANALYZING → analyzing 상태로 변경 + 로딩 UI 유지
  /// - COMPLETED → completed 상태로 변경 + 제목/요약/장소 개수 표시
  /// - FAILED → failed 상태로 변경 + 에러 메시지 표시
  Future<void> _updateNotificationFromApi(String contentId) async {
    if (!mounted) return;

    try {
      debugPrint('[NotificationScreen] 📤 콘텐츠 상태 조회: $contentId');

      // GET /api/content/{contentId} 호출
      final fullContent = await ref.read(
        contentDetailProvider(contentId).future,
      );

      debugPrint(
        '[NotificationScreen] 📥 상태 조회 완료: status=${fullContent.status}',
      );

      // 백엔드 status 문자열 → NotificationStatus enum 변환
      final notificationStatus = _mapContentStatusToNotificationStatus(
        fullContent.status,
      );

      // 알림 업데이트 (Provider 사용)
      ref
          .read(notificationListProvider.notifier)
          .updateNotification(
            contentId: contentId,
            status: notificationStatus,
            title: fullContent.title,
            summary: fullContent.summary,
            placeCount: fullContent.places.length,
          );
      debugPrint(
        '[NotificationScreen] ✅ 알림 업데이트 완료: ${notificationStatus.name}',
      );
    } catch (e) {
      debugPrint('[NotificationScreen] ❌ API 호출 실패: $e');
      // 에러 발생 시 알림 상태 유지 (변경하지 않음)
    }
  }

  /// ContentModel.status (String) → NotificationStatus (enum) 변환
  ///
  /// 백엔드 API 응답의 status 필드를 NotificationStatus enum으로 매핑합니다.
  ///
  /// | 백엔드 API | NotificationStatus |
  /// |------------|--------------------|
  /// | PENDING    | pending            |
  /// | ANALYZING  | analyzing          |
  /// | COMPLETED  | completed          |
  /// | FAILED     | failed             |
  /// | (기타)      | pending (기본값)    |
  NotificationStatus _mapContentStatusToNotificationStatus(String? apiStatus) {
    switch (apiStatus?.toUpperCase()) {
      case 'PENDING':
        return NotificationStatus.pending;
      case 'ANALYZING':
        return NotificationStatus.analyzing;
      case 'COMPLETED':
        return NotificationStatus.completed;
      case 'FAILED':
        return NotificationStatus.failed;
      default:
        debugPrint(
          '[NotificationScreen] ⚠️ 알 수 없는 status: $apiStatus → pending으로 처리',
        );
        return NotificationStatus.pending;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    // Provider에서 알림 목록 watch (상태 변경 시 자동 리빌드)
    final notifications = ref.watch(notificationListProvider);

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
              child: notifications.isNotEmpty
                  ? SingleChildScrollView(
                      padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildSectionHeader(l10n.notificationSectionToday),
                          ...notifications.map(
                            (notification) =>
                                _buildNotificationItem(notification),
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

  /// 상태별 메시지 반환
  ///
  /// [notification]: 알림 아이템
  /// [l10n]: 다국어 리소스
  ///
  /// 알림 상태에 따라 적절한 메시지를 반환합니다:
  /// - PENDING/ANALYZING: "AI가 위치정보를 파악하고 있습니다"
  /// - COMPLETED: "AI가 N곳의 위치정보를 파악했습니다"
  /// - FAILED: "AI가 분석을 실패했습니다"
  String _getStatusMessage(
    NotificationItem notification,
    AppLocalizations l10n,
  ) {
    switch (notification.status) {
      case NotificationStatus.pending:
      case NotificationStatus.analyzing:
        return l10n.aiAnalyzingLocation;
      case NotificationStatus.completed:
        return l10n.aiAnalyzedLocations(
          notification.placeCount?.toString() ?? '0',
        );
      case NotificationStatus.failed:
        return l10n.aiAnalysisFailed;
    }
  }

  /// 상태별 메시지 색상 반환
  ///
  /// [notification]: 알림 아이템
  ///
  /// 알림 상태에 따라 메시지 색상을 반환합니다:
  /// - PENDING/ANALYZING/COMPLETED: mainColor (보라색)
  /// - FAILED: 빨간색 (오류 강조)
  Color _getStatusMessageColor(NotificationItem notification) {
    switch (notification.status) {
      case NotificationStatus.pending:
      case NotificationStatus.analyzing:
      case NotificationStatus.completed:
        return AppColors.mainColor;
      case NotificationStatus.failed:
        return AppColors.error;
    }
  }

  /// 알림 카드 아이템 위젯
  Widget _buildNotificationItem(NotificationItem notification) {
    final l10n = AppLocalizations.of(context);

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
                            _getStatusMessage(notification, l10n),
                            style: AppTextStyles.titleSemiBold16.copyWith(
                              color: _getStatusMessageColor(notification),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Text(
                          notification.getRelativeTimestamp(l10n),
                          style: AppTextStyles.bodyMedium12.copyWith(
                            color: AppColors.subColor2,
                          ),
                        ),
                      ],
                    ),
                    AppSpacing.verticalSpaceXSM, // 6
                    // COMPLETED 상태: 콘텐츠 제목 표시
                    if (notification.isCompleted &&
                        notification.contentTitle != null) ...[
                      Text(
                        notification.contentTitle!,
                        style: AppTextStyles.titleSemiBold14.copyWith(
                          color: AppColors.textColor1,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      AppSpacing.verticalSpaceXS, // 4
                    ],

                    // COMPLETED 상태: 콘텐츠 요약 표시
                    if (notification.isCompleted &&
                        notification.contentSummary != null) ...[
                      Text(
                        notification.contentSummary!,
                        style: AppTextStyles.bodyRegular14.copyWith(
                          color: AppColors.subColor2,
                        ),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                      AppSpacing.verticalSpaceXS, // 4
                    ],

                    // Row 2: 작성자 정보
                    Text(
                      l10n.authorPost(notification.author),
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
                            notification.url,
                            style: AppTextStyles.bodyMedium12.copyWith(
                              color: AppColors.subColor2,
                            ),
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        // 버튼 (오른쪽)
                        _buildStatusButton(notification),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        // 빨간 점 배지 (진행 중일 때만: PENDING 또는 ANALYZING)
        if (notification.isInProgress)
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
  ///
  /// [notification]: 알림 아이템
  ///
  /// 알림 상태에 따라 적절한 버튼을 반환합니다:
  /// - PENDING/ANALYZING: 로딩 버튼 (회색 배경, 스피너)
  /// - COMPLETED: 확인하기 버튼 (보라색 배경)
  /// - FAILED: 실패 버튼 (빨간색 테두리)
  Widget _buildStatusButton(NotificationItem notification) {
    switch (notification.status) {
      case NotificationStatus.pending:
      case NotificationStatus.analyzing:
        return _buildLoadingButton(notification.status);
      case NotificationStatus.completed:
        return _buildCompletedButton();
      case NotificationStatus.failed:
        return _buildFailedButton();
    }
  }

  /// 진행 중 버튼 (PENDING/ANALYZING 상태)
  ///
  /// [status]: 현재 상태 (PENDING 또는 ANALYZING)
  ///
  /// PENDING: "대기 중" 텍스트 표시
  /// ANALYZING: "처리 중" 텍스트 표시
  Widget _buildLoadingButton(NotificationStatus status) {
    final l10n = AppLocalizations.of(context);
    final message = status == NotificationStatus.pending
        ? l10n.notificationStatusWaiting
        : l10n.notificationStatusProcessing;

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
            message,
            style: AppTextStyles.bodyMedium14.copyWith(
              color: AppColors.textColor1.withValues(alpha: 0.5),
            ),
          ),
        ],
      ),
    );
  }

  /// 완료 버튼 (COMPLETED 상태)
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

  /// 실패 버튼 (FAILED 상태)
  Widget _buildFailedButton() {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.smd,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: AppColors.error.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppRadius.small),
        border: Border.all(color: AppColors.error, width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.error_outline,
            size: AppSpacing.lg,
            color: AppColors.error,
          ),
          AppSpacing.horizontalSpaceXS,
          Text(
            AppLocalizations.of(context).notificationStatusFailed,
            style: AppTextStyles.bodyMedium14.copyWith(color: AppColors.error),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    // 스트림 구독 해제
    _sharingSubscription?.cancel();
    _fcmSubscription?.cancel();

    // 폴링 타이머 취소
    _pollingTimer?.cancel();

    // 모든 타이머 취소
    for (final timer in _completionTimers.values) {
      timer.cancel();
    }
    _completionTimers.clear();

    super.dispose();
  }
}
