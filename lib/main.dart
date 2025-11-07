import 'dart:io' show Platform;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_core/firebase_core.dart';

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

  // Firebase 초기화 (.env 값으로 동적 초기화)
  await _initializeFirebase();

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

/// Firebase 동적 초기화
/// .env 파일에서 읽은 키 값으로 플랫폼별 FirebaseOptions를 구성하여 초기화합니다.
///
/// **장점**:
/// - google-services.json과 GoogleService-Info.plist 파일의 민감한 키를 Git에 올리지 않아도 됨
/// - .env 파일만 팀원들에게 공유하면 됨
/// - 환경별(개발/스테이징/프로덕션) Firebase 프로젝트를 쉽게 전환 가능
Future<void> _initializeFirebase() async {
  try {
    // 플랫폼별 FirebaseOptions 구성
    final options = Platform.isAndroid
        ? FirebaseOptions(
            apiKey: dotenv.env['FIREBASE_ANDROID_API_KEY']!,
            appId: dotenv.env['FIREBASE_ANDROID_APP_ID']!,
            messagingSenderId: dotenv.env['FIREBASE_MESSAGING_SENDER_ID']!,
            projectId: dotenv.env['FIREBASE_PROJECT_ID']!,
            storageBucket: dotenv.env['FIREBASE_STORAGE_BUCKET']!,
          )
        : FirebaseOptions(
            apiKey: dotenv.env['FIREBASE_IOS_API_KEY']!,
            appId: dotenv.env['FIREBASE_IOS_APP_ID']!,
            messagingSenderId: dotenv.env['FIREBASE_MESSAGING_SENDER_ID']!,
            projectId: dotenv.env['FIREBASE_PROJECT_ID']!,
            storageBucket: dotenv.env['FIREBASE_STORAGE_BUCKET']!,
            iosBundleId: dotenv.env['FIREBASE_IOS_BUNDLE_ID']!,
          );

    // Firebase 초기화 실행
    await Firebase.initializeApp(options: options);

    debugPrint('✅ Firebase 초기화 성공 (${Platform.isAndroid ? 'Android' : 'iOS'})');
  } catch (e) {
    debugPrint('❌ Firebase 초기화 실패: $e');
    // Firebase 초기화 실패 시에도 앱은 계속 실행됨 (FCM 기능만 비활성화)
  }
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
