import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../models/reminder_history.dart';
import '../providers/history_provider.dart';
import '../providers/reminder_provider.dart';
import '../theme/app_colors.dart';
import '../utils/app_sizes.dart';
import '../widgets/ui_helpers.dart';

enum _HistoryFilter { all, completed, missed, pending }

class _TimelineItem {
  final String title;
  final DateTime dateTime;
  final String emoji;
  final Color bgColor;
  final Color statusColor;
  final String statusLabel;
  final String? id;
  final VoidCallback? onDelete;

  _TimelineItem({
    required this.title,
    required this.dateTime,
    required this.emoji,
    required this.bgColor,
    required this.statusColor,
    required this.statusLabel,
    this.id,
    this.onDelete,
  });
}

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  _HistoryFilter _filter = _HistoryFilter.all;
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  int _calculateStreak(List<ReminderHistory> history) {
    if (history.isEmpty) return 0;

    final completedDates = history
        .where((e) => e.status == ReminderStatus.completed)
        .map((e) => DateTime(e.dateTime.year, e.dateTime.month, e.dateTime.day))
        .toSet()
        .toList()
      ..sort((a, b) => b.compareTo(a));

    if (completedDates.isEmpty) return 0;

    var streak = 0;
    var checkDate = DateTime.now();
    checkDate = DateTime(checkDate.year, checkDate.month, checkDate.day);

    for (final date in completedDates) {
      if (date == checkDate || date == checkDate.subtract(const Duration(days: 1))) {
        streak++;
        checkDate = date.subtract(const Duration(days: 1));
      } else {
        break;
      }
    }
    return streak;
  }

  String _formatDateTime(DateTime dt) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final itemDate = DateTime(dt.year, dt.month, dt.day);

    final timeStr = DateFormat('hh:mm a').format(dt);
    if (itemDate == today) return 'Today · $timeStr';
    if (itemDate == today.subtract(const Duration(days: 1))) {
      return 'Yesterday · $timeStr';
    }
    return '${DateFormat('MMM d').format(dt)} · $timeStr';
  }

  List<_TimelineItem> _buildItems(
    HistoryProvider historyProvider,
    ReminderProvider reminderProvider,
  ) {
    final items = <_TimelineItem>[];

    for (final h in historyProvider.history) {
      final completed = h.status == ReminderStatus.completed;
      items.add(_TimelineItem(
        title: h.title,
        dateTime: h.dateTime,
        emoji: completed ? '✅' : '❌',
        bgColor: completed ? const Color(0xFFE8F5E9) : const Color(0xFFFFEBEE),
        statusColor: completed ? AppColors.primary : AppColors.red,
        statusLabel: completed ? 'Completed' : 'Missed',
        id: h.id,
        onDelete: () => historyProvider.deleteItem(h.id),
      ));
    }

    for (final r in reminderProvider.reminders) {
      final cat = CategoryHelper.forReminderCategory(r.category.name);
      items.add(_TimelineItem(
        title: r.title,
        dateTime: r.dateTime,
        emoji: cat.emoji,
        bgColor: cat.bgColor,
        statusColor: AppColors.orange,
        statusLabel: 'Pending',
      ));
    }

    items.sort((a, b) => b.dateTime.compareTo(a.dateTime));
    return items;
  }

  @override
  Widget build(BuildContext context) {
return SafeArea(
      child: Consumer2<HistoryProvider, ReminderProvider>(
        builder: (context, historyProvider, reminderProvider, _) {
          final sizes = AppSizes(context);
          final completed = historyProvider.completedCount;
          final missed = historyProvider.missedCount;
          final streak = _calculateStreak(historyProvider.history);

          var items = _buildItems(historyProvider, reminderProvider);

          final query = _searchController.text.toLowerCase();
          if (query.isNotEmpty) {
            items = items
                .where((e) => e.title.toLowerCase().contains(query))
                .toList();
          }

          items = items.where((item) {
            switch (_filter) {
              case _HistoryFilter.completed:
                return item.statusLabel == 'Completed';
              case _HistoryFilter.missed:
                return item.statusLabel == 'Missed';
              case _HistoryFilter.pending:
                return item.statusLabel == 'Pending';
              case _HistoryFilter.all:
                return true;
            }
          }).toList();

return ListView(
            padding: EdgeInsets.fromLTRB(
              sizes.mediumSpace,
              sizes.smallSpace,
              sizes.mediumSpace,
              sizes.largeIcon,
            ),
            children: [
              const ScreenTitle(title: 'History'),
              Row(
                children: [
                  _SummaryCard(
                    value: completed.toString(),
                    label: 'Completed',
                    color: AppColors.primary,
                  ),
                  SizedBox(width: sizes.smallSpace),
                  _SummaryCard(
                    value: missed.toString(),
                    label: 'Missed',
                    color: AppColors.red,
                  ),
                  SizedBox(width: sizes.smallSpace),
                  _SummaryCard(
                    value: '${streak}d',
                    label: 'Streak',
                    color: AppColors.orange,
                  ),
                ],
              ),
              SizedBox(height: sizes.mediumSpace),
              Container(
                padding: EdgeInsets.symmetric(horizontal: sizes.mediumSpace),
                decoration: BoxDecoration(
                  color: const Color(0xFFF0F0F0),
                  borderRadius: BorderRadius.circular(sizes.radius * 0.8),
                ),
                child: TextField(
                  controller: _searchController,
                  onChanged: (_) => setState(() {}),
                  style: TextStyle(fontSize: sizes.body),
                  decoration: const InputDecoration(
                    hintText: 'Search reminders...',
                    hintStyle: TextStyle(color: AppColors.subtitle),
                    border: InputBorder.none,
                    icon: Icon(Icons.search, color: AppColors.subtitle),
                  ),
                ),
              ),
              SizedBox(height: sizes.smallSpace),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _FilterChip(
                      label: 'All',
                      isSelected: _filter == _HistoryFilter.all,
                      onTap: () =>
                          setState(() => _filter = _HistoryFilter.all),
                    ),
                    _FilterChip(
                      label: 'Completed',
                      isSelected: _filter == _HistoryFilter.completed,
                      onTap: () => setState(
                          () => _filter = _HistoryFilter.completed),
                    ),
                    _FilterChip(
                      label: 'Missed',
                      isSelected: _filter == _HistoryFilter.missed,
                      onTap: () =>
                          setState(() => _filter = _HistoryFilter.missed),
                    ),
                    _FilterChip(
                      label: 'Pending',
                      isSelected: _filter == _HistoryFilter.pending,
                      onTap: () =>
                          setState(() => _filter = _HistoryFilter.pending),
                    ),
                  ],
                ),
              ),
              SizedBox(height: sizes.mediumSpace),
              if (items.isEmpty)
                Padding(
                  padding: EdgeInsets.all(sizes.largeSpace),
                  child: Center(
                    child: Text(
                      'No reminders found',
                      style: TextStyle(
                        fontSize: sizes.body,
                        color: AppColors.subtitle,
                      ),
                    ),
                  ),
                )
              else
                ...List.generate(items.length, (index) {
                  final item = items[index];
                  return _TimelineRow(
                    item: item,
                    isLast: index == items.length - 1,
                    formattedTime: _formatDateTime(item.dateTime),
                  );
                }),
            ],
          );
        },
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final String value;
  final String label;
  final Color color;

  const _SummaryCard({
    required this.value,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final sizes = AppSizes(context);
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: sizes.cardPadding * 0.8,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(sizes.radius * 0.7),
          boxShadow: [
            BoxShadow(
              color: AppColors.shadow,
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            Text(
              value,
              style: TextStyle(
                fontSize: sizes.heading,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            SizedBox(height: sizes.smallSpace * 0.5),
            Text(
              label,
              style: TextStyle(
                fontSize: sizes.caption * 0.75,
                color: AppColors.subtitle,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final sizes = AppSizes(context);
    return Padding(
      padding: EdgeInsets.only(right: sizes.smallSpace),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: sizes.mediumSpace,
            vertical: sizes.smallSpace,
          ),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primary : Colors.white,
            borderRadius: BorderRadius.circular(sizes.caption),
            border: Border.all(
              color: isSelected ? AppColors.primary : const Color(0xFFE0E0E0),
            ),
          ),
          child: Text(
            label,
            style: TextStyle(
              fontSize: sizes.caption,
              fontWeight: FontWeight.w600,
              color: isSelected ? Colors.white : AppColors.subtitle,
            ),
          ),
        ),
      ),
    );
  }
}

class _TimelineRow extends StatelessWidget {
  final _TimelineItem item;
  final bool isLast;
  final String formattedTime;

  const _TimelineRow({
    required this.item,
    required this.isLast,
    required this.formattedTime,
  });

@override
  Widget build(BuildContext context) {
    final sizes = AppSizes(context);
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: sizes.icon,
            child: Column(
              children: [
                Container(
                  width: sizes.smallIcon,
                  height: sizes.smallIcon,
                  decoration: BoxDecoration(
                    color: item.statusColor,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    item.statusLabel == 'Completed'
                        ? Icons.check
                        : item.statusLabel == 'Missed'
                            ? Icons.close
                            : Icons.access_time,
                    color: Colors.white,
                    size: sizes.caption * 0.8,
                  ),
                ),
                if (!isLast)
                  Expanded(
                    child: Container(
                      width: 2,
                      color: const Color(0xFFE0E0E0),
                    ),
                  ),
              ],
            ),
          ),
          SizedBox(width: sizes.smallSpace),
          Expanded(
            child: Container(
              margin: EdgeInsets.only(bottom: sizes.mediumSpace),
              padding: EdgeInsets.all(sizes.cardPadding * 0.7),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(sizes.radius * 0.8),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.shadow,
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    width: sizes.icon,
                    height: sizes.icon,
                    decoration: BoxDecoration(
                      color: item.bgColor,
                      borderRadius: BorderRadius.circular(sizes.radius * 0.6),
                    ),
                    child: Center(
                      child: Text(
                        item.emoji,
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
                          item.title,
                          style: TextStyle(
                            fontSize: sizes.body,
                            fontWeight: FontWeight.bold,
                            color: AppColors.text,
                          ),
                        ),
                        SizedBox(height: sizes.smallSpace * 0.5),
                        Text(
                          formattedTime,
                          style: TextStyle(
                            fontSize: sizes.caption * 0.75,
                            color: AppColors.subtitle,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (item.onDelete != null)
                    IconButton(
                      icon: Icon(
                        Icons.delete_outline_rounded,
                        color: Colors.red,
                        size: sizes.smallIcon,
                      ),
                      onPressed: item.onDelete,
                    ),
                  Container(
                    width: sizes.smallSpace * 0.8,
                    height: sizes.smallSpace * 0.8,
                    decoration: BoxDecoration(
                      color: item.statusColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
