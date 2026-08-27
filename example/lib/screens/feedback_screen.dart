import 'package:flutter/material.dart';
import 'package:flutter_adaptive_design/flutter_adaptive_design.dart';

import '../app_controller.dart';

class FeedbackScreen extends StatefulWidget {
  const FeedbackScreen({super.key});

  @override
  State<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  int _itemsCount = 3;

  Future<void> _handleRefresh() async {
    await Future<void>.delayed(const Duration(seconds: 1));
    if (mounted) setState(() => _itemsCount += 2);
  }

  @override
  Widget build(BuildContext context) {
    return AdaptiveScaffold(
      appBar: const AdaptiveAppBar(
        title: 'Feedback & Overlays',
        actions: [PlatformSwitchAction()],
      ),
      body: AdaptiveRefreshIndicator(
        onRefresh: _handleRefresh,
        child: ListView(
          padding: AdaptiveSpacing.pagePadding,
          children: [
            AdaptiveCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Dialogs & Modals', style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: AdaptiveSpacing.md),
                  AdaptiveButton.label(
                    onPressed: () {
                      AdaptiveDialog.show(
                        context: context,
                        title: 'Authorize Transfer',
                        content: 'Are you sure you want to send 150.00 USD to Alice?',
                        actions: [
                          AdaptiveDialogAction(
                            label: 'Cancel',
                            onPressed: () => Navigator.pop(context),
                          ),
                          AdaptiveDialogAction(
                            label: 'Confirm',
                            isDefault: true,
                            onPressed: () => Navigator.pop(context),
                          ),
                        ],
                      );
                    },
                    label: 'Show Native Dialog',
                  ),
                  const SizedBox(height: AdaptiveSpacing.sm),
                  AdaptiveButton.label(
                    onPressed: () {
                      AdaptiveActionSheet.show(
                        context: context,
                        title: 'Transaction Options',
                        message: 'Select an action to apply to this record',
                        actions: [
                          AdaptiveSheetAction(
                            label: 'Share Receipt',
                            icon: AdaptiveIcons.share,
                            onPressed: () {},
                          ),
                          AdaptiveSheetAction(
                            label: 'Download PDF',
                            icon: AdaptiveIcons.download,
                            onPressed: () {},
                          ),
                          AdaptiveSheetAction(
                            label: 'Delete Record',
                            icon: AdaptiveIcons.delete,
                            isDestructive: true,
                            onPressed: () {},
                          ),
                        ],
                        cancelAction: const AdaptiveSheetAction(
                          label: 'Cancel',
                        ),
                      );
                    },
                    label: 'Show Action Sheet',
                  ),
                ],
              ),
            ),
            const SizedBox(height: AdaptiveSpacing.md),
            AdaptiveCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Snackbars & Notifications', style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: AdaptiveSpacing.md),
                  AdaptiveButton.label(
                    onPressed: () {
                      AdaptiveSnackBar.show(
                        context: context,
                        message: 'Payment sent successfully!',
                        actionLabel: 'Undo',
                        onAction: () {},
                      );
                    },
                    label: 'Show Adaptive SnackBar',
                  ),
                ],
              ),
            ),
            const SizedBox(height: AdaptiveSpacing.md),
            const AdaptiveCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Progress & Tooltips', style: TextStyle(fontWeight: FontWeight.bold)),
                  SizedBox(height: AdaptiveSpacing.md),
                  Center(child: AdaptiveProgressIndicator()),
                  SizedBox(height: AdaptiveSpacing.md),
                  Center(
                    child: AdaptiveTooltip(
                      message: 'This is an adaptive tooltip with touch-friendly delay.',
                      child: Text(
                        'Hover or Long-Press Me for Tooltip',
                        style: TextStyle(decoration: TextDecoration.underline),
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
                  Text('Pull to Refresh Demo (Items: $_itemsCount)', style: const TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: AdaptiveSpacing.xs),
                  const Text('Swipe down from the top to trigger native iOS / Android refresh indicator.'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
