import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_adaptive_design/flutter_adaptive_design.dart';
import 'package:flutter_adaptive_design/testing.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  tearDown(() {
    PlatformUtils.debugOverridePlatform = null;
  });

  group('AdaptiveProgressIndicator', () {
    testAdaptiveWidget('renders CircularProgressIndicator on Android and CupertinoActivityIndicator on iOS',
        (tester, platform) async {
      await tester.pumpWidget(
        wrapAdaptiveTestWidget(
          const AdaptiveProgressIndicator(),
        ),
      );

      if (platform == TargetPlatform.iOS) {
        expect(find.byType(CupertinoActivityIndicator), findsOneWidget);
        expect(find.byType(CircularProgressIndicator), findsNothing);
      } else {
        expect(find.byType(CircularProgressIndicator), findsOneWidget);
        expect(find.byType(CupertinoActivityIndicator), findsNothing);
      }
    });
  });

  group('AdaptiveDialog', () {
    testAdaptiveWidget('shows native dialog per platform',
        (tester, platform) async {
      await tester.pumpWidget(
        wrapAdaptiveTestWidget(
          Builder(
            builder: (context) {
              return ElevatedButton(
                onPressed: () {
                  AdaptiveDialog.show(
                    context: context,
                    title: 'Dialog Title',
                    content: 'Dialog Body',
                    actions: [
                      AdaptiveDialogAction(
                        label: 'OK',
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  );
                },
                child: const Text('Open Dialog'),
              );
            },
          ),
        ),
      );

      await tester.tap(find.text('Open Dialog'));
      await tester.pumpAndSettle();

      expect(find.text('Dialog Title'), findsOneWidget);
      expect(find.text('Dialog Body'), findsOneWidget);

      if (platform == TargetPlatform.iOS) {
        expect(find.byType(CupertinoAlertDialog), findsOneWidget);
      } else {
        expect(find.byType(AlertDialog), findsOneWidget);
      }
    });
  });

  group('AdaptiveTooltip', () {
    testAdaptiveWidget('renders Tooltip on Android and custom gesture on iOS',
        (tester, platform) async {
      await tester.pumpWidget(
        wrapAdaptiveTestWidget(
          const AdaptiveTooltip(
            message: 'Help Info',
            child: Text('Hover Me'),
          ),
        ),
      );

      expect(find.text('Hover Me'), findsOneWidget);
      if (platform == TargetPlatform.android) {
        expect(find.byType(Tooltip), findsOneWidget);
      }
    });
  });
}
