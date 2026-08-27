import 'package:flutter/material.dart';
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
    });
  });
}
