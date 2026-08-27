import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_adaptive_design/flutter_adaptive_design.dart';

import 'screens/overview_screen.dart';

void main() {
  runApp(const AdaptiveGalleryApp());
}

class AdaptiveGalleryApp extends StatefulWidget {
  const AdaptiveGalleryApp({super.key});

  @override
  State<AdaptiveGalleryApp> createState() => _AdaptiveGalleryAppState();
}

class _AdaptiveGalleryAppState extends State<AdaptiveGalleryApp> {
  TargetPlatform _currentPlatform = TargetPlatform.iOS;
  ThemeMode _themeMode = ThemeMode.light;

  void _togglePlatform() {
    setState(() {
      _currentPlatform = _currentPlatform == TargetPlatform.iOS
          ? TargetPlatform.android
          : TargetPlatform.iOS;
      PlatformUtils.debugOverridePlatform = _currentPlatform;
    });
  }

  void _toggleTheme() {
    setState(() {
      _themeMode =
          _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    });
  }

  @override
  void initState() {
    super.initState();
    PlatformUtils.debugOverridePlatform = _currentPlatform;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = _themeMode == ThemeMode.dark;

    if (_currentPlatform == TargetPlatform.iOS) {
      return CupertinoApp(
        title: 'Flutter Adaptive Design Gallery',
        debugShowCheckedModeBanner: false,
        theme: CupertinoThemeData(
          brightness: isDark ? Brightness.dark : Brightness.light,
          primaryColor: CupertinoColors.activeBlue,
        ),
        home: OverviewScreen(
          onTogglePlatform: _togglePlatform,
          onToggleTheme: _toggleTheme,
          isDark: isDark,
        ),
      );
    }

    return MaterialApp(
      title: 'Flutter Adaptive Design Gallery',
      debugShowCheckedModeBanner: false,
      themeMode: _themeMode,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        colorSchemeSeed: Colors.indigo,
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorSchemeSeed: Colors.indigo,
      ),
      home: OverviewScreen(
        onTogglePlatform: _togglePlatform,
        onToggleTheme: _toggleTheme,
        isDark: isDark,
      ),
    );
  }
}
