import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../models/inventory_item_model.dart';

class ItemGridCard extends StatelessWidget {
  final InventoryItemModel item;
  final VoidCallback onTap;
  final VoidCallback onAddStock;
  final VoidCallback onReduceStock;

  const ItemGridCard({
    super.key,
    required this.item,
    required this.onTap,
    required this.onAddStock,
    required this.onReduceStock,
  });

  @override
  Widget build(BuildContext context) {
    final bool isLowStock = item.stock < 15;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.greyLight.withValues(alpha: 0.55),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border, width: 1.2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Expanded(
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: AppColors.greyMedium.withValues(alpha: 0.5),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.border, width: 0.8),
                    ),
                    child: Stack(
                      children: [
                        Center(
                          child: Icon(
                            _getCategoryIcon(item.category),
                            size: 40,
                            color: AppColors.greyDarker,
                          ),
                        ),

                        Positioned(
                          top: 8,
                          left: 8,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                            decoration: BoxDecoration(
                              color: Colors.black54,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              item.rackLocation,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),

                        Positioned(
                          bottom: 8,
                          right: 8,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: isLowStock ? AppColors.outBadge : AppColors.inBadge,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              item.status,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 9,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 10),

                Text(
                  item.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),

                Text(
                  '${item.category} • ${item.sku}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 10,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 8),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Stok: ${item.stock}',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: isLowStock ? AppColors.outBadge : AppColors.textPrimary,
                      ),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _buildStockBtn(Icons.remove, onReduceStock),
                        const SizedBox(width: 4),
                        _buildStockBtn(Icons.add, onAddStock),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStockBtn(IconData icon, VoidCallback onPressed) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: AppColors.greyLight,
          shape: BoxShape.circle,
          border: Border.all(color: AppColors.border, width: 0.8),
        ),
        child: Icon(icon, size: 14, color: AppColors.textPrimary),
      ),
    );
  }

  IconData _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'packaging':
        return Icons.inventory_2_outlined;
      case 'storage':
        return Icons.shelves;
      case 'equipment':
        return Icons.precision_manufacturing_outlined;
      case 'electronics':
        return Icons.devices_other;
      case 'safety':
        return Icons.health_and_safety_outlined;
      default:
        return Icons.category_outlined;
    }
  }
}
