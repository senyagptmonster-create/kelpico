import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'modules/inventory/inventory_controller.dart';
import 'common/app_tokens.dart';
import 'modules/inventory/inventory_view.dart';
import 'modules/quick_add/add_item_view.dart';
import 'modules/expiring/expiring_alerts_view.dart';
import 'modules/categories/categories_view.dart';

class KelpicoApp extends StatelessWidget {
  const KelpicoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => InventoryController()..initialize(),
      child: MaterialApp(
        title: 'Kelpico Pantry & Provisions',
        debugShowCheckedModeBanner: false,
        theme: AppTokens.theme,
        home: const _KelpicoShell(),
      ),
    );
  }
}

class _KelpicoShell extends StatefulWidget {
  const _KelpicoShell();

  @override
  State<_KelpicoShell> createState() => _KelpicoShellState();
}

class _KelpicoShellState extends State<_KelpicoShell> {
  int _currentIndex = 0;

  final List<Widget> _modules = const [
    InventoryView(),
    AddItemView(),
    ExpiringAlertsView(),
    CategoriesView(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _modules,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (idx) => setState(() => _currentIndex = idx),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.kitchen_outlined),
            selectedIcon: Icon(Icons.kitchen),
            label: 'Inventory',
          ),
          NavigationDestination(
            icon: Icon(Icons.add_box_outlined),
            selectedIcon: Icon(Icons.add_box),
            label: 'Stock In',
          ),
          NavigationDestination(
            icon: Icon(Icons.warning_amber_rounded),
            selectedIcon: Icon(Icons.warning_rounded),
            label: 'Expiring',
          ),
          NavigationDestination(
            icon: Icon(Icons.pie_chart_outline_rounded),
            selectedIcon: Icon(Icons.pie_chart_rounded),
            label: 'Departments',
          ),
        ],
      ),
    );
  }
}
