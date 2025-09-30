import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// 스케줄 화면 - PRD.md 구조에 따른 features/schedule/presentation/screens 위치
///
/// 여행 일정 관리 및 달력 기반 스케줄링을 제공하는 메인 화면
class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({super.key});

  @override
  ScheduleScreenState createState() => ScheduleScreenState();
}

class ScheduleScreenState extends State<ScheduleScreen> {
  bool _showCalendarView = true;
  DateTime _selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '스케줄',
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
            icon: Icon(_showCalendarView ? Icons.list : Icons.calendar_month),
            onPressed: () {
              setState(() {
                _showCalendarView = !_showCalendarView;
              });
            },
          ),
        ],
      ),
      body: _showCalendarView ? _buildCalendarView() : _buildListView(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddScheduleDialog();
        },
        child: Icon(Icons.add),
      ),
    );
  }

  /// 달력 뷰 구성
  Widget _buildCalendarView() {
    return Column(
      children: [
        // 월별 네비게이션
        _buildMonthNavigation(),

        // 달력 그리드
        _buildCalendarGrid(),

        // 선택된 날짜의 일정 리스트
        Expanded(
          child: _buildSelectedDateSchedules(),
        ),
      ],
    );
  }

  /// 리스트 뷰 구성
  Widget _buildListView() {
    return ListView(
      padding: EdgeInsets.all(16.w),
      children: [
        // 이번 주 일정
        _buildScheduleSection('이번 주 일정', _getThisWeekSchedules()),
        SizedBox(height: 24.h),

        // 다음 주 일정
        _buildScheduleSection('다음 주 일정', _getNextWeekSchedules()),
        SizedBox(height: 24.h),

        // 예정된 여행
        _buildScheduleSection('예정된 여행', _getUpcomingTrips()),
      ],
    );
  }

  /// 월별 네비게이션
  Widget _buildMonthNavigation() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: () {
              setState(() {
                _selectedDate = DateTime(_selectedDate.year, _selectedDate.month - 1);
              });
            },
            icon: Icon(Icons.chevron_left),
          ),
          Text(
            '${_selectedDate.year}년 ${_selectedDate.month}월',
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
              fontFamily: 'Pretendard',
            ),
          ),
          IconButton(
            onPressed: () {
              setState(() {
                _selectedDate = DateTime(_selectedDate.year, _selectedDate.month + 1);
              });
            },
            icon: Icon(Icons.chevron_right),
          ),
        ],
      ),
    );
  }

  /// 달력 그리드
  Widget _buildCalendarGrid() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        children: [
          // 요일 헤더
          Row(
            children: ['일', '월', '화', '수', '목', '금', '토'].map((day) {
              return Expanded(
                child: Center(
                  child: Text(
                    day,
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'Pretendard',
                      color: Colors.grey[600],
                    ),
                  ),
                ),
              );
            }).toList(),
          ),

          SizedBox(height: 8.h),

          // 날짜 그리드 (간단한 구현)
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              childAspectRatio: 1,
            ),
            itemCount: 35, // 5주 표시
            itemBuilder: (context, index) {
              final day = index - 6; // 임시 계산
              final hasSchedule = day > 0 && day % 7 == 2; // 임시 일정 표시

              return GestureDetector(
                onTap: day > 0 ? () {
                  setState(() {
                    _selectedDate = DateTime(_selectedDate.year, _selectedDate.month, day);
                  });
                } : null,
                child: Container(
                  margin: EdgeInsets.all(2.w),
                  decoration: BoxDecoration(
                    color: day == DateTime.now().day ? Theme.of(context).primaryColor.withValues(alpha: 0.2) : null,
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Stack(
                    children: [
                      Center(
                        child: Text(
                          day > 0 ? day.toString() : '',
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500,
                            fontFamily: 'Pretendard',
                            color: day > 0 ? Colors.black : Colors.transparent,
                          ),
                        ),
                      ),
                      if (hasSchedule)
                        Positioned(
                          bottom: 4.h,
                          right: 4.w,
                          child: Container(
                            width: 6.w,
                            height: 6.h,
                            decoration: BoxDecoration(
                              color: Theme.of(context).primaryColor,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  /// 선택된 날짜의 일정 리스트
  Widget _buildSelectedDateSchedules() {
    return Container(
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${_selectedDate.month}월 ${_selectedDate.day}일 일정',
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              fontFamily: 'Pretendard',
            ),
          ),
          SizedBox(height: 12.h),
          Expanded(
            child: _selectedDate.day % 7 == 2 // 임시 일정이 있는 날
                ? ListView.builder(
                    itemCount: 3,
                    itemBuilder: (context, index) {
                      return _buildScheduleItem(
                        '일정 ${index + 1}',
                        '${9 + index}:00',
                        '일정 설명이 들어갑니다.',
                        Theme.of(context).primaryColor,
                      );
                    },
                  )
                : Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.event_busy, size: 48.w, color: Colors.grey[400]),
                        SizedBox(height: 8.h),
                        Text(
                          '오늘 일정 없음',
                          style: TextStyle(
                            fontSize: 16.sp,
                            color: Colors.grey[600],
                            fontFamily: 'Pretendard',
                          ),
                        ),
                      ],
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  /// 일정 섹션 구성
  Widget _buildScheduleSection(String title, List<Map<String, dynamic>> schedules) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
            fontFamily: 'Pretendard',
          ),
        ),
        SizedBox(height: 12.h),
        ...schedules.map((schedule) => _buildScheduleItem(
          schedule['title'],
          schedule['time'],
          schedule['description'],
          schedule['color'],
        )),
      ],
    );
  }

  /// 개별 일정 아이템
  Widget _buildScheduleItem(String title, String time, String description, Color color) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.grey[200]!),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.05),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        children: [
          // 색상 인디케이터
          Container(
            width: 4.w,
            height: 40.h,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(2.r),
            ),
          ),
          SizedBox(width: 12.w),

          // 일정 정보
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Pretendard',
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  time,
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: color,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Pretendard',
                  ),
                ),
                if (description.isNotEmpty) ...[
                  SizedBox(height: 4.h),
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: Colors.grey[600],
                      fontFamily: 'Pretendard',
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ],
            ),
          ),

          // 더보기 버튼
          IconButton(
            onPressed: () {
              // TODO: 일정 상세 화면으로 이동
            },
            icon: Icon(Icons.more_vert, color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }

  /// 일정 추가 다이얼로그
  void _showAddScheduleDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            '새 일정 추가',
            style: TextStyle(fontFamily: 'Pretendard'),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: InputDecoration(
                  labelText: '일정 제목',
                  labelStyle: TextStyle(fontFamily: 'Pretendard'),
                ),
              ),
              SizedBox(height: 16.h),
              TextField(
                decoration: InputDecoration(
                  labelText: '시간',
                  labelStyle: TextStyle(fontFamily: 'Pretendard'),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('취소'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('일정이 추가되었습니다')),
                );
              },
              child: Text('추가'),
            ),
          ],
        );
      },
    );
  }

  /// 임시 데이터 생성 메서드들
  List<Map<String, dynamic>> _getThisWeekSchedules() {
    return [
      {
        'title': '서울 여행 계획',
        'time': '10:00',
        'description': '명동 쇼핑 및 남산타워 방문',
        'color': Colors.blue,
      },
      {
        'title': '부산 출발 준비',
        'time': '14:00',
        'description': '짐 정리 및 교통편 확인',
        'color': Colors.green,
      },
    ];
  }

  List<Map<String, dynamic>> _getNextWeekSchedules() {
    return [
      {
        'title': '제주도 여행',
        'time': '09:00',
        'description': '3박 4일 일정',
        'color': Colors.orange,
      },
    ];
  }

  List<Map<String, dynamic>> _getUpcomingTrips() {
    return [
      {
        'title': '일본 도쿄 여행',
        'time': '2024년 4월',
        'description': '벚꽃 시즌 여행',
        'color': Colors.pink,
      },
    ];
  }
}