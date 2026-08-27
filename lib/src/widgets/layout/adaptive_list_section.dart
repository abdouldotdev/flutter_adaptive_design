import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../foundation/platform_utils.dart';
import 'adaptive_liquid_glass.dart';

/// Adaptive list section.
///
/// Material: [Column] with [Divider] separators and optional header/footer.
/// Cupertino: [CupertinoListSection.insetGrouped] or [AdaptiveLiquidGlass]
/// with native iOS grouped styling.
class AdaptiveListSection extends StatelessWidget {
  final String? header;
  final String? footer;
  final List<Widget> children;
  final EdgeInsetsGeometry? margin;
  final Color? backgroundColor;
  final bool hasLeadingWidget;

  /// Whether to render with modern Liquid Glass (frosted blur) styling.
  final bool useLiquidGlass;

  const AdaptiveListSection({
    super.key,
    this.header,
    this.footer,
    required this.children,
    this.margin,
    this.backgroundColor,
    this.hasLeadingWidget = false,
    this.useLiquidGlass = false,
  });

  @override
  Widget build(BuildContext context) {
    if (PlatformUtils.isCupertino) {
      return _buildCupertino(context);
    }
    return _buildMaterial(context);
  }

  Widget _buildCupertino(BuildContext context) {
    if (useLiquidGlass) {
      final isDark = (CupertinoTheme.maybeBrightnessOf(context) ??
              MediaQuery.maybePlatformBrightnessOf(context) ??
              Brightness.light) ==
          Brightness.dark;

      return Padding(
        padding: margin ?? const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (header != null)
              Padding(
                padding: const EdgeInsets.only(left: 16, bottom: 6),
                child: Text(
                  header!.toUpperCase(),
                  style: TextStyle(
                    fontSize: 12,
                    letterSpacing: -0.2,
                    fontWeight: FontWeight.w500,
                    color: isDark ? Colors.white60 : Colors.black54,
                  ),
                ),
              ),
            AdaptiveLiquidGlass(
              borderRadius: BorderRadius.circular(16),
              variant: LiquidGlassVariant.regular,
              tintColor: backgroundColor,
              child: Column(
                children: _buildChildrenWithDividersCupertino(context),
              ),
            ),
            if (footer != null)
              Padding(
                padding: const EdgeInsets.only(left: 16, top: 6),
                child: Text(
                  footer!,
                  style: TextStyle(
                    fontSize: 12,
                    color: isDark ? Colors.white54 : Colors.black45,
                  ),
                ),
              ),
          ],
        ),
      );
    }

    final edgeInsetsMargin = margin is EdgeInsets
        ? margin as EdgeInsets
        : null;

    return CupertinoListSection.insetGrouped(
      header: header != null ? Text(header!) : null,
      footer: footer != null ? Text(footer!) : null,
      margin: edgeInsetsMargin,
      backgroundColor:
          backgroundColor ?? CupertinoColors.systemGroupedBackground,
      hasLeading: hasLeadingWidget,
      children: children,
    );
  }

  Widget _buildMaterial(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: margin ?? const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (header != null)
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16).copyWith(bottom: 8),
              child: Text(
                header!,
                style: theme.textTheme.titleSmall?.copyWith(
                  color: theme.colorScheme.primary,
                ),
              ),
            ),
          Card(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            elevation: 0,
            color: backgroundColor ?? theme.colorScheme.surfaceContainerLowest,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            clipBehavior: Clip.antiAlias,
            child: Column(
              children: _buildChildrenWithDividers(context),
            ),
          ),
          if (footer != null)
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16).copyWith(top: 8),
              child: Text(
                footer!,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ),
        ],
      ),
    );
  }

  List<Widget> _buildChildrenWithDividers(BuildContext context) {
    final result = <Widget>[];
    for (var i = 0; i < children.length; i++) {
      result.add(children[i]);
      if (i < children.length - 1) {
        result.add(const Divider(height: 0.5, indent: 16));
      }
    }
    return result;
  }

  List<Widget> _buildChildrenWithDividersCupertino(BuildContext context) {
    final result = <Widget>[];
    for (var i = 0; i < children.length; i++) {
      result.add(children[i]);
      if (i < children.length - 1) {
        result.add(
          const Padding(
            padding: EdgeInsets.only(left: 48),
            child: Divider(
              height: 0.5,
              thickness: 0.5,
              color: CupertinoColors.separator,
            ),
          ),
        );
      }
    }
    return result;
  }
}
