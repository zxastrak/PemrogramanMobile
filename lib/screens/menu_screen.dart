import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants/app_colors.dart';
import '../providers/auth_provider.dart';
import '../providers/staff_provider.dart';
import '../widgets/qr_scanner_dialog.dart';
import 'login_screen.dart';
import 'log_history_screen.dart';
import 'staff_placement_screen.dart';

class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});

  void _showCustomizeProfileDialog(BuildContext context) {
    final auth = context.read<AuthProvider>();
    final user = auth.currentUser;
    if (user == null) return;

    final nameController = TextEditingController(text: user.name);
    final staffNoController = TextEditingController(text: user.staffNumber);
    final zoneController = TextEditingController(text: user.assignedZone);

    showDialog(
      context: context,
      builder: (dialogCtx) {
        return AlertDialog(
          backgroundColor: AppColors.surface,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Row(
            children: [
              Icon(Icons.edit_note, color: AppColors.primary),
              SizedBox(width: 8),
              Text(
                'Kustomisasi Profil',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: 'Nama Lengkap'),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: staffNoController,
                  decoration: const InputDecoration(labelText: 'No Staf'),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: zoneController,
                  decoration: const InputDecoration(labelText: 'Zona Penempatan'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogCtx),
              child: const Text('Batal', style: TextStyle(color: AppColors.greyDark)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
              onPressed: () {
                auth.updateProfile(
                  name: nameController.text.trim(),
                  staffNumber: staffNoController.text.trim(),
                  assignedZone: zoneController.text.trim(),
                );
                Navigator.pop(dialogCtx);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Profil berhasil diperbarui!'),
                    backgroundColor: AppColors.primary,
                  ),
                );
              },
              child: const Text('Simpan', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  void _showAttendanceQrScanner(BuildContext context) {
    final auth = context.read<AuthProvider>();
    final user = auth.currentUser;

    showDialog(
      context: context,
      builder: (dialogCtx) {
        return QrScannerDialog(
          title: 'QR Scanner Absensi',
          subtitle: 'Arahkan kamera ke QR Code di Pintu Masuk / Gate Gudang',
          onScanned: (code) {
            context.read<StaffProvider>().recordAttendance(
                  user?.name ?? 'Staf',
                  user?.staffNumber ?? 'STF-001',
                  user?.assignedZone ?? 'Zone A',
                );
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Absensi berhasil direkam! (Kode: $code)'),
                backgroundColor: AppColors.inBadge,
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final user = auth.currentUser;

    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [

              const SizedBox(height: 10),

              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.greyLight,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.border, width: 1.2),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [

                        Container(
                          width: 64,
                          height: 64,
                          decoration: BoxDecoration(
                            color: AppColors.greyMedium.withValues(alpha: 0.6),
                            shape: BoxShape.circle,
                            border: Border.all(color: AppColors.border, width: 1.5),
                          ),
                          alignment: Alignment.center,
                          child: const Text(
                            'Foto',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),

                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                user?.name ?? 'Nama',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                user?.staffNumber ?? 'No Staf',
                                style: const TextStyle(
                                  fontSize: 13,
                                  color: AppColors.textSecondary,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                user?.assignedZone ?? 'Zona Belum Diatur',
                                style: const TextStyle(
                                  fontSize: 11,
                                  color: AppColors.greyDark,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),

                    SizedBox(
                      width: double.infinity,
                      height: 40,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.surface,
                          foregroundColor: AppColors.textPrimary,
                          elevation: 0,
                          side: const BorderSide(color: AppColors.border),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: () => _showCustomizeProfileDialog(context),
                        child: const Text(
                          'Kustomisasi',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              _buildMenuCard(
                context: context,
                label: 'Penempatan Staf',
                icon: Icons.badge_outlined,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const StaffPlacementScreen(),
                    ),
                  );
                },
              ),
              const SizedBox(height: 14),

              _buildMenuCard(
                context: context,
                label: 'QR Scanner Absensi',
                icon: Icons.qr_code_scanner,
                onTap: () => _showAttendanceQrScanner(context),
              ),
              const SizedBox(height: 14),

              _buildMenuCard(
                context: context,
                label: 'Log History',
                icon: Icons.history,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LogHistoryScreen(),
                    ),
                  );
                },
              ),
              const SizedBox(height: 32),

              Center(
                child: TextButton.icon(
                  onPressed: () {
                    auth.logout();
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (context) => const LoginScreen()),
                      (route) => false,
                    );
                  },
                  icon: const Icon(Icons.logout, color: AppColors.outBadge, size: 18),
                  label: const Text(
                    'Keluar dari Akun',
                    style: TextStyle(
                      color: AppColors.outBadge,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuCard({
    required BuildContext context,
    required String label,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Container(
      height: 52,
      decoration: BoxDecoration(
        color: AppColors.greyLight,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.border, width: 1),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(icon, size: 20, color: AppColors.textPrimary),
                    const SizedBox(width: 12),
                    Text(
                      label,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
                const Icon(
                  Icons.arrow_forward_ios,
                  size: 14,
                  color: AppColors.greyDark,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
