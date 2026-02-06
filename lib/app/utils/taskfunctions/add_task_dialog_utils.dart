import 'package:intl/intl.dart';
import 'package:taskwarrior/app/utils/app_settings/app_settings.dart';
import 'package:taskwarrior/app/utils/language/sentence_manager.dart';

String dateToStringForAddTask(DateTime dt) {
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final tomorrow = today.add(const Duration(days: 1));
  final dtDate = DateTime(dt.year, dt.month, dt.day);

  // Format time in 12-hour format with AM/PM
  final timeFormat = DateFormat('h:mm a');
  final timeString = timeFormat.format(dt);

  // Check if date is today or tomorrow
  if (dtDate == today) {
    return 'Today • $timeString';
  } else if (dtDate == tomorrow) {
    return 'Tomorrow • $timeString';
  } else {
    // Format: "Feb 28 • 7:50 AM"
    final dateFormat = DateFormat('MMM d');
    final dateString = dateFormat.format(dt);
    return '$dateString • $timeString';
  }
}

String getPriorityText(String priority) {
  switch (priority) {
    case 'H':
      return SentenceManager(currentLanguage: AppSettings.selectedLanguage)
          .sentences
          .high;
    case 'M':
      return SentenceManager(currentLanguage: AppSettings.selectedLanguage)
          .sentences
          .medium;
    case 'L':
      return SentenceManager(currentLanguage: AppSettings.selectedLanguage)
          .sentences
          .low;
    default:
      return 'None';
  }
}

DateTime? getDueDate(List<DateTime?> dates) {
  return dates[0];
}

DateTime? getWaitDate(List<DateTime?> dates) {
  return dates[1];
}

DateTime? getSchedDate(List<DateTime?> dates) {
  return dates[2];
}

DateTime? getUntilDate(List<DateTime?> dates) {
  return dates[3];
}
