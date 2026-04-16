import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models/theme_config.dart';
import '../../domain/models/ui_config.dart';
import '../../data/repositories/config_repository.dart';

final configRepositoryProvider = Provider((ref) => ConfigRepository());

class ThemeModeNotifier extends Notifier<bool> {
  @override
  bool build() => false;
  void toggle() => state = !state;
}

final themeModeProvider = NotifierProvider<ThemeModeNotifier, bool>(ThemeModeNotifier.new);

class ActiveTemplateNotifier extends Notifier<String> {
  @override
  String build() => 'business';
  void setTemplate(String name) => state = name;
}

final activeTemplateProvider = NotifierProvider<ActiveTemplateNotifier, String>(ActiveTemplateNotifier.new);

final themeConfigProvider = FutureProvider<ThemeConfig>((ref) async {
  final repo = ref.watch(configRepositoryProvider);
  final template = ref.watch(activeTemplateProvider);
  return repo.loadThemeConfig(template);
});

final screenConfigProvider = FutureProvider.family<ScreenConfig, String>((ref, screenId) async {
  final repo = ref.watch(configRepositoryProvider);
  return repo.loadScreenConfig(screenId);
});
