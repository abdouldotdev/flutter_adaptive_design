import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_adaptive_design/flutter_adaptive_design.dart';
import 'package:flutter_adaptive_design/testing.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  tearDown(() {
    PlatformUtils.debugOverridePlatform = null;
  });

  group('AdaptiveButton', () {
    testAdaptiveWidget('renders native primitive per platform',
        (tester, platform) async {
      await tester.pumpWidget(
        wrapAdaptiveTestWidget(
          AdaptiveButton.label(onPressed: () {}, label: 'Submit'),
        ),
      );

      expect(find.text('Submit'), findsOneWidget);

      if (platform == TargetPlatform.iOS) {
        expect(find.byType(CupertinoButton), findsOneWidget);
        expect(find.byType(FilledButton), findsNothing);
      } else {
        expect(find.byType(FilledButton), findsOneWidget);
        expect(find.byType(CupertinoButton), findsNothing);
      }
    });

    testAdaptiveWidget('triggers onPressed callback',
        (tester, platform) async {
      int tapCount = 0;
      await tester.pumpWidget(
        wrapAdaptiveTestWidget(
          AdaptiveButton.label(
            onPressed: () => tapCount++,
            label: 'Tap Me',
          ),
        ),
      );

      await tester.tap(find.byType(AdaptiveButton));
      await tester.pump();
      expect(tapCount, 1);
    });

    testAdaptiveWidget('respects disabled state when onPressed is null',
        (tester, platform) async {
      await tester.pumpWidget(
        wrapAdaptiveTestWidget(
          const AdaptiveButton(
            onPressed: null,
            child: Text('Disabled'),
          ),
        ),
      );

      if (platform == TargetPlatform.iOS) {
        final button = tester.widget<CupertinoButton>(find.byType(CupertinoButton));
        expect(button.enabled, isFalse);
      } else {
        final button = tester.widget<FilledButton>(find.byType(FilledButton));
        expect(button.enabled, isFalse);
      }
    });
  });

  group('AdaptiveTextButton', () {
    testAdaptiveWidget('renders TextButton or CupertinoButton',
        (tester, platform) async {
      await tester.pumpWidget(
        wrapAdaptiveTestWidget(
          AdaptiveTextButton(
            onPressed: () {},
            child: const Text('Cancel'),
          ),
        ),
      );

      expect(find.text('Cancel'), findsOneWidget);
      if (platform == TargetPlatform.iOS) {
        expect(find.byType(CupertinoButton), findsOneWidget);
      } else {
        expect(find.byType(TextButton), findsOneWidget);
      }
    });
  });

  group('AdaptiveIconButton', () {
    testAdaptiveWidget('renders icon button natively',
        (tester, platform) async {
      await tester.pumpWidget(
        wrapAdaptiveTestWidget(
          AdaptiveIconButton(
            onPressed: () {},
            icon: const Icon(Icons.favorite),
          ),
        ),
      );

      if (platform == TargetPlatform.iOS) {
        expect(find.byType(CupertinoButton), findsOneWidget);
      } else {
        expect(find.byType(IconButton), findsOneWidget);
      }
    });
  });

  group('AdaptiveFAB', () {
    testAdaptiveWidget('renders FloatingActionButton on Android and shrinks on iOS',
        (tester, platform) async {
      await tester.pumpWidget(
        wrapAdaptiveTestWidget(
          AdaptiveFAB(
            onPressed: () {},
            child: const Icon(Icons.add),
          ),
        ),
      );

      if (platform == TargetPlatform.iOS) {
        expect(find.byType(FloatingActionButton), findsNothing);
      } else {
        expect(find.byType(FloatingActionButton), findsOneWidget);
      }
    });
  });
}
