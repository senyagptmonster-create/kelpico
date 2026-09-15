import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'inventory_controller.dart';
import '../../common/app_tokens.dart';

class InventoryView extends StatefulWidget {
  const InventoryView({super.key});

  @override
  State<InventoryView> createState() => _InventoryViewState();
}

class _InventoryViewState extends State<InventoryView> {
  String _searchQuery = '';
  String _selectedCategory = 'All';
  final TextEditingController _searchCtrl = TextEditingController();

  final List<String> _categories = [
    'All',
    'Dairy & Eggs',
    'Produce',
    'Canned Goods',
    'Grains & Pasta',
    'Spices & Seasoning',
    'Bakery',
  ];

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  Color _expiryBadgeColor(PantryItem item) {
    if (item.isExpired) return AppTokens.crimsonAlert;
    if (item.isExpiringSoon) return AppTokens.honeyAmber;
    return AppTokens.sageGreen;
  }

  String _expiryBadgeText(PantryItem item) {
    final days = item.daysUntilExpiry;
    if (days < 0) return 'Expired (${days.abs()}d ago)';
    if (days == 0) return 'Expires Today!';
    if (days == 1) return 'Expires Tomorrow';
    if (days <= 3) return 'Expires in $days days';
    return '$days days left';
  }

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<InventoryController>(context);
    final items = controller.items;

    final filtered = items.where((item) {
      final matchesCat =
          _selectedCategory == 'All' || item.category == _selectedCategory;
      final matchesSearch = _searchQuery.isEmpty ||
          item.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          item.location.toLowerCase().contains(_searchQuery.toLowerCase());
      return matchesCat && matchesSearch;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pantry Inventory'),
      ),
      body: Column(
        children: [
          // Search input
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchCtrl,
              onChanged: (v) => setState(() => _searchQuery = v),
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search, color: AppTokens.textMuted),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear, size: 18),
                        onPressed: () {
                          _searchCtrl.clear();
                          setState(() => _searchQuery = '');
                        },
                      )
                    : null,
                hintText: 'Search pantry by item or shelf location...',
              ),
            ),
          ),

          // Categories Filter Row
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: _categories.map((cat) {
                final isSelected = _selectedCategory == cat;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: Text(cat),
                    selected: isSelected,
                    selectedColor: AppTokens.terracotta,
                    backgroundColor: AppTokens.surfaceElevated,
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.white : AppTokens.textLight,
                      fontSize: 12,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                    checkmarkColor: Colors.white,
                    onSelected: (val) {
                      if (val) setState(() => _selectedCategory = cat);
                    },
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 10),

          // Items List
          Expanded(
            child: filtered.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(
                          Icons.kitchen_outlined,
                          size: 48,
                          color: AppTokens.textDim,
                        ),
                        SizedBox(height: 12),
                        Text(
                          'No pantry provisions found matching criteria.',
                          style: TextStyle(color: AppTokens.textMuted),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                    itemCount: filtered.length,
                    itemBuilder: (ctx, i) {
                      final item = filtered[i];
                      final badgeColor = _expiryBadgeColor(item);
                      final badgeText = _expiryBadgeText(item);

                      return Card(
                        margin: const EdgeInsets.only(bottom: 10),
                        child: Padding(
                          padding: const EdgeInsets.all(14),
                          child: Row(
                            children: [
                              // Quantity counter column
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                  color: AppTokens.surfaceElevated,
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(color: AppTokens.borderWarm),
                                ),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    InkWell(
                                      onTap: () => controller.updateQuantity(item.id, 1),
                                      child: const Icon(
                                        Icons.add,
                                        size: 16,
                                        color: AppTokens.honeyAmber,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      '${item.quantity}',
                                      style: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        color: AppTokens.textLight,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    InkWell(
                                      onTap: () => controller.updateQuantity(item.id, -1),
                                      child: const Icon(
                                        Icons.remove,
                                        size: 16,
                                        color: AppTokens.textMuted,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 14),

                              // Item info
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            item.name,
                                            style: const TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold,
                                              color: AppTokens.textLight,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 3),
                                    Text(
                                      '${item.category} • ${item.unit}',
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: AppTokens.textMuted,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      '📍 ${item.location}',
                                      style: const TextStyle(
                                        fontSize: 11,
                                        color: AppTokens.textDim,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 3,
                                      ),
                                      decoration: BoxDecoration(
                                        color: badgeColor.withAlpha(30),
                                        borderRadius: BorderRadius.circular(6),
                                        border: Border.all(color: badgeColor.withAlpha(80)),
                                      ),
                                      child: Text(
                                        badgeText,
                                        style: TextStyle(
                                          fontSize: 11,
                                          fontWeight: FontWeight.bold,
                                          color: badgeColor,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              IconButton(
                                icon: const Icon(
                                  Icons.check_circle_outline_rounded,
                                  color: AppTokens.sageGreen,
                                ),
                                tooltip: 'Mark Used',
                                onPressed: () => controller.markConsumed(item.id),
                              ),
                            ],
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
