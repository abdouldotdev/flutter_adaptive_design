import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../foundation/platform_utils.dart';

/// Adaptive app bar that renders [AppBar] on Material and
/// [CupertinoNavigationBar] on Cupertino.
///
/// Supports optional Liquid Glass frosted blur via [useLiquidGlass].
class AdaptiveAppBar extends StatelessWidget
    implements PreferredSizeWidget, ObstructingPreferredSizeWidget {
  final String? title;
  final Widget? titleWidget;
  final Widget? leading;
  final List<Widget>? actions;
  final bool automaticallyImplyLeading;
  final Color? backgroundColor;
  final double? elevation;
  final bool centerTitle;
  final Widget? bottom;
  final bool useLiquidGlass;

  const AdaptiveAppBar({
    super.key,
    this.title,
    this.titleWidget,
    this.leading,
    this.actions,
    this.automaticallyImplyLeading = true,
    this.backgroundColor,
    this.elevation,
    this.centerTitle = true,
    this.bottom,
    this.useLiquidGlass = false,
  });

  @override
  Size get preferredSize {
    final bottomHeight = bottom != null ? kTextTabBarHeight : 0.0;
    final baseHeight = PlatformUtils.isCupertino ? 44.0 : kToolbarHeight;
    return Size.fromHeight(baseHeight + bottomHeight);
  }

  @override
  bool shouldFullyObstruct(BuildContext context) => !useLiquidGlass;

  @override
  Widget build(BuildContext context) {
    if (PlatformUtils.isCupertino) {
      return _buildCupertino(context);
    }
    return _buildMaterial(context);
  }

  Widget _buildMaterial(BuildContext context) {
    final theme = Theme.of(context);
    return AppBar(
      title: titleWidget ?? (title != null ? Text(title!) : null),
      leading: leading,
      actions: actions,
      automaticallyImplyLeading: automaticallyImplyLeading,
      backgroundColor: backgroundColor ??
          (useLiquidGlass ? theme.colorScheme.surfaceContainer : null),
      elevation: elevation ?? (useLiquidGlass ? 2.0 : null),
      centerTitle: centerTitle,
      bottom: bottom != null
          ? PreferredSize(
              preferredSize: const Size.fromHeight(kTextTabBarHeight),
              child: bottom!,
            )
          : null,
    );
  }

  Widget _buildCupertino(BuildContext context) {
    final isDark = CupertinoTheme.brightnessOf(context) == Brightness.dark;
    final navBar = CupertinoNavigationBar(
      middle: titleWidget ?? (title != null ? Text(title!) : null),
      leading: leading,
      trailing: _buildCupertinoTrailing(),
      automaticallyImplyLeading: automaticallyImplyLeading,
      backgroundColor: _resolveCupertinoBackground(isDark),
      border: _resolveCupertinoBorder(isDark),
    );

    if (useLiquidGlass) {
      return ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: navBar,
        ),
      );
    }

    return navBar;
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
