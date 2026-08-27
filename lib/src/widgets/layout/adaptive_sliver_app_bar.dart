import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../foundation/platform_utils.dart';

/// Adaptive sliver app bar for use inside a [CustomScrollView].
///
/// Material: [SliverAppBar] with expandable/collapsible behavior.
/// Cupertino: [CupertinoSliverNavigationBar] with large title and optional
/// Liquid Glass frosted blur via [useLiquidGlass].
class AdaptiveSliverAppBar extends StatelessWidget {
  final String? title;
  final Widget? titleWidget;
  final Widget? leading;
  final List<Widget>? actions;
  final bool automaticallyImplyLeading;
  final Color? backgroundColor;
  final bool pinned;
  final bool floating;
  final double? expandedHeight;
  final Widget? flexibleSpace;
  final bool stretch;
  final String? previousPageTitle;

  /// Whether to render with modern Liquid Glass (frosted blur) styling on iOS.
  final bool useLiquidGlass;

  const AdaptiveSliverAppBar({
    super.key,
    this.title,
    this.titleWidget,
    this.leading,
    this.actions,
    this.automaticallyImplyLeading = true,
    this.backgroundColor,
    this.pinned = true,
    this.floating = false,
    this.expandedHeight,
    this.flexibleSpace,
    this.stretch = false,
    this.previousPageTitle,
    this.useLiquidGlass = false,
  });

  @override
  Widget build(BuildContext context) {
    if (PlatformUtils.isCupertino) {
      return _buildCupertino(context);
    }
    return _buildMaterial(context);
  }

  Widget _buildMaterial(BuildContext context) {
    final theme = Theme.of(context);
    return SliverAppBar(
      title: titleWidget ?? (title != null ? Text(title!) : null),
      leading: leading,
      actions: actions,
      automaticallyImplyLeading: automaticallyImplyLeading,
      backgroundColor: backgroundColor ??
          (useLiquidGlass ? theme.colorScheme.surfaceContainer : null),
      elevation: useLiquidGlass ? 2.0 : null,
      scrolledUnderElevation: useLiquidGlass ? 3.0 : null,
      pinned: pinned,
      floating: floating,
      expandedHeight: expandedHeight,
      flexibleSpace: flexibleSpace,
      stretch: stretch,
    );
  }

  Widget _buildCupertino(BuildContext context) {
    final isDark = CupertinoTheme.brightnessOf(context) == Brightness.dark;
    return CupertinoSliverNavigationBar(
      largeTitle: titleWidget ?? (title != null ? Text(title!) : null),
      leading: leading,
      trailing: _buildCupertinoTrailing(),
      automaticallyImplyLeading: automaticallyImplyLeading,
      backgroundColor: _resolveCupertinoBackground(isDark),
      previousPageTitle: previousPageTitle,
      stretch: stretch,
      border: _resolveCupertinoBorder(isDark),
    );
  }

  Widget? _buildCupertinoTrailing() {
    if (actions == null || actions!.isEmpty) return null;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: actions!,
    );
  }

  Color? _resolveCupertinoBackground(bool isDark) {
    if (!useLiquidGlass) return backgroundColor;
    return backgroundColor ??
        (isDark
            ? const Color(0xFF1E1E1E).withValues(alpha: 0.65)
            : const Color(0xFFFFFFFF).withValues(alpha: 0.75));
  }

  Border? _resolveCupertinoBorder(bool isDark) {
    if (!useLiquidGlass) {
      return const Border(
        bottom: BorderSide(
          color: CupertinoColors.separator,
          width: 0.0,
        ),
      );
    }
    return Border(
      bottom: BorderSide(
        color: isDark
            ? Colors.white.withValues(alpha: 0.15)
            : Colors.black.withValues(alpha: 0.1),
        width: 0.5,
      ),
    );
  }
}
