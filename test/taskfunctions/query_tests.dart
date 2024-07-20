import 'dart:io';
import 'package:taskwarrior/app/utils/taskfunctions/query.dart';
import 'package:test/test.dart';

void main() {
  late Directory tempDir;
  late Query query;

  setUp(() {
    tempDir = Directory.systemTemp.createTempSync('query_test');
    query = Query(tempDir);
  });

  tearDown(() {
    tempDir.deleteSync(recursive: true);
  });

  test('setSelectedSort and getSelectedSort', () {
    const selectedSort = 'priority-';
    query.setSelectedSort(selectedSort);
    expect(query.getSelectedSort(), selectedSort);
  });

  test('togglePendingFilter and getPendingFilter', () {
    expect(query.getPendingFilter(), true);
    query.togglePendingFilter();
    expect(query.getPendingFilter(), false);
    query.togglePendingFilter();
    expect(query.getPendingFilter(), true);
  });

  test('toggleWaitingFilter and getWaitingFilter', () {
    expect(query.getWaitingFilter(), true);
    query.toggleWaitingFilter();
    expect(query.getWaitingFilter(), false);
    query.toggleWaitingFilter();
    expect(query.getWaitingFilter(), true);
  });

  test('toggleProjectFilter and projectFilter', () {
    const project = 'Work';
    query.toggleProjectFilter(project);
    expect(query.projectFilter(), project);
    query.toggleProjectFilter(project);
    expect(query.projectFilter(), '');
  });

  test('toggleTagUnion and tagUnion', () {
    expect(query.tagUnion(), false);
    query.toggleTagUnion();
    expect(query.tagUnion(), true);
    query.toggleTagUnion();
    expect(query.tagUnion(), false);
  });

  test('toggleTagFilter and getSelectedTags', () {
    const tag1 = 'important';
    const tag2 = 'urgent';

    query.toggleTagFilter(tag1);
    var tags = query.getSelectedTags();
    expect(tags.contains('+$tag1'), true);

    query.toggleTagFilter(tag1);
    tags = query.getSelectedTags();
    expect(tags.contains('+$tag1'), false);

    query.toggleTagFilter(tag2);
    tags = query.getSelectedTags();
    expect(tags.contains('+$tag2'), true);
  });
}
