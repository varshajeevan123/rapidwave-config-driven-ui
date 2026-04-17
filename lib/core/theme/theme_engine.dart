import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../domain/models/theme_config.dart';
import 'template_theme_extension.dart';

class ThemeEngine {
  static ThemeData createTheme({
    required ThemeConfig config,
    required bool isDarkMode,
    ThemeExtension? extension,
  }) {
    final colors = isDarkMode ? config.darkColors : config.lightColors;

    // Default Fallbacks
    final primary = colors.primary ?? (isDarkMode ? const Color(0xFFBB86FC) : const Color(0xFF6200EE));
    final secondary = colors.secondary ?? const Color(0xFF03DAC6);
    final background = colors.background ?? (isDarkMode ? const Color(0xFF121212) : const Color(0xFFF6F6F9));
    final surface = colors.surface ?? (isDarkMode ? const Color(0xFF1E1E1E) : const Color(0xFFFFFFFF));
    final error = colors.error ?? const Color(0xFFB00020);
    final textPrimary = colors.textPrimary ?? (isDarkMode ? Colors.white : const Color(0xFF1E1E1E));
    final textSecondary = colors.textSecondary ?? (isDarkMode ? Colors.white70 : const Color(0xFF757575));

    final colorScheme = ColorScheme(
      brightness: isDarkMode ? Brightness.dark : Brightness.light,
      primary: primary,
      onPrimary: _getContrastColor(primary),
      secondary: secondary,
      onSecondary: _getContrastColor(secondary),
      tertiary: colors.tertiary,
      error: error,
      onError: Colors.white,
      surface: surface,
      onSurface: textPrimary,
      surfaceContainerHighest: colors.surface?.withAlpha(20) ?? (isDarkMode ? Colors.white10 : Colors.black12),
    );

    // Dynamic font family using Google Fonts
    final textTheme = GoogleFonts.getTextTheme(
      config.fontFamily,
      ThemeData(brightness: colorScheme.brightness).textTheme,
    ).copyWith(
      bodyLarge: TextStyle(color: textPrimary),
      bodyMedium: TextStyle(color: textSecondary),
      displayLarge: TextStyle(color: textPrimary, fontWeight: FontWeight.bold),
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: background,
      textTheme: textTheme,
      extensions: extension != null ? [extension] : [],
      cardTheme: CardThemeData(
        color: surface,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(config.defaultBorderRadius),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surface,
        contentPadding: EdgeInsets.all(config.defaultSpacing),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(config.defaultBorderRadius),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(config.defaultBorderRadius),
          borderSide: BorderSide(color: textSecondary.withAlpha(51)), 
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(config.defaultBorderRadius),
          borderSide: BorderSide(color: primary, width: 2),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: _getContrastColor(primary),
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

  static Color _getContrastColor(Color color) {
    return ThemeData.estimateBrightnessForColor(color) == Brightness.dark 
        ? Colors.white 
        : Colors.black;
  }
}

