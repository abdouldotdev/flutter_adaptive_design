import 'package:flutter/material.dart';
import 'package:flutter_adaptive_design/flutter_adaptive_design.dart';

import '../app_controller.dart';

class ButtonsScreen extends StatefulWidget {
  const ButtonsScreen({super.key});

  @override
  State<ButtonsScreen> createState() => _ButtonsScreenState();
}

class _ButtonsScreenState extends State<ButtonsScreen> {
  int _counter = 0;
  bool _isLoading = false;

  void _increment() => setState(() => _counter++);

  void _triggerLoading() async {
    setState(() => _isLoading = true);
    await Future<void>.delayed(const Duration(seconds: 2));
    if (mounted) setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return AdaptiveScaffold(
      appBar: const AdaptiveAppBar(
        title: 'Buttons & Actions',
        actions: [PlatformSwitchAction()],
      ),
      floatingActionButton: AdaptiveFab(
        onPressed: _increment,
        showOnCupertino: true,
        tooltip: 'Add item',
        child: const AdaptiveIcon(AdaptiveIcons.add),
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
                  Text(
                    'Tap Count: $_counter',
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: AdaptiveSpacing.md),
                  AdaptiveButton.label(
                    onPressed: _increment,
                    label: 'Primary Button',
                  ),
                  const SizedBox(height: AdaptiveSpacing.sm),
                  AdaptiveTextButton(
                    onPressed: _increment,
                    child: const Text('Text / Borderless Button'),
                  ),
                  const SizedBox(height: AdaptiveSpacing.sm),
                  Row(
                    children: [
                      AdaptiveIconButton(
                        onPressed: _increment,
                        icon: const AdaptiveIcon(AdaptiveIcons.add),
                      ),
                      const SizedBox(width: AdaptiveSpacing.sm),
                      AdaptiveIconButton(
                        onPressed: _increment,
                        icon: const AdaptiveIcon(AdaptiveIcons.edit),
                      ),
                      const SizedBox(width: AdaptiveSpacing.sm),
                      AdaptiveIconButton(
                        onPressed: _increment,
                        icon: const AdaptiveIcon(AdaptiveIcons.delete),
                      ),
                      const SizedBox(width: AdaptiveSpacing.sm),
                      AdaptiveIconButton(
                        onPressed: _increment,
                        icon: const AdaptiveIcon(AdaptiveIcons.share),
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
                  const Text('Loading Button', style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: AdaptiveSpacing.md),
                  AdaptiveLoadingButton(
                    isLoading: _isLoading,
                    onPressed: _triggerLoading,
                    child: const Text('Submit Transaction'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AdaptiveSpacing.md),
            const AdaptiveCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Disabled States', style: TextStyle(fontWeight: FontWeight.bold)),
                  SizedBox(height: AdaptiveSpacing.md),
                  AdaptiveButton(
                    onPressed: null,
                    child: Text('Disabled Primary Button'),
                  ),
                  SizedBox(height: AdaptiveSpacing.sm),
                  AdaptiveTextButton(
                    onPressed: null,
                    child: Text('Disabled Text Button'),
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
