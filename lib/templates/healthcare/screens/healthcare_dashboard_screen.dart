import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/services/auth_service.dart';
import '../../../shared/widgets/dynamic_card.dart';
import '../../../shared/widgets/dynamic_layout.dart';

class HealthcareDashboardScreen extends ConsumerWidget {
  final Map<String, dynamic> data;

  const HealthcareDashboardScreen({super.key, required this.data});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final metrics = List<Map<String, dynamic>>.from(data['metrics'] ?? []);

    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.medical_services, size: 40, color: Colors.teal),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      data['project_name'] ?? 'RapidWave',
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2,
                      ),
                    ),
                    Text(
                      data['page_title'] ?? 'Dashboard',
                      style: Theme.of(context).textTheme.displaySmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                ElevatedButton.icon(
                  onPressed: () {
                    ref.read(authServiceProvider).signOut();
                  },
                  icon: const Icon(Icons.logout),
                  label: const Text('Logout'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.errorContainer,
                    foregroundColor: Theme.of(context).colorScheme.onErrorContainer,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
            DynamicLayout(
              layoutStrategy: 'grid',
              children: metrics.asMap().entries.map((entry) {
                final index = entry.key;
                final item = entry.value;
                return DynamicCard(
                  title: item['title'] ?? '',
                  value: item['value'] ?? '',
                  style: 'elevated',
                  index: index,
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
