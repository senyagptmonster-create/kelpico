import 'package:flutter/material.dart';
import '../state/pantry_scope.dart';
import '../models/pantry_item.dart';
import '../theme/kelpico_theme.dart';

class StorageZonesView extends StatelessWidget {
  const StorageZonesView({super.key});

  @override
  Widget build(BuildContext context) {
    final scope = PantryScope.of(context);

    final zones = [
      {'zone': StorageZone.pantry, 'name': 'Dry Pantry', 'icon': Icons.shelves},
      {'zone': StorageZone.fridge, 'name': 'Refrigerator', 'icon': Icons.kitchen},
      {'zone': StorageZone.freezer, 'name': 'Deep Freezer', 'icon': Icons.ac_unit},
      {'zone': StorageZone.spices, 'name': 'Spice Rack', 'icon': Icons.scatter_plot_outlined},
    ];

    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.1,
      ),
      itemCount: zones.length,
      itemBuilder: (context, idx) {
        final zoneData = zones[idx];
        final targetZone = zoneData['zone'] as StorageZone;
        final zoneItems = scope.items.where((i) => i.zone == targetZone).toList();

        return Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: KelpicoTheme.surface,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: KelpicoTheme.edge),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(zoneData['icon'] as IconData, color: KelpicoTheme.accent, size: 28),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    zoneData['name'] as String,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${zoneItems.length} items catalogued',
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
