import 'dart:convert';

/// Defines how often a reminder repeats.
enum RepeatType {
  none,
  daily,
  weekly,
  monthly,
}

/// Types of reminders shown in the app.
enum ReminderCategory {
  general,
  medicine,
  water,
  meal,
  appointment,
}

class Reminder {
  final String id;

  // Used by flutter_local_notifications
  final int notificationId;

  final String title;
  final DateTime dateTime;
  final bool isEnabled;
  final String sound;

  /// New field
  final RepeatType repeat;
  final ReminderCategory category;

  Reminder({
    required this.id,
    required this.notificationId,
    required this.title,
    required this.dateTime,
    this.isEnabled = true,
    this.sound = 'default.mp3',
    this.repeat = RepeatType.none,
    this.category = ReminderCategory.general,
  });

  Reminder copyWith({
    String? id,
    int? notificationId,
    String? title,
    DateTime? dateTime,
    bool? isEnabled,
    String? sound,
    RepeatType? repeat,
    ReminderCategory? category,
  }) {
    return Reminder(
      id: id ?? this.id,
      notificationId: notificationId ?? this.notificationId,
      title: title ?? this.title,
      dateTime: dateTime ?? this.dateTime,
      isEnabled: isEnabled ?? this.isEnabled,
      sound: sound ?? this.sound,
      repeat: repeat ?? this.repeat,
      category: category ?? this.category,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'notificationId': notificationId,
      'title': title,
      'dateTime': dateTime.toIso8601String(),
      'isEnabled': isEnabled,
      'sound': sound,
      'repeat': repeat.name,
      'category': category.name,
    };
  }

  factory Reminder.fromMap(Map<String, dynamic> map) {
    return Reminder(
      id: map['id'] as String,
      notificationId:
          map['notificationId'] ??
              DateTime.now().millisecondsSinceEpoch.remainder(1000000),
      title: map['title'] as String,
      dateTime: DateTime.parse(map['dateTime'] as String),
      isEnabled: map['isEnabled'] as bool,
      sound: map['sound'] as String,
      repeat: RepeatType.values.firstWhere(
        (e) => e.name == (map['repeat'] ?? 'none'),
        orElse: () => RepeatType.none,
      ),
      category: ReminderCategory.values.firstWhere(
        (e) => e.name == (map['category'] ?? 'general'),
        orElse: () => ReminderCategory.general,
      ),
    );
  }

  String toJson() => jsonEncode(toMap());

  factory Reminder.fromJson(String source) =>
      Reminder.fromMap(jsonDecode(source));

  @override
  String toString() {
    return 'Reminder(id: $id, notificationId: $notificationId, title: $title, dateTime: $dateTime, repeat: ${repeat.name})category: ${category.name}';
  }
}

extension ReminderCategoryExtension on ReminderCategory {
  String get displayName {
    switch (this) {
      case ReminderCategory.medicine:
        return 'Medication';
      case ReminderCategory.water:
        return 'Drink Water';
      case ReminderCategory.meal:
        return 'Meal';
      case ReminderCategory.appointment:
        return 'Appointment';
      case ReminderCategory.general:
        return 'General';
    }
  }

  String get emoji {
    switch (this) {
      case ReminderCategory.medicine:
        return '💊';
      case ReminderCategory.water:
        return '💧';
      case ReminderCategory.meal:
        return '🍽';
      case ReminderCategory.appointment:
        return '🏥';
      case ReminderCategory.general:
        return '📌';
    }
  }
}

extension RepeatTypeExtension on RepeatType {
  String get label {
    switch (this) {
      case RepeatType.none:
        return 'Once';
      case RepeatType.daily:
        return 'Daily';
      case RepeatType.weekly:
        return 'Weekly';
      case RepeatType.monthly:
        return 'Monthly';
    }
  }
}
