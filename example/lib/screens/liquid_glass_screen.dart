import 'package:flutter/material.dart';
import 'package:flutter_adaptive_design/flutter_adaptive_design.dart';

import '../app_controller.dart';

class LiquidGlassScreen extends StatelessWidget {
  const LiquidGlassScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AdaptiveScaffold(
      appBar: const AdaptiveAppBar(
        title: 'Liquid Glass UI',
        actions: [PlatformSwitchAction()],
      ),
      body: Stack(
        children: [
          // Background Gradient to demonstrate authentic translucent backdrop blur
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xFF6A11CB),
                    Color(0xFF2575FC),
                    Color(0xFFFF0844),
                    Color(0xFFFFB199),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),
          ),
          SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                AdaptiveFrostedCard(
                  onTap: () {},
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          AdaptiveIcon(AdaptiveIcons.sparkles, color: Colors.white, size: 24),
                          SizedBox(width: 8),
                          Text(
                            'Liquid Glass Card (Tap Me)',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Pure Dart real-time backdrop blur with specular gradient borders, spring-damping press animations, and haptic feedback.',
                        style: TextStyle(color: Colors.white70, fontSize: 13),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                AdaptiveLiquidGlass(
                  variant: LiquidGlassVariant.ultraThin,
                  padding: const EdgeInsets.all(16),
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Ultra-Thin Glass Surface',
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'High translucency, light blur intensity for overlays.',
                        style: TextStyle(color: Colors.white70, fontSize: 12),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                AdaptiveLiquidGlass(
                  variant: LiquidGlassVariant.dense,
                  padding: const EdgeInsets.all(16),
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Dense Frosted Surface',
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Strong blur (sigma 30) for floating navigation bars, bottom sheets, and toolbars.',
                        style: TextStyle(color: Colors.white70, fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: AdaptiveLiquidNavBar(
              items: [
                AdaptiveIconButton(
                  onPressed: () {},
                  icon: const AdaptiveIcon(AdaptiveIcons.home, color: Colors.white),
                ),
                AdaptiveIconButton(
                  onPressed: () {},
                  icon: const AdaptiveIcon(AdaptiveIcons.analytics, color: Colors.white),
                ),
                AdaptiveIconButton(
                  onPressed: () {},
                  icon: const AdaptiveIcon(AdaptiveIcons.wallet, color: Colors.white),
                ),
                AdaptiveIconButton(
                  onPressed: () {},
                  icon: const AdaptiveIcon(AdaptiveIcons.settings, color: Colors.white),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
