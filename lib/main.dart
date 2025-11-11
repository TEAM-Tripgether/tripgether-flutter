import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:tripgether/core/services/fcm/firebase_messaging_service.dart';
import 'package:tripgether/core/services/fcm/local_notifications_service.dart';

import 'firebase_options.dart';
import 'core/router/router.dart';
import 'core/theme/app_theme.dart';
import 'core/providers/locale_provider.dart';
import 'core/services/sharing_service.dart';
import 'core/services/auth/google_auth_service.dart';
import 'features/auth/providers/user_provider.dart';
import 'l10n/app_localizations.dart';

void main() async {
  // 1. Flutter 바인딩 초기화 (최우선 - 모든 네이티브 플러그인 사용 전 필수)
  WidgetsFlutterBinding.ensureInitialized();

  // 2. 환경 변수 로드 (.env 파일)
  // 다른 서비스들이 환경 변수를 참조할 수 있으므로 먼저 로드
  await dotenv.load(fileName: ".env");

  // 3. FlutterSecureStorage 워밍업 (iOS Keychain 활성화)
  // iOS에서 Keychain 첫 접근 시 발생할 수 있는 블로킹을 미리 해결
  // 이를 통해 UserNotifier.build()에서의 Storage 읽기가 즉시 완료됨
  const storage = FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
    iOptions: IOSOptions(
      accessibility: KeychainAccessibility.first_unlock_this_device,
    ),
  );
  try {
    await storage.read(key: 'warmup_key');
    debugPrint('✅ FlutterSecureStorage 워밍업 완료');
  } catch (e) {
    debugPrint('✅ FlutterSecureStorage 워밍업 완료 (에러 무시): $e');
  }

  // 4. 화면 방향을 세로 모드(정방향)로 고정
  // 앱 전체에서 가로 모드를 비활성화하여 일관된 UX 제공
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp, // 정방향 세로 모드만 허용
  ]);

  // 5. Firebase 초기화 (firebase_options.dart에서 플랫폼별 설정 자동 선택)
  // FCM 서비스의 의존성이므로 먼저 초기화
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // 6. Local Notifications 초기화
  // Firebase Messaging이 이 서비스를 의존하므로 먼저 초기화
  final localNotificationsService = LocalNotificationsService.instance();
  await localNotificationsService.init();

  // 7. Firebase Messaging 초기화
  // Firebase와 Local Notifications에 의존
  final firebaseMessagingService = FirebaseMessagingService.instance();
  await firebaseMessagingService.init(
    localNotificationsService: localNotificationsService,
  );

  // 8. Google Sign-In 초기화
  // 환경 변수의 Google OAuth 설정을 사용
  await GoogleAuthService.initialize();

  // 9. 공유 서비스 초기화 (앱 시작 시 Share Extension 데이터 확인)
  await SharingService.instance.initialize();

  // 10. ProviderContainer 생성 (Riverpod 상태 관리를 위해 필요)
  final container = ProviderContainer();

  // 11. ⭐ UserNotifier 사전 초기화 (Router 생성 데드락 방지)
  // GoRouterRefreshNotifier.listen()과 RouteGuard.isAuthenticated()가
  // 동기적으로 userNotifierProvider를 읽기 전에 async build()를 완료시킴
  // 이를 통해 Router 생성 시 이미 초기화된 provider를 사용하므로 블로킹 없음
  await container.read(userNotifierProvider.future);

  // 12. GoRouter 생성 (UserNotifier 상태 변화 감지 활성화)
  // UserNotifier가 이미 초기화되어 있으므로 동기적 listen() 호출이 안전함
  // GoRouterRefreshNotifier가 UserNotifier 상태 변화를 감지하여 redirect를 재실행
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
