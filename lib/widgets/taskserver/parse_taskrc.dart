/// Parses a taskrc file into a Dart [Map].
Map<String, String> parseTaskrc(String contents) => {
      for (var pair in contents
          .split('\n')
          .where((line) => line.contains('=') && line[0] != '#')
          .map((line) => line.replaceAll('\\/', '/')) // ignore: use_raw_strings
          .map((line) => line.split('=')))
        pair[0].trim(): pair[1].trim(),
    };
