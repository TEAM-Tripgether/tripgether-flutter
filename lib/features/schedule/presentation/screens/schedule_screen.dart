import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../shared/widgets/common/common_app_bar.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../auth/providers/user_provider.dart';

/// 일정 관리 화면
///
/// 사용자의 여행 일정을 확인하고 관리할 수 있는 화면입니다.
/// 캘린더 뷰 전환과 새 일정 추가 기능을 AppBar에 배치했습니다.
class ScheduleScreen extends ConsumerWidget {
  const ScheduleScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Provider 초기화를 위한 참조
    // RouteGuard가 인증 상태를 확인할 때 Provider가 이미 초기화되어 있어야 함
    ref.watch(userNotifierProvider);

    // 다국어 지원을 위한 AppLocalizations 인스턴스
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      // 일정 관리에 최적화된 AppBar
      // 캘린더 뷰와 일정 추가 기능을 강조하여 구성
      appBar: CommonAppBar(
        title: l10n.navSchedule,
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
              tooltip: l10n.addSchedule,
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
            AppSpacing.verticalSpaceLG,
            Text(
              l10n.navSchedule,
              style: AppTextStyles.headlineSmall.copyWith(
                color: Colors.grey[700],
              ),
            ),
            AppSpacing.verticalSpaceSM,
            Text(
              '여행 일정 목록 및 캘린더 뷰 표시 예정',
              style: AppTextStyles.bodyMedium.copyWith(color: Colors.grey[500]),
            ),
          ],
        ),
      ),
    );
  }
}
