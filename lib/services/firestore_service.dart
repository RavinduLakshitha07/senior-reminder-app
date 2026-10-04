import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/reminder.dart';
import '../models/reminder_history.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String? get _uid => _auth.currentUser?.uid;

  CollectionReference get _remindersCollection =>
      _firestore.collection('users').doc(_uid).collection('reminders');

  CollectionReference get _historyCollection =>
      _firestore.collection('users').doc(_uid).collection('history');

  CollectionReference get _settingsCollection =>
      _firestore.collection('users').doc(_uid).collection('settings');

  /// Backup all reminders to Firestore
  Future<void> backupReminders(List<Reminder> reminders) async {
    if (_uid == null) return;

    final batch = _firestore.batch();

    // Delete existing
    final existing = await _remindersCollection.get();
    for (final doc in existing.docs) {
      batch.delete(doc.reference);
    }

    // Add current
    for (final reminder in reminders) {
      final docRef = _remindersCollection.doc(reminder.id);
      batch.set(docRef, reminder.toMap());
    }

    await batch.commit();
  }

  /// Backup history to Firestore
  Future<void> backupHistory(List<ReminderHistory> history) async {
    if (_uid == null) return;

    final batch = _firestore.batch();

    final existing = await _historyCollection.get();
    for (final doc in existing.docs) {
      batch.delete(doc.reference);
    }

    for (final item in history) {
      final docRef = _historyCollection.doc(item.id);
      batch.set(docRef, item.toMap());
    }

    await batch.commit();
  }

  /// Backup settings to Firestore
  Future<void> backupSettings(Map<String, dynamic> settings) async {
    if (_uid == null) return;

    await _settingsCollection.doc('preferences').set(settings);
  }

  /// Restore reminders from Firestore
  Future<List<Reminder>?> restoreReminders() async {
    if (_uid == null) return null;

    final snapshot = await _remindersCollection.get();
    if (snapshot.docs.isEmpty) return null;

    return snapshot.docs
        .map((doc) => Reminder.fromMap(doc.data() as Map<String, dynamic>))
        .toList();
  }

  /// Restore history from Firestore
  Future<List<ReminderHistory>?> restoreHistory() async {
    if (_uid == null) return null;

    final snapshot = await _historyCollection.get();
    if (snapshot.docs.isEmpty) return null;

    return snapshot.docs
        .map(
          (doc) =>
              ReminderHistory.fromMap(doc.data() as Map<String, dynamic>),
        )
        .toList();
  }

  /// Restore settings from Firestore
  Future<Map<String, dynamic>?> restoreSettings() async {
    if (_uid == null) return null;

    final doc = await _settingsCollection.doc('preferences').get();
    if (!doc.exists) return null;

    final data = doc.data() as Map<String, dynamic>?;
    if (data == null) return null;

    return data;
  }

  /// Get last sync timestamp
  Future<DateTime?> getLastSyncTime() async {
    if (_uid == null) return null;

    final doc = await _settingsCollection.doc('sync_info').get();
    if (!doc.exists) return null;

    final data = doc.data() as Map<String, dynamic>?;
    if (data == null) return null;

    final timestamp = data['lastSync'] as Timestamp?;
    return timestamp?.toDate();
  }

  /// Save last sync timestamp
  Future<void> saveLastSyncTime() async {
    if (_uid == null) return;

    await _settingsCollection.doc('sync_info').set({
      'lastSync': FieldValue.serverTimestamp(),
    });
  }
}

