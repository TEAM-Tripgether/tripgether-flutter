import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/router/routes.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../shared/widgets/common/common_app_bar.dart';
import '../../../../shared/widgets/common/platform_icon.dart';
import '../../../../shared/widgets/layout/sns_content_card.dart';
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
    final moreContents = List.generate(
      6,
      (index) => SnsContent.dummy(
        id: '${currentCount + index + 1}', // 고유한 ID 생성
        title: _getDummyTitle(currentCount + index),
        source: _getDummySource(currentCount + index),
        creatorName: _getDummyCreator(currentCount + index),
      ),
    );

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

  /// 더미 제목 생성
  String _getDummyTitle(int index) {
    final titles = [
      '속초 해변 일출 명소',
      '대구 서문시장 먹방 투어',
      '인천 차이나타운 당일치기',
      '수원 화성 역사 탐방',
      '춘천 남이섬 단풍 여행',
      '여수 밤바다 야경 포인트',
    ];
    return titles[index % titles.length];
  }

  /// 더미 소스 생성
  SnsSource _getDummySource(int index) {
    final sources = [
      SnsSource.youtube,
      SnsSource.instagram,
      SnsSource.youtube,
      SnsSource.instagram,
      SnsSource.youtube,
      SnsSource.instagram,
    ];
    return sources[index % sources.length];
  }

  /// 더미 크리에이터 생성
  String _getDummyCreator(int index) {
    final creators = [
      '여행러버',
      '@travel_lover',
      '국내여행가이드',
      '@korea_travel',
      '여행브이로거',
      '@vlog_korea',
    ];
    return creators[index % creators.length];
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
      appBar: CommonAppBar.forSubPage(
        title: l10n.recentSnsContent,
      ),
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

  /// 필터 칩 빌드
  Widget _buildFilterChips(AppLocalizations l10n) {
    return Container(
      height: 50.h,
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          // 전체 필터
          Padding(
            padding: EdgeInsets.only(right: 8.w),
            child: FilterChip(
              label: Text(l10n.filterAll),
              selected: _selectedFilter == null,
              onSelected: (_) => _onFilterChanged(null),
              selectedColor: Theme.of(
                context,
              ).primaryColor.withValues(alpha: 0.2),
            ),
          ),
          // YouTube 필터
          Padding(
            padding: EdgeInsets.only(right: 8.w),
            child: FilterChip(
              label: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  PlatformIcon(source: SnsSource.youtube, size: 16.w),
                  SizedBox(width: 4.w),
                  Text(l10n.filterYoutube),
                ],
              ),
              selected: _selectedFilter == SnsSource.youtube,
              onSelected: (_) => _onFilterChanged(SnsSource.youtube),
              selectedColor: Colors.red.withValues(alpha: 0.2),
            ),
          ),
          // Instagram 필터
          Padding(
            padding: EdgeInsets.only(right: 8.w),
            child: FilterChip(
              label: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  PlatformIcon(source: SnsSource.instagram, size: 16.w),
                  SizedBox(width: 4.w),
                  Text(l10n.filterInstagram),
                ],
              ),
              selected: _selectedFilter == SnsSource.instagram,
              onSelected: (_) => _onFilterChanged(SnsSource.instagram),
              selectedColor: Colors.purple.withValues(alpha: 0.2),
            ),
          ),
        ],
      ),
    );
  }

  /// 콘텐츠 그리드 빌드
  Widget _buildContentGrid(AppLocalizations l10n) {
    if (_filteredContents.isEmpty && !_isLoading) {
      return Center(
        child: Text(
          l10n.noData,
          style: TextStyle(
            fontFamily: 'Pretendard',
            fontSize: 16.sp,
            color: Colors.grey[600],
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
        padding: EdgeInsets.all(16.w),
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
                  padding: EdgeInsets.all(16.h),
                  child: Text(
                    l10n.noMoreContent,
                    style: TextStyle(
                      fontFamily: 'Pretendard',
                      fontSize: 14.sp,
                      color: Colors.grey[500],
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
              margin: EdgeInsets.zero,
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
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Center(
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(
            Theme.of(context).primaryColor,
          ),
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
