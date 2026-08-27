import 'package:flutter/material.dart';
import 'package:flutter_adaptive_design/flutter_adaptive_design.dart';

class LayoutScreen extends StatelessWidget {
  const LayoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AdaptiveScaffold(
      appBar: const AdaptiveAppBar(title: 'Layout & Navigation'),
      body: SingleChildScrollView(
        child: Column(
          children: [
            AdaptiveListSection(
              header: 'Account Settings',
              children: [
                AdaptiveListTile(
                  leading: const AdaptiveIcon(AdaptiveIcons.user),
                  title: const Text('Profile'),
                  subtitle: const Text('Manage your credentials'),
                  onTap: () {},
                ),
                AdaptiveListTile(
                  leading: const AdaptiveIcon(AdaptiveIcons.notification),
                  title: const Text('Notifications'),
                  subtitle: const Text('Push, Email, In-app'),
                  onTap: () {},
                ),
                AdaptiveListTile(
                  leading: const AdaptiveIcon(AdaptiveIcons.lock),
                  title: const Text('Privacy & Security'),
                  onTap: () {},
                ),
              ],
            ),
            AdaptiveListSection(
              header: 'Preferences',
              children: [
                AdaptiveListTile(
                  leading: const AdaptiveIcon(AdaptiveIcons.settings),
                  title: const Text('General Settings'),
                  onTap: () {},
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
