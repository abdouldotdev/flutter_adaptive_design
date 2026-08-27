import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../foundation/platform_utils.dart';
import '../layout/adaptive_liquid_glass.dart';

/// A segment definition for [AdaptiveSegmentedControl].
class AdaptiveSegment<T> {
  final T value;
  final Widget label;
  final Widget? icon;
  final bool enabled;

  const AdaptiveSegment({
    required this.value,
    required this.label,
    this.icon,
    this.enabled = true,
  });
}

/// Adaptive segmented control.
///
/// Material: [SegmentedButton<T>] with M3 styling.
/// Cupertino: [CupertinoSlidingSegmentedControl<T>] with native iOS styling,
/// and optional [AdaptiveLiquidGlass] frosted background.
class AdaptiveSegmentedControl<T extends Object> extends StatelessWidget {
  final List<AdaptiveSegment<T>> segments;
  final T selected;
  final ValueChanged<T> onSelectionChanged;
  final Color? backgroundColor;
  final Color? selectedColor;
  final EdgeInsetsGeometry? padding;

  /// Whether to render the control with a frosted Liquid Glass background.
  final bool useLiquidGlass;

  const AdaptiveSegmentedControl({
    super.key,
    required this.segments,
    required this.selected,
    required this.onSelectionChanged,
    this.backgroundColor,
    this.selectedColor,
    this.padding,
    this.useLiquidGlass = false,
  });

  void _onChanged(T? value) {
    if (value != null && value != selected) {
      HapticFeedback.selectionClick();
      onSelectionChanged(value);
    }
  }

  @override
  Widget build(BuildContext context) {
    final effectivePadding = padding ?? EdgeInsets.zero;

    if (PlatformUtils.isCupertino) {
      return Padding(
        padding: effectivePadding,
        child: _buildCupertinoControl(context),
      );
    }

    return Padding(
      padding: effectivePadding,
      child: _buildMaterialControl(context),
    );
  }

  Widget _buildCupertinoControl(BuildContext context) {
    final control = CupertinoSlidingSegmentedControl<T>(
      groupValue: selected,
      onValueChanged: _onChanged,
      backgroundColor: useLiquidGlass
          ? Colors.transparent
          : (backgroundColor ?? CupertinoColors.tertiarySystemFill),
      thumbColor: selectedColor ??
          CupertinoColors.systemBackground.resolveFrom(context),
      children: {
        for (final segment in segments)
          segment.value: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            child: segment.icon != null
                ? Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      segment.icon!,
                      const SizedBox(width: 6),
                      segment.label,
                    ],
                  )
                : segment.label,
          ),
      },
    );

    if (useLiquidGlass) {
      return AdaptiveLiquidGlass(
        variant: LiquidGlassVariant.ultraThin,
        borderRadius: BorderRadius.circular(10),
        padding: const EdgeInsets.all(2),
        child: control,
      );
    }

    return control;
  }

  Widget _buildMaterialControl(BuildContext context) {
    final control = SegmentedButton<T>(
      segments: segments
          .map(
            (segment) => ButtonSegment<T>(
              value: segment.value,
              label: segment.label,
              icon: segment.icon,
              enabled: segment.enabled,
            ),
          )
          .toList(),
      selected: {selected},
      onSelectionChanged: (values) {
        if (values.isNotEmpty) {
          _onChanged(values.first);
        }
      },
      style: ButtonStyle(
        backgroundColor: selectedColor != null
            ? WidgetStateProperty.resolveWith((states) {
                if (states.contains(WidgetState.selected)) {
                  return selectedColor;
                }
                return backgroundColor;
              })
            : null,
      ),
    );

    if (useLiquidGlass) {
      return AdaptiveLiquidGlass(
        variant: LiquidGlassVariant.ultraThin,
        borderRadius: BorderRadius.circular(20),
        padding: const EdgeInsets.all(2),
        child: control,
      );
    }

    return control;
  }
}
