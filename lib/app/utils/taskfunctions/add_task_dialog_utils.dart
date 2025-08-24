import 'package:intl/intl.dart';
import 'package:taskwarrior/app/utils/app_settings/app_settings.dart';
import 'package:taskwarrior/app/utils/language/sentence_manager.dart';

String dateToStringForAddTask(DateTime dt) {
  return 'On ${DateFormat('yyyy-MM-dd').format(dt)} at ${DateFormat('hh:mm:ss').format(dt)}';
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
