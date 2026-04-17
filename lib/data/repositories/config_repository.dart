import 'dart:convert';
import 'package:flutter/services.dart';
import '../../domain/models/ui_config.dart';
import '../../domain/models/theme_config.dart';
import '../../templates/template_factory.dart';

class ConfigRepository {
  Future<ThemeConfig?> getThemeOverrides(String templateId) async {
    try {
      // In both Dev and White-Label modes, we pull the "Active" template assets.
      // Use 'dart tool/build_manager.dart prepare [id]' to swap the active template.
      const path = 'assets/active/theme.json';
          
      final jsonStr = await rootBundle.loadString(path);
      final map = json.decode(jsonStr) as Map<String, dynamic>;
      return ThemeConfig.fromJson(map);
    } catch (e) {
      return null;
    }
  }

  Future<ScreenConfig> loadScreenConfig(String screenId) async {
    // Load from the active bundle staged by the build manager
    final path = 'assets/active/${screenId}_config.json';
        
    final jsonStr = await rootBundle.loadString(path);
    final map = json.decode(jsonStr) as Map<String, dynamic>;

    // Dynamically resolve template-specific asset paths for images/icons
    if (map.containsKey('data')) {
      final templateId = TemplateFactory.activeTemplateId;
      final templateAssetPath = 'assets/images/$templateId';
      
      final data = map['data'] as Map<String, dynamic>;
      data.forEach((key, value) {
        if (value is String && _isAssetKey(key)) {
          data[key] = '$templateAssetPath/$value';
        }
      });
    }

    return ScreenConfig.fromJson(map);
  }

  bool _isAssetKey(String key) {
    final k = key.toLowerCase();
    return k.endsWith('image') || k.endsWith('icon') || k.endsWith('img') || k == 'clouds';
  }
}
