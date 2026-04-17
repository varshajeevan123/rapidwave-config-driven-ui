import 'dart:convert';
import 'package:flutter/services.dart';
import '../../domain/models/ui_config.dart';
import '../../domain/models/theme_config.dart';

class ConfigRepository {
  Future<ThemeConfig?> getThemeOverrides(String templateId) async {
    try {
      final jsonStr = await rootBundle.loadString('assets/configs/theme_$templateId.json');
      final map = json.decode(jsonStr) as Map<String, dynamic>;
      return ThemeConfig.fromJson(map);
    } catch (e) {
      // Return null if no override file exists
      return null;
    }
  }

  Future<ScreenConfig> loadScreenConfig(String screenId) async {
    final jsonStr = await rootBundle.loadString('assets/configs/${screenId}_config.json');
    final map = json.decode(jsonStr) as Map<String, dynamic>;
    return ScreenConfig.fromJson(map);
  }
}

