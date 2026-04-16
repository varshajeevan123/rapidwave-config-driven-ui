import 'dart:convert';
import 'package:flutter/services.dart';
import '../../domain/models/ui_config.dart';
import '../../domain/models/theme_config.dart';

class ConfigRepository {
  Future<ThemeConfig> loadThemeConfig(String templateId) async {
    final jsonStr = await rootBundle.loadString('assets/configs/theme_$templateId.json');
    final map = json.decode(jsonStr) as Map<String, dynamic>;
    return ThemeConfig.fromJson(map);
  }

  Future<ScreenConfig> loadScreenConfig(String screenId) async {
    final jsonStr = await rootBundle.loadString('assets/configs/${screenId}_config.json');
    final map = json.decode(jsonStr) as Map<String, dynamic>;
    return ScreenConfig.fromJson(map);
  }
}
