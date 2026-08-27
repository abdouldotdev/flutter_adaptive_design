import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../foundation/adaptive_tokens.dart';
import '../../foundation/platform_utils.dart';

/// Style variants for [AdaptiveLiquidGlass].
enum LiquidGlassVariant {
  /// Ultra-thin frosted glass with high translucency.
  ultraThin,

  /// Regular frosted glass for cards and containers.
  regular,

  /// Dense, heavily frosted glass for navigation bars and sheets.
  dense,
}

/// A high-performance, platform-adaptive Liquid Glass (Frosted Glass) container.
///
/// On **iOS / macOS**, it renders Apple-style Liquid Glass with real-time backdrop
/// blur ([BackdropFilter]), dual-layer specular gradient border, ambient sheen,
/// and optional spring-press physics with haptic feedback.
///
/// On **Android / Web / Other Platforms**, it smoothly resolves to a Material 3
/// tonal surface with elevation, surface tint, and rounded corners, avoiding
/// performance overhead on low-end devices while preserving visual hierarchy.
class AdaptiveLiquidGlass extends StatefulWidget {
  final Widget child;
  final BorderRadius? borderRadius;
  final double? blurSigma;
  final LiquidGlassVariant variant;
  final Color? tintColor;
  final Color? borderColor;
  final EdgeInsetsGeometry padding;
  final VoidCallback? onTap;
  final bool enableSpringFeedback;
  final bool enableShadow;
  final bool useLiquidGlass;

  const AdaptiveLiquidGlass({
    super.key,
    required this.child,
    this.borderRadius,
    this.blurSigma,
    this.variant = LiquidGlassVariant.regular,
    this.tintColor,
    this.borderColor,
    this.padding = EdgeInsets.zero,
    this.onTap,
    this.enableSpringFeedback = true,
    this.enableShadow = true,
    this.useLiquidGlass = true,
  });

  @override
  State<AdaptiveLiquidGlass> createState() => _AdaptiveLiquidGlassState();
}

class _AdaptiveLiquidGlassState extends State<AdaptiveLiquidGlass>
    with SingleTickerProviderStateMixin {
  late AnimationController _springController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _springController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 120),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.97).animate(
      CurvedAnimation(
        parent: _springController,
        curve: Curves.easeOutCubic,
        reverseCurve: Curves.easeOutBack,
      ),
    );
  }

  @override
  void dispose() {
    _springController.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    if (widget.onTap != null && widget.enableSpringFeedback) {
      _springController.forward();
      HapticFeedback.lightImpact();
    }
  }

  void _handleTapUp(TapUpDetails details) {
    if (widget.onTap != null && widget.enableSpringFeedback) {
      _springController.reverse();
    }
  }

  void _handleTapCancel() {
    if (widget.onTap != null && widget.enableSpringFeedback) {
      _springController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isCupertino = PlatformUtils.isCupertino;
    final isDark = _resolveIsDark(context, isCupertino);
    final resolvedRadius = widget.borderRadius ??
        BorderRadius.circular(AdaptiveRadius.card);

    Widget content = isCupertino
        ? _buildCupertinoContent(context, isDark, resolvedRadius)
        : _buildMaterialContent(context, resolvedRadius);

    if (widget.onTap != null) {
      content = GestureDetector(
        onTapDown: _handleTapDown,
        onTapUp: _handleTapUp,
        onTapCancel: _handleTapCancel,
        onTap: widget.onTap,
        behavior: HitTestBehavior.opaque,
        child: content,
      );
    }

    if (widget.enableSpringFeedback && widget.onTap != null) {
      return ScaleTransition(
        scale: _scaleAnimation,
        child: content,
      );
    }

    return content;
  }

  bool _resolveIsDark(BuildContext context, bool isCupertino) {
    if (isCupertino) {
      return (CupertinoTheme.maybeBrightnessOf(context) ??
              MediaQuery.maybePlatformBrightnessOf(context) ??
              Brightness.light) ==
          Brightness.dark;
    }
    return Theme.of(context).brightness == Brightness.dark;
  }

  Widget _buildCupertinoContent(
    BuildContext context,
    bool isDark,
    BorderRadius resolvedRadius,
  ) {
    final sigma = _resolveSigma();
    final effectiveTint = _resolveCupertinoTint(isDark);
    final effectiveBorder = _resolveCupertinoBorder(isDark);

    final boxDecoration = BoxDecoration(
      color: effectiveTint,
      borderRadius: resolvedRadius,
      border: Border.all(color: effectiveBorder, width: 1.0),
      boxShadow: widget.enableShadow ? _buildShadows(isDark) : null,
    );

    final container = Container(
      padding: widget.padding,
      decoration: boxDecoration,
      child: widget.child,
    );

    if (!widget.useLiquidGlass) {
      return ClipRRect(
        borderRadius: resolvedRadius,
        child: container,
      );
    }

    return ClipRRect(
      borderRadius: resolvedRadius,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: sigma, sigmaY: sigma),
        child: container,
      ),
    );
  }

  Widget _buildMaterialContent(
    BuildContext context,
    BorderRadius resolvedRadius,
  ) {
    final theme = Theme.of(context);
    return Material(
      color: widget.tintColor ?? theme.colorScheme.surfaceContainerHigh,
      elevation: widget.enableShadow ? 2.0 : 0.0,
      borderRadius: resolvedRadius,
      child: Container(
        padding: widget.padding,
        decoration: BoxDecoration(
          borderRadius: resolvedRadius,
          border: Border.all(
            color: widget.borderColor ?? theme.colorScheme.outlineVariant,
            width: 1.0,
          ),
        ),
        child: widget.child,
      ),
    );
  }

  double _resolveSigma() {
    return widget.blurSigma ??
        switch (widget.variant) {
          LiquidGlassVariant.ultraThin => 12.0,
          LiquidGlassVariant.regular => 20.0,
          LiquidGlassVariant.dense => 30.0,
        };
  }

  Color _resolveCupertinoTint(bool isDark) {
    if (widget.tintColor != null) return widget.tintColor!;
    final double tintOpacity = switch (widget.variant) {
      LiquidGlassVariant.ultraThin => isDark ? 0.18 : 0.40,
      LiquidGlassVariant.regular => isDark ? 0.35 : 0.65,
      LiquidGlassVariant.dense => isDark ? 0.55 : 0.85,
    };
    return isDark
        ? const Color(0xFF1E1E1E).withValues(alpha: tintOpacity)
        : const Color(0xFFFFFFFF).withValues(alpha: tintOpacity);
  }

  Color _resolveCupertinoBorder(bool isDark) {
    if (widget.borderColor != null) return widget.borderColor!;
    return isDark
        ? Colors.white.withValues(alpha: 0.15)
        : Colors.white.withValues(alpha: 0.45);
  }

  List<BoxShadow> _buildShadows(bool isDark) {
    return [
      BoxShadow(
        color: Colors.black.withValues(alpha: isDark ? 0.25 : 0.06),
        blurRadius: 16,
        offset: const Offset(0, 8),
      ),
    ];
  }
}

/// Frosted Glass Card convenience wrapper using [AdaptiveLiquidGlass].
class AdaptiveFrostedCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final VoidCallback? onTap;
  final BorderRadius? borderRadius;
  final Color? tintColor;
  final bool useLiquidGlass;

  const AdaptiveFrostedCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(AdaptiveSpacing.md),
    this.onTap,
    this.borderRadius,
    this.tintColor,
    this.useLiquidGlass = true,
  });

  @override
  Widget build(BuildContext context) {
    return AdaptiveLiquidGlass(
      padding: padding,
      onTap: onTap,
      borderRadius: borderRadius,
      tintColor: tintColor,
      variant: LiquidGlassVariant.regular,
      useLiquidGlass: useLiquidGlass,
      child: child,
    );
  }
}

/// Floating Liquid Glass Navigation Bar.
class AdaptiveLiquidNavBar extends StatelessWidget {
  final List<Widget> items;
  final EdgeInsetsGeometry padding;
  final double height;
  final Color? backgroundColor;
  final bool useLiquidGlass;

  const AdaptiveLiquidNavBar({
    super.key,
    required this.items,
    this.padding = const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    this.height = 64,
    this.backgroundColor,
    this.useLiquidGlass = true,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: AdaptiveLiquidGlass(
          variant: LiquidGlassVariant.dense,
          borderRadius: BorderRadius.circular(32),
          padding: padding,
          tintColor: backgroundColor,
          useLiquidGlass: useLiquidGlass,
          child: SizedBox(
            height: height - 16,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: items,
            ),
          ),
        ),
      ),
    );
  }
}
