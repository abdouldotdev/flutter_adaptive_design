import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'platform_utils.dart';

/// A platform-adaptive application root widget.
///
/// Automatically creates a [CupertinoApp] on iOS/macOS and a [MaterialApp] on
/// Android/Web/Other platforms. Respects [PlatformUtils.debugOverridePlatform]
/// for live platform switching and previews.
class AdaptiveApp extends StatelessWidget {
  /// App title.
  final String title;

  /// Home screen widget.
  final Widget? home;

  /// Named routes table.
  final Map<String, WidgetBuilder>? routes;

  /// Initial route name.
  final String? initialRoute;

  /// Custom route generator.
  final RouteFactory? onGenerateRoute;

  /// Router configuration (e.g. GoRouter) for [AdaptiveApp.router].
  final RouterConfig<Object>? routerConfig;

  /// Material Light Theme.
  final ThemeData? materialTheme;

  /// Material Dark Theme.
  final ThemeData? materialDarkTheme;

  /// Cupertino Light Theme.
  final CupertinoThemeData? cupertinoTheme;

  /// Cupertino Dark Theme.
  final CupertinoThemeData? cupertinoDarkTheme;

  /// Active theme mode (light, dark, system).
  final ThemeMode themeMode;

  /// Localization delegates.
  final Iterable<LocalizationsDelegate<dynamic>>? localizationsDelegates;

  /// Supported locales.
  final Iterable<Locale> supportedLocales;

  /// Current locale.
  final Locale? locale;

  /// Global navigator key.
  final GlobalKey<NavigatorState>? navigatorKey;

  /// Whether to show the debug banner in top right.
  final bool debugShowCheckedModeBanner;

  const AdaptiveApp({
    super.key,
    this.title = '',
    this.home,
    this.routes,
    this.initialRoute,
    this.onGenerateRoute,
    this.materialTheme,
    this.materialDarkTheme,
    this.cupertinoTheme,
    this.cupertinoDarkTheme,
    this.themeMode = ThemeMode.system,
    this.localizationsDelegates,
    this.supportedLocales = const <Locale>[Locale('en', '')],
    this.locale,
    this.navigatorKey,
    this.debugShowCheckedModeBanner = false,
  }) : routerConfig = null;

  const AdaptiveApp.router({
    super.key,
    this.title = '',
    required this.routerConfig,
    this.materialTheme,
    this.materialDarkTheme,
    this.cupertinoTheme,
    this.cupertinoDarkTheme,
    this.themeMode = ThemeMode.system,
    this.localizationsDelegates,
    this.supportedLocales = const <Locale>[Locale('en', '')],
    this.locale,
    this.debugShowCheckedModeBanner = false,
  })  : home = null,
        routes = null,
        initialRoute = null,
        onGenerateRoute = null,
        navigatorKey = null;

  @override
  Widget build(BuildContext context) {
    final isCupertino = PlatformUtils.isCupertino;
    final isDark = themeMode == ThemeMode.dark;

    if (isCupertino) {
      final effectiveCupertinoTheme = isDark
          ? (cupertinoDarkTheme ??
              const CupertinoThemeData(brightness: Brightness.dark))
          : (cupertinoTheme ??
              const CupertinoThemeData(brightness: Brightness.light));

      if (routerConfig != null) {
        return CupertinoApp.router(
          title: title,
          routerConfig: routerConfig,
          theme: effectiveCupertinoTheme,
          localizationsDelegates: localizationsDelegates,
          supportedLocales: supportedLocales,
          locale: locale,
          debugShowCheckedModeBanner: debugShowCheckedModeBanner,
        );
      }

      return CupertinoApp(
        title: title,
        home: home,
        routes: routes ?? const <String, WidgetBuilder>{},
        initialRoute: initialRoute,
        onGenerateRoute: onGenerateRoute,
        navigatorKey: navigatorKey,
        theme: effectiveCupertinoTheme,
        localizationsDelegates: localizationsDelegates,
        supportedLocales: supportedLocales,
        locale: locale,
        debugShowCheckedModeBanner: debugShowCheckedModeBanner,
      );
    }

    final defaultMaterialTheme = ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorSchemeSeed: Colors.blue,
    );
    final defaultMaterialDarkTheme = ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorSchemeSeed: Colors.blue,
    );

    if (routerConfig != null) {
      return MaterialApp.router(
        title: title,
        routerConfig: routerConfig,
        themeMode: themeMode,
        theme: materialTheme ?? defaultMaterialTheme,
        darkTheme: materialDarkTheme ?? defaultMaterialDarkTheme,
        localizationsDelegates: localizationsDelegates,
        supportedLocales: supportedLocales,
        locale: locale,
        debugShowCheckedModeBanner: debugShowCheckedModeBanner,
      );
    }

    return MaterialApp(
      title: title,
      home: home,
      routes: routes ?? const <String, WidgetBuilder>{},
      initialRoute: initialRoute,
      onGenerateRoute: onGenerateRoute,
      navigatorKey: navigatorKey,
      themeMode: themeMode,
      theme: materialTheme ?? defaultMaterialTheme,
      darkTheme: materialDarkTheme ?? defaultMaterialDarkTheme,
      localizationsDelegates: localizationsDelegates,
      supportedLocales: supportedLocales,
      locale: locale,
      debugShowCheckedModeBanner: debugShowCheckedModeBanner,
    );
  }
}
