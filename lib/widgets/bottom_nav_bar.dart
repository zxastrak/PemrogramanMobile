import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const CustomBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 64,
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: const Border(
          top: BorderSide(color: AppColors.border, width: 1.5),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 6,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          _buildNavItem(index: 0, label: 'Item', icon: Icons.grid_view),
          _buildVerticalDivider(),
          _buildNavItem(index: 1, label: 'Home', icon: Icons.home_filled),
          _buildVerticalDivider(),
          _buildNavItem(index: 2, label: 'Menu', icon: Icons.person_outline),
        ],
      ),
    );
  }

  Widget _buildVerticalDivider() {
    return Container(
      width: 1.5,
      height: 64,
      color: AppColors.border,
    );
  }

  Widget _buildNavItem({
    required int index,
    required String label,
    required IconData icon,
  }) {
    final bool isSelected = currentIndex == index;

    return Expanded(
      child: Material(
        color: isSelected ? AppColors.greyLight : Colors.transparent,
        child: InkWell(
          onTap: () => onTap(index),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 22,
                color: isSelected ? AppColors.primary : AppColors.textSecondary,
              ),
              const SizedBox(height: 3),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                  color: isSelected ? AppColors.primary : AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
