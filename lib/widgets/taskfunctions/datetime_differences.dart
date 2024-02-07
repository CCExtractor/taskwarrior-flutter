String age(DateTime dt) => difference(DateTime.now().difference(dt));

String when(DateTime dt) => difference(dt.difference(DateTime.now()));

String difference(Duration difference) {
  String result;
  var days = difference.abs().inDays;
  if (days > 365) {
    result =
        '${(days / 365).toStringAsFixed(1).replaceFirst(RegExp(r'\.0$'), '')}y';
  } else if (days > 30) {
    result = '${days ~/ 30}mo';
  } else if (days > 7) {
    result = '${days ~/ 7}w';
  } else if (days > 0) {
    result = '${days}d';
  } else if (difference.abs().inHours > 0) {
    result = '${difference.abs().inHours}h';
  } else if (difference.abs().inMinutes > 0) {
    result = '${difference.abs().inMinutes}min';
  } else {
    result = '${difference.abs().inSeconds}s';
  }
  if (difference.isNegative) {
    result = '0s';
  }
  return result;
}
