import 'package:flutter/material.dart';

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        actions: [
          IconButton(
            icon: const Icon(Icons.clear_all),
            onPressed: () {
              // Clear all notifications
            },
          ),
        ],
      ),
      body: ListView(
        children: [
          _buildNotificationGroup('Today'),
          _buildNotificationGroup('Yesterday'),
          _buildNotificationGroup('This Week'),
        ],
      ),
    );
  }

  Widget _buildNotificationGroup(String title) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
        ),
        _buildNotificationItem(
          'Workout Milestone',
          'Congratulations! You\'ve completed 5 workouts this week! 💪',
          '2 hours ago',
          Icons.fitness_center,
          Colors.blue,
        ),
        _buildNotificationItem(
          'Step Goal Achieved',
          'You\'ve reached your daily goal of 10,000 steps! 🎉',
          '5 hours ago',
          Icons.directions_walk,
          Colors.green,
        ),
        _buildNotificationItem(
          'Meal Reminder',
          'Don\'t forget to log your lunch! 🍽️',
          '8 hours ago',
          Icons.restaurant,
          Colors.orange,
        ),
      ],
    );
  }

  Widget _buildNotificationItem(
    String title,
    String message,
    String time,
    IconData icon,
    Color color,
  ) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color.withOpacity(0.2),
          child: Icon(icon, color: color),
        ),
        title: Text(title),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(message),
            const SizedBox(height: 4),
            Text(
              time,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
            ),
          ],
        ),
        isThreeLine: true,
      ),
    );
  }
} 