import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../shared/widgets/common/common_app_bar.dart';
import '../../../../core/constants/app_strings.dart';

/// 마이페이지 화면
///
/// 사용자의 개인 정보와 설정을 관리할 수 있는 화면입니다.
/// 개인 계정 중심의 화면으로 설정 버튼을 강조하여 배치했습니다.
class MyPageScreen extends StatelessWidget {
  const MyPageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 마이페이지에 최적화된 AppBar
      // 개인 계정 관리 중심으로 설정 기능을 강조
      appBar: CommonAppBar(
        title: AppStrings.screenMyPage,
        showMenuButton: false, // 마이페이지에서는 메뉴 버튼 제거 (개인 공간)
        showNotificationIcon: true, // 개인 알림 확인을 위해 알림 아이콘 유지
        onNotificationPressed: () {
          debugPrint(AppStrings.debugMyPageNotificationClicked);
          // TODO: 개인 알림 목록 화면으로 이동
        },
        rightActions: [
          // 설정 버튼 - 마이페이지의 핵심 기능
          Semantics(
            label: AppStrings.semanticSettingsButton,
            button: true,
            child: IconButton(
              icon: Icon(
                Icons.settings_outlined,
                size: 24.w,
                color: Colors.grey[700],
              ),
              onPressed: () {
                debugPrint(AppStrings.debugMyPageSettingsClicked);
                // TODO: 설정 화면으로 이동
              },
              tooltip: AppStrings.tooltipSettings,
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
              Icons.person_outline,
              size: 64.w,
              color: Colors.grey[400],
            ),
            SizedBox(height: 16.h),
            Text(
              AppStrings.screenMyPage,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: Colors.grey[700],
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              AppStrings.placeholderMyPage,
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
