import 'package:flutter/material.dart';
import '../models/inventory_item_model.dart';

class InventoryProvider with ChangeNotifier {
  final List<InventoryItemModel> _items = [
    InventoryItemModel(
      id: 'ITM-001',
      name: 'Kotak Kardus Tebal A1',
      sku: 'SKU-001-KRD',
      rackLocation: 'Rak A-01',
      stock: 350,
      category: 'Packaging',
      status: 'Tersedia',
      description: 'Kardus double wall dimensi 40x30x30 cm',
    ),
    InventoryItemModel(
      id: 'ITM-002',
      name: 'Bubble Wrap 50m Roll',
      sku: 'SKU-002-BBL',
      rackLocation: 'Rak A-03',
      stock: 120,
      category: 'Packaging',
      status: 'Tersedia',
      description: 'Roll bubble wrap pelindung barang pecah belah',
    ),
    InventoryItemModel(
      id: 'ITM-003',
      name: 'Pallet Kayu Standar',
      sku: 'SKU-003-PLT',
      rackLocation: 'Rak B-01',
      stock: 45,
      category: 'Storage',
      status: 'Tersedia',
      description: 'Pallet kayu pinus standar ekspor 120x100 cm',
    ),
    InventoryItemModel(
      id: 'ITM-004',
      name: 'Lakban Bening 2 Inch',
      sku: 'SKU-004-LKB',
      rackLocation: 'Rak A-05',
      stock: 12,
      category: 'Packaging',
      status: 'Menipis',
      description: 'Lakban opp tape 48mm x 100 yard',
    ),
    InventoryItemModel(
      id: 'ITM-005',
      name: 'Hand Pallet Manual 3 Ton',
      sku: 'SKU-005-HPL',
      rackLocation: 'Zone Loading',
      stock: 4,
      category: 'Equipment',
      status: 'Tersedia',
      description: 'Hand pallet truck kapasitas angkut 3000 kg',
    ),
    InventoryItemModel(
      id: 'ITM-006',
      name: 'Barcode Scanner Wireless',
      sku: 'SKU-006-SCN',
      rackLocation: 'Rak C-02',
      stock: 18,
      category: 'Electronics',
      status: 'Tersedia',
      description: 'Scanner 1D/2D Bluetooth & 2.4G wireless',
    ),
    InventoryItemModel(
      id: 'ITM-007',
      name: 'Sarung Tangan Karet Safety',
      sku: 'SKU-007-GLV',
      rackLocation: 'Rak C-07',
      stock: 220,
      category: 'Safety',
      status: 'Tersedia',
      description: 'Nitrile coated safety working gloves',
    ),
    InventoryItemModel(
      id: 'ITM-008',
      name: 'Plastik Stretch Film 500m',
      sku: 'SKU-008-STR',
      rackLocation: 'Rak B-06',
      stock: 3,
      category: 'Packaging',
      status: 'Menipis',
      description: 'Plastik wrapping pembungkus palet bening',
    ),
  ];

  String _searchQuery = '';
  String _activeCategory = 'Semua';

  List<InventoryItemModel> get allItems => [..._items];
  String get searchQuery => _searchQuery;
  String get activeCategory => _activeCategory;

  List<String> get categories => [
        'Semua',
        'Packaging',
        'Storage',
        'Equipment',
        'Electronics',
        'Safety',
      ];

  List<InventoryItemModel> get filteredItems {
    return _items.where((item) {
      final matchesSearch = item.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          item.rackLocation.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          item.sku.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          item.category.toLowerCase().contains(_searchQuery.toLowerCase());

      if (!matchesSearch) return false;

      if (_activeCategory != 'Semua' && item.category != _activeCategory) {
        return false;
      }

      return true;
    }).toList();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void setActiveCategory(String category) {
    _activeCategory = category;
    notifyListeners();
  }

  void addItem(InventoryItemModel item) {
    _items.insert(0, item);
    notifyListeners();
  }

  void updateStock(String id, int delta) {
    final index = _items.indexWhere((i) => i.id == id);
    if (index != -1) {
      final newStock = (_items[index].stock + delta).clamp(0, 99999);
      final newStatus = newStock == 0
          ? 'Habis'
          : (newStock < 15 ? 'Menipis' : 'Tersedia');
      _items[index] = _items[index].copyWith(
        stock: newStock,
        status: newStatus,
      );
      notifyListeners();
    }
  }
}
