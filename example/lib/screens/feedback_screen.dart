import 'package:flutter/material.dart';
import 'package:flutter_adaptive_design/flutter_adaptive_design.dart';

class FeedbackScreen extends StatelessWidget {
  const FeedbackScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AdaptiveScaffold(
      appBar: const AdaptiveAppBar(title: 'Feedback & Modals'),
      body: SingleChildScrollView(
        padding: AdaptiveSpacing.pagePadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AdaptiveCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Dialogs & Action Sheets', style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: AdaptiveSpacing.md),
                  AdaptiveButton.label(
                    onPressed: () {
                      AdaptiveDialog.show(
                        context: context,
                        title: 'Confirm Action',
                        content: 'Are you sure you want to proceed with this operation?',
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
                    label: 'Show Adaptive Dialog',
                  ),
                  const SizedBox(height: AdaptiveSpacing.sm),
                  AdaptiveButton.label(
                    onPressed: () {
                      AdaptiveActionSheet.show(
                        context: context,
                        title: 'Select Action',
                        message: 'Choose an option below',
                        actions: [
                          AdaptiveSheetAction(
                            label: 'Share',
                            icon: AdaptiveIcons.share,
                            onPressed: () {},
                          ),
                          AdaptiveSheetAction(
                            label: 'Delete',
                            icon: AdaptiveIcons.delete,
                            isDestructive: true,
                            onPressed: () {},
                          ),
                        ],
                        cancelAction: AdaptiveSheetAction(
                          label: 'Cancel',
                          onPressed: () {},
                        ),
                      );
                    },
                    label: 'Show Action Sheet',
                  ),
                ],
              ),
            ),
            const SizedBox(height: AdaptiveSpacing.lg),
            const AdaptiveCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Progress Indicators', style: TextStyle(fontWeight: FontWeight.bold)),
                  SizedBox(height: AdaptiveSpacing.md),
                  Center(child: AdaptiveProgressIndicator()),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
