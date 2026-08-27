import 'package:flutter/material.dart';
import 'package:flutter_adaptive_design/flutter_adaptive_design.dart';

import '../app_controller.dart';

class PickersScreen extends StatefulWidget {
  const PickersScreen({super.key});

  @override
  State<PickersScreen> createState() => _PickersScreenState();
}

class _PickersScreenState extends State<PickersScreen> {
  DateTime _selectedDate = DateTime(2026, 8, 27);
  TimeOfDay _selectedTime = const TimeOfDay(hour: 14, minute: 30);
  String _selectedOption = 'United States';

  final List<String> _countries = [
    'United States',
    'France',
    'Canada',
    'United Kingdom',
    'Germany',
    'Japan',
    'Australia',
  ];

  @override
  Widget build(BuildContext context) {
    return AdaptiveScaffold(
      appBar: const AdaptiveAppBar(
        title: 'Pickers & Date Selectors',
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
                  const Text('Date Picker', style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: AdaptiveSpacing.xs),
                  Text('Selected: ${_selectedDate.year}-${_selectedDate.month.toString().padLeft(2, '0')}-${_selectedDate.day.toString().padLeft(2, '0')}'),
                  const SizedBox(height: AdaptiveSpacing.md),
                  AdaptiveButton.label(
                    onPressed: () async {
                      final result = await AdaptiveDatePicker.show(
                        context: context,
                        initialDate: _selectedDate,
                        firstDate: DateTime(2020, 1, 1),
                        lastDate: DateTime(2030, 12, 31),
                      );
                      if (result != null) setState(() => _selectedDate = result);
                    },
                    label: 'Pick Date',
                  ),
                ],
              ),
            ),
            const SizedBox(height: AdaptiveSpacing.md),
            AdaptiveCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Time Picker', style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: AdaptiveSpacing.xs),
                  Text('Selected: ${_selectedTime.format(context)}'),
                  const SizedBox(height: AdaptiveSpacing.md),
                  AdaptiveButton.label(
                    onPressed: () async {
                      final result = await AdaptiveTimePicker.show(
                        context: context,
                        initialTime: _selectedTime,
                      );
                      if (result != null) setState(() => _selectedTime = result);
                    },
                    label: 'Pick Time',
                  ),
                ],
              ),
            ),
            const SizedBox(height: AdaptiveSpacing.md),
            AdaptiveCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Generic Wheel / Modal Picker', style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: AdaptiveSpacing.xs),
                  Text('Selected Country: $_selectedOption'),
                  const SizedBox(height: AdaptiveSpacing.md),
                  AdaptiveButton.label(
                    onPressed: () async {
                      final result = await AdaptivePicker.showValue<String>(
                        context: context,
                        items: _countries,
                        labelBuilder: (c) => c,
                        title: 'Select Country',
                      );
                      if (result != null) setState(() => _selectedOption = result);
                    },
                    label: 'Select From Wheel / Dialog',
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
