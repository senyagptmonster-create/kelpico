import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PantryItem {
  final String id;
  final String name;
  final String category;
  int quantity;
  final String unit;
  DateTime expiryDate;
  final DateTime addedDate;
  final String location;
  bool isConsumed;

  PantryItem({
    required this.id,
    required this.name,
    required this.category,
    required this.quantity,
    required this.unit,
    required this.expiryDate,
    required this.addedDate,
    required this.location,
    this.isConsumed = false,
  });

  int get daysUntilExpiry {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final target = DateTime(expiryDate.year, expiryDate.month, expiryDate.day);
    return target.difference(today).inDays;
  }

  bool get isExpired => daysUntilExpiry < 0;
  bool get isExpiringSoon => daysUntilExpiry >= 0 && daysUntilExpiry <= 3;

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'category': category,
        'quantity': quantity,
        'unit': unit,
        'expiryDate': expiryDate.toIso8601String(),
        'addedDate': addedDate.toIso8601String(),
        'location': location,
        'isConsumed': isConsumed,
      };

  factory PantryItem.fromJson(Map<String, dynamic> json) => PantryItem(
        id: json['id'] as String,
        name: json['name'] as String,
        category: json['category'] as String,
        quantity: json['quantity'] as int,
        unit: json['unit'] as String,
        expiryDate: DateTime.parse(json['expiryDate'] as String),
        addedDate: DateTime.parse(json['addedDate'] as String),
        location: json['location'] as String,
        isConsumed: json['isConsumed'] as bool? ?? false,
      );
}

class InventoryController extends ChangeNotifier {
  static const String _storageKey = 'kelpico_pantry_inventory_v1';

  List<PantryItem> _items = [];
  bool _isInitialized = false;

  List<PantryItem> get items =>
      _items.where((item) => !item.isConsumed).toList();
  List<PantryItem> get allItems => List.unmodifiable(_items);
  bool get isInitialized => _isInitialized;

  List<PantryItem> get expiringSoonItems {
    return items.where((item) => item.isExpiringSoon || item.isExpired).toList()
      ..sort((a, b) => a.daysUntilExpiry.compareTo(b.daysUntilExpiry));
  }

  int get totalItemCount => items.fold(0, (acc, item) => acc + item.quantity);

  Map<String, int> get categoryCounts {
    final map = <String, int>{};
    for (final item in items) {
      map[item.category] = (map[item.category] ?? 0) + item.quantity;
    }
    return map;
  }

  Future<void> initialize() async {
    if (_isInitialized) return;
    try {
      final prefs = await SharedPreferences.getInstance();
      final data = prefs.getString(_storageKey);
      if (data != null && data.isNotEmpty) {
        final decoded = jsonDecode(data) as List<dynamic>;
        _items = decoded
            .map((e) => PantryItem.fromJson(e as Map<String, dynamic>))
            .toList();
      } else {
        _items = _seedPantry();
        await _save();
      }
    } catch (e) {
      debugPrint('Kelpico storage error: $e');
      _items = _seedPantry();
    }
    _isInitialized = true;
    notifyListeners();
  }

  Future<void> _save() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonStr = jsonEncode(_items.map((e) => e.toJson()).toList());
    await prefs.setString(_storageKey, jsonStr);
  }

  Future<void> addItem({
    required String name,
    required String category,
    required int quantity,
    required String unit,
    required DateTime expiryDate,
    required String location,
  }) async {
    final newItem = PantryItem(
      id: 'item_${DateTime.now().millisecondsSinceEpoch}',
      name: name,
      category: category,
      quantity: quantity,
      unit: unit,
      expiryDate: expiryDate,
      addedDate: DateTime.now(),
      location: location,
    );
    _items.insert(0, newItem);
    await _save();
    notifyListeners();
  }

  Future<void> markConsumed(String id) async {
    final index = _items.indexWhere((item) => item.id == id);
    if (index != -1) {
      _items[index].isConsumed = true;
      await _save();
      notifyListeners();
    }
  }

  Future<void> updateQuantity(String id, int delta) async {
    final index = _items.indexWhere((item) => item.id == id);
    if (index != -1) {
      final newQty = _items[index].quantity + delta;
      if (newQty <= 0) {
        _items[index].isConsumed = true;
      } else {
        _items[index].quantity = newQty;
      }
      await _save();
      notifyListeners();
    }
  }

  Future<void> extendExpiry(String id, int additionalDays) async {
    final index = _items.indexWhere((item) => item.id == id);
    if (index != -1) {
      _items[index].expiryDate =
          _items[index].expiryDate.add(Duration(days: additionalDays));
      await _save();
      notifyListeners();
    }
  }

  Future<void> deleteItem(String id) async {
    _items.removeWhere((item) => item.id == id);
    await _save();
    notifyListeners();
  }

  List<PantryItem> _seedPantry() {
    final now = DateTime.now();
    return [
      PantryItem(
        id: 'p_1',
        name: 'Greek Whole Milk Yogurt',
        category: 'Dairy & Eggs',
        quantity: 1,
        unit: 'tub (500g)',
        expiryDate: now.add(const Duration(days: 2)),
        addedDate: now.subtract(const Duration(days: 4)),
        location: 'Top Refrigerator Shelf',
      ),
      PantryItem(
        id: 'p_2',
        name: 'Organic Baby Spinach',
        category: 'Produce',
        quantity: 1,
        unit: 'bag',
        expiryDate: now.add(const Duration(days: 1)),
        addedDate: now.subtract(const Duration(days: 3)),
        location: 'Crisper Drawer',
      ),
      PantryItem(
        id: 'p_3',
        name: 'San Marzano Crushed Tomatoes',
        category: 'Canned Goods',
        quantity: 4,
        unit: 'cans (400g)',
        expiryDate: now.add(const Duration(days: 240)),
        addedDate: now.subtract(const Duration(days: 20)),
        location: 'Main Pantry Shelf 2',
      ),
      PantryItem(
        id: 'p_4',
        name: 'Arborio Risotto Rice',
        category: 'Grains & Pasta',
        quantity: 2,
        unit: 'kg',
        expiryDate: now.add(const Duration(days: 180)),
        addedDate: now.subtract(const Duration(days: 15)),
        location: 'Dry Goods Bin',
      ),
      PantryItem(
        id: 'p_5',
        name: 'Smoked Spanish Paprika',
        category: 'Spices & Seasoning',
        quantity: 1,
        unit: 'tin',
        expiryDate: now.add(const Duration(days: 365)),
        addedDate: now.subtract(const Duration(days: 30)),
        location: 'Tiered Spice Carousel',
      ),
      PantryItem(
        id: 'p_6',
        name: 'Sourdough Artisan Bread',
        category: 'Bakery',
        quantity: 1,
        unit: 'loaf',
        expiryDate: now.add(const Duration(days: 3)),
        addedDate: now.subtract(const Duration(days: 1)),
        location: 'Bread Box',
      ),
    ];
  }
}
