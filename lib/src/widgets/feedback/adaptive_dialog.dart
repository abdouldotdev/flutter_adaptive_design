import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../foundation/platform_utils.dart';
import '../layout/adaptive_liquid_glass.dart';

/// An action for use in [AdaptiveDialog].
class AdaptiveDialogAction {
  final String label;
  final VoidCallback? onPressed;
  final bool isDestructive;
  final bool isDefault;

  const AdaptiveDialogAction({
    required this.label,
    this.onPressed,
    this.isDestructive = false,
    this.isDefault = false,
  });
}

/// Adaptive dialog that renders [AlertDialog] on Material platforms
/// and [CupertinoAlertDialog] on Cupertino platforms, with optional
/// [AdaptiveLiquidGlass] frosted glass styling.
class AdaptiveDialog {
  const AdaptiveDialog._();

  /// Shows a platform-adaptive dialog.
  ///
  /// Returns the value passed to [Navigator.pop] when the dialog is dismissed.
  static Future<T?> show<T>({
    required BuildContext context,
    required String title,
    String? content,
    Widget? contentWidget,
    List<AdaptiveDialogAction> actions = const [],
    bool barrierDismissible = true,
    bool useLiquidGlass = false,
  }) {
    if (useLiquidGlass) {
      return _showLiquidGlassDialog<T>(
        context: context,
        title: title,
        content: content,
        contentWidget: contentWidget,
        actions: actions,
        barrierDismissible: barrierDismissible,
      );
    }
    if (PlatformUtils.isCupertino) {
      return _showCupertinoDialog<T>(
        context: context,
        title: title,
        content: content,
        contentWidget: contentWidget,
        actions: actions,
        barrierDismissible: barrierDismissible,
      );
    }
    return _showMaterialDialog<T>(
      context: context,
      title: title,
      content: content,
      contentWidget: contentWidget,
      actions: actions,
      barrierDismissible: barrierDismissible,
    );
  }

  static Future<T?> _showMaterialDialog<T>({
    required BuildContext context,
    required String title,
    String? content,
    Widget? contentWidget,
    required List<AdaptiveDialogAction> actions,
    required bool barrierDismissible,
  }) {
    return showDialog<T>(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: contentWidget ?? (content != null ? Text(content) : null),
        actions: actions.map((action) {
          return TextButton(
            onPressed: () {
              HapticFeedback.lightImpact();
              Navigator.of(context).pop();
              action.onPressed?.call();
            },
            child: Text(
              action.label,
              style: TextStyle(
                color: action.isDestructive
                    ? Theme.of(context).colorScheme.error
                    : null,
                fontWeight: action.isDefault ? FontWeight.bold : null,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  static Future<T?> _showCupertinoDialog<T>({
    required BuildContext context,
    required String title,
    String? content,
    Widget? contentWidget,
    required List<AdaptiveDialogAction> actions,
    required bool barrierDismissible,
  }) {
    return showCupertinoDialog<T>(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (context) => CupertinoAlertDialog(
        title: Text(title),
        content: contentWidget ?? (content != null ? Text(content) : null),
        actions: actions.map((action) {
          return CupertinoDialogAction(
            onPressed: () {
              HapticFeedback.lightImpact();
              Navigator.of(context).pop();
              action.onPressed?.call();
            },
            isDestructiveAction: action.isDestructive,
            isDefaultAction: action.isDefault,
            child: Text(action.label),
          );
        }).toList(),
      ),
    );
  }

  static Future<T?> _showLiquidGlassDialog<T>({
    required BuildContext context,
    required String title,
    String? content,
    Widget? contentWidget,
    required List<AdaptiveDialogAction> actions,
    required bool barrierDismissible,
  }) {
    return showGeneralDialog<T>(
      context: context,
      barrierDismissible: barrierDismissible,
      barrierLabel: 'Dismiss',
      barrierColor: Colors.black.withValues(alpha: 0.35),
      transitionDuration: const Duration(milliseconds: 220),
      transitionBuilder: (context, anim1, anim2, child) {
        final curved = CurvedAnimation(
          parent: anim1,
          curve: Curves.easeOutCubic,
          reverseCurve: Curves.easeInCubic,
        );
        return ScaleTransition(
          scale: Tween<double>(begin: 0.92, end: 1.0).animate(curved),
          child: FadeTransition(opacity: anim1, child: child),
        );
      },
      pageBuilder: (context, anim1, anim2) {
        return Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 300),
            margin: const EdgeInsets.symmetric(horizontal: 24),
            child: AdaptiveLiquidGlass(
              variant: LiquidGlassVariant.dense,
              borderRadius: BorderRadius.circular(20),
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                      decoration: TextDecoration.none,
                    ),
                  ),
                  if (content != null || contentWidget != null) ...[
                    const SizedBox(height: 10),
                    if (contentWidget != null)
                      contentWidget
                    else
                      Text(
                        content!,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.normal,
                          decoration: TextDecoration.none,
                        ),
                      ),
                  ],
                  const SizedBox(height: 16),
                  const Divider(height: 1, thickness: 0.5),
                  _buildLiquidActions(context, actions),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  static Widget _buildLiquidActions(
    BuildContext context,
    List<AdaptiveDialogAction> actions,
  ) {
    if (actions.length == 2) {
      return Row(
        children: [
          Expanded(child: _buildLiquidActionButton(context, actions[0])),
          const SizedBox(
            height: 44,
            child: VerticalDivider(width: 1, thickness: 0.5),
          ),
          Expanded(child: _buildLiquidActionButton(context, actions[1])),
        ],
      );
    }
    return Column(
      children: [
        for (int i = 0; i < actions.length; i++) ...[
          if (i > 0) const Divider(height: 1, thickness: 0.5),
          SizedBox(
            width: double.infinity,
            child: _buildLiquidActionButton(context, actions[i]),
          ),
        ],
      ],
    );
  }

  static Widget _buildLiquidActionButton(
    BuildContext context,
    AdaptiveDialogAction action,
  ) {
    final theme = Theme.of(context);
    final color = action.isDestructive
        ? theme.colorScheme.error
        : theme.colorScheme.primary;

    return CupertinoButton(
      padding: const EdgeInsets.symmetric(vertical: 12),
      onPressed: () {
        HapticFeedback.lightImpact();
        Navigator.of(context).pop();
        action.onPressed?.call();
      },
      child: Text(
        action.label,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 16,
          fontWeight: action.isDefault ? FontWeight.bold : FontWeight.normal,
          color: color,
        ),
      ),
    );
  }
}
