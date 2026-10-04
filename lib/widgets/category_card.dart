import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../utils/app_sizes.dart';

class CategoryCard extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String title;

  const CategoryCard({
    super.key,
    required this.icon,
    required this.color,
    required this.title,
  });

@override
  Widget build(BuildContext context) {
    final sizes = AppSizes(context);
    final iconBox = sizes.icon + 12;
    final cardWidth = sizes.senior ? 120.0 : 100.0;

    return Container(
      width: cardWidth,
      padding: EdgeInsets.symmetric(
        vertical: sizes.mediumSpace,
        horizontal: sizes.containerPadding,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(sizes.radius),
        boxShadow: const [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: iconBox,
            height: iconBox,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(sizes.radius),
            ),
            child: Icon(icon, color: color, size: sizes.icon),
          ),
          SizedBox(height: sizes.smallSpace),
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: sizes.caption,
              fontWeight: FontWeight.w600,
              color: AppColors.text,
            ),
          ),
        ],
      ),
    );
  }
}
