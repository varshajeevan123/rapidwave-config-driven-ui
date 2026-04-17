import 'package:flutter/material.dart';
import '../domain/models/theme_config.dart';

abstract class TemplateRegistry {
  Widget buildLoginScreen(Map<String, dynamic> data);
  Widget buildDashboardScreen(Map<String, dynamic> data);

  // New Theme Methods
  ThemeConfig getThemeConfig();
  ThemeExtension? getThemeExtension();

  // Future-proofing for more screens
  Widget buildScreen(String screenId, Map<String, dynamic> data) {
    switch (screenId) {
      case 'login':
        return buildLoginScreen(data);
      case 'dashboard':
        return buildDashboardScreen(data);
      default:
        return Center(child: Text('Screen $screenId not supported in this template.'));
    }
  }
}

