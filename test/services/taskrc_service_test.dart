import 'package:flutter_test/flutter_test.dart';
import 'package:taskwarrior/app/models/report.dart';
import 'package:taskwarrior/app/services/taskrc_service.dart';
import 'package:taskwarrior/app/utils/taskchampion/taskrc_parser.dart';
import 'package:taskwarrior/app/utils/taskchampion/virtual_filter_engine.dart';

ReportDefinition report({
  String name = 'mine',
  String description = 'My report',
  String? filter = 'status:pending +READY',
  String sort = 'urgency-',
  String columns = 'id,description',
}) =>
    ReportDefinition(
      name: name,
      description: description,
      filterExpression: filter,
      sortCriteria: SortCriterion.parseList(sort),
      columns: ColumnSpec.parseList(columns),
      isCustom: true,
    );

void main() {
  group('report name validation', () {
    test('accepts names Taskwarrior can address', () {
      for (final String ok in ['mine', 'work-today', 'a_b', 'r2']) {
        expect(TaskrcService.validateName(ok), isNull, reason: ok);
      }
    });

    test('rejects names that would produce an unreadable key', () {
      // `report.<name>.sort` is parsed by splitting on dots, so a dotted or
      // spaced name yields a key that can never be read back.
      for (final String bad in ['', '   ', 'my.report', 'my report', 'a=b']) {
        expect(TaskrcService.validateName(bad), isNotNull,
            reason: 'should reject "$bad"');
      }
    });
  });

  group('writing a report into .taskrc', () {
    test('round-trips through the parser', () {
      final String content = TaskrcService.mergeReport('', report());
      final List<ReportDefinition> parsed =
          (TaskrcParser()..parse(content)).customReports();

      expect(parsed, hasLength(1));
      final ReportDefinition r = parsed.single;
      expect(r.name, 'mine');
      expect(r.description, 'My report');
      expect(r.filterExpression, 'status:pending +READY');
      expect(r.sortCriteria.single.field, 'urgency');
      expect(r.sortCriteria.single.ascending, isFalse);
      expect(r.columns.map((c) => c.field), ['id', 'description']);
    });

    test('always writes a sort key, since that is what marks a report', () {
      // TaskrcParser only recognises a block that has `.sort`; omitting it
      // would silently produce a report that never appears again.
      final String content = TaskrcService.mergeReport(
          '', report(sort: ''));
      expect(content, contains('report.mine.sort='));
      expect((TaskrcParser()..parse(content)).customReports(), hasLength(1));
    });

    test('omits the filter line when there is no filter', () {
      final String content =
          TaskrcService.mergeReport('', report(filter: null));
      expect(content, isNot(contains('report.mine.filter')));
      expect((TaskrcParser()..parse(content)).customReports().single
          .filterExpression, isNull);
    });

    test('preserves everything the user wrote by hand', () {
      const String existing = '''
# my own settings
data.location=/somewhere
report.other.sort=due+
report.other.description=Someone else's report
''';
      final String content = TaskrcService.mergeReport(existing, report());

      expect(content, contains('# my own settings'));
      expect(content, contains('data.location=/somewhere'));
      expect(content, contains('report.other.sort=due+'));
      expect(content, contains('report.mine.sort=urgency-'));

      // and both reports are still readable
      final names = (TaskrcParser()..parse(content))
          .customReports()
          .map((r) => r.name)
          .toSet();
      expect(names, {'other', 'mine'});
    });

    test('replaces the same report instead of duplicating it', () {
      String content = TaskrcService.mergeReport('', report());
      content = TaskrcService.mergeReport(
          content, report(description: 'Updated', filter: '+OVERDUE'));

      expect('report.mine.sort='.allMatches(content).length, 1,
          reason: 'saving twice must not leave two blocks');
      final ReportDefinition r =
          (TaskrcParser()..parse(content)).customReports().single;
      expect(r.description, 'Updated');
      expect(r.filterExpression, '+OVERDUE');
    });

    test('repeated saves do not accumulate blank lines', () {
      String content = TaskrcService.mergeReport('', report());
      for (int i = 0; i < 5; i++) {
        content = TaskrcService.mergeReport(content, report());
      }
      expect(content, isNot(contains('\n\n\n')));
    });

    test('a name that cannot be addressed is refused, not written', () {
      expect(() => TaskrcService.mergeReport('', report(name: 'bad.name')),
          throwsArgumentError);
    });
  });

  group('deleting a report', () {
    test('removes only the named report', () {
      String content = TaskrcService.mergeReport('', report(name: 'keep'));
      content = TaskrcService.mergeReport(content, report(name: 'drop'));

      final String after = TaskrcService.removeReport(content, 'drop');
      final names = (TaskrcParser()..parse(after))
          .customReports()
          .map((r) => r.name)
          .toSet();
      expect(names, {'keep'});
    });

    test('leaves unrelated settings and comments intact', () {
      const String existing = '# keep me\ndata.location=/x\n';
      final String content = TaskrcService.mergeReport(existing, report());
      final String after = TaskrcService.removeReport(content, 'mine');

      expect(after, contains('# keep me'));
      expect(after, contains('data.location=/x'));
      expect(after, isNot(contains('report.mine')));
    });

    test('deleting something that is not there changes nothing', () {
      final String content = TaskrcService.mergeReport('', report());
      expect(TaskrcService.removeReport(content, 'absent').trim(),
          content.trim());
    });
  });

  group('filter validation', () {
    test('accepts the documented vocabulary', () {
      expect(VirtualFilterEngine.validate('status:pending +READY'), isEmpty);
      expect(VirtualFilterEngine.validate('project:work priority:H'), isEmpty);
      expect(VirtualFilterEngine.validate(null), isEmpty);
      expect(VirtualFilterEngine.validate('   '), isEmpty);
    });

    test('bare words and tags are never errors', () {
      // A bare word searches the description and +anything is a user tag, so
      // neither can be a mistake — only an unknown attribute can.
      expect(VirtualFilterEngine.validate('groceries +home -ACTIVE'), isEmpty);
    });

    test('catches an attribute typo, which would otherwise match everything',
        () {
      final List<String> issues =
          VirtualFilterEngine.validate('statuss:pending');
      expect(issues, hasLength(1));
      expect(issues.single, contains('matches every task'));
    });

    test('catches an attribute with no value', () {
      expect(VirtualFilterEngine.validate('status:'), hasLength(1));
    });
  });
}
