/// Parses a taskrc file into a Dart [Map].
/// Splits each line on the first '=' only, preserving values that
/// contain '=' characters (e.g. base64-encoded certificates, taskd
/// parameters with padding).
Map<String, String> parseTaskrc(String contents) {
  final result = <String, String>{};
  for (var line in contents
      .split('\n')
      .where((line) => line.contains('=') && line[0] != '#')
      .map((line) => line.replaceAll('\\/', '/'))) { // ignore: use_raw_strings
    final sep = line.indexOf('=');
    result[line.substring(0, sep).trim()] = line.substring(sep + 1).trim();
  }
  return result;
}