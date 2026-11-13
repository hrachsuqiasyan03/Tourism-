import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';

import 'services/app_settings.dart';
import 'screens/splash_screen.dart';

void main() {
  runApp(const VirtualTourismApp());
}

class VirtualTourismApp extends StatelessWidget {
  const VirtualTourismApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: AppSettings.themeMode,
      builder: (context, themeMode, _) => MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'ArmTravel',
        themeMode: themeMode,
        theme: ThemeData(
          useMaterial3: true,
          scaffoldBackgroundColor: const Color(0xFFF7F7F2),
          textTheme: _comfortableTextTheme(Typography.material2021().black),
          primaryTextTheme: _comfortableTextTheme(
            Typography.material2021().white,
          ),
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF17453D),
            primary: const Color(0xFF17453D),
            secondary: const Color(0xFFD99A62),
            surface: const Color(0xFFFFFEFA),
          ),
          appBarTheme: const AppBarTheme(
            backgroundColor: Color(0xFF17453D),
            foregroundColor: Colors.white,
            elevation: 0,
            centerTitle: false,
            titleTextStyle: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.2,
              height: 1.35,
            ),
          ),
          cardTheme: CardThemeData(
            color: const Color(0xFFFFFEFA),
            elevation: 1,
            margin: EdgeInsets.zero,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),
            clipBehavior: Clip.antiAlias,
          ),
          inputDecorationTheme: InputDecorationTheme(
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: Color(0xFFE6E7E0)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: Color(0xFFE6E7E0)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(
                color: Color(0xFF17453D),
                width: 1.5,
              ),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 15,
            ),
          ),
          navigationBarTheme: NavigationBarThemeData(
            backgroundColor: const Color(0xFFFFFEFA),
            indicatorColor: const Color(0xFFE4EEE9),
            labelTextStyle: WidgetStateProperty.resolveWith(
              (states) => TextStyle(
                color: states.contains(WidgetState.selected)
                    ? const Color(0xFF17453D)
                    : const Color(0xFF7B817D),
                fontWeight: states.contains(WidgetState.selected)
                    ? FontWeight.w700
                    : FontWeight.w500,
                letterSpacing: 0.2,
                height: 1.35,
              ),
            ),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF17453D),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(13),
              ),
            ),
          ),
        ),
        darkTheme: ThemeData(
          useMaterial3: true,
          scaffoldBackgroundColor: const Color(0xFF151D1A),
          textTheme: _comfortableTextTheme(Typography.material2021().white),
          primaryTextTheme: _comfortableTextTheme(
            Typography.material2021().white,
          ),
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF17453D),
            brightness: Brightness.dark,
            primary: const Color(0xFF78B49A),
            secondary: const Color(0xFFD99A62),
            surface: const Color(0xFF202B26),
          ),
          appBarTheme: const AppBarTheme(
            backgroundColor: Color(0xFF17453D),
            foregroundColor: Colors.white,
            elevation: 0,
            titleTextStyle: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.2,
              height: 1.35,
            ),
          ),
          cardTheme: CardThemeData(
            color: const Color(0xFF202B26),
            elevation: 1,
            margin: EdgeInsets.zero,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),
            clipBehavior: Clip.antiAlias,
          ),
          inputDecorationTheme: InputDecorationTheme(
            filled: true,
            fillColor: const Color(0xFF25322C),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: Color(0xFF3B4A42)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: Color(0xFF3B4A42)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(
                color: Color(0xFF78B49A),
                width: 1.5,
              ),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 15,
            ),
          ),
          navigationBarTheme: const NavigationBarThemeData(
            backgroundColor: Color(0xFF202B26),
            indicatorColor: Color(0xFF354D40),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF78B49A),
              foregroundColor: const Color(0xFF10251B),
              padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(13),
              ),
            ),
          ),
        ),
        scrollBehavior: const AppScrollBehavior(),
        home: const SplashScreen(),
      ),
    );
  }
}

TextTheme _comfortableTextTheme(TextTheme theme) => theme.copyWith(
  displayLarge: _comfortable(theme.displayLarge),
  displayMedium: _comfortable(theme.displayMedium),
  displaySmall: _comfortable(theme.displaySmall),
  headlineLarge: _comfortable(theme.headlineLarge),
  headlineMedium: _comfortable(theme.headlineMedium),
  headlineSmall: _comfortable(theme.headlineSmall),
  titleLarge: _comfortable(theme.titleLarge),
  titleMedium: _comfortable(theme.titleMedium),
  titleSmall: _comfortable(theme.titleSmall),
  bodyLarge: _comfortable(theme.bodyLarge),
  bodyMedium: _comfortable(theme.bodyMedium),
  bodySmall: _comfortable(theme.bodySmall),
  labelLarge: _comfortable(theme.labelLarge),
  labelMedium: _comfortable(theme.labelMedium),
  labelSmall: _comfortable(theme.labelSmall),
);

TextStyle? _comfortable(TextStyle? style) =>
    style?.copyWith(letterSpacing: 0.2, height: 1.35);

/// Keeps touchscreen scrolling and also allows mouse dragging on desktop/web.
class AppScrollBehavior extends MaterialScrollBehavior {
  const AppScrollBehavior();

  @override
  Set<PointerDeviceKind> get dragDevices => {
    ...super.dragDevices,
    PointerDeviceKind.mouse,
  };
}
