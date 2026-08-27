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
    testAdaptiveWidget('renders drawer per platform with useLiquidGlass false',
        (tester, platform) async {
      await tester.pumpWidget(
        wrapAdaptiveTestWidget(
          const AdaptiveNavigationDrawer(
            selectedIndex: 0,
            useLiquidGlass: false,
            items: [
              AdaptiveDrawerItem(label: 'Home', icon: Icons.home),
              AdaptiveDrawerItem(label: 'Settings', icon: Icons.settings),
            ],
          ),
        ),
      );

      expect(find.text('Home'), findsOneWidget);
      expect(find.text('Settings'), findsOneWidget);

      if (platform == TargetPlatform.iOS) {
        expect(find.byType(BackdropFilter), findsNothing);
      } else {
        expect(find.byType(NavigationDrawer), findsOneWidget);
      }
    });

    testAdaptiveWidget('renders drawer with useLiquidGlass true',
        (tester, platform) async {
      await tester.pumpWidget(
        wrapAdaptiveTestWidget(
          const AdaptiveNavigationDrawer(
            selectedIndex: 0,
            useLiquidGlass: true,
            items: [
              AdaptiveDrawerItem(label: 'Home', icon: Icons.home),
              AdaptiveDrawerItem(label: 'Settings', icon: Icons.settings),
            ],
          ),
        ),
      );

      expect(find.text('Home'), findsOneWidget);
      expect(find.text('Settings'), findsOneWidget);

      if (platform == TargetPlatform.iOS) {
        expect(find.byType(BackdropFilter), findsOneWidget);
      } else {
        final drawer = tester.widget<NavigationDrawer>(find.byType(NavigationDrawer));
        expect(drawer.elevation, equals(2.0));
      }
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
            useLiquidGlass: false,
            tabs: [
              AdaptiveTab(label: 'Tab 1', child: Text('Content 1')),
              AdaptiveTab(label: 'Tab 2', child: Text('Content 2')),
            ],
          ),
        ),
      );

      expect(find.text('Tab 1'), findsOneWidget);
      expect(find.text('Tab 2'), findsOneWidget);

      if (platform == TargetPlatform.iOS) {
        expect(find.byType(CupertinoSlidingSegmentedControl<int>), findsOneWidget);
        expect(find.byType(AdaptiveLiquidGlass), findsNothing);
      } else {
        expect(find.byType(TabBar), findsOneWidget);
      }
    });

    testAdaptiveWidget('renders TabBar with useLiquidGlass true',
        (tester, platform) async {
      await tester.pumpWidget(
        wrapAdaptiveTestWidget(
          const AdaptiveTabBar(
            useLiquidGlass: true,
            tabs: [
              AdaptiveTab(label: 'Tab 1', child: Text('Content 1')),
              AdaptiveTab(label: 'Tab 2', child: Text('Content 2')),
            ],
          ),
        ),
      );

      expect(find.text('Tab 1'), findsOneWidget);
      expect(find.text('Tab 2'), findsOneWidget);

      if (platform == TargetPlatform.iOS) {
        expect(find.byType(AdaptiveLiquidGlass), findsOneWidget);
      } else {
        expect(find.byType(TabBar), findsOneWidget);
      }
    });
  });

  group('AdaptivePopupMenu', () {
    testAdaptiveWidget('renders popup menu trigger and selects item',
        (tester, platform) async {
      String? selectedValue;
      await tester.pumpWidget(
        wrapAdaptiveTestWidget(
          AdaptivePopupMenu<String>(
            onSelected: (val) => selectedValue = val,
            items: const [
              AdaptiveMenuItem(label: 'Edit', value: 'edit', icon: Icons.edit),
              AdaptiveMenuItem(
                label: 'Delete',
                value: 'delete',
                icon: Icons.delete,
                isDestructive: true,
              ),
            ],
            child: const Text('Menu Trigger'),
          ),
        ),
      );

      expect(find.text('Menu Trigger'), findsOneWidget);

      await tester.tap(find.text('Menu Trigger'));
      await tester.pumpAndSettle();

      expect(find.text('Edit'), findsOneWidget);
      expect(find.text('Delete'), findsOneWidget);

      await tester.tap(find.text('Edit'));
      await tester.pumpAndSettle();
      expect(selectedValue, 'edit');
    });

    testAdaptiveWidget('renders Liquid Glass popup menu when useLiquidGlass is true',
        (tester, platform) async {
      String? selectedValue;
      await tester.pumpWidget(
        wrapAdaptiveTestWidget(
          AdaptivePopupMenu<String>(
            useLiquidGlass: true,
            title: 'Options Menu',
            onSelected: (val) => selectedValue = val,
            items: const [
              AdaptiveMenuItem(label: 'Share', value: 'share'),
              AdaptiveMenuItem(label: 'Archive', value: 'archive'),
            ],
            child: const Text('Glass Menu Trigger'),
          ),
        ),
      );

      expect(find.text('Glass Menu Trigger'), findsOneWidget);

      await tester.tap(find.text('Glass Menu Trigger'));
      await tester.pumpAndSettle();

      expect(find.text('Options Menu'), findsOneWidget);
      expect(find.text('Share'), findsOneWidget);
      expect(find.byType(AdaptiveLiquidGlass), findsWidgets);

      await tester.tap(find.text('Share'));
      await tester.pumpAndSettle();
      expect(selectedValue, 'share');
    });
  });
}
