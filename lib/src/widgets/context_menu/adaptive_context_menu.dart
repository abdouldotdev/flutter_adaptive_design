import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../foundation/platform_utils.dart';
import '../layout/adaptive_liquid_glass.dart';

/// An action for use in [AdaptiveContextMenu].
class ContextMenuAction {
  final String label;
  final IconData? icon;
  final VoidCallback? onPressed;
  final bool isDestructive;

  const ContextMenuAction({
    required this.label,
    this.icon,
    this.onPressed,
    this.isDestructive = false,
  });
}

/// Adaptive context menu that renders [CupertinoContextMenu] on Cupertino platforms
/// and a popup menu with optional Liquid Glass frosted glass rendering on Material.
class AdaptiveContextMenu extends StatelessWidget {
  /// The child widget that triggers the context menu on long press.
  final Widget child;

  /// A preview widget shown during the Cupertino context menu (iOS 13+ style).
  /// If null, the [child] is used as the preview.
  final Widget? previewBuilder;

  /// The context menu actions.
  final List<ContextMenuAction> actions;

  /// Whether to render the context menu with Liquid Glass (frosted blur) styling.
  final bool useLiquidGlass;

  const AdaptiveContextMenu({
    super.key,
    required this.child,
    required this.actions,
    this.previewBuilder,
    this.useLiquidGlass = false,
  });

  @override
  Widget build(BuildContext context) {
    if (PlatformUtils.isCupertino) {
      return _buildCupertinoContextMenu(context);
    }
    return _buildMaterialContextMenu(context);
  }

  Widget _buildMaterialContextMenu(BuildContext context) {
    return GestureDetector(
      onLongPressStart: (details) {
        HapticFeedback.lightImpact();
        if (useLiquidGlass) {
          _showLiquidGlassMenu(context, details.globalPosition);
        } else {
          _showMaterialMenu(context, details.globalPosition);
        }
      },
      child: child,
    );
  }

  void _showMaterialMenu(BuildContext context, Offset position) {
    final items = actions.map((action) {
      return PopupMenuItem<ContextMenuAction>(
        value: action,
        child: Row(
          children: [
            if (action.icon != null) ...[
              Icon(
                action.icon,
                size: 20,
                color: action.isDestructive
                    ? Theme.of(context).colorScheme.error
                    : null,
              ),
              const SizedBox(width: 12),
            ],
            Text(
              action.label,
              style: TextStyle(
                color: action.isDestructive
                    ? Theme.of(context).colorScheme.error
                    : null,
              ),
            ),
          ],
        ),
      );
    }).toList();

    showMenu<ContextMenuAction>(
      context: context,
      position: RelativeRect.fromLTRB(
        position.dx,
        position.dy,
        position.dx + 1,
        position.dy + 1,
      ),
      items: items,
    ).then((selectedAction) {
      if (selectedAction != null) {
        HapticFeedback.selectionClick();
        selectedAction.onPressed?.call();
      }
    });
  }

  void _showLiquidGlassMenu(BuildContext context, Offset position) {
    showGeneralDialog<ContextMenuAction>(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Dismiss',
      barrierColor: Colors.black.withValues(alpha: 0.25),
      transitionDuration: const Duration(milliseconds: 180),
      transitionBuilder: (context, anim1, anim2, child) {
        final curved = CurvedAnimation(
          parent: anim1,
          curve: Curves.easeOutCubic,
          reverseCurve: Curves.easeInCubic,
        );
        return ScaleTransition(
          alignment: Alignment.topLeft,
          scale: Tween<double>(begin: 0.85, end: 1.0).animate(curved),
          child: FadeTransition(opacity: anim1, child: child),
        );
      },
      pageBuilder: (context, anim1, anim2) {
        final screenSize = MediaQuery.of(context).size;
        final left = position.dx.clamp(16.0, screenSize.width - 220.0);
        final top = position.dy.clamp(16.0, screenSize.height - (actions.length * 48.0 + 32.0));

        return Stack(
          children: [
            Positioned(
              left: left,
              top: top,
              child: SizedBox(
                width: 200,
                child: AdaptiveLiquidGlass(
                  variant: LiquidGlassVariant.dense,
                  borderRadius: BorderRadius.circular(14),
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      for (int i = 0; i < actions.length; i++) ...[
                        if (i > 0) const Divider(height: 1, thickness: 0.5),
                        _buildLiquidMenuItem(context, actions[i]),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildLiquidMenuItem(BuildContext context, ContextMenuAction action) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final color = action.isDestructive
        ? theme.colorScheme.error
        : (isDark ? Colors.white : Colors.black87);

    return CupertinoButton(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      onPressed: () {
        HapticFeedback.selectionClick();
        Navigator.of(context).pop();
        action.onPressed?.call();
      },
      child: Row(
        children: [
          if (action.icon != null) ...[
            Icon(action.icon, size: 18, color: color),
            const SizedBox(width: 10),
          ],
          Expanded(
            child: Text(
              action.label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: color,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCupertinoContextMenu(BuildContext context) {
    return CupertinoContextMenu(
      actions: actions.map((action) {
        return CupertinoContextMenuAction(
          onPressed: () {
            HapticFeedback.selectionClick();
            Navigator.of(context).pop();
            action.onPressed?.call();
          },
          isDestructiveAction: action.isDestructive,
          trailingIcon: action.icon,
          child: Text(action.label),
        );
      }).toList(),
      child: previewBuilder ?? child,
    );
  }
}
