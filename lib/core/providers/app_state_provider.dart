import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import '../../domain/models/theme_config.dart';
import '../../domain/models/ui_config.dart';
import '../../data/repositories/config_repository.dart';
import '../../templates/template_factory.dart';

final configRepositoryProvider = Provider((ref) => ConfigRepository());

class ThemeModeNotifier extends Notifier<bool> {
  @override
  bool build() => false;
  void toggle() => state = !state;
}

final themeModeProvider = NotifierProvider<ThemeModeNotifier, bool>(
  ThemeModeNotifier.new,
);

class ActiveTemplateNotifier extends Notifier<String> {
  @override
  String build() => TemplateFactory.activeTemplateId;
  
  void setTemplate(String name) {
    if (TemplateFactory.isWhiteLabel) return; // Prevent switching in White-Label mode
    state = name;
  }
}

final activeTemplateProvider = NotifierProvider<ActiveTemplateNotifier, String>(
  ActiveTemplateNotifier.new,
);

final themeConfigProvider = FutureProvider<ThemeConfig>((ref) async {
  final repo = ref.watch(configRepositoryProvider);
  final templateId = ref.watch(activeTemplateProvider);

  // 1. Get Template Default
  final registry = TemplateFactory.getRegistry(templateId);
  final baseTheme = registry.getThemeConfig();

  // 2. Load Overrides from JSON
  final overrides = await repo.getThemeOverrides(templateId);

  // 3. Merge
  return baseTheme.merge(overrides);
});

final themeExtensionProvider = Provider<ThemeExtension?>((ref) {
  final templateId = ref.watch(activeTemplateProvider);
  final registry = TemplateFactory.getRegistry(templateId);
  return registry.getThemeExtension();
});

final screenConfigProvider = FutureProvider.family<ScreenConfig, String>((
  ref,
  screenId,
) async {
  final repo = ref.watch(configRepositoryProvider);
  return repo.loadScreenConfig(screenId);
});
