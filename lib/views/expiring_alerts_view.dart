import 'package:flutter/material.dart';
import '../state/pantry_scope.dart';
import '../theme/kelpico_theme.dart';

class ExpiringAlertsView extends StatelessWidget {
  const ExpiringAlertsView({super.key});

  @override
  Widget build(BuildContext context) {
    final scope = PantryScope.of(context);
    final urgentItems = scope.items.where((i) => i.daysToExpiry <= 5).toList()
      ..sort((a, b) => a.daysToExpiry.compareTo(b.daysToExpiry));

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: KelpicoTheme.red.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: KelpicoTheme.red.withValues(alpha: 0.3)),
            ),
            child: Row(
              children: [
                const Icon(Icons.alarm_on_rounded, color: KelpicoTheme.red, size: 28),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Priority Food Rescue',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: KelpicoTheme.red),
                      ),
                      Text(
                        '${urgentItems.length} provisions expiring in 5 days or fewer.',
                        style: TextStyle(fontSize: 13, color: Colors.grey.shade800),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: urgentItems.isEmpty
                ? const Center(
                    child: Text(
                      'All provisions are fresh! Zero urgent items.',
                      style: TextStyle(color: Colors.grey),
                    ),
                  )
                : ListView.builder(
                    itemCount: urgentItems.length,
                    itemBuilder: (context, idx) {
                      final item = urgentItems[idx];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 10),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          side: const BorderSide(color: KelpicoTheme.edge),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: KelpicoTheme.red.withValues(alpha: 0.15),
                            child: Text(
                              '${item.daysToExpiry}d',
                              style: const TextStyle(color: KelpicoTheme.red, fontWeight: FontWeight.bold),
                            ),
                          ),
                          title: Text(item.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: Text('${item.zoneLabel} • ${item.quantity} remaining'),
                          trailing: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: KelpicoTheme.accent,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(horizontal: 12),
                            ),
                            onPressed: () => scope.onRemoveItem(item.id),
                            child: const Text('Used Up'),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
