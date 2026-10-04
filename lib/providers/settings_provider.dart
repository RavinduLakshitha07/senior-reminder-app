import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsProvider extends ChangeNotifier {
  static const _seniorModeKey = 'senior_mode';
  static const _voiceReminderKey = 'voice_reminder';
  static const _darkModeKey = 'dark_mode';
  static const _onboardingKey = 'onboarding_complete';
  static const _userNameKey = 'user_name';
  static const _notificationSoundKey = 'notification_sound';
  static const _emergencyContactKey = 'emergency_contact';
  static const _backupEnabledKey = 'backup_enabled';
  static const _lastSyncKey = 'last_sync';

  bool _seniorMode = true;
  bool _voiceReminder = true;
  bool _darkMode = false;
  bool _onboardingComplete = false;
  String _userName = 'Margaret';
  String _notificationSound = 'Chime (default)';
  String _emergencyContact = '';
  bool _backupEnabled = false;
  String _lastSync = 'Never';

  bool get seniorMode => _seniorMode;
  bool get voiceReminder => _voiceReminder;
  bool get darkMode => _darkMode;
  bool get onboardingComplete => _onboardingComplete;
  String get userName => _userName;
  String get notificationSound => _notificationSound;
  String get emergencyContact => _emergencyContact;
  bool get backupEnabled => _backupEnabled;
  String get lastSync => _lastSync;

  static const List<String> soundOptions = [
    'Chime (default)',
    'Bell',
    'Soft',
    'Gentle',
    'Nature',
  ];

  Future<void> loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    _seniorMode = prefs.getBool(_seniorModeKey) ?? true;
    _voiceReminder = prefs.getBool(_voiceReminderKey) ?? true;
    _darkMode = prefs.getBool(_darkModeKey) ?? false;
    _onboardingComplete = prefs.getBool(_onboardingKey) ?? false;
    _userName = prefs.getString(_userNameKey) ?? 'Margaret';
    _notificationSound =
        prefs.getString(_notificationSoundKey) ?? 'Chime (default)';
    _emergencyContact = prefs.getString(_emergencyContactKey) ?? '';
    _backupEnabled = prefs.getBool(_backupEnabledKey) ?? false;
    _lastSync = prefs.getString(_lastSyncKey) ?? 'Never';
    notifyListeners();
  }

  Future<void> toggleSeniorMode(bool value) async {
    _seniorMode = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_seniorModeKey, value);
    notifyListeners();
  }

  Future<void> toggleVoiceReminder(bool value) async {
    _voiceReminder = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_voiceReminderKey, value);
    notifyListeners();
  }

  Future<void> toggleDarkMode(bool value) async {
    _darkMode = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_darkModeKey, value);
    notifyListeners();
  }

  Future<void> completeOnboarding() async {
    _onboardingComplete = true;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_onboardingKey, true);
    notifyListeners();
  }

  Future<void> setUserName(String name) async {
    _userName = name;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userNameKey, name);
    notifyListeners();
  }

  Future<void> setNotificationSound(String sound) async {
    _notificationSound = sound;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_notificationSoundKey, sound);
    notifyListeners();
  }

  Future<void> setEmergencyContact(String contact) async {
    _emergencyContact = contact;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_emergencyContactKey, contact);
    notifyListeners();
  }

  Future<void> toggleBackup(bool value) async {
    _backupEnabled = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_backupEnabledKey, value);
    notifyListeners();
  }

  Future<void> setLastSync(String syncTime) async {
    _lastSync = syncTime;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_lastSyncKey, syncTime);
    notifyListeners();
  }

  Map<String, dynamic> toMap() {
    return {
      'seniorMode': _seniorMode,
      'voiceReminder': _voiceReminder,
      'darkMode': _darkMode,
      'onboardingComplete': _onboardingComplete,
      'userName': _userName,
      'notificationSound': _notificationSound,
      'emergencyContact': _emergencyContact,
      'backupEnabled': _backupEnabled,
    };
  }

  void fromMap(Map<String, dynamic> map) {
    _seniorMode = map['seniorMode'] as bool? ?? true;
    _voiceReminder = map['voiceReminder'] as bool? ?? true;
    _darkMode = map['darkMode'] as bool? ?? false;
    _onboardingComplete = map['onboardingComplete'] as bool? ?? false;
    _userName = map['userName'] as String? ?? 'Margaret';
    _notificationSound =
        map['notificationSound'] as String? ?? 'Chime (default)';
    _emergencyContact = map['emergencyContact'] as String? ?? '';
    _backupEnabled = map['backupEnabled'] as bool? ?? false;
    notifyListeners();
  }
}
