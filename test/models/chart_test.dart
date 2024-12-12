import 'package:flutter_test/flutter_test.dart';
import 'package:taskwarrior/app/models/chart.dart';

void main() {
  group('ChartData', () {
    test('should create an instance with correct values', () {
      final chartData = ChartData('2024-12-12', 100, 200);

      expect(chartData.x, '2024-12-12');
      expect(chartData.y1, 100);
      expect(chartData.y2, 200);
    });

    test('should handle null or empty values correctly', () {
      final chartData = ChartData('', 0, 0);

      expect(chartData.x, '');
      expect(chartData.y1, 0);
      expect(chartData.y2, 0);
    });

    test('should handle negative values correctly', () {
      final chartData = ChartData('2024-12-12', -100, -200);

      expect(chartData.x, '2024-12-12');
      expect(chartData.y1, -100);
      expect(chartData.y2, -200);
    });
  });
}
