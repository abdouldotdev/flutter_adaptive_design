import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../foundation/platform_utils.dart';
import '../layout/adaptive_liquid_glass.dart';

/// Adaptive snack bar that renders a [SnackBar] on Material platforms
/// and a custom iOS-style overlay toast / floating liquid glass banner on Cupertino platforms.
class AdaptiveSnackBar {
  const AdaptiveSnackBar._();

  /// Shows a platform-adaptive snack bar / toast.
  static void show({
    required BuildContext context,
    required String message,
    String? actionLabel,
    VoidCallback? onAction,
    Duration duration = const Duration(seconds: 3),
    Color? backgroundColor,
    Color? textColor,
    bool useLiquidGlass = false,
    Widget? leading,
  }) {
    HapticFeedback.lightImpact();

    if (useLiquidGlass || PlatformUtils.isCupertino) {
      _showOverlayToast(
        context: context,
        message: message,
        actionLabel: actionLabel,
        onAction: onAction,
        duration: duration,
        backgroundColor: backgroundColor,
        textColor: textColor,
        useLiquidGlass: useLiquidGlass,
        leading: leading,
      );
    } else {
      _showMaterialSnackBar(
        context: context,
        message: message,
        actionLabel: actionLabel,
        onAction: onAction,
        duration: duration,
        backgroundColor: backgroundColor,
        textColor: textColor,
      );
    }
  }

  static void _showMaterialSnackBar({
    required BuildContext context,
    required String message,
    String? actionLabel,
    VoidCallback? onAction,
    required Duration duration,
    Color? backgroundColor,
    Color? textColor,
  }) {
    final snackBar = SnackBar(
      content: Text(
        message,
        style: textColor != null ? TextStyle(color: textColor) : null,
      ),
      duration: duration,
      backgroundColor: backgroundColor,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      action: actionLabel != null
          ? SnackBarAction(
              label: actionLabel,
              textColor: textColor,
              onPressed: () {
                HapticFeedback.selectionClick();
                onAction?.call();
              },
            )
          : null,
    );

    final messenger = ScaffoldMessenger.maybeOf(context);
    if (messenger != null) {
      try {
        messenger
          ..hideCurrentSnackBar()
          ..showSnackBar(snackBar);
        return;
      } catch (_) {
        // Fall back to overlay toast
      }
    }

    _showOverlayToast(
      context: context,
      message: message,
      actionLabel: actionLabel,
      onAction: onAction,
      duration: duration,
      backgroundColor: backgroundColor,
      textColor: textColor,
    );
  }

  static void _showOverlayToast({
    required BuildContext context,
    required String message,
    String? actionLabel,
    VoidCallback? onAction,
    required Duration duration,
    Color? backgroundColor,
    Color? textColor,
    bool useLiquidGlass = false,
    Widget? leading,
  }) {
    final overlay = Overlay.of(context);
    late final OverlayEntry entry;
    late final AnimationController controller;
    Timer? timer;

    controller = AnimationController(
      vsync: overlay,
      duration: const Duration(milliseconds: 300),
      reverseDuration: const Duration(milliseconds: 200),
    );

    final curved = CurvedAnimation(
      parent: controller,
      curve: Curves.easeOutCubic,
      reverseCurve: Curves.easeInCubic,
    );

    void dismiss() {
      timer?.cancel();
      if (controller.isAnimating ||
          controller.status == AnimationStatus.dismissed) {
        return;
      }
      controller.reverse().then((_) {
        entry.remove();
        controller.dispose();
      });
    }

    entry = OverlayEntry(
      builder: (context) {
        return _FloatingToastOverlay(
          animation: curved,
          message: message,
          actionLabel: actionLabel,
          onAction: onAction,
          backgroundColor: backgroundColor,
          textColor: textColor,
          useLiquidGlass: useLiquidGlass,
          leading: leading,
          onDismiss: dismiss,
        );
      },
    );

    overlay.insert(entry);
    controller.forward();

    timer = Timer(duration, () {
      if (controller.status == AnimationStatus.completed) {
        dismiss();
      }
    });
  }
}

class _FloatingToastOverlay extends StatelessWidget {
  final Animation<double> animation;
  final String message;
  final String? actionLabel;
  final VoidCallback? onAction;
  final VoidCallback onDismiss;
  final Color? backgroundColor;
  final Color? textColor;
  final bool useLiquidGlass;
  final Widget? leading;

  const _FloatingToastOverlay({
    required this.animation,
    required this.message,
    this.actionLabel,
    this.onAction,
    required this.onDismiss,
    this.backgroundColor,
    this.textColor,
    this.useLiquidGlass = false,
    this.leading,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: SafeArea(
        child: FadeTransition(
          opacity: animation,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, 0.3),
              end: Offset.zero,
            ).animate(animation),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: GestureDetector(
                onVerticalDragEnd: (details) {
                  if (details.primaryVelocity != null &&
                      details.primaryVelocity! > 0) {
                    onDismiss();
                  }
                },
                child: _buildBannerContent(context),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBannerContent(BuildContext context) {
    final body = _buildInnerRow(context);

    if (useLiquidGlass) {
      return AdaptiveLiquidGlass(
        variant: LiquidGlassVariant.dense,
        borderRadius: BorderRadius.circular(18),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        tintColor: backgroundColor,
        child: body,
      );
    }

    final brightness = CupertinoTheme.brightnessOf(context);
    final isDark = brightness == Brightness.dark;
    final effectiveBackground = backgroundColor ??
        (isDark ? const Color(0xE6363636) : const Color(0xE6F2F2F7));

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: effectiveBackground,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: body,
    );
  }

  Widget _buildInnerRow(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final effectiveTextColor = textColor ??
        (isDark ? CupertinoColors.white : CupertinoColors.black);

    return Row(
      children: [
        if (leading != null) ...[
          leading!,
          const SizedBox(width: 10),
        ],
        Expanded(
          child: Text(
            message,
            style: TextStyle(
              color: effectiveTextColor,
              fontSize: 14,
              fontWeight: FontWeight.w500,
              decoration: TextDecoration.none,
            ),
          ),
        ),
        if (actionLabel != null) ...[
          const SizedBox(width: 12),
          CupertinoButton(
            padding: EdgeInsets.zero,
            minimumSize: Size.zero,
            onPressed: () {
              HapticFeedback.selectionClick();
              onDismiss();
              onAction?.call();
            },
            child: Text(
              actionLabel!,
              style: TextStyle(
                color: CupertinoTheme.of(context).primaryColor,
                fontSize: 14,
                fontWeight: FontWeight.w600,
                decoration: TextDecoration.none,
              ),
            ),
          ),
        ],
      ],
    );
  }
}
