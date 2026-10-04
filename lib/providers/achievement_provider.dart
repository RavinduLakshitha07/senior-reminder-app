import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Badge {
  final String id;
  final String emoji;
  final String title;
  final String description;
  final Color bgColor;
  bool unlocked;
  DateTime? unlockedAt;

  Badge({
    required this.id,
    required this.emoji,
    required this.title,
    required this.description,
    required this.bgColor,
    this.unlocked = false,
    this.unlockedAt,
  });
}

class AchievementProvider extends ChangeNotifier {
  static const _xpKey = 'user_xp';
  static const _streakKey = 'current_streak';
  static const _bestStreakKey = 'best_streak';
  static const _lastCompleteDateKey = 'last_complete_date';
  static const _badgesKey = 'unlocked_badges';

  int _xp = 0;
  int _currentStreak = 0;
  int _bestStreak = 0;
  DateTime? _lastCompleteDate;

  late List<Badge> _badges;

  int get xp => _xp;
  int get level => _calculateLevel(_xp);
  int get currentStreak => _currentStreak;
  int get bestStreak => _bestStreak;
  int get xpForNextLevel => _xpForLevel(level + 1);
  int get xpInCurrentLevel => _xp - _xpForLevel(level);
  int get xpNeededForNextLevel => _xpForLevel(level + 1) - _xpForLevel(level);
  List<Badge> get badges => List.unmodifiable(_badges);
  List<Badge> get unlockedBadges => _badges.where((b) => b.unlocked).toList();
  int get unlockedBadgeCount => _badges.where((b) => b.unlocked).length;
  int get totalBadgeCount => _badges.length;

  AchievementProvider() {
    _initBadges();
  }

  void _initBadges() {
    _badges = [
      Badge(
        id: 'first_complete',
        emoji: '🎯',
        title: 'First Step',
        description: 'Complete your first reminder',
        bgColor: const Color(0xFFE8F5E9),
      ),
      Badge(
        id: 'streak_5',
        emoji: '🔥',
        title: '5-Day Streak',
        description: 'Complete reminders 5 days in a row',
        bgColor: const Color(0xFFFFF9C4),
      ),
      Badge(
        id: 'streak_7',
        emoji: '⭐',
        title: 'Perfect Week',
        description: 'Complete reminders 7 days in a row',
        bgColor: const Color(0xFFFFF3E0),
      ),
      Badge(
        id: 'streak_30',
        emoji: '💪',
        title: 'Monthly Master',
        description: 'Complete reminders 30 days in a row',
        bgColor: const Color(0xFFE3F2FD),
      ),
      Badge(
        id: 'med_master',
        emoji: '💊',
        title: 'Med Master',
        description: 'Complete 30 medicine reminders',
        bgColor: const Color(0xFFE3F2FD),
      ),
      Badge(
        id: 'health_hero',
        emoji: '❤️',
        title: 'Health Hero',
        description: 'Complete 50 total reminders',
        bgColor: const Color(0xFFFFEBEE),
      ),
      Badge(
        id: 'water_drinker',
        emoji: '💧',
        title: 'Hydrated',
        description: 'Complete 20 water reminders',
        bgColor: const Color(0xFFE0F7FA),
      ),
      Badge(
        id: 'xp_100',
        emoji: '🏅',
        title: 'Bronze Medal',
        description: 'Earn 100 XP',
        bgColor: const Color(0xFFF5F5F5),
      ),
      Badge(
        id: 'xp_500',
        emoji: '🥈',
        title: 'Silver Medal',
        description: 'Earn 500 XP',
        bgColor: const Color(0xFFECEFF1),
      ),
      Badge(
        id: 'xp_1000',
        emoji: '🥇',
        title: 'Gold Medal',
        description: 'Earn 1,000 XP',
        bgColor: const Color(0xFFFFF8E1),
      ),
      Badge(
        id: 'perfect_day',
        emoji: '🌟',
        title: 'Perfect Day',
        description: 'Complete all reminders for a day',
        bgColor: const Color(0xFFE8F5E9),
      ),
      Badge(
        id: 'level_5',
        emoji: '🚀',
        title: 'Level 5',
        description: 'Reach level 5',
        bgColor: const Color(0xFFF3E5F5),
      ),
      Badge(
        id: 'level_10',
        emoji: '💎',
        title: 'Diamond',
        description: 'Reach level 10',
        bgColor: const Color(0xFFE0F7FA),
      ),
    ];
  }

  int _calculateLevel(int xp) {
    // Level 1 at 0 XP, Level 2 at 50, Level 3 at 150, etc.
    // Formula: level_n_xp = 50 * n * (n - 1) / 2
    int level = 1;
    while (_xpForLevel(level + 1) <= xp) {
      level++;
    }
    return level;
  }

  int _xpForLevel(int level) {
    // XP needed to reach a given level: 50 * level * (level - 1) / 2
    return 50 * level * (level - 1) ~/ 2;
  }

  Future<void> loadProgress() async {
    final prefs = await SharedPreferences.getInstance();

    _xp = prefs.getInt(_xpKey) ?? 0;
    _currentStreak = prefs.getInt(_streakKey) ?? 0;
    _bestStreak = prefs.getInt(_bestStreakKey) ?? 0;

    final lastDateStr = prefs.getString(_lastCompleteDateKey);
    if (lastDateStr != null) {
      _lastCompleteDate = DateTime.tryParse(lastDateStr);
    }

    final unlockedIds = prefs.getStringList(_badgesKey) ?? [];
    for (final badge in _badges) {
      badge.unlocked = unlockedIds.contains(badge.id);
    }

    notifyListeners();
  }

  Future<void> _saveProgress() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_xpKey, _xp);
    await prefs.setInt(_streakKey, _currentStreak);
    await prefs.setInt(_bestStreakKey, _bestStreak);

    if (_lastCompleteDate != null) {
      await prefs.setString(
        _lastCompleteDateKey,
        _lastCompleteDate!.toIso8601String(),
      );
    }

    final unlockedIds = _badges
        .where((b) => b.unlocked)
        .map((b) => b.id)
        .toList();
    await prefs.setStringList(_badgesKey, unlockedIds);
  }

  /// Called when a reminder is completed. Awards XP and updates streak.
  Future<void> onReminderCompleted({
    int xpAward = 10,
    String? category,
    int totalCompleted = 0,
    int todayCompleted = 0,
    int todayTotal = 0,
  }) async {
    _xp += xpAward;

    // Update streak
    final today = DateTime.now();
    final todayDate = DateTime(today.year, today.month, today.day);

    if (_lastCompleteDate != null) {
      final lastDate = DateTime(
        _lastCompleteDate!.year,
        _lastCompleteDate!.month,
        _lastCompleteDate!.day,
      );
      final diff = todayDate.difference(lastDate).inDays;

      if (diff == 1) {
        _currentStreak++;
      } else if (diff > 1) {
        _currentStreak = 1; // reset streak
      }
      // if diff == 0, same day, don't increment streak
    } else {
      _currentStreak = 1;
    }

    _lastCompleteDate = todayDate;

    if (_currentStreak > _bestStreak) {
      _bestStreak = _currentStreak;
    }

    // Check badge unlocks
    _checkBadgeUnlocks(
      category: category,
      totalCompleted: totalCompleted,
      todayCompleted: todayCompleted,
      todayTotal: todayTotal,
    );

    await _saveProgress();
    notifyListeners();
  }

  void _checkBadgeUnlocks({
    String? category,
    int totalCompleted = 0,
    int todayCompleted = 0,
    int todayTotal = 0,
  }) {
    _unlockIf('first_complete', totalCompleted >= 1);
    _unlockIf('streak_5', _currentStreak >= 5);
    _unlockIf('streak_7', _currentStreak >= 7);
    _unlockIf('streak_30', _currentStreak >= 30);
    _unlockIf('med_master', category == 'medicine' && totalCompleted >= 30);
    _unlockIf('water_drinker', category == 'water' && totalCompleted >= 20);
    _unlockIf('health_hero', totalCompleted >= 50);
    _unlockIf('xp_100', _xp >= 100);
    _unlockIf('xp_500', _xp >= 500);
    _unlockIf('xp_1000', _xp >= 1000);
    _unlockIf('level_5', level >= 5);
    _unlockIf('level_10', level >= 10);
    _unlockIf('perfect_day', todayTotal > 0 && todayCompleted >= todayTotal);
  }

  void _unlockIf(String badgeId, bool condition) {
    if (!condition) return;
    final badge = _badges.where((b) => b.id == badgeId).firstOrNull;
    if (badge != null && !badge.unlocked) {
      badge.unlocked = true;
      badge.unlockedAt = DateTime.now();
    }
  }
}

