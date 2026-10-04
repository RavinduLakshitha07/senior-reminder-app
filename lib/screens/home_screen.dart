import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'add_reminder_screen.dart';

import '../models/reminder.dart';
import '../providers/history_provider.dart';
import '../providers/reminder_provider.dart';
import '../theme/app_colors.dart';
import '../utils/app_sizes.dart';
import '../widgets/animated_progress.dart';
import '../widgets/category_card.dart';
import '../widgets/home_reminder_card.dart';
import '../widgets/premium_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  IconData _getCategoryIcon(ReminderCategory category) {
    switch (category) {
      case ReminderCategory.medicine:
        return Icons.medication_rounded;
      case ReminderCategory.water:
        return Icons.water_drop_rounded;
      case ReminderCategory.meal:
        return Icons.restaurant_rounded;
      case ReminderCategory.appointment:
        return Icons.local_hospital_rounded;
      case ReminderCategory.general:
        return Icons.notifications_active_rounded;
    }
  }

  Color _getCategoryColor(ReminderCategory category) {
    switch (category) {
      case ReminderCategory.medicine:
        return const Color(0xFFEF4444);
      case ReminderCategory.water:
        return AppColors.medicalBlue;
      case ReminderCategory.meal:
        return AppColors.amber;
      case ReminderCategory.appointment:
        return const Color(0xFF7B1FA2);
      case ReminderCategory.general:
        return AppColors.primary;
    }
  }

  String _getCategoryName(ReminderCategory category) {
    switch (category) {
      case ReminderCategory.medicine:
        return 'Medicine';
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

  @override
  Widget build(BuildContext context) {
return SafeArea(
      child: Consumer2<ReminderProvider, HistoryProvider>(
        builder: (context, provider, historyProvider, child) {
          final sizes = AppSizes(context);
          final total = provider.reminders.length +
              historyProvider.completedCount +
              historyProvider.missedCount;

          final done = historyProvider.completedCount;
          final missed = historyProvider.missedCount;
          final pending = provider.reminders.length;

          final progress = total == 0 ? 0.0 : done / total;
          final percent = (progress * 100).round();

          // Greeting based on time of day
          final hour = DateTime.now().hour;
          String greeting;
          String greetingEmoji;
          if (hour < 12) {
            greeting = 'Good Morning';
            greetingEmoji = '🌅';
          } else if (hour < 17) {
            greeting = 'Good Afternoon';
            greetingEmoji = '☀️';
          } else {
            greeting = 'Good Evening';
            greetingEmoji = '🌙';
          }

return ListView(
            padding: EdgeInsets.fromLTRB(
              sizes.mediumSpace,
              sizes.smallSpace,
              sizes.mediumSpace,
              sizes.largeIcon,
            ),
            children: [
              // ==========================
              // Greeting Section
              // ==========================
              Padding(
                padding: EdgeInsets.only(bottom: sizes.smallSpace),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '$greeting $greetingEmoji',
                      style: TextStyle(
                        fontSize: sizes.body,
                        color: AppColors.subtitle,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: sizes.smallSpace * 0.7),
                    Text(
                      'Welcome back',
                      style: TextStyle(
                        fontSize: sizes.title,
                        fontWeight: FontWeight.bold,
                        color: AppColors.text,
                        height: 1.2,
                      ),
                    ),
                    SizedBox(height: sizes.smallSpace * 0.5),
                    Text(
                      'You have $pending reminder${pending == 1 ? '' : 's'} today.',
                      style: TextStyle(
                        fontSize: sizes.body,
                        color: AppColors.subtitle,
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: sizes.largeSpace),

              // ==========================
              // Today's Overview Card
              // ==========================
              PremiumCard(
                child: Row(
                  children: [
                    // Circular progress
                    Flexible(
                      flex: 0,
                      child: AnimatedCircularProgress(
                        progress: progress,
                        size: sizes.largeIcon,
                        strokeWidth: sizes.smallSpace,
                        centerWidget: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              '$percent%',
                              style: TextStyle(
                                fontSize: sizes.body,
                                fontWeight: FontWeight.bold,
                                color: AppColors.text,
                              ),
                            ),
                            Text(
                              'Done',
                              style: TextStyle(
                                fontSize: sizes.caption,
                                color: AppColors.subtitle,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(width: sizes.mediumSpace),

                    // Stats
                    Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _StatRow(
                            label: "Today",
                            value: total.toString(),
                            color: AppColors.medicalBlue,
                          ),
                          SizedBox(height: sizes.smallSpace * 0.7),
                          _StatRow(
                            label: 'Done',
                            value: done.toString(),
                            color: AppColors.primary,
                          ),
                          SizedBox(height: sizes.smallSpace * 0.7),
                          _StatRow(
                            label: 'Pending',
                            value: pending.toString(),
                            color: AppColors.amber,
                          ),
                          SizedBox(height: sizes.smallSpace * 0.7),
                          _StatRow(
                            label: 'Missed',
                            value: missed.toString(),
                            color: AppColors.error,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: sizes.largeSpace),

              // ==========================
              // Categories Section
              // ==========================
              Text(
                'Categories',
                style: TextStyle(
                  fontSize: sizes.heading,
                  fontWeight: FontWeight.bold,
                  color: AppColors.text,
                ),
              ),
              SizedBox(height: sizes.mediumSpace),

              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    CategoryCard(
                      icon: Icons.medication_rounded,
                      color: const Color(0xFFEF4444),
                      title: 'Medication',
                    ),
                    const SizedBox(width: 14),
                    CategoryCard(
                      icon: Icons.local_hospital_rounded,
                      color: const Color(0xFF7B1FA2),
                      title: 'Doctor',
                    ),
                    const SizedBox(width: 14),
                    CategoryCard(
                      icon: Icons.restaurant_rounded,
                      color: AppColors.amber,
                      title: 'Meal',
                    ),
                    const SizedBox(width: 14),
                    CategoryCard(
                      icon: Icons.fitness_center_rounded,
                      color: AppColors.medicalBlue,
                      title: 'Exercise',
                    ),
                    const SizedBox(width: 14),
                    CategoryCard(
                      icon: Icons.favorite_rounded,
                      color: AppColors.primary,
                      title: 'Health',
                    ),
                    const SizedBox(width: 14),
                    CategoryCard(
                      icon: Icons.more_horiz_rounded,
                      color: AppColors.subtitle,
                      title: 'Other',
                    ),
                  ],
                ),
              ),

SizedBox(height: sizes.largeSpace),

              // ==========================
              // Upcoming Reminders
              // ==========================
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Upcoming Reminders',
                    style: TextStyle(
                      fontSize: sizes.heading,
                      fontWeight: FontWeight.bold,
                      color: AppColors.text,
                    ),
                  ),
                  if (provider.reminders.isNotEmpty)
                    Text(
                      '${provider.reminders.length} total',
                      style: TextStyle(
                        fontSize: sizes.caption,
                        color: AppColors.subtitle,
                      ),
                    ),
                ],
              ),
              SizedBox(height: sizes.mediumSpace),

              if (provider.reminders.isEmpty)
                PremiumCard(
                  child: SizedBox(
                    width: double.infinity,
                    child: Column(
                      children: [
                        SizedBox(height: sizes.mediumSpace),
                        Container(
                          width: sizes.icon,
                          height: sizes.icon,
                          decoration: BoxDecoration(
                            color: AppColors.secondaryBackground,
                            borderRadius: BorderRadius.circular(sizes.radius),
                          ),
                          child: Icon(
                            Icons.notifications_none_rounded,
                            size: sizes.smallIcon,
                            color: AppColors.medicalBlue,
                          ),
                        ),
                        SizedBox(height: sizes.mediumSpace),
                        Text(
                          'No reminders yet',
                          style: TextStyle(
                            fontSize: sizes.heading,
                            fontWeight: FontWeight.w600,
                            color: AppColors.text,
                          ),
                        ),
                        SizedBox(height: sizes.smallSpace),
                        Text(
                          'Tap + to add your first reminder',
                          style: TextStyle(
                            fontSize: sizes.body,
                            color: AppColors.subtitle,
                          ),
                        ),
                        SizedBox(height: sizes.largeSpace),
                      ],
                    ),
                  ),
                )
              else
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: provider.reminders.length,
                  itemBuilder: (context, index) {
                    final reminder = provider.reminders[index];
                    final icon = _getCategoryIcon(reminder.category);
                    final iconColor = _getCategoryColor(reminder.category);
                    final categoryName = _getCategoryName(reminder.category);

                    return HomeReminderCard(
                      reminder: reminder,
                      icon: icon,
                      iconColor: iconColor,
                      categoryName: categoryName,
                      onTap: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                AddReminderScreen(reminder: reminder),
                          ),
                        );
                        if (context.mounted) {
                          context.read<ReminderProvider>().loadReminders();
                        }
                      },
                      onToggle: (_) {
                        provider.toggleReminder(reminder.id);
                      },
                      onDelete: () async {
                        final confirm = await showDialog<bool>(
                          context: context,
                          builder: (_) => AlertDialog(
                            title: const Text('Delete Reminder'),
                            content: Text(
                              "Are you sure you want to delete '${reminder.title}'?",
                            ),
                            actions: [
                              TextButton(
                                onPressed: () =>
                                    Navigator.pop(context, false),
                                child: const Text('Cancel'),
                              ),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.error,
                                ),
                                onPressed: () =>
                                    Navigator.pop(context, true),
                                child: const Text(
                                  'Delete',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                        );
                        if (confirm == true) {
                          provider.deleteReminder(reminder.id);
                        }
                      },
                    );
                  },
                ),
            ],
          );
        },
      ),
    );
  }
}

class _StatRow extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _StatRow({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final sizes = AppSizes(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: sizes.caption,
            color: AppColors.text,
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: sizes.smallSpace,
            vertical: sizes.smallSpace * 0.4,
          ),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(sizes.radius * 0.5),
          ),
          child: Text(
            value,
            style: TextStyle(
              fontSize: sizes.caption,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ),
      ],
    );
  }
}
