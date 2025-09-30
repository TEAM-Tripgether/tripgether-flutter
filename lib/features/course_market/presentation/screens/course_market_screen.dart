import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../shared/widgets/common/common_app_bar.dart';
import '../../../../core/constants/app_strings.dart';

/// 코스마켓 화면
///
/// 여행 코스를 탐색하고 구매할 수 있는 마켓플레이스 화면입니다.
/// 검색과 필터링 기능이 주요 기능으로 AppBar에 검색 및 필터 버튼을 배치했습니다.
class CourseMarketScreen extends StatelessWidget {
  const CourseMarketScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 코스마켓에 최적화된 AppBar
      // 검색과 필터링 기능을 강조하여 구성
      appBar: CommonAppBar(
        title: AppStrings.of(context).navCourseMarket,
        showMenuButton: true, // 카테고리 메뉴 접근을 위한 햄버거 메뉴 유지
        showNotificationIcon: false, // 알림 대신 검색/필터 기능 우선
        onMenuPressed: () {
          debugPrint("임시 디버그 메시지");
          // TODO: 코스 카테고리 메뉴 표시 또는 드로어 열기
        },
        rightActions: [
          // 검색 버튼 - 코스마켓의 핵심 기능
          Semantics(
            label: "임시 시맨틱 라벨",
            button: true,
            child: IconButton(
              icon: Icon(Icons.search, size: 24.w, color: Colors.grey[700]),
              onPressed: () {
                debugPrint("임시 디버그 메시지");
                // TODO: 검색 화면으로 이동 또는 검색 모달 표시
              },
              tooltip: '검색',
            ),
          ),
          // 필터 버튼 - 코스 필터링 기능
          Semantics(
            label: "임시 시맨틱 라벨",
            button: true,
            child: IconButton(
              icon: Icon(
                Icons.filter_list_outlined,
                size: 24.w,
                color: Colors.grey[700],
              ),
              onPressed: () {
                debugPrint("임시 디버그 메시지");
                // TODO: 필터 옵션 모달 표시 (가격, 지역, 카테고리 등)
              },
              tooltip: '필터',
            ),
          ),
          SizedBox(width: 8.w), // Material Design 가이드라인에 따른 오른쪽 마진
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.store_outlined, size: 64.w, color: Colors.grey[400]),
            SizedBox(height: 16.h),
            Text(
              AppStrings.of(context).navCourseMarket,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: Colors.grey[700],
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              "임시 플레이스홀더 텍스트",
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.grey[500],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
