class InventoryItemModel {
  final String id;
  final String name;
  final String sku;
  final String rackLocation;
  final int stock;
  final String category;
  final String status;
  final String? description;

  InventoryItemModel({
    required this.id,
    required this.name,
    required this.sku,
    required this.rackLocation,
    required this.stock,
    required this.category,
    this.status = 'Tersedia',
    this.description,
  });

  InventoryItemModel copyWith({
    String? id,
    String? name,
    String? sku,
    String? rackLocation,
    int? stock,
    String? category,
    String? status,
    String? description,
  }) {
    return InventoryItemModel(
      id: id ?? this.id,
      name: name ?? this.name,
      sku: sku ?? this.sku,
      rackLocation: rackLocation ?? this.rackLocation,
      stock: stock ?? this.stock,
      category: category ?? this.category,
      status: status ?? this.status,
      description: description ?? this.description,
    );
  }
}
