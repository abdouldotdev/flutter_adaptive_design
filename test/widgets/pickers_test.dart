import 'package:flutter/material.dart';
import 'package:flutter_adaptive_design/flutter_adaptive_design.dart';
import 'package:flutter_adaptive_design/testing.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  tearDown(() {
    PlatformUtils.debugOverridePlatform = null;
  });

  group('AdaptiveDatePicker & AdaptiveTimePicker', () {
    testAdaptiveWidget('opens date picker on tap', (tester, platform) async {
      await tester.pumpWidget(
        wrapAdaptiveTestWidget(
          Builder(
            builder: (context) {
              return ElevatedButton(
                onPressed: () {
                  AdaptiveDatePicker.show(
                    context: context,
                    initialDate: DateTime(2026, 1, 1),
                    firstDate: DateTime(2020, 1, 1),
                    lastDate: DateTime(2030, 1, 1),
                  );
                },
                child: const Text('Pick Date'),
              );
            },
          ),
        ),
      );

      await tester.tap(find.text('Pick Date'));
      await tester.pumpAndSettle();

      if (platform == TargetPlatform.android) {
        expect(find.byType(DatePickerDialog), findsOneWidget);
      }
    });

    testAdaptiveWidget('opens time picker on tap', (tester, platform) async {
      await tester.pumpWidget(
        wrapAdaptiveTestWidget(
          Builder(
            builder: (context) {
              return ElevatedButton(
                onPressed: () {
                  AdaptiveTimePicker.show(
                    context: context,
                    initialTime: const TimeOfDay(hour: 10, minute: 30),
                  );
                },
                child: const Text('Pick Time'),
              );
            },
          ),
        ),
      );

      await tester.tap(find.text('Pick Time'));
      await tester.pumpAndSettle();

      if (platform == TargetPlatform.android) {
        expect(find.byType(TimePickerDialog), findsOneWidget);
      }
    });
  });

  group('AdaptivePicker', () {
    testAdaptiveWidget('opens list picker on tap', (tester, platform) async {
      await tester.pumpWidget(
        wrapAdaptiveTestWidget(
          Builder(
            builder: (context) {
              return ElevatedButton(
                onPressed: () {
                  AdaptivePicker.show(
                    context: context,
                    items: ['Option 1', 'Option 2', 'Option 3'],
                    title: 'Select Item',
                  );
                },
                child: const Text('Pick Item'),
              );
            },
          ),
        ),
      );

      await tester.tap(find.text('Pick Item'));
      await tester.pumpAndSettle();

      expect(find.text('Select Item'), findsOneWidget);
    });
  });
}
