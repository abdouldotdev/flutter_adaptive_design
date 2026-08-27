import 'package:flutter/material.dart';
import 'package:flutter_adaptive_design/flutter_adaptive_design.dart';

import '../app_controller.dart';

class InputsScreen extends StatefulWidget {
  const InputsScreen({super.key});

  @override
  State<InputsScreen> createState() => _InputsScreenState();
}

class _InputsScreenState extends State<InputsScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _textCtrl = TextEditingController(text: 'John Doe');
  final TextEditingController _searchCtrl = TextEditingController();
  bool _switchVal = true;
  bool _checkVal = true;
  double _sliderVal = 0.65;
  int _radioVal = 1;
  int _segmentVal = 1;

  @override
  void dispose() {
    _textCtrl.dispose();
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AdaptiveScaffold(
      appBar: const AdaptiveAppBar(
        title: 'Forms & Inputs',
        actions: [PlatformSwitchAction()],
      ),
      body: SingleChildScrollView(
        padding: AdaptiveSpacing.pagePadding,
        child: Column(
          children: [
            AdaptiveCard(
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Text Fields & Form Fields', style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: AdaptiveSpacing.md),
                    AdaptiveTextField(
                      controller: _textCtrl,
                      placeholder: 'Enter full name',
                      prefix: const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8),
                        child: AdaptiveIcon(AdaptiveIcons.user, size: 18),
                      ),
                    ),
                    const SizedBox(height: AdaptiveSpacing.md),
                    AdaptiveFormField(
                      placeholder: 'Email address',
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || !value.contains('@')) {
                          return 'Please enter a valid email address';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: AdaptiveSpacing.sm),
                    AdaptiveButton.label(
                      onPressed: () {
                        _formKey.currentState?.validate();
                      },
                      label: 'Validate Form',
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: AdaptiveSpacing.md),
            AdaptiveCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Search Input', style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: AdaptiveSpacing.sm),
                  AdaptiveSearchBar(
                    controller: _searchCtrl,
                    placeholder: 'Search transactions, users, tags...',
                  ),
                ],
              ),
            ),
            const SizedBox(height: AdaptiveSpacing.md),
            AdaptiveCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Toggles & Switches', style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: AdaptiveSpacing.sm),
                  AdaptiveListTile(
                    title: const Text('Biometric Authentication'),
                    subtitle: const Text('FaceID / TouchID / Fingerprint'),
                    trailing: AdaptiveSwitch(
                      value: _switchVal,
                      onChanged: (v) => setState(() => _switchVal = v),
                    ),
                  ),
                  const AdaptiveDivider(),
                  AdaptiveListTile(
                    title: const Text('Accept Terms and Conditions'),
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
                  Text('Slider: ${(_sliderVal * 100).toInt()}%', style: const TextStyle(fontWeight: FontWeight.bold)),
                  AdaptiveSlider(
                    value: _sliderVal,
                    onChanged: (v) => setState(() => _sliderVal = v),
                  ),
                  const SizedBox(height: AdaptiveSpacing.md),
                  const Text('Radio Selection', style: TextStyle(fontWeight: FontWeight.bold)),
                  Row(
                    children: [
                      AdaptiveRadio<int>(
                        value: 1,
                        groupValue: _radioVal,
                        onChanged: (v) => setState(() => _radioVal = v ?? 1),
                      ),
                      const Text('Standard'),
                      const SizedBox(width: AdaptiveSpacing.md),
                      AdaptiveRadio<int>(
                        value: 2,
                        groupValue: _radioVal,
                        onChanged: (v) => setState(() => _radioVal = v ?? 2),
                      ),
                      const Text('Express'),
                    ],
                  ),
                  const SizedBox(height: AdaptiveSpacing.md),
                  const Text('Segmented Control', style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: AdaptiveSpacing.xs),
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
          ],
        ),
      ),
    );
  }
}
