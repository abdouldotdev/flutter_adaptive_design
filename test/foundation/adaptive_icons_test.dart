import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_adaptive_design/flutter_adaptive_design.dart';
import 'package:flutter_adaptive_design/testing.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  tearDown(() {
    PlatformUtils.debugOverridePlatform = null;
  });

  group('AdaptiveIcons & AdaptiveIcon', () {
    testAdaptiveWidget('renders HugeIcon correctly', (tester, platform) async {
      await tester.pumpWidget(
        wrapAdaptiveTestWidget(
          const AdaptiveIcon(
            AdaptiveIcons.home,
            size: 24,
            semanticLabel: 'Home',
          ),
        ),
      );

      expect(find.byType(AdaptiveIcon), findsOneWidget);
    });

    testAdaptiveWidget('renders standard Flutter IconData correctly', (tester, platform) async {
      await tester.pumpWidget(
        wrapAdaptiveTestWidget(
          const AdaptiveIcon(
            Icons.star,
            size: 24,
            semanticLabel: 'Star',
          ),
        ),
      );

      expect(find.byIcon(Icons.star), findsOneWidget);
    });

    test('resolve branches between glyphs', () {
      PlatformUtils.debugOverridePlatform = TargetPlatform.iOS;
      final iosIcon = AdaptiveIcons.resolve(
        material: Icons.arrow_back,
        cupertino: CupertinoIcons.back,
      );
      expect(iosIcon, CupertinoIcons.back);

      PlatformUtils.debugOverridePlatform = TargetPlatform.android;
      final androidIcon = AdaptiveIcons.resolve(
        material: Icons.arrow_back,
        cupertino: CupertinoIcons.back,
      );
      expect(androidIcon, Icons.arrow_back);
    });
  });
}
