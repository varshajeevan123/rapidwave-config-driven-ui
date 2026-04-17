import 'template_registry.dart';
import 'healthcare/screens/healthcare_login_screen.dart';
import 'healthcare/screens/healthcare_dashboard_screen.dart';
import 'business/screens/business_login_screen.dart';
import 'business/screens/business_dashboard_screen.dart';
import 'package:flutter/material.dart';
import '../domain/models/theme_config.dart';
import '../core/theme/template_theme_extension.dart';

class HealthcareRegistry extends TemplateRegistry {
  @override
  Widget buildLoginScreen(Map<String, dynamic> data) => HealthcareLoginScreen(data: data);
  
  @override
  Widget buildDashboardScreen(Map<String, dynamic> data) => HealthcareDashboardScreen(data: data);

  @override
  ThemeConfig getThemeConfig() => ThemeConfig(
    lightColors: ThemeColors(
      primary: const Color(0xFF00796B),
      secondary: const Color(0xFF4DB6AC),
      background: const Color(0xFFF1F8F7),
      surface: Colors.white,
      textPrimary: const Color(0xFF1B2F2A), // More neutral dark color for better readability
      textSecondary: const Color(0xFF1B2F2A).withOpacity(0.65),
      error: const Color(0xFFD32F2F),
      success: const Color(0xFF388E3C),
    ),
    darkColors: ThemeColors(
      primary: const Color(0xFF80CBC4),
      secondary: const Color(0xFF4DB6AC),
      background: const Color(0xFF002420),
      surface: const Color(0xFF004D40),
      textPrimary: Colors.white,
      textSecondary: Colors.white70,
      error: const Color(0xFFEF5350),
    ),
    defaultBorderRadius: 24.0, // More rounded for healthcare
  );

  @override
  ThemeExtension? getThemeExtension() => TemplateColors.healthcare();
}

class BusinessRegistry extends TemplateRegistry {
  @override
  Widget buildLoginScreen(Map<String, dynamic> data) => BusinessLoginScreen(data: data);
  
  @override
  Widget buildDashboardScreen(Map<String, dynamic> data) => BusinessDashboardScreen(data: data);

  @override
  ThemeConfig getThemeConfig() => ThemeConfig(
    lightColors: ThemeColors(
      primary: const Color(0xFF0052CC),
      secondary: const Color(0xFF00B8D9),
      background: const Color(0xFFF4F5F7),
      surface: Colors.white,
      textPrimary: const Color(0xFF172B4D),
      textSecondary: const Color(0xFF5E6C84),
      error: const Color(0xFFFF5630),
    ),
    darkColors: ThemeColors(
      primary: const Color(0xFF4C9AFF),
      secondary: const Color(0xFF00E5FF),
      background: const Color(0xFF091E42),
      surface: const Color(0xFF172B4D),
      textPrimary: Colors.white,
      textSecondary: const Color(0xFF8993A4),
      error: const Color(0xFFFF8F73),
    ),
    defaultBorderRadius: 8.0, // Sharper for business
  );

  @override
  ThemeExtension? getThemeExtension() => TemplateColors.business();
}

// Fallback education registry
class EducationRegistry extends TemplateRegistry {
  @override
  Widget buildLoginScreen(Map<String, dynamic> data) => const Scaffold(body: Center(child: Text("Education Login Pending")));
  
  @override
  Widget buildDashboardScreen(Map<String, dynamic> data) => const Scaffold(body: Center(child: Text("Education Dashboard Pending")));

  @override
  ThemeConfig getThemeConfig() => ThemeConfig(
    lightColors: ThemeColors(
      primary: Colors.orange,
      secondary: Colors.amber,
      background: Colors.white,
      surface: Colors.white,
      textPrimary: Colors.black87,
      textSecondary: Colors.black54,
      error: Colors.red,
    ),
    darkColors: ThemeColors(
      primary: Colors.orangeAccent,
      secondary: Colors.amberAccent,
      background: Colors.grey[900],
      surface: Colors.grey[850],
      textPrimary: Colors.white,
      textSecondary: Colors.white70,
      error: Colors.redAccent,
    ),
    defaultBorderRadius: 16.0,
  );

  @override
  ThemeExtension? getThemeExtension() => null;
}

class TemplateFactory {
  static TemplateRegistry getRegistry(String templateId) {
    switch (templateId) {
      case 'healthcare':
        return HealthcareRegistry();
      case 'business':
        return BusinessRegistry();
      case 'education':
        return EducationRegistry();
      default:
        return BusinessRegistry();
    }
  }
}

