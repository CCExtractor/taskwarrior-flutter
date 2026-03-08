// ignore_for_file: depend_on_referenced_packages

import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:intl/intl.dart';
import 'package:taskwarrior/app/utils/app_settings/app_settings.dart';

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

  DarwinInitializationSettings macSettings = const DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestCriticalPermission: true,
      requestSoundPermission: true);
  void initiliazeNotification() async {
    InitializationSettings initializationSettings = InitializationSettings(
      android: _androidInitializationSettings,
      iOS: iosSettings,
      macOS: macSettings,
    );

    await _flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  // Function to create a unique notification ID
  int calculateNotificationId(DateTime scheduledTime, String taskname,
      bool isWait, DateTime entryTime) {
    String combinedString =
        '${entryTime.toIso8601String().substring(0, 19)}$taskname';

    // Calculate SHA-256 hash
    var sha2561 = sha256.convert(utf8.encode(combinedString));

    // Convert the first 8 characters of the hash to an integer
    int notificationId =
        int.parse(sha2561.toString().substring(0, 8), radix: 16) % 2147483647;
    if (isWait) {
      notificationId = (notificationId + 2) % 2147483647;
    }

    return notificationId;
  }

  // Helper method to format date time based on user preferences
  String getFormattedDateTime(DateTime dateTime) {
    String timeFormat = AppSettings.use24HourFormatRx.value
        ? 'yyyy-MM-dd HH:mm:ss'
        : 'yyyy-MM-dd hh:mm:ss a';
    return DateFormat(timeFormat).format(dateTime);
  }

  void sendNotification(
      DateTime dtb, String taskname, bool isWait, DateTime entryTime) async {
    DateTime dateTime = DateTime.now();
    tz.initializeTimeZones();
    if (kDebugMode) {
      print("date and time are:-$dateTime");
      print("date and time are:-${getFormattedDateTime(dtb)}");
    }
    final tz.TZDateTime scheduledAt =
        tz.TZDateTime.from(dtb.add(const Duration(minutes: 0)), tz.local);

    AndroidNotificationDetails androidNotificationDetails =
        const AndroidNotificationDetails('channelId', 'TaskReminder',
            icon: "taskwarrior",
            importance: Importance.max,
            priority: Priority.max);

    // iOS and macOS Notification Details
    DarwinNotificationDetails iOSNotificationDetails =
        const DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    DarwinNotificationDetails macOsNotificationDetails =
        const DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
      iOS: iOSNotificationDetails,
      macOS: macOsNotificationDetails,
    );

    // Generate a unique notification ID based on the scheduled time and task name
    int notificationId =
        calculateNotificationId(dtb, taskname, isWait, entryTime);

    await _flutterLocalNotificationsPlugin
        .zonedSchedule(
            notificationId,
            'Taskwarrior Reminder',
            isWait
                ? "Hey! Don't forget your task of $taskname"
                : 'Hey! Your task of $taskname is still pending',
            scheduledAt,
            notificationDetails,
            uiLocalNotificationDateInterpretation:
                UILocalNotificationDateInterpretation.absoluteTime,
            androidScheduleMode: AndroidScheduleMode.alarmClock)
        .then((value) {
      if (kDebugMode) {
        print('Notification scheduled successfully');
      }
    }).catchError((error) {
      if (kDebugMode) {
        print('Error scheduling notification: $error');
      }
    });

    if (kDebugMode) {
      print(scheduledAt.day * 100 + scheduledAt.hour * 10 + scheduledAt.minute);
    }
  }

  // Delete previously scheduled notification with a specific ID
  void cancelNotification(int notificationId) async {
    await _flutterLocalNotificationsPlugin.cancel(notificationId);
  }

  /// Schedule an advance-warning notification 24 hours before [due] for a
  /// recurring task.  Uses an ID offset of +4 over the base due-notification
  /// ID so it never collides with the due (+0) or wait (+2) notifications.
  void sendRecurrenceAdvanceNotification(
      DateTime due, String taskname, DateTime entryTime) async {
    final advanceTime = due.subtract(const Duration(hours: 24));
    if (advanceTime.isBefore(DateTime.now().toUtc())) return;

    tz.initializeTimeZones();
    final tz.TZDateTime scheduledAt = tz.TZDateTime.from(advanceTime, tz.local);

    final int baseId = calculateNotificationId(due, taskname, false, entryTime);
    final int notificationId = (baseId + 4) % 2147483647;

    AndroidNotificationDetails androidDetails =
        const AndroidNotificationDetails('channelId', 'TaskReminder',
            icon: "taskwarrior",
            importance: Importance.max,
            priority: Priority.max);

    DarwinNotificationDetails iosDetails = const DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    DarwinNotificationDetails macDetails = const DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    NotificationDetails notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
      macOS: macDetails,
    );

    await _flutterLocalNotificationsPlugin
        .zonedSchedule(
            notificationId,
            'Taskwarrior Reminder',
            "Hey! Your recurring task '$taskname' is due tomorrow",
            scheduledAt,
            notificationDetails,
            uiLocalNotificationDateInterpretation:
                UILocalNotificationDateInterpretation.absoluteTime,
            androidScheduleMode: AndroidScheduleMode.alarmClock)
        .then((_) {
      if (kDebugMode) {
        print('Advance-warning notification scheduled for $taskname');
      }
    }).catchError((error) {
      if (kDebugMode) {
        print('Error scheduling advance-warning notification: $error');
      }
    });
  }

  /// Cancel the advance-warning notification previously scheduled for a
  /// recurring task identified by [due] + [taskname] + [entryTime].
  void cancelRecurrenceAdvanceNotification(
      DateTime due, String taskname, DateTime entryTime) {
    final int baseId = calculateNotificationId(due, taskname, false, entryTime);
    final int notificationId = (baseId + 4) % 2147483647;
    cancelNotification(notificationId);
  }
}
