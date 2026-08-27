import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../foundation/platform_widget.dart';
import 'adaptive_liquid_glass.dart';

/// Adaptive card widget.
///
/// Material: [Card] with M3 styling (elevation, shape).
/// Cupertino: [Container] or [AdaptiveLiquidGlass] with rounded corners
/// and subtle background / frosted glass.
class AdaptiveCard extends PlatformWidget<Card, Widget> {
  final Widget? child;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;
  final Color? color;
  final double? elevation;
  final ShapeBorder? shape;
  final double borderRadius;
  final VoidCallback? onTap;
  final bool useLiquidGlass;
  final bool enableSpringFeedback;

  const AdaptiveCard({
    super.key,
    this.child,
    this.margin,
    this.padding,
    this.color,
    this.elevation,
    this.shape,
    this.borderRadius = 12.0,
    this.onTap,
    this.useLiquidGlass = false,
    this.enableSpringFeedback = true,
  });

  @override
  Card buildMaterialWidget(BuildContext context) {
    final content = padding != null
        ? Padding(padding: padding!, child: child)
        : child;

    return Card(
      margin: margin ?? const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: color,
      elevation: elevation,
      shape: shape ??
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
      child: onTap != null
          ? InkWell(
              borderRadius: BorderRadius.circular(borderRadius),
              onTap: onTap,
              child: content,
            )
          : content,
    );
  }

  @override
  Widget buildCupertinoWidget(BuildContext context) {
    final effectiveMargin =
        margin ?? const EdgeInsets.symmetric(horizontal: 16, vertical: 8);

    if (useLiquidGlass) {
      return Padding(
        padding: effectiveMargin,
        child: AdaptiveLiquidGlass(
          borderRadius: BorderRadius.circular(borderRadius),
          padding: padding ?? EdgeInsets.zero,
          tintColor: color,
          onTap: onTap,
          enableSpringFeedback: enableSpringFeedback,
          child: child ?? const SizedBox.shrink(),
        ),
      );
    }

    final brightness = CupertinoTheme.maybeBrightnessOf(context) ??
        MediaQuery.maybePlatformBrightnessOf(context) ??
        Brightness.light;
    final resolvedColor = color ??
        (brightness == Brightness.dark
            ? const Color(0xFF1C1C1E)
            : CupertinoColors.white);

    Widget content = Container(
      margin: effectiveMargin,
      padding: padding,
      decoration: BoxDecoration(
        color: resolvedColor,
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: [
          BoxShadow(
            color: CupertinoColors.systemGrey.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: child,
    );

    if (onTap != null) {
      content = GestureDetector(
        onTap: onTap,
        child: content,
      );
    }

    return content;
  }
}
