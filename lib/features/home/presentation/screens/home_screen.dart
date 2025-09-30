import 'package:flutter/material.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../shared/widgets/common/common_app_bar.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // CommonAppBar를 사용하여 일관된 AppBar UI 제공
      appBar: CommonAppBar.forHome(
        onMenuPressed: () {
          // 햄버거 메뉴 버튼을 눌렀을 때의 동작
          // 현재는 기본 Drawer 열기 동작이 수행됨
          // 향후 커스텀 사이드 메뉴나 다른 동작으로 변경 가능
          debugPrint(
            '홈 화면 메뉴 버튼 클릭',
          ); // AppStrings에 홈 화면 전용 디버그 메시지가 정의되면 교체 예정
        },
        onNotificationPressed: () {
          // 알림 버튼을 눌렀을 때의 동작
          // 현재는 기본 알림 다이얼로그가 표시됨
          // 향후 알림 목록 화면으로 이동하도록 변경 가능
          debugPrint(
            '홈 화면 알림 버튼 클릭',
          ); // AppStrings에 홈 화면 전용 디버그 메시지가 정의되면 교체 예정
        },
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              AppStrings.of(context).navHome,
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
