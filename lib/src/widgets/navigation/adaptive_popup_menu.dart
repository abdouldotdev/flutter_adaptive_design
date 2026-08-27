import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../foundation/platform_utils.dart';
import '../layout/adaptive_liquid_glass.dart';

/// An item for use in [AdaptivePopupMenu].
class AdaptiveMenuItem<T> {
  final String label;
  final IconData? icon;
  final T? value;
  final bool isDestructive;
  final bool enabled;

  const AdaptiveMenuItem({
    required this.label,
    this.icon,
    this.value,
    this.isDestructive = false,
    this.enabled = true,
  });
}

/// Adaptive popup menu that renders [PopupMenuButton] on Material platforms
/// and a [CupertinoActionSheet] or frosted Liquid Glass popup on Cupertino platforms.
class AdaptivePopupMenu<T> extends StatelessWidget {
  /// The child widget that triggers the menu.
  final Widget child;

  /// The icon shown in the trigger button.
  final IconData? icon;

  /// The menu items to display.
  final List<AdaptiveMenuItem<T>> items;

  /// Called when a menu item is selected.
  final ValueChanged<T?>? onSelected;

  /// Optional title for the sheet/popup.
  final String? title;

  /// Optional message for the sheet/popup.
  final String? message;

  /// Optional tooltip for the Material popup menu button.
  final String? tooltip;

  /// Whether to render with Liquid Glass frosted glass styling.
  final bool useLiquidGlass;

  const AdaptivePopupMenu({
    super.key,
    required this.child,
    required this.items,
    this.icon,
    this.onSelected,
    this.title,
    this.message,
    this.tooltip,
    this.useLiquidGlass = false,
  });

  @override
  Widget build(BuildContext context) {
    if (useLiquidGlass) {
      return GestureDetector(
        onTap: () {
          HapticFeedback.lightImpact();
          _showLiquidGlassPopup(context);
        },
        child: child,
      );
    }
    if (PlatformUtils.isCupertino) {
      return _buildCupertinoMenu(context);
    }
    return _buildMaterialMenu(context);
  }

  Widget _buildMaterialMenu(BuildContext context) {
    return PopupMenuButton<T>(
      tooltip: tooltip,
      onSelected: (val) {
        HapticFeedback.selectionClick();
        onSelected?.call(val);
      },
      itemBuilder: (context) {
        return items.map((item) {
          return PopupMenuItem<T>(
            value: item.value,
            enabled: item.enabled,
            child: Row(
              children: [
                if (item.icon != null) ...[
                  Icon(
                    item.icon,
                    size: 20,
                    color: item.isDestructive
                        ? Theme.of(context).colorScheme.error
                        : null,
                  ),
                  const SizedBox(width: 12),
                ],
                Text(
                  item.label,
                  style: TextStyle(
                    color: item.isDestructive
                        ? Theme.of(context).colorScheme.error
                        : null,
                  ),
                ),
              ],
            ),
          );
        }).toList();
      },
      child: child,
    );
  }

  Widget _buildCupertinoMenu(BuildContext context) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        _showCupertinoSheet(context);
      },
      child: child,
    );
  }

  void _showCupertinoSheet(BuildContext context) {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (context) => CupertinoActionSheet(
        title: title != null ? Text(title!) : null,
        message: message != null ? Text(message!) : null,
        actions: items
            .where((item) => item.enabled)
            .map((item) {
          return CupertinoActionSheetAction(
            onPressed: () {
              HapticFeedback.selectionClick();
              Navigator.of(context).pop();
              onSelected?.call(item.value);
            },
            isDestructiveAction: item.isDestructive,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (item.icon != null) ...[
                  Icon(item.icon, size: 20),
                  const SizedBox(width: 8),
                ],
                Text(item.label),
              ],
            ),
          );
        }).toList(),
        cancelButton: CupertinoActionSheetAction(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
      ),
    );
  }

  void _showLiquidGlassPopup(BuildContext context) {
    showCupertinoModalPopup<void>(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.3),
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AdaptiveLiquidGlass(
                variant: LiquidGlassVariant.dense,
                borderRadius: BorderRadius.circular(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (title != null || message != null) ...[
                      _buildHeader(context),
                      const Divider(height: 1, thickness: 0.5),
                    ],
                    for (final item in items.where((i) => i.enabled)) ...[
                      _buildLiquidItem(context, item),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 8),
              AdaptiveLiquidGlass(
                variant: LiquidGlassVariant.dense,
                borderRadius: BorderRadius.circular(16),
                child: CupertinoButton(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  onPressed: () => Navigator.of(context).pop(),
                  child: Center(
                    child: Text(
                      'Cancel',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        children: [
          if (title != null)
            Text(
              title!,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            ),
          if (message != null) ...[
            const SizedBox(height: 4),
            Text(
              message!,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 12),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildLiquidItem(BuildContext context, AdaptiveMenuItem<T> item) {
    final theme = Theme.of(context);
    final color = item.isDestructive
        ? theme.colorScheme.error
        : (theme.brightness == Brightness.dark ? Colors.white : Colors.black87);

    return CupertinoButton(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
      onPressed: () {
        HapticFeedback.selectionClick();
        Navigator.of(context).pop();
        onSelected?.call(item.value);
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (item.icon != null) ...[
            Icon(item.icon, size: 20, color: color),
            const SizedBox(width: 8),
          ],
          Text(
            item.label,
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.normal,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
