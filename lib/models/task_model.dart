enum TaskType { inBound, outBound }

class TaskModel {
  final String id;
  final String rack;
  final String itemName;
  final String sku;
  final int quantity;
  final TaskType type;
  final bool isCompleted;
  final DateTime createdAt;

  TaskModel({
    required this.id,
    required this.rack,
    required this.itemName,
    required this.sku,
    required this.quantity,
    required this.type,
    this.isCompleted = false,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  String get typeLabel => type == TaskType.inBound ? 'IN' : 'OUT';

  TaskModel copyWith({
    String? id,
    String? rack,
    String? itemName,
    String? sku,
    int? quantity,
    TaskType? type,
    bool? isCompleted,
    DateTime? createdAt,
  }) {
    return TaskModel(
      id: id ?? this.id,
      rack: rack ?? this.rack,
      itemName: itemName ?? this.itemName,
      sku: sku ?? this.sku,
      quantity: quantity ?? this.quantity,
      type: type ?? this.type,
      isCompleted: isCompleted ?? this.isCompleted,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
