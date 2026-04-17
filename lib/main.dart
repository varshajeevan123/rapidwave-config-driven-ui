import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/providers/app_state_provider.dart';
import 'core/routes/app_router.dart';
import 'core/theme/theme_engine.dart';
import 'domain/models/theme_config.dart';

void main() {
  runApp(const ProviderScope(child: RapidWeaveApp()));
}

class RapidWeaveApp extends ConsumerWidget {
  const RapidWeaveApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);
    final themeMode = ref.watch(themeModeProvider);
    final themeConfigAsync = ref.watch(themeConfigProvider);
    final themeExtension = ref.watch(themeExtensionProvider);

    return MaterialApp.router(
      title: 'RapidWeave',
      debugShowCheckedModeBanner: false,
      theme: themeConfigAsync.maybeWhen(
        data: (config) => ThemeEngine.createTheme(
          config: config, 
          isDarkMode: themeMode,
          extension: themeExtension,
        ),
        orElse: () => ThemeData.light(), // Fallback theme while loading
      ),

      routerConfig: router,
      builder: (context, child) {
        return themeConfigAsync.when(
          data: (config) => child!,
          loading: () => const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          ),
          error: (e, st) => Scaffold(
            body: Center(child: Text('Failed to load theme: $e')),
          ),
        );
      },
    );
  }
}
