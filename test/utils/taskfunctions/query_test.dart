import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:taskwarrior/app/utils/taskfunctions/query.dart';

void main() {
  late Directory queryStorage;
  late Query query;

  setUp(() {
    queryStorage = Directory.systemTemp.createTempSync();
    query = Query(queryStorage);
  });

  tearDown(() {
    queryStorage.deleteSync(recursive: true);
  });

  test('setSelectedSort and getSelectedSort', () {
    query.setSelectedSort('priority+');
    expect(query.getSelectedSort(), 'priority+');
  });

  test('getSelectedSort default value', () {
    expect(query.getSelectedSort(), 'urgency+');
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
    expect(query.projectFilter(), '');
    query.toggleProjectFilter('Project1');
    expect(query.projectFilter(), 'Project1');
    query.toggleProjectFilter('Project1');
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
    expect(query.getSelectedTags(), <String>{});
    query.toggleTagFilter('tag1');
    expect(query.getSelectedTags(), {'+tag1'});
    query.toggleTagFilter('tag1');
    expect(query.getSelectedTags(), <String>{'-tag1'});
    query.toggleTagFilter('tag2');
    expect(query.getSelectedTags(), {'-tag1', '+tag2'});
    query.toggleTagFilter('tag2');
    expect(query.getSelectedTags(), <String>{'-tag1', '-tag2'});
  });
}
