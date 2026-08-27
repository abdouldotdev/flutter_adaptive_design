# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.0] - 2026-08-27

### Added
- **Foundational Architecture**:
  - `PlatformUtils`: Centralized platform sniffing with web-safe static release overrides (`debugOverridePlatform`).
  - `PlatformWidget` and `PlatformBuilder`: Base abstractions for dual-rendering with strict compile-time typing.
  - `AdaptiveThemeScope`: Dual-theme synchronization across Cupertino and Material 3 design systems.
  - `AdaptiveTokens`: Spacing (8pt grid), Radius (platform-accurate curvature), Motion (eased durations and curves), Colors, and ScrollPhysics.
  - `AdaptiveTypography`: Platform-accurate text scaling clamped to accessibility boundaries (0.8x–1.35x).
  - `AdaptiveIcons`: Unified icon registry with seamless support for `HugeIcons`, Flutter `IconData`, and custom `Widget`s.

- **Adaptive Component Catalog (+96 widgets & tokens)**:
  - **Layout & Structure**: `AdaptiveScaffold`, `AdaptiveAppBar`, `AdaptiveCard`, `AdaptiveListTile`, `AdaptiveListSection`, `AdaptiveDivider`, `AdaptiveBottomNav`, `AdaptivePageScaffold`, `AdaptiveSidebarLayout`.
  - **Buttons & Actions**: `AdaptiveButton`, `AdaptiveTextButton`, `AdaptiveIconButton`, `AdaptiveFAB` / `AdaptiveFab`.
  - **Forms & Inputs**: `AdaptiveTextField`, `AdaptiveSearchBar`, `AdaptiveSwitch`, `AdaptiveSlider`, `AdaptiveCheckbox`, `AdaptiveSegmentedControl`, `AdaptiveFormSection`, `AdaptiveRadioGroup`.
  - **Feedback & Overlays**: `AdaptiveDialog`, `AdaptiveActionSheet`, `AdaptiveSnackBar`, `AdaptiveBanner`, `AdaptiveProgressIndicator`, `AdaptiveTooltip`.
  - **Chips & Tags**: `AdaptiveChip`, `AdaptiveFilterChip`.
  - **Navigation & Routing**: `AdaptiveNavigationDrawer`, `AdaptivePageRoute`, `AdaptivePopupMenu`, `AdaptiveTabBar`.
  - **Pickers & Inputs**: `AdaptiveDatePicker`, `AdaptiveTimePicker`, `AdaptivePicker`.
  - **State Patterns & Feedback**: `AdaptiveEmptyState`, `AdaptiveErrorState`, `AdaptiveErrorBanner`, `AdaptiveLoadingOverlay`, `AdaptiveLoadingPage`, `AdaptiveSkeletonBox`, `AdaptiveSkeletonListTile`, `AdaptiveSkeletonCard`, `AdaptiveShimmer`, `AdaptiveDisabled`.
  - **Responsive & Multi-Device**: `Breakpoints` (compact, medium, expanded, large), `AdaptiveConstrainedContent`, `AdaptiveMasterDetail`, `AdaptiveResponsiveGrid`, `AdaptiveResponsiveScaffold`.

- **Testing Suite**:
  - `package:flutter_adaptive_design/testing.dart` exporting `testAdaptiveWidget`, `wrapAdaptiveTestWidget`, `kAdaptivePlatforms`, and standard touch target metrics (`kCupertinoMinTouchTarget`, `kMaterialMinTouchTarget`).
  - 100% test pass rate across foundation, widgets, responsive layout, and integration barrels.

- **Interactive Gallery Example**:
  - Full-featured example application showcasing live iOS/Android platform toggling, theme switching, and interactive component exploration.
