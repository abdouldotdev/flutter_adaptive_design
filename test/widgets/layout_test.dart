import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_adaptive_design/flutter_adaptive_design.dart';
import 'package:flutter_adaptive_design/testing.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  tearDown(() {
    PlatformUtils.debugOverridePlatform = null;
  });

  group('AdaptiveScaffold', () {
    testAdaptiveWidget('renders Scaffold on Android and CupertinoPageScaffold on iOS',
        (tester, platform) async {
      await tester.pumpWidget(
        wrapAdaptiveTestWidget(
          const AdaptiveScaffold(
            body: Text('Scaffold Content'),
          ),
        ),
      );

      expect(find.text('Scaffold Content'), findsOneWidget);

      if (platform == TargetPlatform.iOS) {
        expect(find.byType(CupertinoPageScaffold), findsOneWidget);
      } else {
        expect(find.byType(Scaffold), findsOneWidget);
      }
    });
  });

  group('AdaptiveAppBar', () {
    testAdaptiveWidget('renders AppBar on Android and CupertinoNavigationBar on iOS',
        (tester, platform) async {
      await tester.pumpWidget(
        wrapAdaptiveTestWidget(
          const AdaptiveScaffold(
            appBar: AdaptiveAppBar(title: 'App Title'),
            body: Text('Body'),
          ),
        ),
      );

      expect(find.text('App Title'), findsOneWidget);

      if (platform == TargetPlatform.iOS) {
        expect(find.byType(CupertinoNavigationBar), findsOneWidget);
      } else {
        expect(find.byType(AppBar), findsOneWidget);
      }
    });

    testAdaptiveWidget('renders with useLiquidGlass enabled',
        (tester, platform) async {
      await tester.pumpWidget(
        wrapAdaptiveTestWidget(
          const AdaptiveScaffold(
            appBar: AdaptiveAppBar(
              title: 'Liquid Glass Title',
              useLiquidGlass: true,
            ),
            body: Text('Body Content'),
          ),
        ),
      );

      expect(find.text('Liquid Glass Title'), findsOneWidget);

      if (platform == TargetPlatform.iOS) {
        expect(find.byType(CupertinoNavigationBar), findsOneWidget);
        expect(
          find.byWidgetPredicate(
            (w) =>
                w is BackdropFilter &&
                w.filter == ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          ),
          findsOneWidget,
        );
      } else {
        final appBar = tester.widget<AppBar>(find.byType(AppBar));
        expect(appBar.elevation, equals(2.0));
      }
    });
  });

  group('AdaptiveSliverAppBar', () {
    testAdaptiveWidget('renders sliver bar with useLiquidGlass true and false',
        (tester, platform) async {
      await tester.pumpWidget(
        wrapAdaptiveTestWidget(
          CustomScrollView(
            slivers: const [
              AdaptiveSliverAppBar(
                title: 'Sliver Title',
                useLiquidGlass: true,
              ),
              SliverToBoxAdapter(child: Text('Sliver Body')),
            ],
          ),
        ),
      );

      expect(find.text('Sliver Title'), findsOneWidget);

      if (platform == TargetPlatform.iOS) {
        expect(find.byType(CupertinoSliverNavigationBar), findsOneWidget);
      } else {
        final sliverAppBar =
            tester.widget<SliverAppBar>(find.byType(SliverAppBar));
        expect(sliverAppBar.elevation, equals(2.0));
      }
    });
  });

  group('AdaptiveBottomNav', () {
    const navItems = [
      AdaptiveBottomNavItem(
        icon: Icon(Icons.home),
        label: 'Home',
      ),
      AdaptiveBottomNavItem(
        icon: Icon(Icons.search),
        label: 'Search',
      ),
    ];

    testAdaptiveWidget('renders native bar when useLiquidGlass is false',
        (tester, platform) async {
      await tester.pumpWidget(
        wrapAdaptiveTestWidget(
          const AdaptiveBottomNav(
            currentIndex: 0,
            items: navItems,
            useLiquidGlass: false,
          ),
        ),
      );

      expect(find.text('Home'), findsOneWidget);
      expect(find.text('Search'), findsOneWidget);

      if (platform == TargetPlatform.iOS) {
        expect(find.byType(CupertinoTabBar), findsOneWidget);
        expect(find.byType(AdaptiveLiquidGlass), findsNothing);
      } else {
        expect(find.byType(NavigationBar), findsOneWidget);
        expect(find.byType(AdaptiveLiquidGlass), findsNothing);
      }
    });

    testAdaptiveWidget('renders AdaptiveLiquidGlass when useLiquidGlass is true',
        (tester, platform) async {
      await tester.pumpWidget(
        wrapAdaptiveTestWidget(
          const AdaptiveBottomNav(
            currentIndex: 0,
            items: navItems,
            useLiquidGlass: true,
          ),
        ),
      );

      expect(find.text('Home'), findsOneWidget);
      expect(find.text('Search'), findsOneWidget);
      expect(find.byType(AdaptiveLiquidGlass), findsOneWidget);
    });
  });

  group('AdaptiveCard', () {
    testAdaptiveWidget(
      'renders Card on Android and styled Container on iOS',
      (tester, platform) async {
        await tester.pumpWidget(
          wrapAdaptiveTestWidget(
            const AdaptiveCard(
              child: Text('Card Content'),
            ),
          ),
        );

        expect(find.text('Card Content'), findsOneWidget);

        if (platform == TargetPlatform.iOS) {
          expect(find.byType(Card), findsNothing);
        } else {
          expect(find.byType(Card), findsOneWidget);
        }
      },
    );

    testAdaptiveWidget(
      'renders Liquid Glass on iOS when useLiquidGlass is true',
      (tester, platform) async {
        int tapped = 0;
        await tester.pumpWidget(
          wrapAdaptiveTestWidget(
            AdaptiveCard(
              useLiquidGlass: true,
              onTap: () => tapped++,
              child: const Text('Liquid Card'),
            ),
          ),
        );

        expect(find.text('Liquid Card'), findsOneWidget);

        if (platform == TargetPlatform.iOS) {
          expect(find.byType(AdaptiveLiquidGlass), findsOneWidget);
          expect(find.byType(BackdropFilter), findsOneWidget);
        }

        await tester.tap(find.text('Liquid Card'));
        await tester.pump();
        expect(tapped, 1);
      },
    );
  });

  group('AdaptiveListSection', () {
    testAdaptiveWidget(
      'renders standard section on Android and Cupertino',
      (tester, platform) async {
        await tester.pumpWidget(
          wrapAdaptiveTestWidget(
            const AdaptiveListSection(
              header: 'Section Header',
              footer: 'Section Footer',
              children: [Text('Item 1'), Text('Item 2')],
            ),
          ),
        );

        expect(find.text('Item 1'), findsOneWidget);
        expect(find.text('Item 2'), findsOneWidget);

        if (platform == TargetPlatform.iOS) {
          expect(find.byType(CupertinoListSection), findsOneWidget);
        } else {
          expect(find.byType(Card), findsOneWidget);
        }
      },
    );

    testAdaptiveWidget(
      'renders Liquid Glass on iOS when useLiquidGlass is true',
      (tester, platform) async {
        await tester.pumpWidget(
          wrapAdaptiveTestWidget(
            const AdaptiveListSection(
              useLiquidGlass: true,
              header: 'Glass Header',
              footer: 'Glass Footer',
              children: [Text('Glass Item 1'), Text('Glass Item 2')],
            ),
          ),
        );

        expect(find.text('Glass Item 1'), findsOneWidget);
        expect(find.text('Glass Item 2'), findsOneWidget);

        if (platform == TargetPlatform.iOS) {
          expect(find.byType(AdaptiveLiquidGlass), findsOneWidget);
          expect(find.byType(BackdropFilter), findsOneWidget);
        }
      },
    );
  });

  group('AdaptiveListTile', () {
    testAdaptiveWidget(
      'renders ListTile on Android and CupertinoListTile on iOS',
      (tester, platform) async {
        int tapped = 0;
        await tester.pumpWidget(
          wrapAdaptiveTestWidget(
            AdaptiveListTile(
              title: const Text('Tile Title'),
              subtitle: const Text('Tile Subtitle'),
              onTap: () => tapped++,
            ),
          ),
        );

        expect(find.text('Tile Title'), findsOneWidget);
        expect(find.text('Tile Subtitle'), findsOneWidget);

        if (platform == TargetPlatform.iOS) {
          expect(find.byType(CupertinoListTile), findsOneWidget);
        } else {
          expect(find.byType(ListTile), findsOneWidget);
        }

        await tester.tap(find.text('Tile Title'));
        await tester.pump();
        expect(tapped, 1);
      },
    );

    testAdaptiveWidget(
      'renders Liquid Glass on iOS when useLiquidGlass is true',
      (tester, platform) async {
        int tapped = 0;
        await tester.pumpWidget(
          wrapAdaptiveTestWidget(
            AdaptiveListTile(
              useLiquidGlass: true,
              leading: const Icon(Icons.star),
              title: const Text('Glass Tile'),
              subtitle: const Text('Glass Subtitle'),
              onTap: () => tapped++,
            ),
          ),
        );

        expect(find.text('Glass Tile'), findsOneWidget);
        expect(find.text('Glass Subtitle'), findsOneWidget);

        if (platform == TargetPlatform.iOS) {
          expect(find.byType(AdaptiveLiquidGlass), findsOneWidget);
          expect(find.byType(BackdropFilter), findsOneWidget);
        }

        await tester.tap(find.text('Glass Tile'));
        await tester.pump();
        expect(tapped, 1);
      },
    );
  });

  group('AdaptiveLiquidGlass & Frosted Components', () {
    testAdaptiveWidget(
      'AdaptiveLiquidGlass animates spring scale on tap',
      (tester, platform) async {
        int taps = 0;
        await tester.pumpWidget(
          wrapAdaptiveTestWidget(
            AdaptiveLiquidGlass(
              onTap: () => taps++,
              child: const Text('Tap Me'),
            ),
          ),
        );

        expect(find.text('Tap Me'), findsOneWidget);

        await tester.tap(find.text('Tap Me'));
        await tester.pump();
        expect(taps, 1);
      },
    );

    testAdaptiveWidget(
      'AdaptiveFrostedCard and AdaptiveLiquidNavBar render correctly',
      (tester, platform) async {
        await tester.pumpWidget(
          wrapAdaptiveTestWidget(
            const Column(
              children: [
                AdaptiveFrostedCard(child: Text('Frosted Card')),
                AdaptiveLiquidNavBar(items: [Text('Nav 1'), Text('Nav 2')]),
              ],
            ),
          ),
        );

        expect(find.text('Frosted Card'), findsOneWidget);
        expect(find.text('Nav 1'), findsOneWidget);
        expect(find.text('Nav 2'), findsOneWidget);
      },
    );
  });

  group('AdaptiveDivider', () {
    testAdaptiveWidget(
      'renders Divider on Android and custom separator on iOS',
      (tester, platform) async {
        await tester.pumpWidget(
          wrapAdaptiveTestWidget(
            const AdaptiveDivider(),
          ),
        );

        if (platform == TargetPlatform.iOS) {
          expect(find.byType(Divider), findsNothing);
        } else {
          expect(find.byType(Divider), findsOneWidget);
        }
      },
    );
  });
}
