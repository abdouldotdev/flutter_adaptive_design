import 'package:flutter/material.dart';
import 'package:flutter_adaptive_design/flutter_adaptive_design.dart';

class AdaptiveAppController extends InheritedWidget {
  final TargetPlatform platform;
  final ThemeMode themeMode;
  final VoidCallback onTogglePlatform;
  final VoidCallback onToggleTheme;

  const AdaptiveAppController({
    super.key,
    required this.platform,
    required this.themeMode,
    required this.onTogglePlatform,
    required this.onToggleTheme,
    required super.child,
  });

  static AdaptiveAppController of(BuildContext context) {
    final result =
        context.dependOnInheritedWidgetOfExactType<AdaptiveAppController>();
    assert(result != null, 'No AdaptiveAppController found in context');
    return result!;
  }

  static AdaptiveAppController? maybeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<AdaptiveAppController>();
  }

  bool get isCupertino => platform == TargetPlatform.iOS;
  bool get isDark => themeMode == ThemeMode.dark;

  @override
  bool updateShouldNotify(AdaptiveAppController oldWidget) {
    return platform != oldWidget.platform || themeMode != oldWidget.themeMode;
  }
}

class PlatformSwitchAction extends StatelessWidget {
  const PlatformSwitchAction({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = AdaptiveAppController.maybeOf(context);
    if (controller == null) return const SizedBox.shrink();

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        AdaptiveIconButton(
          onPressed: controller.onTogglePlatform,
          icon: Icon(
            controller.isCupertino ? Icons.phone_iphone : Icons.android,
            color: controller.isCupertino ? Colors.blue : Colors.green,
          ),
        ),
        AdaptiveIconButton(
          onPressed: controller.onToggleTheme,
          icon: Icon(
            controller.isDark ? Icons.light_mode : Icons.dark_mode,
          ),
        ),
      ],
    );
  }
}
