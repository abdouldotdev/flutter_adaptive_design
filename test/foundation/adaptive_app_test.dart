import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_adaptive_design/flutter_adaptive_design.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  tearDown(() {
    PlatformUtils.debugOverridePlatform = null;
  });

  testWidgets('AdaptiveApp mounts CupertinoApp on iOS and MaterialApp on Android', (tester) async {
    PlatformUtils.debugOverridePlatform = TargetPlatform.iOS;
    await tester.pumpWidget(
      const AdaptiveApp(
        home: Text('Adaptive App iOS'),
      ),
    );
    expect(find.byType(CupertinoApp), findsOneWidget);
    expect(find.byType(MaterialApp), findsNothing);
    expect(find.text('Adaptive App iOS'), findsOneWidget);

    PlatformUtils.debugOverridePlatform = TargetPlatform.android;
    await tester.pumpWidget(
      const AdaptiveApp(
        home: Text('Adaptive App Android'),
      ),
    );
    expect(find.byType(MaterialApp), findsOneWidget);
    expect(find.byType(CupertinoApp), findsNothing);
    expect(find.text('Adaptive App Android'), findsOneWidget);
  });
}
