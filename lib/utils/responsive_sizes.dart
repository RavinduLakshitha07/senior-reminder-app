import 'package:flutter/material.dart';

/// Responsive sizing helper that adapts to screen width.
/// Provides scaled values for padding, fonts, and dimensions
/// to ensure consistent UI across devices from 360dp to 430dp+.
class ResponsiveSizes {
  final BuildContext context;

  ResponsiveSizes(this.context);

  /// The base design width (iPhone 13 / Pixel 6 scale)
  static const double _baseWidth = 390.0;

  /// Screen width, clamped to avoid extreme values
  double get screenWidth => MediaQuery.of(context).size.width;

  double get _scale => (screenWidth / _baseWidth).clamp(0.85, 1.15);

  /// Scaled font size ensuring minimum legibility
  double font(double size) => (size * _scale).clamp(size * 0.85, size * 1.1);

  /// Scaled padding/spacing
  double space(double size) => (size * _scale).clamp(size * 0.8, size * 1.15);

  /// Scaled icon size
  double icon(double size) => (size * _scale).clamp(size * 0.85, size * 1.1);

  /// Scaled height
  double height(double size) => (size * _scale).clamp(size * 0.85, size * 1.15);

  /// Scaled width keeping aspect ratio
  double width(double size) => (size * _scale).clamp(size * 0.85, size * 1.15);

  /// Whether the device is small (< 360dp)
  bool get isSmall => screenWidth < 360;

  /// Whether the device is medium (360-400dp)
  bool get isMedium => screenWidth >= 360 && screenWidth < 400;

  /// Whether the device is large (>= 400dp)
  bool get isLarge => screenWidth >= 400;

  // Convenience getters for common values
  double get bodyFont => font(18);
  double get titleFont => font(20);
  double get headingFont => font(26);
  double get largeFont => font(34);
  double get smallFont => font(14);
  double get captionFont => font(12);

  double get horizontalPadding => space(20);
  double get verticalPadding => space(16);
  double get cardPadding => space(20);
  double get smallSpace => space(8);
  double get mediumSpace => space(16);
  double get largeSpace => space(24);
  double get xlSpace => space(28);
}
