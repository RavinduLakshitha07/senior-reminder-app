import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../utils/app_sizes.dart';

/// Section header label used before card groups
class SectionLabel extends StatelessWidget {
  final String label;

  const SectionLabel({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    final sizes = AppSizes(context);
    return Padding(
      padding: EdgeInsets.only(left: 4, bottom: sizes.smallSpace),
      child: Text(
        label,
        style: TextStyle(
          fontSize: sizes.body,
          fontWeight: FontWeight.w600,
          color: AppColors.subtitle,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}

/// Screen title at the top of each page
class ScreenTitle extends StatelessWidget {
  final String title;

  const ScreenTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    final sizes = AppSizes(context);
    return Padding(
      padding: EdgeInsets.only(bottom: sizes.largeSpace),
      child: Text(
        title,
        style: TextStyle(
          fontSize: sizes.title,
          fontWeight: FontWeight.bold,
          color: AppColors.text,
          height: 1.2,
        ),
      ),
    );
  }
}

/// Helper category data for reminder category mapping
class CategoryHelper {
  final String emoji;
  final Color bgColor;
  final Color iconColor;
  final String label;

  const CategoryHelper({
    required this.emoji,
    required this.bgColor,
    required this.iconColor,
    required this.label,
  });

  static const medicine = CategoryHelper(
    emoji: '💊',
    bgColor: Color(0xFFFEE2E2),
    iconColor: Color(0xFFEF4444),
    label: 'Medicine',
  );

  static const water = CategoryHelper(
    emoji: '💧',
    bgColor: Color(0xFFDBEAFE),
    iconColor: Color(0xFF2563EB),
    label: 'Drink Water',
  );

  static const meal = CategoryHelper(
    emoji: '🍽',
    bgColor: Color(0xFFFEF3C7),
    iconColor: Color(0xFFF59E0B),
    label: 'Meal',
  );

  static const appointment = CategoryHelper(
    emoji: '🏥',
    bgColor: Color(0xFFF3E8FF),
    iconColor: Color(0xFF7B1FA2),
    label: 'Appointment',
  );

  static const general = CategoryHelper(
    emoji: '📌',
    bgColor: Color(0xFFD1FAE5),
    iconColor: Color(0xFF2E7D32),
    label: 'General',
  );

  static CategoryHelper forName(String name) {
    switch (name.toLowerCase()) {
      case 'medicine':
        return medicine;
      case 'water':
        return water;
      case 'meal':
        return meal;
      case 'appointment':
        return appointment;
      default:
        return general;
    }
  }

  static CategoryHelper forReminderCategory(String category) {
    switch (category) {
      case 'ReminderCategory.medicine':
        return medicine;
      case 'ReminderCategory.water':
        return water;
      case 'ReminderCategory.meal':
        return meal;
      case 'ReminderCategory.appointment':
        return appointment;
      default:
        return general;
    }
  }
}

/// Settings tile used in settings screen
class SettingsTile extends StatelessWidget {
  final String emoji;
  final String title;
  final String subtitle;
  final bool showDivider;
  final Widget? trailing;
  final VoidCallback? onTap;

  const SettingsTile({
    super.key,
    required this.emoji,
    required this.title,
    required this.subtitle,
    this.showDivider = true,
    this.trailing,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final sizes = AppSizes(context);
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(sizes.radius),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: sizes.smallSpace),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  width: sizes.icon,
                  height: sizes.icon,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(sizes.radius),
                  ),
                  child: Center(
                    child: Text(
                      emoji,
                      style: TextStyle(fontSize: sizes.smallIcon),
                    ),
                  ),
                ),
                SizedBox(width: sizes.smallSpace),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: sizes.body,
                          fontWeight: FontWeight.w600,
                          color: AppColors.text,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: sizes.caption,
                          color: AppColors.subtitle,
                        ),
                      ),
                    ],
                  ),
                ),
                if (trailing != null) trailing!,
                if (onTap != null && trailing == null)
                  Icon(
                    Icons.chevron_right_rounded,
                    color: AppColors.subtitle,
                    size: sizes.smallIcon,
                  ),
              ],
            ),
            if (showDivider)
              Padding(
                padding: EdgeInsets.only(top: sizes.smallSpace),
                child: const Divider(height: 1),
              ),
          ],
        ),
      ),
    );
  }
}

/// Settings card wrapper
class SettingsCard extends StatelessWidget {
  final Widget child;

  const SettingsCard({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final sizes = AppSizes(context);
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: sizes.cardPadding * 0.8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(sizes.radius),
        boxShadow: const [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 16,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }
}
