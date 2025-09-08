import 'dart:convert';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';

import 'main.dart';

class NotificationService {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications =
  FlutterLocalNotificationsPlugin();

  Future<void> initialize() async {
    // Request permissions
    await _requestPermissions();

    // Initialize Firebase Messaging
    await _initializeFirebaseMessaging();

    // Initialize local notifications
    await _initializeLocalNotifications();

    // Set up message handlers
    _setupMessageHandlers();
  }

  Future<void> _requestPermissions() async {
    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
    print('User granted permission: ${settings.authorizationStatus}');

    // Request other permissions (optional)
    await [
      Permission.notification,
      Permission.systemAlertWindow,
    ].request();
  }

  Future<void> _initializeFirebaseMessaging() async {
    // Get FCM token
    String? token = await _firebaseMessaging.getToken();
    print('FCM Token: $token');

    // Configure iOS foreground presentation
    await _firebaseMessaging.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  Future<void> _initializeLocalNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
    );

    await _localNotifications.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );

    // Create high importance notification channel (Android)
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'high_importance_channel',
      'High Importance Notifications',
      description: 'This channel is used for important notifications.',
      importance: Importance.max,
      enableVibration: true,
      enableLights: true,
      ledColor: Colors.blue,
      showBadge: true,
    );

    await _localNotifications
        .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
  }

  void _setupMessageHandlers() {
    // Foreground messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Got a message in the foreground!');
      _handleMessage(message);
    });

    // App opened from background
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('onMessageOpenedApp event!');
      _handleMessageOpened(message);
    });

    // Background handler already defined at top-level
    //FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  }

  Future<void> _handleMessage(RemoteMessage message) async {
    // ✅ Always prefer data payload over notification payload
    String title = message.data['title'] ??
        message.notification?.title ??
        'New Notification';

    String body = message.data['body'] ??
        message.notification?.body ??
        'You have a new message';

    String route = message.data['route'] ?? '/home';

    // ✅ Prevent showing duplicate system notifications
    if (message.notification != null && message.data.isEmpty) {
      print("⚠️ Ignoring Firebase auto-notification (using only data).");
      return;
    }

    await showFullScreenNotification(
      title: title,
      body: body,
      route: route,
    );
  }


  void _handleMessageOpened(RemoteMessage message) {
    String route = message.data['route'] ?? '/home';
    navigatorKey.currentState?.pushNamed(route);
  }

  Future<void> showFullScreenNotification({
    required String title,
    required String body,
    required String route,
    bool fromBackground = false,
  }) async {
    final androidDetails = AndroidNotificationDetails(
      'high_importance_channel',
      'High Importance Notifications',
      channelDescription: 'This channel is used for important notifications.',
      importance: Importance.max,
      priority: Priority.high,
      fullScreenIntent: true,
      category: AndroidNotificationCategory.call,
      autoCancel: true,
    );

    final details = NotificationDetails(android: androidDetails);

    await _localNotifications.show(
      0,
      title,
      body,
      details,
      payload: jsonEncode({'title': title, 'body': body, 'route': route}),
    );

    // 👉 Only navigate if app is in foreground
    if (!fromBackground) {
      navigatorKey.currentState?.pushNamed(
        '/fullscreen-notification',
        arguments: {'title': title, 'body': body, 'route': route},
      );
    }
  }

  void _onNotificationTapped(NotificationResponse notificationResponse) {
    if (notificationResponse.payload != null) {
      Map<String, dynamic> payload = jsonDecode(notificationResponse.payload!);
      String route = payload['route'] ?? '/home';
      navigatorKey.currentState?.pushNamed(route);
      print('Navigate to: $route');
    }
  }

  Future<String?> getFCMToken() async {
    return await _firebaseMessaging.getToken();
  }
}

/// ✅ Background message handler MUST be outside the class
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('Handling a background message: ${message.messageId}');

  await NotificationService().showFullScreenNotification(
    title: message.data['title'] ??
        message.notification?.title ??
        'New Notification',
    body: message.data['body'] ??
        message.notification?.body ??
        'You have a new message',
    route: message.data['route'] ?? '/home',
    fromBackground: true,
  );
}
