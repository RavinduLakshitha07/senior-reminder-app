import 'dart:convert';

enum ReminderStatus {
  completed,
  missed,
}

class ReminderHistory {
  final String id;
  final String title;
  final DateTime dateTime;
  final ReminderStatus status;

  ReminderHistory({
    required this.id,
    required this.title,
    required this.dateTime,
    required this.status,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'dateTime': dateTime.toIso8601String(),
      'status': status.name,
    };
  }

  factory ReminderHistory.fromMap(Map<String, dynamic> map) {
    return ReminderHistory(
      id: map['id'],
      title: map['title'],
      dateTime: DateTime.parse(map['dateTime']),
      status: ReminderStatus.values.firstWhere(
        (e) => e.name == map['status'],
      ),
    );
  }

  String toJson() => jsonEncode(toMap());

  factory ReminderHistory.fromJson(String source) =>
      ReminderHistory.fromMap(jsonDecode(source));
}