import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/reminder.dart';
import '../models/reminder_history.dart';

class StorageService {
  static const String remindersKey = 'reminders';
  static const String historyKey = 'reminder_history';

  /// Save all reminders
  Future<void> saveReminders(List<Reminder> reminders) async {
    final prefs = await SharedPreferences.getInstance();

    final reminderList =
        reminders.map((reminder) => reminder.toMap()).toList();

    await prefs.setString(
      remindersKey,
      jsonEncode(reminderList),
    );
  }

  /// Load all reminders
  Future<List<Reminder>> loadReminders() async {
    final prefs = await SharedPreferences.getInstance();

    final jsonString = prefs.getString(remindersKey);

    if (jsonString == null) {
      return [];
    }

    final List<dynamic> decoded = jsonDecode(jsonString);

    return decoded
        .map(
          (item) => Reminder.fromMap(
            Map<String, dynamic>.from(item),
          ),
        )
        .toList();
  }

  /// Save reminder history
Future<void> saveHistory(
  List<ReminderHistory> history,
) async {
  final prefs = await SharedPreferences.getInstance();

  final historyList =
      history.map((item) => item.toMap()).toList();

  await prefs.setString(
    historyKey,
    jsonEncode(historyList),
  );
}

/// Load reminder history
Future<List<ReminderHistory>> loadHistory() async {
  final prefs = await SharedPreferences.getInstance();

  final jsonString = prefs.getString(historyKey);

  if (jsonString == null) {
    return [];
  }

  final List<dynamic> decoded = jsonDecode(jsonString);

  return decoded
      .map(
        (item) => ReminderHistory.fromMap(
          Map<String, dynamic>.from(item),
        ),
      )
      .toList();
}


  /// Delete everything (useful later)
  Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.remove(remindersKey);
    await prefs.remove(historyKey);
  }
}