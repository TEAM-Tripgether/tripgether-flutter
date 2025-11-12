import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/router/routes.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../shared/widgets/common/common_app_bar.dart';
import '../../../../shared/widgets/common/platform_icon.dart';
import '../../../../shared/widgets/cards/sns_content_card.dart';
import '../../data/models/sns_content_model.dart';

/// SNS 콘텐츠 목록 화면
///
/// 그리드 레이아웃으로 SNS 콘텐츠를 표시하고
/// 플랫폼별 필터링과 무한 스크롤을 지원합니다
class SnsContentsListScreen extends StatefulWidget {
  const SnsContentsListScreen({super.key});

  @override
  State<SnsContentsListScreen> createState() => _SnsContentsListScreenState();
}

/// 필터 설정 데이터 클래스
class _FilterConfig {
  final SnsSource? source;
  final String label;
  final Color? selectedColor;
  final bool showIcon;

  const _FilterConfig({
    this.source,
    required this.label,
    this.selectedColor,
    this.showIcon = false,
  });
}

class _SnsContentsListScreenState extends State<SnsContentsListScreen> {
  /// 현재 선택된 필터
  SnsSource? _selectedFilter;

  /// 전체 콘텐츠 리스트
  final List<SnsContent> _allContents = [];

  /// 필터링된 콘텐츠 리스트
  List<SnsContent> _filteredContents = [];

  /// 스크롤 컨트롤러
  final ScrollController _scrollController = ScrollController();

  /// 로딩 중 상태
  bool _isLoading = false;

  /// 더 이상 데이터가 없는지 여부
  bool _hasMore = true;

  /// 필터 설정 목록 (확장 가능한 구조)
  /// 새로운 SNS 플랫폼 추가 시 여기에만 데이터를 추가하면 됨
  List<_FilterConfig> get _filterConfigs => [
    _FilterConfig(
      source: null, // null = 전체 보기
      label: AppLocalizations.of(context).filterAll,
      selectedColor: Theme.of(context).primaryColor.withValues(alpha: 0.2),
      showIcon: false,
    ),
    _FilterConfig(
      source: SnsSource.youtube,
      label: AppLocalizations.of(context).filterYoutube,
      selectedColor: Colors.red.withValues(alpha: 0.2),
      showIcon: true,
    ),
    _FilterConfig(
      source: SnsSource.instagram,
      label: AppLocalizations.of(context).filterInstagram,
      selectedColor: Colors.purple.withValues(alpha: 0.2),
      showIcon: true,
    ),
    // 새로운 플랫폼 추가 예시:
    // _FilterConfig(
    //   source: SnsSource.tiktok,
    //   label: AppLocalizations.of(context).filterTiktok,
    //   selectedColor: Colors.black.withValues(alpha: 0.2),
    //   showIcon: true,
    // ),
  ];

  @override
  void initState() {
    super.initState();
    _loadInitialData();
    _scrollController.addListener(_onScroll);
  }

  /// 초기 데이터 로드
  void _loadInitialData() {
    // 더미 데이터 로드 (실제로는 API 호출)
    // 기본 6개의 샘플 콘텐츠만 로드
    _allContents.addAll(SnsContentDummyData.getSampleContents());
    _filteredContents = List.from(_allContents);
    setState(() {});
  }

  /// 스크롤 이벤트 처리 (무한 스크롤)
  void _onScroll() {
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 200 &&
        !_isLoading &&
        _hasMore) {
      _loadMoreData();
    }
  }

  /// 추가 데이터 로드
  Future<void> _loadMoreData() async {
    setState(() {
      _isLoading = true;
    });

    // 실제로는 API 호출하여 데이터 가져오기
    await Future.delayed(const Duration(seconds: 1));

    // 현재 콘텐츠 개수를 기반으로 고유한 ID를 가진 더미 데이터 생성
    final currentCount = _allContents.length;
    final moreContents = List.generate(6, (index) {
      final dummyData = _getDummyData(currentCount + index);
      return SnsContent.dummy(
        id: '${currentCount + index + 1}', // 고유한 ID 생성
        title: dummyData['title'] as String,
        source: dummyData['source'] as SnsSource,
        creatorName: dummyData['creator'] as String,
      );
    });

    setState(() {
      _allContents.addAll(moreContents);
      _applyFilter();
      _isLoading = false;

      // 3번 로드하면 더 이상 없다고 표시 (총 6 + 6*3 = 24개)
      if (_allContents.length >= 24) {
        _hasMore = false;
      }
    });
  }

  /// 더미 데이터 템플릿 (확장 가능한 구조)
  /// 새로운 더미 콘텐츠 추가 시 여기에만 데이터를 추가하면 됨
  static const List<Map<String, dynamic>> _dummyTemplates = [
    {'title': '속초 해변 일출 명소', 'source': SnsSource.youtube, 'creator': '여행러버'},
    {
      'title': '대구 서문시장 먹방 투어',
      'source': SnsSource.instagram,
      'creator': '@travel_lover',
    },
    {
      'title': '인천 차이나타운 당일치기',
      'source': SnsSource.youtube,
      'creator': '국내여행가이드',
    },
    {
      'title': '수원 화성 역사 탐방',
      'source': SnsSource.instagram,
      'creator': '@korea_travel',
    },
    {'title': '춘천 남이섬 단풍 여행', 'source': SnsSource.youtube, 'creator': '여행브이로거'},
    {
      'title': '여수 밤바다 야경 포인트',
      'source': SnsSource.instagram,
      'creator': '@vlog_korea',
    },
  ];

  /// 더미 데이터 가져오기 (통합 메서드)
  /// [index] 인덱스에 해당하는 더미 데이터 반환
  Map<String, dynamic> _getDummyData(int index) {
    return _dummyTemplates[index % _dummyTemplates.length];
  }

  /// 필터 적용
  void _applyFilter() {
    if (_selectedFilter == null) {
      _filteredContents = List.from(_allContents);
    } else {
      _filteredContents = _allContents
          .where((content) => content.source == _selectedFilter)
          .toList();
    }
  }

  /// 필터 변경
  void _onFilterChanged(SnsSource? filter) {
    setState(() {
      _selectedFilter = filter;
      _applyFilter();
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: CommonAppBar.forSubPage(title: l10n.recentSnsContent),
      body: Column(
        children: [
          // 필터 칩들
          _buildFilterChips(l10n),

          // 콘텐츠 그리드
          Expanded(child: _buildContentGrid(l10n)),
        ],
      ),
    );
  }

  /// 필터 칩 빌드 (데이터 기반 확장 가능 구조)
  Widget _buildFilterChips(AppLocalizations l10n) {
    return Container(
      height: 50.h,
      padding: AppSpacing.symmetric(horizontal: 16),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _filterConfigs.length,
        itemBuilder: (context, index) {
          final config = _filterConfigs[index];
          return _buildSingleFilterChip(config);
        },
      ),
    );
  }

  /// 개별 필터 칩 빌드
  /// [config] 필터 설정 데이터
  Widget _buildSingleFilterChip(_FilterConfig config) {
    final isSelected = _selectedFilter == config.source;

    return Padding(
      padding: AppSpacing.only(right: 8),
      child: FilterChip(
        label: config.showIcon && config.source != null
            ? Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  PlatformIcon(source: config.source!, size: 16.w),
                  AppSpacing.horizontalSpaceXS,
                  Text(config.label),
                ],
              )
            : Text(config.label),
        selected: isSelected,
        onSelected: (_) => _onFilterChanged(config.source),
        selectedColor: config.selectedColor,
      ),
    );
  }

  /// 콘텐츠 그리드 빌드
  Widget _buildContentGrid(AppLocalizations l10n) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    if (_filteredContents.isEmpty && !_isLoading) {
      return Center(
        child: Text(
          l10n.noData,
          style: AppTextStyles.bodyMedium16.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () async {
        // 새로고침 로직
        setState(() {
          _allContents.clear();
          _hasMore = true;
        });
        _loadInitialData();
      },
      child: GridView.builder(
        controller: _scrollController,
        padding: AppSpacing.cardPadding,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10.w,
          mainAxisSpacing: 10.w,
          childAspectRatio: 0.60, // 썸네일 250.h + 제목 영역을 고려한 비율
        ),
        itemCount:
            _filteredContents.length +
            (_isLoading ? 2 : 0) +
            (!_hasMore ? 1 : 0),
        itemBuilder: (context, index) {
          // 로딩 인디케이터
          if (index >= _filteredContents.length) {
            if (!_hasMore) {
              return Center(
                child: Padding(
                  padding: AppSpacing.cardPadding,
                  child: Text(
                    l10n.noMoreContent,
                    style: AppTextStyles.bodyRegular14.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
              );
            }
            return _buildLoadingCard();
          }

          // 콘텐츠 카드 (Hero 애니메이션 적용)
          // 리스트 → 상세 화면 전환 시 이미지가 확대되는 효과
          final content = _filteredContents[index];
          return Hero(
            tag: 'sns_content_${content.id}',
            child: SnsContentCard(
              content: content,
              margin: EdgeInsets.zero, // EdgeInsets.zero는 유지
              isGridLayout: true,
              onTap: () {
                final detailPath = AppRoutes.snsContentDetail.replaceFirst(
                  ':contentId',
                  content.id,
                );
                context.go(
                  detailPath,
                  extra: {'contents': _filteredContents, 'initialIndex': index},
                );
              },
            ),
          );
        },
      ),
    );
  }

  /// 로딩 카드 빌드
  Widget _buildLoadingCard() {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Center(
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(theme.primaryColor),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
