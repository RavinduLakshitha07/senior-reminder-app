import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/settings_provider.dart';

class AppSizes {
  final BuildContext context;

  AppSizes(this.context);

  bool get senior =>
      context.watch<SettingsProvider>().seniorMode;

  // ===========================
  // Text Sizes
  // ===========================

  double get title => senior ? 34 : 28;

  double get heading => senior ? 30 : 24;

  double get body => senior ? 22 : 18;

  double get caption => senior ? 18 : 14;

  // ===========================
  // Icons
  // ===========================

  double get icon => senior ? 40 : 30;

  double get smallIcon => senior ? 28 : 20;

  double get largeIcon => senior ? 120 : 90;

  // ===========================
  // Buttons
  // ===========================

  double get buttonHeight => senior ? 80 : 60;

  double get largeButtonHeight => senior ? 90 : 70;

  // ===========================
  // Cards & Padding
  // ===========================

  double get cardPadding => senior ? 24 : 16;

  double get containerPadding => senior ? 16 : 10;

  double get radius => senior ? 28 : 20;

  // ===========================
  // Spacing
  // ===========================

  double get smallSpace => senior ? 12 : 8;

  double get mediumSpace => senior ? 20 : 16;

  double get largeSpace => senior ? 32 : 24;
}