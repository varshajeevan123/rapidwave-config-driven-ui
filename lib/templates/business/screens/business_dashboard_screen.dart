import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/services/auth_service.dart';
import '../../../shared/widgets/dynamic_card.dart';
import '../../../shared/widgets/dynamic_layout.dart';

class BusinessDashboardScreen extends ConsumerWidget {
  final Map<String, dynamic> data;

  const BusinessDashboardScreen({super.key, required this.data});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final metrics = List<Map<String, dynamic>>.from(data['metrics'] ?? []);

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              data['project_name'] ?? 'RapidWave',
              style: TextStyle(
                fontSize: 12,
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.5,
              ),
            ),
            Text(data['page_title'] ?? 'Enterprise Dashboard'),
          ],
        ),
        elevation: 0,
        backgroundColor: Theme.of(context).colorScheme.surface,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
            color: Theme.of(context).colorScheme.primary,
            onPressed: () {
              ref.read(authServiceProvider).signOut();
            },
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Simulated Side Navigation for Business Apps
          if (MediaQuery.of(context).size.width > 800)
            Container(
              width: 250,
              color: Theme.of(context).colorScheme.surface,
              child: ListView(
                padding: const EdgeInsets.symmetric(vertical: 16),
                children: [
                  ListTile(
                    leading: const Icon(Icons.dashboard),
                    title: const Text('Overview'),
                    selected: true,
                    selectedColor: Theme.of(context).colorScheme.primary,
                  ),
                  const ListTile(leading: Icon(Icons.people), title: Text('Employees')),
                  const ListTile(leading: Icon(Icons.bar_chart), title: Text('Reports')),
                  const ListTile(leading: Icon(Icons.settings), title: Text('Settings')),
                ],
              ),
            ),
            
          // Main Body Context
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(32.0),
              children: [
                DynamicLayout(
                  layoutStrategy: 'row',
                  children: metrics.asMap().entries.map((entry) {
                    final index = entry.key;
                    final item = entry.value;
                    return DynamicCard(
                      title: item['title'] ?? '',
                      value: item['value'] ?? '',
                      style: 'glass', // Business looks trendy with glass
                      index: index,
                    );
                  }).toList(),
                ),
                
                const SizedBox(height: 32),
                
                // Placeholder for data table typical in business apps
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                         Text('Recent Activity', style: Theme.of(context).textTheme.titleLarge),
                         const SizedBox(height: 16),
                         const Center(child: Padding(
                           padding: EdgeInsets.all(48.0),
                           child: Text("Data table would populate here."),
                         ))
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
