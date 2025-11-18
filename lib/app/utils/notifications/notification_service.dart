import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notifications =
  FlutterLocalNotificationsPlugin();

  /// ------------------------------------------
  /// INITIALIZE NOTIFICATION SYSTEM
  /// ------------------------------------------
  static Future<void> initialize() async {
    const AndroidInitializationSettings androidInit =
    AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initSettings =
    InitializationSettings(android: androidInit);

    await _notifications.initialize(initSettings);
  }

  /// ------------------------------------------
  /// SCHEDULE NOTIFICATION
  /// ------------------------------------------
  static Future<void> scheduleTaskReminder({
    required int id,
    required String title,
    required String body,
    required DateTime dueDate,
    int minutesBefore = 15,
  }) async {
    final scheduleTime =
    dueDate.subtract(Duration(minutes: minutesBefore));

    if (scheduleTime.isBefore(DateTime.now())) {
      // Avoid scheduling past-time notifications
      return;
    }

    await _notifications.zonedSchedule(
      id,
      title,
      body,
      tz.TZDateTime.from(scheduleTime, tz.local),

      const NotificationDetails(
        android: AndroidNotificationDetails(
          'task_channel',
          'Task Reminders',
          channelDescription: 'Reminder before task is due',
          importance: Importance.high,
          priority: Priority.high,
        ),
      ),

      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
      UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  /// ------------------------------------------
  /// CANCEL notification for a deleted task
  /// ------------------------------------------
  static Future<void> cancel(int id) async {
    await _notifications.cancel(id);
  }

  /// ------------------------------------------
  /// CANCEL ALL (optional)
  /// ------------------------------------------
  static Future<void> cancelAll() async {
    await _notifications.cancelAll();
  }
}
