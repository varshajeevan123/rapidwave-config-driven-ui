import 'package:flutter/material.dart';
import '../../../shared/widgets/dynamic_card.dart';
import '../../../shared/widgets/dynamic_layout.dart';

class HealthcareDashboardScreen extends StatelessWidget {
  final Map<String, dynamic> data;

  const HealthcareDashboardScreen({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
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
