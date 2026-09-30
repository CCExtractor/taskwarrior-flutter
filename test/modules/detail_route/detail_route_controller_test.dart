import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:taskwarrior/app/models/models.dart';
import 'package:taskwarrior/app/models/task_attribute.dart';
import 'package:taskwarrior/app/modules/detailRoute/controllers/detail_route_controller.dart';
import 'package:taskwarrior/app/utils/taskfunctions/modify.dart';

void main() {
  const uuid = 'test-uuid';
  final entry = DateTime.utc(2026, 1, 1, 9);
  late Task stored;

  Task buildTask({String status = 'pending', DateTime? start}) => Task((b) => b
    ..id = 7
    ..uuid = uuid
    ..description = 'Write tests'
    ..status = status
    ..entry = entry
    ..start = start);

  DetailRouteController createController({Object? arguments}) {
    final controller = DetailRouteController(
      arguments: arguments ?? const ['uuid', uuid],
      createModify: (id) => Modify(
        getTask: (_) => stored,
        mergeTask: (task) => stored = task,
        uuid: id,
      ),
      knownTags: () => const {},
    );
    controller.onInit();
    return controller;
  }

  setUp(() {
    Get.testMode = true;
    stored = buildTask();
  });

  group('uuidFromArguments', () {
    test('reads the uuid from ["uuid", <uuid>]', () {
      expect(DetailRouteController.uuidFromArguments(['uuid', 'abc']), 'abc');
    });

    test('rejects missing, short, empty or non-string arguments', () {
      for (final args in [
        null,
        'abc',
        [],
        ['uuid'],
        ['uuid', ''],
        ['uuid', 3]
      ]) {
        expect(DetailRouteController.uuidFromArguments(args), isNull,
            reason: '$args');
      }
    });
  });

  group('loading', () {
    test('loads the task values', () {
      final controller = createController();
      expect(controller.hasTask, isTrue);
      expect(controller.descriptionValue.value, 'Write tests');
      expect(controller.statusValue.value, 'pending');
      expect(controller.isReadOnly.value, isFalse);
      expect(controller.hasPendingChanges.value, isFalse);
    });

    test('invalid arguments leave the page without a task', () {
      final controller = createController(arguments: const ['uuid']);
      expect(controller.hasTask, isFalse);
    });

    test('a task that fails to load leaves the page without a task', () {
      final controller = DetailRouteController(
        arguments: const ['uuid', uuid],
        createModify: (_) => throw StateError('no such task'),
      )..onInit();
      expect(controller.hasTask, isFalse);
    });

    test('completed and deleted tasks open read-only', () {
      for (final status in ['completed', 'deleted']) {
        stored = buildTask(status: status);
        expect(createController().isReadOnly.value, isTrue, reason: status);
      }
    });

    test('hides a start the backend set to the entry time', () {
      stored = buildTask(start: entry);
      expect(createController().startValue.value, isNull);
    });

    test('keeps a real start time', () {
      final start = entry.add(const Duration(hours: 1));
      stored = buildTask(start: start);
      expect(createController().startValue.value, start);
    });
  });

  group('editing', () {
    test('an edit marks the page edited and pending', () {
      final controller = createController();
      controller.setAttribute(TaskAttribute.description, 'Changed');

      expect(controller.descriptionValue.value, 'Changed');
      expect(controller.onEdit.value, isTrue);
      expect(controller.hasPendingChanges.value, isTrue);
      expect(controller.changesSummary, contains('description'));
    });

    test('reverting an edit clears the pending changes', () {
      final controller = createController();
      controller.setAttribute(TaskAttribute.description, 'Changed');
      controller.setAttribute(TaskAttribute.description, 'Write tests');

      expect(controller.hasPendingChanges.value, isFalse);
    });

    test('read-only tasks ignore edits except to status', () {
      stored = buildTask(status: 'completed');
      final controller = createController();

      expect(
          controller.isAttributeEditable(TaskAttribute.description), isFalse);
      expect(controller.isAttributeEditable(TaskAttribute.status), isTrue);

      controller.setAttribute(TaskAttribute.description, 'Changed');
      expect(controller.descriptionValue.value, 'Write tests');
      expect(controller.onEdit.value, isFalse);

      controller.setAttribute(TaskAttribute.status, 'pending');
      expect(controller.isReadOnly.value, isFalse);
    });

    test('completing a task makes it read-only', () {
      final controller = createController();
      controller.setAttribute(TaskAttribute.status, 'completed');
      expect(controller.isReadOnly.value, isTrue);
    });
  });

  group('tags', () {
    test('parseTags splits on commas and drops blanks', () {
      expect(DetailRouteController.parseTags(' a, b ,,c '), ['a', 'b', 'c']);
    });

    test('addTags appends only new tags', () {
      final controller = createController();
      controller.addTags(['a', 'b']);
      controller.addTags(['b', 'c']);
      expect(controller.currentTags, ['a', 'b', 'c']);
      expect(controller.hasPendingChanges.value, isTrue);
    });

    test('removeTag removes it', () {
      final controller = createController();
      controller.addTags(['a', 'b']);
      controller.removeTag('a');
      expect(controller.currentTags, ['b']);
    });

    test('validateTags rejects empty, spaced and duplicate tags', () {
      final controller = createController();
      controller.addTags(['a']);
      final s = controller.sentences;
      expect(controller.validateTags('  '), s.pleaseEnterATag);
      expect(controller.validateTags('x y'), s.tagShouldNotContainSpaces);
      expect(controller.validateTags('b, a'), s.tagAlreadyExists);
      expect(controller.validateTags('b, c'), isNull);
    });
  });

  test('tour keys exist only for the toured attributes', () {
    final controller = createController();
    expect(controller.tourKeyFor(TaskAttribute.due), controller.dueKey);
    expect(controller.tourKeyFor(TaskAttribute.wait), controller.waitKey);
    expect(controller.tourKeyFor(TaskAttribute.until), controller.untilKey);
    expect(
        controller.tourKeyFor(TaskAttribute.priority), controller.priorityKey);
    expect(controller.tourKeyFor(TaskAttribute.description), isNull);
  });

  test('app bar shows "-" for a task without an id', () {
    stored = Task((b) => b
      ..uuid = uuid
      ..description = 'No id'
      ..status = 'pending'
      ..entry = entry);
    expect(createController().appBarTitle, endsWith(': -'));
  });
}
