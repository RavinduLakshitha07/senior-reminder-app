import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/achievement_provider.dart';
import '../providers/history_provider.dart';
import '../providers/reminder_provider.dart';
import '../utils/app_sizes.dart';
import '../widgets/ui_helpers.dart';

class StatisticsScreen extends StatelessWidget {
  const StatisticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
return SafeArea(
      child: Consumer3<ReminderProvider, HistoryProvider, AchievementProvider>(
        builder: (context, reminderProvider, historyProvider, achievement, _) {
          final sizes = AppSizes(context);
          final pending = reminderProvider.reminders.length;
          final done = historyProvider.completedCount;
          final missed = historyProvider.missedCount;
          final total = pending + done + missed;
          final progress = total == 0 ? 0.0 : done / total;
          final percent = (progress * 100).round();

return ListView(
            padding: EdgeInsets.fromLTRB(
              sizes.mediumSpace,
              sizes.smallSpace,
              sizes.mediumSpace,
              sizes.largeIcon,
            ),
            children: [
              const ScreenTitle(title: 'Statistics'),

              // XP & Level Card
              _StatCard(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Level ${achievement.level}',
                              style: TextStyle(
                                fontSize: sizes.heading,
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFF1E293B),
                              ),
                            ),
                            SizedBox(height: sizes.smallSpace * 0.5),
                            Text(
                              '${achievement.xp} Total XP',
                              style: TextStyle(
                                fontSize: sizes.body,
                                color: const Color(0xFF64748B),
                              ),
                            ),
                          ],
                        ),
                        Container(
                          width: sizes.icon,
                          height: sizes.icon,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFF4CAF50), Color(0xFF2196F3)],
                            ),
                            borderRadius: BorderRadius.circular(sizes.radius * 0.7),
                          ),
                          child: Center(
                            child: Text(
                              _levelEmoji(achievement.level),
                              style: TextStyle(fontSize: sizes.icon),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: sizes.mediumSpace),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(sizes.smallSpace),
                      child: LinearProgressIndicator(
                        value: achievement.xpNeededForNextLevel > 0
                            ? achievement.xpInCurrentLevel /
                                achievement.xpNeededForNextLevel
                            : 0,
                        minHeight: sizes.smallSpace,
                        backgroundColor: const Color(0xFFE0E0E0),
                        valueColor: const AlwaysStoppedAnimation(
                          Color(0xFF4CAF50),
                        ),
                      ),
                    ),
                    SizedBox(height: sizes.smallSpace),
                    Text(
                      '${achievement.xpInCurrentLevel} / ${achievement.xpNeededForNextLevel} XP to next level',
                      style: TextStyle(
                        fontSize: sizes.caption * 0.75,
                        color: const Color(0xFF64748B),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: sizes.mediumSpace),

              // Streak Card
              _StatCard(
                child: Row(
                  children: [
                    Text('🔥', style: TextStyle(fontSize: sizes.heading)),
                    SizedBox(width: sizes.smallSpace),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${achievement.currentStreak} Day Streak',
                            style: TextStyle(
                              fontSize: sizes.body,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF1E293B),
                            ),
                          ),
                          SizedBox(height: sizes.smallSpace * 0.25),
                          Text(
                            'Best: ${achievement.bestStreak} days',
                            style: TextStyle(
                              fontSize: sizes.caption * 0.75,
                              color: const Color(0xFF64748B),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: sizes.smallSpace,
                        vertical: sizes.smallSpace * 0.5,
                      ),
                      decoration: BoxDecoration(
                        color: achievement.currentStreak >= 5
                            ? const Color(0xFFE8F5E9)
                            : const Color(0xFFF5F5F5),
                        borderRadius: BorderRadius.circular(sizes.caption),
                      ),
                      child: Text(
                        achievement.currentStreak >= 5
                            ? 'On Fire!'
                            : 'Keep Going',
                        style: TextStyle(
                          fontSize: sizes.caption * 0.75,
                          fontWeight: FontWeight.w600,
                          color: achievement.currentStreak >= 5
                              ? const Color(0xFF2E7D32)
                              : const Color(0xFF64748B),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: sizes.mediumSpace),

              // Completion Overview
              _StatCard(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Completion Overview',
                          style: TextStyle(
                            fontSize: sizes.body,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF1E293B),
                          ),
                        ),
                        Text(
                          '$percent%',
                          style: TextStyle(
                            fontSize: sizes.body,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF4CAF50),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: sizes.mediumSpace),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(sizes.smallSpace),
                      child: LinearProgressIndicator(
                        value: progress,
                        minHeight: sizes.smallSpace,
                        backgroundColor: const Color(0xFFE0E0E0),
                        valueColor: const AlwaysStoppedAnimation(
                          Color(0xFF4CAF50),
                        ),
                      ),
                    ),
                    SizedBox(height: sizes.mediumSpace),
                    Row(
                      children: [
                        _MiniStat(
                          color: const Color(0xFF2196F3),
                          value: total.toString(),
                          label: 'Total',
                        ),
                        SizedBox(width: sizes.smallSpace),
                        _MiniStat(
                          color: const Color(0xFF4CAF50),
                          value: done.toString(),
                          label: 'Done',
                        ),
                        SizedBox(width: sizes.smallSpace),
                        _MiniStat(
                          color: const Color(0xFFEF5350),
                          value: missed.toString(),
                          label: 'Missed',
                        ),
                        SizedBox(width: sizes.smallSpace),
                        _MiniStat(
                          color: const Color(0xFFFF9800),
                          value: pending.toString(),
                          label: 'Pending',
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              SizedBox(height: sizes.largeSpace),

              // Achievements Section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Achievements',
                    style: TextStyle(
                      fontSize: sizes.body,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF1E293B),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: sizes.smallSpace,
                      vertical: sizes.smallSpace * 0.5,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE8F5E9),
                      borderRadius: BorderRadius.circular(sizes.caption),
                    ),
                    child: Text(
                      '${achievement.unlockedBadgeCount}/${achievement.totalBadgeCount}',
                      style: TextStyle(
                        fontSize: sizes.caption * 0.75,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF2E7D32),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: sizes.smallSpace),
              GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 1.5,
                ),
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: achievement.badges.length,
                itemBuilder: (context, index) {
                  final badge = achievement.badges[index];
                  return _AchievementCard(
                    emoji: badge.emoji,
                    title: badge.title,
                    subtitle: badge.unlocked ? 'Unlocked!' : badge.description,
                    bgColor: badge.unlocked
                        ? badge.bgColor
                        : const Color(0xFFF5F5F5),
                    isLocked: !badge.unlocked,
                  );
                },
              ),
            ],
          );
        },
      ),
    );
  }

  String _levelEmoji(int level) {
    if (level <= 2) return '🌱';
    if (level <= 4) return '🌿';
    if (level <= 6) return '🌳';
    if (level <= 8) return '🏆';
    if (level <= 10) return '💎';
    return '👑';
  }
}

class _StatCard extends StatelessWidget {
  final Widget child;

  const _StatCard({required this.child});

  @override
  Widget build(BuildContext context) {
    final pad = MediaQuery.of(context).size.width < 360 ? 14.0 : 20.0;
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(pad),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A000000),
            blurRadius: 16,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }
}

class _MiniStat extends StatelessWidget {
  final Color color;
  final String value;
  final String label;

  const _MiniStat({
    required this.color,
    required this.value,
    required this.label,
  });

@override
  Widget build(BuildContext context) {
    final sizes = AppSizes(context);
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: sizes.smallSpace),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(sizes.radius * 0.7),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: TextStyle(
                fontSize: sizes.caption,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            SizedBox(height: sizes.smallSpace * 0.25),
            Text(
              label,
              style: TextStyle(
                fontSize: sizes.caption * 0.6,
                color: const Color(0xFF64748B),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AchievementCard extends StatelessWidget {
  final String emoji;
  final String title;
  final String subtitle;
  final Color bgColor;
  final bool isLocked;

  const _AchievementCard({
    required this.emoji,
    required this.title,
    required this.subtitle,
    required this.bgColor,
    this.isLocked = false,
  });

@override
  Widget build(BuildContext context) {
    final sizes = AppSizes(context);
    return Stack(
      children: [
        Container(
          padding: EdgeInsets.all(sizes.smallSpace),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(sizes.radius * 0.8),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                isLocked ? '🔒' : emoji,
                style: TextStyle(fontSize: sizes.smallIcon),
              ),
              SizedBox(height: sizes.smallSpace * 0.5),
              Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: sizes.caption * 0.75,
                  fontWeight: FontWeight.bold,
                  color: isLocked ? Colors.grey : const Color(0xFF1E293B),
                ),
              ),
              SizedBox(height: sizes.smallSpace * 0.25),
              Text(
                subtitle,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: sizes.caption * 0.6,
                  color: isLocked ? Colors.grey.shade400 : const Color(0xFF64748B),
                ),
              ),
            ],
          ),
        ),
        if (isLocked)
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.03),
                borderRadius: BorderRadius.circular(sizes.radius * 0.8),
              ),
            ),
          ),
      ],
    );
  }
}
