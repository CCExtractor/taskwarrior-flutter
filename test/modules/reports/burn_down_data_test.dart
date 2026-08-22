import 'package:flutter_test/flutter_test.dart';
import 'package:taskwarrior/app/modules/reports/burn_down_data.dart';

/// Covers the bucketing shared by every burndown chart. This replaced nine
/// near-duplicate widgets that each re-implemented it inline, so the grouping
/// keys here must match what those produced or the x-axis labels would shift.
void main() {
  BurnDownEntry e(DateTime d, String status) =>
      BurnDownEntry(date: d, status: status);

  group('bucketBurnDown — counting', () {
    test('counts pending and completed separately within a bucket', () {
      final buckets = bucketBurnDown([
        e(DateTime(2024, 6, 1), 'pending'),
        e(DateTime(2024, 6, 1), 'pending'),
        e(DateTime(2024, 6, 1), 'completed'),
      ], BurnDownPeriod.daily);

      expect(buckets.length, 1);
      expect(buckets['06-01'], {'pending': 2, 'completed': 1});
    });

    test('separates tasks that fall in different buckets', () {
      final buckets = bucketBurnDown([
        e(DateTime(2024, 6, 1), 'pending'),
        e(DateTime(2024, 6, 2), 'completed'),
      ], BurnDownPeriod.daily);

      expect(buckets.keys.toSet(), {'06-01', '06-02'});
      expect(buckets['06-01']!['pending'], 1);
      expect(buckets['06-02']!['completed'], 1);
    });

    test('ignores statuses other than pending/completed', () {
      // Deleted and recurring tasks were never plotted; with soft delete now
      // preserving deleted records, this matters more than it used to.
      final buckets = bucketBurnDown([
        e(DateTime(2024, 6, 1), 'deleted'),
        e(DateTime(2024, 6, 1), 'recurring'),
        e(DateTime(2024, 6, 1), 'pending'),
      ], BurnDownPeriod.daily);

      expect(buckets['06-01'], {'pending': 1, 'completed': 0});
    });

    test('an empty input produces no buckets', () {
      expect(bucketBurnDown([], BurnDownPeriod.daily), isEmpty);
    });

    test('a bucket with only completed tasks still reports pending: 0', () {
      final buckets = bucketBurnDown(
          [e(DateTime(2024, 6, 1), 'completed')], BurnDownPeriod.daily);
      expect(buckets['06-01'], {'pending': 0, 'completed': 1});
    });
  });

  group('bucketBurnDown — ordering', () {
    test('buckets come out oldest-first regardless of input order', () {
      final buckets = bucketBurnDown([
        e(DateTime(2024, 6, 3), 'pending'),
        e(DateTime(2024, 6, 1), 'pending'),
        e(DateTime(2024, 6, 2), 'pending'),
      ], BurnDownPeriod.daily);

      // Dart maps preserve insertion order, which is what the chart plots.
      expect(buckets.keys.toList(), ['06-01', '06-02', '06-03']);
    });
  });

  group('burnDownBucketKey — grouping granularity', () {
    test('daily keys are MM-dd', () {
      expect(burnDownBucketKey(DateTime(2024, 7, 1), BurnDownPeriod.daily),
          '07-01');
    });

    test('monthly keys are MonthName YYYY', () {
      expect(burnDownBucketKey(DateTime(2024, 7, 15), BurnDownPeriod.monthly),
          'July 2024');
    });

    test('days in the same month share a monthly bucket', () {
      final buckets = bucketBurnDown([
        e(DateTime(2024, 7, 1), 'pending'),
        e(DateTime(2024, 7, 28), 'completed'),
      ], BurnDownPeriod.monthly);

      expect(buckets.length, 1);
      expect(buckets['July 2024'], {'pending': 1, 'completed': 1});
    });

    test('days in the same 7-day window share a weekly bucket', () {
      // Days 183 and 184 of 2024 both fall in window 27.
      final buckets = bucketBurnDown([
        e(DateTime(2024, 7, 2), 'pending'),
        e(DateTime(2024, 7, 3), 'completed'),
      ], BurnDownPeriod.weekly);

      expect(buckets.length, 1);
      expect(buckets.values.single, {'pending': 1, 'completed': 1});
    });

    test('weekly buckets are 7-day windows from Jan 1, not calendar weeks', () {
      // Documents a PRE-EXISTING quirk carried over unchanged by this
      // refactor: Utils.getWeekNumbertoInt is ceil(daysSinceJan1 / 7), so the
      // window boundaries ignore the day of week. 2024-07-01 is a Monday and
      // 2024-07-03 is the same Mon-Sun week, yet they land in windows 26 and
      // 27. Asserted so the behaviour is visible rather than hidden — if the
      // charts should follow real calendar weeks, that is a deliberate
      // behaviour change to make in Utils, not here.
      expect(burnDownBucketKey(DateTime(2024, 7, 1), BurnDownPeriod.weekly),
          '26');
      expect(burnDownBucketKey(DateTime(2024, 7, 3), BurnDownPeriod.weekly),
          '27');
    });

    test('different months land in different monthly buckets', () {
      final buckets = bucketBurnDown([
        e(DateTime(2024, 6, 30), 'pending'),
        e(DateTime(2024, 7, 1), 'pending'),
      ], BurnDownPeriod.monthly);

      expect(buckets.keys.toList(), ['June 2024', 'July 2024']);
    });
  });
}
