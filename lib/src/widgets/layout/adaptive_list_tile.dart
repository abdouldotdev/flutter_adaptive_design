import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../foundation/platform_widget.dart';
import 'adaptive_liquid_glass.dart';

/// Adaptive list tile.
///
/// Material: [ListTile] with M3 styling.
/// Cupertino: [CupertinoListTile] or [AdaptiveLiquidGlass] with iOS styling.
class AdaptiveListTile extends PlatformWidget<ListTile, Widget> {
  final Widget? title;
  final Widget? subtitle;
  final Widget? leading;
  final Widget? trailing;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final bool enabled;
  final EdgeInsetsGeometry? contentPadding;
  final bool dense;

  /// Whether to render with modern Liquid Glass (frosted blur) styling.
  final bool useLiquidGlass;

  /// Corner radius when using liquid glass.
  final BorderRadius? borderRadius;

  const AdaptiveListTile({
    super.key,
    this.title,
    this.subtitle,
    this.leading,
    this.trailing,
    this.onTap,
    this.onLongPress,
    this.enabled = true,
    this.contentPadding,
    this.dense = false,
    this.useLiquidGlass = false,
    this.borderRadius,
  });

  @override
  ListTile buildMaterialWidget(BuildContext context) {
    return ListTile(
      title: title,
      subtitle: subtitle,
      leading: leading,
      trailing: trailing,
      onTap: enabled ? onTap : null,
      onLongPress: enabled ? onLongPress : null,
      enabled: enabled,
      contentPadding: contentPadding,
      dense: dense,
    );
  }

  @override
  Widget buildCupertinoWidget(BuildContext context) {
    if (useLiquidGlass) {
      return _buildLiquidGlassTile(context);
    }

    final edgeInsetsPadding = contentPadding is EdgeInsets
        ? contentPadding as EdgeInsets
        : null;

    return CupertinoListTile(
      title: title ?? const SizedBox.shrink(),
      subtitle: subtitle,
      leading: leading,
      trailing: trailing ??
          (onTap != null ? const CupertinoListTileChevron() : null),
      onTap: enabled ? onTap : null,
      padding: edgeInsetsPadding,
    );
  }

  Widget _buildLiquidGlassTile(BuildContext context) {
    final effectivePadding = contentPadding ??
        EdgeInsets.symmetric(
          horizontal: 16,
          vertical: dense ? 8 : 12,
        );

    final titleStyle = CupertinoTheme.of(context).textTheme.textStyle.copyWith(
          fontWeight: FontWeight.w600,
          color: enabled
              ? CupertinoColors.label.resolveFrom(context)
              : CupertinoColors.secondaryLabel.resolveFrom(context),
        );

    final subtitleStyle =
        CupertinoTheme.of(context).textTheme.textStyle.copyWith(
              fontSize: 13,
              color: CupertinoColors.secondaryLabel.resolveFrom(context),
            );

    return AdaptiveLiquidGlass(
      padding: effectivePadding,
      borderRadius: borderRadius ?? BorderRadius.circular(12),
      onTap: enabled ? onTap : null,
      enableSpringFeedback: true,
      child: Row(
        children: [
          if (leading != null) ...[
            leading!,
            const SizedBox(width: 12),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (title != null)
                  DefaultTextStyle(
                    style: titleStyle,
                    child: title!,
                  ),
                if (subtitle != null) ...[
                  const SizedBox(height: 2),
                  DefaultTextStyle(
                    style: subtitleStyle,
                    child: subtitle!,
                  ),
                ],
              ],
            ),
          ),
          if (trailing != null)
            trailing!
          else if (onTap != null)
            const CupertinoListTileChevron(),
        ],
      ),
    );
  }
}
