import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../core/constants/app_strings.dart';

/// 간단한 국제화 테스트 화면
///
/// 기본적인 국제화 기능이 올바르게 작동하는지 빠르게 확인하기 위한 화면입니다.
class SimpleI18nTestScreen extends StatelessWidget {
  const SimpleI18nTestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppStrings.of(context).appTitle),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 앱 제목 테스트
            Card(
              child: Padding(
                padding: EdgeInsets.all(16.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '📱 앱 정보',
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Pretendard',
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Text('제목: ${AppStrings.of(context).appTitle}'),
                    Text('설명: ${AppStrings.of(context).appDescription}'),
                  ],
                ),
              ),
            ),

            SizedBox(height: 16.h),

            // 네비게이션 라벨 테스트
            Card(
              child: Padding(
                padding: EdgeInsets.all(16.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '🧭 네비게이션',
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Pretendard',
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Text('홈: ${AppStrings.of(context).navHome}'),
                    Text('지도: ${AppStrings.of(context).navMap}'),
                    Text('일정: ${AppStrings.of(context).navSchedule}'),
                    Text('코스마켓: ${AppStrings.of(context).navCourseMarket}'),
                    Text('마이페이지: ${AppStrings.of(context).navMyPage}'),
                  ],
                ),
              ),
            ),

            SizedBox(height: 16.h),

            // 버튼 테스트
            Card(
              child: Padding(
                padding: EdgeInsets.all(16.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '🔘 버튼',
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Pretendard',
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          onPressed: () {},
                          child: Text(AppStrings.of(context).btnConfirm),
                        ),
                        ElevatedButton(
                          onPressed: () {},
                          child: Text(AppStrings.of(context).btnCancel),
                        ),
                        ElevatedButton(
                          onPressed: () {},
                          child: Text(AppStrings.of(context).btnSave),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: 16.h),

            // 언어 정보
            Card(
              child: Padding(
                padding: EdgeInsets.all(16.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '🌍 언어 정보',
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Pretendard',
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Text('언어코드: ${AppStrings.getCurrentLanguageCode(context)}'),
                    Text('한국어 여부: ${AppStrings.isKorean(context)}'),
                    Text('영어 여부: ${AppStrings.isEnglish(context)}'),
                    Text('날짜 포맷: ${AppStrings.getDateFormat(context)}'),
                    Text('시간 포맷: ${AppStrings.getTimeFormat(context)}'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}