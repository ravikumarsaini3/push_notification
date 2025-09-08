import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

import 'profile_screen.dart';
import 'setting_screen.dart';
import 'full_screen_notification.dart';
import 'home_screen.dart';
import 'notification_service.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();


@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print("✅ Background message received: ${message.messageId}");

  await NotificationService().showFullScreenNotification(
    title: message.data['title'] ?? message.notification?.title ?? 'New Notification',
    body: message.data['body'] ?? message.notification?.body ?? 'You have a new message',
    route: message.data['route'] ?? '/home',
  );
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // 🔹 Register background handler
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  // 🔹 Initialize Notification Service
  await NotificationService().initialize();

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  RemoteMessage? _initialMessage;

  @override
  void initState() {
    super.initState();
    _setupInitialMessage();
  }

  /// 🔹 Handles notification when app is opened from killed state
  Future<void> _setupInitialMessage() async {
    _initialMessage = await FirebaseMessaging.instance.getInitialMessage();
    if (_initialMessage != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        navigatorKey.currentState?.pushNamed(
          '/fullscreen-notification',
          arguments: {
            'title': _initialMessage?.data['title'] ??
                _initialMessage?.notification?.title,
            'body': _initialMessage?.data['body'] ??
                _initialMessage?.notification?.body,
            'route': _initialMessage?.data['route'] ?? '/home',
          },
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      title: 'Full Screen Notifications',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: HomeScreen(),
      onGenerateRoute: (settings) {
        if (settings.name == '/fullscreen-notification') {
          final args = settings.arguments as Map<String, dynamic>?;
          return MaterialPageRoute(
            builder: (context) => FullScreenNotificationScreen(
              title: args?['title'],
              body: args?['body'],
              route: args?['route'],
            ),
          );
        }
        if (settings.name == '/home') {
          return MaterialPageRoute(builder: (_) => HomeScreen());
        }
        if (settings.name == '/profile') {
          return MaterialPageRoute(builder: (_) => ProfileScreen());
        }
        if (settings.name == '/settings') {
          return MaterialPageRoute(builder: (_) => SettingsScreen());
        }
        return null;
      },
    );
  }
}
