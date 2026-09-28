import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class QrScannerDialog extends StatefulWidget {
  final String title;
  final String subtitle;
  final Function(String scannedCode) onScanned;

  const QrScannerDialog({
    super.key,
    required this.title,
    required this.subtitle,
    required this.onScanned,
  });

  @override
  State<QrScannerDialog> createState() => _QrScannerDialogState();
}

class _QrScannerDialogState extends State<QrScannerDialog>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.2),
              blurRadius: 16,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                  color: AppColors.greyDark,
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              widget.subtitle,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 20),

            Container(
              height: 220,
              width: 220,
              decoration: BoxDecoration(
                color: AppColors.greyDarker,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [

                  Positioned.fill(
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.white38, width: 2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.qr_code_2,
                            size: 80,
                            color: Colors.white24,
                          ),
                        ),
                      ),
                    ),
                  ),

                  AnimatedBuilder(
                    animation: _animationController,
                    builder: (context, child) {
                      return Positioned(
                        top: 40 + (_animationController.value * 140),
                        left: 30,
                        right: 30,
                        child: Container(
                          height: 3,
                          decoration: BoxDecoration(
                            color: Colors.redAccent,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.redAccent.withValues(alpha: 0.8),
                                blurRadius: 8,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            const Text(
              'Simulasi Pemindaian Barcode / QR:',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              alignment: WrapAlignment.center,
              children: [
                _buildPresetButton('SKU-99023412 (Hydraulic)'),
                _buildPresetButton('ABSEN-STF-883 (Gate A)'),
                _buildPresetButton('RAK-A02 (Location)'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPresetButton(String code) {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.greyLight,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: const BorderSide(color: AppColors.border),
        ),
      ),
      icon: const Icon(Icons.qr_code_scanner, size: 16),
      label: Text(code, style: const TextStyle(fontSize: 11)),
      onPressed: () {
        widget.onScanned(code);
        Navigator.pop(context);
      },
    );
  }
}
