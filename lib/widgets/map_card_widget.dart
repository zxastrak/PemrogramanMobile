import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class MapCardWidget extends StatefulWidget {
  const MapCardWidget({super.key});

  @override
  State<MapCardWidget> createState() => _MapCardWidgetState();
}

class _MapCardWidgetState extends State<MapCardWidget> {
  String _selectedZone = 'Semua Zona';

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 180,
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.greyDark,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          children: [

            Positioned.fill(
              child: CustomPaint(
                painter: _WarehouseGridPainter(),
              ),
            ),

            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'MAP',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 4.0,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.18),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      'Zona Aktif: $_selectedZone',
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Positioned(
              top: 14,
              left: 14,
              child: _buildZoneBadge(
                'Rak A (Inbound)',
                '12 Rak Terisi',
                AppColors.sage,
              ),
            ),

            Positioned(
              top: 14,
              right: 14,
              child: _buildZoneBadge(
                'Rak B (Storage)',
                '8 Rak Terisi',
                AppColors.coral,
              ),
            ),

            Positioned(
              bottom: 14,
              left: 14,
              child: _buildZoneBadge(
                'Rak C (Outbound)',
                '4 Rak Menunggu',
                AppColors.crimson,
              ),
            ),

            Positioned(
              bottom: 14,
              right: 14,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.black45,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.wifi_tethering, size: 12, color: AppColors.sage),
                    SizedBox(width: 4),
                    Text(
                      'Live GPS Tracking',
                      style: TextStyle(color: Colors.white70, fontSize: 10),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildZoneBadge(String title, String subtitle, Color dotColor) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedZone = title;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Menampilkan denah $title'),
            duration: const Duration(seconds: 1),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.4),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.white24, width: 0.8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: dotColor,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 6),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  subtitle,
                  style: const TextStyle(
                    color: Colors.white60,
                    fontSize: 9,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _WarehouseGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.06)
      ..strokeWidth = 1.0;

    const step = 20.0;
    for (double x = 0; x < size.width; x += step) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = 0; y < size.height; y += step) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }

    final aislePaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.08)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(20, 20, size.width * 0.4, 50),
        const Radius.circular(6),
      ),
      aislePaint,
    );

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(size.width * 0.55, 20, size.width * 0.4, 50),
        const Radius.circular(6),
      ),
      aislePaint,
    );

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(20, 100, size.width * 0.45, 55),
        const Radius.circular(6),
      ),
      aislePaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
