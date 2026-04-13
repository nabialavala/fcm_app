import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';

class FCMService {
  final FirebaseMessaging messaging = FirebaseMessaging.instance;

  Future<void> initialize({
    required void Function(RemoteMessage) onData,
  }) async {
    // Request notification permission
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    debugPrint('Permission status: ${settings.authorizationStatus}');

    // Foreground messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      debugPrint('Foreground message received');
      debugPrint('Title: ${message.notification?.title}');
      debugPrint('Body: ${message.notification?.body}');
      debugPrint('Data: ${message.data}');
      onData(message);
    });

    // App opened by tapping notification
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      debugPrint('Notification tapped from background state');
      debugPrint('Data: ${message.data}');
      onData(message);
    });

    // App launched from terminated state by tapping notification
    final RemoteMessage? initialMessage = await messaging.getInitialMessage();
    if (initialMessage != null) {
      debugPrint('App opened from terminated state');
      debugPrint('Data: ${initialMessage.data}');
      onData(initialMessage);
    }
  }

  Future<String?> getToken() async {
    final token = await messaging.getToken();
    debugPrint('FCM token: $token');
    return token;
  }
}