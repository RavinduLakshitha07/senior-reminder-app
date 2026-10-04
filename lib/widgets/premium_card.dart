import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../utils/app_sizes.dart';

class PremiumCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final double? height;
  final double? width;
  final EdgeInsetsGeometry? margin;
  final List<BoxShadow>? boxShadow;
  final Color? backgroundColor;
  final double? borderRadius;
  final Border? border;
  final Gradient? gradient;

  const PremiumCard({
    super.key,
    required this.child,
    this.padding,
    this.height,
    this.width,
    this.margin,
    this.boxShadow,
    this.backgroundColor,
    this.borderRadius,
    this.border,
    this.gradient,
  });

  @override
  Widget build(BuildContext context) {
    final sizes = AppSizes(context);
    return Container(
      height: height,
      width: width,
      margin: margin,
      padding: padding ?? EdgeInsets.all(sizes.cardPadding),
      decoration: BoxDecoration(
        color: gradient == null ? (backgroundColor ?? AppColors.card) : null,
        gradient: gradient,
        borderRadius: BorderRadius.circular(borderRadius ?? sizes.radius),
        border: border,
        boxShadow: boxShadow ??
            const [
              BoxShadow(
                color: AppColors.shadow,
                blurRadius: 16,
                offset: Offset(0, 4),
              ),
            ],
      ),
      child: child,
    );
  }
}
