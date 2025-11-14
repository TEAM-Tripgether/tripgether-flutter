import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'app_colors.dart';

/// Tripgether 앱의 텍스트 스타일 정의
///
/// **디자이너 스펙 기반 폰트 시스템**:
/// - 각 폰트 패밀리를 직접 지정 (Pretendard-Bold, Pretendard-Medium 등)
/// - 기능명과 폰트 정보를 함께 제공하여 사용처와 스타일을 동시에 파악
/// - ScreenUtil(.sp)을 사용하여 반응형 폰트 크기 지원
///
/// **사용 예시**:
/// ```dart
/// Text('환영합니다', style: AppTextStyles.onboardingTitle)  // Bold 24
/// Text('안녕하세요!', style: AppTextStyles.greetingBold20)  // Bold 20
/// ```
class AppTextStyles {
  AppTextStyles._();

  // ============================================================================
  // 제목 스타일 (Titles)
  // ============================================================================

  /// 큰 제목 (Bold, 24px)
  /// 사용처: 온보딩 화면, 중요 제목
  static TextStyle titleBold24 = TextStyle(
    fontFamily: 'Pretendard-Bold',
    fontSize: 24.sp,
    color: AppColors.textColor1,
  );

  /// 큰 인사말 (Bold, 20px)
  /// 사용처: "환영합니다!", 메인 인사 문구
  static TextStyle greetingBold20 = TextStyle(
    fontFamily: 'Pretendard-Bold',
    fontSize: 20.sp,
    color: AppColors.textColor1,
  );

  /// 중간 인사말 (SemiBold, 20px)
  /// 사용처: 서브 인사 문구, 부제목
  static TextStyle greetingSemiBold20 = TextStyle(
    fontFamily: 'Pretendard-SemiBold',
    fontSize: 20.sp,
    color: AppColors.textColor1,
  );

  /// 요약 한 줄 (Bold, 18px)
  /// 사용처: 카드 요약, 중요 정보 한 줄
  static TextStyle summaryBold18 = TextStyle(
    fontFamily: 'Pretendard-Bold',
    fontSize: 18.sp,
    color: AppColors.textColor1,
  );

  static TextStyle summaryBold16 = TextStyle(
    fontFamily: 'Pretendard-Bold',
    fontSize: 16.sp,
    color: AppColors.textColor1,
  );

  // ============================================================================
  // 섹션 제목 (Section Headers)
  // ============================================================================

  /// 중간 제목 (SemiBold, 16px)
  /// 사용처: 섹션 제목, "최근 SNS에서 본 콘텐츠", "저장된 장소" 등
  static TextStyle titleSemiBold16 = TextStyle(
    fontFamily: 'Pretendard-SemiBold',
    fontSize: 16.sp,
    color: AppColors.textColor1,
  );

  // ============================================================================
  // 콘텐츠 제목 (Content Titles)
  // ============================================================================

  /// 작은 제목 (SemiBold, 14px)
  /// 사용처: 콘텐츠 제목, 장소 이름, 게시물 작성자
  static TextStyle titleSemiBold14 = TextStyle(
    fontFamily: 'Pretendard-SemiBold',
    fontSize: 14.sp,
    color: AppColors.textColor1,
  );

  // ============================================================================
  // 본문 텍스트 (Body Text)
  // ============================================================================

  /// 설명 텍스트 (Regular, 14px)
  /// 사용처: 설명, 상세 내용, 일반 본문
  static TextStyle bodyRegular14 = TextStyle(
    fontFamily: 'Pretendard-Regular',
    fontSize: 14.sp,
    color: AppColors.textColor1,
  );

  /// 큰 본문 텍스트 (Medium, 16px)
  /// 사용처: 강조된 본문, 중요 설명
  static TextStyle bodyMedium16 = TextStyle(
    fontFamily: 'Pretendard-Medium',
    fontSize: 16.sp,
    color: AppColors.textColor1,
  );

  /// 작은 보조 텍스트 (Regular, 12px)
  /// 사용처: 캡션, 작은 보조 설명
  static TextStyle caption12 = TextStyle(
    fontFamily: 'Pretendard-Regular',
    fontSize: 12.sp,
    color: AppColors.textColor1,
  );

  // ============================================================================
  // 버튼 텍스트 (Button Text)
  // ============================================================================

  /// 선택 버튼 (SemiBold, 16px)
  /// 사용처: 선택지 버튼, 옵션 버튼
  static TextStyle buttonSelectSemiBold16 = TextStyle(
    fontFamily: 'Pretendard-SemiBold',
    fontSize: 16.sp,
    color: AppColors.textColor1,
  );

  /// 큰 버튼 (Medium, 16px)
  /// 사용처: "계속하기", 주요 액션 버튼
  static TextStyle buttonLargeMedium16 = TextStyle(
    fontFamily: 'Pretendard-Medium',
    fontSize: 16.sp,
    color: AppColors.textColor1,
  );

  /// 중간 버튼 (Medium, 14px)
  /// 사용처: "~를 확인하기", 보조 버튼
  static TextStyle buttonMediumMedium14 = TextStyle(
    fontFamily: 'Pretendard-Medium',
    fontSize: 14.sp,
    color: AppColors.textColor1,
  );

  /// 작은 버튼 (Bold, 10px)
  /// 사용처: "닫기", "저장하기", 작은 액션 버튼
  static TextStyle buttonSmallBold10 = TextStyle(
    fontFamily: 'Pretendard-Bold',
    fontSize: 10.sp,
    color: AppColors.textColor1,
  );

  // ============================================================================
  // 부가 정보 (Meta Information)
  // ============================================================================

  /// 메타 정보 (Medium, 12px)
  /// 사용처: 저장된 장소 주소, URL, 부가 정보
  static TextStyle metaMedium12 = TextStyle(
    fontFamily: 'Pretendard-Medium',
    fontSize: 12.sp,
    color: AppColors.textColor1,
  );

  // ============================================================================
  // 스플래시 화면 (Splash Screen)
  // ============================================================================

  /// 스플래시 대형 로고 텍스트 (Bold, 48px)
  /// 사용처: 스플래시 화면 "Trip", "Together", "Tripgether"
  static TextStyle splashLogoBold48 = TextStyle(
    fontFamily: 'Pretendard-Bold',
    fontSize: 48.sp,
    color: AppColors.white,
    letterSpacing: 2.0,
  );

  /// 스플래시 슬로건 (Regular, 12px)
  /// 사용처: 스플래시 화면 하단 슬로건
  static TextStyle splashSloganRegular12 = TextStyle(
    fontFamily: 'Pretendard-Regular',
    fontSize: 12.sp,
    color: AppColors.white,
    letterSpacing: 0.5,
  );

  // ============================================================================
  // 폰트 패밀리 상수 (Font Family Constants)
  // ============================================================================

  /// 직접 사용을 위한 폰트 패밀리 상수
  static const String thin = 'Pretendard-Thin';
  static const String extraLight = 'Pretendard-ExtraLight';
  static const String light = 'Pretendard-Light';
  static const String regular = 'Pretendard-Regular';
  static const String medium = 'Pretendard-Medium';
  static const String semiBold = 'Pretendard-SemiBold';
  static const String bold = 'Pretendard-Bold';
  static const String extraBold = 'Pretendard-ExtraBold';
  static const String black = 'Pretendard-Black';
}
