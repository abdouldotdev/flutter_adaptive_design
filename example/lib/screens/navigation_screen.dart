import 'package:flutter/material.dart';
import 'package:flutter_adaptive_design/flutter_adaptive_design.dart';

import '../app_controller.dart';

class NavigationScreen extends StatefulWidget {
  const NavigationScreen({super.key});

  @override
  State<NavigationScreen> createState() => _NavigationScreenState();
}

class _NavigationScreenState extends State<NavigationScreen> {
  int _drawerIndex = 0;

  @override
  Widget build(BuildContext context) {
    return AdaptiveScaffold(
      appBar: const AdaptiveAppBar(
        title: 'Navigation & Tabs',
        actions: [PlatformSwitchAction()],
      ),
      body: Column(
        children: [
          Padding(
            padding: AdaptiveSpacing.pagePadding,
            child: AdaptiveCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Page Transitions', style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: AdaptiveSpacing.xs),
                  const Text('AdaptivePageRoute automatically pushes CupertinoPageRoute on iOS and MaterialPageRoute on Android.'),
                  const SizedBox(height: AdaptiveSpacing.md),
                  AdaptiveButton.label(
                    onPressed: () {
                      AdaptivePageRoute.push(
                        context,
                        builder: (_) => const _DemoSubPage(),
                      );
                    },
                    label: 'Push Nested Adaptive Route',
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: AdaptiveSpacing.sm),
          Expanded(
            child: AdaptiveTabBar(
              tabs: [
                AdaptiveTab(
                  label: 'Analytics',
                  icon: AdaptiveIcons.analytics,
                  child: Center(
                    child: Padding(
                      padding: AdaptiveSpacing.pagePadding,
                      child: AdaptiveCard(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text('Analytics Tab Content', style: TextStyle(fontWeight: FontWeight.bold)),
                            const SizedBox(height: AdaptiveSpacing.sm),
                            const Text('Material renders TabBar + TabBarView. Cupertino renders SlidingSegmentedControl + IndexedStack.'),
                            const SizedBox(height: AdaptiveSpacing.md),
                            AdaptiveButton.label(
                              onPressed: () {
                                showModalBottomSheet<void>(
                                  context: context,
                                  builder: (_) => AdaptiveNavigationDrawer(
                                    selectedIndex: _drawerIndex,
                                    onDestinationSelected: (i) => setState(() => _drawerIndex = i),
                                    items: const [
                                      AdaptiveDrawerItem(label: 'Home', icon: Icons.home),
                                      AdaptiveDrawerItem(label: 'Reports', icon: Icons.bar_chart),
                                      AdaptiveDrawerItem(label: 'Account', icon: Icons.person),
                                    ],
                                  ),
                                );
                              },
                              label: 'Open Navigation Drawer',
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                AdaptiveTab(
                  label: 'History',
                  icon: AdaptiveIcons.clock,
                  child: const Center(
                    child: Text('History Tab Content'),
                  ),
                ),
                AdaptiveTab(
                  label: 'Settings',
                  icon: AdaptiveIcons.settings,
                  child: const Center(
                    child: Text('Settings Tab Content'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DemoSubPage extends StatelessWidget {
  const _DemoSubPage();

  @override
  Widget build(BuildContext context) {
    return AdaptiveScaffold(
      appBar: const AdaptiveAppBar(
        title: 'Nested Adaptive Route',
        actions: [PlatformSwitchAction()],
      ),
      body: Center(
        child: Padding(
          padding: AdaptiveSpacing.pagePadding,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Notice the native page transition animation and back gesture!',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: AdaptiveSpacing.lg),
              AdaptiveButton.label(
                onPressed: () => Navigator.pop(context),
                label: 'Go Back',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
