import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:taskwarrior/app/utils/taskchampion/credentials_storage.dart';
import 'package:taskwarrior/app/v3/db/task_database.dart';

// NEW IMPORTS FOR NOTIFICATIONS
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import '../../services/notification_service.dart';  // You will create this file later
import '../../settings/app_settings.dart';          // We will update this file later

Future<void> addTaskAndDeleteFromDatabase(
    String description,
    String project,
    String due,
    String priority,
    List<dynamic> tags,
    ) async {

  // -----------------------------
  // 1️⃣ Send Task to API (your original code)
  // -----------------------------

  var baseUrl = await CredentialsStorage.getApiUrl();
  String apiUrl = '$baseUrl/add-task';

  var c = await CredentialsStorage.getClientId();
  var e = await CredentialsStorage.getEncryptionSecret();

  debugPrint("Database Adding Tags $tags $description");
  debugPrint(c);
  debugPrint(e);

  var res = await http.post(
    Uri.parse(apiUrl),
    headers: {
      'Content-Type': 'text/plain',
    },
    body: jsonEncode({
      'email': 'email',
      'encryptionSecret': e,
      'UUID': c,
      'description': description,
      'project': project,
      'due': due,
      'priority': priority,
      'tags': tags
    }),
  );

  debugPrint('Database res  ${res.body}');

  var taskDatabase = TaskDatabase();
  await taskDatabase.open();

  await taskDatabase.deleteTask(
      description: description,
      due: due,
      project: project,
      priority: priority);

  // -----------------------------
  // 2️⃣ Schedule 15-Minute Reminder (NEW)
  // -----------------------------

  // First, check if the user enabled reminders in settings
  final settings = await AppSettings.load();
  if (settings.enableEarlyReminder == false) {
    debugPrint("Early reminder disabled — skipping notification.");
    return;
  }

  // Parse the due date into a DateTime
  DateTime? dueDate;
  try {
    dueDate = DateTime.parse(due);   // expects "2025-02-20T18:00:00Z"
  } catch (e) {
    debugPrint("Invalid due date format, cannot schedule reminder.");
    return;
  }

  // Calculate the 15-minute earlier reminder time
  final reminderTime = dueDate.subtract(const Duration(minutes: 15));

  if (reminderTime.isBefore(DateTime.now())) {
    debugPrint("Reminder time is in the past — skipping.");
    return;
  }

  // Use Notification Service
  final NotificationService notifier =
  NotificationService(FlutterLocalNotificationsPlugin());

  await notifier.scheduleTaskReminder(
    taskId: dueDate.millisecondsSinceEpoch ~/ 1000, // unique ID
    title: description,
    dueDate: dueDate,
  );

  debugPrint("Reminder scheduled for: $reminderTime");
}
