import 'package:flutter/material.dart';
import '../app/brand.dart';
import '../app/theme.dart';

class KelpicoMainScreen extends StatefulWidget {
  const KelpicoMainScreen({super.key});
  @override
  State<KelpicoMainScreen> createState() => _KelpicoMainScreenState();
}

class _KelpicoMainScreenState extends State<KelpicoMainScreen> {
  int _currentIndex = 0;
  final List<Widget> _pages = const [
    PantryInventoryScreen(),
    QuickAddItemScreen(),
    ExpiringAlertScreen(),
    CategoryManagerScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Kelpico', style: AppTheme.display(cInk))),
      drawer: Drawer(
        child: ListView(
          children: [
            ListTile(title: Text('Inventory', style: AppTheme.text(cInk)), onTap: () { setState(() { _currentIndex = 0; }); Navigator.pop(context); }),
            ListTile(title: Text('Add Item', style: AppTheme.text(cInk)), onTap: () { setState(() { _currentIndex = 1; }); Navigator.pop(context); }),
            ListTile(title: Text('Expiring Soon', style: AppTheme.text(cInk)), onTap: () { setState(() { _currentIndex = 2; }); Navigator.pop(context); }),
            ListTile(title: Text('Categories', style: AppTheme.text(cInk)), onTap: () { setState(() { _currentIndex = 3; }); Navigator.pop(context); }),
          ],
        ),
      ),
      body: _pages[_currentIndex],
    );
  }
}

class PantryInventoryScreen extends StatelessWidget {
  const PantryInventoryScreen({super.key});
  @override
  Widget build(BuildContext context) { return Center(child: Text('Inventory', style: AppTheme.text(cInk))); }
}
class QuickAddItemScreen extends StatelessWidget {
  const QuickAddItemScreen({super.key});
  @override
  Widget build(BuildContext context) { return Center(child: Text('Quick Add', style: AppTheme.text(cInk))); }
}
class ExpiringAlertScreen extends StatelessWidget {
  const ExpiringAlertScreen({super.key});
  @override
  Widget build(BuildContext context) { return Center(child: Text('Expiring Alerts', style: AppTheme.text(cInk))); }
}
class CategoryManagerScreen extends StatelessWidget {
  const CategoryManagerScreen({super.key});
  @override
  Widget build(BuildContext context) { return Center(child: Text('Category Manager', style: AppTheme.text(cInk))); }
}
