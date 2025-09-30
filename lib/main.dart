import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'core/router/router.dart';
import 'core/theme/app_theme.dart';

void main() => runApp(const MyApp());

/// 앱의 루트 위젯 - PRD.md 구조에 따른 메인 앱 설정
///
/// ScreenUtil 초기화와 GoRouter를 사용한 라우팅 시스템을 적용합니다.
/// 기존의 복잡한 공유 서비스 로직은 홈 화면으로 이동되었습니다.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      // 디자인 기준 사이즈 (iPhone 14 기준)
      designSize: const Size(414, 896),
      minTextAdapt: true, // 텍스트 크기 자동 조정
      splitScreenMode: true, // 분할 화면 모드 지원
      builder: (context, child) {
        return MaterialApp.router(
          title: 'TripTogether',

          // AppTheme의 완벽한 테마 시스템 활용
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,

          // GoRouter 설정 적용
          routerConfig: AppRouter.router,

          // 디버그 배너 숨김
          debugShowCheckedModeBanner: false,
        );
      },
    );
  }
}
