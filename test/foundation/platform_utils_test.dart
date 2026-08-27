import 'package:flutter/foundation.dart';
import 'package:flutter_adaptive_design/flutter_adaptive_design.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  tearDown(() {
    PlatformUtils.debugOverridePlatform = null;
    debugDefaultTargetPlatformOverride = null;
  });

  group('PlatformUtils', () {
    test('defaultTargetPlatform fallback when no override', () {
      debugDefaultTargetPlatformOverride = TargetPlatform.iOS;
      expect(PlatformUtils.isCupertino, isTrue);
      expect(PlatformUtils.isMaterial, isFalse);

      debugDefaultTargetPlatformOverride = TargetPlatform.android;
      expect(PlatformUtils.isCupertino, isFalse);
      expect(PlatformUtils.isMaterial, isTrue);
    });

    test('debugOverridePlatform overrides defaultTargetPlatform in all modes', () {
      debugDefaultTargetPlatformOverride = TargetPlatform.android;
      PlatformUtils.debugOverridePlatform = TargetPlatform.iOS;

      expect(PlatformUtils.isCupertino, isTrue);
      expect(PlatformUtils.isMaterial, isFalse);

      PlatformUtils.debugOverridePlatform = TargetPlatform.macOS;
      expect(PlatformUtils.isCupertino, isTrue);

      PlatformUtils.debugOverridePlatform = TargetPlatform.android;
      expect(PlatformUtils.isCupertino, isFalse);
      expect(PlatformUtils.isMaterial, isTrue);
    });

    test('host OS flags do not crash', () {
      expect(PlatformUtils.isWeb, isA<bool>());
      expect(PlatformUtils.isMobile, isA<bool>());
      expect(PlatformUtils.isDesktop, isA<bool>());
    });
  });
}
