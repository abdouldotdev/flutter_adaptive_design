# Flutter Adaptive Design (`flutter_adaptive_design`)

[![pub package](https://img.shields.io/pub/v/flutter_adaptive_design.svg?color=blue)](https://pub.dev/packages/flutter_adaptive_design)
[![likes](https://img.shields.io/pub/likes/flutter_adaptive_design)](https://pub.dev/packages/flutter_adaptive_design/score)
[![popularity](https://img.shields.io/pub/popularity/flutter_adaptive_design)](https://pub.dev/packages/flutter_adaptive_design/score)
[![pub points](https://img.shields.io/pub/points/flutter_adaptive_design)](https://pub.dev/packages/flutter_adaptive_design/score)
[![license](https://img.shields.io/badge/license-MIT-blue.svg)](https://github.com/abdouldotdev/flutter_adaptive_design/blob/main/LICENSE)
[![platform](https://img.shields.io/badge/platform-iOS%20%7C%20Android%20%7C%20Web%20%7C%20macOS%20%7C%20Windows%20%7C%20Linux-lightgrey.svg)](https://pub.dev/packages/flutter_adaptive_design)
[![code style](https://img.shields.io/badge/style-flutter__lints-blue)](https://pub.dev/packages/flutter_lints)

> **The unified, production-grade Flutter design system that automatically renders native iOS (Apple Human Interface Guidelines / Cupertino) and Android (Material Design 3) from a single codebase.**

Stop writing messy `if (Theme.of(context).platform == TargetPlatform.iOS)` conditionals. `flutter_adaptive_design` gives you **50+ production-ready adaptive widgets**, **system design tokens** (8pt spacing, platform radii, eased motion curves), **semantic iconography** via HugeIcons & Material/Cupertino glyphs, **responsive multi-device layouts**, and a **bi-platform test harness**.

---

## ⚡ Quick Links & Navigation

- [Why Flutter Adaptive Design?](#-why-flutter_adaptive_design)
- [Feature Comparison vs Existing Solutions](#-feature-comparison)
- [Installation](#-installation)
- [Quick Start in 60 Seconds](#-quick-start)
- [Design Tokens (Spacing, Radius, Motion, Colors, Typography)](#-design-tokens--foundations)
- [Complete Component Catalog (+96 Components)](#-component-catalog)
- [Real-World Screen Recipes (Settings, Auth, Responsive)](#-real-world-recipes)
- [Bi-Platform Testing Guide](#-bi-platform-testing-guide)
- [Live Preview & Platform Switching](#-live-preview--platform-switching)
- [Frequently Asked Questions (FAQ)](#-frequently-asked-questions-faq)
- [Interactive Example Gallery](#-example-application)
- [License & Contributing](#-license)

---

## 💡 Why `flutter_adaptive_design`?

Building cross-platform apps often leads to the **"uncanny valley"** of mobile UI:
- Material buttons and bottom sheets on iPhones make iOS users feel alienated.
- Cupertino navigation bars and bouncing overscroll on Android feel out of place.
- Manually branching widget trees (`Platform.isIOS ? ... : ...`) bloats codebases and breaks on Flutter Web due to `dart:io` runtime crashes.
- Custom styling often breaks text scaling accessibility (Dynamic Type / font scaler) and accessibility touch targets (44pt on iOS, 48dp on Android).

`flutter_adaptive_design` solves this once and for all:

```
                          ┌───────────────────────────┐
                          │   Adaptive Component API  │
                          │   (e.g., AdaptiveButton)   │
                          └─────────────┬─────────────┘
                                        │
                 ┌──────────────────────┴──────────────────────┐
                 ▼                                             ▼
     ┌───────────────────────┐                     ┌───────────────────────┐
     │      iOS / macOS      │                     │   Android / Web / OS  │
     │  Apple Cupertino HIG  │                     │   Google Material 3   │
     ├───────────────────────┤                     ├───────────────────────┤
     │ • CupertinoButton     │                     │ • FilledButton (M3)   │
     │ • CupertinoTextField  │                     │ • TextField (M3)      │
     │ • CupertinoActionSheet│                     │ • Modal BottomSheet   │
     │ • BouncingScroll      │                     │ • ClampingScroll      │
     │ • 10pt Squircle Radius│                     │ • 20pt Pill Radius    │
     │ • EaseInOut Motion    │                     │ • Emphasized Easing   │
     └───────────────────────┘                     └───────────────────────┘
```

---

## 📊 Feature Comparison

| Capability | Standard Flutter | `flutter_platform_widgets` | `flutter_adaptive_design` |
|---|:---:|:---:|:---:|
| **Material 3 (M3) Native Support** | Manual | Partial | **100% Native M3** |
| **Cupertino HIG Fidelity** | Manual | Basic | **Pixel-Perfect HIG** |
| **Web-Safe (No `dart:io` crashes)** | ⚠️ Manual | ⚠️ Config needed | **Zero Web Crashes** |
| **Standard Design Tokens (8pt grid)** | ❌ None | ❌ None | **Built-in (`AdaptiveTokens`)** |
| **Platform Easing & Motion Curves** | ❌ Manual | ❌ None | **Built-in (`AdaptiveMotion`)** |
| **Semantic Iconography (HugeIcons/SVG)** | ❌ None | ❌ None | **Built-in (`AdaptiveIcons`)** |
| **Responsive Engine (Breakpoints/Grid)** | ⚠️ Complex | ❌ None | **Built-in (`Breakpoints`)** |
| **Bi-Platform Test Runner** | ❌ Manual | ❌ None | **Built-in (`testAdaptiveWidget`)** |
| **Live Platform Preview (Web & Release)** | ❌ Throws | ❌ None | **Built-in (`debugOverridePlatform`)** |

---

## 📦 Installation

Add `flutter_adaptive_design` and `hugeicons` to your `pubspec.yaml`:

```bash
flutter pub add flutter_adaptive_design hugeicons
```

Or manually:

```yaml
dependencies:
  flutter:
    sdk: flutter
  flutter_adaptive_design: ^1.0.0
  hugeicons: ^1.1.7
```

---

## 🚀 Quick Start

### 1. Import the Package

```dart
import 'package:flutter_adaptive_design/flutter_adaptive_design.dart';
// Or use the short alias:
// import 'package:flutter_adaptive_design/adaptive.dart';
```

### 2. Build Platform-Native Screens

```dart
import 'package:flutter/material.dart';
import 'package:flutter_adaptive_design/flutter_adaptive_design.dart';

class QuickStartView extends StatefulWidget {
  const QuickStartView({super.key});

  @override
  State<QuickStartView> createState() => _QuickStartViewState();
}

class _QuickStartViewState extends State<QuickStartView> {
  bool _faceIdEnabled = true;
  final TextEditingController _searchCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AdaptiveScaffold(
      appBar: const AdaptiveAppBar(
        title: 'Account Settings',
      ),
      body: SingleChildScrollView(
        padding: AdaptiveSpacing.pagePadding,
        child: Column(
          children: [
            AdaptiveSearchBar(
              controller: _searchCtrl,
              placeholder: 'Search preferences...',
            ),
            const SizedBox(height: AdaptiveSpacing.md),
            AdaptiveCard(
              child: Column(
                children: [
                  AdaptiveListTile(
                    leading: const AdaptiveIcon(AdaptiveIcons.lock),
                    title: const Text('Biometric Login'),
                    subtitle: const Text('FaceID / TouchID / Fingerprint'),
                    trailing: AdaptiveSwitch(
                      value: _faceIdEnabled,
                      onChanged: (val) => setState(() => _faceIdEnabled = val),
                    ),
                  ),
                  const AdaptiveDivider(),
                  AdaptiveListTile(
                    leading: const AdaptiveIcon(AdaptiveIcons.notification),
                    title: const Text('Push Notifications'),
                    trailing: const AdaptiveIcon(AdaptiveIcons.forward, size: 16),
                    onTap: () {},
                  ),
                ],
              ),
            ),
            const SizedBox(height: AdaptiveSpacing.lg),
            AdaptiveButton.label(
              onPressed: () {
                AdaptiveDialog.show(
                  context: context,
                  title: 'Sign Out',
                  content: 'Are you sure you want to log out of your session?',
                  actions: [
                    AdaptiveDialogAction(
                      label: 'Cancel',
                      onPressed: () => Navigator.pop(context),
                    ),
                    AdaptiveDialogAction(
                      label: 'Sign Out',
                      isDestructive: true,
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                );
              },
              label: 'Sign Out',
            ),
          ],
        ),
      ),
    );
  }
}
```

---

## 🎨 Design Tokens & Foundations

### 1. Spacing (`AdaptiveSpacing`)
Strict 8-point spatial grid with 4-point precision:

| Token | Dimension | Intended Usage |
|---|:---:|---|
| `AdaptiveSpacing.xs` | **4pt** | Micro-offsets, badge paddings, icon-to-text spacing |
| `AdaptiveSpacing.sm` | **8pt** | Compact paddings, list item inner gaps |
| `AdaptiveSpacing.md` | **12pt** | Form field vertical gutters, card content margins |
| `AdaptiveSpacing.lg` | **16pt** | Standard page gutter, root screen container padding |
| `AdaptiveSpacing.xl` | **24pt** | Section-to-section separators, headline spacing |
| `AdaptiveSpacing.xxl` | **32pt** | Major view divisions |
| `AdaptiveSpacing.xxxl` | **48pt** | Empty state illustrations, hero headers |

### 2. Corner Radii (`AdaptiveRadius`)
Matches native platform surface geometry:

| Component | iOS (Cupertino HIG) | Android (Material 3) |
|---|:---:|:---:|
| **Card** | `10pt` (Smooth Squircle) | `12pt` (Rounded Corner) |
| **Button** | `10pt` (Continuous Corner) | `20pt` (M3 Full Pill) |
| **Dialog** | `14pt` | `28pt` |
| **Text Field** | `8pt` | `4pt` |
| **Modal Sheet** | `12pt` | `28pt` |

### 3. Motion & Animation Curves (`AdaptiveMotion`)
Physics-calibrated animation durations and easing:
- `AdaptiveMotion.micro`: `120ms` (taps, toggles, check states)
- `AdaptiveMotion.transition`: `280ms` (bottom sheets, dialogs, drawers)
- `AdaptiveMotion.page`: `380ms` (page routes, navigation transitions)
- `AdaptiveMotion.pageCurve`: `Curves.easeInOut` (iOS) ↔ `Curves.easeInOutCubicEmphasized` (Android M3)

### 4. Semantic Iconography (`AdaptiveIcons` & `AdaptiveIcon`)
Unified icon registry supporting **HugeIcons stroke-rounded**, standard **Flutter `IconData`**, and **custom widgets** with automatic Dark/Light dynamic color resolution:

```dart
// Intent-based semantic presets:
AdaptiveIcon(AdaptiveIcons.home)
AdaptiveIcon(AdaptiveIcons.wallet)
AdaptiveIcon(AdaptiveIcons.settings)
AdaptiveIcon(AdaptiveIcons.error, color: AdaptiveColors.destructive(context))

// Custom IconData fallback:
AdaptiveIcon(Icons.star, color: Colors.amber)
```

---

## 🧩 Component Catalog

### 🏗️ Layout & Navigation
- [`AdaptiveScaffold`](file:///Users/abdoul/development/appbiz-studio/flutter_adaptive_design/lib/src/widgets/layout/adaptive_scaffold.dart): Resolves `Scaffold` (M3) or `CupertinoPageScaffold` (iOS) with seamless top bar attachment.
- [`AdaptiveAppBar`](file:///Users/abdoul/development/appbiz-studio/flutter_adaptive_design/lib/src/widgets/layout/adaptive_app_bar.dart): Implements `PreferredSizeWidget` and `ObstructingPreferredSizeWidget`.
- [`AdaptiveSliverAppBar`](file:///Users/abdoul/development/appbiz-studio/flutter_adaptive_design/lib/src/widgets/layout/adaptive_sliver_app_bar.dart): Large collapsible iOS navigation bar or M3 large app bar.
- [`AdaptiveBottomNav`](file:///Users/abdoul/development/appbiz-studio/flutter_adaptive_design/lib/src/widgets/layout/adaptive_bottom_nav.dart): Cupertino bottom tab bar or M3 NavigationBar.
- [`AdaptiveCard`](file:///Users/abdoul/development/appbiz-studio/flutter_adaptive_design/lib/src/widgets/layout/adaptive_card.dart): Native squircle container on iOS, elevated M3 card on Android.
- [`AdaptiveListTile`](file:///Users/abdoul/development/appbiz-studio/flutter_adaptive_design/lib/src/widgets/layout/adaptive_list_tile.dart) & [`AdaptiveListSection`](file:///Users/abdoul/development/appbiz-studio/flutter_adaptive_design/lib/src/widgets/layout/adaptive_list_section.dart): Grouped iOS settings style or Material list view.
- [`AdaptiveDivider`](file:///Users/abdoul/development/appbiz-studio/flutter_adaptive_design/lib/src/widgets/layout/adaptive_divider.dart): 0.5pt hairline separator on iOS, 1dp divider on Android.
- [`AdaptiveTabBar`](file:///Users/abdoul/development/appbiz-studio/flutter_adaptive_design/lib/src/widgets/navigation/adaptive_tab_bar.dart): Segmented control on iOS, `TabBar` + `TabBarView` on Android.
- [`AdaptiveNavigationDrawer`](file:///Users/abdoul/development/appbiz-studio/flutter_adaptive_design/lib/src/widgets/navigation/adaptive_navigation_drawer.dart): iOS modal drawer or M3 permanent/modal navigation drawer.
- [`AdaptivePageRoute`](file:///Users/abdoul/development/appbiz-studio/flutter_adaptive_design/lib/src/widgets/navigation/adaptive_page_route.dart): Push transitions with swipe-to-back gesture on iOS.

### 🔘 Buttons & Inputs
- [`AdaptiveButton`](file:///Users/abdoul/development/appbiz-studio/flutter_adaptive_design/lib/src/widgets/buttons/adaptive_button.dart): Primary filled button (`CupertinoButton.filled` / `FilledButton`).
- [`AdaptiveTextButton`](file:///Users/abdoul/development/appbiz-studio/flutter_adaptive_design/lib/src/widgets/buttons/adaptive_text_button.dart): Borderless action button.
- [`AdaptiveIconButton`](file:///Users/abdoul/development/appbiz-studio/flutter_adaptive_design/lib/src/widgets/buttons/adaptive_icon_button.dart): Touch-target compliant icon trigger.
- [`AdaptiveFAB`](file:///Users/abdoul/development/appbiz-studio/flutter_adaptive_design/lib/src/widgets/buttons/adaptive_fab.dart): Circular floating button on iOS / FloatingActionButton on Android.
- [`AdaptiveLoadingButton`](file:///Users/abdoul/development/appbiz-studio/flutter_adaptive_design/lib/src/widgets/states/adaptive_loading_button.dart): Button with integrated activity indicator.
- [`AdaptiveTextField`](file:///Users/abdoul/development/appbiz-studio/flutter_adaptive_design/lib/src/widgets/inputs/adaptive_text_field.dart) & [`AdaptiveFormField`](file:///Users/abdoul/development/appbiz-studio/flutter_adaptive_design/lib/src/widgets/inputs/adaptive_form_field.dart): Native text input with form validation.
- [`AdaptiveSearchBar`](file:///Users/abdoul/development/appbiz-studio/flutter_adaptive_design/lib/src/widgets/inputs/adaptive_search_bar.dart): `CupertinoSearchTextField` or M3 `SearchBar`.
- [`AdaptiveSwitch`](file:///Users/abdoul/development/appbiz-studio/flutter_adaptive_design/lib/src/widgets/inputs/adaptive_switch.dart), [`AdaptiveSlider`](file:///Users/abdoul/development/appbiz-studio/flutter_adaptive_design/lib/src/widgets/inputs/adaptive_slider.dart), [`AdaptiveCheckbox`](file:///Users/abdoul/development/appbiz-studio/flutter_adaptive_design/lib/src/widgets/inputs/adaptive_checkbox.dart), [`AdaptiveRadio`](file:///Users/abdoul/development/appbiz-studio/flutter_adaptive_design/lib/src/widgets/inputs/adaptive_radio.dart).
- [`AdaptiveSegmentedControl`](file:///Users/abdoul/development/appbiz-studio/flutter_adaptive_design/lib/src/widgets/inputs/adaptive_segmented_control.dart): Multi-option pill selector.

### 💬 Feedback & Overlays
- [`AdaptiveDialog`](file:///Users/abdoul/development/appbiz-studio/flutter_adaptive_design/lib/src/widgets/feedback/adaptive_dialog.dart): `CupertinoAlertDialog` on iOS, `AlertDialog` on Android.
- [`AdaptiveActionSheet`](file:///Users/abdoul/development/appbiz-studio/flutter_adaptive_design/lib/src/widgets/feedback/adaptive_action_sheet.dart): Modal action sheet (iOS) / Bottom sheet with actions (Android).
- [`AdaptiveSnackBar`](file:///Users/abdoul/development/appbiz-studio/flutter_adaptive_design/lib/src/widgets/feedback/adaptive_snack_bar.dart): Non-intrusive floating toast/snack.
- [`AdaptiveProgressIndicator`](file:///Users/abdoul/development/appbiz-studio/flutter_adaptive_design/lib/src/widgets/feedback/adaptive_progress_indicator.dart): `CupertinoActivityIndicator` or `CircularProgressIndicator`.
- [`AdaptiveRefreshIndicator`](file:///Users/abdoul/development/appbiz-studio/flutter_adaptive_design/lib/src/widgets/feedback/adaptive_refresh_indicator.dart): iOS native pull-down spinner or Android overscroll swipe refresh.
- [`AdaptiveTooltip`](file:///Users/abdoul/development/appbiz-studio/flutter_adaptive_design/lib/src/widgets/feedback/adaptive_tooltip.dart): Touch and hover-aware tooltip.
- [`AdaptiveContextMenu`](file:///Users/abdoul/development/appbiz-studio/flutter_adaptive_design/lib/src/widgets/context_menu/adaptive_context_menu.dart): Peek & pop contextual menu on iOS / Long-press menu on Android.
- [`AdaptivePopupMenu`](file:///Users/abdoul/development/appbiz-studio/flutter_adaptive_design/lib/src/widgets/navigation/adaptive_popup_menu.dart): Anchor popup menu.

### ⚡ State & Skeleton Patterns
- [`AdaptiveEmptyState`](file:///Users/abdoul/development/appbiz-studio/flutter_adaptive_design/lib/src/widgets/states/adaptive_empty_state.dart): Illustrated empty container with CTA.
- [`AdaptiveErrorState`](file:///Users/abdoul/development/appbiz-studio/flutter_adaptive_design/lib/src/widgets/states/adaptive_error_state.dart) & [`AdaptiveErrorBanner`](file:///Users/abdoul/development/appbiz-studio/flutter_adaptive_design/lib/src/widgets/states/adaptive_error_banner.dart): Full-page and inline error states.
- [`AdaptiveLoadingOverlay`](file:///Users/abdoul/development/appbiz-studio/flutter_adaptive_design/lib/src/widgets/states/adaptive_loading_overlay.dart) & [`AdaptiveLoadingPage`](file:///Users/abdoul/development/appbiz-studio/flutter_adaptive_design/lib/src/widgets/states/adaptive_loading_page.dart).
- [`AdaptiveSkeletonBox`](file:///Users/abdoul/development/appbiz-studio/flutter_adaptive_design/lib/src/widgets/states/adaptive_skeleton.dart), [`AdaptiveSkeletonListTile`](file:///Users/abdoul/development/appbiz-studio/flutter_adaptive_design/lib/src/widgets/states/adaptive_skeleton.dart), [`AdaptiveSkeletonCard`](file:///Users/abdoul/development/appbiz-studio/flutter_adaptive_design/lib/src/widgets/states/adaptive_skeleton.dart).
- [`AdaptiveShimmer`](file:///Users/abdoul/development/appbiz-studio/flutter_adaptive_design/lib/src/widgets/states/adaptive_shimmer.dart): Shimmer animation wrapper.
- [`AdaptiveDisabled`](file:///Users/abdoul/development/appbiz-studio/flutter_adaptive_design/lib/src/widgets/states/adaptive_disabled.dart): Accessible dimming and interaction suppressor.

### 📐 Responsive Engine
- [`Breakpoints`](file:///Users/abdoul/development/appbiz-studio/flutter_adaptive_design/lib/src/responsive/breakpoints.dart): `compact` (<600pt), `medium` (600–840pt), `expanded` (840–1200pt), `large` (>=1200pt).
- [`AdaptiveConstrainedContent`](file:///Users/abdoul/development/appbiz-studio/flutter_adaptive_design/lib/src/responsive/adaptive_constrained_content.dart): Center-constrains page width on desktop/tablets.
- [`AdaptiveResponsiveGrid`](file:///Users/abdoul/development/appbiz-studio/flutter_adaptive_design/lib/src/responsive/adaptive_responsive_grid.dart): Auto-fit multi-column responsive grid.
- [`AdaptiveMasterDetail`](file:///Users/abdoul/development/appbiz-studio/flutter_adaptive_design/lib/src/responsive/adaptive_master_detail.dart): Split-pane layout on tablets/web, push-route on phones.
- [`AdaptiveResponsiveScaffold`](file:///Users/abdoul/development/appbiz-studio/flutter_adaptive_design/lib/src/responsive/adaptive_responsive_scaffold.dart): Responsive scaffold with bottom nav on phone, rail on tablet, permanent drawer on desktop.

---

## 🍳 Real-World Recipes

### Recipe 1: Native Date & Time Pickers

```dart
// Native Date Picker (iOS Modal Wheel / Material Calendar Dialog)
final DateTime? selectedDate = await AdaptiveDatePicker.show(
  context: context,
  initialDate: DateTime.now(),
  firstDate: DateTime(2020),
  lastDate: DateTime(2030),
);

// Native Time Picker (iOS Wheel / Material Clock Dialog)
final TimeOfDay? selectedTime = await AdaptiveTimePicker.show(
  context: context,
  initialTime: TimeOfDay.now(),
);
```

### Recipe 2: Multi-Device Responsive Master-Detail

```dart
class MessagesScreen extends StatelessWidget {
  const MessagesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AdaptiveMasterDetail(
      master: ListView.builder(
        itemCount: 20,
        itemBuilder: (context, index) => AdaptiveListTile(
          title: Text('Conversation #$index'),
          subtitle: const Text('Latest message snippet...'),
          onTap: () {
            // Automatically updates detail view on tablet/desktop,
            // or pushes route on mobile!
          },
        ),
      ),
      detail: const Center(
        child: Text('Select a conversation to view messages'),
      ),
    );
  }
}
```

---

## 🧪 Bi-Platform Testing Guide

`flutter_adaptive_design` exports a dedicated test runner via `package:flutter_adaptive_design/testing.dart`.

Every test wrapped with `testAdaptiveWidget` runs **twice**:
1. Once for `TargetPlatform.android` (Material 3)
2. Once for `TargetPlatform.iOS` (Cupertino)

```dart
import 'package:flutter_adaptive_design/flutter_adaptive_design.dart';
import 'package:flutter_adaptive_design/testing.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AdaptiveButton Platform Verification', () {
    testAdaptiveWidget('renders native button primitive', (tester, platform) async {
      await tester.pumpWidget(
        wrapAdaptiveTestWidget(
          AdaptiveButton.label(
            onPressed: () {},
            label: 'Submit',
          ),
        ),
      );

      expect(find.text('Submit'), findsOneWidget);

      if (platform == TargetPlatform.iOS) {
        expect(find.byType(CupertinoButton), findsOneWidget);
        expect(find.byType(FilledButton), findsNothing);
      } else {
        expect(find.byType(FilledButton), findsOneWidget);
        expect(find.byType(CupertinoButton), findsNothing);
      }
    });
  });
}
```

---

## 🔄 Live Preview & Platform Switching

Test your UI directly in Flutter Web or your live mobile app without restarting:

```dart
// Force iOS preview across the whole app
PlatformUtils.debugOverridePlatform = TargetPlatform.iOS;

// Force Android Material 3 preview
PlatformUtils.debugOverridePlatform = TargetPlatform.android;

// Revert to host OS behavior
PlatformUtils.debugOverridePlatform = null;
```

---

## ❓ Frequently Asked Questions (FAQ)

<details>
<summary><b>Does this package work on Flutter Web without crashing on dart:io?</b></summary>
Yes! <code>flutter_adaptive_design</code> uses conditional imports (<code>platform_os_stub.dart</code> vs <code>platform_os_io.dart</code>). It is 100% compile-time and runtime safe on Web, macOS, Windows, Linux, Android, and iOS.
</details>

<details>
<summary><b>Can I use custom themes and branding colors?</b></summary>
Absolutely. All widgets respect your <code>ThemeData</code> (M3 colorSchemeSeed, primary colors) and <code>CupertinoThemeData</code>. You can also override colors directly per widget.
</details>

<details>
<summary><b>Does it support Dynamic Type and accessibility scaling?</b></summary>
Yes. All components comply with Apple HIG (44pt touch target) and Google M3 (48dp touch target) and scale smoothly with system font sizes without clipping.
</details>

---

## 📱 Example Application

A complete interactive showcase featuring **all 50+ widgets**, **live platform switcher (iOS ⟷ Android)**, and **Dark/Light mode** is available in the [`example/`](https://github.com/abdouldotdev/flutter_adaptive_design/tree/main/example) folder.

```bash
git clone https://github.com/abdouldotdev/flutter_adaptive_design.git
cd flutter_adaptive_design/example
flutter run
```

---

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](https://github.com/abdouldotdev/flutter_adaptive_design/blob/main/LICENSE) file for details.
