import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../foundation/adaptive_icons.dart';
import '../../foundation/adaptive_tokens.dart';
import '../../foundation/platform_utils.dart';

/// Non-blocking error, shown as a strip above the content that stays on
/// screen.
class AdaptiveErrorBanner extends StatelessWidget {
  /// What went wrong, in the user's language.
  final String message;

  /// Called when the dismiss action is tapped.
  final VoidCallback? onDismiss;

  /// Label of the dismiss action on Material.
  final String dismissLabel;

  /// Called when the retry action is tapped.
  final VoidCallback? onRetry;

  /// Label of the retry action.
  final String retryLabel;

  /// The glyph shown before the message.
  final dynamic icon;

  const AdaptiveErrorBanner({
    super.key,
    required this.message,
    this.onDismiss,
    this.dismissLabel = 'Dismiss',
    this.onRetry,
    this.retryLabel = 'Retry',
    this.icon = AdaptiveIcons.error,
  });

  @override
  Widget build(BuildContext context) {
    if (PlatformUtils.isCupertino) {
      return _buildCupertino(context);
    }
    return _buildMaterial(context);
  }

  Widget _buildCupertino(BuildContext context) {
    final Color accent = AdaptiveColors.destructive(context);

    return DecoratedBox(
      decoration: BoxDecoration(
        color: accent.withValues(alpha: 0.12),
        border: Border(
          bottom: BorderSide(color: AdaptiveColors.separator(context), width: 0),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AdaptiveSpacing.page,
          vertical: AdaptiveSpacing.sm,
        ),
        child: Row(
          children: <Widget>[
            AdaptiveIcon(icon, size: 18, color: accent),
            const SizedBox(width: AdaptiveSpacing.sm),
            Expanded(
              child: Text(
                message,
                style: CupertinoTheme.of(context)
                    .textTheme
                    .textStyle
                    .copyWith(color: AdaptiveColors.label(context)),
              ),
            ),
            if (onRetry != null)
              CupertinoButton(
                padding: EdgeInsets.zero,
                onPressed: onRetry,
                child: Text(
                  retryLabel,
                  style: CupertinoTheme.of(context)
                      .textTheme
                      .actionTextStyle
                      .copyWith(color: AdaptiveColors.primary(context)),
                ),
              ),
            if (onDismiss != null)
              CupertinoButton(
                padding: EdgeInsets.zero,
                onPressed: onDismiss,
                child: AdaptiveIcon(
                  AdaptiveIcons.close,
                  size: 18,
                  color: AdaptiveColors.secondaryLabel(context),
                  semanticLabel: dismissLabel,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildMaterial(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;
    final ButtonStyle actionStyle = TextButton.styleFrom(
      foregroundColor: scheme.onErrorContainer,
    );

    final List<Widget> actions = <Widget>[
      if (onRetry != null)
        TextButton(
          onPressed: onRetry,
          style: actionStyle,
          child: Text(retryLabel),
        ),
      if (onDismiss != null)
        TextButton(
          onPressed: onDismiss,
          style: actionStyle,
          child: Text(dismissLabel),
        ),
    ];

    if (actions.isEmpty) {
      return _buildMaterialStatic(context, scheme);
    }

    return MaterialBanner(
      backgroundColor: scheme.errorContainer,
      contentTextStyle: Theme.of(context)
          .textTheme
          .bodyMedium
          ?.copyWith(color: scheme.onErrorContainer),
      leading: AdaptiveIcon(icon, size: 24, color: scheme.onErrorContainer),
      content: Text(message),
      actions: actions,
    );
  }

  Widget _buildMaterialStatic(BuildContext context, ColorScheme scheme) {
    return Material(
      color: scheme.errorContainer,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AdaptiveSpacing.page,
          vertical: AdaptiveSpacing.md,
        ),
        child: Row(
          children: <Widget>[
            AdaptiveIcon(icon, size: 24, color: scheme.onErrorContainer),
            const SizedBox(width: AdaptiveSpacing.md),
            Expanded(
              child: Text(
                message,
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(color: scheme.onErrorContainer),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
