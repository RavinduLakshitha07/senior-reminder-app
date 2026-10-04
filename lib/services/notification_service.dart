import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import '../main.dart';
import '../models/reminder.dart';
import '../screens/alarm_screen.dart';

class NotificationService {
  NotificationService._();

  static final NotificationService instance = NotificationService._();

  final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();

  FlutterLocalNotificationsPlugin get plugin => _notifications;

  Future<void> initialize() async {
    tz.initializeTimeZones();

    final String timeZoneName =
        await FlutterTimezone.getLocalTimezone();

    tz.setLocalLocation(tz.getLocation(timeZoneName));

    const androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const settings = InitializationSettings(
      android: androidSettings,
    );

    await _notifications.initialize(
      settings,
      onDidReceiveNotificationResponse:
          (NotificationResponse response) {
        final payload = response.payload;

        if (payload == null || payload.isEmpty) return;

        final parts = payload.split('|');

        final title = parts.isNotEmpty ? parts[0] : "Reminder";
        final sound = parts.length > 1 ? parts[1] : "default.mp3";
        final categoryStr = parts.length > 2 ? parts[2] : "general";
        final repeatStr = parts.length > 3 ? parts[3] : "none";

        final category = ReminderCategory.values.firstWhere(
          (e) => e.name == categoryStr,
          orElse: () => ReminderCategory.general,
        );

        final repeat = RepeatType.values.firstWhere(
          (e) => e.name == repeatStr,
          orElse: () => RepeatType.none,
        );

        navigatorKey.currentState?.push(
          MaterialPageRoute(
            builder: (_) => AlarmScreen(
              title: title,
              sound: sound,
              category: category,
              repeat: repeat,
            ),
          ),
        );
      },
    );

    await _notifications
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();

    await _notifications
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestExactAlarmsPermission();

    debugPrint("NotificationService initialized.");
  }

  Future<void> scheduleNotification({
    required int notificationId,
    required String title,
    required DateTime dateTime,
    required String body,
    String sound = "default.mp3",
    RepeatType repeat = RepeatType.none,
    ReminderCategory category = ReminderCategory.general,
  }) async {
    if (dateTime.isBefore(DateTime.now())) {
      debugPrint("Cannot schedule notification in the past.");
      return;
    }

    final scheduledDate = tz.TZDateTime.from(
      dateTime,
      tz.local,
    );

    DateTimeComponents? repeatComponent;

    switch (repeat) {
      case RepeatType.none:
        repeatComponent = null;
        break;

      case RepeatType.daily:
        repeatComponent = DateTimeComponents.time;
        break;

      case RepeatType.weekly:
        repeatComponent =
            DateTimeComponents.dayOfWeekAndTime;
        break;

      case RepeatType.monthly:
        repeatComponent = null;
        break;
    }

    await _notifications.zonedSchedule(
      notificationId,
      title,
      body,
      scheduledDate,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'reminder_channel',
          'Reminder Notifications',
          channelDescription:
              'Notifications for reminders',
          importance: Importance.max,
          priority: Priority.high,
        ),
      ),
      payload: '$title|$sound|${category.name}|${repeat.name}',
      androidScheduleMode:
          AndroidScheduleMode.exactAllowWhileIdle,
      matchDateTimeComponents: repeatComponent,
    );

    debugPrint(
      "Notification scheduled (${repeat.name})",
    );
  }

  Future<void> snoozeNotification({
    required String title,
    required String sound,
    required int minutes,
  }) async {
    final notificationId =
        DateTime.now().millisecondsSinceEpoch.remainder(1000000);

    final scheduledDate = tz.TZDateTime.now(
      tz.local,
    ).add(Duration(minutes: minutes));

    await _notifications.zonedSchedule(
      notificationId,
      title,
      "Snoozed Reminder",
      scheduledDate,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'reminder_channel',
          'Reminder Notifications',
          channelDescription: 'Notifications for reminders',
          importance: Importance.max,
          priority: Priority.high,
        ),
      ),
      payload: '$title|$sound|snoozed|none',
      androidScheduleMode:
          AndroidScheduleMode.exactAllowWhileIdle,
    );

    debugPrint(
      "Reminder snoozed for $minutes minute(s).",
    );
  }

  Future<void> cancelNotification(
    int notificationId,
  ) async {
    await _notifications.cancel(notificationId);
  }

  Future<void> cancelAllNotifications() async {
    await _notifications.cancelAll();
  }
}
