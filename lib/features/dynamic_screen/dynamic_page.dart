import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/providers/app_state_provider.dart';
import '../../templates/template_factory.dart';

class DynamicPage extends ConsumerWidget {
  final String screenId;

  const DynamicPage({super.key, required this.screenId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final screenConfigAsync = ref.watch(screenConfigProvider(screenId));
    final activeTemplate = ref.watch(activeTemplateProvider);

    return Scaffold(
      appBar: (screenId == 'dashboard' || !kDebugMode) ? null : AppBar(
        title: screenConfigAsync.when(
          data: (_) => Text('App Loader'),
          loading: () => const Text('Loading...'),
          error: (_, __) => const Text('Error'),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.brightness_4),
            onPressed: () {
              ref.read(themeModeProvider.notifier).toggle();
            },
            tooltip: 'Toggle Theme',
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.color_lens),
            tooltip: 'Change Template',
            onSelected: (value) {
              ref.read(activeTemplateProvider.notifier).setTemplate(value);
            },
            itemBuilder: (context) => [
              const PopupMenuItem(value: 'business', child: Text('Business Template')),
              const PopupMenuItem(value: 'healthcare', child: Text('Healthcare Template')),
              const PopupMenuItem(value: 'education', child: Text('Education Template')),
            ],
          )
        ],
      ),
      body: screenConfigAsync.when(
        data: (config) {
           final registry = TemplateFactory.getRegistry(activeTemplate);
           return registry.buildScreen(screenId, config.data);
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Text('Failed to load screen data: $error'),
        ),
      ),
    );
  }
}
