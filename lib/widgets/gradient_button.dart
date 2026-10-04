import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../utils/app_sizes.dart';

class GradientButton extends StatelessWidget {
  final String label;
  final IconData? icon;
  final VoidCallback? onPressed;
  final double? height;
  final double? fontSize;
  final Gradient? gradient;
  final Color? textColor;

  const GradientButton({
    super.key,
    required this.label,
    this.icon,
    this.onPressed,
    this.height,
    this.fontSize,
    this.gradient,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    final sizes = AppSizes(context);
    final bool isDisabled = onPressed == null;
    final buttonHeight = height ?? sizes.buttonHeight;
    final buttonFontSize = fontSize ?? sizes.heading;

    return GestureDetector(
      onTap: onPressed,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        height: buttonHeight,
        decoration: BoxDecoration(
          gradient: isDisabled
              ? LinearGradient(
                  colors: [Colors.grey.shade300, Colors.grey.shade400],
                )
              : (gradient ??
                  const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFF2E7D32), Color(0xFF66BB6A)],
                  )),
          borderRadius: BorderRadius.circular(sizes.radius),
          boxShadow: isDisabled
              ? null
              : [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.3),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  ),
                ],
        ),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) ...[
                Icon(
                  icon,
                  color: textColor ?? Colors.white,
                  size: sizes.smallIcon,
                ),
                const SizedBox(width: 10),
              ],
              Text(
                label,
                style: TextStyle(
                  fontSize: buttonFontSize,
                  fontWeight: FontWeight.w600,
                  color: textColor ?? Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
