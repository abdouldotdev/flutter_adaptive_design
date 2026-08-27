import 'package:flutter_adaptive_design/flutter_adaptive_design.dart';
import 'package:flutter_adaptive_design_example/main.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  tearDown(() {
    PlatformUtils.debugOverridePlatform = null;
  });

  testWidgets('AdaptiveGalleryApp mounts and renders catalog categories', (tester) async {
    await tester.pumpWidget(const AdaptiveGalleryApp());
    await tester.pumpAndSettle();

    expect(find.text('Adaptive Design Gallery'), findsOneWidget);
    expect(find.text('Buttons & Actions'), findsOneWidget);
    expect(find.text('Forms & Inputs'), findsOneWidget);
    expect(find.text('Layout & Navigation'), findsOneWidget);
  });
}
