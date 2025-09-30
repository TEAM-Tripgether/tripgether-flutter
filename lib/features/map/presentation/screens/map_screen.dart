import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// 지도 화면 - PRD.md 구조에 따른 features/map/presentation/screens 위치
///
/// 저장된 장소들을 지도에서 시각화하여 표시하는 지도 기반 메인 화면
class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  MapScreenState createState() => MapScreenState();
}

class MapScreenState extends State<MapScreen> {
  bool _showListView = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '지도',
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
            icon: Icon(_showListView ? Icons.map : Icons.list),
            onPressed: () {
              setState(() {
                _showListView = !_showListView;
              });
            },
          ),
          IconButton(
            icon: Icon(Icons.my_location),
            onPressed: () {
              // TODO: 현재 위치로 이동 기능
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('현재 위치로 이동')),
              );
            },
          ),
        ],
      ),
      body: _showListView ? _buildListView() : _buildMapView(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: 장소 추가 기능
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('장소 추가 기능')),
          );
        },
        child: Icon(Icons.add_location),
      ),
    );
  }

  /// 지도 뷰 구성
  Widget _buildMapView() {
    return Stack(
      children: [
        // 지도 영역 (실제 구현 시 Google Maps 또는 Kakao Map 사용)
        Container(
          width: double.infinity,
          height: double.infinity,
          color: Colors.grey[300],
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.map, size: 64.w, color: Colors.grey[600]),
                SizedBox(height: 16.h),
                Text(
                  '지도 컴포넌트 영역',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontFamily: 'Pretendard',
                    color: Colors.grey[600],
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  'Google Maps 또는 Kakao Map 연동 예정',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontFamily: 'Pretendard',
                    color: Colors.grey[500],
                  ),
                ),
              ],
            ),
          ),
        ),

        // 검색 바
        Positioned(
          top: 16.h,
          left: 16.w,
          right: 16.w,
          child: _buildSearchBar(),
        ),

        // 저장된 장소 마커들 (샘플)
        ..._buildSampleMarkers(),
      ],
    );
  }

  /// 리스트 뷰 구성
  Widget _buildListView() {
    return Column(
      children: [
        // 검색 바
        Padding(
          padding: EdgeInsets.all(16.w),
          child: _buildSearchBar(),
        ),

        // 장소 리스트
        Expanded(
          child: ListView.builder(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            itemCount: 8, // 임시 개수
            itemBuilder: (context, index) {
              return _buildPlaceListItem(index);
            },
          ),
        ),
      ],
    );
  }

  /// 검색 바 위젯
  Widget _buildSearchBar() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25.r),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.2),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(Icons.search, color: Colors.grey[600], size: 20.w),
          SizedBox(width: 12.w),
          Expanded(
            child: Text(
              '장소나 주소를 검색하세요',
              style: TextStyle(
                fontSize: 14.sp,
                fontFamily: 'Pretendard',
                color: Colors.grey[600],
              ),
            ),
          ),
          Icon(Icons.filter_list, color: Colors.grey[600], size: 20.w),
        ],
      ),
    );
  }

  /// 샘플 마커들 생성
  List<Widget> _buildSampleMarkers() {
    return List.generate(5, (index) {
      return Positioned(
        top: 150.h + (index * 80.h),
        left: 100.w + (index * 60.w),
        child: GestureDetector(
          onTap: () {
            _showPlaceInfo(index);
          },
          child: Container(
            width: 40.w,
            height: 40.h,
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.2),
                  spreadRadius: 1,
                  blurRadius: 3,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Center(
              child: Text(
                '${index + 1}',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Pretendard',
                ),
              ),
            ),
          ),
        ),
      );
    });
  }

  /// 장소 리스트 아이템
  Widget _buildPlaceListItem(int index) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        children: [
          // 장소 이미지
          Container(
            width: 60.w,
            height: 60.h,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Icon(Icons.place, color: Colors.grey[600]),
          ),

          SizedBox(width: 12.w),

          // 장소 정보
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '저장된 장소 ${index + 1}',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Pretendard',
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  '서울시 강남구 테헤란로 ${index + 100}',
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: Colors.grey[600],
                    fontFamily: 'Pretendard',
                  ),
                ),
                SizedBox(height: 4.h),
                Row(
                  children: [
                    Icon(Icons.star, color: Colors.amber, size: 14.w),
                    SizedBox(width: 4.w),
                    Text(
                      '4.${8 - (index % 3)}',
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'Pretendard',
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Text(
                      '${(index + 1) * 0.5}km',
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: Colors.grey[600],
                        fontFamily: 'Pretendard',
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // 액션 버튼
          Column(
            children: [
              IconButton(
                onPressed: () {
                  // TODO: 경로 안내 기능
                },
                icon: Icon(Icons.directions, color: Theme.of(context).primaryColor),
              ),
              IconButton(
                onPressed: () {
                  // TODO: 즐겨찾기 토글
                },
                icon: Icon(Icons.favorite_border, color: Colors.grey[600]),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// 장소 정보 표시 (마커 탭 시)
  void _showPlaceInfo(int index) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          padding: EdgeInsets.all(20.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20.r),
              topRight: Radius.circular(20.r),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      '장소 ${index + 1}',
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Pretendard',
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(Icons.close),
                  ),
                ],
              ),
              SizedBox(height: 8.h),
              Text(
                '서울시 강남구 테헤란로 ${index + 100}',
                style: TextStyle(
                  fontSize: 14.sp,
                  color: Colors.grey[600],
                  fontFamily: 'Pretendard',
                ),
              ),
              SizedBox(height: 16.h),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        // TODO: 경로 안내
                      },
                      child: Text('길찾기'),
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        // TODO: 일정에 추가
                      },
                      child: Text('일정 추가'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}