import 'package:flutter/material.dart';
import 'package:flutter_adaptive_design/flutter_adaptive_design.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AdaptiveConstrainedContent', () {
    testWidgets('constrains child width on wide screens', (tester) async {
      tester.view.physicalSize = const Size(1200, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AdaptiveConstrainedContent(
              maxWidth: 500,
              padding: EdgeInsets.zero,
              child: Container(
                key: const ValueKey('content'),
                color: Colors.blue,
                height: 100,
              ),
            ),
          ),
        ),
      );

      final size = tester.getSize(find.byKey(const ValueKey('content')));
      expect(size.width, lessThanOrEqualTo(500));
    });
  });

  group('AdaptiveResponsiveGrid', () {
    testWidgets('lays out children in responsive grid', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AdaptiveResponsiveGrid(
              minChildWidth: 150,
              children: [
                Container(height: 50, color: Colors.red),
                Container(height: 50, color: Colors.green),
                Container(height: 50, color: Colors.blue),
              ],
            ),
          ),
        ),
      );

      expect(find.byType(AdaptiveResponsiveGrid), findsOneWidget);
    });
  });

  group('AdaptiveMasterDetail', () {
    testWidgets('renders only master on compact screen', (tester) async {
      tester.view.physicalSize = const Size(400, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: AdaptiveMasterDetail(
              master: Text('Master View'),
              detail: Text('Detail View'),
            ),
          ),
        ),
      );

      expect(find.text('Master View'), findsOneWidget);
      expect(find.text('Detail View'), findsNothing);
    });

    testWidgets('renders master and detail side-by-side on wide screen', (tester) async {
      tester.view.physicalSize = const Size(1000, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: AdaptiveMasterDetail(
              master: Text('Master View'),
              detail: Text('Detail View'),
            ),
          ),
        ),
      );

      expect(find.text('Master View'), findsOneWidget);
      expect(find.text('Detail View'), findsOneWidget);
    });
  });
}
