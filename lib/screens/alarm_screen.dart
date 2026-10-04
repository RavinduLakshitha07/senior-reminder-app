import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../models/reminder.dart';
import '../models/reminder_history.dart';
import '../providers/history_provider.dart';
import '../services/alarm_audio_service.dart';
import '../services/notification_service.dart';
import '../services/voice_service.dart';
import '../utils/app_sizes.dart';

class AlarmScreen extends StatefulWidget {
  final String title;
  final String sound;
  final ReminderCategory category;
  final RepeatType repeat;

  const AlarmScreen({
    super.key,
    required this.title,
    required this.sound,
    this.category = ReminderCategory.general,
    this.repeat = RepeatType.none,
  });

  @override
  State<AlarmScreen> createState() => _AlarmScreenState();
}

class _AlarmScreenState extends State<AlarmScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _bellController;
  late Animation<double> _bellAnimation;

  @override
  void initState() {
    super.initState();

    AlarmAudioService.instance.play(widget.sound);
    VoiceService.instance.speak(
      "Reminder. It's time for ${widget.title}",
    );

    _bellController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();

    _bellAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: -0.3, end: 0.3), weight: 1),
      TweenSequenceItem(tween: Tween(begin: 0.3, end: -0.3), weight: 1),
    ]).animate(
      CurvedAnimation(parent: _bellController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    AlarmAudioService.instance.stop();
    VoiceService.instance.stop();
    _bellController.dispose();
    super.dispose();
  }

  Future<void> _snooze(int minutes) async {
    await AlarmAudioService.instance.stop();

    await NotificationService.instance.snoozeNotification(
      title: widget.title,
      sound: widget.sound,
      minutes: minutes,
    );

    if (!mounted) return;
    Navigator.of(context).pop();
  }

  Future<void> _stopReminder() async {
    await AlarmAudioService.instance.stop();

    if (!mounted) return;

    await context.read<HistoryProvider>().addHistory(
          title: widget.title,
          dateTime: DateTime.now(),
          status: ReminderStatus.completed,
        );

    if (!mounted) return;
    Navigator.of(context).pop();
  }

@override
  Widget build(BuildContext context) {
    final sizes = AppSizes(context);
    final now = DateTime.now();
    final timeString = DateFormat('HH:mm').format(now);
    final dayDate = DateFormat('EEEE, MMMM d').format(now);

    final categoryEmoji = widget.category.emoji;
    final categoryName = widget.category.displayName;
    final repeatLabel = widget.repeat.label;
    final categoryTag = '$categoryEmoji $categoryName · $repeatLabel';

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFE8F5E9), Color(0xFFE3F2FD)],
          ),
        ),
child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: sizes.largeSpace),
            child: Column(
              children: [
                SizedBox(height: sizes.mediumSpace),

                // ----- Large Clock -----
                Text(
                  timeString,
                  style: TextStyle(
                    fontSize: sizes.largeIcon * 0.6,
                    fontWeight: FontWeight.bold,
                    letterSpacing: -3,
                    color: const Color(0xFF212121),
                  ),
                ),
                SizedBox(height: sizes.smallSpace * 0.5),
                Text(
                  dayDate,
                  style: TextStyle(
                    fontSize: sizes.body,
                    color: const Color(0xFF757575),
                  ),
                ),

                const Spacer(flex: 2),

                // ----- Animated Bell -----
                AnimatedBuilder(
                  animation: _bellAnimation,
                  builder: (context, child) {
                    return Transform.rotate(
                      angle: _bellAnimation.value,
                      child: child,
                    );
                  },
                  child: Container(
                    width: sizes.largeIcon,
                    height: sizes.largeIcon,
                    decoration: BoxDecoration(
                      color: const Color(0xFF2E7D32),
                      borderRadius: BorderRadius.circular(sizes.largeIcon * 0.35),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x592E7D32),
                          blurRadius: 52,
                          offset: Offset(0, 16),
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.notifications_active_rounded,
                      size: sizes.largeIcon * 0.5,
                      color: Colors.white,
                    ),
                  ),
                ),

                const Spacer(flex: 1),

                // ----- Reminder Info -----
                Text(
                  "Time for your",
                  style: TextStyle(
                    fontSize: sizes.body,
                    color: const Color(0xFF757575),
                  ),
                ),
                SizedBox(height: sizes.smallSpace),
                Text(
                  widget.title,
                  style: TextStyle(
                    fontSize: sizes.heading,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF212121),
                  ),
                ),
                SizedBox(height: sizes.smallSpace * 0.5),
                Text(
                  categoryTag,
                  style: TextStyle(
                    fontSize: sizes.caption,
                    color: const Color(0xFF757575),
                  ),
                ),

                const Spacer(flex: 2),

                // ----- Action Buttons -----
_ActionButton(
                  icon: Icons.access_time_rounded,
                  label: 'Snooze 5 Minutes',
                  backgroundColor: const Color(0xFFFFF3E0),
                  foregroundColor: const Color(0xFFFB8C00),
                  onTap: () => _snooze(5),
                ),
                SizedBox(height: sizes.smallSpace),
                _ActionButton(
                  icon: Icons.access_time_rounded,
                  label: 'Snooze 10 Minutes',
                  backgroundColor: const Color(0xFFE3F2FD),
                  foregroundColor: const Color(0xFF1976D2),
                  onTap: () => _snooze(10),
                ),
                SizedBox(height: sizes.smallSpace),
                _ActionButton(
                  icon: Icons.check_rounded,
                  label: 'Stop Reminder',
                  backgroundColor: const Color(0xFF2E7D32),
                  foregroundColor: Colors.white,
                  onTap: _stopReminder,
                ),

                SizedBox(height: sizes.largeSpace),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color backgroundColor;
  final Color foregroundColor;
  final VoidCallback onTap;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.backgroundColor,
    required this.foregroundColor,
    required this.onTap,
  });

@override
  Widget build(BuildContext context) {
    final sizes = AppSizes(context);
    return SizedBox(
      width: double.infinity,
      height: sizes.buttonHeight,
      child: ElevatedButton.icon(
        onPressed: onTap,
        icon: Icon(icon, color: foregroundColor, size: sizes.smallIcon),
        label: Text(
          label,
          style: TextStyle(
            fontSize: sizes.body,
            fontWeight: FontWeight.bold,
            color: foregroundColor,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: foregroundColor,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(sizes.radius * 0.8),
          ),
        ),
      ),
    );
  }
}
