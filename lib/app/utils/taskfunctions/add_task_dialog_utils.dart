import 'package:intl/intl.dart';

String dateToStringForAddTask(DateTime dt) {
  return 'On ${DateFormat('yyyy-MM-dd').format(dt)} at ${DateFormat('hh:mm:ss').format(dt)}';
}

String getPriorityText(String priority) {
  switch (priority) {
    case 'H':
      return 'High';
    case 'M':
      return 'Medium';
    case 'L':
      return 'Low';
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
