import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../inventory/inventory_controller.dart';
import '../../common/app_tokens.dart';

class ExpiringAlertsView extends StatelessWidget {
  const ExpiringAlertsView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<InventoryController>(context);
    final alertItems = controller.expiringSoonItems;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Spoilage Prevention Alerts'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Status banner
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    alertItems.isEmpty
                        ? AppTokens.sageGreen.withAlpha(40)
                        : AppTokens.crimsonAlert.withAlpha(45),
                    AppTokens.surfaceElevated,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: alertItems.isEmpty
                      ? AppTokens.sageGreen.withAlpha(80)
                      : AppTokens.crimsonAlert.withAlpha(100),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: alertItems.isEmpty
                          ? AppTokens.sageGreen.withAlpha(50)
                          : AppTokens.crimsonAlert.withAlpha(50),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      alertItems.isEmpty
                          ? Icons.verified_outlined
                          : Icons.notification_important_rounded,
                      color: alertItems.isEmpty
                          ? AppTokens.sageGreen
                          : AppTokens.crimsonAlert,
                      size: 26,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          alertItems.isEmpty
                              ? 'Zero Imminent Spoilage'
                              : '${alertItems.length} Provisions Expiring Soon',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppTokens.textLight,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          alertItems.isEmpty
                              ? 'All pantry provisions are safely within best-by limits.'
                              : 'Consume or cook these items within the next 72 hours.',
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppTokens.textMuted,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            const Text(
              'Urgent Consumption Queue',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppTokens.textLight,
              ),
            ),
            const SizedBox(height: 12),

            if (alertItems.isEmpty)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(
                  color: AppTokens.surfaceWarm,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: const [
                    Icon(
                      Icons.eco_rounded,
                      size: 48,
                      color: AppTokens.sageGreen,
                    ),
                    SizedBox(height: 12),
                    Text(
                      'Pantry rotation is on point! No waste detected.',
                      style: TextStyle(color: AppTokens.textMuted),
                    ),
                  ],
                ),
              )
            else
              ...alertItems.map((item) {
                final days = item.daysUntilExpiry;
                final isExpired = item.isExpired;

                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: isExpired
                                    ? AppTokens.crimsonAlert.withAlpha(40)
                                    : AppTokens.honeyAmber.withAlpha(40),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                isExpired
                                    ? 'EXPIRED'
                                    : (days == 0 ? 'TODAY' : '${days}d LEFT'),
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: isExpired
                                      ? AppTokens.crimsonAlert
                                      : AppTokens.honeyAmber,
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item.name,
                                    style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: AppTokens.textLight,
                                    ),
                                  ),
                                  Text(
                                    '${item.quantity} ${item.unit} • ${item.location}',
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: AppTokens.textMuted,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 14),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            OutlinedButton.icon(
                              onPressed: () => controller.extendExpiry(item.id, 7),
                              icon: const Icon(Icons.update, size: 16),
                              label: const Text('+7d Life'),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: AppTokens.textMuted,
                                side: const BorderSide(color: AppTokens.borderWarm),
                                padding: const EdgeInsets.symmetric(horizontal: 12),
                              ),
                            ),
                            const SizedBox(width: 10),
                            ElevatedButton.icon(
                              onPressed: () => controller.markConsumed(item.id),
                              icon: const Icon(Icons.done_all_rounded, size: 16),
                              label: const Text('Used in Recipe'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppTokens.sageGreen,
                                padding: const EdgeInsets.symmetric(horizontal: 14),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              }),
          ],
        ),
      ),
    );
  }
}
