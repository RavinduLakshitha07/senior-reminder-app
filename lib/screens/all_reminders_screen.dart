import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/reminder.dart';
import '../providers/reminder_provider.dart';
import '../theme/app_colors.dart';
import '../widgets/home_reminder_card.dart';
import 'add_reminder_screen.dart';

class AllRemindersScreen extends StatefulWidget {
  const AllRemindersScreen({super.key});

  @override
  State<AllRemindersScreen> createState() => _AllRemindersScreenState();
}

class _AllRemindersScreenState extends State<AllRemindersScreen> {
  String? _selectedCategory;
  String _searchQuery = '';
  final _searchController = TextEditingController();

  final _categories = ['All', 'Medicine', 'Health', 'Meal', 'Doctor', 'Other'];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

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

  List<Reminder> _filteredReminders(List<Reminder> reminders) {
    final filtered = reminders.toList();

    if (_selectedCategory != null && _selectedCategory != 'All') {
      filtered.removeWhere((r) {
        final catName = _getCategoryName(r.category);
        return catName != _selectedCategory;
      });
    }

    if (_searchQuery.isNotEmpty) {
      filtered.removeWhere((r) {
        return !r.title.toLowerCase().contains(_searchQuery.toLowerCase());
      });
    }

    filtered.sort((a, b) => a.dateTime.compareTo(b.dateTime));
    return filtered;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        title: const Text(
          'All Reminders',
          style: TextStyle(
            color: Color(0xFF1E293B),
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        iconTheme: const IconThemeData(color: Color(0xFF1E293B)),
      ),
      body: Consumer<ReminderProvider>(
        builder: (context, provider, _) {
          final filtered = _filteredReminders(provider.reminders);

          return Column(
            children: [
              // Search bar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                child: TextField(
                  controller: _searchController,
                  onChanged: (value) => setState(() => _searchQuery = value),
                  style: const TextStyle(fontSize: 16),
                  decoration: InputDecoration(
                    hintText: 'Search reminders...',
                    hintStyle: const TextStyle(color: Color(0xFF94A3B8)),
                    prefixIcon: const Icon(
                      Icons.search_rounded,
                      color: Color(0xFF94A3B8),
                    ),
                    suffixIcon: _searchQuery.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear_rounded,
                                color: Color(0xFF94A3B8)),
                            onPressed: () {
                              _searchController.clear();
                              setState(() => _searchQuery = '');
                            },
                          )
                        : null,
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 16,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: const BorderSide(
                        color: AppColors.primary,
                        width: 2,
                      ),
                    ),
                  ),
                ),
              ),

              // Category filter chips
              SizedBox(
                height: 48,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  children: _categories.map((cat) {
                    final isSelected = _selectedCategory == cat ||
                        (_selectedCategory == null && cat == 'All');
                    return Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: GestureDetector(
                        onTap: () =>
                            setState(() => _selectedCategory = cat == 'All' ? null : cat),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 18,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? AppColors.primary
                                : Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: isSelected
                                  ? AppColors.primary
                                  : const Color(0xFFE0E0E0),
                            ),
                          ),
                          child: Text(
                            cat,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: isSelected
                                  ? Colors.white
                                  : const Color(0xFF475569),
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),

              const SizedBox(height: 8),

              // Reminder count
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  children: [
                    Text(
                      '${filtered.length} reminder${filtered.length != 1 ? 's' : ''}',
                      style: const TextStyle(
                        fontSize: 15,
                        color: Color(0xFF64748B),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 8),

              // Reminder list
              Expanded(
                child: filtered.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 64,
                              height: 64,
                              decoration: BoxDecoration(
                                color: AppColors.secondaryBackground,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: const Icon(
                                Icons.search_off_rounded,
                                size: 32,
                                color: AppColors.medicalBlue,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              _searchQuery.isNotEmpty
                                  ? 'No reminders match your search'
                                  : 'No reminders yet',
                              style: const TextStyle(
                                fontSize: 16,
                                color: Color(0xFF64748B),
                              ),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        itemCount: filtered.length,
                        itemBuilder: (context, index) {
                          final reminder = filtered[index];
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
                                  builder: (_) => AddReminderScreen(
                                    reminder: reminder,
                                  ),
                                ),
                              );
                              if (context.mounted) {
                                context
                                    .read<ReminderProvider>()
                                    .loadReminders();
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
              ),
            ],
          );
        },
      ),
    );
  }
}
