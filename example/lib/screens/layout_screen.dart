import 'package:flutter/material.dart';
import 'package:flutter_adaptive_design/flutter_adaptive_design.dart';

import '../app_controller.dart';

class LayoutScreen extends StatefulWidget {
  const LayoutScreen({super.key});

  @override
  State<LayoutScreen> createState() => _LayoutScreenState();
}

class _LayoutScreenState extends State<LayoutScreen> {
  int _navIndex = 0;

  @override
  Widget build(BuildContext context) {
    return AdaptiveScaffold(
      appBar: const AdaptiveAppBar(
        title: 'Layout & Lists',
        actions: [PlatformSwitchAction()],
      ),
      bottomNavigationBar: AdaptiveBottomNav(
        currentIndex: _navIndex,
        onTap: (index) => setState(() => _navIndex = index),
        items: const [
          AdaptiveBottomNavItem(
            icon: AdaptiveIcon(AdaptiveIcons.home),
            label: 'Home',
          ),
          AdaptiveBottomNavItem(
            icon: AdaptiveIcon(AdaptiveIcons.analytics),
            label: 'Analytics',
          ),
          AdaptiveBottomNavItem(
            icon: AdaptiveIcon(AdaptiveIcons.settings),
            label: 'Settings',
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            AdaptiveListSection(
              header: 'Personal Info',
              children: [
                AdaptiveListTile(
                  leading: const AdaptiveIcon(AdaptiveIcons.user),
                  title: const Text('Account Profile'),
                  subtitle: const Text('Edit email, username, phone'),
                  trailing: const AdaptiveIcon(AdaptiveIcons.forward, size: 16),
                  onTap: () {},
                ),
                AdaptiveListTile(
                  leading: const AdaptiveIcon(AdaptiveIcons.lock),
                  title: const Text('Security & Password'),
                  trailing: const AdaptiveIcon(AdaptiveIcons.forward, size: 16),
                  onTap: () {},
                ),
                AdaptiveListTile(
                  leading: const AdaptiveIcon(AdaptiveIcons.wallet),
                  title: const Text('Payment Methods'),
                  subtitle: const Text('Cards, Bank accounts, Apple/Google Pay'),
                  trailing: const AdaptiveIcon(AdaptiveIcons.forward, size: 16),
                  onTap: () {},
                ),
              ],
            ),
            AdaptiveListSection(
              header: 'Preferences & System',
              footer: 'Changes are automatically synchronized across devices.',
              children: [
                AdaptiveListTile(
                  leading: const AdaptiveIcon(AdaptiveIcons.notification),
                  title: const Text('Notification Channels'),
                  trailing: const AdaptiveIcon(AdaptiveIcons.forward, size: 16),
                  onTap: () {},
                ),
                AdaptiveListTile(
                  leading: const AdaptiveIcon(AdaptiveIcons.settings),
                  title: const Text('App Settings'),
                  trailing: const AdaptiveIcon(AdaptiveIcons.forward, size: 16),
                  onTap: () {},
                ),
              ],
            ),
            const SizedBox(height: AdaptiveSpacing.lg),
            Padding(
              padding: AdaptiveSpacing.pagePaddingHorizontal,
              child: AdaptiveCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Card Container', style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: AdaptiveSpacing.xs),
                    const Text('AdaptiveCard applies squircle radius on iOS and M3 elevated radius on Android.'),
                    const SizedBox(height: AdaptiveSpacing.sm),
                    const AdaptiveDivider(),
                    const SizedBox(height: AdaptiveSpacing.sm),
                    Text('Current Tab Selected: #$_navIndex', style: const TextStyle(color: Colors.grey)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: AdaptiveSpacing.xxl),
          ],
        ),
      ),
    );
  }
}
