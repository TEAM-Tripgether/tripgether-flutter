import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../core/router/routes.dart';
import '../../../../core/services/sharing_service.dart';
import '../../../../core/utils/url_formatter.dart';
import '../../../../shared/widgets/common/common_app_bar.dart';
import '../../../../shared/widgets/common/section_divider.dart';
import '../../../../shared/widgets/common/info_container.dart';
import '../../../../shared/widgets/layout/greeting_section.dart';
import '../../../../shared/widgets/cards/sns_content_card.dart';
import '../../../../shared/widgets/cards/place_card.dart';
import '../../../debug/share_extension_log_screen.dart';
import '../../data/models/sns_content_model.dart';
import '../../data/models/place_model.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../auth/providers/user_provider.dart';

/// 홈 화면 위젯
/// 앱의 메인 화면이며, 공유 데이터를 받아서 처리하는 기능을 포함
class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  /// 공유 서비스 인스턴스
  late SharingService _sharingService;

  /// 공유 데이터 스트림 구독
  StreamSubscription<SharedData>? _sharingSubscription;

  /// 현재 받은 공유 데이터
  SharedData? _currentSharedData;

  /// 공유 데이터 처리 중 상태
  bool _isProcessingSharedData = false;

  /// 더미 SNS 콘텐츠 리스트
  late List<SnsContent> _snsContents;

  /// 더미 저장 장소 리스트
  late List<SavedPlace> _savedPlaces;

  @override
  void initState() {
    super.initState();
    // 공유 서비스 초기화 및 데이터 스트림 구독
    _initializeSharingService();

    // 더미 데이터 초기화
    _snsContents = SnsContentDummyData.getSampleContents();
    _savedPlaces = SavedPlaceDummyData.getSamplePlaces();
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

        // TODO: URL에 따른 처리 (여행 정보 파싱 등)
      } else {
        debugPrint('[HomeScreen] 📝 일반 텍스트: $text');
        // TODO: 일반 텍스트 처리 (여행 메모 등)
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
      // TODO: 이미지 처리 (여행 사진 업로드 등)
    }

    if (videos.isNotEmpty) {
      debugPrint('[HomeScreen] 동영상 ${videos.length}개 수신');
      // TODO: 동영상 처리
    }

    if (docs.isNotEmpty) {
      debugPrint('[HomeScreen] 문서 ${docs.length}개 수신');
      // TODO: 문서 처리
    }
  }

  /// 공유 데이터 표시용 위젯 생성
  Widget _buildSharedDataDisplay() {
    if (_currentSharedData == null) {
      return const SizedBox.shrink();
    }

    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
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
            // TODO: 공유 데이터를 활용한 액션 (여행 생성 등)
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
              style: textTheme.bodyMedium?.copyWith(
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
                  style: textTheme.bodyMedium?.copyWith(
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
              style: textTheme.bodyMedium?.copyWith(
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
    final textTheme = theme.textTheme;
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
            style: textTheme.labelMedium?.copyWith(color: colorScheme.primary),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final colorScheme = theme.colorScheme;

    return Scaffold(
      // CommonAppBar를 사용하여 일관된 AppBar UI 제공
      appBar: CommonAppBar(
        title: 'Tripgether',
        showMenuButton: true, // 햄버거 메뉴 표시 (다른 화면과 일관성 유지)
        onNotificationPressed: () {
          // 알림 버튼을 눌렀을 때의 동작
          debugPrint('홈 화면 알림 버튼 클릭');
        },
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 공유 데이터 표시 영역
            if (_currentSharedData != null) _buildSharedDataDisplay(),

            // 홈 헤더 (인사말 + 검색창 통합)
            // userNotifierProvider를 통해 실시간 사용자 정보 가져오기
            Consumer(
              builder: (context, ref, child) {
                final userAsync = ref.watch(userNotifierProvider);

                return userAsync.when(
                  // 로딩 중: 기본 닉네임으로 표시
                  loading: () => HomeHeader(
                    nickname: '사용자',
                    greeting: l10n.greeting('사용자'),
                    greetingSubtitle: l10n.greetingSubtitle,
                    searchHint: l10n.searchHint,
                    onSearchTap: () {
                      debugPrint('검색창 클릭 - 검색 화면으로 이동');
                    },
                  ),
                  // 에러 발생: 기본 닉네임으로 표시
                  error: (error, stack) => HomeHeader(
                    nickname: '사용자',
                    greeting: l10n.greeting('사용자'),
                    greetingSubtitle: l10n.greetingSubtitle,
                    searchHint: l10n.searchHint,
                    onSearchTap: () {
                      debugPrint('검색창 클릭 - 검색 화면으로 이동');
                    },
                  ),
                  // 데이터 로드 완료: 실제 사용자 닉네임 표시
                  data: (user) {
                    final nickname = user?.nickname ?? '사용자';
                    return HomeHeader(
                      nickname: nickname,
                      greeting: l10n.greeting(nickname),
                      greetingSubtitle: l10n.greetingSubtitle,
                      searchHint: l10n.searchHint,
                      onSearchTap: () {
                        debugPrint('검색창 클릭 - 검색 화면으로 이동');
                      },
                    );
                  },
                );
              },
            ),

            SizedBox(height: 16.h),

            // 최근 SNS에서 본 콘텐츠 섹션 (빈 상태 처리 추가)
            if (_snsContents.isEmpty)
              // SNS 콘텐츠가 없을 때 빈 상태 메시지 표시
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: AppSpacing.lg,
                  vertical: AppSpacing.huge,
                ),
                child: Center(
                  child: Text(
                    l10n.noSnsContentYet,
                    style: textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w400,
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
              )
            else
              // SNS 콘텐츠가 있을 때 리스트 표시 (처음 6개만)
              SnsContentHorizontalList(
                contents: _snsContents.take(6).toList(),
                title: l10n.recentSnsContent,
                onSeeMoreTap: () {
                  // SNS 콘텐츠 목록 화면으로 이동
                  context.push(AppRoutes.snsContentsList);
                },
                onContentTap: (content, index) {
                  // 개별 콘텐츠 카드 탭 시 상세 화면으로 이동
                  // 전체 리스트와 현재 인덱스를 전달하여 가로 스와이프 네비게이션 지원
                  final detailPath = AppRoutes.snsContentDetail.replaceFirst(
                    ':contentId',
                    content.id,
                  );
                  context.go(
                    detailPath,
                    extra: {
                      'contents': _snsContents.take(6).toList(),
                      'initialIndex': index,
                    },
                  );
                },
              ),

            SizedBox(height: 24.h),

            // 섹션 구분선 (더 두꺼운 배경색 영역)
            const SectionDivider.thick(),

            SizedBox(height: 24.h),

            // 최근 저장한 장소 섹션 (세로 리스트, 이미지 가로 스크롤)
            // 처음 3개만 표시하여 스크롤 부담 감소
            PlaceListSection(
              places: _savedPlaces,
              title: l10n.recentSavedPlaces,
              maxItems: 3,
              onPlaceTap: (place) {
                // 장소 카드 클릭 시 바로 상세 화면으로 이동
                final detailPath = AppRoutes.placeDetail.replaceFirst(
                  ':placeId',
                  place.id,
                );
                context.go(detailPath, extra: place);
              },
              onSeeMoreTap: () {
                // 저장한 장소 목록 화면으로 이동
                context.push(AppRoutes.savedPlacesList);
              },
            ),

            // 디버깅용 버튼
            if (const bool.fromEnvironment('dart.vm.product') == false) ...[
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
            SizedBox(height: 20.h),
          ],
        ),
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
    // 스트림 구독 해제
    _sharingSubscription?.cancel();

    // SharingService 일시정지 (타이머 및 lifecycle 리스너 정리)
    _sharingService.pause();

    super.dispose();
  }
}
