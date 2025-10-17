import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../l10n/app_localizations.dart';
import '../inputs/search_bar.dart';

/// 홈 화면 상단 인사말 섹션 위젯
///
/// 사용자 닉네임과 함께 인사말을 표시하고
/// 현재 시간대에 맞는 인사말을 자동으로 선택
class GreetingSection extends StatelessWidget {
  /// 사용자 닉네임
  final String nickname;

  /// 부제목 텍스트
  final String? subtitle;

  const GreetingSection({super.key, required this.nickname, this.subtitle});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 인사말
          Text(
            _getGreetingText(),
            style: textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w700,
              color: colorScheme.onSurface,
              height: 1.3,
            ),
          ),
          SizedBox(height: AppSpacing.xs.h),

          // 부제목
          Text(
            subtitle ?? _getSubtitleText(),
            style: textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w400,
              color: colorScheme.onSurfaceVariant,
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

    return '$greeting, $nickname님!';
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

/// 홈 화면 헤더 위젯 (인사말 + 검색창)
///
/// 인사말, 부제목, 검색창을 포함하는 통합 헤더
class HomeHeader extends StatelessWidget {
  /// 사용자 닉네임
  final String nickname;

  /// 인사말 텍스트 (국제화된)
  final String? greeting;

  /// 인사말 부제목 (국제화된)
  final String? greetingSubtitle;

  /// 검색창 힌트 텍스트 (국제화된)
  final String? searchHint;

  /// 검색창 탭 시 콜백
  final VoidCallback? onSearchTap;

  const HomeHeader({
    super.key,
    required this.nickname,
    this.greeting,
    this.greetingSubtitle,
    this.searchHint,
    this.onSearchTap,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final textTheme = Theme.of(context).textTheme;

    return Container(
      // 전체 너비 명시적으로 지정
      width: double.infinity,
      // 그라데이션 배경 추가 (#664BAE → #8975C1B2 70% → #FFFFFF)
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: AppColorPalette.homeHeaderGradient,
          stops: const [0.0, 0.7, 1.0], // 70% 지점에서 중간 색상
        ),
      ),
      padding: EdgeInsets.only(
        left: AppSpacing.lg,
        right: AppSpacing.lg,
        top: AppSpacing.xxl.h,
        bottom: AppSpacing.lg.h, // 검색창을 위한 하단 패딩 추가
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 인사말 (국제화 적용)
          Text(
            greeting ?? l10n.greeting(nickname),
            style: textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w700,
              color: Colors.white, // 그라데이션 배경에 맞춰 흰색으로 변경
            ),
          ),

          AppSpacing.verticalSpaceXS,
          // 부제목 (국제화 적용)
          Text(
            greetingSubtitle ?? l10n.greetingSubtitle,
            style: textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.w400,
              color: Colors.white.withValues(alpha: 0.9), // 약간 투명한 흰색
            ),
          ),

          AppSpacing.verticalSpaceLG,

          // 검색창 (그라데이션 배경 위에 표시)
          TripSearchBar(
            hintText: searchHint ?? l10n.searchHint,
            readOnly: false, // 직접 입력 가능하도록 변경
            onTap: onSearchTap,
            onChanged: (text) {
              // 텍스트 변경 시 (X 아이콘 표시 업데이트)
              debugPrint('검색어 입력: $text');
            },
            onSubmitted: (text) {
              // 검색 실행 (엔터 키 또는 검색 버튼 클릭)
              debugPrint('검색 실행: $text');
              // TODO: 검색 결과 화면으로 이동
            },
          ),
        ],
      ),
    );
  }
}
