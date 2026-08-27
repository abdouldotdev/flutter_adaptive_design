import 'package:flutter/material.dart';
import 'package:flutter_adaptive_design/flutter_adaptive_design.dart';

class ButtonsScreen extends StatefulWidget {
  const ButtonsScreen({super.key});

  @override
  State<ButtonsScreen> createState() => _ButtonsScreenState();
}

class _ButtonsScreenState extends State<ButtonsScreen> {
  int _counter = 0;

  void _increment() => setState(() => _counter++);

  @override
  Widget build(BuildContext context) {
    return AdaptiveScaffold(
      appBar: const AdaptiveAppBar(title: 'Buttons & Actions'),
      body: SingleChildScrollView(
        padding: AdaptiveSpacing.pagePadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AdaptiveCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Taps recorded: $_counter', style: const TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: AdaptiveSpacing.md),
                  AdaptiveButton.label(
                    onPressed: _increment,
                    label: 'Primary Button',
                  ),
                  const SizedBox(height: AdaptiveSpacing.sm),
                  AdaptiveTextButton(
                    onPressed: _increment,
                    child: const Text('Text Button'),
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
            const SizedBox(height: AdaptiveSpacing.lg),
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
