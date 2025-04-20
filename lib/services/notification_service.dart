import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

class NotificationService {
  static final NotificationService _instance = NotificationService._();
  static NotificationService get instance => _instance;

  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  NotificationService._();

  Future<void> init() async {
    tz.initializeTimeZones();

    const androidInitialize =
        AndroidInitializationSettings('app_icon'); // Make sure to add app icon
    const iOSInitialize = DarwinInitializationSettings(
      requestSoundPermission: true,
      requestBadgePermission: true,
      requestAlertPermission: true,
    );
    const initializationSettings = InitializationSettings(
      android: androidInitialize,
      iOS: iOSInitialize,
    );

    await _flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (details) {
        // Handle notification tap
        _handleNotificationTap(details);
      },
    );
  }

  void _handleNotificationTap(NotificationResponse details) {
    // Handle different notification types
    switch (details.payload) {
      case 'workout':
        // Navigate to workout screen
        break;
      case 'meal':
        // Navigate to meal tracking screen
        break;
      case 'steps':
        // Navigate to steps tracking screen
        break;
    }
  }

  // Schedule daily reminders
  Future<void> scheduleDailyReminders() async {
    // Morning workout reminder
    await scheduleNotification(
      id: 1,
      title: 'Time for Your Morning Workout! 💪',
      body: "Don't forget to start your day with exercise",
      hour: 7,
      minute: 0,
      payload: 'workout',
    );

    // Meal tracking reminders
    await scheduleNotification(
      id: 2,
      title: 'Breakfast Time! 🍳',
      body: "Don't forget to log your breakfast",
      hour: 8,
      minute: 0,
      payload: 'meal',
    );

    await scheduleNotification(
      id: 3,
      title: 'Lunch Time! 🥗',
      body: "Time to log your lunch",
      hour: 13,
      minute: 0,
      payload: 'meal',
    );

    await scheduleNotification(
      id: 4,
      title: 'Dinner Time! 🍽️',
      body: "Remember to log your dinner",
      hour: 19,
      minute: 0,
      payload: 'meal',
    );

    // Evening step count check
    await scheduleNotification(
      id: 5,
      title: 'Step Count Check 👣',
      body: "Check your daily step progress!",
      hour: 20,
      minute: 0,
      payload: 'steps',
    );
  }

  // Schedule a daily notification
  Future<void> scheduleNotification({
    required int id,
    required String title,
    required String body,
    required int hour,
    required int minute,
    String? payload,
  }) async {
    await _flutterLocalNotificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      _nextInstanceOfTime(hour, minute),
      NotificationDetails(
        android: AndroidNotificationDetails(
          'fitness_app_channel',
          'Fitness Reminders',
          channelDescription: 'Notifications for workouts and meal tracking',
          importance: Importance.high,
          priority: Priority.high,
          enableLights: true,
        ),
        iOS: const DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
      payload: payload,
    );
  }

  // Send milestone notification
  Future<void> sendMilestoneNotification({
    required String title,
    required String body,
    String? payload,
  }) async {
    await _flutterLocalNotificationsPlugin.show(
      DateTime.now().millisecond,
      title,
      body,
      NotificationDetails(
        android: AndroidNotificationDetails(
          'milestone_channel',
          'Milestone Alerts',
          channelDescription: 'Notifications for achieved milestones',
          importance: Importance.max,
          priority: Priority.high,
          enableLights: true,
          playSound: true,
          icon: 'app_icon',
        ),
        iOS: const DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),
      payload: payload,
    );
  }

  // Calculate next instance of time
  tz.TZDateTime _nextInstanceOfTime(int hour, int minute) {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      hour,
      minute,
    );

    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    return scheduledDate;
  }

  // Methods for specific milestone notifications
  Future<void> notifyStepMilestone(int steps) async {
    await sendMilestoneNotification(
      title: 'Step Goal Achievement! 🎉',
      body: 'Congratulations! You\'ve reached $steps steps today!',
      payload: 'steps',
    );
  }

  Future<void> notifyWorkoutMilestone(int workouts) async {
    await sendMilestoneNotification(
      title: 'Workout Milestone! 💪',
      body: 'Amazing! You\'ve completed $workouts workouts this week!',
      payload: 'workout',
    );
  }

  Future<void> notifyWeightLossMilestone(double kg) async {
    await sendMilestoneNotification(
      title: 'Weight Loss Goal! ⭐',
      body: 'Incredible! You\'ve lost $kg kg! Keep going!',
      payload: 'weight',
    );
  }

  Future<void> notifyStreakMilestone(int days) async {
    await sendMilestoneNotification(
      title: 'Streak Milestone! 🔥',
      body: 'Awesome! You\'ve maintained a $days day streak!',
      payload: 'streak',
    );
  }
} 