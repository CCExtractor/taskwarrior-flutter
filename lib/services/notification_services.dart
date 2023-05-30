import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  final AndroidInitializationSettings _androidInitializationSettings =
      const AndroidInitializationSettings('taskwarrior');
  DarwinInitializationSettings iosSettings = const DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestCriticalPermission: true,
      requestSoundPermission: true);

  void initiliazeNotification() async {
    InitializationSettings initializationSettings = InitializationSettings(
        android: _androidInitializationSettings, iOS: iosSettings);

    await _flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  void sendNotification(DateTime dtb, String task) async {
    DateTime dateTime = DateTime.now();
    tz.initializeTimeZones();
    print("date and time are:-$dateTime");
    print("date and time are:-$dtb");

    // represent the time when the task is actually scheduled to go off
    final tz.TZDateTime scheduledFor =
        tz.TZDateTime.from(dtb.add(const Duration(minutes: 1)), tz.local);
    // represent the time when the user created or scheduled the task
    final tz.TZDateTime scheduledAt = tz.TZDateTime.local(dateTime.year,
        dateTime.month, dateTime.day, dateTime.hour, dateTime.minute);
    // print("date and time are:-" + dateTime.toString());
    print("dtb is :-$scheduledFor");
    print("date and time are scheduled2:-$scheduledAt");

    AndroidNotificationDetails androidNotificationDetails =
        const AndroidNotificationDetails('channelId', 'TaskReminder',
            icon: "taskwarrior",
            importance: Importance.max,
            priority: Priority.max);

    NotificationDetails notificationDetails =
        NotificationDetails(android: androidNotificationDetails);

    _flutterLocalNotificationsPlugin.zonedSchedule(
        scheduledFor.day * 100 + scheduledFor.hour * 10 + scheduledFor.minute,
        'Task Warrior Reminder',
        'Hi there! Just a friendly reminder that your task "$task" is still pending. Would you like to complete it now?',
        scheduledFor,
        notificationDetails,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        androidAllowWhileIdle: true);
    print(
        scheduledFor.day * 100 + scheduledFor.hour * 10 + scheduledFor.minute);
  }
}
