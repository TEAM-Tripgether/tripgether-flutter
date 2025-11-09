import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:tripgether/core/services/fcm/local_notifications_service.dart';

/// Firebase Cloud Messaging 서비스
/// FCM 푸시 알림을 관리하고 메시지를 처리합니다
class FirebaseMessagingService {
  // Private constructor for singleton pattern
  // 싱글톤 패턴을 위한 private 생성자
  FirebaseMessagingService._internal();

  // Singleton instance
  // 싱글톤 인스턴스
  static final FirebaseMessagingService _instance =
      FirebaseMessagingService._internal();

  // Factory constructor to provide singleton instance
  // 싱글톤 인스턴스를 제공하는 팩토리 생성자
  factory FirebaseMessagingService.instance() => _instance;

  // Reference to local notifications service for displaying notifications
  // 알림 표시를 위한 로컬 알림 서비스 참조
  LocalNotificationsService? _localNotificationsService;

  /// Initialize Firebase Messaging and sets up all message listeners
  /// Firebase Messaging을 초기화하고 모든 메시지 리스너를 설정합니다
  Future<void> init({
    required LocalNotificationsService localNotificationsService,
  }) async {
    // Init local notifications service
    // 로컬 알림 서비스 초기화
    _localNotificationsService = localNotificationsService;

    // Handle FCM token
    // FCM 토큰 처리
    _handlePushNotificationsToken();

    // Request user permission for notifications
    // 알림 권한 요청
    _requestPermission();

    // Register handler for background messages (app terminated)
    // 백그라운드 메시지 핸들러 등록 (앱 종료 상태)
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    // Listen for messages when the app is in foreground
    // 앱이 포그라운드 상태일 때 메시지 수신 대기
    FirebaseMessaging.onMessage.listen(_onForegroundMessage);

    // Listen for notification taps when the app is in background but not terminated
    // 앱이 백그라운드 상태일 때 알림 탭 이벤트 수신 대기
    FirebaseMessaging.onMessageOpenedApp.listen(_onMessageOpenedApp);

    // Check for initial message that opened the app from terminated state
    // 앱이 종료 상태에서 알림으로 실행된 경우 초기 메시지 확인
    final initialMessage = await FirebaseMessaging.instance.getInitialMessage();
    if (initialMessage != null) {
      _onMessageOpenedApp(initialMessage);
    }
  }

  /// Retrieves and manages the FCM token for push notifications
  /// 푸시 알림을 위한 FCM 토큰을 가져오고 관리합니다
  Future<void> _handlePushNotificationsToken() async {
    try {
      // Get the FCM token for the device
      // 디바이스의 FCM 토큰 가져오기
      final token = await FirebaseMessaging.instance.getToken();
      debugPrint('✅ Push notifications token: $token');

      // Listen for token refresh events
      // 토큰 갱신 이벤트 수신 대기
      FirebaseMessaging.instance.onTokenRefresh
          .listen((fcmToken) {
            debugPrint('🔄 FCM token refreshed: $fcmToken');
            // TODO: optionally send token to your server for targeting this device
            // TODO: 선택적으로 서버에 토큰을 전송하여 이 디바이스를 타겟팅할 수 있습니다
          })
          .onError((error) {
            // Handle errors during token refresh
            // 토큰 갱신 중 발생한 에러 처리
            debugPrint('❌ Error refreshing FCM token: $error');
          });
    } catch (e) {
      // Handle token retrieval errors
      // 토큰 가져오기 에러 처리
      debugPrint('⚠️ Unable to get FCM token: $e');
      debugPrint('📱 Note: FCM tokens are only available on physical iOS devices, not simulators');
      // Don't throw - allow app to continue running on simulator
      // 에러를 throw하지 않음 - 시뮬레이터에서도 앱이 계속 실행되도록 함
    }
  }

  /// Requests notification permission from the user
  /// 사용자에게 알림 권한을 요청합니다
  Future<void> _requestPermission() async {
    // Request permission for alerts, badges, and sounds
    // 알림, 배지, 사운드에 대한 권한 요청
    final result = await FirebaseMessaging.instance.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    // Log the user's permission decision
    // 사용자의 권한 허용 여부 로그 기록
    debugPrint('User granted permission: ${result.authorizationStatus}');
  }

  /// Handles messages received while the app is in the foreground
  /// 앱이 포그라운드 상태일 때 수신한 메시지를 처리합니다
  void _onForegroundMessage(RemoteMessage message) {
    debugPrint('Foreground message received: ${message.data.toString()}');
    final notificationData = message.notification;
    if (notificationData != null) {
      // Display a local notification using the service
      // 서비스를 사용하여 로컬 알림 표시
      _localNotificationsService?.showNotification(
        notificationData.title,
        notificationData.body,
        message.data.toString(),
      );
    }
  }

  /// Handles notification taps when app is opened from the background or terminated state
  /// 앱이 백그라운드 또는 종료 상태에서 알림 탭으로 열렸을 때 처리합니다
  void _onMessageOpenedApp(RemoteMessage message) {
    debugPrint('Notification caused the app to open: ${message.data.toString()}');
    // TODO: Add navigation or specific handling based on message data
    // TODO: 메시지 데이터를 기반으로 화면 이동 또는 특정 처리를 추가하세요
  }
}

/// Background message handler (must be top-level function or static)
/// Handles messages when the app is fully terminated
/// 백그라운드 메시지 핸들러 (최상위 함수 또는 static이어야 함)
/// 앱이 완전히 종료된 상태에서 메시지를 처리합니다
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  debugPrint('Background message received: ${message.data.toString()}');
}
