import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tripgether/core/theme/app_colors.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../core/services/sharing_service.dart';
import '../../../../core/utils/url_formatter.dart';
import '../../../../shared/widgets/common/info_container.dart';
import '../../../../shared/widgets/common/section_divider.dart';
import '../../../../shared/widgets/inputs/search_bar.dart';
import '../../../../shared/mixins/refreshable_tab_mixin.dart';
import '../../../debug/share_extension_log_screen.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../auth/providers/user_provider.dart';
import '../widgets/recent_sns_content_section.dart';
import '../widgets/recent_saved_places_section.dart';

/// 홈 화면 위젯
/// 앱의 메인 화면이며, 공유 데이터를 받아서 처리하는 기능을 포함
class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen>
    with AutomaticKeepAliveClientMixin, RefreshableTabMixin {
  // ════════════════════════════════════════════════════════════════════════
  // RefreshableTabMixin 필수 구현
  // ════════════════════════════════════════════════════════════════════════

  @override
  int get tabIndex => 0; // 홈 탭 (인덱스 0)

  @override
  Future<void> onRefreshData() async {
    // 홈 화면 데이터 새로고침
    if (mounted) {
      setState(() {
        // 데이터 새로고침 로직
      });
    }
  }

  // ════════════════════════════════════════════════════════════════════════
  // AutomaticKeepAliveClientMixin 필수 구현
  // ════════════════════════════════════════════════════════════════════════

  @override
  bool get wantKeepAlive => true; // 탭 전환 시 상태 유지

  // ════════════════════════════════════════════════════════════════════════
  // 홈 화면 전용 상태
  // ════════════════════════════════════════════════════════════════════════

  /// 공유 서비스 인스턴스
  late SharingService _sharingService;

  /// 공유 데이터 스트림 구독
  StreamSubscription<SharedData>? _sharingSubscription;

  /// 현재 받은 공유 데이터
  SharedData? _currentSharedData;

  /// 공유 데이터 처리 중 상태
  bool _isProcessingSharedData = false;

  @override
  void initState() {
    super.initState();
    // 공유 서비스 초기화 및 데이터 스트림 구독
    _initializeSharingService();

    // RefreshableTabMixin이 자동으로 콜백 등록을 처리함
  }

  /// 공유 서비스 초기화 및 스트림 구독 설정
  Future<void> _initializeSharingService() async {
    _sharingService = SharingService.instance;

    // 공유 서비스 재개 (이전에 일시정지된 경우 재활성화)
    _sharingService.resume();

    // main.dart에서 이미 초기화되었으므로 여기서는 초기화하지 않음
    // await _sharingService.initialize(); // 제거됨

    // 공유 데이터 스트림 구독
    _sharingSubscription = _sharingService.dataStream.listen(
      _handleSharedData,
      onError: (error) {
        debugPrint('[HomeScreen] 공유 데이터 스트림 에러: $error');
      },
    );

    // 이미 저장된 공유 데이터가 있는지 확인
    if (_sharingService.currentSharedData != null) {
      _handleSharedData(_sharingService.currentSharedData!);
    }
  }

  /// 공유 데이터 처리
  void _handleSharedData(SharedData sharedData) {
    debugPrint('[HomeScreen] 공유 데이터 수신: ${sharedData.toString()}');

    setState(() {
      _currentSharedData = sharedData;
      _isProcessingSharedData = true;
    });

    // 데이터 타입에 따른 처리
    if (sharedData.hasTextData) {
      // 텍스트/URL 데이터 처리
      _processTextData(sharedData.sharedTexts);
    }

    if (sharedData.hasMediaData) {
      // 미디어 파일 데이터 처리
      _processMediaFiles(sharedData.sharedFiles);
    }

    // 처리 완료 후 상태 업데이트
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _isProcessingSharedData = false;
        });
      }
    });
  }

  /// 텍스트/URL 데이터 처리
  void _processTextData(List<String> texts) {
    for (final text in texts) {
      debugPrint('[HomeScreen] 텍스트 데이터: $text');

      // URL인지 확인
      if (UrlFormatter.isValidUrl(text)) {
        // 🧹 추적 파라미터 제거하여 깔끔한 URL로 정리
        final cleanedUrl = UrlFormatter.cleanUrl(text);
        final urlType = UrlFormatter.getUrlType(cleanedUrl);
        final domain = UrlFormatter.extractDomain(cleanedUrl);

        debugPrint('[HomeScreen] 🔗 URL 감지: $cleanedUrl');
        debugPrint('[HomeScreen] 📱 플랫폼: $urlType');
        debugPrint('[HomeScreen] 🌐 도메인: $domain');

        // URL에 따른 처리 (여행 정보 파싱)
      } else {
        debugPrint('[HomeScreen] 📝 일반 텍스트: $text');
        // 일반 텍스트 처리 (여행 메모)
      }
    }
  }

  /// 미디어 파일 데이터 처리
  void _processMediaFiles(List<SharedMediaFile> files) {
    // 파일 타입별로 분류
    final images = files.where((f) => f.type == SharedMediaType.image).toList();
    final videos = files.where((f) => f.type == SharedMediaType.video).toList();
    final docs = files.where((f) => f.type == SharedMediaType.file).toList();

    if (images.isNotEmpty) {
      debugPrint('[HomeScreen] 이미지 ${images.length}개 수신');
      // 이미지 처리 (여행 사진 업로드)
    }

    if (videos.isNotEmpty) {
      debugPrint('[HomeScreen] 동영상 ${videos.length}개 수신');
      // 동영상 처리
    }

    if (docs.isNotEmpty) {
      debugPrint('[HomeScreen] 문서 ${docs.length}개 수신');
      // 문서 처리
    }
  }

  /// 공유 데이터 표시용 위젯 생성
  Widget _buildSharedDataDisplay() {
    if (_currentSharedData == null) {
      return const SizedBox.shrink();
    }

    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return InfoContainer(
      title: '공유 데이터 수신됨',
      titleIcon: Icons.share_arrival_time,
      titleTrailing: _isProcessingSharedData
          ? SizedBox(
              width: 16.w,
              height: 16.w,
              child: const CircularProgressIndicator(strokeWidth: 2),
            )
          : null,
      actions: [
        TextButton(
          onPressed: () {
            // 공유 데이터 삭제
            setState(() {
              _currentSharedData = null;
            });
            _sharingService.clearCurrentData();
          },
          child: const Text('닫기'),
        ),
        SizedBox(width: AppSpacing.xs),
        ElevatedButton(
          onPressed: () {
            // 공유 데이터를 활용한 액션 (여행 생성)
            debugPrint('[HomeScreen] 공유 데이터 활용 액션 실행');
          },
          child: const Text('여행 만들기'),
        ),
      ],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // 텍스트 데이터 표시
          if (_currentSharedData!.hasTextData) ...[
            Text(
              '텍스트 (${_currentSharedData!.sharedTexts.length}개):',
              style: AppTextStyles.bodyRegular14.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: AppSpacing.xs),
            ..._currentSharedData!.sharedTexts.map(
              (text) => Padding(
                padding: EdgeInsets.only(
                  left: AppSpacing.xs,
                  bottom: AppSpacing.xs,
                ),
                child: Text(
                  '• ${text.length > 50 ? '${text.substring(0, 50)}...' : text}',
                  style: AppTextStyles.bodyRegular14.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
            ),
            SizedBox(height: AppSpacing.xs),
          ],

          // 미디어 파일 정보 표시
          if (_currentSharedData!.hasMediaData) ...[
            Text(
              '미디어 파일 (${_currentSharedData!.sharedFiles.length}개):',
              style: AppTextStyles.bodyRegular14.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: AppSpacing.xs),
            Wrap(
              spacing: AppSpacing.xs,
              children: [
                if (_currentSharedData!.images.isNotEmpty)
                  _buildFileTypeChip(
                    Icons.image,
                    '이미지 ${_currentSharedData!.images.length}',
                  ),
                if (_currentSharedData!.videos.isNotEmpty)
                  _buildFileTypeChip(
                    Icons.video_library,
                    '동영상 ${_currentSharedData!.videos.length}',
                  ),
                if (_currentSharedData!.files.isNotEmpty)
                  _buildFileTypeChip(
                    Icons.description,
                    '파일 ${_currentSharedData!.files.length}',
                  ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  /// 파일 타입 표시용 칩 위젯
  Widget _buildFileTypeChip(IconData icon, String label) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.xs,
        vertical: AppSpacing.xs / 2,
      ),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: AppRadius.circular(16),
        border: Border.all(color: colorScheme.outlineVariant),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16.w, color: colorScheme.primary),
          SizedBox(width: AppSpacing.xs),
          Text(
            label,
            style: AppTextStyles.buttonMediumMedium14.copyWith(
              color: colorScheme.primary,
            ),
          ),
        ],
      ),
    );
  }

  /// 홈 화면 헤더 위젯 (로고, 인사말, 검색창)
  Widget _buildHeader(BuildContext context, String nickname) {
    final l10n = AppLocalizations.of(context);

    return Container(
      color: AppColors.backgroundLight,
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: EdgeInsets.only(
            left: AppSpacing.lg,
            right: AppSpacing.lg,
            top: AppSpacing.md.h,
            bottom: AppSpacing.lg.h,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 로고 + 알림 아이콘 Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Tripgether 로고
                  Image.asset(
                    'assets/tripgether_text_logo.png',
                    width: 110.w,
                    height: 35.h,
                    fit: BoxFit.contain,
                  ),
                  // 알림 아이콘
                  GestureDetector(
                    onTap: () {
                      debugPrint('알림 아이콘 클릭');
                    },
                    child: SvgPicture.asset(
                      'assets/icons/alarm_inactive.svg',
                      width: AppSizes.iconXLarge,
                      height: AppSizes.iconXLarge,
                    ),
                  ),
                ],
              ),

              AppSpacing.verticalSpaceLG,

              // 인사말
              Text(
                l10n.greeting(nickname),
                style: AppTextStyles.greetingBold20.copyWith(
                  color: AppColors.mainColor,
                ),
              ),

              AppSpacing.verticalSpaceXS,
              // 부제목
              Text(
                l10n.greetingSubtitle,
                style: AppTextStyles.greetingBold20.copyWith(
                  color: AppColors.mainColor,
                ),
              ),

              AppSpacing.verticalSpaceLG,

              // 검색창
              TripSearchBar(
                hintText: l10n.searchHint,
                readOnly: false,
                onTap: () {
                  debugPrint('검색창 클릭 - 검색 화면으로 이동');
                },
                onChanged: (text) {
                  debugPrint('검색어 입력: $text');
                },
                onSubmitted: (text) {
                  debugPrint('검색 실행: $text');
                  // 검색 결과 화면으로 이동 예정
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // AutomaticKeepAliveClientMixin 필수 호출

    return Scaffold(
      backgroundColor: AppColors.white,
      body: Column(
        children: [
          // 상단 헤더 영역 (배경색 있음)
          Consumer(
            builder: (context, ref, child) {
              final userAsync = ref.watch(userNotifierProvider);
              final nickname = userAsync.when(
                loading: () => '사용자',
                error: (_, _) => '사용자',
                data: (user) => user?.nickname ?? '사용자',
              );
              return _buildHeader(context, nickname);
            },
          ),
          // 하단 콘텐츠 영역 (흰색 배경)
          Expanded(
            child: CustomScrollView(
              controller: scrollController,
              slivers: [
                CupertinoSliverRefreshControl(onRefresh: onRefresh),
                SliverList(
                  delegate: SliverChildListDelegate([
                    // 공유 데이터 표시 영역
                    if (_currentSharedData != null) ...[
                      Padding(
                        padding: EdgeInsets.all(AppSpacing.lg),
                        child: _buildSharedDataDisplay(),
                      ),
                    ],

                    // 최근 SNS에서 본 콘텐츠 섹션
                    RecentSnsContentSection(),

                    // 섹션 구분선
                    const SectionDivider.thick(),

                    // 최근 저장한 장소 섹션
                    RecentSavedPlacesSection(),

                    // 디버깅용 버튼
                    if (const bool.fromEnvironment('dart.vm.product') ==
                        false) ...[
                      AppSpacing.verticalSpaceXL,
                      Padding(
                        padding: EdgeInsets.all(AppSpacing.lg),
                        child: Center(
                          child: ElevatedButton(
                            onPressed: () async {
                              // 모든 데이터 초기화 (테스트용)
                              await _sharingService.resetAllData();
                              setState(() {
                                _currentSharedData = null;
                              });
                            },
                            child: const Text('공유 데이터 초기화 (테스트)'),
                          ),
                        ),
                      ),
                    ],

                    // 하단 여백
                    AppSpacing.verticalSpaceXL,
                  ]),
                ),
              ],
            ),
          ),
        ],
      ),
      // 디버그용 FloatingActionButton (Share Extension 로그 확인)
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const ShareExtensionLogScreen(),
            ),
          );
        },
        tooltip: 'Share Extension 로그',
        child: const Icon(Icons.bug_report),
      ),
    );
  }

  @override
  void dispose() {
    // RefreshableTabMixin이 자동으로 탭 콜백 해제 및 컨트롤러 정리 처리

    // 스트림 구독 해제
    _sharingSubscription?.cancel();

    // SharingService 일시정지 (타이머 및 lifecycle 리스너 정리)
    _sharingService.pause();

    super.dispose();
  }
}
