import 'package:flutter/material.dart';
import 'package:flutter_adaptive_design/flutter_adaptive_design.dart';

import 'buttons_screen.dart';
import 'feedback_screen.dart';
import 'inputs_screen.dart';
import 'layout_screen.dart';
import 'responsive_screen.dart';
import 'states_screen.dart';

class OverviewScreen extends StatelessWidget {
  final VoidCallback onTogglePlatform;
  final VoidCallback onToggleTheme;
  final bool isDark;

  const OverviewScreen({
    super.key,
    required this.onTogglePlatform,
    required this.onToggleTheme,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final isCupertino = PlatformUtils.isCupertino;

    return AdaptiveScaffold(
      appBar: AdaptiveAppBar(
        title: 'Adaptive Design Gallery',
        actions: [
          AdaptiveIconButton(
            onPressed: onTogglePlatform,
            icon: Icon(isCupertino ? Icons.phone_iphone : Icons.android),
          ),
          AdaptiveIconButton(
            onPressed: onToggleTheme,
            icon: Icon(isDark ? Icons.light_mode : Icons.dark_mode),
          ),
        ],
      ),
      body: ListView(
        padding: AdaptiveSpacing.pagePadding,
        children: [
          AdaptiveCard(
            color: Theme.of(context).colorScheme.primaryContainer.withValues(alpha: 0.3),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Active Platform: ${isCupertino ? "iOS (Cupertino HIG)" : "Android (Material 3)"}',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: AdaptiveSpacing.xs),
                const Text(
                  'Single codebase dispatching true native components. Tap the top-right icons to toggle platform or theme.',
                  style: TextStyle(fontSize: 13),
                ),
              ],
            ),
          ),
          const SizedBox(height: AdaptiveSpacing.md),
          _CatalogTile(
            title: 'Buttons & Actions',
            subtitle: 'AdaptiveButton, FAB, IconButton, TextButton',
            icon: AdaptiveIcons.add,
            onTap: () => AdaptivePageRoute.push(context, builder: (_) => const ButtonsScreen()),
          ),
          _CatalogTile(
            title: 'Forms & Inputs',
            subtitle: 'TextField, SearchBar, Switch, Slider, SegmentedControl',
            icon: AdaptiveIcons.edit,
            onTap: () => AdaptivePageRoute.push(context, builder: (_) => const InputsScreen()),
          ),
          _CatalogTile(
            title: 'Layout & Navigation',
            subtitle: 'Scaffold, AppBar, BottomNav, ListSection, ListTile',
            icon: AdaptiveIcons.menu,
            onTap: () => AdaptivePageRoute.push(context, builder: (_) => const LayoutScreen()),
          ),
          _CatalogTile(
            title: 'Feedback & Modals',
            subtitle: 'Dialog, ActionSheet, ProgressIndicator, Tooltip',
            icon: AdaptiveIcons.info,
            onTap: () => AdaptivePageRoute.push(context, builder: (_) => const FeedbackScreen()),
          ),
          _CatalogTile(
            title: 'State Patterns',
            subtitle: 'EmptyState, ErrorState, Shimmer, Skeleton',
            icon: AdaptiveIcons.warning,
            onTap: () => AdaptivePageRoute.push(context, builder: (_) => const StatesScreen()),
          ),
          _CatalogTile(
            title: 'Responsive & Multi-Device',
            subtitle: 'Breakpoints, ConstrainedContent, ResponsiveGrid',
            icon: AdaptiveIcons.analytics,
            onTap: () => AdaptivePageRoute.push(context, builder: (_) => const ResponsiveScreen()),
          ),
        ],
      ),
    );
  }
}

class _CatalogTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final dynamic icon;
  final VoidCallback onTap;

  const _CatalogTile({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AdaptiveSpacing.sm),
      child: AdaptiveCard(
        child: AdaptiveListTile(
          leading: AdaptiveIcon(icon),
          title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
          subtitle: Text(subtitle),
          onTap: onTap,
        ),
      ),
    );
  }
}
