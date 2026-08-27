import 'package:flutter/material.dart';
import 'package:flutter_adaptive_design/flutter_adaptive_design.dart';

class StatesScreen extends StatefulWidget {
  const StatesScreen({super.key});

  @override
  State<StatesScreen> createState() => _StatesScreenState();
}

class _StatesScreenState extends State<StatesScreen> {
  int _stateMode = 0;

  @override
  Widget build(BuildContext context) {
    return AdaptiveScaffold(
      appBar: const AdaptiveAppBar(title: 'State Patterns'),
      body: Column(
        children: [
          Padding(
            padding: AdaptiveSpacing.pagePaddingHorizontal,
            child: AdaptiveSegmentedControl<int>(
              selected: _stateMode,
              onSelectionChanged: (v) => setState(() => _stateMode = v),
              segments: const [
                AdaptiveSegment(value: 0, label: Text('Empty')),
                AdaptiveSegment(value: 1, label: Text('Error')),
                AdaptiveSegment(value: 2, label: Text('Skeleton')),
              ],
            ),
          ),
          const SizedBox(height: AdaptiveSpacing.md),
          Expanded(
            child: switch (_stateMode) {
              0 => AdaptiveEmptyState(
                  icon: AdaptiveIcons.wallet,
                  title: 'No Transactions',
                  subtitle: 'Your payment history will appear here once you send or receive funds.',
                  actionLabel: 'Make a Transfer',
                  onAction: () {},
                ),
              1 => AdaptiveErrorState(
                  icon: AdaptiveIcons.error,
                  title: 'Connection Lost',
                  message: 'We were unable to contact the servers. Please verify your internet connection.',
                  onRetry: () {},
                ),
              _ => const Padding(
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
            },
          ),
        ],
      ),
    );
  }
}
