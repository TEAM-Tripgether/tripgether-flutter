import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../shared/widgets/common/common_app_bar.dart';
import '../../../../core/constants/app_strings.dart';

/// 일정 관리 화면
///
/// 사용자의 여행 일정을 확인하고 관리할 수 있는 화면입니다.
/// 캘린더 뷰 전환과 새 일정 추가 기능을 AppBar에 배치했습니다.
class ScheduleScreen extends StatelessWidget {
  const ScheduleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 일정 관리에 최적화된 AppBar
      // 캘린더 뷰와 일정 추가 기능을 강조하여 구성
      appBar: CommonAppBar(
        title: AppStrings.of(context).navSchedule,
        showMenuButton: true, // 메뉴를 통한 다른 화면 접근 유지
        showNotificationIcon: true, // 일정 알림 확인을 위해 알림 아이콘 유지
        onMenuPressed: () {
          debugPrint('일정 화면 메뉴 버튼 클릭');
          // TODO: 사이드 메뉴 열기 또는 드로어 표시
        },
        onNotificationPressed: () {
          debugPrint('일정 화면 알림 버튼 클릭');
          // TODO: 일정 관련 알림 화면으로 이동
        },
        rightActions: [
          // 캘린더 뷰 전환 버튼
          Semantics(
            label: '캘린더 뷰 버튼',
            button: true,
            child: IconButton(
              icon: Icon(
                Icons.calendar_today_outlined,
                size: 24.w,
                color: Colors.grey[700],
              ),
              onPressed: () {
                debugPrint('캘린더 뷰 버튼 클릭');
                // TODO: 리스트 뷰 ↔ 캘린더 뷰 전환
              },
              tooltip: '캘린더',
            ),
          ),
          // 새 일정 추가 버튼
          Semantics(
            label: '일정 추가 버튼',
            button: true,
            child: IconButton(
              icon: Icon(
                Icons.add_circle_outline,
                size: 24.w,
                color: Colors.grey[700],
              ),
              onPressed: () {
                debugPrint('일정 추가 버튼 클릭');
                // TODO: 새 일정 추가 화면으로 이동 또는 모달 표시
              },
              tooltip: AppStrings.of(context).addSchedule,
            ),
          ),
          // 알림 아이콘은 showNotificationIcon으로 처리됨
          SizedBox(width: 8.w), // Material Design 가이드라인에 따른 오른쪽 마진
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.event_note_outlined,
              size: 64.w,
              color: Colors.grey[400],
            ),
            SizedBox(height: 16.h),
            Text(
              AppStrings.of(context).navSchedule,
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(color: Colors.grey[700]),
            ),
            SizedBox(height: 8.h),
            Text(
              '여행 일정 목록 및 캘린더 뷰 표시 예정',
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: Colors.grey[500]),
            ),
          ],
        ),
      ),
    );
  }
}
