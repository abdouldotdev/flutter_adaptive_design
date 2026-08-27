import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_adaptive_design/flutter_adaptive_design.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AdaptiveTypography', () {
    test('material creates a complete TextTheme with correct sizes', () {
      final theme = AdaptiveTypography.material();

      expect(theme.displayLarge?.fontSize, AdaptiveTypography.displayLargeSize);
      expect(theme.titleLarge?.fontSize, AdaptiveTypography.titleLargeSize);
      expect(theme.bodyLarge?.fontSize, AdaptiveTypography.bodyLargeSize);
      expect(theme.bodyMedium?.fontSize, AdaptiveTypography.bodyMediumSize);
      expect(theme.labelSmall?.fontSize, AdaptiveTypography.labelSmallSize);
    });

    test('cupertino creates complete CupertinoTextThemeData', () {
      final theme = AdaptiveTypography.cupertino();

      expect(theme.navLargeTitleTextStyle.fontSize, 34);
      expect(theme.navTitleTextStyle.fontSize, 17);
      expect(theme.tabLabelTextStyle.fontSize, 10);
      expect(theme.textStyle.fontSize, 17);
    });

    testWidgets('AdaptiveTextScale clamps scaler properly', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: MediaQuery(
            data: const MediaQueryData(textScaler: TextScaler.linear(3.0)),
            child: Builder(
              builder: (context) {
                return AdaptiveTextScale.clamp(
                  context: context,
                  max: 1.5,
                  child: Builder(
                    builder: (innerContext) {
                      final scaler = MediaQuery.textScalerOf(innerContext);
                      expect(scaler.scale(10), lessThanOrEqualTo(15.01));
                      return const Text('Test');
                    },
                  ),
                );
              },
            ),
          ),
        ),
      );
    });
  });
}
