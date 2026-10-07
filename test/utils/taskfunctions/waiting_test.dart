import 'package:flutter_test/flutter_test.dart';
import 'package:taskwarrior/app/models/models.dart';
import 'package:taskwarrior/app/utils/taskfunctions/waiting.dart';

void main() {
  final now = DateTime.utc(2026, 10, 1, 12);

  Task task({DateTime? wait}) => Task((b) => b
    ..uuid = 'u'
    ..description = 'd'
    ..status = 'pending'
    ..entry = now
    ..wait = wait);

  test('a task without a wait date is not waiting', () {
    expect(isWaiting(task(), now), isFalse);
  });

  test('a task whose wait date is in the future is waiting', () {
    expect(
        isWaiting(task(wait: now.add(const Duration(days: 1))), now), isTrue);
  });

  test('a task whose wait date has passed is no longer waiting', () {
    expect(isWaiting(task(wait: now.subtract(const Duration(days: 1))), now),
        isFalse);
  });
}
