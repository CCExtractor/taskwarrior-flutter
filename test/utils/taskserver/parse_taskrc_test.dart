import 'package:flutter_test/flutter_test.dart';
import 'package:taskwarrior/app/utils/taskserver/parse_taskrc.dart';

void main() {
  group('parseTaskrc', () {
    test('parses a taskrc file correctly', () {
      const contents = '''
# This is a comment
key1=value1
key2 = value2
key3=value3
# Another comment
key4 = value4
''';
      final result = parseTaskrc(contents);

      expect(result, {
        'key1': 'value1',
        'key2': 'value2',
        'key3': 'value3',
        'key4': 'value4',
      });
    });

    test('ignores comments and empty lines', () {
      const contents = '''
# This is a comment
key1=value1

key2 = value2
# Another comment
''';
      final result = parseTaskrc(contents);

      expect(result, {
        'key1': 'value1',
        'key2': 'value2',
      });
    });

    test('handles lines with escaped slashes correctly', () {
      const contents = '''
key1=value\\/1
key2 = value\\/2
''';
      final result = parseTaskrc(contents);

      expect(result, {
        'key1': 'value/1',
        'key2': 'value/2',
      });
    });

    test('trims keys and values', () {
      const contents = '''
key1 = value1
 key2= value2 
key3 =value3 
''';
      final result = parseTaskrc(contents);

      expect(result, {
        'key1': 'value1',
        'key2': 'value2',
        'key3': 'value3',
      });
    });

    test('returns empty map for empty input', () {
      const contents = '';
      final result = parseTaskrc(contents);

      expect(result, {});
    });
  });
}
