import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'main.dart';

class FullScreenNotificationScreen extends StatelessWidget {
  final String? title;
  final String? body;
  final String? route;

  const FullScreenNotificationScreen({
    Key? key,
    this.title,
    this.body,
    this.route,
  }) : super(key: key);

  void _dismissNotification(BuildContext context) {
    Navigator.of(context).pop();
  }

  void _openApp(BuildContext context) {
    Navigator.of(context).pop();
    navigatorKey.currentState?.pushNamed('/profile');
  }

  @override
  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;

    final title = args?['title'] ?? 'New Notification';
    final body = args?['body'] ?? 'You have a new message';
    final route = args?['route'] ?? '/home';

    return Scaffold(
      backgroundColor: Colors.black87,
      body: SafeArea(
        child: Center(
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 20),
            padding: EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 10,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.notifications_active, color: Colors.blue, size: 60),
                SizedBox(height: 20),
                Text(title,
                    style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87),
                    textAlign: TextAlign.center),
                SizedBox(height: 12),
                Text(body,
                    style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                    textAlign: TextAlign.center),
                SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey[300],
                        foregroundColor: Colors.black87,
                        padding: EdgeInsets.symmetric(
                            horizontal: 20, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                      child: Text('Dismiss'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        navigatorKey.currentState?.pushNamed(route);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(
                            horizontal: 20, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                      child: Text('Open App'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

}
