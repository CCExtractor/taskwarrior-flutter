import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import 'package:flutter_native_timezone/flutter_native_timezone.dart';

class NotificationService {
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();
  final AndroidInitializationSettings _androidInitializationSettings =
  AndroidInitializationSettings('splash.png');

  void initiliazeNotification() async {
    InitializationSettings initializationSettings =
    InitializationSettings(android: _androidInitializationSettings);

    await _flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  void sendNotification(DateTime dtb, String task) async {
    DateTime dateTime = DateTime.now();
    tz.initializeTimeZones();
    print("date and time are:-" + dateTime.toString());
    print("date and time are:-" + dtb.toString());

    final tz.TZDateTime scheduledAt =
    tz.TZDateTime.from(dtb.add(Duration(minutes: 1)), tz.local);
    final tz.TZDateTime scheduledAt1 = tz.TZDateTime.local(dateTime.year,
        dateTime.month, dateTime.day, dateTime.hour, dateTime.minute);
    // print("date and time are:-" + dateTime.toString());
    print("dtb is :-" + scheduledAt.toString());
    print("date and time are scheduled2:-" + scheduledAt1.toString());

    AndroidNotificationDetails androidNotificationDetails =
    AndroidNotificationDetails('channelId', 'TaskReminder',
        importance: Importance.max, priority: Priority.max);

    NotificationDetails notificationDetails =
    NotificationDetails(android: androidNotificationDetails);

    _flutterLocalNotificationsPlugin.zonedSchedule(
        scheduledAt.day * 100 + scheduledAt.hour * 10 + scheduledAt.minute,
        'Task Warrior Reminder',
        'Hey! Your task of ' + task + ' is still pending',
        scheduledAt,
        notificationDetails,
        uiLocalNotificationDateInterpretation:
        UILocalNotificationDateInterpretation.absoluteTime,
        androidAllowWhileIdle: true);
    print(scheduledAt.day * 100 + scheduledAt.hour * 10 + scheduledAt.minute);
  }
}
