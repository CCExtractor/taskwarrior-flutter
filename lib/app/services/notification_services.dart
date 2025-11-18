// lib/app/services/notification_service.dart
import 'dart:convert';
import 'dart:math';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tzdata;
import 'package:timezone/timezone.dart' as tz;

/// Singleton notification service that wraps flutter_local_notifications
class NotificationService {
  NotificationService._privateConstructor();

  static final NotificationService _instance =
  NotificationService._privateConstructor();

  factory NotificationService() => _instance;

  final FlutterLocalNotificationsPlugin _plugin =
  FlutterLocalNotificationsPlugin();

  bool _initialized = false;

  Future<void> init() async {
    if (_initialized) return;

    // Initialize timezone database
    tzdata.initializeTimeZones();

    const AndroidInitializationSettings androidInit =
    AndroidInitializationSettings('@mipmap/ic_launcher');

    final InitializationSettings initSettings =
    InitializationSettings(android: androidInit);

    await _plugin.initialize(
      initSettings,
      // you can add onSelectNotification callback here if needed
      // onSelectNotification: (payload) async { ... },
    );

    _initialized = true;
  }

  /// Create a stable integer id for a task from its uuid (string).
  /// Ensures same id is produced for same uuid (to cancel/reschedule).
  int _idFromUuid(String? uuid) {
    if (uuid == null || uuid.isEmpty) {
      // fallback random but stable using time
      return DateTime.now().millisecondsSinceEpoch.remainder(1 << 31);
    }
    // simple stable hash (non cryptographic) -> within int range
    var bytes = utf8.encode(uuid);
    int h = 0;
    for (var b in bytes) {
      h = (h * 31 + b) & 0x7fffffff;
    }
    return h;
  }

  /// Schedule a reminder for a task.
  /// dueDate must be in device-local DateTime (not UTC) or converted to tz.local
  Future<void> scheduleTaskReminder({
    required String uuid,
    required String title,
    required DateTime dueDate,
    Duration before = const Duration(minutes: 15),
    String? body,
  }) async {
    await init();

    final reminderTime = dueDate.subtract(before);

    if (reminderTime.isBefore(DateTime.now())) {
      // too late to schedule
      return;
    }

    final tz.TZDateTime scheduled =
    tz.TZDateTime.from(reminderTime, tz.local);

    final id = _idFromUuid(uuid);

    final androidDetails = AndroidNotificationDetails(
      'task_reminder_channel',
      'Task reminders',
      channelDescription: 'Reminders scheduled before task due time',
      importance: Importance.defaultImportance,
      priority: Priority.defaultPriority,
      playSound: false, // silent by default
      enableVibration: false,
      // set additional channel settings if needed
    );

    final notificationDetails = NotificationDetails(android: androidDetails);

    await _plugin.zonedSchedule(
      id,
      title.isNotEmpty ? title : 'Upcoming task',
      body ?? 'A task is due at ${dueDate.toLocal()}',
      scheduled,
      notificationDetails,
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
      UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: null,
    );
  }

  /// Cancel reminder for a task identified by uuid
  Future<void> cancelReminder(String uuid) async {
    await init();
    final id = _idFromUuid(uuid);
    await _plugin.cancel(id);
  }

  /// Cancel all reminders
  Future<void> cancelAllReminders() async {
    await init();
    await _plugin.cancelAll();
  }
}
