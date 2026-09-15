import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../inventory/inventory_controller.dart';
import '../../common/app_tokens.dart';

class CategoriesView extends StatelessWidget {
  const CategoriesView({super.key});

  IconData _iconForCategory(String cat) {
    switch (cat.toLowerCase()) {
      case 'grains & pasta':
        return Icons.breakfast_dining_outlined;
      case 'canned goods':
        return Icons.inventory_2_outlined;
      case 'spices & seasoning':
        return Icons.soup_kitchen_outlined;
      case 'dairy & eggs':
        return Icons.egg_outlined;
      case 'produce':
        return Icons.grass_rounded;
      case 'bakery':
        return Icons.bakery_dining_outlined;
      default:
        return Icons.category_outlined;
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<InventoryController>(context);
    final categoryMap = controller.categoryCounts;
    final total = controller.totalItemCount;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pantry Classification'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Overall Stats Card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppTokens.surfaceWarm,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppTokens.borderWarm),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'TOTAL PANTRY INVENTORY',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.1,
                      color: AppTokens.textMuted,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Text(
                        '$total',
                        style: const TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.w900,
                          color: AppTokens.honeyAmber,
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'stocked items across categories',
                        style: TextStyle(fontSize: 13, color: AppTokens.textMuted),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            const Text(
              'Stock Distribution by Department',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppTokens.textLight,
              ),
            ),
            const SizedBox(height: 12),

            if (categoryMap.isEmpty)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(32),
                  child: Text(
                    'No categories currently stocked.',
                    style: TextStyle(color: AppTokens.textMuted),
                  ),
                ),
              )
            else
              ...categoryMap.entries.map((entry) {
                final catName = entry.key;
                final count = entry.value;
                final pct = total > 0 ? (count / total) : 0.0;
                final catItems = controller.items
                    .where((i) => i.category == catName)
                    .toList();

                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ExpansionTile(
                    shape: const Border(),
                    leading: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppTokens.terracotta.withAlpha(35),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        _iconForCategory(catName),
                        color: AppTokens.honeyAmber,
                        size: 22,
                      ),
                    ),
                    title: Text(
                      catName,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: AppTokens.textLight,
                      ),
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 6),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '$count items',
                                style: const TextStyle(
                                  fontSize: 11,
                                  color: AppTokens.textMuted,
                                ),
                              ),
                              Text(
                                '${(pct * 100).toStringAsFixed(0)}%',
                                style: const TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: AppTokens.honeyAmber,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: LinearProgressIndicator(
                              value: pct,
                              minHeight: 5,
                              backgroundColor: AppTokens.surfaceElevated,
                              valueColor: const AlwaysStoppedAnimation<Color>(
                                AppTokens.honeyAmber,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    children: catItems.map((item) {
                      return ListTile(
                        dense: true,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                        title: Text(
                          item.name,
                          style: const TextStyle(color: AppTokens.textLight, fontSize: 13),
                        ),
                        subtitle: Text(
                          '${item.quantity} ${item.unit} • 📍 ${item.location}',
                          style: const TextStyle(color: AppTokens.textDim, fontSize: 11),
                        ),
                        trailing: Text(
                          '${item.daysUntilExpiry}d left',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: item.daysUntilExpiry <= 3
                                ? AppTokens.honeyAmber
                                : AppTokens.sageGreen,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                );
              }),
          ],
        ),
      ),
    );
  }
}
