import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../models/task_model.dart';

class TaskCardWidget extends StatelessWidget {
  final TaskModel task;
  final VoidCallback onToggle;
  final VoidCallback? onDelete;

  const TaskCardWidget({
    super.key,
    required this.task,
    required this.onToggle,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final bool isIn = task.type == TaskType.inBound;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: task.isCompleted ? const Color(0xFFF0F4F8) : AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: task.isCompleted ? AppColors.greyLight : AppColors.border,
          width: 1,
        ),
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
          borderRadius: BorderRadius.circular(12),
          onTap: onToggle,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            child: Row(
              children: [

                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.greyLight,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppColors.border, width: 0.8),
                  ),
                  child: Text(
                    task.rack,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: task.isCompleted ? AppColors.greyDark : AppColors.textPrimary,
                    ),
                  ),
                ),
                const SizedBox(width: 12),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        task.itemName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          decoration:
                              task.isCompleted ? TextDecoration.lineThrough : null,
                          color: task.isCompleted
                              ? AppColors.greyDark
                              : AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Row(
                        children: [
                          Text(
                            'Qty : ${task.quantity}',
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                              color: AppColors.textSecondary,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Flexible(
                            child: Text(
                              task.sku,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 10,
                                color: AppColors.greyDark.withValues(alpha: 0.8),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),

                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: isIn
                        ? AppColors.inBadge.withValues(alpha: 0.12)
                        : AppColors.outBadge.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(
                      color: isIn ? AppColors.inBadge : AppColors.outBadge,
                      width: 1,
                    ),
                  ),
                  child: Text(
                    task.typeLabel,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: isIn ? AppColors.inBadge : AppColors.outBadge,
                    ),
                  ),
                ),
                const SizedBox(width: 6),

                Checkbox(
                  value: task.isCompleted,
                  onChanged: (val) => onToggle(),
                  activeColor: AppColors.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
