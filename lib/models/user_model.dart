class UserModel {
  final String id;
  final String username;
  final String name;
  final String staffNumber;
  final String role;
  final String assignedZone;
  final String? photoUrl;

  UserModel({
    required this.id,
    required this.username,
    required this.name,
    required this.staffNumber,
    required this.role,
    required this.assignedZone,
    this.photoUrl,
  });

  UserModel copyWith({
    String? id,
    String? username,
    String? name,
    String? staffNumber,
    String? role,
    String? assignedZone,
    String? photoUrl,
  }) {
    return UserModel(
      id: id ?? this.id,
      username: username ?? this.username,
      name: name ?? this.name,
      staffNumber: staffNumber ?? this.staffNumber,
      role: role ?? this.role,
      assignedZone: assignedZone ?? this.assignedZone,
      photoUrl: photoUrl ?? this.photoUrl,
    );
  }
}
