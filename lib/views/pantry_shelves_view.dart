import 'package:flutter/material.dart';
import '../state/pantry_scope.dart';
import '../theme/kelpico_theme.dart';
import '../painters/pantry_shelf_painter.dart';

class PantryShelvesView extends StatelessWidget {
  const PantryShelvesView({super.key});

  @override
  Widget build(BuildContext context) {
    final scope = PantryScope.of(context);
    final items = scope.items;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Shelf visual board
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: KelpicoTheme.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: KelpicoTheme.edge),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Visual Tiered Shelves',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    Text(
                      '${items.length} items stocked',
                      style: const TextStyle(color: KelpicoTheme.accent, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                SizedBox(
                  height: 200,
                  width: double.infinity,
                  child: CustomPaint(
                    painter: PantryShelfPainter(items: items),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Stock Inventory',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: KelpicoTheme.ink),
          ),
          const SizedBox(height: 12),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: items.length,
            separatorBuilder: (_, index) => const SizedBox(height: 10),
            itemBuilder: (context, idx) {
              final item = items[idx];
              final isUrgent = item.daysToExpiry <= 3;
              return Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: KelpicoTheme.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isUrgent ? KelpicoTheme.red.withValues(alpha: 0.5) : KelpicoTheme.edge,
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: (isUrgent ? KelpicoTheme.red : KelpicoTheme.accent).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        isUrgent ? Icons.warning_amber_rounded : Icons.inventory_2_outlined,
                        color: isUrgent ? KelpicoTheme.red : KelpicoTheme.accent,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.name,
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${item.zoneLabel} • ${item.quantity}',
                            style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: (isUrgent ? KelpicoTheme.red : KelpicoTheme.green).withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            '${item.daysToExpiry}d left',
                            style: TextStyle(
                              color: isUrgent ? KelpicoTheme.red : KelpicoTheme.green,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete_outline, size: 18, color: Colors.grey),
                          onPressed: () => scope.onRemoveItem(item.id),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
