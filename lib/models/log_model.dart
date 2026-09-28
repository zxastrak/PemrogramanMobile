class ActivityLogModel {
  final String id;
  final String title;
  final String description;
  final DateTime timestamp;
  final String staffName;
  final String type;

  ActivityLogModel({
    required this.id,
    required this.title,
    required this.description,
    required this.timestamp,
    required this.staffName,
    required this.type,
  });
}
