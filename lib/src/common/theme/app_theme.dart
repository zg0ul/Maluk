import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:maluk/src/common/theme/text_theme.dart';
import 'package:maluk/src/common/theme/style_constants.dart';

// Theme mode provider
final themeProvider = StateProvider<ThemeMode>((ref) => ThemeMode.dark);

class AppTheme {
  // Colors for light theme
  static final Color lightPrimaryColor = Color(0xFFE50C61);
  static final Color lightSecondaryColor = Colors.teal.shade600;
  static const Color lightBackgroundColor = Color(0xFFF5F5F5);
  static const Color lightTextColor = Color(0xFF2D3142);
  static final Color lightSurfaceColor = Colors.white;

  // Colors for dark theme
  static final Color darkPrimaryColor = Color(0xFFE50C61);
  static final Color darkSecondaryColor = Colors.teal.shade300;
  static const Color darkBackgroundColor = Color(0xFF121212);
  static const Color darkTextColor = Color(0xFFF5F5F5);
  static final Color darkSurfaceColor = Colors.grey.shade900;

  // Light theme
  static final ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    textTheme: AppTextTheme.getLightTextTheme(),
    colorScheme: ColorScheme.light(
      primary: lightPrimaryColor,
      secondary: lightSecondaryColor,
      surface: lightSurfaceColor,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onSurface: lightTextColor,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: lightSurfaceColor,
      foregroundColor: lightTextColor,
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: true,
    ),
    cardTheme: CardTheme(
      color: lightSurfaceColor,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
    scaffoldBackgroundColor: lightBackgroundColor,
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: lightPrimaryColor,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: lightPrimaryColor,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        side: BorderSide(color: lightPrimaryColor),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: lightPrimaryColor,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    ),
    splashFactory: StyleConstants.splashFactory,
    splashColor: Colors.transparent,
    highlightColor: StyleConstants.highlightColor,
    iconButtonTheme: IconButtonThemeData(
      style: IconButton.styleFrom(
        highlightColor: StyleConstants.highlightColor,
        splashFactory: StyleConstants.splashFactory,
      ),
    ),
    tabBarTheme: TabBarTheme(
      splashFactory: StyleConstants.splashFactory,
      overlayColor: StyleConstants.inkOverlayColor,
      dividerColor: lightTextColor.withOpacity(0.1),
      dividerHeight: 1,
      labelStyle: TextStyle(fontWeight: FontWeight.bold),
      indicatorSize: TabBarIndicatorSize.tab,
    ),
  );

  // Dark theme
  static final ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    textTheme: AppTextTheme.getDarkTextTheme(),
    colorScheme: ColorScheme.dark(
      primary: darkPrimaryColor,
      secondary: darkSecondaryColor,
      surface: darkSurfaceColor,
      onPrimary: Colors.black,
      onSecondary: Colors.black,
      onSurface: darkTextColor,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: darkSurfaceColor,
      foregroundColor: darkTextColor,
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: true,
    ),
    cardTheme: CardTheme(
      color: darkSurfaceColor,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
    scaffoldBackgroundColor: darkBackgroundColor,
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: darkPrimaryColor,
        foregroundColor: Colors.black,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: darkPrimaryColor,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        side: BorderSide(color: darkPrimaryColor),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: darkPrimaryColor,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    ),
    splashFactory: StyleConstants.splashFactory,
    splashColor: Colors.transparent,
    highlightColor: StyleConstants.highlightColor,
    iconButtonTheme: IconButtonThemeData(
      style: IconButton.styleFrom(
        highlightColor: StyleConstants.highlightColor,
        splashFactory: StyleConstants.splashFactory,
      ),
    ),
    tabBarTheme: TabBarTheme(
      splashFactory: StyleConstants.splashFactory,
      overlayColor: StyleConstants.inkOverlayColor,
      dividerColor: darkTextColor.withOpacity(0.1),
      dividerHeight: 1,
      labelStyle: TextStyle(fontWeight: FontWeight.bold),
      indicatorSize: TabBarIndicatorSize.tab,
    ),
  );
}
