import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../shared/widgets/inputs/search_bar.dart';
import '../../../../shared/widgets/cards/course_card.dart';
import '../../data/models/course_model.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../l10n/app_localizations.dart';

/// 코스 검색 화면
///
/// 코스를 검색하고 필터링하는 전용 화면
/// 검색어 입력, 최근 검색어, 추천 검색어, 검색 결과 표시
class CourseSearchScreen extends StatefulWidget {
  const CourseSearchScreen({super.key});

  @override
  State<CourseSearchScreen> createState() => _CourseSearchScreenState();
}

class _CourseSearchScreenState extends State<CourseSearchScreen> {
  /// 검색어 컨트롤러
  final TextEditingController _searchController = TextEditingController();

  /// 검색 결과 코스 리스트
  List<Course> _searchResults = [];

  /// 검색 중 여부
  bool _isSearching = false;

  /// 최근 검색어 목록 (실제로는 로컬 저장소에서 불러와야 함)
  final List<String> _recentSearches = ['데이트 코스', '빈티지', '카페 투어', '야경'];

  /// 추천 검색어 목록
  final List<String> _recommendedSearches = [
    '데이트',
    '산책',
    '빈티지',
    '맛집',
    '카페',
    '야경',
    '문화',
    '자연',
  ];

  /// 좋아요한 코스 ID 목록 (임시 상태)
  final Set<String> _likedCourseIds = {};

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  /// 검색 실행
  void _performSearch(String query) {
    if (query.trim().isEmpty) {
      setState(() {
        _searchResults = [];
        _isSearching = false;
      });
      return;
    }

    setState(() {
      _isSearching = true;
    });

    // 실제로는 API 호출 또는 로컬 데이터 필터링
    // 여기서는 더미 데이터에서 필터링
    final allCourses = [
      ...CourseDummyData.getPopularCourses(),
      ...CourseDummyData.getNearbyCoursesById(placeId: 'search'),
    ];

    final results = allCourses.where((course) {
      final searchLower = query.toLowerCase();
      return course.title.toLowerCase().contains(searchLower) ||
          course.description.toLowerCase().contains(searchLower) ||
          course.category.displayName.toLowerCase().contains(searchLower) ||
          course.location.toLowerCase().contains(searchLower);
    }).toList();

    // 검색 지연 시뮬레이션 (실제 API 호출 시간 반영)
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) {
        setState(() {
          _searchResults = results;
          _isSearching = false;
        });
      }
    });
  }

  /// 최근 검색어 삭제
  void _removeRecentSearch(String query) {
    setState(() {
      _recentSearches.remove(query);
    });
    // 실제로는 로컬 저장소에서도 삭제해야 함
  }

  /// 검색어 클릭 (최근 검색어 또는 추천 검색어)
  void _onSearchQueryTap(String query) {
    _searchController.text = query;
    _performSearch(query);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: _buildAppBar(),
      body: _buildBody(),
    );
  }

  /// AppBar 빌드
  PreferredSizeWidget _buildAppBar() {
    final l10n = AppLocalizations.of(context);

    return AppBar(
      backgroundColor: AppColors.background,
      elevation: 0,
      leadingWidth: 48.w, // search bar 높이와 동일
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back_ios_new, // 더 얇은 아이콘으로 변경
          size: 24.w, // search bar 높이(48.h)의 절반보다 약간 작게
          color: AppColors.onSurface,
        ),
        onPressed: () => Navigator.pop(context),
        padding: EdgeInsets.zero, // 패딩 제거
        splashRadius: 24.w, // 터치 영역
      ),
      titleSpacing: 0, // 타이틀과 leading 사이 간격 제거
      title: Hero(
        tag: 'course_search_bar', // market_screen과 동일한 태그로 Hero 애니메이션 연결
        child: TripSearchBar(
          controller: _searchController,
          hintText: l10n.searchPlaceholder,
          readOnly: false, // 직접 입력 가능
          autofocus: true, // 자동 포커스
          onChanged: (text) {
            // 실시간 검색 (타이핑할 때마다)
            _performSearch(text);
          },
          onSubmitted: (text) {
            // 엔터 키 누르면 검색
            _performSearch(text);
          },
        ),
      ),
    );
  }

  /// Body 빌드
  Widget _buildBody() {
    // 검색어가 없으면 최근 검색어와 추천 검색어 표시
    if (_searchController.text.isEmpty) {
      return _buildSearchSuggestions();
    }

    // 검색 중이면 로딩 표시
    if (_isSearching) {
      return Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
        ),
      );
    }

    // 검색 결과가 없으면 안내 메시지
    if (_searchResults.isEmpty) {
      return _buildEmptyResults();
    }

    // 검색 결과 표시
    return _buildSearchResults();
  }

  /// 검색 제안 (최근 검색어 + 추천 검색어)
  Widget _buildSearchSuggestions() {
    final l10n = AppLocalizations.of(context);

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 24.h),

          // 최근 검색어
          if (_recentSearches.isNotEmpty) ...[
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    l10n.recentSearches,
                    style: TextStyle(
                      fontFamily: 'Pretendard',
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColors.onSurface,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        _recentSearches.clear();
                      });
                    },
                    child: Text(
                      l10n.clearAllSearches,
                      style: TextStyle(
                        fontFamily: 'Pretendard',
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w500,
                        color: AppColors.neutral60,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 12.h),
            ..._recentSearches.map((query) => _buildRecentSearchItem(query)),
            SizedBox(height: 24.h),
          ],

          // 추천 검색어
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Text(
              l10n.recommendedSearches,
              style: TextStyle(
                fontFamily: 'Pretendard',
                fontSize: 16.sp,
                fontWeight: FontWeight.w700,
                color: AppColors.onSurface,
              ),
            ),
          ),
          SizedBox(height: 12.h),
          _buildRecommendedSearches(),
          SizedBox(height: 24.h),
        ],
      ),
    );
  }

  /// 최근 검색어 아이템
  Widget _buildRecentSearchItem(String query) {
    return ListTile(
      leading: Icon(Icons.history, size: 20.w, color: AppColors.neutral60),
      title: Text(
        query,
        style: TextStyle(
          fontFamily: 'Pretendard',
          fontSize: 14.sp,
          fontWeight: FontWeight.w500,
          color: AppColors.onSurface,
        ),
      ),
      trailing: IconButton(
        icon: Icon(Icons.close, size: 20.w, color: AppColors.neutral60),
        onPressed: () => _removeRecentSearch(query),
      ),
      onTap: () => _onSearchQueryTap(query),
    );
  }

  /// 추천 검색어 칩 리스트
  Widget _buildRecommendedSearches() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Wrap(
        spacing: 8.w,
        runSpacing: 8.h,
        children: _recommendedSearches.map((query) {
          return GestureDetector(
            onTap: () => _onSearchQueryTap(query),
            child: Chip(
              label: Text(
                query,
                style: TextStyle(
                  fontFamily: 'Pretendard',
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w500,
                  color: AppColors.onSurface,
                ),
              ),
              backgroundColor: AppColors.neutral95,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.r),
                side: BorderSide(color: AppColors.neutral90, width: 1),
              ),
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
            ),
          );
        }).toList(),
      ),
    );
  }

  /// 검색 결과 없음
  Widget _buildEmptyResults() {
    final l10n = AppLocalizations.of(context);

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off, size: 64.w, color: AppColors.neutral70),
          SizedBox(height: 16.h),
          Text(
            l10n.noSearchResults,
            style: TextStyle(
              fontFamily: 'Pretendard',
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.neutral50,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            l10n.tryDifferentKeyword,
            style: TextStyle(
              fontFamily: 'Pretendard',
              fontSize: 14.sp,
              fontWeight: FontWeight.w400,
              color: AppColors.neutral60,
            ),
          ),
        ],
      ),
    );
  }

  /// 검색 결과 표시
  Widget _buildSearchResults() {
    final l10n = AppLocalizations.of(context);

    return CustomScrollView(
      slivers: [
        // 검색 결과 헤더
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.all(16.w),
            child: Text(
              l10n.searchResults(_searchResults.length),
              style: TextStyle(
                fontFamily: 'Pretendard',
                fontSize: 16.sp,
                fontWeight: FontWeight.w700,
                color: AppColors.onSurface,
              ),
            ),
          ),
        ),

        // 검색 결과 리스트
        SliverList(
          delegate: SliverChildBuilderDelegate((context, index) {
            final course = _searchResults[index];
            return Padding(
              padding: EdgeInsets.only(left: 16.w, right: 16.w, bottom: 16.h),
              child: CourseCard(
                course: course,
                width: double.infinity, // 전체 너비 사용
                onTap: () {
                  debugPrint('코스 상세: ${course.title}');
                  // 코스 상세 화면으로 이동
                },
                onLikeTap: () {
                  setState(() {
                    if (_likedCourseIds.contains(course.id)) {
                      _likedCourseIds.remove(course.id);
                    } else {
                      _likedCourseIds.add(course.id);
                    }
                  });
                },
                isLiked: _likedCourseIds.contains(course.id),
              ),
            );
          }, childCount: _searchResults.length),
        ),

        // 하단 여백
        SliverToBoxAdapter(child: SizedBox(height: 24.h)),
      ],
    );
  }
}
