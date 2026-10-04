import 'package:flutter/material.dart';

class AppTextStyles {
  AppTextStyles._();

  // Screen Title - 34sp Bold
  static const screenTitle = TextStyle(
    fontSize: 34,
    fontWeight: FontWeight.bold,
    color: Color(0xFF111827),
    height: 1.2,
  );

  // Section Title - 26sp Bold
  static const sectionTitle = TextStyle(
    fontSize: 26,
    fontWeight: FontWeight.bold,
    color: Color(0xFF111827),
    height: 1.3,
  );

  // Card Title - 22sp
  static const cardTitle = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.w600,
    color: Color(0xFF111827),
  );

  // Backward-compatible alias
  static const title = cardTitle;

  // Body - 20sp (never smaller than 18sp for accessibility)
  static const bodyLarge = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w400,
    color: Color(0xFF6B7280),
    height: 1.5,
  );

  static const body = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w400,
    color: Color(0xFF6B7280),
    height: 1.5,
  );

  // Button - 20sp
  static const button = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: Colors.white,
  );

  // Label - 18sp
  static const label = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w500,
    color: Color(0xFF111827),
  );

  // Caption - 16sp (minimum for accessibility)
  static const caption = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: Color(0xFF6B7280),
  );

  // Numbers / Stats
  static const statValue = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.bold,
    color: Color(0xFF111827),
  );

  static const statLabel = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w500,
    color: Color(0xFF6B7280),
  );
}
