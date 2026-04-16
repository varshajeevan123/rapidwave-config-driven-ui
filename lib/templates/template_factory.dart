import 'template_registry.dart';
import 'healthcare/screens/healthcare_login_screen.dart';
import 'healthcare/screens/healthcare_dashboard_screen.dart';
import 'business/screens/business_login_screen.dart';
import 'business/screens/business_dashboard_screen.dart';
import 'package:flutter/material.dart';

class HealthcareRegistry extends TemplateRegistry {
  @override
  Widget buildLoginScreen(Map<String, dynamic> data) => HealthcareLoginScreen(data: data);
  
  @override
  Widget buildDashboardScreen(Map<String, dynamic> data) => HealthcareDashboardScreen(data: data);
}

class BusinessRegistry extends TemplateRegistry {
  @override
  Widget buildLoginScreen(Map<String, dynamic> data) => BusinessLoginScreen(data: data);
  
  @override
  Widget buildDashboardScreen(Map<String, dynamic> data) => BusinessDashboardScreen(data: data);
}

// Fallback education registry
class EducationRegistry extends TemplateRegistry {
  @override
  Widget buildLoginScreen(Map<String, dynamic> data) => const Scaffold(body: Center(child: Text("Education Login Pending")));
  
  @override
  Widget buildDashboardScreen(Map<String, dynamic> data) => const Scaffold(body: Center(child: Text("Education Dashboard Pending")));
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
