import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../utils/app_sizes.dart';

class EmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final String? actionLabel;
  final VoidCallback? onAction;

  const EmptyState({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    this.actionLabel,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    final sizes = AppSizes(context);
    final iconBox = sizes.largeIcon;

    return Center(
      child: Padding(
        padding: EdgeInsets.all(sizes.largeSpace),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: iconBox,
              height: iconBox,
              decoration: BoxDecoration(
                color: AppColors.secondaryBackground,
                borderRadius: BorderRadius.circular(sizes.radius),
              ),
              child: Icon(
                icon,
                size: sizes.icon,
                color: AppColors.medicalBlue.withValues(alpha: 0.6),
              ),
            ),
            SizedBox(height: sizes.largeSpace),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: sizes.heading,
                fontWeight: FontWeight.bold,
                color: AppColors.text,
              ),
            ),
            SizedBox(height: sizes.smallSpace),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: sizes.body,
                color: AppColors.subtitle,
                height: 1.4,
              ),
            ),
            if (actionLabel != null && onAction != null) ...[
              SizedBox(height: sizes.largeSpace),
              ElevatedButton(
                onPressed: onAction,
                child: Text(actionLabel!),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
