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

  ThemeConfig copyWith({
    ThemeColors? lightColors,
    ThemeColors? darkColors,
    String? fontFamily,
    double? defaultBorderRadius,
    double? defaultSpacing,
  }) {
    return ThemeConfig(
      lightColors: lightColors ?? this.lightColors,
      darkColors: darkColors ?? this.darkColors,
      fontFamily: fontFamily ?? this.fontFamily,
      defaultBorderRadius: defaultBorderRadius ?? this.defaultBorderRadius,
      defaultSpacing: defaultSpacing ?? this.defaultSpacing,
    );
  }

  ThemeConfig merge(ThemeConfig? other) {
    if (other == null) return this;
    return ThemeConfig(
      lightColors: lightColors.merge(other.lightColors),
      darkColors: darkColors.merge(other.darkColors),
      fontFamily: other.fontFamily != 'Inter' ? other.fontFamily : fontFamily,
      defaultBorderRadius: other.defaultBorderRadius != 12.0 ? other.defaultBorderRadius : defaultBorderRadius,
      defaultSpacing: other.defaultSpacing != 16.0 ? other.defaultSpacing : defaultSpacing,
    );
  }

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
  final Color? primary;
  final Color? secondary;
  final Color? tertiary;
  final Color? background;
  final Color? surface;
  final Color? textPrimary;
  final Color? textSecondary;
  final Color? error;
  final Color? success;
  final Color? warning;
  final Color? info;

  ThemeColors({
    this.primary,
    this.secondary,
    this.tertiary,
    this.background,
    this.surface,
    this.textPrimary,
    this.textSecondary,
    this.error,
    this.success,
    this.warning,
    this.info,
  });

  ThemeColors merge(ThemeColors? other) {
    if (other == null) return this;
    return ThemeColors(
      primary: other.primary ?? primary,
      secondary: other.secondary ?? secondary,
      tertiary: other.tertiary ?? tertiary,
      background: other.background ?? background,
      surface: other.surface ?? surface,
      textPrimary: other.textPrimary ?? textPrimary,
      textSecondary: other.textSecondary ?? textSecondary,
      error: other.error ?? error,
      success: other.success ?? success,
      warning: other.warning ?? warning,
      info: other.info ?? info,
    );
  }

  factory ThemeColors.fromJson(Map<String, dynamic> json) {
    return ThemeColors(
      primary: _parseColor(json['primary'] as String?),
      secondary: _parseColor(json['secondary'] as String?),
      tertiary: _parseColor(json['tertiary'] as String?),
      background: _parseColor(json['background'] as String?),
      surface: _parseColor(json['surface'] as String?),
      textPrimary: _parseColor(json['textPrimary'] as String?),
      textSecondary: _parseColor(json['textSecondary'] as String?),
      error: _parseColor(json['error'] as String?),
      success: _parseColor(json['success'] as String?),
      warning: _parseColor(json['warning'] as String?),
      info: _parseColor(json['info'] as String?),
    );
  }

  static Color? _parseColor(String? hex) {
    if (hex == null || hex.isEmpty) return null;
    hex = hex.replaceAll('#', '');
    if (hex.length == 6) {
      hex = 'FF$hex';
    }
    return Color(int.tryParse(hex, radix: 16) ?? 0);
  }
}

