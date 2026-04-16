import 'package:flutter/material.dart';

class ThemeConfig {
  final ThemeColors lightColors;
  final ThemeColors darkColors;
  final String fontFamily;
  final double defaultBorderRadius;
  final double defaultSpacing;

  ThemeConfig({
    required this.lightColors,
    required this.darkColors,
    this.fontFamily = 'Inter',
    this.defaultBorderRadius = 12.0,
    this.defaultSpacing = 16.0,
  });

  factory ThemeConfig.fromJson(Map<String, dynamic> json) {
    return ThemeConfig(
      lightColors: ThemeColors.fromJson(json['lightColors'] ?? {}),
      darkColors: ThemeColors.fromJson(json['darkColors'] ?? {}),
      fontFamily: json['fontFamily'] as String? ?? 'Inter',
      defaultBorderRadius: (json['defaultBorderRadius'] as num?)?.toDouble() ?? 12.0,
      defaultSpacing: (json['defaultSpacing'] as num?)?.toDouble() ?? 16.0,
    );
  }
}

class ThemeColors {
  final Color primary;
  final Color secondary;
  final Color background;
  final Color surface;
  final Color textPrimary;
  final Color textSecondary;
  final Color error;

  ThemeColors({
    required this.primary,
    required this.secondary,
    required this.background,
    required this.surface,
    required this.textPrimary,
    required this.textSecondary,
    required this.error,
  });

  factory ThemeColors.fromJson(Map<String, dynamic> json) {
    return ThemeColors(
      primary: _parseColor(json['primary'] as String?, const Color(0xFF6200EE)),
      secondary: _parseColor(json['secondary'] as String?, const Color(0xFF03DAC6)),
      background: _parseColor(json['background'] as String?, const Color(0xFFF6F6F9)),
      surface: _parseColor(json['surface'] as String?, const Color(0xFFFFFFFF)),
      textPrimary: _parseColor(json['textPrimary'] as String?, const Color(0xFF1E1E1E)),
      textSecondary: _parseColor(json['textSecondary'] as String?, const Color(0xFF757575)),
      error: _parseColor(json['error'] as String?, const Color(0xFFB00020)),
    );
  }

  static Color _parseColor(String? hex, Color defaultColor) {
    if (hex == null || hex.isEmpty) return defaultColor;
    hex = hex.replaceAll('#', '');
    if (hex.length == 6) {
      hex = 'FF$hex';
    }
    return Color(int.tryParse(hex, radix: 16) ?? defaultColor.value);
  }
}
