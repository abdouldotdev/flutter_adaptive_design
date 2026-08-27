import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../foundation/platform_utils.dart';

/// The two platforms every adaptive widget branches on.
const List<TargetPlatform> kAdaptivePlatforms = <TargetPlatform>[
  TargetPlatform.android,
  TargetPlatform.iOS,
];

/// Minimum touch target per Apple Human Interface Guidelines: 44x44 pt.
const double kCupertinoMinTouchTarget = 44;

/// Minimum touch target per Material 3 accessibility guidance: 48x48 dp.
const double kMaterialMinTouchTarget = 48;

/// Runs [body] once per entry in [platforms], with the platform forced.
///
/// Ensures both Cupertino and Material branches are exercised in unit and widget tests.
/// The forced [platform] is automatically reset in a `finally` block to prevent test contamination.
void testAdaptiveWidget(
  String description,
  Future<void> Function(WidgetTester tester, TargetPlatform platform) body, {
  List<TargetPlatform> platforms = kAdaptivePlatforms,
  bool overrideFrameworkPlatform = true,
}) {
  for (final TargetPlatform platform in platforms) {
    testWidgets('$description · ${platform.name}', (WidgetTester tester) async {
      PlatformUtils.debugOverridePlatform = platform;
      if (overrideFrameworkPlatform) {
        debugDefaultTargetPlatformOverride = platform;
      }
      try {
        await body(tester, platform);
      } finally {
        PlatformUtils.debugOverridePlatform = null;
        debugDefaultTargetPlatformOverride = null;
      }
    });
  }
}

/// Helper to wrap a widget inside the appropriate native shell (CupertinoApp / MaterialApp).
Widget wrapAdaptiveTestWidget(
  Widget child, {
  TextScaler textScaler = TextScaler.noScaling,
  ThemeData? materialTheme,
  CupertinoThemeData? cupertinoTheme,
}) {
  final Widget body = Builder(
    builder: (BuildContext context) {
      return MediaQuery(
        data: MediaQuery.of(context).copyWith(textScaler: textScaler),
        child: Center(child: child),
      );
    },
  );

  if (PlatformUtils.isCupertino) {
    return CupertinoApp(
      theme: cupertinoTheme,
      home: body,
    );
  }

  return MaterialApp(
    theme: materialTheme ?? ThemeData(platform: TargetPlatform.android),
    home: Material(child: body),
  );
}
