import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../foundation/adaptive_icons.dart';
import '../../foundation/adaptive_tokens.dart';
import '../../foundation/platform_utils.dart';
import '../buttons/adaptive_button.dart';

/// The "there is nothing here yet" screen: an icon, a title, an optional
/// explanation and an optional call to action.
class AdaptiveEmptyState extends StatelessWidget {
  /// The glyph shown above the title, normally a constant from
  /// [AdaptiveIcons], an [IconData], or a [Widget].
  final dynamic icon;

  /// One line stating what is missing. Required.
  final String title;

  /// Optional second line explaining how the list fills up.
  final String? subtitle;

  /// Label of the call-to-action button.
  final String? actionLabel;

  /// Called when the call-to-action button is tapped.
  final VoidCallback? onAction;

  /// Size of the icon in logical pixels.
  final double iconSize;

  /// Overrides the icon colour.
  final Color? iconColor;

  /// Padding around the whole block.
  final EdgeInsetsGeometry? padding;

  const AdaptiveEmptyState({
    super.key,
    this.icon = AdaptiveIcons.info,
    required this.title,
    this.subtitle,
    this.actionLabel,
    this.onAction,
    this.iconSize = 64,
    this.iconColor,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final bool hasAction = actionLabel != null && onAction != null;

    return Center(
      child: SingleChildScrollView(
        padding: padding ?? const EdgeInsets.all(AdaptiveSpacing.xxl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            AdaptiveIcon(
              icon,
              size: iconSize,
              color: iconColor ?? AdaptiveColors.secondaryLabel(context),
            ),
            const SizedBox(height: AdaptiveSpacing.lg),
            Text(
              title,
              textAlign: TextAlign.center,
              style: _titleStyle(context),
            ),
            if (subtitle != null) ...<Widget>[
              const SizedBox(height: AdaptiveSpacing.sm),
              Text(
                subtitle!,
                textAlign: TextAlign.center,
                style: _subtitleStyle(context),
              ),
            ],
            if (hasAction) ...<Widget>[
              const SizedBox(height: AdaptiveSpacing.xl),
              AdaptiveButton(
                onPressed: onAction,
                child: Text(actionLabel!),
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

  TextStyle _subtitleStyle(BuildContext context) {
    final Color color = AdaptiveColors.secondaryLabel(context);
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
