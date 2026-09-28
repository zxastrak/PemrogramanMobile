import 'package:flutter/material.dart';
import '../models/log_model.dart';

class StaffMember {
  final String id;
  final String name;
  final String staffNo;
  final String role;
  String currentZone;

  StaffMember({
    required this.id,
    required this.name,
    required this.staffNo,
    required this.role,
    required this.currentZone,
  });
}

class StaffProvider with ChangeNotifier {
  final List<StaffMember> _staffList = [
    StaffMember(
      id: 'S01',
      name: 'Muhammad Rizky',
      staffNo: 'STF-2024-883',
      role: 'Warehouse Supervisor',
      currentZone: 'Zone A - Inbound',
    ),
    StaffMember(
      id: 'S02',
      name: 'Ahmad Fauzi',
      staffNo: 'STF-2024-884',
      role: 'Forklift Operator',
      currentZone: 'Zone B - Storage Rack',
    ),
    StaffMember(
      id: 'S03',
      name: 'Siti Rahmawati',
      staffNo: 'STF-2024-885',
      role: 'Quality Inspector',
      currentZone: 'Zone C - Outbound & Packing',
    ),
    StaffMember(
      id: 'S04',
      name: 'Budi Santoso',
      staffNo: 'STF-2024-886',
      role: 'Inventory Staf',
      currentZone: 'Zone A - Inbound',
    ),
  ];

  final List<ActivityLogModel> _logs = [
    ActivityLogModel(
      id: 'LOG-101',
      title: 'Absensi Masuk Shift Pagi',
      description: 'Scan QR Code di Gate Utama (WIB 07:15)',
      timestamp: DateTime.now().subtract(const Duration(minutes: 42)),
      staffName: 'Muhammad Rizky (STF-2024-883)',
      type: 'ATTENDANCE',
    ),
    ActivityLogModel(
      id: 'LOG-102',
      title: 'Barang Masuk Rak A-02',
      description: 'Forklift Hydraulic Pump sebanyak 120 unit',
      timestamp: DateTime.now().subtract(const Duration(hours: 1, minutes: 20)),
      staffName: 'Ahmad Fauzi (STF-2024-884)',
      type: 'INVENTORY',
    ),
    ActivityLogModel(
      id: 'LOG-103',
      title: 'Perubahan Penempatan Staf',
      description: 'Siti Rahmawati dipindahkan ke Zone C - Outbound',
      timestamp: DateTime.now().subtract(const Duration(hours: 2, minutes: 10)),
      staffName: 'Supervisor Admin',
      type: 'PLACEMENT',
    ),
    ActivityLogModel(
      id: 'LOG-104',
      title: 'Pemeriksaan Rak B-14',
      description: 'Stock opname Heavy Duty Pallet Wrap selesai',
      timestamp: DateTime.now().subtract(const Duration(hours: 3, minutes: 45)),
      staffName: 'Budi Santoso (STF-2024-886)',
      type: 'TASK',
    ),
  ];

  List<StaffMember> get staffList => [..._staffList];
  List<ActivityLogModel> get logs => [..._logs];

  final List<String> availableZones = [
    'Zone A - Inbound',
    'Zone B - Storage Rack',
    'Zone C - Outbound & Packing',
    'Zone D - Loading Dock',
  ];

  void updatePlacement(String staffId, String newZone) {
    final index = _staffList.indexWhere((s) => s.id == staffId);
    if (index != -1) {
      final oldZone = _staffList[index].currentZone;
      _staffList[index].currentZone = newZone;

      _logs.insert(
        0,
        ActivityLogModel(
          id: 'LOG-${DateTime.now().millisecondsSinceEpoch}',
          title: 'Penempatan Staf Diperbarui',
          description:
              '${_staffList[index].name} dialihkan dari $oldZone ke $newZone',
          timestamp: DateTime.now(),
          staffName: _staffList[index].name,
          type: 'PLACEMENT',
        ),
      );

      notifyListeners();
    }
  }

  void recordAttendance(String staffName, String staffNo, String zone) {
    _logs.insert(
      0,
      ActivityLogModel(
        id: 'LOG-${DateTime.now().millisecondsSinceEpoch}',
        title: 'Absensi QR Berhasil',
        description: 'Verifikasi kehadiran di $zone (Valid)',
        timestamp: DateTime.now(),
        staffName: '$staffName ($staffNo)',
        type: 'ATTENDANCE',
      ),
    );
    notifyListeners();
  }
}
