import 'package:flutter/material.dart';
import '../models/task_model.dart';

class TaskProvider with ChangeNotifier {
  final List<TaskModel> _tasks = [
    TaskModel(
      id: 'TSK-001',
      rack: 'Rak A-02',
      itemName: 'Forklift Hydraulic Pump',
      sku: 'SKU-99023412',
      quantity: 120,
      type: TaskType.inBound,
      isCompleted: false,
    ),
    TaskModel(
      id: 'TSK-002',
      rack: 'Rak B-14',
      itemName: 'Heavy Duty Pallet Wrap',
      sku: 'SKU-88341901',
      quantity: 450,
      type: TaskType.outBound,
      isCompleted: false,
    ),
    TaskModel(
      id: 'TSK-003',
      rack: 'Rak A-08',
      itemName: 'Industrial Safety Helmet',
      sku: 'SKU-77219084',
      quantity: 80,
      type: TaskType.inBound,
      isCompleted: true,
    ),
    TaskModel(
      id: 'TSK-004',
      rack: 'Rak C-05',
      itemName: 'Thermal Barcode Scanner',
      sku: 'SKU-44120938',
      quantity: 25,
      type: TaskType.outBound,
      isCompleted: false,
    ),
    TaskModel(
      id: 'TSK-005',
      rack: 'Rak B-01',
      itemName: 'Steel Racking Bolts M12',
      sku: 'SKU-33290112',
      quantity: 600,
      type: TaskType.inBound,
      isCompleted: false,
    ),
  ];

  String _searchQuery = '';
  String _activeFilter = 'Semua';

  List<TaskModel> get allTasks => [..._tasks];
  String get searchQuery => _searchQuery;
  String get activeFilter => _activeFilter;

  List<TaskModel> get filteredTasks {
    return _tasks.where((task) {
      final matchesSearch = task.itemName.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          task.rack.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          task.sku.toLowerCase().contains(_searchQuery.toLowerCase());

      if (!matchesSearch) return false;

      if (_activeFilter == 'IN') {
        return task.type == TaskType.inBound;
      } else if (_activeFilter == 'OUT') {
        return task.type == TaskType.outBound;
      } else if (_activeFilter == 'Selesai') {
        return task.isCompleted;
      }

      return true;
    }).toList();
  }

  int get pendingTasksCount => _tasks.where((t) => !t.isCompleted).length;
  int get completedTasksCount => _tasks.where((t) => t.isCompleted).length;

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void setActiveFilter(String filter) {
    _activeFilter = filter;
    notifyListeners();
  }

  void addTask(TaskModel newTask) {
    _tasks.insert(0, newTask);
    notifyListeners();
  }

  void toggleTaskStatus(String id) {
    final index = _tasks.indexWhere((t) => t.id == id);
    if (index != -1) {
      _tasks[index] = _tasks[index].copyWith(
        isCompleted: !_tasks[index].isCompleted,
      );
      notifyListeners();
    }
  }

  void deleteTask(String id) {
    _tasks.removeWhere((t) => t.id == id);
    notifyListeners();
  }
}
