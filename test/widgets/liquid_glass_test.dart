import 'package:flutter/material.dart';
import 'package:flutter_adaptive_design/flutter_adaptive_design.dart';
import 'package:flutter_adaptive_design/testing.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AdaptiveLiquidGlass', () {
    testAdaptiveWidget('renders frosted glass on iOS and M3 surface on Android', (tester, platform) async {
      await tester.pumpWidget(
        wrapAdaptiveTestWidget(
          AdaptiveLiquidGlass(
            child: const Text('Liquid Glass Content'),
          ),
        ),
      );

      expect(find.text('Liquid Glass Content'), findsOneWidget);

      if (platform == TargetPlatform.iOS) {
        expect(find.byType(BackdropFilter), findsOneWidget);
      } else {
        expect(find.byType(Material), findsWidgets);
      }
    });

    testAdaptiveWidget('AdaptiveFrostedCard renders cleanly', (tester, platform) async {
      await tester.pumpWidget(
        wrapAdaptiveTestWidget(
          AdaptiveFrostedCard(
            onTap: () {},
            child: const Text('Frosted Card'),
          ),
        ),
      );

      expect(find.text('Frosted Card'), findsOneWidget);
    });

    testAdaptiveWidget('AdaptiveLiquidNavBar renders item list', (tester, platform) async {
      await tester.pumpWidget(
        wrapAdaptiveTestWidget(
          const AdaptiveLiquidNavBar(
            items: [
              Text('Nav Item 1'),
              Text('Nav Item 2'),
            ],
          ),
        ),
      );

      expect(find.text('Nav Item 1'), findsOneWidget);
      expect(find.text('Nav Item 2'), findsOneWidget);
    });
  });
}
