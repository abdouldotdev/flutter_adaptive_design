import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_adaptive_design/flutter_adaptive_design.dart';
import 'package:flutter_adaptive_design/testing.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  tearDown(() {
    PlatformUtils.debugOverridePlatform = null;
  });

  group('AdaptiveSpacing', () {
    test('standard spacing constants match 8pt scale', () {
      expect(AdaptiveSpacing.page, 16);
      expect(AdaptiveSpacing.item, 8);
      expect(AdaptiveSpacing.section, 24);
      expect(AdaptiveSpacing.xs, 4);
      expect(AdaptiveSpacing.sm, 8);
      expect(AdaptiveSpacing.md, 12);
      expect(AdaptiveSpacing.lg, 16);
      expect(AdaptiveSpacing.xl, 24);
      expect(AdaptiveSpacing.xxl, 32);
      expect(AdaptiveSpacing.xxxl, 48);
    });
  });

  group('AdaptiveRadius', () {
    test('radii differ between Cupertino and Material', () {
      PlatformUtils.debugOverridePlatform = TargetPlatform.iOS;
      expect(AdaptiveRadius.card, 10);
      expect(AdaptiveRadius.button, 10);
      expect(AdaptiveRadius.dialog, 14);
      expect(AdaptiveRadius.textField, 8);
      expect(AdaptiveRadius.chip, 6);
      expect(AdaptiveRadius.sheet, 12);

      PlatformUtils.debugOverridePlatform = TargetPlatform.android;
      expect(AdaptiveRadius.card, 12);
      expect(AdaptiveRadius.button, 20);
      expect(AdaptiveRadius.dialog, 28);
      expect(AdaptiveRadius.textField, 4);
      expect(AdaptiveRadius.chip, 8);
      expect(AdaptiveRadius.sheet, 28);
    });
  });

  group('AdaptiveMotion & AdaptiveScrollPhysics', () {
    testAdaptiveWidget('scroll physics match platform expectations',
        (tester, platform) async {
      await tester.pumpWidget(
        wrapAdaptiveTestWidget(
          Builder(
            builder: (context) {
              final physics = AdaptiveScrollPhysics.of();
              if (platform == TargetPlatform.iOS) {
                expect(physics, isA<BouncingScrollPhysics>());
              } else {
                expect(physics, isA<ClampingScrollPhysics>());
              }
              return const SizedBox.shrink();
            },
          ),
        ),
      );
    });

    test('motion durations are within standard UI bounds', () {
      expect(AdaptiveMotion.micro.inMilliseconds, inInclusiveRange(100, 150));
      expect(AdaptiveMotion.transition.inMilliseconds, inInclusiveRange(250, 300));
      expect(AdaptiveMotion.page.inMilliseconds, inInclusiveRange(350, 400));
    });
  });

  group('AdaptiveColors', () {
    testAdaptiveWidget('resolves primary and destructive colors correctly',
        (tester, platform) async {
      await tester.pumpWidget(
        wrapAdaptiveTestWidget(
          Builder(
            builder: (context) {
              final primary = AdaptiveColors.primary(context);
              final destructive = AdaptiveColors.destructive(context);
              expect(primary, isNotNull);
              expect(destructive, isNotNull);
              return const SizedBox.shrink();
            },
          ),
        ),
      );
    });
  });
}
