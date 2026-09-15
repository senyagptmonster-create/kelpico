import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../inventory/inventory_controller.dart';
import '../../common/app_tokens.dart';

class AddItemView extends StatefulWidget {
  const AddItemView({super.key});

  @override
  State<AddItemView> createState() => _AddItemViewState();
}

class _AddItemViewState extends State<AddItemView> {
  final _nameCtrl = TextEditingController();
  final _unitCtrl = TextEditingController(text: 'items');
  final _locationCtrl = TextEditingController(text: 'Main Pantry Shelf');

  String _selectedCategory = 'Grains & Pasta';
  int _quantity = 1;
  DateTime _expiryDate = DateTime.now().add(const Duration(days: 7));

  final List<String> _categories = [
    'Grains & Pasta',
    'Canned Goods',
    'Spices & Seasoning',
    'Dairy & Eggs',
    'Produce',
    'Bakery',
    'Baking & Oils',
  ];

  @override
  void dispose() {
    _nameCtrl.dispose();
    _unitCtrl.dispose();
    _locationCtrl.dispose();
    super.dispose();
  }

  void _applyQuickExpiry(int days) {
    setState(() {
      _expiryDate = DateTime.now().add(Duration(days: days));
    });
  }

  Future<void> _pickCustomDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _expiryDate,
      firstDate: DateTime.now().subtract(const Duration(days: 30)),
      lastDate: DateTime.now().add(const Duration(days: 365 * 3)),
      builder: (ctx, child) {
        return Theme(
          data: Theme.of(ctx).copyWith(
            colorScheme: const ColorScheme.dark(
              primary: AppTokens.terracotta,
              surface: AppTokens.surfaceWarm,
              onSurface: AppTokens.textLight,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() => _expiryDate = picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<InventoryController>(context, listen: false);
    final dateStr =
        '${_expiryDate.year}-${_expiryDate.month.toString().padLeft(2, '0')}-${_expiryDate.day.toString().padLeft(2, '0')}';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Quick Stock Entry'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Provision Details',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppTokens.textLight,
              ),
            ),
            const SizedBox(height: 12),

            TextField(
              controller: _nameCtrl,
              decoration: const InputDecoration(
                labelText: 'Item Name (e.g. Organic Rolled Oats)',
              ),
            ),
            const SizedBox(height: 16),

            const Text(
              'Pantry Category',
              style: TextStyle(fontSize: 12, color: AppTokens.textMuted),
            ),
            const SizedBox(height: 6),
            DropdownButtonFormField<String>(
              initialValue: _selectedCategory,
              dropdownColor: AppTokens.surfaceElevated,
              items: _categories.map((c) {
                return DropdownMenuItem(value: c, child: Text(c));
              }).toList(),
              onChanged: (v) {
                if (v != null) setState(() => _selectedCategory = v);
              },
            ),
            const SizedBox(height: 16),

            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Quantity Count',
                        style: TextStyle(fontSize: 12, color: AppTokens.textMuted),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          IconButton(
                            style: IconButton.styleFrom(
                              backgroundColor: AppTokens.surfaceElevated,
                            ),
                            icon: const Icon(Icons.remove, color: AppTokens.textLight),
                            onPressed: () {
                              if (_quantity > 1) setState(() => _quantity--);
                            },
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Text(
                              '$_quantity',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: AppTokens.textLight,
                              ),
                            ),
                          ),
                          IconButton(
                            style: IconButton.styleFrom(
                              backgroundColor: AppTokens.surfaceElevated,
                            ),
                            icon: const Icon(Icons.add, color: AppTokens.honeyAmber),
                            onPressed: () => setState(() => _quantity++),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Package Unit',
                        style: TextStyle(fontSize: 12, color: AppTokens.textMuted),
                      ),
                      const SizedBox(height: 6),
                      TextField(
                        controller: _unitCtrl,
                        decoration: const InputDecoration(
                          hintText: 'e.g. cans, kg, boxes',
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Expiry Date Section
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Expiration Best-By Date',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: AppTokens.textLight,
                          ),
                        ),
                        TextButton.icon(
                          onPressed: _pickCustomDate,
                          icon: const Icon(Icons.calendar_today, size: 16, color: AppTokens.honeyAmber),
                          label: Text(
                            dateStr,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: AppTokens.honeyAmber,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Quick Presets:',
                      style: TextStyle(fontSize: 11, color: AppTokens.textMuted),
                    ),
                    const SizedBox(height: 6),
                    Wrap(
                      spacing: 8,
                      children: [
                        ActionChip(
                          label: const Text('+3 Days'),
                          backgroundColor: AppTokens.surfaceElevated,
                          onPressed: () => _applyQuickExpiry(3),
                        ),
                        ActionChip(
                          label: const Text('+1 Week'),
                          backgroundColor: AppTokens.surfaceElevated,
                          onPressed: () => _applyQuickExpiry(7),
                        ),
                        ActionChip(
                          label: const Text('+1 Month'),
                          backgroundColor: AppTokens.surfaceElevated,
                          onPressed: () => _applyQuickExpiry(30),
                        ),
                        ActionChip(
                          label: const Text('+6 Months'),
                          backgroundColor: AppTokens.surfaceElevated,
                          onPressed: () => _applyQuickExpiry(180),
                        ),
                        ActionChip(
                          label: const Text('+1 Year'),
                          backgroundColor: AppTokens.surfaceElevated,
                          onPressed: () => _applyQuickExpiry(365),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            TextField(
              controller: _locationCtrl,
              decoration: const InputDecoration(
                labelText: 'Storage Location (Shelf, Drawer, Cellar)',
                prefixIcon: Icon(Icons.place_outlined, color: AppTokens.textMuted),
              ),
            ),
            const SizedBox(height: 28),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  final name = _nameCtrl.text.trim();
                  if (name.isEmpty) return;

                  controller.addItem(
                    name: name,
                    category: _selectedCategory,
                    quantity: _quantity,
                    unit: _unitCtrl.text.trim().isEmpty ? 'item' : _unitCtrl.text.trim(),
                    expiryDate: _expiryDate,
                    location: _locationCtrl.text.trim().isEmpty ? 'Pantry' : _locationCtrl.text.trim(),
                  );

                  _nameCtrl.clear();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Added "$name" to pantry inventory.'),
                      backgroundColor: AppTokens.surfaceElevated,
                    ),
                  );
                },
                icon: const Icon(Icons.add_shopping_cart_rounded, size: 20),
                label: const Text('Add Provision to Pantry'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
