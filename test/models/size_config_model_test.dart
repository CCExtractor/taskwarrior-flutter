import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:taskwarrior/app/models/size_config_model.dart';

void main() {
  group('SizeConfig', () {
    late SizeConfig sizeConfig;

    setUp(() {
      sizeConfig = SizeConfig();
    });

    testWidgets('should initialize screen dimensions correctly',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (BuildContext context) {
              sizeConfig.init(context);
              return Container();
            },
          ),
        ),
      );

      final mediaQueryData =
          MediaQuery.of(tester.element(find.byType(Container)));

      expect(sizeConfig.screenW, mediaQueryData.size.width);
      expect(sizeConfig.screenH, mediaQueryData.size.height);
      expect(sizeConfig.blockH, mediaQueryData.size.width / 100);
      expect(sizeConfig.blockV, mediaQueryData.size.height / 100);
    });
  });
}
