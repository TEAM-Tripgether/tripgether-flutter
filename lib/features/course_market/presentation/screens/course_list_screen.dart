import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// 코스 마켓 화면 - PRD.md 구조에 따른 features/course_market/presentation/screens 위치
///
/// 여행 코스 리스트와 필터링 기능을 제공하는 마켓플레이스 메인 화면
class CourseListScreen extends StatefulWidget {
  const CourseListScreen({super.key});

  @override
  CourseListScreenState createState() => CourseListScreenState();
}

class CourseListScreenState extends State<CourseListScreen> {
  String _selectedFilter = '전체';
  final List<String> _filters = ['전체', '인기', '최신', '저가', '고급'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '코스마켓',
          style: TextStyle(
            fontFamily: 'Pretendard',
            fontSize: 20.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              // TODO: 검색 기능 구현
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // 필터 바
          _buildFilterBar(),

          // 코스 리스트
          Expanded(
            child: _buildCourseList(),
          ),
        ],
      ),
    );
  }

  /// 필터 바 구성
  Widget _buildFilterBar() {
    return Container(
      height: 50.h,
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _filters.length,
        itemBuilder: (context, index) {
          final filter = _filters[index];
          final isSelected = _selectedFilter == filter;

          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedFilter = filter;
              });
            },
            child: Container(
              margin: EdgeInsets.only(right: 8.w, top: 8.h, bottom: 8.h),
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
              decoration: BoxDecoration(
                color: isSelected ? Theme.of(context).primaryColor : Colors.grey[100],
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: Center(
                child: Text(
                  filter,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Pretendard',
                    color: isSelected ? Colors.white : Colors.grey[700],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  /// 코스 리스트 구성
  Widget _buildCourseList() {
    return ListView.builder(
      padding: EdgeInsets.all(16.w),
      itemCount: 10, // 임시 개수
      itemBuilder: (context, index) {
        return _buildCourseCard(index);
      },
    );
  }

  /// 개별 코스 카드
  Widget _buildCourseCard(int index) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 코스 이미지
          Container(
            height: 160.h,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12.r),
                topRight: Radius.circular(12.r),
              ),
            ),
            child: Center(
              child: Text(
                '코스 이미지 ${index + 1}',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontFamily: 'Pretendard',
                ),
              ),
            ),
          ),

          // 코스 정보
          Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '서울 핫플 투어 코스 ${index + 1}',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Pretendard',
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  '서울의 인기 장소들을 하루만에 둘러보는 완벽한 코스입니다.',
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: Colors.grey[600],
                    fontFamily: 'Pretendard',
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 8.h),
                Row(
                  children: [
                    Icon(Icons.star, color: Colors.amber, size: 16.w),
                    SizedBox(width: 4.w),
                    Text(
                      '4.${8 - (index % 3)}',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'Pretendard',
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Text(
                      '(${120 + index * 10}개 리뷰)',
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: Colors.grey[600],
                        fontFamily: 'Pretendard',
                      ),
                    ),
                    const Spacer(),
                    Text(
                      '${15000 + index * 5000}원',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w700,
                        fontFamily: 'Pretendard',
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}