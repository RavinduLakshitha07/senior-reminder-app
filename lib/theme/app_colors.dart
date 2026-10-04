import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // ==========================
  // Brand Palette
  // ==========================

  /// Orange (#EE6C29)
  static const primary = Color(0xFFEE6C29);

  /// Jet (#282B2B)
  static const dark = Color(0xFF282B2B);

  /// Moonstone (#7AA6B3)
  static const moonstone = Color(0xFF7AA6B3);

  // ==========================
  // Backgrounds
  // ==========================

  static const background = Color(0xFFF8F9FA);
  static const secondaryBackground = Color(0xFFF2F4F6);

  // ==========================
  // Cards
  // ==========================

  static const card = Colors.white;

  // ==========================
  // Text
  // ==========================

  static const text = dark;
  static const subtitle = moonstone;

  // ==========================
  // Semantic Colors
  // ==========================

  static const success = Color(0xFF4CAF50);
  static const error = Color(0xFFE53935);
  static const warning = Color(0xFFFF9800);

  // ==========================
  // Category Colors
  // ==========================

  static const medicalBlue = moonstone;

  static const blue = moonstone;
  static const red = error;
  static const orange = primary;
  static const purple = Color(0xFF7E57C2);

  // Keep compatibility with existing code
  static const secondaryGreen = success;
  static const amber = warning;

  // ==========================
  // Shadows
  // ==========================

  static const shadow = Color(0x0A000000);
  static const shadowMd = Color(0x14000000);

static const divider = Color(0xFFE5E7EB);

}