import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../utils/app_sizes.dart';

class ReminderCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final VoidCallback? onTap;

  const ReminderCard({
    super.key,
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final sizes = AppSizes(context);
    final iconBox = sizes.icon + 12;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(sizes.radius),
        onTap: onTap,
        child: Container(
          margin: EdgeInsets.only(bottom: sizes.mediumSpace),
          padding: EdgeInsets.all(sizes.cardPadding * 0.7),
          decoration: BoxDecoration(
            color: AppColors.card,
            borderRadius: BorderRadius.circular(sizes.radius),
            boxShadow: const [
              BoxShadow(
                color: AppColors.shadow,
                blurRadius: 20,
                offset: Offset(0, 8),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: iconBox,
                height: iconBox,
                decoration: BoxDecoration(
                  color: iconColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(sizes.radius),
                ),
                child: Icon(
                  icon,
                  color: iconColor,
                  size: sizes.icon,
                ),
              ),

              SizedBox(width: sizes.smallSpace),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: AppTextStyles.title.copyWith(
                        fontSize: sizes.heading,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),

                    SizedBox(height: sizes.smallSpace * 0.7),

                    Text(
                      subtitle,
                      style: AppTextStyles.body.copyWith(
                        fontSize: sizes.body,
                      ),
                    ),
                  ],
                ),
              ),

              Column(
                children: [
                  Container(
                    width: sizes.caption * 0.6,
                    height: sizes.caption * 0.6,
                    decoration: BoxDecoration(
                      color: AppColors.orange,
                      shape: BoxShape.circle,
                    ),
                  ),

                  SizedBox(height: sizes.mediumSpace),

                  Icon(
                    Icons.chevron_right,
                    color: Colors.grey,
                    size: sizes.smallIcon,
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
