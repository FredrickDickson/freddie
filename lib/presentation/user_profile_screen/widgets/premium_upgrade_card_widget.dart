import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

/// Premium upgrade card for free users
class PremiumUpgradeCardWidget extends StatelessWidget {
  final VoidCallback onUpgrade;

  const PremiumUpgradeCardWidget({Key? key, required this.onUpgrade})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              theme.colorScheme.tertiary,
              theme.colorScheme.tertiary.withValues(alpha: 0.8),
            ],
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        padding: EdgeInsets.all(4.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CustomIconWidget(
                  iconName: 'workspace_premium',
                  color: theme.colorScheme.onTertiary,
                  size: 8.w,
                ),
                SizedBox(width: 3.w),
                Expanded(
                  child: Text(
                    'Upgrade to Premium',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: theme.colorScheme.onTertiary,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 2.h),
            _buildFeatureItem(
              context: context,
              text: 'Zero commission on transactions',
            ),
            SizedBox(height: 1.h),
            _buildFeatureItem(
              context: context,
              text: 'Unlimited property listings',
            ),
            SizedBox(height: 1.h),
            _buildFeatureItem(
              context: context,
              text: 'Priority listing visibility',
            ),
            SizedBox(height: 1.h),
            _buildFeatureItem(
              context: context,
              text: 'Advanced AI tools access',
            ),
            SizedBox(height: 1.h),
            _buildFeatureItem(context: context, text: 'Analytics dashboard'),
            SizedBox(height: 2.h),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: onUpgrade,
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.colorScheme.onTertiary,
                  foregroundColor: theme.colorScheme.tertiary,
                  padding: EdgeInsets.symmetric(vertical: 1.5.h),
                ),
                child: Text(
                  'Upgrade Now',
                  style: theme.textTheme.labelLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureItem({
    required BuildContext context,
    required String text,
  }) {
    final theme = Theme.of(context);

    return Row(
      children: [
        CustomIconWidget(
          iconName: 'check_circle',
          color: theme.colorScheme.onTertiary,
          size: 4.w,
        ),
        SizedBox(width: 2.w),
        Expanded(
          child: Text(
            text,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onTertiary,
            ),
          ),
        ),
      ],
    );
  }
}
