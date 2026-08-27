import 'package:flutter_adaptive_design/adaptive.dart';
import 'package:flutter_adaptive_design/flutter_adaptive_design.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('barrel exports are defined and non-null', () {
    expect(PlatformUtils.isCupertino, isA<bool>());
    expect(AdaptiveSpacing.page, 16);
    expect(AdaptiveRadius.card, isA<double>());
    expect(Breakpoints.compact, 600);
  });
}
