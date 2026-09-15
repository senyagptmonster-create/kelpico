enum StorageZone { pantry, fridge, freezer, spices }

class PantryItem {
  final String id;
  final String name;
  final StorageZone zone;
  final int daysToExpiry;
  final String quantity;
  final bool isOpened;

  const PantryItem({
    required this.id,
    required this.name,
    required this.zone,
    required this.daysToExpiry,
    required this.quantity,
    this.isOpened = false,
  });

  PantryItem copyWith({
    String? name,
    StorageZone? zone,
    int? daysToExpiry,
    String? quantity,
    bool? isOpened,
  }) {
    return PantryItem(
      id: id,
      name: name ?? this.name,
      zone: zone ?? this.zone,
      daysToExpiry: daysToExpiry ?? this.daysToExpiry,
      quantity: quantity ?? this.quantity,
      isOpened: isOpened ?? this.isOpened,
    );
  }

  String get zoneLabel {
    switch (zone) {
      case StorageZone.pantry:
        return 'Pantry Shelf';
      case StorageZone.fridge:
        return 'Refrigerator';
      case StorageZone.freezer:
        return 'Deep Freeze';
      case StorageZone.spices:
        return 'Spice Rack';
    }
  }
}
