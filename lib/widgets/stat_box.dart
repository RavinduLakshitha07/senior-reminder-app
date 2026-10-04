import 'package:flutter/material.dart';

import '../utils/app_sizes.dart';

class StatBox extends StatelessWidget {
  final Color color;
  final String title;
  final String value;

  const StatBox({
    super.key,
    required this.color,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final sizes = AppSizes(context);

    return Expanded(
      child: Container(
        height: sizes.largeIcon * 0.95,
        margin: const EdgeInsets.symmetric(horizontal: 4),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(sizes.radius),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              value,
              style: TextStyle(
                fontSize: sizes.largeIcon * 0.4,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            SizedBox(height: sizes.smallSpace),
            Text(
              title,
              style: TextStyle(
                fontSize: sizes.caption,
                color: Colors.grey,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
