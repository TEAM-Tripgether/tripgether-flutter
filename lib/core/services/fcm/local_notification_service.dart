import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/foundation.dart';

class LocalNotificationService {
  // 싱글톤 패턴을 위한 프라이빗 생성자
  LocalNotificationService._internal();

  // 싱글톤 인스턴스
  static final LocalNotificationService _instance =
      LocalNotificationService._internal();

  // 팩토리 생성자를 통해 싱글톤 인스턴스 반환
  factory LocalNotificationService() {
    return _instance;
  }

  // Main plugin for handling notifications
  // 알림 처리를 위한 주요 플러그인
  late FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin;

  // Android-specific initialization settings using app launcher icon
  // 안드로이드 전용 초기화 설정 (앱 런처 아이콘 사용)
  final _androidInitializationSettings = const AndroidInitializationSettings(
    '@mipmap/ic_launcher',
  );

  // iOS-specific initialization settings
  // iOS 전용 초기화 설정
  final _iosInitializationSettings = const DarwinInitializationSettings(
    requestAlertPermission: true,
    requestBadgePermission: true,
    requestSoundPermission: true,
  );

  // Android notification channel configuration
  // 안드로이드 알림 채널 구성
  final _androidChannel = const AndroidNotificationChannel(
    'channel_id', // 채널 ID
    'Channel Name', // 채널 이름
    description: 'Android push notification channel', // 채널 설명
    importance: Importance.max, // 최대 중요도
  );

  // Flag to track initialization status
  // 초기화 상태를 추적하는 플래그
  bool _isFlutterLocalNotificationsInitialized = false;

  // Counter for generating unique notification IDs
  // 고유한 알림 ID 생성을 위한 카운터
  final int _notificationIdCounter = 0;

  // Initialize the local notification plugin for Android and IOS
  Future<void> initialize() async {
    // Check if already initialized to prevent redundant setups
    // 중복 설정을 방지하기 위해 이미 초기화되었는지 확인
    if (_isFlutterLocalNotificationsInitialized) return;

    // Create plugin instance
    // 플러그인 인스턴스 생성
    _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    // Combine platform-specific settings
    // 플랫폼별 설정 결합
    final initializationSettings = InitializationSettings(
      android: _androidInitializationSettings,
      iOS: _iosInitializationSettings,
    );

    // Initialize plugin with settings and callback for notification taps
    // 설정 및 알림 탭에 대한 콜백으로 플러그인 초기화
    await _flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        // Handle notification tap in foreground
        // 포그라운드에서 알림 탭 처리
        debugPrint(
          "Foreground Notification has been tapped: ${response.payload}",
        );
      },
    );

    // Create Android notification channel
    // 안드로이드 알림 채널 생성
    await _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(_androidChannel);

    // Mark initialization as complete
    // 초기화를 완료로 표시
    _isFlutterLocalNotificationsInitialized = true;
  }

  // Show a local notification with given title, body, and optional payload
  Future<void> showNotification({
    required String title,
    required String body,
    String? payload,
  }) async {
    // Ensure plugin is initialized before showing notification
    // 알림을 표시하기 전에 플러그인이 초기화되었는지 확인
    if (!_isFlutterLocalNotificationsInitialized) {
      await initialize();
    }

    // Android-specific notification details
    // 안드로이드 전용 알림 세부 정보
    final androidDetails = AndroidNotificationDetails(
      _androidChannel.id,
      _androidChannel.name,
      channelDescription: _androidChannel.description,
      importance: Importance.max,
      priority: Priority.high,
    );

    // iOS-specific notification details
    // iOS 전용 알림 세부 정보
    final iosDetails = const DarwinNotificationDetails();

    // Combine platform-specific notification details
    // 플랫폼별 알림 세부 정보 결합
    final notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    // Show the notification with a unique ID
    // 고유한 ID로 알림 표시
    await _flutterLocalNotificationsPlugin.show(
      _notificationIdCounter,
      title,
      body,
      notificationDetails,
      payload: payload,
    );
  }
}
