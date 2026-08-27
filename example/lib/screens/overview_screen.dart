import 'package:flutter/material.dart';
import 'package:flutter_adaptive_design/flutter_adaptive_design.dart';

import '../app_controller.dart';
import 'buttons_screen.dart';
import 'chips_screen.dart';
import 'feedback_screen.dart';
import 'inputs_screen.dart';
import 'layout_screen.dart';
import 'navigation_screen.dart';
import 'pickers_screen.dart';
import 'responsive_screen.dart';
import 'states_screen.dart';

class OverviewScreen extends StatelessWidget {
  const OverviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = AdaptiveAppController.of(context);
    final isCupertino = controller.isCupertino;

    return AdaptiveScaffold(
      appBar: const AdaptiveAppBar(
        title: 'Adaptive Design Gallery',
        actions: [PlatformSwitchAction()],
      ),
      body: ListView(
        padding: AdaptiveSpacing.pagePadding,
        children: [
          AdaptiveCard(
            color: Theme.of(context).colorScheme.primaryContainer.withValues(alpha: 0.25),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    AdaptiveIcon(
                      isCupertino ? Icons.phone_iphone : Icons.android,
                      size: 24,
                    ),
                    const SizedBox(width: AdaptiveSpacing.sm),
                    Expanded(
                      child: Text(
                        'Active Shell: ${isCupertino ? "iOS (Cupertino HIG)" : "Android (Material 3)"}',
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AdaptiveSpacing.xs),
                const Text(
                  'Tap the phone / theme icon in any top bar to toggle platforms and watch the entire widget hierarchy transform instantly.',
                  style: TextStyle(fontSize: 13),
                ),
              ],
            ),
          ),
          const SizedBox(height: AdaptiveSpacing.md),
          _CatalogTile(
            title: 'Buttons & Actions',
            subtitle: 'AdaptiveButton, Fab, IconButton, TextButton, LoadingButton',
            icon: AdaptiveIcons.add,
            onTap: () => AdaptivePageRoute.push(context, builder: (_) => const ButtonsScreen()),
          ),
          _CatalogTile(
            title: 'Forms & Inputs',
            subtitle: 'TextField, FormField, SearchBar, Switch, Slider, Radio, SegmentedControl',
            icon: AdaptiveIcons.edit,
            onTap: () => AdaptivePageRoute.push(context, builder: (_) => const InputsScreen()),
          ),
          _CatalogTile(
            title: 'Layout & Lists',
            subtitle: 'Scaffold, AppBar, BottomNav, ListSection, ListTile, Divider, Card',
            icon: AdaptiveIcons.menu,
            onTap: () => AdaptivePageRoute.push(context, builder: (_) => const LayoutScreen()),
          ),
          _CatalogTile(
            title: 'Feedback & Overlays',
            subtitle: 'Dialog, ActionSheet, SnackBar, ProgressIndicator, RefreshIndicator, Tooltip',
            icon: AdaptiveIcons.info,
            onTap: () => AdaptivePageRoute.push(context, builder: (_) => const FeedbackScreen()),
          ),
          _CatalogTile(
            title: 'Chips & Context Menus',
            subtitle: 'AdaptiveChip, FilterChip, ContextMenu, PopupMenu',
            icon: AdaptiveIcons.filter,
            onTap: () => AdaptivePageRoute.push(context, builder: (_) => const ChipsScreen()),
          ),
          _CatalogTile(
            title: 'Pickers & Selectors',
            subtitle: 'DatePicker, TimePicker, WheelPicker, PickerValue',
            icon: AdaptiveIcons.calendar,
            onTap: () => AdaptivePageRoute.push(context, builder: (_) => const PickersScreen()),
          ),
          _CatalogTile(
            title: 'Navigation & Routes',
            subtitle: 'TabBar, NavigationDrawer, PageRoute, SubPage',
            icon: AdaptiveIcons.home,
            onTap: () => AdaptivePageRoute.push(context, builder: (_) => const NavigationScreen()),
          ),
          _CatalogTile(
            title: 'State & Placeholder Patterns',
            subtitle: 'EmptyState, ErrorState, ErrorBanner, LoadingOverlay, Shimmer, Skeletons, Disabled',
            icon: AdaptiveIcons.warning,
            onTap: () => AdaptivePageRoute.push(context, builder: (_) => const StatesScreen()),
          ),
          _CatalogTile(
            title: 'Responsive & Multi-Device',
            subtitle: 'Breakpoints, ConstrainedContent, ResponsiveGrid, MasterDetail, Scaffold',
            icon: AdaptiveIcons.analytics,
            onTap: () => AdaptivePageRoute.push(context, builder: (_) => const ResponsiveScreen()),
          ),
          const SizedBox(height: AdaptiveSpacing.lg),
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
          trailing: const AdaptiveIcon(AdaptiveIcons.forward, size: 16),
          onTap: onTap,
        ),
      ),
    );
  }
}
