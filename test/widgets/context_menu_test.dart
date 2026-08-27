import 'package:flutter/cupertino.dart';
import 'package:flutter_adaptive_design/flutter_adaptive_design.dart';
import 'package:flutter_adaptive_design/testing.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  tearDown(() {
    PlatformUtils.debugOverridePlatform = null;
  });

  group('AdaptiveContextMenu', () {
    testAdaptiveWidget('renders child and wraps with platform interaction',
        (tester, platform) async {
      await tester.pumpWidget(
        wrapAdaptiveTestWidget(
          AdaptiveContextMenu(
            actions: [
              ContextMenuAction(
                label: 'Copy',
                onPressed: () {},
              ),
            ],
            child: const Text('Long press target'),
          ),
        ),
      );

      expect(find.text('Long press target'), findsOneWidget);

      if (platform == TargetPlatform.iOS) {
        expect(find.byType(CupertinoContextMenu), findsOneWidget);
      } else {
        expect(find.byType(GestureDetector), findsWidgets);
      }
    });

    testAdaptiveWidget('triggers Liquid Glass menu on long press when enabled',
        (tester, platform) async {
      int copyTapped = 0;
      await tester.pumpWidget(
        wrapAdaptiveTestWidget(
          AdaptiveContextMenu(
            useLiquidGlass: true,
            actions: [
              ContextMenuAction(
                label: 'Copy Item',
                onPressed: () => copyTapped++,
              ),
              ContextMenuAction(
                label: 'Delete Item',
                isDestructive: true,
                onPressed: () {},
              ),
            ],
            child: const Text('Glass target'),
          ),
        ),
      );

      expect(find.text('Glass target'), findsOneWidget);

      if (platform != TargetPlatform.iOS) {
        await tester.longPress(find.text('Glass target'));
        await tester.pumpAndSettle();

        expect(find.text('Copy Item'), findsOneWidget);
        expect(find.text('Delete Item'), findsOneWidget);
        expect(find.byType(AdaptiveLiquidGlass), findsOneWidget);

        await tester.tap(find.text('Copy Item'));
        await tester.pumpAndSettle();
        expect(copyTapped, 1);
      }
    });
  });
}
