import 'package:flutter/material.dart';
import 'package:flutter_adaptive_design/flutter_adaptive_design.dart';
import 'package:flutter_adaptive_design_example/app_controller.dart';
import 'package:flutter_adaptive_design_example/main.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  tearDown(() {
    PlatformUtils.debugOverridePlatform = null;
  });

  testWidgets('AdaptiveGalleryApp mounts and renders top catalog items', (tester) async {
    await tester.pumpWidget(const AdaptiveGalleryApp());
    await tester.pumpAndSettle();

    expect(find.text('Adaptive Design Gallery'), findsOneWidget);
    expect(find.text('Buttons & Actions'), findsOneWidget);
    expect(find.text('Forms & Inputs'), findsOneWidget);
    expect(find.text('Layout & Lists'), findsOneWidget);
  });

  testWidgets('Navigates to Buttons & Actions and triggers increment', (tester) async {
    await tester.pumpWidget(const AdaptiveGalleryApp());
    await tester.pumpAndSettle();

    await tester.tap(find.text('Buttons & Actions'));
    await tester.pumpAndSettle();

    expect(find.text('Tap Count: 0'), findsOneWidget);
    await tester.tap(find.text('Primary Button'));
    await tester.pump();
    expect(find.text('Tap Count: 1'), findsOneWidget);
  });

  testWidgets('Navigates to Forms & Inputs', (tester) async {
    await tester.pumpWidget(const AdaptiveGalleryApp());
    await tester.pumpAndSettle();

    await tester.tap(find.text('Forms & Inputs'));
    await tester.pumpAndSettle();

    expect(find.text('Text Fields & Form Fields'), findsOneWidget);
    expect(find.text('Biometric Authentication'), findsOneWidget);
  });

  testWidgets('Live toggles platform from iOS to Android', (tester) async {
    await tester.pumpWidget(const AdaptiveGalleryApp());
    await tester.pumpAndSettle();

    expect(find.textContaining('Active Shell: iOS'), findsOneWidget);

    final switchFinder = find.descendant(
      of: find.byType(PlatformSwitchAction),
      matching: find.byIcon(Icons.phone_iphone),
    );
    await tester.tap(switchFinder);
    await tester.pumpAndSettle();

    expect(find.textContaining('Active Shell: Android'), findsOneWidget);
  });

  testWidgets('Scrolls to and navigates to Responsive Screen', (tester) async {
    await tester.pumpWidget(const AdaptiveGalleryApp());
    await tester.pumpAndSettle();

    final itemFinder = find.text('Responsive & Multi-Device');
    await tester.scrollUntilVisible(
      itemFinder,
      100.0,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pumpAndSettle();

    await tester.tap(itemFinder);
    await tester.pumpAndSettle();

    expect(find.text('Grid / Width'), findsOneWidget);
    expect(find.text('Master-Detail'), findsOneWidget);
  });
}
