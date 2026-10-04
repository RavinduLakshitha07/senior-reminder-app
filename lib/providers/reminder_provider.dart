import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import '../models/reminder.dart';
import '../services/storage_service.dart';
import '../services/notification_service.dart';

class ReminderProvider extends ChangeNotifier {
  final StorageService _storageService = StorageService();

  final List<Reminder> _reminders = [];

  List<Reminder> get reminders => List.unmodifiable(_reminders);

  bool _isLoading = true;

  bool get isLoading => _isLoading;

  ReminderProvider() {
    loadReminders();
  }

  Future<void> loadReminders() async {
    _isLoading = true;
    notifyListeners();

    final loadedReminders = await _storageService.loadReminders();

    _reminders
      ..clear()
      ..addAll(loadedReminders);

    _sortReminders();

    _isLoading = false;
    notifyListeners();
  }

  Future<void> addReminder({
    required String title,
    required DateTime dateTime,
    String sound = 'default.mp3',
    RepeatType repeat = RepeatType.none,
    ReminderCategory category = ReminderCategory.general,
  }) async {
    final reminder = Reminder(
      id: const Uuid().v4(),
      notificationId:
          DateTime.now().millisecondsSinceEpoch.remainder(1000000),
      title: title,
      dateTime: dateTime,
      sound: sound,
      repeat: repeat,
      category: category,
    );

    _reminders.add(reminder);
    _sortReminders();
    await _storageService.saveReminders(_reminders);

    if (reminder.isEnabled) {
      await NotificationService.instance.scheduleNotification(
        notificationId: reminder.notificationId,
        title: reminder.title,
        body: "It's time for your reminder.",
        dateTime: reminder.dateTime,
        sound: reminder.sound,
        repeat: reminder.repeat,
        category: reminder.category,
      );
    }

    notifyListeners();
  }

  Future<void> deleteReminder(String id) async {
    final reminder = _reminders.firstWhere(
      (item) => item.id == id,
    );

    await NotificationService.instance.cancelNotification(
      reminder.notificationId,
    );

    _reminders.removeWhere(
      (item) => item.id == id,
    );

    await _storageService.saveReminders(_reminders);
    notifyListeners();
  }

  Future<void> updateReminder(Reminder reminder) async {
    final index = _reminders.indexWhere(
      (item) => item.id == reminder.id,
    );

    if (index == -1) return;

    await NotificationService.instance.cancelNotification(
      reminder.notificationId,
    );

    _reminders[index] = reminder;
    _sortReminders();
    await _storageService.saveReminders(_reminders);

    if (reminder.isEnabled) {
      await NotificationService.instance.scheduleNotification(
        notificationId: reminder.notificationId,
        title: reminder.title,
        body: "It's time for your reminder.",
        dateTime: reminder.dateTime,
        sound: reminder.sound,
        repeat: reminder.repeat,
        category: reminder.category,
      );
    }

    notifyListeners();
  }

  Future<void> updateReminderDetails({
    required Reminder reminder,
    required String title,
    required DateTime dateTime,
    required String sound,
    required RepeatType repeat,
    required ReminderCategory category,
  }) async {
    final updatedReminder = reminder.copyWith(
      title: title,
      dateTime: dateTime,
      sound: sound,
      repeat: repeat,
      category: category,
    );

    await updateReminder(updatedReminder);
  }

  Future<void> toggleReminder(String id) async {
    final index = _reminders.indexWhere(
      (item) => item.id == id,
    );

    if (index == -1) return;

    final reminder = _reminders[index];
    final updatedReminder = reminder.copyWith(
      isEnabled: !reminder.isEnabled,
    );

    _reminders[index] = updatedReminder;
    await _storageService.saveReminders(_reminders);

    if (updatedReminder.isEnabled) {
      await NotificationService.instance.scheduleNotification(
        notificationId: updatedReminder.notificationId,
        title: updatedReminder.title,
        body: "It's time for your reminder.",
        dateTime: updatedReminder.dateTime,
        sound: updatedReminder.sound,
        repeat: updatedReminder.repeat,
        category: updatedReminder.category,
      );
    } else {
      await NotificationService.instance.cancelNotification(
        updatedReminder.notificationId,
      );
    }

    notifyListeners();
  }

  Future<void> clearAll() async {
    await NotificationService.instance.cancelAllNotifications();
    _reminders.clear();
    await _storageService.clearAll();
    notifyListeners();
  }

  void _sortReminders() {
    _reminders.sort(
      (a, b) => a.dateTime.compareTo(b.dateTime),
    );
  }
}
