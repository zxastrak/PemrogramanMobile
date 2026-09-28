import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants/app_colors.dart';
import '../providers/staff_provider.dart';

class LogHistoryScreen extends StatelessWidget {
  const LogHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final staffProvider = context.watch<StaffProvider>();
    final logs = staffProvider.logs;

    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        title: const Text(
          'Log History',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        elevation: 0,
      ),
      body: logs.isEmpty
          ? const Center(
              child: Text('Belum ada riwayat aktivitas.'),
            )
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: logs.length,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final log = logs[index];
                return Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.borderLight, width: 1.2),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.03),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: _getTypeColor(log.type).withValues(alpha: 0.12),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          _getTypeIcon(log.type),
                          color: _getTypeColor(log.type),
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              log.title,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 3),
                            Text(
                              log.description,
                              style: const TextStyle(
                                fontSize: 12,
                                color: AppColors.textSecondary,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  log.staffName,
                                  style: const TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.primary,
                                  ),
                                ),
                                Text(
                                  _formatTime(log.timestamp),
                                  style: const TextStyle(
                                    fontSize: 10,
                                    color: AppColors.greyDark,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }

  Color _getTypeColor(String type) {
    switch (type) {
      case 'ATTENDANCE':
        return Colors.teal;
      case 'INVENTORY':
        return Colors.blue;
      case 'PLACEMENT':
        return Colors.orange;
      case 'TASK':
        return Colors.purple;
      default:
        return AppColors.primary;
    }
  }

  IconData _getTypeIcon(String type) {
    switch (type) {
      case 'ATTENDANCE':
        return Icons.fingerprint;
      case 'INVENTORY':
        return Icons.inventory_2;
      case 'PLACEMENT':
        return Icons.transfer_within_a_station;
      case 'TASK':
        return Icons.task_alt;
      default:
        return Icons.history;
    }
  }

  String _formatTime(DateTime time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final min = time.minute.toString().padLeft(2, '0');
    return '$hour:$min WIB';
  }
}
