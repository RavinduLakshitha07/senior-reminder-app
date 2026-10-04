import '../models/reminder.dart';

class RepeatHelper {
  /// Returns the next reminder date based on the repeat type.
  static DateTime getNextReminderDate(
    DateTime current,
    RepeatType repeat,
  ) {
    switch (repeat) {
      case RepeatType.none:
        return current;

      case RepeatType.daily:
        return current.add(const Duration(days: 1));

      case RepeatType.weekly:
        return current.add(const Duration(days: 7));

      case RepeatType.monthly:
        return DateTime(
          current.year,
          current.month + 1,
          current.day,
          current.hour,
          current.minute,
          current.second,
        );
    }
  }

  /// Returns true if this reminder should repeat.
  static bool isRepeating(RepeatType repeat) {
    return repeat != RepeatType.none;
  }
}