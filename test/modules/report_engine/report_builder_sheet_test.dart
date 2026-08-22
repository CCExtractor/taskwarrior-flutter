import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:taskwarrior/app/models/report.dart';
import 'package:taskwarrior/app/modules/report_engine/controllers/report_engine_controller.dart';
import 'package:taskwarrior/app/modules/report_engine/views/report_builder_sheet.dart';
import 'package:taskwarrior/app/utils/themes/dark_theme.dart';

/// The filter chips insert tokens into the expression. Tokens AND together,
/// so a duplicate is never meaningful: a repeated virtual tag is noise and a
/// second `attr:` token can only contradict the first. These pin the rule that
/// a chip whose token is already present is disabled and inserts nothing —
/// whether the token came from a chip tap, a hand-edit, or the report being
/// edited.
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    Get.testMode = true;
    Get.put(ReportEngineController());
  });

  tearDown(Get.reset);

  Future<void> pump(WidgetTester tester, {ReportDefinition? existing}) async {
    await tester.pumpWidget(
      GetMaterialApp(
        theme: darkTheme,
        home: Scaffold(
          body: SingleChildScrollView(
            child: ReportBuilderSheet(
              controller: Get.find<ReportEngineController>(),
              existing: existing,
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  String filterText(WidgetTester tester) {
    final EditableText field = tester.widget<EditableText>(
      find.descendant(
        of: find.byType(TextField),
        matching: find.byType(EditableText),
      ).at(2), // name, description, filter
    );
    return field.controller.text;
  }

  // Scoped to chips: once a token is inserted, the filter field renders the
  // same string, so a bare find.text() would match both.
  Finder chipFinder(String label) => find.descendant(
        of: find.byType(ActionChip),
        matching: find.text(label),
      );

  ActionChip chip(WidgetTester tester, String label) =>
      tester.widget<ActionChip>(find.ancestor(
        of: chipFinder(label),
        matching: find.byType(ActionChip),
      ));

  testWidgets('tapping the same virtual-tag chip twice inserts one token',
      (tester) async {
    await pump(tester);

    await tester.tap(chipFinder('+ACTIVE'));
    await tester.pumpAndSettle();
    expect(filterText(tester), '+ACTIVE');
    // The chip is disabled now, but tap anyway (warnIfMissed off) to prove a
    // second activation could not double the token even if it got through.
    await tester.tap(chipFinder('+ACTIVE'), warnIfMissed: false);
    await tester.pumpAndSettle();

    expect(filterText(tester), '+ACTIVE');
    expect(chip(tester, '+ACTIVE').onPressed, isNull,
        reason: 'a chip whose token is present must be disabled');
    expect(chip(tester, '+READY').onPressed, isNotNull,
        reason: 'other chips stay tappable');
  });

  testWidgets('an attribute chip is disabled once any attr: token exists',
      (tester) async {
    await pump(tester);

    await tester.tap(chipFinder('status:'));
    await tester.pumpAndSettle();
    expect(filterText(tester), 'status:');
    // A second status: filter can only contradict the first.
    expect(chip(tester, 'status:').onPressed, isNull);
    expect(chip(tester, 'project:').onPressed, isNotNull);
  });

  testWidgets('a hand-typed token disables its chip, case-insensitively',
      (tester) async {
    await pump(tester);

    await tester.enterText(
        find.byType(TextField).at(2), 'status:pending +active');
    await tester.pumpAndSettle();

    expect(chip(tester, '+ACTIVE').onPressed, isNull,
        reason: 'the engine treats +active and +ACTIVE as the same filter');
    expect(chip(tester, 'status:').onPressed, isNull);
    expect(chip(tester, '+READY').onPressed, isNotNull);
  });

  testWidgets('creating a report under a taken custom name is refused',
      (tester) async {
    final ReportEngineController controller =
        Get.find<ReportEngineController>();
    controller.reports.assignAll([
      ReportDefinition(
        name: 'mine',
        description: 'mine',
        filterExpression: '+OVERDUE',
        sortCriteria: SortCriterion.parseList('due+'),
        columns: ColumnSpec.parseList('id,description'),
        isCustom: true,
      ),
    ]);
    await pump(tester);

    await tester.enterText(find.byType(TextField).at(0), 'mine');
    await tester.pumpAndSettle();
    await tester.tap(find.text('Create'));
    await tester.pumpAndSettle();

    // Refused with an explanation instead of silently replacing the stored
    // report (mergeReport clobbers same-name blocks).
    expect(find.textContaining('already exists'), findsOneWidget);
  });

  testWidgets('re-saving an edited report under its own name is not refused',
      (tester) async {
    final ReportDefinition mine = ReportDefinition(
      name: 'mine',
      description: 'mine',
      filterExpression: '+OVERDUE',
      sortCriteria: SortCriterion.parseList('due+'),
      columns: ColumnSpec.parseList('id,description'),
      isCustom: true,
    );
    final ReportEngineController controller =
        Get.find<ReportEngineController>();
    controller.reports.assignAll([mine]);
    await pump(tester, existing: mine);

    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    // Its own name is the normal update path, not a clobber. (The actual file
    // write fails in the test environment; the point is which error we get.)
    expect(find.textContaining('already exists'), findsNothing);
  });

  testWidgets('editing an existing report opens with its tokens disabled',
      (tester) async {
    await pump(
      tester,
      existing: ReportDefinition(
        name: 'my-overdue',
        description: 'my-overdue',
        filterExpression: '+OVERDUE',
        sortCriteria: SortCriterion.parseList('due+'),
        columns: ColumnSpec.parseList('id,description'),
        isCustom: true,
      ),
    );

    expect(filterText(tester), '+OVERDUE');
    expect(chip(tester, '+OVERDUE').onPressed, isNull);
    expect(chip(tester, '+ACTIVE').onPressed, isNotNull);
  });
}
