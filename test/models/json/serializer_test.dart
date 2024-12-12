import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';
import 'package:taskwarrior/app/models/json/serializers.dart';
import 'package:taskwarrior/app/models/json/annotation.dart';
import 'package:taskwarrior/app/models/json/task.dart';

void main() {
  group('Serializers', () {
    test('should correctly serialize and deserialize Annotation', () {
      final annotation = Annotation((b) => b
        ..entry = DateTime.now().toUtc()
        ..description = 'Test description');

      final serialized =
          serializers.serializeWith(Annotation.serializer, annotation);
      final deserialized =
          serializers.deserializeWith(Annotation.serializer, serialized!);

      expect(DateFormat("yyyyMMdd'T'HH").format(deserialized!.entry),
          DateFormat("yyyyMMdd'T'HH").format(annotation.entry));
      expect(deserialized.description, annotation.description);
    });

    test('should correctly serialize and deserialize Task', () {
      final task = Task((b) => b
        ..uuid = '1'
        ..status = 'pending'
        ..description = 'Test Task'
        ..entry = DateTime.now().toUtc());

      final serialized = serializers.serializeWith(Task.serializer, task);
      final deserialized =
          serializers.deserializeWith(Task.serializer, serialized!);

      expect(DateFormat("yyyyMMdd'T'HH").format(deserialized!.entry),
          DateFormat("yyyyMMdd'T'HH").format(task.entry));
      expect(deserialized.uuid, task.uuid);
      expect(deserialized.status, task.status);
      expect(deserialized.description, task.description);
    });
  });
}
