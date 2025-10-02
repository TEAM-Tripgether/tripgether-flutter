import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/router/routes.dart';
import '../../../../l10n/app_localizations.dart';
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
    _allContents.addAll(SnsContentDummyData.getSampleContents());
    _allContents.addAll(SnsContentDummyData.getSampleContents()); // 더 많은 데이터
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

    // 더미 데이터 추가
    final moreContents = SnsContentDummyData.getSampleContents();

    setState(() {
      _allContents.addAll(moreContents);
      _applyFilter();
      _isLoading = false;

      // 데이터가 적으면 더 이상 없다고 표시
      if (moreContents.length < 3) {
        _hasMore = false;
      }
    });
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
      appBar: AppBar(title: Text(l10n.recentSnsContent), elevation: 0),
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
                  Icon(Icons.play_circle_filled, size: 16.w, color: Colors.red),
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
                  Icon(Icons.camera_alt, size: 16.w, color: Colors.purple),
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
          crossAxisSpacing: 12.w,
          mainAxisSpacing: 12.w,
          childAspectRatio:
              0.58, // sns_content_card (120w:170h) + 제목 영역을 고려한 비율
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

          // 콘텐츠 카드
          return _buildContentCard(_filteredContents[index], index, l10n);
        },
      ),
    );
  }

  /// 콘텐츠 카드 빌드 (간단하게: 썸네일 + 플랫폼 로고 + 제목)
  Widget _buildContentCard(
    SnsContent content,
    int index,
    AppLocalizations l10n,
  ) {
    return GestureDetector(
      onTap: () {
        // SNS 콘텐츠 상세 화면으로 네비게이션
        final detailPath = AppRoutes.snsContentDetail.replaceFirst(
          ':contentId',
          content.id,
        );
        context.go(
          detailPath,
          extra: {'contents': _filteredContents, 'initialIndex': index},
        );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 썸네일 이미지
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12.r),
              child: CachedNetworkImage(
                imageUrl: content.thumbnailUrl,
                width: double.infinity,
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  color: Colors.grey[200],
                  child: Center(
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Colors.grey[400]!,
                      ),
                    ),
                  ),
                ),
                errorWidget: (context, url, error) => Container(
                  color: Colors.grey[200],
                  child: Icon(
                    Icons.image_not_supported,
                    size: 48.w,
                    color: Colors.grey[400],
                  ),
                ),
              ),
            ),
          ),

          SizedBox(height: 8.h),

          // 플랫폼 로고 + 제목
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 플랫폼 로고
              _buildPlatformIcon(content.source),

              SizedBox(width: 8.w),

              // 제목
              Expanded(
                child: Text(
                  content.title,
                  style: TextStyle(
                    fontFamily: 'Pretendard',
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// 플랫폼 아이콘 빌드
  Widget _buildPlatformIcon(SnsSource source) {
    IconData icon;
    Color backgroundColor;

    switch (source) {
      case SnsSource.youtube:
        icon = Icons.play_circle_filled;
        backgroundColor = Colors.red;
        break;
      case SnsSource.instagram:
        icon = Icons.camera_alt;
        backgroundColor = Colors.purple;
        break;
      case SnsSource.tiktok:
        icon = Icons.music_note;
        backgroundColor = Colors.black;
        break;
    }

    return Container(
      padding: EdgeInsets.all(6.w),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Icon(icon, size: 18.w, color: Colors.white),
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
