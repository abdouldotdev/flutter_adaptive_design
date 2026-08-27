import 'package:flutter/material.dart';
import 'package:flutter_adaptive_design/flutter_adaptive_design.dart';
import 'package:flutter_adaptive_design/testing.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  tearDown(() {
    PlatformUtils.debugOverridePlatform = null;
  });

  group('AdaptiveChip', () {
    testAdaptiveWidget('renders Chip on Android and iOS container on iOS',
        (tester, platform) async {
      await tester.pumpWidget(
        wrapAdaptiveTestWidget(
          AdaptiveChip(
            label: 'Tag',
            onTap: () {},
          ),
        ),
      );

      expect(find.text('Tag'), findsOneWidget);
      if (platform == TargetPlatform.android) {
        expect(find.byType(Chip), findsOneWidget);
      } else {
        expect(find.byType(Chip), findsNothing);
      }
    });
  });

  group('AdaptiveFilterChip', () {
    testAdaptiveWidget('renders FilterChip on Android and iOS toggle container on iOS',
        (tester, platform) async {
      await tester.pumpWidget(
        wrapAdaptiveTestWidget(
          AdaptiveFilterChip(
            label: 'Active',
            selected: true,
            onSelected: (v) {},
          ),
        ),
      );

      expect(find.text('Active'), findsOneWidget);
      if (platform == TargetPlatform.android) {
        expect(find.byType(FilterChip), findsOneWidget);
      } else {
        expect(find.byType(FilterChip), findsNothing);
      }
    });
  });
}
