/// Parses a taskrc file into a Dart [Map].
/// Splits each line on the first '=' only, preserving values that
/// contain '=' characters (e.g. base64-encoded certificates, taskd
/// parameters with padding).
Map<String, String> parseTaskrc(String contents) => {
      for (var line in contents
          .split('\n')
          .where((line) => line.contains('=') && line[0] != '#')
          .map((line) => line.replaceAll('\\/', '/'))) // ignore: use_raw_strings
        line.substring(0, line.indexOf('=')).trim():
            line.substring(line.indexOf('=') + 1).trim(),
    };