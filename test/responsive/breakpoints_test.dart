import 'package:flutter_adaptive_design/flutter_adaptive_design.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Breakpoints', () {
    test('fromWidth classifies sizes properly', () {
      expect(Breakpoints.fromWidth(375), ScreenSize.compact);
      expect(Breakpoints.fromWidth(599), ScreenSize.compact);
      expect(Breakpoints.fromWidth(600), ScreenSize.medium);
      expect(Breakpoints.fromWidth(839), ScreenSize.medium);
      expect(Breakpoints.fromWidth(840), ScreenSize.expanded);
      expect(Breakpoints.fromWidth(1199), ScreenSize.expanded);
      expect(Breakpoints.fromWidth(1200), ScreenSize.large);
      expect(Breakpoints.fromWidth(1920), ScreenSize.large);
    });

    test('ScreenSize enum properties and helpers', () {
      expect(ScreenSize.compact.isCompact, isTrue);
      expect(ScreenSize.medium.isCompact, isFalse);
      expect(ScreenSize.expanded.isCompact, isFalse);
      expect(ScreenSize.large.isCompact, isFalse);

      expect(ScreenSize.expanded.isAtLeast(ScreenSize.medium), isTrue);
      expect(ScreenSize.medium.isAtLeast(ScreenSize.expanded), isFalse);
    });
  });
}
