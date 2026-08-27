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
  });

  group('AdaptiveCard', () {
    testAdaptiveWidget('renders Card on Android and styled Container on iOS',
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
    });
  });

  group('AdaptiveListTile', () {
    testAdaptiveWidget('renders ListTile on Android and CupertinoListTile on iOS',
        (tester, platform) async {
      await tester.pumpWidget(
        wrapAdaptiveTestWidget(
          AdaptiveListTile(
            title: const Text('Tile Title'),
            subtitle: const Text('Tile Subtitle'),
            onTap: () {},
          ),
        ),
      );

      expect(find.text('Tile Title'), findsOneWidget);

      if (platform == TargetPlatform.iOS) {
        expect(find.byType(CupertinoListTile), findsOneWidget);
      } else {
        expect(find.byType(ListTile), findsOneWidget);
      }
    });
  });

  group('AdaptiveDivider', () {
    testAdaptiveWidget('renders Divider on Android and custom separator on iOS',
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
    });
  });
}
