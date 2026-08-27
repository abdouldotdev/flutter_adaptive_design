import 'package:flutter/material.dart';
import 'package:flutter_adaptive_design/flutter_adaptive_design.dart';

class ResponsiveScreen extends StatelessWidget {
  const ResponsiveScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final sizeClass = Breakpoints.of(context);

    return AdaptiveScaffold(
      appBar: const AdaptiveAppBar(title: 'Responsive Layout'),
      body: SingleChildScrollView(
        padding: AdaptiveSpacing.pagePadding,
        child: AdaptiveConstrainedContent(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AdaptiveCard(
                child: Column(
                  children: [
                    Text(
                      'Window Size: ${sizeClass.name.toUpperCase()}',
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    const SizedBox(height: AdaptiveSpacing.sm),
                    Text(
                      'Screen width: ${MediaQuery.sizeOf(context).width.toStringAsFixed(1)} pt',
                      style: const TextStyle(color: Colors.grey),
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
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 24),
                        child: Text(
                          'Grid Item ${index + 1}',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
