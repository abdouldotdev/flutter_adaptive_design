import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../foundation/platform_utils.dart';
import 'adaptive_liquid_glass.dart';

/// An item for use with [AdaptiveBottomNav].
class AdaptiveBottomNavItem {
  final Widget icon;
  final Widget? activeIcon;
  final String label;

  const AdaptiveBottomNavItem({
    required this.icon,
    this.activeIcon,
    required this.label,
  });
}

/// Adaptive bottom navigation bar.
///
/// Renders [NavigationBar] (Material 3) on Android/web and
/// [CupertinoTabBar] or [AdaptiveLiquidGlass] floating bar on iOS/macOS.
class AdaptiveBottomNav extends StatelessWidget {
  final List<AdaptiveBottomNavItem> items;
  final int currentIndex;
  final ValueChanged<int>? onTap;
  final Color? backgroundColor;
  final Color? activeColor;
  final Color? inactiveColor;

  /// Whether to render with modern floating Liquid Glass (frosted blur) styling.
  final bool useLiquidGlass;

  const AdaptiveBottomNav({
    super.key,
    required this.items,
    required this.currentIndex,
    this.onTap,
    this.backgroundColor,
    this.activeColor,
    this.inactiveColor,
    this.useLiquidGlass = false,
  });

  @override
  Widget build(BuildContext context) {
    if (useLiquidGlass) {
      return _buildLiquidGlassNav(context);
    }
    if (PlatformUtils.isCupertino) {
      return _buildCupertinoNav(context);
    }
    return _buildMaterialNav(context);
  }

  Widget _buildLiquidGlassNav(BuildContext context) {
    final isCupertino = PlatformUtils.isCupertino;
    final theme = Theme.of(context);
    final primaryColor = activeColor ??
        (isCupertino
            ? CupertinoTheme.of(context).primaryColor
            : theme.colorScheme.primary);
    final unselectedColor = inactiveColor ??
        (isCupertino
            ? CupertinoColors.inactiveGray
            : theme.colorScheme.onSurfaceVariant);

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: AdaptiveLiquidGlass(
          variant: LiquidGlassVariant.dense,
          borderRadius: BorderRadius.circular(28),
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(items.length, (index) {
              return _buildLiquidNavItem(
                items[index],
                index == currentIndex,
                primaryColor,
                unselectedColor,
                index,
              );
            }),
          ),
        ),
      ),
    );
  }

  Widget _buildLiquidNavItem(
    AdaptiveBottomNavItem item,
    bool isSelected,
    Color primaryColor,
    Color unselectedColor,
    int index,
  ) {
    final color = isSelected ? primaryColor : unselectedColor;
    return Expanded(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => onTap?.call(index),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: isSelected
                      ? primaryColor.withValues(alpha: 0.12)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: IconTheme(
                  data: IconThemeData(color: color, size: 24),
                  child: isSelected ? (item.activeIcon ?? item.icon) : item.icon,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                item.label,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                  color: color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCupertinoNav(BuildContext context) {
    return CupertinoTabBar(
      items: items
          .map(
            (item) => BottomNavigationBarItem(
              icon: item.icon,
              activeIcon: item.activeIcon,
              label: item.label,
            ),
          )
          .toList(),
      currentIndex: currentIndex,
      onTap: onTap,
      backgroundColor: backgroundColor,
      activeColor: activeColor ?? CupertinoTheme.of(context).primaryColor,
      inactiveColor: inactiveColor ?? CupertinoColors.inactiveGray,
    );
  }

  Widget _buildMaterialNav(BuildContext context) {
    return NavigationBar(
      destinations: items
          .map(
            (item) => NavigationDestination(
              icon: item.icon,
              selectedIcon: item.activeIcon,
              label: item.label,
            ),
          )
          .toList(),
      selectedIndex: currentIndex,
      onDestinationSelected: onTap,
      backgroundColor: backgroundColor,
      indicatorColor: activeColor?.withValues(alpha: 0.15),
    );
  }
}
