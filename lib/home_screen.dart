import 'package:flutter/material.dart';
import 'notification_service.dart';

class HomeScreen extends StatelessWidget {
  Future<void> _testNotification() async {
    await NotificationService().showFullScreenNotification(
      title: 'Test Notification',
      body: 'This is a test full-screen notification',
      route: '/fullscreen-notification',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text('Home'),
        backgroundColor: Colors.blue,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Header
            CircleAvatar(
              radius: 45,
              backgroundColor: Colors.blue[100],
              child: Icon(Icons.person, size: 50, color: Colors.blue),
            ),
            SizedBox(height: 15),
            Text(
              'Welcome, PriyaQubit 👋',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 6),
            Text(
              'Your personalized notification center',
              style: TextStyle(fontSize: 16, color: Colors.grey[700]),
            ),
            SizedBox(height: 30),

            // Action Buttons in Grid
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 15,
                mainAxisSpacing: 15,
                children: [
                  _buildActionCard(
                    icon: Icons.notifications_active,
                    title: "Test Notification",
                    color: Colors.orange,
                    onTap: _testNotification,
                  ),
                  _buildActionCard(
                    icon: Icons.person,
                    title: "Profile",
                    color: Colors.green,
                    onTap: () => Navigator.pushNamed(context, '/profile'),
                  ),
                  _buildActionCard(
                    icon: Icons.settings,
                    title: "Settings",
                    color: Colors.blue,
                    onTap: () => Navigator.pushNamed(context, '/settings'),
                  ),
                  _buildActionCard(
                    icon: Icons.info,
                    title: "About",
                    color: Colors.purple,
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("This is a demo Home Screen")),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionCard({
    required IconData icon,
    required String title,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: color.withOpacity(0.1),
          ),
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                backgroundColor: color.withOpacity(0.2),
                radius: 28,
                child: Icon(icon, size: 30, color: color),
              ),
              SizedBox(height: 12),
              Text(
                title,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
