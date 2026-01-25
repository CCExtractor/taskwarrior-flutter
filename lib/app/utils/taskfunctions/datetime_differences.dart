import 'package:intl/intl.dart';
import 'package:taskwarrior/app/utils/app_settings/app_settings.dart';

String age(DateTime dt, {bool? use24HourFormat}) {
  final format = AppSettings.use24HourFormatRx.value;

  String result;
  var days = DateTime.now().difference(dt).abs().inDays;
  if (days > 365) {
    result =
        '${(days / 365).toStringAsFixed(1).replaceFirst(RegExp(r'\.0$'), '')}y';
  } else if (days > 30) {
    result = '${days ~/ 30}mo';
  } else if (days > 7) {
    result = '${days ~/ 7}w';
  } else if (days > 0) {
    result = '${days}d';
  } else if (DateTime.now().difference(dt).abs().inHours > 0) {
    result = '${DateTime.now().difference(dt).abs().inHours}h';
  } else if (DateTime.now().difference(dt).abs().inMinutes > 0) {
    result = '${DateTime.now().difference(dt).abs().inMinutes}min';
  } else {
    result = '${DateTime.now().difference(dt).abs().inSeconds}s';
  }

  // Format the time part according to the format preference
  String timeFormat = format ? 'HH:mm' : 'hh:mm a';
  String formattedTime = DateFormat(timeFormat).format(dt);

  return '$result ago ($formattedTime)';
}

String when(DateTime dt, {bool? use24HourFormat}) {
  final format = AppSettings.use24HourFormatRx.value;

  String result;
  var days = dt.difference(DateTime.now()).abs().inDays;
  if (days > 365) {
    result =
        '${(days / 365).toStringAsFixed(1).replaceFirst(RegExp(r'\.0$'), '')}y';
  } else if (days > 30) {
    result = '${days ~/ 30}mo';
  } else if (days > 7) {
    result = '${days ~/ 7}w';
  } else if (days > 0) {
    result = '${days}d';
  } else if (dt.difference(DateTime.now()).abs().inHours > 0) {
    result = '${dt.difference(DateTime.now()).abs().inHours}h';
  } else if (dt.difference(DateTime.now()).abs().inMinutes > 0) {
    result = '${dt.difference(DateTime.now()).abs().inMinutes}min';
  } else {
    result = '${dt.difference(DateTime.now()).abs().inSeconds}s';
  }

  // Format the time part according to the format preference
  String timeFormat = format ? 'HH:mm' : 'hh:mm a';
  String formattedTime = DateFormat(timeFormat).format(dt);

  return '$result ($formattedTime)';
}
