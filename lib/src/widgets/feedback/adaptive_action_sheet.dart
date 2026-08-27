import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../foundation/adaptive_icons.dart';
import '../../foundation/platform_utils.dart';
import '../layout/adaptive_liquid_glass.dart';

/// An action for use in [AdaptiveActionSheet].
class AdaptiveSheetAction {
  final String label;
  final dynamic icon;
  final VoidCallback? onPressed;
  final bool isDestructive;
  final bool isDefault;

  const AdaptiveSheetAction({
    required this.label,
    this.icon,
    this.onPressed,
    this.isDestructive = false,
    this.isDefault = false,
  });
}

/// Adaptive action sheet that renders a [BottomSheet] on Material platforms
/// and a [CupertinoActionSheet] on Cupertino platforms, with optional
/// [AdaptiveLiquidGlass] frosted glass styling.
class AdaptiveActionSheet {
  const AdaptiveActionSheet._();

  /// Shows a platform-adaptive action sheet.
  ///
  /// Returns the value passed to [Navigator.pop] when dismissed.
  static Future<T?> show<T>({
    required BuildContext context,
    String? title,
    String? message,
    required List<AdaptiveSheetAction> actions,
    AdaptiveSheetAction? cancelAction,
    bool useLiquidGlass = false,
  }) {
    if (useLiquidGlass) {
      return _showLiquidGlassSheet<T>(
        context: context,
        title: title,
        message: message,
        actions: actions,
        cancelAction: cancelAction,
      );
    }
    if (PlatformUtils.isCupertino) {
      return _showCupertinoSheet<T>(
        context: context,
        title: title,
        message: message,
        actions: actions,
        cancelAction: cancelAction,
      );
    }
    return _showMaterialSheet<T>(
      context: context,
      title: title,
      message: message,
      actions: actions,
      cancelAction: cancelAction,
    );
  }

  static Future<T?> _showMaterialSheet<T>({
    required BuildContext context,
    String? title,
    String? message,
    required List<AdaptiveSheetAction> actions,
    AdaptiveSheetAction? cancelAction,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        final theme = Theme.of(context);
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (title != null || message != null)
                  _buildMaterialHeader(context, title, message),
                if (title != null || message != null) const Divider(height: 1),
                ...actions.map((action) => _buildMaterialTile(context, action)),
                if (cancelAction != null) ...[
                  const Divider(height: 1),
                  _buildMaterialCancelTile(context, cancelAction, theme),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  static Widget _buildMaterialHeader(
    BuildContext context,
    String? title,
    String? message,
  ) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      child: Column(
        children: [
          if (title != null)
            Text(
              title,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
          if (message != null) ...[
            const SizedBox(height: 4),
            Text(
              message,
              style: theme.textTheme.bodySmall,
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }

  static Widget _buildMaterialTile(
    BuildContext context,
    AdaptiveSheetAction action,
  ) {
    final theme = Theme.of(context);
    return ListTile(
      leading: action.icon != null ? AdaptiveIcon(action.icon) : null,
      title: Text(
        action.label,
        style: TextStyle(
          color: action.isDestructive ? theme.colorScheme.error : null,
          fontWeight: action.isDefault ? FontWeight.bold : null,
        ),
      ),
      onTap: () {
        HapticFeedback.lightImpact();
        Navigator.of(context).pop();
        action.onPressed?.call();
      },
    );
  }

  static Widget _buildMaterialCancelTile(
    BuildContext context,
    AdaptiveSheetAction cancelAction,
    ThemeData theme,
  ) {
    return ListTile(
      title: Text(
        cancelAction.label,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: theme.colorScheme.primary,
          fontWeight: FontWeight.w600,
        ),
      ),
      onTap: () {
        HapticFeedback.lightImpact();
        Navigator.of(context).pop();
        cancelAction.onPressed?.call();
      },
    );
  }

  static Future<T?> _showCupertinoSheet<T>({
    required BuildContext context,
    String? title,
    String? message,
    required List<AdaptiveSheetAction> actions,
    AdaptiveSheetAction? cancelAction,
  }) {
    return showCupertinoModalPopup<T>(
      context: context,
      builder: (context) => CupertinoActionSheet(
        title: title != null ? Text(title) : null,
        message: message != null ? Text(message) : null,
        actions: actions.map((action) {
          return CupertinoActionSheetAction(
            onPressed: () {
              HapticFeedback.lightImpact();
              Navigator.of(context).pop();
              action.onPressed?.call();
            },
            isDestructiveAction: action.isDestructive,
            isDefaultAction: action.isDefault,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (action.icon != null) ...[
                  AdaptiveIcon(action.icon),
                  const SizedBox(width: 8),
                ],
                Text(action.label),
              ],
            ),
          );
        }).toList(),
        cancelButton: cancelAction != null
            ? CupertinoActionSheetAction(
                onPressed: () {
                  HapticFeedback.lightImpact();
                  Navigator.of(context).pop();
                  cancelAction.onPressed?.call();
                },
                child: Text(cancelAction.label),
              )
            : null,
      ),
    );
  }

  static Future<T?> _showLiquidGlassSheet<T>({
    required BuildContext context,
    String? title,
    String? message,
    required List<AdaptiveSheetAction> actions,
    AdaptiveSheetAction? cancelAction,
  }) {
    return showCupertinoModalPopup<T>(
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
                      _buildLiquidGlassHeader(context, title, message),
                      const Divider(height: 1, thickness: 0.5),
                    ],
                    for (int i = 0; i < actions.length; i++) ...[
                      if (i > 0) const Divider(height: 1, thickness: 0.5),
                      _buildLiquidGlassAction(context, actions[i]),
                    ],
                  ],
                ),
              ),
              if (cancelAction != null) ...[
                const SizedBox(height: 8),
                AdaptiveLiquidGlass(
                  variant: LiquidGlassVariant.dense,
                  borderRadius: BorderRadius.circular(16),
                  child: _buildLiquidGlassAction(
                    context,
                    cancelAction,
                    isCancel: true,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  static Widget _buildLiquidGlassHeader(
    BuildContext context,
    String? title,
    String? message,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Column(
        children: [
          if (title != null)
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                decoration: TextDecoration.none,
              ),
            ),
          if (message != null) ...[
            const SizedBox(height: 4),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.normal,
                decoration: TextDecoration.none,
              ),
            ),
          ],
        ],
      ),
    );
  }

  static Widget _buildLiquidGlassAction(
    BuildContext context,
    AdaptiveSheetAction action, {
    bool isCancel = false,
  }) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final color = action.isDestructive
        ? theme.colorScheme.error
        : (isCancel || action.isDefault
            ? theme.colorScheme.primary
            : (isDark ? Colors.white : Colors.black87));

    return CupertinoButton(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
      onPressed: () {
        HapticFeedback.lightImpact();
        Navigator.of(context).pop();
        action.onPressed?.call();
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (action.icon != null) ...[
            AdaptiveIcon(action.icon, color: color, size: 20),
            const SizedBox(width: 8),
          ],
          Text(
            action.label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 17,
              fontWeight: isCancel || action.isDefault
                  ? FontWeight.w600
                  : FontWeight.normal,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
