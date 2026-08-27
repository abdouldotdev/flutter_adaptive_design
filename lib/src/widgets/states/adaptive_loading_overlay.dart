import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../foundation/adaptive_tokens.dart';
import '../../foundation/platform_utils.dart';
import '../feedback/adaptive_progress_indicator.dart';

/// Covers its [child] with a frosted glass scrim and a platform-native activity indicator
/// while [isLoading] is true.
///
/// Reach for this when an operation must block interaction with the screen
/// that is already on display — submitting a form, confirming a payment.
///
/// Features Liquid Glass (frosted blur) background on iOS and tonal overlay on Android.
class AdaptiveLoadingOverlay extends StatelessWidget {
  /// The content that the overlay covers.
  final Widget child;

  /// Whether the scrim and the indicator are shown.
  final bool isLoading;

  /// Optional line of text under the indicator, e.g. `'Signing in…'`.
  final String? message;

  /// Overrides the scrim colour.
  final Color? barrierColor;

  /// Alpha applied to the default scrim colour. Ignored when [barrierColor] is set.
  final double barrierOpacity;

  /// Announced by screen readers while the overlay is up.
  final String semanticsLabel;

  /// Whether to enable Liquid Glass frosted backdrop blur. Defaults to true.
  final bool useLiquidGlass;

  /// Gaussian blur intensity for the Liquid Glass effect. Defaults to 16.0.
  final double blurSigma;

  const AdaptiveLoadingOverlay({
    super.key,
    required this.child,
    required this.isLoading,
    this.message,
    this.barrierColor,
    this.barrierOpacity = 0.7,
    this.semanticsLabel = 'Loading',
    this.useLiquidGlass = true,
    this.blurSigma = 16.0,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        child,
        if (isLoading) Positioned.fill(child: _buildBarrier(context)),
      ],
    );
  }

  Widget _buildBarrier(BuildContext context) {
    final Color scrim = barrierColor ??
        AdaptiveColors.background(context).withValues(alpha: barrierOpacity);

    Widget barrierContent = ColoredBox(
      color: scrim,
      child: Center(
        child: SingleChildScrollView(
          padding: AdaptiveSpacing.pagePadding,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const AdaptiveProgressIndicator(),
              if (message != null) ...<Widget>[
                const SizedBox(height: AdaptiveSpacing.lg),
                Text(
                  message!,
                  textAlign: TextAlign.center,
                  style: _messageStyle(context),
                ),
              ],
            ],
          ),
        ),
      ),
    );

    if (useLiquidGlass && (PlatformUtils.isCupertino || blurSigma > 0)) {
      barrierContent = ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: blurSigma, sigmaY: blurSigma),
          child: barrierContent,
        ),
      );
    }

    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0, end: 1),
      duration: AdaptiveMotion.micro,
      curve: AdaptiveMotion.enterCurve,
      builder: (BuildContext context, double value, Widget? child) =>
          Opacity(opacity: value, child: child),
      child: AbsorbPointer(
        child: Semantics(
          label: semanticsLabel,
          liveRegion: true,
          child: barrierContent,
        ),
      ),
    );
  }

  TextStyle _messageStyle(BuildContext context) {
    final Color color = AdaptiveColors.secondaryLabel(context);
    if (PlatformUtils.isCupertino) {
      return CupertinoTheme.of(context)
          .textTheme
          .textStyle
          .copyWith(color: color);
    }
    return Theme.of(context).textTheme.bodyMedium?.copyWith(color: color) ??
        TextStyle(color: color);
  }
}
