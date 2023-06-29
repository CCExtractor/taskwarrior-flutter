import 'package:intl/intl.dart';

class Utils {
  static String getWeekNumber(DateTime? date) {
    int weekNumber =
        ((date!.difference(DateTime(date.year, 1, 1)).inDays) / 7).ceil();
    return weekNumber.toString();
  }

  static int getWeekNumbertoInt(DateTime? date) {
    int weekNumber =
        ((date!.difference(DateTime(date.year, 1, 1)).inDays) / 7).ceil();
    return weekNumber;
  }

  static String formatDate(DateTime date, String pattern) {
    final formatter = DateFormat(pattern);
    return formatter.format(date);
  }

  static String getMonthName(int month) {
    switch (month) {
      case 1:
        return 'January';
      case 2:
        return 'February';
      case 3:
        return 'March';
      case 4:
        return 'April';
      case 5:
        return 'May';
      case 6:
        return 'June';
      case 7:
        return 'July';
      case 8:
        return 'August';
      case 9:
        return 'September';
      case 10:
        return 'October';
      case 11:
        return 'November';
      case 12:
        return 'December';
      default:
        return '';
    }
  }
}
