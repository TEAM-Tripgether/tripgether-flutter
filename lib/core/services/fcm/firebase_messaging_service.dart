import 'package:flutter/foundation.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:tripgether/core/services/fcm/local_notification_service.dart';

class FirebaseMessagingService {
  // Private constructor for singleton pattern
  // 싱클톤 패턴을 위한 프라이빗 생성자
  FirebaseMessagingService._internal();

  // Singleton instance
  // 싱글톤 인스턴스
  static final FirebaseMessagingService _instance =
      FirebaseMessagingService._internal();

  // Factory constructor to provide singleton instance
  // 싱글톤 인스턴스를 제공하는 팩토리 생성자
  factory FirebaseMessagingService.instance() => _instance;

  // Referenece to local notification service for displaying notifications
  // 알림 표시를 위한 로컬 알림 서비스 참조
  LocalNotificationService? _localNotificationService;

  // Initialize Firebase Messaging and sets up all message listeners
  // Firebase Messaging 초기화 및 모든 메시지 리스너 설정
  Future<void> init({
    required LocalNotificationService localNotificationService,
  }) async {
    // Init local notification service
    // 로컬 알림 서비스 초기화
    _localNotificationService = localNotificationService;

    // Handle FCM token
    // FCM 토큰 처리
    _handlePushNotificationToken();

    // Request user permissions for notifications
    // 알림에 대한 사용자 권한 요청
    _requestPermissions();

    // Register handler for background messages (app terminated)
    // 백그라운드 메시지(앱 종료 상태) 핸들러 등록
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    // Listen for messages when the app is in the foreground
    // 앱이 포그라운드에 있을 때 메시지 수신 대기
    FirebaseMessaging.onMessage.listen(_onForegroundMessage);

    // Listen for notification taps when the app is in background but not terminated
    // 앱이 백그라운드에 있지만 종료되지 않은 상태에서 알림 탭 수신 대기
    FirebaseMessaging.onMessageOpenedApp.listen(_onMessageOpenedApp);

    // Check for initial message that opened the app from a terminated state
    // 종료된 상태에서 앱을 연 초기 메시지 확인
    final initialMessage = await FirebaseMessaging.instance.getInitialMessage();
    if (initialMessage != null) {
      _onMessageOpenedApp(initialMessage);
    }
  }

  // Retrieves and manages the FCM token for push notifications
  // 푸시 알림을 위한 FCM 토큰 검색 및 관리
  Future<void> _handlePushNotificationToken() async {
    // Get the FCM token for this device
    // 이 기기의 FCM 토큰 가져오기
    final token = await FirebaseMessaging.instance.getToken();
    debugPrint('Push notifications Token: $token');

    FirebaseMessaging.instance.onTokenRefresh
        .listen((fcmToken) {
          debugPrint('FCM Token refreshed: $fcmToken');
          // TODO : optionally send token to your server for targeting this device
          // TODO : 선택적으로 이 기기를 타겟팅하기 위해 토큰을 서버로 전송
        })
        .onError((error) {
          debugPrint('Error refreshing FCM Token: $error');
        });
  }

  // Requests notification permissions from the user
  // 사용자로부터 알림 권한 요청
  Future<void> _requestPermissions() async {
    // Request permission for alert, badge, and sound
    // 알림, 배지 및 사운드에 대한 권한 요청
    final result = await FirebaseMessaging.instance.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    // Log the user's permission decision
    // 사용자의 권한 결정 로그
    debugPrint('User granted permission: ${result.authorizationStatus}');
  }

  // Handles incoming messages when the app is in the foreground
  // 앱이 포그라운드에 있을 때 수신된 메시지 처리
  Future<void> _onForegroundMessage(RemoteMessage message) async {
    debugPrint('Foreground message received: ${message.data.toString()}');

    // Show local notification for the received message
    // 수신된 메시지에 대한 로컬 알림 표시
    final notificationData = message.notification;
    if (notificationData != null) {
      _localNotificationService?.showNotification(
        title: notificationData.title ?? 'Tripgether',
        body: notificationData.body ?? '',
        payload: message.data.toString(),
      );
    }
  }

  // Handles notification taps when the app is in background or terminated state
  // 앱이 백그라운드 또는 종료 상태일 때 알림 탭 처리
  void _onMessageOpenedApp(RemoteMessage message) {
    debugPrint(
      'Notification caused the app to open: ${message.data.toString()}',
    );
    // TODO : Add navigation or specific handling based on notification data
    // TODO : 알림 데이터를 기반으로 탐색 또는 특정 처리 추가
  }

  // Background message handler (must be top-level function or static)
  // 백그라운드 메시지 핸들러 (최상위 함수 또는 정적이어야 함)
  @pragma('vm:entry-point')
  Future<void> _firebaseMessagingBackgroundHandler(
    RemoteMessage message,
  ) async {
    debugPrint('Background message received: ${message.data.toString()}');
  }
}
