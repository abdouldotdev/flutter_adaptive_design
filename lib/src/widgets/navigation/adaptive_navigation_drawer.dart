import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../foundation/platform_utils.dart';

/// An item for use in [AdaptiveNavigationDrawer].
class AdaptiveDrawerItem {
  final String label;
  final IconData icon;
  final IconData? selectedIcon;
  final VoidCallback? onTap;
  final bool selected;

  const AdaptiveDrawerItem({
    required this.label,
    required this.icon,
    this.selectedIcon,
    this.onTap,
    this.selected = false,
  });
}

/// A separator or section header for the drawer.
class AdaptiveDrawerSection {
  final String? title;
  final List<AdaptiveDrawerItem> items;

  const AdaptiveDrawerSection({
    this.title,
    required this.items,
  });
}

/// Adaptive navigation drawer that renders [NavigationDrawer] on Material
/// platforms and a Cupertino-styled drawer on Cupertino platforms.
///
/// Supports optional Liquid Glass frosted blur via [useLiquidGlass].
class AdaptiveNavigationDrawer extends StatelessWidget {
  /// The header widget displayed at the top of the drawer.
  final Widget? header;

  /// Flat list of drawer items. Used when sections are not needed.
  final List<AdaptiveDrawerItem>? items;

  /// Sectioned drawer items. Takes precedence over [items].
  final List<AdaptiveDrawerSection>? sections;

  /// The currently selected index (used for Material NavigationDrawer).
  final int selectedIndex;

  /// Called when the selection changes (Material only).
  final ValueChanged<int>? onDestinationSelected;

  /// The background color of the drawer.
  final Color? backgroundColor;

  /// The width of the drawer.
  final double width;

  /// Whether to render with modern Liquid Glass (frosted blur) styling.
  final bool useLiquidGlass;

  const AdaptiveNavigationDrawer({
    super.key,
    this.header,
    this.items,
    this.sections,
    this.selectedIndex = 0,
    this.onDestinationSelected,
    this.backgroundColor,
    this.width = 304,
    this.useLiquidGlass = false,
  }) : assert(
          items != null || sections != null,
          'Either items or sections must be provided.',
        );

  List<AdaptiveDrawerItem> get _allItems {
    if (sections != null) {
      return sections!.expand((s) => s.items).toList();
    }
    return items ?? [];
  }

  @override
  Widget build(BuildContext context) {
    if (PlatformUtils.isCupertino) {
      return _buildCupertinoDrawer(context);
    }
    return _buildMaterialDrawer(context);
  }

  Widget _buildMaterialDrawer(BuildContext context) {
    final theme = Theme.of(context);
    return NavigationDrawer(
      selectedIndex: selectedIndex,
      onDestinationSelected: _handleDestinationSelected,
      backgroundColor: backgroundColor ??
          (useLiquidGlass ? theme.colorScheme.surfaceContainerLow : null),
      elevation: useLiquidGlass ? 2.0 : null,
      children: [
        if (header != null) ...[
          header!,
          const Divider(),
        ],
        ..._buildMaterialDestinations(),
      ],
    );
  }

  void _handleDestinationSelected(int index) {
    final allItems = _allItems;
    if (index >= 0 && index < allItems.length) {
      allItems[index].onTap?.call();
    }
    onDestinationSelected?.call(index);
  }

  List<Widget> _buildMaterialDestinations() {
    return _allItems.map((item) {
      return NavigationDrawerDestination(
        icon: Icon(item.icon),
        selectedIcon: item.selectedIcon != null
            ? Icon(item.selectedIcon)
            : null,
        label: Text(item.label),
      );
    }).toList();
  }

  Widget _buildCupertinoDrawer(BuildContext context) {
    final cupertinoTheme = CupertinoTheme.of(context);
    final isDark = CupertinoTheme.brightnessOf(context) == Brightness.dark;

    final content = SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (header != null) ...[
            header!,
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Divider(
                height: 1,
                color: isDark
                    ? Colors.white.withValues(alpha: 0.1)
                    : Colors.black.withValues(alpha: 0.08),
              ),
            ),
          ],
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 8),
              children: _buildCupertinoItems(context, cupertinoTheme),
            ),
          ),
        ],
      ),
    );

    if (useLiquidGlass) {
      return SizedBox(
        width: width,
        child: ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 25, sigmaY: 25),
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: _resolveCupertinoBackground(isDark),
                border: _resolveCupertinoBorder(isDark),
              ),
              child: content,
            ),
          ),
        ),
      );
    }

    final solidBg = backgroundColor ??
        CupertinoColors.systemGroupedBackground.resolveFrom(context);

    return SizedBox(
      width: width,
      child: ColoredBox(
        color: solidBg,
        child: content,
      ),
    );
  }

  Color _resolveCupertinoBackground(bool isDark) {
    if (backgroundColor != null) return backgroundColor!;
    return isDark
        ? const Color(0xFF1E1E1E).withValues(alpha: 0.70)
        : const Color(0xFFF8F8F8).withValues(alpha: 0.75);
  }

  Border _resolveCupertinoBorder(bool isDark) {
    return Border(
      right: BorderSide(
        color: isDark
            ? Colors.white.withValues(alpha: 0.15)
            : Colors.black.withValues(alpha: 0.1),
        width: 0.5,
      ),
    );
  }

  List<Widget> _buildCupertinoItems(
    BuildContext context,
    CupertinoThemeData theme,
  ) {
    final widgets = <Widget>[];
    if (sections != null) {
      for (final section in sections!) {
        if (section.title != null) {
          widgets.add(_buildCupertinoSectionHeader(context, section.title!));
        }
        for (final item in section.items) {
          widgets.add(_buildCupertinoItem(context, item, theme));
        }
      }
    } else if (items != null) {
      for (final item in items!) {
        widgets.add(_buildCupertinoItem(context, item, theme));
      }
    }
    return widgets;
  }

  Widget _buildCupertinoSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 16, 4),
      child: Text(
        title.toUpperCase(),
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: CupertinoColors.secondaryLabel.resolveFrom(context),
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildCupertinoItem(
    BuildContext context,
    AdaptiveDrawerItem item,
    CupertinoThemeData theme,
  ) {
    final isSelected = item.selected;
    final primaryColor = theme.primaryColor;
    final labelColor = isSelected
        ? primaryColor
        : CupertinoColors.label.resolveFrom(context);

    return GestureDetector(
      onTap: item.onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: _buildCupertinoItemDecoration(isSelected, primaryColor),
        child: Row(
          children: [
            Icon(
              isSelected ? (item.selectedIcon ?? item.icon) : item.icon,
              size: 22,
              color: labelColor,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                item.label,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                  color: labelColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  BoxDecoration? _buildCupertinoItemDecoration(
    bool isSelected,
    Color primaryColor,
  ) {
    if (!isSelected) return null;
    if (useLiquidGlass) {
      return BoxDecoration(
        color: primaryColor.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: primaryColor.withValues(alpha: 0.25),
          width: 0.5,
        ),
      );
    }
    return BoxDecoration(
      color: primaryColor.withValues(alpha: 0.1),
      borderRadius: BorderRadius.circular(16),
    );
  }
}
