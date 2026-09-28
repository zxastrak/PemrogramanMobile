import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class CustomSearchBar extends StatelessWidget {
  final String placeholder;
  final ValueChanged<String> onChanged;
  final VoidCallback onFilterTap;
  final TextEditingController? controller;

  const CustomSearchBar({
    super.key,
    this.placeholder = 'Search',
    required this.onChanged,
    required this.onFilterTap,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [

        Expanded(
          child: Container(
            height: 44,
            decoration: BoxDecoration(
              color: AppColors.greyLight,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppColors.border, width: 1),
            ),
            child: TextField(
              controller: controller,
              onChanged: onChanged,
              textAlignVertical: TextAlignVertical.center,
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w500,
              ),
              decoration: InputDecoration(
                isDense: true,
                hintText: placeholder,
                hintStyle: const TextStyle(
                  color: AppColors.greyDark,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
                prefixIcon: const Icon(
                  Icons.search,
                  size: 20,
                  color: AppColors.greyDark,
                ),
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),

        GestureDetector(
          onTap: onFilterTap,
          child: Container(
            height: 44,
            padding: const EdgeInsets.symmetric(horizontal: 14),
            decoration: BoxDecoration(
              color: AppColors.greyLight,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppColors.border, width: 1),
            ),
            alignment: Alignment.center,
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.tune,
                  size: 16,
                  color: AppColors.textPrimary,
                ),
                SizedBox(width: 4),
                Text(
                  'Filter',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
