import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/achievement_provider.dart';
import 'providers/bmi_provider.dart';
import 'providers/history_provider.dart';
import 'providers/reminder_provider.dart';
import 'providers/settings_provider.dart';

import 'screens/splash_screen.dart';

import 'services/auth_service.dart';
import 'services/notification_service.dart';
import 'services/voice_service.dart';
import 'theme/app_theme.dart';


final GlobalKey<NavigatorState> navigatorKey =
    GlobalKey<NavigatorState>();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

  await NotificationService.instance.initialize();
  await VoiceService.instance.initialize();

  final reminderProvider = ReminderProvider();
  await reminderProvider.loadReminders();

  final historyProvider = HistoryProvider();
  await historyProvider.loadHistory();

  final settingsProvider = SettingsProvider();
  await settingsProvider.loadSettings();

  final achievementProvider = AchievementProvider();
  await achievementProvider.loadProgress();

  final bmiProvider = BmiProvider();

  final authService = AuthService();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<ReminderProvider>.value(
          value: reminderProvider,
        ),
        ChangeNotifierProvider<HistoryProvider>.value(
          value: historyProvider,
        ),
        ChangeNotifierProvider<SettingsProvider>.value(
          value: settingsProvider,
        ),
        ChangeNotifierProvider<AuthService>.value(
          value: authService,
        ),
        ChangeNotifierProvider<AchievementProvider>.value(
          value: achievementProvider,
        ),
        ChangeNotifierProvider<BmiProvider>.value(
          value: bmiProvider,
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

@override
Widget build(BuildContext context) {
  final settings = context.watch<SettingsProvider>();

return MaterialApp(
  navigatorKey: navigatorKey,
  debugShowCheckedModeBanner: false,
  title: 'Senior Reminder',

  theme: AppTheme.lightTheme,
  darkTheme: AppTheme.darkTheme,
  themeMode: settings.darkMode
      ? ThemeMode.dark
      : ThemeMode.light,

  home: const SplashScreen(),
);
}
}
