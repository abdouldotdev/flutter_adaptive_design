# flutter_adaptive_design

[![pub package](https://img.shields.io/pub/v/flutter_adaptive_design.svg)](https://pub.dev/packages/flutter_adaptive_design)
[![license](https://img.shields.io/badge/license-MIT-blue.svg)](https://github.com/abdouldotdev/flutter_adaptive_design/blob/main/LICENSE)
[![platform](https://img.shields.io/badge/platform-iOS%20%7C%20Android%20%7C%20Web%20%7C%20macOS%20%7C%20Windows%20%7C%20Linux-lightgrey.svg)](https://pub.dev/packages/flutter_adaptive_design)
[![code style](https://img.shields.io/badge/style-flutter__lints-blue)](https://pub.dev/packages/flutter_lints)

An enterprise-grade, zero-overhead Flutter design system package that delivers true platform-native UI for **iOS (Apple Human Interface Guidelines)** and **Android (Material 3)** from a single unified API.

---

## 🌟 Why `flutter_adaptive_design`?

Building apps that feel truly native on both iOS and Android traditionally required messy conditional branches (`if (Platform.isIOS)`), broken web builds due to `dart:io`, mismatched font scaling, inconsistent touch targets, and duplicated UI code.

`flutter_adaptive_design` eliminates all of that by providing:
- **50+ Unified Adaptive Primitives**: Write `AdaptiveButton`, `AdaptiveScaffold`, `AdaptiveTextField`, and get pixel-perfect Cupertino or Material 3 components automatically.
- **Web & Multiplatform Safe**: Conditional OS imports prevent web compile errors.
- **Design Tokens**: Standardized 8pt spacing grid, platform radii (squircle vs M3), eased motion curves, and semantic colors.
- **Semantic Iconography**: Native integration with `hugeicons`, Flutter `IconData`, and custom SVGs.
- **Responsive Multi-Device Engine**: Breakpoints, responsive grids, constrained content, master-detail layouts, and responsive scaffolds.
- **First-Class Testing Suite**: Dedicated `testAdaptiveWidget` harness to verify Cupertino and Material branches in automated CI/CD pipelines.

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

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _notificationsEnabled = true;
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AdaptiveScaffold(
      appBar: const AdaptiveAppBar(
        title: 'Dashboard',
      ),
      body: SingleChildScrollView(
        padding: AdaptiveSpacing.pagePadding,
        child: Column(
          children: [
            AdaptiveSearchBar(
              controller: _searchController,
              placeholder: 'Search transactions...',
            ),
            const SizedBox(height: AdaptiveSpacing.md),
            AdaptiveCard(
              child: AdaptiveListTile(
                leading: const AdaptiveIcon(AdaptiveIcons.notification),
                title: const Text('Push Notifications'),
                subtitle: const Text('Receive instant alerts'),
                trailing: AdaptiveSwitch(
                  value: _notificationsEnabled,
                  onChanged: (val) => setState(() => _notificationsEnabled = val),
                ),
              ),
            ),
            const SizedBox(height: AdaptiveSpacing.lg),
            AdaptiveButton.label(
              onPressed: () {
                AdaptiveDialog.show(
                  context: context,
                  title: 'Confirm Action',
                  content: 'Do you want to proceed with this transfer?',
                  actions: [
                    AdaptiveDialogAction(
                      label: 'Cancel',
                      onPressed: () => Navigator.pop(context),
                    ),
                    AdaptiveDialogAction(
                      label: 'Confirm',
                      isDefault: true,
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                );
              },
              label: 'Make Payment',
            ),
          ],
        ),
      ),
    );
  }
}
```

---

## 🎨 Design Tokens & Foundation

### 1. Spacing (`AdaptiveSpacing`)
Based on the standard 8pt grid with 4pt sub-grid support:

| Token | Size | Purpose |
|-------|------|---------|
| `AdaptiveSpacing.xs` | 4pt | Icon/text gaps, tight badges |
| `AdaptiveSpacing.sm` | 8pt | Internal padding, list item gaps |
| `AdaptiveSpacing.md` | 12pt | Card inner padding, form spacing |
| `AdaptiveSpacing.lg` | 16pt | Page gutter, container padding |
| `AdaptiveSpacing.xl` | 24pt | Section gaps, header margin |
| `AdaptiveSpacing.xxl` | 32pt | Large feature spacing |
| `AdaptiveSpacing.xxxl` | 48pt | Empty state / hero spacing |

### 2. Radius (`AdaptiveRadius`)
Provides platform-accurate corner radii:

| Element | iOS (Cupertino) | Android (Material 3) |
|---------|-----------------|----------------------|
| Card | 10pt (Squircle) | 12pt (Rounded) |
| Button | 10pt | 20pt (Full Pill / Rounded) |
| Dialog | 14pt | 28pt |
| TextField | 8pt | 4pt |
| Bottom Sheet | 12pt | 28pt |

### 3. Motion & Curves (`AdaptiveMotion`)
Platform-tailored transition curves and micro-durations:
- `AdaptiveMotion.micro`: 120ms (taps, toggles)
- `AdaptiveMotion.transition`: 280ms (sheets, dialogs)
- `AdaptiveMotion.page`: 380ms (navigation transitions)
- `AdaptiveMotion.pageCurve`: `Curves.easeInOut` on iOS, `Curves.easeInOutCubicEmphasized` on Android.

### 4. Semantic Iconography (`AdaptiveIcons` & `AdaptiveIcon`)
Seamlessly renders stroke-rounded HugeIcons, Flutter `IconData`, or custom widgets with automatic platform dark/light color resolution:

```dart
// Semantic preset:
AdaptiveIcon(AdaptiveIcons.home, size: 24)

// Flutter IconData:
AdaptiveIcon(Icons.star, color: Colors.amber)

// Platform-resolved glyph:
final icon = AdaptiveIcons.resolve(
  material: Icons.arrow_back,
  cupertino: CupertinoIcons.back,
);
```

---

## 🧩 Comprehensive Component Catalog (+96 Components)

### 🏗️ Layout & Structure
| Component | Cupertino Implementation | Material 3 Implementation |
|-----------|--------------------------|---------------------------|
| `AdaptiveScaffold` | `CupertinoPageScaffold` | `Scaffold` |
| `AdaptiveAppBar` | `CupertinoNavigationBar` | `AppBar` |
| `AdaptiveSliverAppBar` | `CupertinoSliverNavigationBar` | `SliverAppBar` |
| `AdaptiveBottomNav` | `CupertinoTabBar` | `NavigationBar` (M3) |
| `AdaptiveTabScaffold` | `CupertinoTabScaffold` | `Scaffold` with BottomNav |
| `AdaptiveCard` | Bordered squircle container | `Card` / `ElevatedCard` |
| `AdaptiveListTile` | `CupertinoListTile` | `ListTile` |
| `AdaptiveListSection` | `CupertinoListSection` | `Column` with divider styling |
| `AdaptiveDivider` | 0.5pt hairline separator | `Divider` |
| `AdaptiveSidebarLayout` | Collapsible split-view | Navigation Rail / Drawer |

### 🔘 Buttons & Actions
| Component | Description |
|-----------|-------------|
| `AdaptiveButton` | `CupertinoButton.filled` on iOS, `FilledButton` on Android |
| `AdaptiveTextButton` | `CupertinoButton` (borderless) on iOS, `TextButton` on Android |
| `AdaptiveIconButton` | `CupertinoButton` icon on iOS, `IconButton` on Android |
| `AdaptiveFAB` / `AdaptiveFab` | Circular iOS floating action button or M3 `FloatingActionButton` |

### 📝 Forms & Inputs
| Component | Description |
|-----------|-------------|
| `AdaptiveTextField` | `CupertinoTextField` on iOS, `TextField` (Outlined/Filled) on Android |
| `AdaptiveSearchBar` | `CupertinoSearchTextField` on iOS, `SearchBar` on Android |
| `AdaptiveSwitch` | `CupertinoSwitch` on iOS, `Switch` on Android |
| `AdaptiveSlider` | `CupertinoSlider` on iOS, `Slider` on Android |
| `AdaptiveCheckbox` | `CupertinoCheckbox` on iOS, `Checkbox` on Android |
| `AdaptiveRadioGroup` | Native radio selection group per platform |
| `AdaptiveSegmentedControl` | `CupertinoSlidingSegmentedControl` on iOS, `SegmentedButton` on Android |
| `AdaptiveFormSection` | Grouped form field wrapper with platform styling |

### 💬 Feedback & Overlays
| Component | Description |
|-----------|-------------|
| `AdaptiveDialog` | `CupertinoAlertDialog` on iOS, `AlertDialog` on Android |
| `AdaptiveActionSheet` | `CupertinoActionSheet` on iOS, Modal `BottomSheet` on Android |
| `AdaptiveSnackBar` | Top floating notification strip on iOS, `SnackBar` on Android |
| `AdaptiveBanner` | In-flow non-blocking notification banner |
| `AdaptiveProgressIndicator` | `CupertinoActivityIndicator` on iOS, `CircularProgressIndicator` on Android |
| `AdaptiveTooltip` | Native long-press tooltip on iOS, `Tooltip` on Android |

### 🏷️ Chips & Tags
| Component | Description |
|-----------|-------------|
| `AdaptiveChip` | Compact pill tag with optional leading icon |
| `AdaptiveFilterChip` | Selectable filter tag with active toggle states |

### 🧭 Navigation & Pickers
| Component | Description |
|-----------|-------------|
| `AdaptiveNavigationDrawer` | iOS sliding sheet drawer or M3 `NavigationDrawer` |
| `AdaptivePageRoute` | `CupertinoPageRoute` on iOS, `MaterialPageRoute` on Android |
| `AdaptivePopupMenu` | Tap action sheet on iOS, `PopupMenuButton` on Android |
| `AdaptiveTabBar` | `CupertinoSlidingSegmentedControl` or `TabBar` |
| `AdaptiveDatePicker` | `CupertinoDatePicker` modal or `showDatePicker` dialog |
| `AdaptiveTimePicker` | `CupertinoDatePicker` time mode or `showTimePicker` dialog |
| `AdaptivePicker` | Modal wheel picker on iOS or wheel scroll dialog on Android |

### ⚡ State & Placeholder Patterns
| Component | Description |
|-----------|-------------|
| `AdaptiveEmptyState` | Illustrated empty state with title, subtitle, and action button |
| `AdaptiveErrorState` | Full-page error state with retry callback |
| `AdaptiveErrorBanner` | Non-blocking inline error strip |
| `AdaptiveLoadingOverlay` | Semi-transparent modal loading indicator |
| `AdaptiveLoadingPage` | Full-screen loading indicator with status text |
| `AdaptiveSkeletonBox` | Shimmer-ready layout placeholder block |
| `AdaptiveSkeletonListTile` | Placeholder list item with avatar and lines |
| `AdaptiveSkeletonCard` | Placeholder card container |
| `AdaptiveShimmer` | Linear shimmering animation effect |
| `AdaptiveDisabled` | Accessibility-compliant opacity and interaction suppressor |

### 📐 Responsive Layout Engine
| Component | Description |
|-----------|-------------|
| `Breakpoints` | Standard size classes: `compact` (<600pt), `medium` (600–840pt), `expanded` (840–1200pt), `large` (>=1200pt) |
| `AdaptiveConstrainedContent` | Constrains maximum page content width on large screens with automatic centering |
| `AdaptiveResponsiveGrid` | Auto-fitting multi-column responsive grid |
| `AdaptiveMasterDetail` | Automatic split-pane for tablet/desktop and push-route for mobile |
| `AdaptiveResponsiveScaffold` | Multi-screen scaffold adapting between bottom nav, rail, and permanent drawer |

---

## 🧪 Testing Guide

`flutter_adaptive_design` includes a comprehensive testing library via `package:flutter_adaptive_design/testing.dart`.

### Test Both Platforms in One Go

```dart
import 'package:flutter_adaptive_design/flutter_adaptive_design.dart';
import 'package:flutter_adaptive_design/testing.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AdaptiveButton Tests', () {
    // Automatically executes twice: once for Android, once for iOS
    testAdaptiveWidget('renders native primitive per platform', (tester, platform) async {
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
      } else {
        expect(find.byType(FilledButton), findsOneWidget);
      }
    });
  });
}
```

---

## 🔄 Live Preview & Platform Switching

You can dynamically force or preview any platform at runtime (including web demos and release builds):

```dart
// Force iOS preview
PlatformUtils.debugOverridePlatform = TargetPlatform.iOS;

// Force Android preview
PlatformUtils.debugOverridePlatform = TargetPlatform.android;

// Reset to device platform
PlatformUtils.debugOverridePlatform = null;
```

---

## 📱 Example Application

An interactive gallery app showcasing all components with live iOS/Android platform toggling and Light/Dark themes is located in the [`example/`](https://github.com/abdouldotdev/flutter_adaptive_design/tree/main/example) directory.

To run the example app:

```bash
cd example
flutter run
```

---

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](https://github.com/abdouldotdev/flutter_adaptive_design/blob/main/LICENSE) file for details.
