import 'package:flutter/material.dart';
import 'models/pantry_item.dart';
import 'state/pantry_scope.dart';
import 'theme/kelpico_theme.dart';
import 'views/pantry_shelves_view.dart';
import 'views/expiring_alerts_view.dart';
import 'views/storage_zones_view.dart';

class KelpicoApp extends StatefulWidget {
  const KelpicoApp({super.key});

  @override
  State<KelpicoApp> createState() => _KelpicoAppState();
}

class _KelpicoAppState extends State<KelpicoApp> {
  final List<PantryItem> _items = [
    const PantryItem(id: '1', name: 'Rolled Oats', zone: StorageZone.pantry, daysToExpiry: 45, quantity: '1.2 kg'),
    const PantryItem(id: '2', name: 'Almond Milk', zone: StorageZone.fridge, daysToExpiry: 3, quantity: '1 L'),
    const PantryItem(id: '3', name: 'Greek Yogurt', zone: StorageZone.fridge, daysToExpiry: 2, quantity: '500 g'),
    const PantryItem(id: '4', name: 'Smoked Paprika', zone: StorageZone.spices, daysToExpiry: 180, quantity: '75 g'),
    const PantryItem(id: '5', name: 'Frozen Blueberries', zone: StorageZone.freezer, daysToExpiry: 90, quantity: '800 g'),
    const PantryItem(id: '6', name: 'Brown Rice', zone: StorageZone.pantry, daysToExpiry: 120, quantity: '2 kg'),
  ];

  int _selectedNav = 0;

  void _addItem(PantryItem item) {
    setState(() => _items.add(item));
  }

  void _removeItem(String id) {
    setState(() => _items.removeWhere((i) => i.id == id));
  }

  void _toggleOpened(String id) {
    setState(() {
      final idx = _items.indexWhere((i) => i.id == id);
      if (idx != -1) {
        _items[idx] = _items[idx].copyWith(isOpened: !_items[idx].isOpened);
      }
    });
  }

  void _showAddDialog() {
    final nameCtrl = TextEditingController();
    final qtyCtrl = TextEditingController();
    StorageZone selectedZone = StorageZone.pantry;
    int expiry = 14;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          title: const Text('Add Provision'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameCtrl,
                decoration: const InputDecoration(labelText: 'Item Name'),
              ),
              TextField(
                controller: qtyCtrl,
                decoration: const InputDecoration(labelText: 'Quantity (e.g. 500g, 2 cans)'),
              ),
              const SizedBox(height: 12),
              DropdownButton<StorageZone>(
                value: selectedZone,
                isExpanded: true,
                items: StorageZone.values.map((z) {
                  return DropdownMenuItem(value: z, child: Text(z.name.toUpperCase()));
                }).toList(),
                onChanged: (v) {
                  if (v != null) setDialogState(() => selectedZone = v);
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (nameCtrl.text.isNotEmpty) {
                  _addItem(PantryItem(
                    id: DateTime.now().millisecondsSinceEpoch.toString(),
                    name: nameCtrl.text,
                    zone: selectedZone,
                    daysToExpiry: expiry,
                    quantity: qtyCtrl.text.isEmpty ? '1 unit' : qtyCtrl.text,
                  ));
                  Navigator.pop(ctx);
                }
              },
              child: const Text('Add'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget content;
    String title;
    switch (_selectedNav) {
      case 0:
        content = const PantryShelvesView();
        title = 'Pantry Shelves';
        break;
      case 1:
        content = const ExpiringAlertsView();
        title = 'Expiry Alerts';
        break;
      case 2:
      default:
        content = const StorageZonesView();
        title = 'Storage Zones';
        break;
    }

    return PantryScope(
      items: _items,
      onAddItem: _addItem,
      onRemoveItem: _removeItem,
      onToggleOpened: _toggleOpened,
      child: MaterialApp(
        title: 'Kelpico Pantry',
        debugShowCheckedModeBanner: false,
        theme: KelpicoTheme.themeData,
        home: Scaffold(
          appBar: AppBar(
            title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
            actions: [
              IconButton(
                icon: const Icon(Icons.add_circle_outline, color: KelpicoTheme.accent),
                onPressed: _showAddDialog,
              ),
            ],
          ),
          drawer: Drawer(
            child: Builder(
              builder: (drawerContext) => ListView(
                padding: EdgeInsets.zero,
                children: [
                  DrawerHeader(
                    decoration: const BoxDecoration(
                      color: KelpicoTheme.accent,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        const CircleAvatar(
                          backgroundColor: Colors.white,
                          radius: 24,
                          child: Icon(Icons.kitchen, color: KelpicoTheme.accent, size: 28),
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          'Kelpico Auditor',
                          style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          '${_items.length} active provisions',
                          style: const TextStyle(color: Colors.white70, fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                  ListTile(
                    leading: const Icon(Icons.shelves),
                    title: const Text('Pantry Shelves'),
                    selected: _selectedNav == 0,
                    onTap: () {
                      setState(() => _selectedNav = 0);
                      Navigator.pop(drawerContext);
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.notification_important_outlined),
                    title: const Text('Expiry Alerts'),
                    selected: _selectedNav == 1,
                    onTap: () {
                      setState(() => _selectedNav = 1);
                      Navigator.pop(drawerContext);
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.dashboard_customize_outlined),
                    title: const Text('Storage Zones'),
                    selected: _selectedNav == 2,
                    onTap: () {
                      setState(() => _selectedNav = 2);
                      Navigator.pop(drawerContext);
                    },
                  ),
                ],
              ),
            ),
          ),
          body: content,
        ),
      ),
    );
  }
}
