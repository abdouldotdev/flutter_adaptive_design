import 'package:flutter/material.dart';
import 'package:flutter_adaptive_design/flutter_adaptive_design.dart';

import '../app_controller.dart';

class StatesScreen extends StatefulWidget {
  const StatesScreen({super.key});

  @override
  State<StatesScreen> createState() => _StatesScreenState();
}

class _StatesScreenState extends State<StatesScreen> {
  int _stateMode = 0;
  bool _showBanner = true;
  bool _isLoadingOverlay = false;

  void _triggerOverlay() async {
    setState(() => _isLoadingOverlay = true);
    await Future<void>.delayed(const Duration(seconds: 2));
    if (mounted) setState(() => _isLoadingOverlay = false);
  }

  @override
  Widget build(BuildContext context) {
    return AdaptiveLoadingOverlay(
      isLoading: _isLoadingOverlay,
      child: AdaptiveScaffold(
        appBar: const AdaptiveAppBar(
          title: 'State & Placeholder Patterns',
          actions: [PlatformSwitchAction()],
        ),
        body: Column(
          children: [
            if (_showBanner)
              AdaptiveErrorBanner(
                message: 'Offline mode: displaying cached transactions.',
                onRetry: () {},
                onDismiss: () => setState(() => _showBanner = false),
              ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  Expanded(
                    child: AdaptiveSegmentedControl<int>(
                      selected: _stateMode,
                      onSelectionChanged: (v) => setState(() => _stateMode = v),
                      segments: const [
                        AdaptiveSegment(value: 0, label: Text('Empty')),
                        AdaptiveSegment(value: 1, label: Text('Error')),
                        AdaptiveSegment(value: 2, label: Text('Skeleton')),
                        AdaptiveSegment(value: 3, label: Text('Disabled')),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: AdaptiveButton.label(
                onPressed: _triggerOverlay,
                label: 'Test Loading Overlay (2s)',
              ),
            ),
            const SizedBox(height: AdaptiveSpacing.sm),
            Expanded(
              child: switch (_stateMode) {
                0 => AdaptiveEmptyState(
                    icon: AdaptiveIcons.wallet,
                    title: 'No Active Subscriptions',
                    subtitle: 'Subscribe to a plan or start a free trial to unlock premium features.',
                    actionLabel: 'Explore Plans',
                    onAction: () {},
                  ),
                1 => AdaptiveErrorState(
                    icon: AdaptiveIcons.error,
                    title: 'Connection Timed Out',
                    message: 'The network request took longer than expected. Please retry.',
                    onRetry: () {},
                  ),
                2 => const Padding(
                    padding: AdaptiveSpacing.pagePadding,
                    child: Column(
                      children: [
                        AdaptiveSkeletonListTile(),
                        SizedBox(height: AdaptiveSpacing.sm),
                        AdaptiveSkeletonListTile(),
                        SizedBox(height: AdaptiveSpacing.sm),
                        AdaptiveSkeletonCard(),
                      ],
                    ),
                  ),
                _ => Center(
                    child: Padding(
                      padding: AdaptiveSpacing.pagePadding,
                      child: AdaptiveCard(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text('AdaptiveDisabled Demo', style: TextStyle(fontWeight: FontWeight.bold)),
                            const SizedBox(height: AdaptiveSpacing.sm),
                            const Text('Dims the widget to 38% opacity and disables hit-testing.'),
                            const SizedBox(height: AdaptiveSpacing.md),
                            AdaptiveDisabled(
                              disabled: true,
                              child: AdaptiveButton.label(
                                onPressed: () {},
                                label: 'Disabled Button in AdaptiveDisabled',
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
              },
            ),
          ],
        ),
      ),
    );
  }
}
