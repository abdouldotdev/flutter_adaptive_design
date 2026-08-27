import 'package:flutter/material.dart';
import 'package:flutter_adaptive_design/flutter_adaptive_design.dart';

import '../app_controller.dart';

class ChipsScreen extends StatefulWidget {
  const ChipsScreen({super.key});

  @override
  State<ChipsScreen> createState() => _ChipsScreenState();
}

class _ChipsScreenState extends State<ChipsScreen> {
  final Set<String> _selectedFilters = {'Active', 'Verified'};
  String _selectedMenuValue = 'None';

  void _toggleFilter(String tag) {
    setState(() {
      if (_selectedFilters.contains(tag)) {
        _selectedFilters.remove(tag);
      } else {
        _selectedFilters.add(tag);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AdaptiveScaffold(
      appBar: const AdaptiveAppBar(
        title: 'Chips & Context Menus',
        actions: [PlatformSwitchAction()],
      ),
      body: SingleChildScrollView(
        padding: AdaptiveSpacing.pagePadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AdaptiveCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Filter & Action Chips', style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: AdaptiveSpacing.md),
                  Wrap(
                    spacing: AdaptiveSpacing.sm,
                    runSpacing: AdaptiveSpacing.sm,
                    children: [
                      AdaptiveChip(
                        label: 'Finance',
                        icon: AdaptiveIcons.wallet,
                        onTap: () {},
                      ),
                      AdaptiveChip(
                        label: 'Analytics',
                        icon: AdaptiveIcons.analytics,
                        onTap: () {},
                      ),
                      AdaptiveFilterChip(
                        label: 'Active',
                        selected: _selectedFilters.contains('Active'),
                        onSelected: (_) => _toggleFilter('Active'),
                      ),
                      AdaptiveFilterChip(
                        label: 'Verified',
                        selected: _selectedFilters.contains('Verified'),
                        onSelected: (_) => _toggleFilter('Verified'),
                      ),
                      AdaptiveFilterChip(
                        label: 'Archived',
                        selected: _selectedFilters.contains('Archived'),
                        onSelected: (_) => _toggleFilter('Archived'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: AdaptiveSpacing.md),
            AdaptiveCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Popup Menu (Selected: $_selectedMenuValue)', style: const TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: AdaptiveSpacing.md),
                  AdaptivePopupMenu<String>(
                    onSelected: (val) {
                      if (val != null) setState(() => _selectedMenuValue = val);
                    },
                    items: const [
                      AdaptiveMenuItem(label: 'Edit Entry', value: 'Edit', icon: Icons.edit),
                      AdaptiveMenuItem(label: 'Duplicate', value: 'Duplicate', icon: Icons.copy),
                      AdaptiveMenuItem(label: 'Delete', value: 'Delete', isDestructive: true, icon: Icons.delete),
                    ],
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.withValues(alpha: 0.3)),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Tap to trigger AdaptivePopupMenu'),
                          AdaptiveIcon(AdaptiveIcons.more),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AdaptiveSpacing.md),
            AdaptiveCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Context Menu (Long-Press)', style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: AdaptiveSpacing.md),
                  AdaptiveContextMenu(
                    actions: [
                      ContextMenuAction(
                        label: 'Copy text',
                        onPressed: () {},
                      ),
                      ContextMenuAction(
                        label: 'Share link',
                        onPressed: () {},
                      ),
                      ContextMenuAction(
                        label: 'Delete item',
                        isDestructive: true,
                        onPressed: () {},
                      ),
                    ],
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.blue.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Center(
                        child: Text(
                          'Long-press on iOS for peek & pop, or right-click/long-press on Android.',
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
