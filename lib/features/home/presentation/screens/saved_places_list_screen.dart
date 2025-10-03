import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../shared/widgets/common/common_app_bar.dart';
import '../../../../shared/widgets/layout/place_card.dart';
import '../../data/models/place_model.dart';

/// 저장한 장소 목록 화면
///
/// 그리드 레이아웃으로 저장한 장소를 표시하고
/// 카테고리별 필터링을 지원합니다
class SavedPlacesListScreen extends StatefulWidget {
  const SavedPlacesListScreen({super.key});

  @override
  State<SavedPlacesListScreen> createState() => _SavedPlacesListScreenState();
}

class _SavedPlacesListScreenState extends State<SavedPlacesListScreen> {
  /// 현재 선택된 카테고리 필터
  PlaceCategory? _selectedCategory;

  /// 전체 장소 리스트
  final List<SavedPlace> _allPlaces = [];

  /// 필터링된 장소 리스트
  List<SavedPlace> _filteredPlaces = [];

  /// 스크롤 컨트롤러
  final ScrollController _scrollController = ScrollController();

  /// 로딩 중 상태
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadInitialData();
    _scrollController.addListener(_onScroll);
  }

  /// 초기 데이터 로드
  void _loadInitialData() {
    // 더미 데이터 로드 (실제로는 API 호출)
    _allPlaces.addAll(SavedPlaceDummyData.getSamplePlaces());
    _filteredPlaces = List.from(_allPlaces);
    setState(() {});
  }

  /// 스크롤 이벤트 처리 (무한 스크롤)
  void _onScroll() {
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 200 &&
        !_isLoading) {
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

    // 현재 장소 개수를 기반으로 고유한 ID를 가진 더미 데이터 생성
    final currentCount = _allPlaces.length;
    final morePlaces = List.generate(
      6,
      (index) => SavedPlace.dummy(
        id: '${currentCount + index + 1}',
        name: _getDummyName(currentCount + index),
        category: _getDummyCategory(currentCount + index),
        address: _getDummyAddress(currentCount + index),
      ),
    );

    setState(() {
      _allPlaces.addAll(morePlaces);
      _applyFilter();
      _isLoading = false;
    });
  }

  /// 더미 이름 생성
  String _getDummyName(int index) {
    final names = [
      '홍대 감성 카페',
      '연남동 맛집',
      '강남 루프탑 바',
      '이태원 브런치',
      '북촌 한옥카페',
      '망원동 디저트',
    ];
    return names[index % names.length];
  }

  /// 더미 카테고리 생성
  PlaceCategory _getDummyCategory(int index) {
    final categories = PlaceCategory.values;
    return categories[index % categories.length];
  }

  /// 더미 주소 생성
  String _getDummyAddress(int index) {
    final addresses = [
      '서울 마포구 홍대입구',
      '서울 마포구 연남동',
      '서울 강남구 역삼동',
      '서울 용산구 이태원동',
      '서울 종로구 북촌로',
      '서울 마포구 망원동',
    ];
    return addresses[index % addresses.length];
  }

  /// 필터 적용
  void _applyFilter() {
    if (_selectedCategory == null) {
      _filteredPlaces = List.from(_allPlaces);
    } else {
      _filteredPlaces = _allPlaces
          .where((place) => place.category == _selectedCategory)
          .toList();
    }
  }

  /// 필터 변경
  void _onFilterChanged(PlaceCategory? category) {
    setState(() {
      _selectedCategory = category;
      _applyFilter();
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: CommonAppBar.forSubPage(
        title: l10n.recentSavedPlaces,
      ),
      body: Column(
        children: [
          // 카테고리 필터 칩들
          _buildFilterChips(l10n),

          // 장소 그리드
          Expanded(child: _buildPlaceGrid(l10n)),
        ],
      ),
    );
  }

  /// 카테고리 필터 칩 빌드
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
              selected: _selectedCategory == null,
              onSelected: (_) => _onFilterChanged(null),
              selectedColor:
                  Theme.of(context).primaryColor.withValues(alpha: 0.2),
            ),
          ),
          // 카테고리 필터들
          ...PlaceCategory.values.map((category) {
            return Padding(
              padding: EdgeInsets.only(right: 8.w),
              child: FilterChip(
                label: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(category.emoji),
                    SizedBox(width: 4.w),
                    Text(category.displayName),
                  ],
                ),
                selected: _selectedCategory == category,
                onSelected: (_) => _onFilterChanged(category),
                selectedColor:
                    Theme.of(context).primaryColor.withValues(alpha: 0.2),
              ),
            );
          }),
        ],
      ),
    );
  }

  /// 장소 그리드 빌드
  Widget _buildPlaceGrid(AppLocalizations l10n) {
    if (_filteredPlaces.isEmpty && !_isLoading) {
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
          _allPlaces.clear();
        });
        _loadInitialData();
      },
      child: GridView.builder(
        controller: _scrollController,
        padding: EdgeInsets.all(16.w),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, // 2열 그리드
          crossAxisSpacing: 12.w,
          mainAxisSpacing: 12.w,
          childAspectRatio: 0.75, // 세로로 긴 비율
        ),
        itemCount: _filteredPlaces.length + (_isLoading ? 2 : 0),
        itemBuilder: (context, index) {
          // 로딩 인디케이터
          if (index >= _filteredPlaces.length) {
            return _buildLoadingCard();
          }

          // 장소 카드
          final place = _filteredPlaces[index];
          return PlaceGridCard(
            place: place,
            onTap: () {
              // 상세 화면으로 이동 (nested routing)
              context.go('/home/saved-places/${place.id}', extra: place);
            },
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
