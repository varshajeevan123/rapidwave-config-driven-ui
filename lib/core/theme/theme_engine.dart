import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../domain/models/theme_config.dart';

class ThemeEngine {
  static ThemeData createTheme({
    required ThemeConfig config,
    required bool isDarkMode,
  }) {
    final colors = isDarkMode ? config.darkColors : config.lightColors;

    final colorScheme = ColorScheme(
      brightness: isDarkMode ? Brightness.dark : Brightness.light,
      primary: colors.primary,
      onPrimary: colors.surface,
      secondary: colors.secondary,
      onSecondary: colors.textPrimary,
      error: colors.error,
      onError: colors.surface,
      surface: colors.surface,
      onSurface: colors.textPrimary,
    );

    // Dynamic font family using Google Fonts
    final textTheme = GoogleFonts.getTextTheme(
      config.fontFamily,
      ThemeData(brightness: colorScheme.brightness).textTheme,
    ).copyWith(
      bodyLarge: TextStyle(color: colors.textPrimary),
      bodyMedium: TextStyle(color: colors.textSecondary),
      displayLarge: TextStyle(color: colors.textPrimary, fontWeight: FontWeight.bold),
    );

    return ThemeData(
      colorScheme: colorScheme,
      scaffoldBackgroundColor: colors.background,
      textTheme: textTheme,
      cardTheme: CardThemeData(
        color: colors.surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(config.defaultBorderRadius),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colors.surface,
        contentPadding: EdgeInsets.all(config.defaultSpacing),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(config.defaultBorderRadius),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(config.defaultBorderRadius),
          borderSide: BorderSide(color: colors.textSecondary.withAlpha(51)), // 0.2 alpha (51/255)
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(config.defaultBorderRadius),
          borderSide: BorderSide(color: colors.primary),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: colors.primary,
          foregroundColor: colorScheme.onPrimary,
          padding: EdgeInsets.symmetric(
            vertical: config.defaultSpacing,
            horizontal: config.defaultSpacing * 2,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(config.defaultBorderRadius),
          ),
          elevation: 0,
        ),
      ),
    );
  }
}
