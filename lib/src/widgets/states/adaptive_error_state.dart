import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../foundation/adaptive_icons.dart';
import '../../foundation/adaptive_tokens.dart';
import '../../foundation/platform_utils.dart';
import '../buttons/adaptive_text_button.dart';

/// Blocking error state: what a screen shows instead of its content when the
/// content could not be loaded.
class AdaptiveErrorState extends StatelessWidget {
  /// What went wrong, in the user's language.
  final String message;

  /// Optional short headline above [message], e.g. `'Something went wrong'`.
  final String? title;

  /// Called when the retry action is tapped.
  final VoidCallback? onRetry;

  /// Label of the retry action.
  final String retryLabel;

  /// The glyph shown above the message (HugeIcons data, IconData, or Widget).
  final dynamic icon;

  /// Size of the icon in logical pixels.
  final double iconSize;

  /// Padding around the whole block.
  final EdgeInsetsGeometry? padding;

  const AdaptiveErrorState({
    super.key,
    required this.message,
    this.title,
    this.onRetry,
    this.retryLabel = 'Retry',
    this.icon = AdaptiveIcons.error,
    this.iconSize = 48,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: padding ?? const EdgeInsets.all(AdaptiveSpacing.xxl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            AdaptiveIcon(
              icon,
              size: iconSize,
              color: AdaptiveColors.destructive(context),
            ),
            const SizedBox(height: AdaptiveSpacing.lg),
            if (title != null) ...<Widget>[
              Text(
                title!,
                textAlign: TextAlign.center,
                style: _titleStyle(context),
              ),
              const SizedBox(height: AdaptiveSpacing.sm),
            ],
            Text(
              message,
              textAlign: TextAlign.center,
              style: _messageStyle(context),
            ),
            if (onRetry != null) ...<Widget>[
              const SizedBox(height: AdaptiveSpacing.lg),
              AdaptiveTextButton(
                onPressed: onRetry,
                color: AdaptiveColors.primary(context),
                child: Text(retryLabel),
              ),
            ],
          ],
        ),
      ),
    );
  }

  TextStyle _titleStyle(BuildContext context) {
    final Color color = AdaptiveColors.label(context);
    if (PlatformUtils.isCupertino) {
      return CupertinoTheme.of(context)
          .textTheme
          .navTitleTextStyle
          .copyWith(color: color);
    }
    return Theme.of(context).textTheme.titleMedium?.copyWith(color: color) ??
        TextStyle(color: color);
  }

  TextStyle _messageStyle(BuildContext context) {
    final Color color = AdaptiveColors.label(context);
    if (PlatformUtils.isCupertino) {
      return CupertinoTheme.of(context)
          .textTheme
          .textStyle
          .copyWith(color: color);
    }
    return Theme.of(context).textTheme.bodyMedium?.copyWith(color: color) ??
        TextStyle(color: color);
  }
}
