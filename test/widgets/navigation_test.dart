import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_adaptive_design/flutter_adaptive_design.dart';
import 'package:flutter_adaptive_design/testing.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  tearDown(() {
    PlatformUtils.debugOverridePlatform = null;
  });

  group('AdaptiveNavigationDrawer', () {
    testAdaptiveWidget('renders drawer per platform', (tester, platform) async {
      await tester.pumpWidget(
        wrapAdaptiveTestWidget(
          AdaptiveNavigationDrawer(
            selectedIndex: 0,
            items: const [
              AdaptiveDrawerItem(label: 'Home', icon: Icons.home),
              AdaptiveDrawerItem(label: 'Settings', icon: Icons.settings),
            ],
          ),
        ),
      );

      expect(find.text('Home'), findsOneWidget);
      expect(find.text('Settings'), findsOneWidget);
    });
  });

  group('AdaptivePageRoute', () {
    test('creates CupertinoPageRoute on iOS and MaterialPageRoute on Android', () {
      PlatformUtils.debugOverridePlatform = TargetPlatform.iOS;
      final iosRoute = AdaptivePageRoute.create<void>(
        builder: (_) => const SizedBox.shrink(),
      );
      expect(iosRoute, isA<CupertinoPageRoute<void>>());

      PlatformUtils.debugOverridePlatform = TargetPlatform.android;
      final androidRoute = AdaptivePageRoute.create<void>(
        builder: (_) => const SizedBox.shrink(),
      );
      expect(androidRoute, isA<MaterialPageRoute<void>>());
    });
  });

  group('AdaptiveTabBar', () {
    testAdaptiveWidget('renders TabBar on Android and SegmentedControl on iOS',
        (tester, platform) async {
      await tester.pumpWidget(
        wrapAdaptiveTestWidget(
          const AdaptiveTabBar(
            tabs: [
              AdaptiveTab(label: 'Tab 1', child: Text('Content 1')),
              AdaptiveTab(label: 'Tab 2', child: Text('Content 2')),
            ],
          ),
        ),
      );

      expect(find.text('Tab 1'), findsOneWidget);
      expect(find.text('Tab 2'), findsOneWidget);
    });
  });
}
