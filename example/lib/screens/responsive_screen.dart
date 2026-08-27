import 'package:flutter/material.dart';
import 'package:flutter_adaptive_design/flutter_adaptive_design.dart';

import '../app_controller.dart';

class ResponsiveScreen extends StatefulWidget {
  const ResponsiveScreen({super.key});

  @override
  State<ResponsiveScreen> createState() => _ResponsiveScreenState();
}

class _ResponsiveScreenState extends State<ResponsiveScreen> {
  int _viewMode = 0;
  String _selectedItem = 'Item 1';

  @override
  Widget build(BuildContext context) {
    final sizeClass = Breakpoints.of(context);
    final width = MediaQuery.sizeOf(context).width;

    return AdaptiveScaffold(
      appBar: const AdaptiveAppBar(
        title: 'Responsive & Multi-Device',
        actions: [PlatformSwitchAction()],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: AdaptiveSegmentedControl<int>(
              selected: _viewMode,
              onSelectionChanged: (v) => setState(() => _viewMode = v),
              segments: const [
                AdaptiveSegment(value: 0, label: Text('Grid / Width')),
                AdaptiveSegment(value: 1, label: Text('Master-Detail')),
              ],
            ),
          ),
          Expanded(
            child: _viewMode == 0
                ? SingleChildScrollView(
                    padding: AdaptiveSpacing.pagePadding,
                    child: AdaptiveConstrainedContent(
                      maxWidth: 800,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          AdaptiveCard(
                            child: Column(
                              children: [
                                Text(
                                  'Current Window Class: ${sizeClass.name.toUpperCase()}',
                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                ),
                                const SizedBox(height: AdaptiveSpacing.xs),
                                Text(
                                  'Width: ${width.toStringAsFixed(1)} pt (Breakpoints: compact < 600, medium < 840, expanded < 1200, large >= 1200)',
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: AdaptiveSpacing.lg),
                          AdaptiveResponsiveGrid(
                            minChildWidth: 160,
                            children: List.generate(
                              6,
                              (index) => AdaptiveCard(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 24),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      AdaptiveIcon(
                                        index % 2 == 0 ? AdaptiveIcons.wallet : AdaptiveIcons.analytics,
                                        size: 28,
                                      ),
                                      const SizedBox(height: AdaptiveSpacing.sm),
                                      Text('Card #${index + 1}', style: const TextStyle(fontWeight: FontWeight.bold)),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                : AdaptiveMasterDetail(
                    master: ListView(
                      children: List.generate(
                        8,
                        (index) => AdaptiveListTile(
                          title: Text('Item #${index + 1}'),
                          subtitle: Text('Details preview for record ${index + 1}'),
                          trailing: const AdaptiveIcon(AdaptiveIcons.forward, size: 16),
                          onTap: () => setState(() => _selectedItem = 'Item #${index + 1}'),
                        ),
                      ),
                    ),
                    detail: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const AdaptiveIcon(AdaptiveIcons.info, size: 48),
                          const SizedBox(height: AdaptiveSpacing.md),
                          Text('Detail View for: $_selectedItem', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                          const SizedBox(height: AdaptiveSpacing.sm),
                          const Text('On compact screens, master and detail navigate sequentially. On tablet/desktop, they appear side-by-side.'),
                        ],
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
