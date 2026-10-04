import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/reminder.dart';
import '../providers/reminder_provider.dart';
import '../providers/settings_provider.dart';
import '../theme/app_colors.dart';
import '../utils/app_sizes.dart';
import '../widgets/gradient_button.dart';

class AddReminderScreen extends StatefulWidget {
  final Reminder? reminder;

  const AddReminderScreen({super.key, this.reminder});

  @override
  State<AddReminderScreen> createState() => _AddReminderScreenState();
}

class _AddReminderScreenState extends State<AddReminderScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();

  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();
  String _selectedSound = 'Chime';
  String _selectedRepeat = 'None';
  int _selectedCategoryIndex = 0;
  bool _voiceReminder = true;
  bool _enableReminder = true;

  bool get isEditing => widget.reminder != null;

  static const _sounds = ['Chime', 'Bell', 'Gentle', 'Classic', 'Vibrate'];
  static const _repeats = [
    'None',
    'Daily',
    'Weekdays',
    'Weekends',
    'Weekly',
    'Monthly',
  ];

  static const _categoryMap = [
    ReminderCategory.medicine,
    ReminderCategory.water,
    ReminderCategory.meal,
    ReminderCategory.general,
    ReminderCategory.appointment,
    ReminderCategory.general,
  ];

  static const _categoryData = [
    _CategoryItem('💊', 'Medicine', Color(0xFFFEE2E2)),
    _CategoryItem('💧', 'Drink Water', Color(0xFFDBEAFE)),
    _CategoryItem('🍽', 'Meal', Color(0xFFFEF3C7)),
    _CategoryItem('📌', 'General', Color(0xFFD1FAE5)),
    _CategoryItem('🏥', 'Appointment', Color(0xFFF3E8FF)),
  ];

  bool _voiceInitialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_voiceInitialized) {
      _voiceReminder = context.read<SettingsProvider>().voiceReminder;
      _voiceInitialized = true;
    }
  }

  @override
  void initState() {
    super.initState();
    if (widget.reminder != null) {
      final r = widget.reminder!;
      _titleController.text = r.title;
      _selectedDate = r.dateTime;
      _selectedTime = TimeOfDay(
        hour: r.dateTime.hour,
        minute: r.dateTime.minute,
      );
      _selectedRepeat = _repeatToLabel(r.repeat);
      _selectedCategoryIndex = _categoryMap.indexOf(r.category);
      if (_selectedCategoryIndex < 0) _selectedCategoryIndex = 5;
      _enableReminder = r.isEnabled;
    }
  }

  String _repeatToLabel(RepeatType repeat) {
    switch (repeat) {
      case RepeatType.none:
        return 'None';
      case RepeatType.daily:
        return 'Daily';
      case RepeatType.weekly:
        return 'Weekly';
      case RepeatType.monthly:
        return 'Monthly';
    }
  }

  RepeatType _labelToRepeat(String label) {
    switch (label) {
      case 'Daily':
      case 'Weekdays':
      case 'Weekends':
        return RepeatType.daily;
      case 'Weekly':
        return RepeatType.weekly;
      case 'Monthly':
        return RepeatType.monthly;
      default:
        return RepeatType.none;
    }
  }

  String _soundToFile(String label) {
    switch (label) {
      case 'Bell':
        return 'bell.mp3';
      case 'Gentle':
      case 'Classic':
        return 'soft.mp3';
      default:
        return 'default.mp3';
    }
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (picked != null) setState(() => _selectedDate = picked);
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );
    if (picked != null) setState(() => _selectedTime = picked);
  }

  Future<void> _saveReminder() async {
    if (!_formKey.currentState!.validate()) return;

    final dateTime = DateTime(
      _selectedDate.year,
      _selectedDate.month,
      _selectedDate.day,
      _selectedTime.hour,
      _selectedTime.minute,
    );

    final provider = context.read<ReminderProvider>();
    final category = _categoryMap[_selectedCategoryIndex];
    final sound = _soundToFile(_selectedSound);
    final repeat = _labelToRepeat(_selectedRepeat);

    if (isEditing) {
      await provider.updateReminderDetails(
        reminder: widget.reminder!,
        title: _titleController.text.trim(),
        dateTime: dateTime,
        sound: sound,
        repeat: repeat,
        category: category,
      );
      if (_enableReminder != widget.reminder!.isEnabled) {
        await provider.toggleReminder(widget.reminder!.id);
      }
    } else {
      await provider.addReminder(
        title: _titleController.text.trim(),
        dateTime: dateTime,
        sound: sound,
        repeat: repeat,
        category: category,
      );
    }

    if (!mounted) return;
    Navigator.pop(context);
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final sizes = AppSizes(context);
    final dateStr =
        '${_selectedDate.year}-${_selectedDate.month.toString().padLeft(2, '0')}-${_selectedDate.day.toString().padLeft(2, '0')}';
    final timeStr = _selectedTime.format(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: EdgeInsets.fromLTRB(
              sizes.mediumSpace,
              sizes.smallSpace,
              sizes.mediumSpace,
              sizes.largeSpace,
            ),
            children: [
              // Header
              Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: sizes.icon,
                      height: sizes.icon,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(sizes.radius * 0.6),
                      ),
                      child: Icon(
                        Icons.chevron_left,
                        size: sizes.icon,
                        color: AppColors.text,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      'New Reminder',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: sizes.heading,
                        fontWeight: FontWeight.bold,
                        color: AppColors.text,
                      ),
                    ),
                  ),
                  SizedBox(width: sizes.icon),
                ],
              ),
              SizedBox(height: sizes.largeSpace),

              // Title field
              Text(
                'Reminder Title',
                style: TextStyle(
                  fontSize: sizes.body,
                  fontWeight: FontWeight.w600,
                  color: AppColors.text,
                ),
              ),
              SizedBox(height: sizes.smallSpace),
              TextFormField(
                controller: _titleController,
                style: TextStyle(fontSize: sizes.body),
                decoration: InputDecoration(
                  hintText: 'e.g., Morning Medication',
                  hintStyle: TextStyle(color: const Color(0xFF94A3B8), fontSize: sizes.caption),
                  prefixIcon: Icon(Icons.title_rounded,
                      color: AppColors.primary, size: sizes.smallIcon),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: sizes.mediumSpace,
                    vertical: sizes.mediumSpace,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(sizes.radius * 0.8),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(sizes.radius * 0.8),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(sizes.radius * 0.8),
                    borderSide: const BorderSide(
                      color: AppColors.primary,
                      width: 2,
                    ),
                  ),
                ),
                validator: (v) =>
                    v == null || v.trim().isEmpty ? 'Please enter a title' : null,
              ),
              SizedBox(height: sizes.largeSpace),

              // Category
              Text(
                'Category',
                style: TextStyle(
                  fontSize: sizes.body,
                  fontWeight: FontWeight.w600,
                  color: AppColors.text,
                ),
              ),
              SizedBox(height: sizes.smallSpace),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisSpacing: sizes.smallSpace,
                  crossAxisSpacing: sizes.smallSpace,
                  childAspectRatio: 1.2,
                ),
                itemCount: _categoryData.length,
                itemBuilder: (context, index) {
                  final cat = _categoryData[index];
                  final isSelected = _selectedCategoryIndex == index;
                  return GestureDetector(
                    onTap: () => setState(() => _selectedCategoryIndex = index),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(sizes.radius * 0.8),
                        border: Border.all(
                          color: isSelected
                              ? AppColors.primary
                              : Colors.transparent,
                          width: 2.5,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.shadow,
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(cat.emoji, style: TextStyle(fontSize: sizes.smallIcon)),
                          SizedBox(height: sizes.smallSpace),
                          Text(
                            cat.label,
                            style: TextStyle(
                              fontSize: sizes.caption,
                              fontWeight: FontWeight.w600,
                              color: isSelected
                                  ? AppColors.primary
                                  : AppColors.subtitle,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
              SizedBox(height: sizes.largeSpace),

// Date & Time
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Date',
                          style: TextStyle(
                            fontSize: sizes.body,
                            fontWeight: FontWeight.w600,
                            color: AppColors.text,
                          ),
                        ),
                        SizedBox(height: sizes.smallSpace),
                        GestureDetector(
                          onTap: _pickDate,
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: sizes.mediumSpace,
                              vertical: sizes.mediumSpace,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(sizes.radius * 0.7),
                            ),
                            child: Row(
                              children: [
                                Icon(Icons.calendar_today_rounded,
                                    color: AppColors.primary, size: sizes.smallIcon),
                                SizedBox(width: sizes.smallSpace),
                                Text(
                                  dateStr,
                                  style: TextStyle(
                                    fontSize: sizes.caption,
                                    color: AppColors.text,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: sizes.smallSpace),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Time',
                          style: TextStyle(
                            fontSize: sizes.body,
                            fontWeight: FontWeight.w600,
                            color: AppColors.text,
                          ),
                        ),
                        SizedBox(height: sizes.smallSpace),
                        GestureDetector(
                          onTap: _pickTime,
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: sizes.mediumSpace,
                              vertical: sizes.mediumSpace,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(sizes.radius * 0.7),
                            ),
                            child: Row(
                              children: [
                                Icon(Icons.access_time_rounded,
                                    color: AppColors.medicalBlue, size: sizes.smallIcon),
                                SizedBox(width: sizes.smallSpace),
                                Text(
                                  timeStr,
                                  style: TextStyle(
                                    fontSize: sizes.caption,
                                    color: AppColors.text,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: sizes.largeSpace),

              // Repeat
              Text(
                'Repeat',
                style: TextStyle(
                  fontSize: sizes.body,
                  fontWeight: FontWeight.w600,
                  color: AppColors.text,
                ),
              ),
              SizedBox(height: sizes.smallSpace),
              Wrap(
                spacing: sizes.smallSpace,
                runSpacing: sizes.smallSpace,
                children: _repeats.map((r) {
                  final isSelected = _selectedRepeat == r;
                  return GestureDetector(
                    onTap: () => setState(() => _selectedRepeat = r),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: EdgeInsets.symmetric(
                        horizontal: sizes.mediumSpace,
                        vertical: sizes.smallSpace,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppColors.primary
                            : Colors.white,
                        borderRadius: BorderRadius.circular(sizes.largeSpace),
                        border: Border.all(
                          color: isSelected
                              ? AppColors.primary
                              : const Color(0xFFE2E8F0),
                        ),
                      ),
                      child: Text(
                        r,
                        style: TextStyle(
                          fontSize: sizes.caption,
                          fontWeight: FontWeight.w600,
                          color: isSelected ? Colors.white : AppColors.text,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
              SizedBox(height: sizes.largeSpace),

// Sound
              Text(
                'Notification Sound',
                style: TextStyle(
                  fontSize: sizes.body,
                  fontWeight: FontWeight.w600,
                  color: AppColors.text,
                ),
              ),
              SizedBox(height: sizes.smallSpace),
              Wrap(
                spacing: sizes.smallSpace,
                runSpacing: sizes.smallSpace,
                children: _sounds.map((s) {
                  final isSelected = _selectedSound == s;
                  return GestureDetector(
                    onTap: () => setState(() => _selectedSound = s),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: EdgeInsets.symmetric(
                        horizontal: sizes.mediumSpace,
                        vertical: sizes.smallSpace,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppColors.secondaryBackground
                            : Colors.white,
                        borderRadius: BorderRadius.circular(sizes.largeSpace),
                        border: Border.all(
                          color: isSelected
                              ? AppColors.primary
                              : const Color(0xFFE2E8F0),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            isSelected
                                ? Icons.volume_up_rounded
                                : Icons.volume_mute_rounded,
                            size: sizes.smallIcon,
                            color: isSelected
                                ? AppColors.primary
                                : AppColors.subtitle,
                          ),
                          SizedBox(width: sizes.smallSpace * 0.5),
                          Text(
                            s,
                            style: TextStyle(
                              fontSize: sizes.caption,
                              fontWeight: FontWeight.w600,
                              color: isSelected ? AppColors.primary : AppColors.text,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
              SizedBox(height: sizes.largeSpace),

              // Toggle options
              Container(
                padding: EdgeInsets.all(sizes.smallSpace * 0.5),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(sizes.radius),
                  boxShadow: const [
                    BoxShadow(
                      color: AppColors.shadow,
                      blurRadius: 12,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    _ToggleRow(
                      emoji: '🎤',
                      bgColor: const Color(0xFFEDE7F6),
                      title: 'Voice Reminder',
                      subtitle: 'Read reminder aloud',
                      value: _voiceReminder,
                      activeColor: AppColors.medicalBlue,
                      onChanged: (v) => setState(() => _voiceReminder = v),
                    ),
                    const Divider(height: 1, indent: 16, endIndent: 16),
                    _ToggleRow(
                      emoji: '🔔',
                      bgColor: const Color(0xFFE8F5E9),
                      title: 'Enable Reminder',
                      subtitle: 'Activate this reminder',
                      value: _enableReminder,
                      activeColor: AppColors.primary,
                      onChanged: (v) => setState(() => _enableReminder = v),
                    ),
                  ],
                ),
              ),

              SizedBox(height: sizes.largeSpace),

              // Save button
              GradientButton(
                onPressed: _saveReminder,
                label: isEditing ? 'Update Reminder' : 'Set Reminder',
                icon: Icons.check_rounded,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CategoryItem {
  final String emoji;
  final String label;
  final Color bgColor;

  const _CategoryItem(this.emoji, this.label, this.bgColor);
}

class _ToggleRow extends StatelessWidget {
  final String emoji;
  final Color bgColor;
  final String title;
  final String subtitle;
  final bool value;
  final Color activeColor;
  final ValueChanged<bool> onChanged;

  const _ToggleRow({
    required this.emoji,
    required this.bgColor,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.activeColor,
    required this.onChanged,
  });

@override
  Widget build(BuildContext context) {
    final sizes = AppSizes(context);
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: sizes.mediumSpace,
        vertical: sizes.smallSpace,
      ),
      child: Row(
        children: [
          Container(
            width: sizes.icon,
            height: sizes.icon,
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(sizes.radius * 0.7),
            ),
            child: Center(
              child: Text(emoji, style: TextStyle(fontSize: sizes.smallIcon)),
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
          Switch(
            value: value,
            activeTrackColor: activeColor,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}
