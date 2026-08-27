import 'package:flutter/cupertino.dart';
import 'package:flutter_adaptive_design/flutter_adaptive_design.dart';
import 'package:flutter_adaptive_design/testing.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  tearDown(() {
    PlatformUtils.debugOverridePlatform = null;
  });

  group('AdaptiveDisabled', () {
    testAdaptiveWidget('dims child when disabled is true',
        (tester, platform) async {
      await tester.pumpWidget(
        wrapAdaptiveTestWidget(
          AdaptiveDisabled(
            disabled: true,
            child: Container(
              key: const ValueKey('disabled_box'),
              child: const Text('Action'),
            ),
          ),
        ),
      );

      final ignorePointer = tester.widget<IgnorePointer>(
        find.descendant(
          of: find.byType(AdaptiveDisabled),
          matching: find.byType(IgnorePointer),
        ).first,
      );
      expect(ignorePointer.ignoring, isTrue);

      final animatedOpacity = tester.widget<AnimatedOpacity>(
        find.descendant(
          of: find.byType(AdaptiveDisabled),
          matching: find.byType(AnimatedOpacity),
        ).first,
      );
      expect(animatedOpacity.opacity, lessThan(1.0));
    });
  });

  group('AdaptiveEmptyState', () {
    testAdaptiveWidget('renders title, subtitle, and action button',
        (tester, platform) async {
      int tapCount = 0;
      await tester.pumpWidget(
        wrapAdaptiveTestWidget(
          AdaptiveEmptyState(
            title: 'No Data',
            subtitle: 'Try adding some items',
            actionLabel: 'Add Item',
            onAction: () => tapCount++,
          ),
        ),
      );

      expect(find.text('No Data'), findsOneWidget);
      expect(find.text('Try adding some items'), findsOneWidget);
      expect(find.text('Add Item'), findsOneWidget);

      await tester.tap(find.text('Add Item'));
      await tester.pump();
      expect(tapCount, 1);
    });

    testAdaptiveWidget('renders with useLiquidGlass enabled',
        (tester, platform) async {
      await tester.pumpWidget(
        wrapAdaptiveTestWidget(
          const AdaptiveEmptyState(
            useLiquidGlass: true,
            title: 'Frosted Empty State',
            subtitle: 'Looking empty and glossy',
          ),
        ),
      );

      expect(find.text('Frosted Empty State'), findsOneWidget);
      expect(find.text('Looking empty and glossy'), findsOneWidget);
      expect(find.byType(AdaptiveLiquidGlass), findsOneWidget);
    });
  });

  group('AdaptiveErrorState', () {
    testAdaptiveWidget('renders error message and retry button',
        (tester, platform) async {
      int retried = 0;
      await tester.pumpWidget(
        wrapAdaptiveTestWidget(
          AdaptiveErrorState(
            message: 'Network error occurred',
            onRetry: () => retried++,
          ),
        ),
      );

      expect(find.text('Network error occurred'), findsOneWidget);
      expect(find.text('Retry'), findsOneWidget);

      await tester.tap(find.text('Retry'));
      await tester.pump();
      expect(retried, 1);
    });

    testAdaptiveWidget('renders with useLiquidGlass enabled',
        (tester, platform) async {
      await tester.pumpWidget(
        wrapAdaptiveTestWidget(
          const AdaptiveErrorState(
            useLiquidGlass: true,
            title: 'Frosted Error',
            message: 'Failed to sync frosted data',
          ),
        ),
      );

      expect(find.text('Frosted Error'), findsOneWidget);
      expect(find.text('Failed to sync frosted data'), findsOneWidget);
      expect(find.byType(AdaptiveLiquidGlass), findsOneWidget);
    });
  });

  group('AdaptiveErrorBanner', () {
    testAdaptiveWidget('renders message and triggers retry/dismiss',
        (tester, platform) async {
      int retried = 0;
      int dismissed = 0;

      await tester.pumpWidget(
        wrapAdaptiveTestWidget(
          AdaptiveErrorBanner(
            message: 'Something went wrong',
            onRetry: () => retried++,
            onDismiss: () => dismissed++,
          ),
        ),
      );

      expect(find.text('Something went wrong'), findsOneWidget);
      expect(find.text('Retry'), findsOneWidget);

      await tester.tap(find.text('Retry'));
      await tester.pump();
      expect(retried, 1);

      if (platform == TargetPlatform.iOS) {
        final dismissBtn = find.byType(CupertinoButton).last;
        await tester.tap(dismissBtn);
      } else {
        await tester.tap(find.text('Dismiss'));
      }
      await tester.pump();
      expect(dismissed, 1);
    });

    testAdaptiveWidget('renders with useLiquidGlass on iOS',
        (tester, platform) async {
      int tapped = 0;
      await tester.pumpWidget(
        wrapAdaptiveTestWidget(
          AdaptiveErrorBanner(
            useLiquidGlass: true,
            message: 'Frosted banner message',
            onTap: () => tapped++,
          ),
        ),
      );

      expect(find.text('Frosted banner message'), findsOneWidget);

      if (platform == TargetPlatform.iOS) {
        expect(find.byType(AdaptiveLiquidGlass), findsOneWidget);
        expect(find.byType(BackdropFilter), findsOneWidget);
      }

      await tester.tap(find.text('Frosted banner message'));
      await tester.pump();
      expect(tapped, 1);
    });
  });

  group('AdaptiveLoadingOverlay & AdaptiveLoadingPage', () {
    testAdaptiveWidget('renders progress indicator when loading',
        (tester, platform) async {
      await tester.pumpWidget(
        wrapAdaptiveTestWidget(
          const AdaptiveLoadingOverlay(
            isLoading: true,
            child: Text('Content Under'),
          ),
        ),
      );

      expect(find.text('Content Under'), findsOneWidget);
      expect(find.byType(AdaptiveProgressIndicator), findsOneWidget);
    });

    testAdaptiveWidget('AdaptiveLoadingOverlay renders Liquid Glass backdrop filter',
        (tester, platform) async {
      await tester.pumpWidget(
        wrapAdaptiveTestWidget(
          const AdaptiveLoadingOverlay(
            isLoading: true,
            useLiquidGlass: true,
            blurSigma: 12.0,
            message: 'Processing Payment...',
            child: Text('Background Content'),
          ),
        ),
      );

      expect(find.text('Background Content'), findsOneWidget);
      expect(find.text('Processing Payment...'), findsOneWidget);
      expect(find.byType(BackdropFilter), findsOneWidget);
    });

    testAdaptiveWidget('AdaptiveLoadingPage renders message',
        (tester, platform) async {
      await tester.pumpWidget(
        wrapAdaptiveTestWidget(
          const AdaptiveLoadingPage(
            message: 'Loading assets...',
          ),
        ),
      );

      expect(find.text('Loading assets...'), findsOneWidget);
      expect(find.byType(AdaptiveProgressIndicator), findsOneWidget);
    });
  });

  group('AdaptiveSkeletonBox & AdaptiveShimmer', () {
    testAdaptiveWidget('renders skeleton box placeholder',
        (tester, platform) async {
      await tester.pumpWidget(
        wrapAdaptiveTestWidget(
          const AdaptiveShimmer(
            child: AdaptiveSkeletonBox(
              width: 100,
              height: 20,
            ),
          ),
        ),
      );

      expect(find.byType(AdaptiveSkeletonBox), findsOneWidget);
      expect(find.byType(AdaptiveShimmer), findsOneWidget);
    });
  });
}
