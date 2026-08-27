import 'package:flutter/material.dart';
import 'package:flutter_adaptive_design/flutter_adaptive_design.dart';

class InputsScreen extends StatefulWidget {
  const InputsScreen({super.key});

  @override
  State<InputsScreen> createState() => _InputsScreenState();
}

class _InputsScreenState extends State<InputsScreen> {
  bool _switchVal = true;
  bool _checkVal = true;
  double _sliderVal = 0.5;
  int _segmentVal = 1;
  final TextEditingController _textCtrl = TextEditingController(text: 'Adaptive Text');

  @override
  void dispose() {
    _textCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AdaptiveScaffold(
      appBar: const AdaptiveAppBar(title: 'Forms & Inputs'),
      body: SingleChildScrollView(
        padding: AdaptiveSpacing.pagePadding,
        child: Column(
          children: [
            AdaptiveCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AdaptiveTextField(
                    controller: _textCtrl,
                    placeholder: 'Enter text here',
                  ),
                  const SizedBox(height: AdaptiveSpacing.md),
                  const AdaptiveSearchBar(
                    placeholder: 'Search items...',
                  ),
                ],
              ),
            ),
            const SizedBox(height: AdaptiveSpacing.md),
            AdaptiveCard(
              child: Column(
                children: [
                  AdaptiveListTile(
                    title: const Text('Toggle Switch'),
                    trailing: AdaptiveSwitch(
                      value: _switchVal,
                      onChanged: (v) => setState(() => _switchVal = v),
                    ),
                  ),
                  const AdaptiveDivider(),
                  AdaptiveListTile(
                    title: const Text('Checkbox Option'),
                    trailing: AdaptiveCheckbox(
                      value: _checkVal,
                      onChanged: (v) => setState(() => _checkVal = v ?? false),
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
                  Text('Slider value: ${(_sliderVal * 100).toInt()}%'),
                  AdaptiveSlider(
                    value: _sliderVal,
                    onChanged: (v) => setState(() => _sliderVal = v),
                  ),
                  const SizedBox(height: AdaptiveSpacing.md),
                  AdaptiveSegmentedControl<int>(
                    selected: _segmentVal,
                    onSelectionChanged: (v) => setState(() => _segmentVal = v),
                    segments: const [
                      AdaptiveSegment(value: 1, label: Text('Daily')),
                      AdaptiveSegment(value: 2, label: Text('Weekly')),
                      AdaptiveSegment(value: 3, label: Text('Monthly')),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: AdaptiveSpacing.md),
            AdaptiveCard(
              child: Wrap(
                spacing: AdaptiveSpacing.sm,
                runSpacing: AdaptiveSpacing.sm,
                children: [
                  AdaptiveChip(
                    label: 'Finance',
                    icon: AdaptiveIcons.wallet,
                    onTap: () {},
                  ),
                  AdaptiveFilterChip(
                    label: 'Featured',
                    selected: true,
                    onSelected: (_) {},
                  ),
                  AdaptiveFilterChip(
                    label: 'Trending',
                    selected: false,
                    onSelected: (_) {},
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
