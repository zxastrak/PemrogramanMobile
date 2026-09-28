import 'package:flutter/material.dart';
import '../models/user_model.dart';

class AuthProvider with ChangeNotifier {
  UserModel? _currentUser;
  bool _isAuthenticated = false;
  String? _errorMessage;

  UserModel? get currentUser => _currentUser;
  bool get isAuthenticated => _isAuthenticated;
  String? get errorMessage => _errorMessage;

  AuthProvider() {

    _currentUser = UserModel(
      id: 'USR-01',
      username: 'admin',
      name: 'Muhammad Rizky Pratama',
      staffNumber: 'STF-2024-883',
      role: 'Warehouse Supervisor',
      assignedZone: 'Zone A - Inbound',
    );
  }

  bool login(String username, String password) {
    _errorMessage = null;

    if (username.trim().isEmpty || password.trim().isEmpty) {
      _errorMessage = 'Username dan Password tidak boleh kosong!';
      notifyListeners();
      return false;
    }

    _currentUser = UserModel(
      id: 'USR-01',
      username: username,
      name: username.toLowerCase() == 'admin'
          ? 'Muhammad Rizky Pratama'
          : 'Staff $username',
      staffNumber: 'STF-2024-883',
      role: 'Staff Gudang / Inventory Specialist',
      assignedZone: 'Zone A - Inbound',
    );

    _isAuthenticated = true;
    notifyListeners();
    return true;
  }

  void logout() {
    _isAuthenticated = false;
    notifyListeners();
  }

  void updateProfile({
    required String name,
    required String staffNumber,
    required String assignedZone,
  }) {
    if (_currentUser != null) {
      _currentUser = _currentUser!.copyWith(
        name: name,
        staffNumber: staffNumber,
        assignedZone: assignedZone,
      );
      notifyListeners();
    }
  }
}
