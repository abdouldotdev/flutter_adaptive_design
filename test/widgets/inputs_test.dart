import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_adaptive_design/flutter_adaptive_design.dart';
import 'package:flutter_adaptive_design/testing.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  tearDown(() {
    PlatformUtils.debugOverridePlatform = null;
  });

  group('AdaptiveSwitch', () {
    testAdaptiveWidget('renders Switch on Android and CupertinoSwitch on iOS',
        (tester, platform) async {
      await tester.pumpWidget(
        wrapAdaptiveTestWidget(
          AdaptiveSwitch(
            value: true,
            onChanged: (v) {},
          ),
        ),
      );

      if (platform == TargetPlatform.iOS) {
        expect(find.byType(CupertinoSwitch), findsOneWidget);
        expect(find.byType(Switch), findsNothing);
      } else {
        expect(find.byType(Switch), findsOneWidget);
        expect(find.byType(CupertinoSwitch), findsNothing);
      }
    });
  });

  group('AdaptiveSlider', () {
    testAdaptiveWidget('renders Slider on Android and CupertinoSlider on iOS',
        (tester, platform) async {
      await tester.pumpWidget(
        wrapAdaptiveTestWidget(
          AdaptiveSlider(
            value: 0.5,
            onChanged: (v) {},
          ),
        ),
      );

      if (platform == TargetPlatform.iOS) {
        expect(find.byType(CupertinoSlider), findsOneWidget);
        expect(find.byType(Slider), findsNothing);
      } else {
        expect(find.byType(Slider), findsOneWidget);
        expect(find.byType(CupertinoSlider), findsNothing);
      }
    });
  });

  group('AdaptiveCheckbox', () {
    testAdaptiveWidget('renders Checkbox on Android and CupertinoCheckbox on iOS',
        (tester, platform) async {
      await tester.pumpWidget(
        wrapAdaptiveTestWidget(
          AdaptiveCheckbox(
            value: true,
            onChanged: (v) {},
          ),
        ),
      );

      if (platform == TargetPlatform.iOS) {
        expect(find.byType(CupertinoCheckbox), findsOneWidget);
      } else {
        expect(find.byType(Checkbox), findsOneWidget);
      }
    });
  });

  group('AdaptiveTextField', () {
    testAdaptiveWidget('renders TextField on Android and CupertinoTextField on iOS',
        (tester, platform) async {
      final controller = TextEditingController(text: 'Hello');
      await tester.pumpWidget(
        wrapAdaptiveTestWidget(
          AdaptiveTextField(
            controller: controller,
            placeholder: 'Type here',
          ),
        ),
      );

      if (platform == TargetPlatform.iOS) {
        expect(find.byType(CupertinoTextField), findsOneWidget);
        expect(find.byType(TextField), findsNothing);
      } else {
        expect(find.byType(TextField), findsOneWidget);
        expect(find.byType(CupertinoTextField), findsNothing);
      }
    });
  });

  group('AdaptiveSearchBar', () {
    testAdaptiveWidget('renders SearchBar on Android and CupertinoSearchTextField on iOS',
        (tester, platform) async {
      await tester.pumpWidget(
        wrapAdaptiveTestWidget(
          const AdaptiveSearchBar(
            placeholder: 'Search items',
          ),
        ),
      );

      if (platform == TargetPlatform.iOS) {
        expect(find.byType(CupertinoSearchTextField), findsOneWidget);
      } else {
        expect(find.byType(SearchBar), findsOneWidget);
      }
    });
  });

  group('AdaptiveSegmentedControl', () {
    testAdaptiveWidget('renders SegmentedButton on Android and CupertinoSlidingSegmentedControl on iOS',
        (tester, platform) async {
      await tester.pumpWidget(
        wrapAdaptiveTestWidget(
          AdaptiveSegmentedControl<int>(
            selected: 1,
            onSelectionChanged: (v) {},
            segments: const [
              AdaptiveSegment(value: 1, label: Text('First')),
              AdaptiveSegment(value: 2, label: Text('Second')),
            ],
          ),
        ),
      );

      if (platform == TargetPlatform.iOS) {
        expect(find.byType(CupertinoSlidingSegmentedControl<int>), findsOneWidget);
      } else {
        expect(find.byType(SegmentedButton<int>), findsOneWidget);
      }
    });
  });
}
