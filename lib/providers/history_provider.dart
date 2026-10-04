import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import '../models/reminder_history.dart';
import '../services/storage_service.dart';
import 'achievement_provider.dart';

class HistoryProvider extends ChangeNotifier {
  final StorageService _storageService = StorageService();

  final List<ReminderHistory> _history = [];

  List<ReminderHistory> get history =>
      List.unmodifiable(_history);

  bool _isLoading = true;

  bool get isLoading => _isLoading;

  HistoryProvider() {
    loadHistory();
  }

  Future<void> loadHistory() async {
    _isLoading = true;
    notifyListeners();

    final loaded =
        await _storageService.loadHistory();

    _history
      ..clear()
      ..addAll(loaded);

    _history.sort(
      (a, b) => b.dateTime.compareTo(a.dateTime),
    );

    _isLoading = false;
    notifyListeners();
  }

  Future<void> addHistory({
    required String title,
    required DateTime dateTime,
    required ReminderStatus status,
    String? category,
    AchievementProvider? achievementProvider,
  }) async {
    final item = ReminderHistory(
      id: const Uuid().v4(),
      title: title,
      dateTime: dateTime,
      status: status,
    );

    _history.insert(0, item);

    await _storageService.saveHistory(_history);

    // Award XP when a reminder is completed
    if (status == ReminderStatus.completed && achievementProvider != null) {
      final today = DateTime.now();
      final todayStart = DateTime(today.year, today.month, today.day);
      final todayEnd = todayStart.add(const Duration(days: 1));

      final todayCompleted = _history.where((h) =>
        h.status == ReminderStatus.completed &&
        h.dateTime.isAfter(todayStart) &&
        h.dateTime.isBefore(todayEnd)
      ).length;

      await achievementProvider.onReminderCompleted(
        xpAward: 10,
        category: category,
        totalCompleted: completedCount,
        todayCompleted: todayCompleted,
        todayTotal: todayCompleted, // simplified
      );
    }

    notifyListeners();
  }

  int get completedCount =>
      _history.where(
        (e) => e.status == ReminderStatus.completed,
      ).length;

  int get missedCount =>
      _history.where(
        (e) => e.status == ReminderStatus.missed,
      ).length;

  Future<void> deleteItem(String id) async {
    _history.removeWhere((e) => e.id == id);
    await _storageService.saveHistory(_history);
    notifyListeners();
  }

  Future<void> clearHistory() async {
    _history.clear();

    await _storageService.saveHistory([]);

    notifyListeners();
  }
}
