import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../providers/reminder_provider.dart';
import '../providers/history_provider.dart';
import '../providers/settings_provider.dart';
import '../services/auth_service.dart';
import '../services/firestore_service.dart';
import '../theme/app_colors.dart';
import '../utils/app_sizes.dart';
import '../widgets/ui_helpers.dart';
import 'login_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  Future<void> _showSoundPicker(
      BuildContext context, SettingsProvider settings) async {
    final result = await showDialog<String>(
      context: context,
      builder: (context) => SimpleDialog(
        title: const Text('Notification Sound'),
        children: SettingsProvider.soundOptions.map((sound) {
          return SimpleDialogOption(
            onPressed: () => Navigator.pop(context, sound),
            child: Row(
              children: [
                Icon(
                  sound == settings.notificationSound
                      ? Icons.radio_button_checked
                      : Icons.radio_button_off,
                  color: AppColors.primary,
                  size: 20,
                ),
                const SizedBox(width: 12),
                Text(sound),
              ],
            ),
          );
        }).toList(),
      ),
    );

    if (result != null) {
      await settings.setNotificationSound(result);
    }
  }

  Future<void> _showContactEditor(
      BuildContext context, SettingsProvider settings) async {
    final controller = TextEditingController(text: settings.emergencyContact);

    final result = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Emergency Contact'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            hintText: 'Name · Phone number',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, controller.text.trim()),
            child: const Text('Save'),
          ),
        ],
      ),
    );

    if (result != null) {
      await settings.setEmergencyContact(result);
    }
  }

  Future<void> _performBackup(BuildContext context) async {
    final settings = context.read<SettingsProvider>();
    final reminderProvider = context.read<ReminderProvider>();
    final historyProvider = context.read<HistoryProvider>();

    try {
      final firestoreService = FirestoreService();
      await firestoreService.backupReminders(reminderProvider.reminders);
      await firestoreService.backupHistory(historyProvider.history);
      await firestoreService.backupSettings(settings.toMap());
      await firestoreService.saveLastSyncTime();

      final now = DateFormat('MMM d, h:mm a').format(DateTime.now());
      await settings.setLastSync(now);

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Backup completed successfully!'),
            backgroundColor: Color(0xFF4CAF50),
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Backup failed: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _showAboutApp(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.info_outline, color: AppColors.primary),
            SizedBox(width: 8),
            Text('About App'),
          ],
        ),
        content: const SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Senior Reminder is a simple and easy-to-use reminder application designed to help users remember important daily tasks, medications, appointments, and events. The app focuses on accessibility with a clean interface, large text, and intuitive navigation, making it suitable for users of all ages, especially senior citizens.',
                style: TextStyle(fontSize: 14, height: 1.5),
              ),
              SizedBox(height: 12),
              Text(
                'If you have suggestions, feedback, or encounter any issues, feel free to contact the developer.',
                style: TextStyle(fontSize: 14, height: 1.5),
              ),
              SizedBox(height: 12),
              Row(
                children: [
                  Icon(Icons.email, size: 16, color: AppColors.primary),
                  SizedBox(width: 8),
                  Text(
                    'ravindulakshitha121@gmail.com',
                    style: TextStyle(
                      fontSize: 13,
                      color: AppColors.primary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.person, size: 16, color: AppColors.subtitle),
                  SizedBox(width: 8),
                  Text(
                    'Created by: Ravindu Lakshitha',
                    style: TextStyle(fontSize: 13),
                  ),
                ],
              ),
            ],
          ),
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showRateApp(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.star, color: Colors.amber),
            SizedBox(width: 8),
            Text('Rate App'),
          ],
        ),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Enjoying Senior Reminder?',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 12),
            Text(
              'Your feedback helps us improve the app. If you find it useful, please consider leaving a rating and sharing your experience.',
              style: TextStyle(fontSize: 14, height: 1.5),
            ),
            SizedBox(height: 12),
            Text(
              'Thank you for your support! 🙏',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Later'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Rate Now'),
          ),
        ],
      ),
    );
  }

  void _showPrivacyPolicy(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.privacy_tip, color: AppColors.blue),
            SizedBox(width: 8),
            Text('Privacy Policy'),
          ],
        ),
        content: const SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Your privacy is important to us.',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 12),
              Text(
                'Senior Reminder stores your reminder data locally on your device. We do not collect, sell, or share your personal information with third parties. Any permissions requested by the app are used only to provide reminder notifications and improve your experience.',
                style: TextStyle(fontSize: 14, height: 1.5),
              ),
              SizedBox(height: 12),
              Text(
                'If future updates introduce cloud services or analytics, this Privacy Policy will be updated accordingly.',
                style: TextStyle(fontSize: 14, height: 1.5),
              ),
              SizedBox(height: 16),
              Divider(),
              SizedBox(height: 12),
              Row(
                children: [
                  Icon(Icons.person, size: 16, color: AppColors.subtitle),
                  SizedBox(width: 8),
                  Text(
                    'Developer: Ravindu Lakshitha',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
return SafeArea(
      child: Consumer<SettingsProvider>(
        builder: (context, settings, _) {
          final sizes = AppSizes(context);
          return ListView(
            padding: EdgeInsets.fromLTRB(
              sizes.mediumSpace,
              sizes.smallSpace,
              sizes.mediumSpace,
              sizes.largeIcon,
            ),
            children: [
              const ScreenTitle(title: 'Settings'),

              // Profile
              SettingsCard(
                child: Padding(
                  padding: EdgeInsets.all(sizes.cardPadding),
                  child: Row(
                    children: [
                      Container(
                        width: sizes.icon,
                        height: sizes.icon,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [AppColors.primary, AppColors.blue],
                          ),
                          borderRadius: BorderRadius.circular(sizes.radius * 0.7),
                        ),
                        child: Center(
                          child: Text('👵', style: TextStyle(fontSize: sizes.smallIcon)),
                        ),
                      ),
                      SizedBox(width: sizes.smallSpace),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              settings.userName,
                              style: TextStyle(
                                fontSize: sizes.heading,
                                fontWeight: FontWeight.bold,
                                color: AppColors.text,
                              ),
                            ),
                            SizedBox(height: sizes.smallSpace * 0.5),
                            Text(
                              'Senior Care Plan · Active',
                              style: TextStyle(
                                fontSize: sizes.caption,
                                color: AppColors.subtitle,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: sizes.largeSpace),
              const SectionLabel(label: 'Accessibility'),
              SettingsCard(
                child: Column(
                  children: [
                    SettingsTile(
                      emoji: '👓',
                      title: 'Senior Mode',
                      subtitle: 'Larger text & buttons',
                      showDivider: true,
                      trailing: Switch(
                        value: settings.seniorMode,
                        activeTrackColor: AppColors.primary,
                        onChanged: settings.toggleSeniorMode,
                      ),
                    ),
                    SettingsTile(
                      emoji: '🔊',
                      title: 'Voice Reminder',
                      subtitle: 'Read reminders aloud',
                      showDivider: true,
                      trailing: Switch(
                        value: settings.voiceReminder,
                        activeTrackColor: AppColors.blue,
                        onChanged: settings.toggleVoiceReminder,
                      ),
                    ),
                    SettingsTile(
                      emoji: '🌙',
                      title: 'Dark Mode',
                      subtitle: 'Reduce eye strain',
                      showDivider: false,
                      trailing: Switch(
                        value: settings.darkMode,
                        activeTrackColor: AppColors.primary,
                        onChanged: settings.toggleDarkMode,
                      ),
                    ),
                  ],
                ),
              ),

SizedBox(height: sizes.largeSpace),
              const SectionLabel(label: 'Preferences'),
              SettingsCard(
                child: Column(
                  children: [
                    SettingsTile(
                      emoji: '🔔',
                      title: 'Notification Sound',
                      subtitle: settings.notificationSound,
                      onTap: () => _showSoundPicker(context, settings),
                    ),
                    SettingsTile(
                      emoji: '📞',
                      title: 'Emergency Contact',
                      subtitle: settings.emergencyContact.isEmpty
                          ? 'Not set'
                          : settings.emergencyContact,
                      onTap: () => _showContactEditor(context, settings),
                    ),
                    SettingsTile(
                      emoji: '💾',
                      title: 'Backup & Sync',
                      subtitle: 'Last synced: ${settings.lastSync}',
                      showDivider: false,
                      trailing: Switch(
                        value: settings.backupEnabled,
                        activeTrackColor: AppColors.primary,
                        onChanged: (value) {
                          settings.toggleBackup(value);
                          if (value) {
                            _performBackup(context);
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),

SizedBox(height: sizes.largeSpace),
              const SectionLabel(label: 'About'),
              SettingsCard(
                child: Column(
                  children: [
                    SettingsTile(
                      emoji: 'ℹ️',
                      title: 'About App',
                      subtitle: 'Senior Reminder v2.0.1',
                      onTap: () => _showAboutApp(context),
                    ),
                    SettingsTile(
                      emoji: '⭐',
                      title: 'Rate App',
                      subtitle: "Tell us how we're doing",
                      onTap: () => _showRateApp(context),
                    ),
                    SettingsTile(
                      emoji: '🔒',
                      title: 'Privacy Policy',
                      subtitle: 'Your data is safe',
                      showDivider: false,
                      onTap: () => _showPrivacyPolicy(context),
                    ),
                  ],
                ),
              ),

SizedBox(height: sizes.largeSpace),
              const SectionLabel(label: 'Account'),
              SettingsCard(
                child: SettingsTile(
                  emoji: '🚪',
                  title: 'Sign Out',
                  subtitle: 'Sign out of your account',
                  showDivider: false,
                  onTap: () async {
                    final authService = context.read<AuthService>();
                    final confirm = await showDialog<bool>(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        title: const Text('Sign Out'),
                        content: const Text(
                          'Are you sure you want to sign out?',
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(ctx, false),
                            child: const Text('Cancel'),
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                            ),
                            onPressed: () => Navigator.pop(ctx, true),
                            child: const Text(
                              'Sign Out',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    );

                    if (confirm == true) {
                      await authService.logout();
                      if (!context.mounted) return;
                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                          builder: (_) => const LoginScreen(),
                        ),
                        (route) => false,
                      );
                    }
                  },
                ),
              ),

SizedBox(height: sizes.largeSpace),
              Center(
                child: Text(
                  'Made with ❤️ for seniors everywhere',
                  style: TextStyle(
                    fontSize: sizes.caption,
                    color: AppColors.subtitle,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
