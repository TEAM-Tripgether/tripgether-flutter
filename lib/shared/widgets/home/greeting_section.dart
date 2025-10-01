import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// 홈 화면 상단 인사말 섹션 위젯
///
/// 사용자 이름과 함께 인사말을 표시하고
/// 현재 시간대에 맞는 인사말을 자동으로 선택
class GreetingSection extends StatelessWidget {
  /// 사용자 이름
  final String userName;

  /// 부제목 텍스트
  final String? subtitle;

  const GreetingSection({
    super.key,
    required this.userName,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 인사말
          Text(
            _getGreetingText(),
            style: TextStyle(
              fontFamily: 'Pretendard',
              fontSize: 24.sp,
              fontWeight: FontWeight.w700,
              color: Colors.black87,
              height: 1.3,
            ),
          ),
          SizedBox(height: 4.h),

          // 부제목
          Text(
            subtitle ?? _getSubtitleText(),
            style: TextStyle(
              fontFamily: 'Pretendard',
              fontSize: 14.sp,
              fontWeight: FontWeight.w400,
              color: Colors.grey[600],
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  /// 시간대에 따른 인사말 생성
  String _getGreetingText() {
    final hour = DateTime.now().hour;
    String greeting;

    if (hour < 6) {
      greeting = '새벽이네요';
    } else if (hour < 12) {
      greeting = '안녕하세요';
    } else if (hour < 18) {
      greeting = '안녕하세요';
    } else {
      greeting = '안녕하세요';
    }

    return '$greeting, $userName님!';
  }

  /// 기본 부제목 텍스트 생성
  String _getSubtitleText() {
    final hour = DateTime.now().hour;

    if (hour < 6) {
      return '일찍 일어나셨네요! 오늘도 좋은 여행 되세요.';
    } else if (hour < 12) {
      return '오늘은 어디로 떠날까요?';
    } else if (hour < 18) {
      return '현지의 하루, 어디로 떠날까요?';
    } else {
      return '오늘의 하루는 어떠셨나요?';
    }
  }
}

/// 홈 화면 헤더 위젯 (인사말 전용)
///
/// 인사말과 부제목을 표시하는 헤더
class HomeHeader extends StatelessWidget {
  /// 사용자 이름
  final String userName;

  /// 인사말 텍스트 (국제화된)
  final String? greeting;

  /// 인사말 부제목 (국제화된)
  final String? greetingSubtitle;

  const HomeHeader({
    super.key,
    required this.userName,
    this.greeting,
    this.greetingSubtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 인사말
          Text(
            greeting ?? _getGreetingText(),
            style: TextStyle(
              fontFamily: 'Pretendard',
              fontSize: 22.sp,
              fontWeight: FontWeight.w700,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 2.h),
          // 부제목
          Text(
            greetingSubtitle ?? _getSubtitleText(),
            style: TextStyle(
              fontFamily: 'Pretendard',
              fontSize: 13.sp,
              fontWeight: FontWeight.w400,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  /// 시간대에 따른 인사말 생성
  String _getGreetingText() {
    return '안녕하세요, $userName님!';
  }

  /// 기본 부제목 텍스트 생성
  String _getSubtitleText() {
    return '현지의 하루, 어디로 떠날까요?';
  }
}