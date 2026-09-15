import 'package:flutter/material.dart';
import '../models/pantry_item.dart';

class PantryScope extends InheritedWidget {
  final List<PantryItem> items;
  final Function(PantryItem) onAddItem;
  final Function(String) onRemoveItem;
  final Function(String) onToggleOpened;

  const PantryScope({
    super.key,
    required this.items,
    required this.onAddItem,
    required this.onRemoveItem,
    required this.onToggleOpened,
    required super.child,
  });

  static PantryScope of(BuildContext context) {
    final result = context.dependOnInheritedWidgetOfExactType<PantryScope>();
    assert(result != null, 'No PantryScope found in context');
    return result!;
  }

  @override
  bool updateShouldNotify(PantryScope oldWidget) {
    return items != oldWidget.items;
  }
}
