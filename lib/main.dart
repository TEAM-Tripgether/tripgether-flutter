import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:go_router/go_router.dart';

import 'core/router/router.dart';
import 'core/theme/app_theme.dart';
import 'core/providers/locale_provider.dart';
import 'core/services/sharing_service.dart';
import 'core/services/auth/google_auth_service.dart';
import 'l10n/app_localizations.dart';

void main() async {
  // Flutter 바인딩 초기화
  WidgetsFlutterBinding.ensureInitialized();

  // 화면 방향을 세로 모드(정방향)로 고정
  // 앱 전체에서 가로 모드를 비활성화하여 일관된 UX 제공
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp, // 정방향 세로 모드만 허용
  ]);

  // 환경 변수 로드 (.env 파일)
  await dotenv.load(fileName: ".env");

  // Google Sign-In 초기화
  await GoogleAuthService.initialize();

  // 공유 서비스 초기화 (앱 시작 시 Share Extension 데이터 확인)
  await SharingService.instance.initialize();

  // ProviderContainer 생성 (GoRouter refreshListenable을 위해 필요)
  final container = ProviderContainer();

  // GoRouter 생성 (UserNotifier 상태 변화 감지 활성화)
  final router = AppRouter.createRouter(container);

  runApp(
    UncontrolledProviderScope(
      container: container,
      child: MyApp(router: router),
    ),
  );
}

/// 앱의 루트 위젯 - PRD.md 구조에 따른 메인 앱 설정
///
/// ScreenUtil 초기화와 GoRouter를 사용한 라우팅 시스템을 적용합니다.
/// 기존의 복잡한 공유 서비스 로직은 홈 화면으로 이동되었습니다.
/// 언어 설정은 LocaleNotifier provider를 통해 관리됩니다.
///
/// [router] GoRouter 인스턴스 (UserNotifier 상태 감지를 위한 refreshListenable 포함)
class MyApp extends ConsumerWidget {
  /// GoRouter 인스턴스
  final GoRouter router;

  const MyApp({super.key, required this.router});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 현재 선택된 언어 설정 가져오기 (null = 시스템 언어)
    final currentLocale = ref.watch(localeNotifierProvider);

    return ScreenUtilInit(
      // 디자인 기준 사이즈 (iPhone 14 기준)
      designSize: const Size(414, 896),
      minTextAdapt: true, // 텍스트 크기 자동 조정
      splitScreenMode: true, // 분할 화면 모드 지원
      builder: (context, child) {
        return MaterialApp.router(
          title: 'Tripgether',

          // AppTheme의 완벽한 테마 시스템 활용
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,

          // 국제화 설정 - 한국어와 영어 지원
          localizationsDelegates: const [
            AppLocalizations.delegate, // 앱 고유 번역
            GlobalMaterialLocalizations.delegate, // Material 위젯 번역
            GlobalWidgetsLocalizations.delegate, // 기본 위젯 번역
            GlobalCupertinoLocalizations.delegate, // Cupertino 위젯 번역
          ],

          // 지원 언어 목록
          supportedLocales: const [
            Locale('ko', ''), // 한국어
            Locale('en', ''), // 영어
          ],

          // 사용자가 선택한 언어 설정 적용
          locale: currentLocale,

          // GoRouter 설정 적용 (refreshListenable 포함)
          routerConfig: router,

          // 디버그 배너 숨김
          debugShowCheckedModeBanner: false,
        );
      },
    );
  }
}
