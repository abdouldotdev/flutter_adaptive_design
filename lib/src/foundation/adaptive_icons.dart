import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

import 'platform_utils.dart';

/// Type alias for icon data supported by the adaptive design system.
///
/// Supports HugeIcons data ([List<List<dynamic>>]), Flutter's [IconData],
/// or direct [Widget] instances.
typedef AdaptiveIconData = dynamic;

/// Semantic icon registry.
///
/// Icons are named by **purpose**, not by shape: [back] rather than
/// `arrowLeft01`. Call sites then read as intent, and swapping the underlying
/// glyph is a one-line change here instead of a repo-wide search.
abstract final class AdaptiveIcons {
  // Navigation
  static const AdaptiveIconData home = HugeIcons.strokeRoundedHome01;
  static const AdaptiveIconData back = HugeIcons.strokeRoundedArrowLeft01;
  static const AdaptiveIconData forward = HugeIcons.strokeRoundedArrowRight01;
  static const AdaptiveIconData chevronDown = HugeIcons.strokeRoundedArrowDown01;
  static const AdaptiveIconData menu = HugeIcons.strokeRoundedMenu01;
  static const AdaptiveIconData more = HugeIcons.strokeRoundedMoreHorizontal;
  static const AdaptiveIconData close = HugeIcons.strokeRoundedCancel01;

  // Identity & account
  static const AdaptiveIconData user = HugeIcons.strokeRoundedUser;
  static const AdaptiveIconData lock = HugeIcons.strokeRoundedLock;
  static const AdaptiveIconData password = HugeIcons.strokeRoundedLockPassword;
  static const AdaptiveIconData logout = HugeIcons.strokeRoundedLogout01;
  static const AdaptiveIconData visibility = HugeIcons.strokeRoundedView;
  static const AdaptiveIconData visibilityOff = HugeIcons.strokeRoundedViewOff;

  // Actions
  static const AdaptiveIconData add = HugeIcons.strokeRoundedAdd01;
  static const AdaptiveIconData edit = HugeIcons.strokeRoundedEdit01;
  static const AdaptiveIconData delete = HugeIcons.strokeRoundedDelete01;
  static const AdaptiveIconData copy = HugeIcons.strokeRoundedCopy01;
  static const AdaptiveIconData share = HugeIcons.strokeRoundedShare01;
  static const AdaptiveIconData download = HugeIcons.strokeRoundedDownload01;
  static const AdaptiveIconData upload = HugeIcons.strokeRoundedUpload01;
  static const AdaptiveIconData refresh = HugeIcons.strokeRoundedRefresh;
  static const AdaptiveIconData search = HugeIcons.strokeRoundedSearch01;
  static const AdaptiveIconData filter = HugeIcons.strokeRoundedFilter;

  // Status & feedback
  static const AdaptiveIconData success = HugeIcons.strokeRoundedCheckmarkCircle01;
  static const AdaptiveIconData check = HugeIcons.strokeRoundedTick01;
  static const AdaptiveIconData info = HugeIcons.strokeRoundedInformationCircle;
  static const AdaptiveIconData warning = HugeIcons.strokeRoundedAlert01;
  static const AdaptiveIconData error = HugeIcons.strokeRoundedAlertCircle;
  static const AdaptiveIconData help = HugeIcons.strokeRoundedHelpCircle;

  // Content
  static const AdaptiveIconData settings = HugeIcons.strokeRoundedSettings01;
  static const AdaptiveIconData notification = HugeIcons.strokeRoundedNotification01;
  static const AdaptiveIconData book = HugeIcons.strokeRoundedBook01;
  static const AdaptiveIconData wallet = HugeIcons.strokeRoundedWallet01;
  static const AdaptiveIconData analytics = HugeIcons.strokeRoundedAnalytics01;
  static const AdaptiveIconData calendar = HugeIcons.strokeRoundedCalendar01;
  static const AdaptiveIconData clock = HugeIcons.strokeRoundedClock01;

  /// Branches between two glyphs by platform.
  static T resolve<T>({
    required T material,
    required T cupertino,
  }) =>
      PlatformUtils.isCupertino ? cupertino : material;
}

/// An icon that picks up the platform's default foreground colour.
///
/// Automatically resolves colors: `CupertinoColors.label` on Cupertino
/// and `colorScheme.onSurface` on Material.
///
/// Accepts [HugeIcons] constants, Flutter [IconData], or custom [Widget]s.
class AdaptiveIcon extends StatelessWidget {
  /// The glyph to render, normally a constant from [AdaptiveIcons],
  /// a Flutter [IconData], or a [Widget].
  final dynamic icon;

  /// Size in logical pixels. 24 matches both the Material and the iOS default.
  final double size;

  /// Overrides the resolved foreground colour.
  final Color? color;

  /// Announced by screen readers. Provide it whenever the icon carries meaning
  /// that is not already in adjacent text.
  final String? semanticLabel;

  const AdaptiveIcon(
    this.icon, {
    super.key,
    this.size = 24,
    this.color,
    this.semanticLabel,
  });

  @override
  Widget build(BuildContext context) {
    final Color resolved = color ?? _defaultColor(context);

    final Widget glyph;
    if (icon is List<List<dynamic>>) {
      glyph = HugeIcon(
        icon: icon as List<List<dynamic>>,
        color: resolved,
        size: size,
      );
    } else if (icon is IconData) {
      glyph = Icon(
        icon as IconData,
        color: resolved,
        size: size,
      );
    } else if (icon is Widget) {
      glyph = icon as Widget;
    } else {
      glyph = SizedBox(width: size, height: size);
    }

    if (semanticLabel == null) return glyph;

    return Semantics(
      label: semanticLabel,
      child: ExcludeSemantics(child: glyph),
    );
  }

  Color _defaultColor(BuildContext context) {
    final TargetPlatform platform = Theme.of(context).platform;
    final bool isCupertino = PlatformUtils.isCupertino ||
        platform == TargetPlatform.iOS ||
        platform == TargetPlatform.macOS;

    if (isCupertino) {
      return CupertinoColors.label.resolveFrom(context);
    }
    return Theme.of(context).colorScheme.onSurface;
  }
}
