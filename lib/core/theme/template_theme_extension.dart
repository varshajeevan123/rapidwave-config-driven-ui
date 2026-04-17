import 'package:flutter/material.dart';

@immutable
class TemplateColors extends ThemeExtension<TemplateColors> {
  final Color? brandAccent;
  final Color? surfaceVariant;
  final Color? indicatorColor;
  final Color? softOverlay;

  const TemplateColors({
    this.brandAccent,
    this.surfaceVariant,
    this.indicatorColor,
    this.softOverlay,
  });

  @override
  TemplateColors copyWith({
    Color? brandAccent,
    Color? surfaceVariant,
    Color? indicatorColor,
    Color? softOverlay,
  }) {
    return TemplateColors(
      brandAccent: brandAccent ?? this.brandAccent,
      surfaceVariant: surfaceVariant ?? this.surfaceVariant,
      indicatorColor: indicatorColor ?? this.indicatorColor,
      softOverlay: softOverlay ?? this.softOverlay,
    );
  }

  @override
  TemplateColors lerp(ThemeExtension<TemplateColors>? other, double t) {
    if (other is! TemplateColors) {
      return this;
    }
    return TemplateColors(
      brandAccent: Color.lerp(brandAccent, other.brandAccent, t),
      surfaceVariant: Color.lerp(surfaceVariant, other.surfaceVariant, t),
      indicatorColor: Color.lerp(indicatorColor, other.indicatorColor, t),
      softOverlay: Color.lerp(softOverlay, other.softOverlay, t),
    );
  }

  // Predefined extensions for templates
  static TemplateColors healthcare() {
    return const TemplateColors(
      brandAccent: Color(0xFF00796B),
      surfaceVariant: Color(0xFFE0F2F1),
      indicatorColor: Color(0xFF80CBC4),
      softOverlay: Color(0x33B2DFDB),
    );
  }

  static TemplateColors business() {
    return const TemplateColors(
      brandAccent: Color(0xFF0052CC),
      surfaceVariant: Color(0xFFF4F5F7),
      indicatorColor: Color(0xFF00B8D9),
      softOverlay: Color(0x1A091E42),
    );
  }
}
