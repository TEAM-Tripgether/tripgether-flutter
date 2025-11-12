import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/router/routes.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../shared/widgets/common/common_app_bar.dart';
import '../../../../shared/widgets/cards/place_card.dart';
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

/// 필터 설정 데이터 클래스
class _FilterConfig {
  final PlaceCategory? category;
  final String label;
  final Color? selectedColor;

  const _FilterConfig({
    this.category,
    required this.label,
    this.selectedColor,
  });
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

  /// 필터 설정 목록 (확장 가능한 구조)
  /// PlaceCategory enum에 새 카테고리 추가 시 자동으로 필터에 반영됨
  List<_FilterConfig> get _filterConfigs {
    return [
      // 전체 보기 필터
      _FilterConfig(
        category: null,
        label: AppLocalizations.of(context).filterAll,
        selectedColor: Theme.of(context).primaryColor.withValues(alpha: 0.2),
      ),
      // 카테고리별 필터 (PlaceCategory enum 기반 자동 생성)
      ...PlaceCategory.values.map(
        (category) => _FilterConfig(
          category: category,
          label: category.displayName,
          selectedColor: Theme.of(context).primaryColor.withValues(alpha: 0.2),
        ),
      ),
    ];
  }

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

    // 비동기 작업 후 위젯이 dispose된 경우 setState 호출 방지
    if (!mounted) return;

    // 현재 장소 개수를 기반으로 고유한 ID를 가진 더미 데이터 생성
    final currentCount = _allPlaces.length;
    final morePlaces = List.generate(6, (index) {
      final dummyData = _getDummyData(currentCount + index);
      return SavedPlace.dummy(
        id: '${currentCount + index + 1}',
        name: dummyData['name'] as String,
        category: dummyData['category'] as PlaceCategory,
        address: dummyData['address'] as String,
      );
    });

    setState(() {
      _allPlaces.addAll(morePlaces);
      _applyFilter();
      _isLoading = false;
    });
  }

  /// 더미 데이터 템플릿 (확장 가능한 구조)
  /// 새로운 더미 장소 추가 시 여기에만 데이터를 추가하면 됨
  static const List<Map<String, dynamic>> _dummyTemplates = [
    {
      'name': '홍대 감성 카페',
      'category': PlaceCategory.cafe,
      'address': '서울 마포구 홍대입구',
    },
    {
      'name': '연남동 맛집',
      'category': PlaceCategory.restaurant,
      'address': '서울 마포구 연남동',
    },
    {
      'name': '강남 루프탑 바',
      'category': PlaceCategory.bar,
      'address': '서울 강남구 역삼동',
    },
    {
      'name': '이태원 브런치',
      'category': PlaceCategory.restaurant,
      'address': '서울 용산구 이태원동',
    },
    {
      'name': '북촌 한옥카페',
      'category': PlaceCategory.cafe,
      'address': '서울 종로구 북촌로',
    },
    {
      'name': '망원동 디저트',
      'category': PlaceCategory.cafe,
      'address': '서울 마포구 망원동',
    },
  ];

  /// 더미 데이터 가져오기 (통합 메서드)
  /// [index] 인덱스에 해당하는 더미 데이터 반환
  Map<String, dynamic> _getDummyData(int index) {
    return _dummyTemplates[index % _dummyTemplates.length];
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
      appBar: CommonAppBar.forSubPage(title: l10n.recentSavedPlaces),
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

  /// 카테고리 필터 칩 빌드 (데이터 기반 확장 가능 구조)
  Widget _buildFilterChips(AppLocalizations l10n) {
    return Container(
      height: 50.h,
      padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg),
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
    final isSelected = _selectedCategory == config.category;

    return Padding(
      padding: EdgeInsets.only(right: AppSpacing.sm),
      child: FilterChip(
        label: Text(config.label),
        selected: isSelected,
        onSelected: (_) => _onFilterChanged(config.category),
        selectedColor: config.selectedColor,
      ),
    );
  }

  /// 장소 그리드 빌드
  Widget _buildPlaceGrid(AppLocalizations l10n) {
    final colorScheme = Theme.of(context).colorScheme;

    if (_filteredPlaces.isEmpty && !_isLoading) {
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
          _allPlaces.clear();
        });
        _loadInitialData();
      },
      child: GridView.builder(
        controller: _scrollController,
        padding: EdgeInsets.all(AppSpacing.lg.w),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, // 2열 그리드
          crossAxisSpacing: AppSpacing.md,
          mainAxisSpacing: AppSpacing.md,
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
              context.go(
                AppRoutes.placeDetail.replaceFirst(':placeId', place.id),
                extra: place,
              );
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
        color: AppColors.neutral90,
        borderRadius: AppRadius.allLarge,
      ),
      child: Center(
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
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
