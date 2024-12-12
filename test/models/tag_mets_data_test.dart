import 'package:flutter_test/flutter_test.dart';
import 'package:taskwarrior/app/models/tag_meta_data.dart';

void main() {
  group('TagMetadata', () {
    late TagMetadata tagMetadata;
    late DateTime lastModified;
    late int frequency;
    late bool selected;

    setUp(() {
      lastModified = DateTime.now();
      frequency = 5;
      selected = true;

      tagMetadata = TagMetadata(
        lastModified: lastModified,
        frequency: frequency,
        selected: selected,
      );
    });

    test('should correctly initialize with given parameters', () {
      expect(tagMetadata.lastModified, lastModified);
      expect(tagMetadata.frequency, frequency);
      expect(tagMetadata.selected, selected);
    });

    test('should correctly convert to JSON', () {
      final json = tagMetadata.toJson();
      expect(json['lastModified'], lastModified);
      expect(json['frequency'], frequency);
      expect(json['selected'], selected);
    });

    test('should correctly convert to string', () {
      final string = tagMetadata.toString();
      expect(string, tagMetadata.toJson().toString());
    });
  });
}
