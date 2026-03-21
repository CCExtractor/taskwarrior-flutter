/// Parses a taskrc file into a Dart [Map].
///
/// Uses first-occurrence split on '=' to correctly handle values
/// containing '=' characters (e.g. base64-encoded certificates).
Map<String, String> parseTaskrc(String contents) {
  final map = <String, String>{};
  for (var line in contents.split('\n')) {
    line = line.trim();
    if (line.isEmpty || line.startsWith('#')) continue;
    final index = line.indexOf('=');
    if (index == -1) continue;
    final key = line.substring(0, index).trim();
    // ignore: use_raw_strings
    final value = line.substring(index + 1).trim().replaceAll('\\/', '/');
    map[key] = value;
  }
  return map;
}
