import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../foundation/adaptive_icons.dart';
import '../../foundation/adaptive_tokens.dart';
import '../../foundation/platform_utils.dart';

import '../layout/adaptive_liquid_glass.dart';

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

  /// Whether to render with modern Liquid Glass (frosted blur) styling.
  final bool useLiquidGlass;

  /// Optional tap callback for the entire banner.
  final VoidCallback? onTap;

  /// Corner radius when [useLiquidGlass] is true.
  final BorderRadius? borderRadius;

  const AdaptiveErrorBanner({
    super.key,
    required this.message,
    this.onDismiss,
    this.dismissLabel = 'Dismiss',
    this.onRetry,
    this.retryLabel = 'Retry',
    this.icon = AdaptiveIcons.error,
    this.useLiquidGlass = false,
    this.onTap,
    this.borderRadius,
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

    if (useLiquidGlass) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        child: AdaptiveLiquidGlass(
          variant: LiquidGlassVariant.ultraThin,
          borderRadius: borderRadius ?? BorderRadius.circular(12),
          tintColor: accent.withValues(alpha: 0.15),
          borderColor: accent.withValues(alpha: 0.3),
          padding: const EdgeInsets.symmetric(
            horizontal: AdaptiveSpacing.page,
            vertical: AdaptiveSpacing.sm,
          ),
          onTap: onTap,
          enableSpringFeedback: onTap != null,
          child: _buildBannerRow(context, accent),
        ),
      );
    }

    Widget banner = DecoratedBox(
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
        child: _buildBannerRow(context, accent),
      ),
    );

    if (onTap != null) {
      banner = GestureDetector(
        onTap: onTap,
        child: banner,
      );
    }

    return banner;
  }

  Widget _buildBannerRow(BuildContext context, Color accent) {
    return Row(
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

    Widget banner = MaterialBanner(
      backgroundColor: scheme.errorContainer,
      contentTextStyle: Theme.of(context)
          .textTheme
          .bodyMedium
          ?.copyWith(color: scheme.onErrorContainer),
      leading: AdaptiveIcon(icon, size: 24, color: scheme.onErrorContainer),
      content: Text(message),
      actions: actions,
    );

    if (onTap != null) {
      banner = InkWell(
        onTap: onTap,
        child: banner,
      );
    }

    return banner;
  }

  Widget _buildMaterialStatic(BuildContext context, ColorScheme scheme) {
    Widget content = Padding(
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
    );

    if (onTap != null) {
      content = InkWell(
        onTap: onTap,
        child: content,
      );
    }

    return Material(
      color: scheme.errorContainer,
      child: content,
    );
  }
}
