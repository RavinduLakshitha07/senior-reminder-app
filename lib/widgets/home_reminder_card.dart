import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/reminder.dart';
import '../theme/app_colors.dart';
import '../utils/app_sizes.dart';

class HomeReminderCard extends StatefulWidget {
  final Reminder reminder;
  final IconData icon;
  final Color iconColor;
  final String categoryName;
  final VoidCallback onTap;
  final ValueChanged<bool> onToggle;
  final VoidCallback onDelete;

  const HomeReminderCard({
    super.key,
    required this.reminder,
    required this.icon,
    required this.iconColor,
    required this.categoryName,
    required this.onTap,
    required this.onToggle,
    required this.onDelete,
  });

  @override
  State<HomeReminderCard> createState() => _HomeReminderCardState();
}

class _HomeReminderCardState extends State<HomeReminderCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _scaleAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutBack,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final sizes = AppSizes(context);

    return GestureDetector(
      onTap: () {
        _controller.forward(from: 0);
        Future.delayed(const Duration(milliseconds: 150), widget.onTap);
      },
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: 1.0 - (_scaleAnimation.value * 0.02),
            child: child,
          );
        },
        child: Container(
          margin: EdgeInsets.only(bottom: sizes.mediumSpace),
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
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(sizes.radius),
                border: const Border(
                  left: BorderSide(
                    color: AppColors.primary,
                    width: 4,
                  ),
                ),
              ),
              child: Padding(
                padding: EdgeInsets.all(sizes.containerPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header row
                    Row(
                      children: [
                        Container(
                          width: sizes.icon + 8,
                          height: sizes.icon + 8,
                          decoration: BoxDecoration(
                            color: widget.iconColor.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(sizes.radius),
                          ),
                          child: Icon(
                            widget.icon,
                            color: widget.iconColor,
                            size: sizes.smallIcon,
                          ),
                        ),
                        SizedBox(width: sizes.smallSpace),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.reminder.title,
                                style: TextStyle(
                                  fontSize: sizes.heading,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.text,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                widget.categoryName,
                                style: TextStyle(
                                  fontSize: sizes.body,
                                  color: AppColors.subtitle,
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Status badge
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: sizes.smallSpace,
                            vertical: sizes.containerPadding * 0.5,
                          ),
                          decoration: BoxDecoration(
                            color: widget.reminder.isEnabled
                                ? const Color(0xFFE8F5E9)
                                : const Color(0xFFF5F5F5),
                            borderRadius: BorderRadius.circular(sizes.caption),
                          ),
                          child: Text(
                            widget.reminder.isEnabled
                                ? 'Active'
                                : 'Paused',
                            style: TextStyle(
                              fontSize: sizes.caption * 0.75,
                              fontWeight: FontWeight.w600,
                              color: widget.reminder.isEnabled
                                  ? const Color(0xFF2E7D32)
                                  : const Color(0xFF64748B),
                            ),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: sizes.largeSpace),

                    // Time - large bold
                    Text(
                      DateFormat('hh:mm a').format(widget.reminder.dateTime),
                      style: TextStyle(
                        fontSize: sizes.largeIcon * 0.33,
                        fontWeight: FontWeight.bold,
                        color: AppColors.text,
                      ),
                    ),

                    const SizedBox(height: 4),

                    // Date
                    Text(
                      DateFormat('EEEE, dd MMM yyyy').format(widget.reminder.dateTime),
                      style: TextStyle(
                        fontSize: sizes.body,
                        color: AppColors.subtitle,
                      ),
                    ),

                    SizedBox(height: sizes.smallSpace),

                    // Repeat badge
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: sizes.smallSpace,
                        vertical: sizes.containerPadding * 0.5,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE8F5E9),
                        borderRadius: BorderRadius.circular(sizes.caption),
                      ),
                      child: Text(
                        widget.reminder.repeat.name.toUpperCase(),
                        style: TextStyle(
                          fontSize: sizes.caption * 0.75,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF2E7D32),
                        ),
                      ),
                    ),

                    SizedBox(height: sizes.largeSpace),

                    const Divider(),

                    // Bottom row
                    Row(
                      children: [
                        Text(
                          'Enabled',
                          style: TextStyle(
                            fontSize: sizes.body,
                            fontWeight: FontWeight.w600,
                            color: AppColors.text,
                          ),
                        ),
                        const Spacer(),
                        Switch(
                          value: widget.reminder.isEnabled,
                          onChanged: widget.onToggle,
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.delete_outline_rounded,
                            color: AppColors.error,
                            size: sizes.smallIcon,
                          ),
                          onPressed: widget.onDelete,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
        ),
      ),
    );
  }
}
