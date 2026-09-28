import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants/app_colors.dart';
import '../models/inventory_item_model.dart';
import '../providers/inventory_provider.dart';
import '../widgets/custom_search_bar.dart';
import '../widgets/item_grid_card.dart';
import '../widgets/qr_scanner_dialog.dart';

class ItemScreen extends StatefulWidget {
  const ItemScreen({super.key});

  @override
  State<ItemScreen> createState() => _ItemScreenState();
}

class _ItemScreenState extends State<ItemScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _showFilterCategoryModal(BuildContext context) {
    final invProvider = context.read<InventoryProvider>();

    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Kategori Barang',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: invProvider.categories.map((cat) {
                  final isSelected = invProvider.activeCategory == cat;
                  return ChoiceChip(
                    label: Text(cat),
                    selected: isSelected,
                    selectedColor: AppColors.primary,
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.white : AppColors.textPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                    onSelected: (selected) {
                      invProvider.setActiveCategory(cat);
                      Navigator.pop(context);
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  void _showQrScanner(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogCtx) {
        return QrScannerDialog(
          title: 'Pemindai Barcode / QR',
          subtitle: 'Arahkan kamera ke barcode rak atau label SKU barang',
          onScanned: (code) {
            _searchController.text = code;
            context.read<InventoryProvider>().setSearchQuery(code);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Mencari barcode: $code'),
                backgroundColor: AppColors.primary,
              ),
            );
          },
        );
      },
    );
  }

  void _showItemDetailDialog(BuildContext context, InventoryItemModel item) {
    showDialog(
      context: context,
      builder: (dialogCtx) {
        return AlertDialog(
          backgroundColor: AppColors.surface,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Row(
            children: [
              const Icon(Icons.inventory_2, color: AppColors.primary),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  item.name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _detailRow('SKU:', item.sku),
              _detailRow('Lokasi Rak:', item.rackLocation),
              _detailRow('Kategori:', item.category),
              _detailRow('Jumlah Stok:', '${item.stock} Unit'),
              _detailRow('Status:', item.status),
              if (item.description != null) ...[
                const SizedBox(height: 8),
                const Text(
                  'Deskripsi:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                    color: AppColors.textPrimary,
                  ),
                ),
                Text(
                  item.description!,
                  style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                ),
              ],
            ],
          ),
          actions: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
              onPressed: () => Navigator.pop(dialogCtx),
              child: const Text('Tutup', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  Widget _detailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 90,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 12,
                color: AppColors.textSecondary,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 12,
                color: AppColors.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final invProvider = context.watch<InventoryProvider>();
    final items = invProvider.filteredItems;

    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SafeArea(
        child: Stack(
          children: [

            CustomScrollView(
              slivers: [

                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 14, 16, 12),
                    child: CustomSearchBar(
                      controller: _searchController,
                      placeholder: 'Search',
                      onChanged: (val) {
                        invProvider.setSearchQuery(val);
                      },
                      onFilterTap: () => _showFilterCategoryModal(context),
                    ),
                  ),
                ),

                if (invProvider.activeCategory != 'Semua')
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppColors.greyLight,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              children: [
                                Text(
                                  'Kategori: ${invProvider.activeCategory}',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(width: 4),
                                GestureDetector(
                                  onTap: () => invProvider.setActiveCategory('Semua'),
                                  child: const Icon(Icons.close, size: 14),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  sliver: items.isEmpty
                      ? SliverToBoxAdapter(
                          child: Container(
                            height: 250,
                            alignment: Alignment.center,
                            child: const Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.inventory_2_outlined,
                                    size: 48, color: AppColors.greyMedium),
                                SizedBox(height: 10),
                                Text(
                                  'Barang tidak ditemukan.',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      : SliverGrid(
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 0.72,
                            crossAxisSpacing: 14,
                            mainAxisSpacing: 14,
                          ),
                          delegate: SliverChildBuilderDelegate(
                            (context, index) {
                              final item = items[index];
                              return ItemGridCard(
                                item: item,
                                onTap: () => _showItemDetailDialog(context, item),
                                onAddStock: () {
                                  invProvider.updateStock(item.id, 5);
                                },
                                onReduceStock: () {
                                  invProvider.updateStock(item.id, -5);
                                },
                              );
                            },
                            childCount: items.length,
                          ),
                        ),
                ),

                const SliverToBoxAdapter(
                  child: SizedBox(height: 90),
                ),
              ],
            ),

            Positioned(
              bottom: 20,
              right: 28,
              child: GestureDetector(
                onTap: () => _showQrScanner(context),
                child: Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: AppColors.greyLight,
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.border, width: 1.5),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.18),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  alignment: Alignment.center,
                  child: const Text(
                    'QR',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
