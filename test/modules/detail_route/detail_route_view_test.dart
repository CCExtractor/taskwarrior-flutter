import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:taskwarrior/app/models/models.dart';
import 'package:taskwarrior/app/models/tag_meta_data.dart';
import 'package:taskwarrior/app/models/task_attribute.dart';
import 'package:taskwarrior/app/modules/detailRoute/controllers/detail_route_controller.dart';
import 'package:taskwarrior/app/modules/detailRoute/views/attribute_widget.dart';
import 'package:taskwarrior/app/modules/detailRoute/views/detail_route_view.dart';
import 'package:taskwarrior/app/modules/detailRoute/views/tags_route.dart';
import 'package:taskwarrior/app/utils/app_settings/app_settings.dart';
import 'package:taskwarrior/app/utils/taskfunctions/modify.dart';
import 'package:taskwarrior/app/utils/themes/theme_extension.dart';

void main() {
  const uuid = 'test-uuid';
  late Task stored;
  late DetailRouteController controller;

  ThemeData theme() => ThemeData(extensions: [
        TaskwarriorColorTheme(
          dialogBackgroundColor: Colors.white,
          primaryBackgroundColor: Colors.white,
          primaryDisabledTextColor: Colors.grey,
          primaryTextColor: Colors.black,
          secondaryBackgroundColor: Colors.grey[200],
          secondaryTextColor: Colors.black54,
          dividerColor: Colors.grey,
          purpleShade: Colors.purple,
          greyShade: Colors.grey,
          icons: Icons.star,
          dimCol: Colors.grey,
        ),
      ]);

  setUp(() async {
    // Mark the tour as seen so it never overlays the page under test.
    SharedPreferences.setMockInitialValues({'details_tour': true});
    await SaveTourStatus.init();
    stored = Task((b) => b
      ..id = 1
      ..uuid = uuid
      ..description = 'Write tests'
      ..status = 'pending'
      ..entry = DateTime.utc(2026, 1, 1));
    controller = DetailRouteController(
      arguments: const ['uuid', uuid],
      createModify: (id) => Modify(
        getTask: (_) => stored,
        mergeTask: (task) => stored = task,
        uuid: id,
      ),
      knownTags: () => {
        'work': TagMetadata(
            lastModified: DateTime(2026), frequency: 3, selected: false)
      },
    );
  });

  tearDown(Get.reset);

  /// Opens the detail page on top of a placeholder home page. The controller
  /// is registered only after the app is mounted: GetX ties it to the current
  /// route, and the previous test's routes are torn down by [pumpWidget].
  Future<void> openDetailPage(WidgetTester tester,
      {DetailRouteController Function()? lazyController}) async {
    await tester.pumpWidget(GetMaterialApp(
      theme: theme(),
      home: const Scaffold(body: Text('home')),
    ));
    if (lazyController != null) {
      // Lazy, like DetailRouteBinding, so onReady runs once the page is built.
      Get.lazyPut(lazyController);
    } else {
      Get.put(controller);
    }
    Get.to(() => const DetailRouteView());
    await tester.pumpAndSettle();
    // Let the tour's start-up delay run out.
    await tester.pump(const Duration(seconds: 1));
  }

  testWidgets('save button appears after an edit and hides on revert',
      (tester) async {
    await openDetailPage(tester);
    expect(find.byType(FloatingActionButton), findsNothing);

    controller.setAttribute(TaskAttribute.description, 'Changed');
    await tester.pump();
    expect(find.byType(FloatingActionButton), findsOneWidget);

    controller.setAttribute(TaskAttribute.description, 'Write tests');
    await tester.pump();
    expect(find.byType(FloatingActionButton), findsNothing);
  });

  testWidgets('completing the task greys out the other cards', (tester) async {
    await openDetailPage(tester);
    AttributeWidget card(TaskAttribute attribute) => tester
        .widgetList<AttributeWidget>(find.byType(AttributeWidget))
        .firstWhere((w) => w.attribute == attribute);
    expect(card(TaskAttribute.description).isEditable, isTrue);

    controller.isReadOnly.value = true;
    await tester.pump();
    expect(card(TaskAttribute.description).isEditable, isFalse);
    expect(card(TaskAttribute.status).isEditable, isTrue);
  });

  testWidgets('dates follow the 24-hour setting live', (tester) async {
    stored =
        stored.rebuild((b) => b..due = DateTime(2026, 5, 4, 15, 30).toUtc());
    AppSettings.use24HourFormatRx.value = false;
    await openDetailPage(tester);
    expect(find.textContaining('03:30:00 PM'), findsOneWidget);

    AppSettings.use24HourFormatRx.value = true;
    await tester.pump();
    expect(find.textContaining('15:30:00'), findsOneWidget);
    AppSettings.use24HourFormatRx.value = false;
  });

  testWidgets('submitting the review dialog saves and closes the page',
      (tester) async {
    await openDetailPage(tester);
    controller.setAttribute(TaskAttribute.description, 'Changed');
    await tester.pump();

    await tester.tap(find.byType(FloatingActionButton));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Submit'));
    await tester.pumpAndSettle();

    expect(stored.description, 'Changed');
    expect(find.byType(DetailRouteView), findsNothing);
    expect(find.text('home'), findsOneWidget);
    expect(find.text('Task Updated'), findsOneWidget);
  });

  testWidgets('a task that fails to load closes the page', (tester) async {
    await openDetailPage(
      tester,
      lazyController: () => DetailRouteController(
        arguments: const ['uuid', uuid],
        createModify: (_) => throw StateError('no such task'),
      ),
    );

    expect(find.byType(DetailRouteView), findsNothing);
    expect(find.text('home'), findsOneWidget);
    expect(find.text('Task not found'), findsOneWidget);
  });

  testWidgets('tags screen adds and removes tags through the controller',
      (tester) async {
    await openDetailPage(tester);
    final tagsCard = find.textContaining('tags:');
    await tester.scrollUntilVisible(
      tagsCard,
      200,
      // Each card also scrolls horizontally; target the page's list.
      scrollable: find
          .descendant(
              of: find.byType(ListView), matching: find.byType(Scrollable))
          .first,
    );
    await tester.ensureVisible(tagsCard);
    await tester.pumpAndSettle();
    await tester.tap(tagsCard);
    await tester.pumpAndSettle();
    expect(find.byType(TagsRoute), findsOneWidget);

    await tester.tap(find.text('work 3'));
    await tester.pump();
    expect(controller.currentTags, ['work']);
    expect(find.text('+work 3'), findsOneWidget);

    await tester.tap(find.text('+work 3'));
    await tester.pump();
    expect(controller.currentTags, isEmpty);
    expect(find.text('work 3'), findsOneWidget);
  });

  testWidgets('dialog buttons use the readable text colour', (tester) async {
    await openDetailPage(tester);
    final tColors = theme().extension<TaskwarriorColorTheme>()!;
    Color? colorOf(String label) =>
        tester.widget<Text>(find.text(label)).style?.color;

    controller.setAttribute(TaskAttribute.description, 'Changed');
    await tester.pump();

    await tester.tap(find.byType(FloatingActionButton));
    await tester.pumpAndSettle();
    for (final label in ['Cancel', 'Submit']) {
      expect(colorOf(label), tColors.primaryTextColor, reason: label);
    }
    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();

    await tester.tap(find.byType(BackButton));
    await tester.pumpAndSettle();
    for (final label in ['Yes', 'No', 'Cancel']) {
      expect(colorOf(label), tColors.primaryTextColor, reason: label);
    }
  });

  testWidgets('every attribute card is styled the same', (tester) async {
    await openDetailPage(tester);
    final tColors = theme().extension<TaskwarriorColorTheme>()!;
    final listView = find.byType(ListView);
    // Scroll through so the lazily built cards (tags is last) get checked.
    for (var i = 0; i < 4; i++) {
      for (final card in tester.widgetList<Card>(
          find.descendant(of: listView, matching: find.byType(Card)))) {
        expect(card.color, tColors.secondaryBackgroundColor);
      }
      for (final tile in tester.widgetList<ListTile>(
          find.descendant(of: listView, matching: find.byType(ListTile)))) {
        expect(tile.tileColor, isNull);
      }
      await tester.drag(listView, const Offset(0, -400));
      await tester.pumpAndSettle();
    }
  });

  testWidgets('back with unsaved edits asks first; cancel stays',
      (tester) async {
    await openDetailPage(tester);
    controller.setAttribute(TaskAttribute.description, 'Changed');
    await tester.pump();

    await tester.tap(find.byType(BackButton));
    await tester.pumpAndSettle();
    expect(find.byType(AlertDialog), findsOneWidget);

    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();
    expect(find.byType(DetailRouteView), findsOneWidget);
    expect(stored.description, 'Write tests');
  });

  testWidgets('back without edits leaves immediately', (tester) async {
    await openDetailPage(tester);
    await tester.tap(find.byType(BackButton));
    await tester.pumpAndSettle();
    expect(find.byType(DetailRouteView), findsNothing);
  });
}
