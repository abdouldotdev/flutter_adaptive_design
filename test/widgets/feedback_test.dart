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
    testAdaptiveWidget(
      'renders CircularProgressIndicator on Android and CupertinoActivityIndicator on iOS',
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
      },
    );
  });

  group('AdaptiveDialog', () {
    testAdaptiveWidget('shows native dialog per platform',
        (tester, platform) async {
      int actionTapCount = 0;
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
                        isDefault: true,
                        onPressed: () => actionTapCount++,
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

      await tester.tap(find.text('OK'));
      await tester.pumpAndSettle();
      expect(actionTapCount, 1);
    });

    testAdaptiveWidget('shows Liquid Glass dialog when useLiquidGlass is true',
        (tester, platform) async {
      int cancelCount = 0;
      int confirmCount = 0;
      await tester.pumpWidget(
        wrapAdaptiveTestWidget(
          Builder(
            builder: (context) {
              return ElevatedButton(
                onPressed: () {
                  AdaptiveDialog.show(
                    context: context,
                    useLiquidGlass: true,
                    title: 'Glass Dialog',
                    content: 'Glass Content',
                    actions: [
                      AdaptiveDialogAction(
                        label: 'Cancel',
                        onPressed: () => cancelCount++,
                      ),
                      AdaptiveDialogAction(
                        label: 'Confirm',
                        isDestructive: true,
                        onPressed: () => confirmCount++,
                      ),
                    ],
                  );
                },
                child: const Text('Open Glass Dialog'),
              );
            },
          ),
        ),
      );

      await tester.tap(find.text('Open Glass Dialog'));
      await tester.pumpAndSettle();

      expect(find.text('Glass Dialog'), findsOneWidget);
      expect(find.text('Glass Content'), findsOneWidget);
      expect(find.byType(AdaptiveLiquidGlass), findsOneWidget);

      await tester.tap(find.text('Confirm'));
      await tester.pumpAndSettle();
      expect(confirmCount, 1);
    });
  });

  group('AdaptiveActionSheet', () {
    testAdaptiveWidget('shows native sheet per platform',
        (tester, platform) async {
      int actionTapped = 0;
      await tester.pumpWidget(
        wrapAdaptiveTestWidget(
          Builder(
            builder: (context) {
              return ElevatedButton(
                onPressed: () {
                  AdaptiveActionSheet.show(
                    context: context,
                    title: 'Options',
                    message: 'Choose one',
                    actions: [
                      AdaptiveSheetAction(
                        label: 'Option 1',
                        onPressed: () => actionTapped++,
                      ),
                    ],
                    cancelAction: const AdaptiveSheetAction(label: 'Cancel'),
                  );
                },
                child: const Text('Open Sheet'),
              );
            },
          ),
        ),
      );

      await tester.tap(find.text('Open Sheet'));
      await tester.pumpAndSettle();

      expect(find.text('Options'), findsOneWidget);
      expect(find.text('Choose one'), findsOneWidget);
      expect(find.text('Option 1'), findsOneWidget);

      if (platform == TargetPlatform.iOS) {
        expect(find.byType(CupertinoActionSheet), findsOneWidget);
      } else {
        expect(find.byType(BottomSheet), findsOneWidget);
      }

      await tester.tap(find.text('Option 1'));
      await tester.pumpAndSettle();
      expect(actionTapped, 1);
    });

    testAdaptiveWidget('shows Liquid Glass action sheet when useLiquidGlass is true',
        (tester, platform) async {
      int optionTapped = 0;
      await tester.pumpWidget(
        wrapAdaptiveTestWidget(
          Builder(
            builder: (context) {
              return ElevatedButton(
                onPressed: () {
                  AdaptiveActionSheet.show(
                    context: context,
                    useLiquidGlass: true,
                    title: 'Glass Sheet',
                    message: 'Glass Message',
                    actions: [
                      AdaptiveSheetAction(
                        label: 'Action 1',
                        onPressed: () => optionTapped++,
                      ),
                    ],
                    cancelAction: const AdaptiveSheetAction(label: 'Cancel'),
                  );
                },
                child: const Text('Open Glass Sheet'),
              );
            },
          ),
        ),
      );

      await tester.tap(find.text('Open Glass Sheet'));
      await tester.pumpAndSettle();

      expect(find.text('Glass Sheet'), findsOneWidget);
      expect(find.text('Action 1'), findsOneWidget);
      expect(find.byType(AdaptiveLiquidGlass), findsWidgets);

      await tester.tap(find.text('Action 1'));
      await tester.pumpAndSettle();
      expect(optionTapped, 1);
    });
  });

  group('AdaptiveSnackBar', () {
    testAdaptiveWidget('shows snack bar and triggers action',
        (tester, platform) async {
      int actionTapped = 0;
      await tester.pumpWidget(
        wrapAdaptiveTestWidget(
          AdaptiveScaffold(
            body: Builder(
              builder: (context) {
                return ElevatedButton(
                  onPressed: () {
                    AdaptiveSnackBar.show(
                      context: context,
                      message: 'Item saved',
                      actionLabel: 'Undo',
                      onAction: () => actionTapped++,
                    );
                  },
                  child: const Text('Show SnackBar'),
                );
              },
            ),
          ),
        ),
      );

      await tester.tap(find.text('Show SnackBar'));
      await tester.pumpAndSettle();

      expect(find.text('Item saved'), findsOneWidget);
      expect(find.text('Undo'), findsOneWidget);

      await tester.tap(find.text('Undo'));
      await tester.pumpAndSettle();
      expect(actionTapped, 1);
    });

    testAdaptiveWidget('shows Liquid Glass floating banner when useLiquidGlass is true',
        (tester, platform) async {
      int actionTapped = 0;
      await tester.pumpWidget(
        wrapAdaptiveTestWidget(
          Builder(
            builder: (context) {
              return ElevatedButton(
                onPressed: () {
                  AdaptiveSnackBar.show(
                    context: context,
                    useLiquidGlass: true,
                    message: 'Glass Toast Notification',
                    actionLabel: 'Dismiss',
                    onAction: () => actionTapped++,
                  );
                },
                child: const Text('Show Glass Banner'),
              );
            },
          ),
        ),
      );

      await tester.tap(find.text('Show Glass Banner'));
      await tester.pumpAndSettle();

      expect(find.text('Glass Toast Notification'), findsOneWidget);
      expect(find.byType(AdaptiveLiquidGlass), findsOneWidget);

      await tester.tap(find.text('Dismiss'));
      await tester.pumpAndSettle();
      expect(actionTapped, 1);
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
