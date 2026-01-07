import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

/// Widget displaying subscription plan cards with pricing and features
class SubscriptionPlanCardWidget extends StatelessWidget {
  final String currentPlan;
  final VoidCallback onUpgrade;

  const SubscriptionPlanCardWidget({
    Key? key,
    required this.currentPlan,
    required this.onUpgrade,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        // Free Plan Card
        Container(
          width: double.infinity,
          margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
          padding: EdgeInsets.all(4.w),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: currentPlan == 'free'
                  ? theme.colorScheme.primary
                  : theme.dividerColor,
              width: currentPlan == 'free' ? 2 : 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Free Plan', style: theme.textTheme.titleLarge),
                  currentPlan == 'free'
                      ? Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 3.w,
                            vertical: 0.5.h,
                          ),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.primary,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            'CURRENT',
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        )
                      : const SizedBox.shrink(),
                ],
              ),
              SizedBox(height: 1.h),
              Text(
                '₦0/year',
                style: theme.textTheme.headlineMedium?.copyWith(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: 2.h),
              _buildFeatureItem(context, 'Up to 5 property listings'),
              _buildFeatureItem(context, '5% commission on transactions'),
              _buildFeatureItem(context, 'Basic AI contract generation'),
              _buildFeatureItem(context, 'Standard listing visibility'),
              _buildFeatureItem(context, 'Email support'),
            ],
          ),
        ),

        // Premium Plan Card
        Container(
          width: double.infinity,
          margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
          padding: EdgeInsets.all(4.w),
          decoration: BoxDecoration(
            gradient: currentPlan == 'premium'
                ? LinearGradient(
                    colors: [
                      theme.colorScheme.primary,
                      theme.colorScheme.primary.withValues(alpha: 0.8),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  )
                : null,
            color: currentPlan == 'premium' ? null : theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: theme.colorScheme.primary, width: 2),
            boxShadow: [
              BoxShadow(
                color: theme.colorScheme.primary.withValues(alpha: 0.3),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Premium Plan',
                        style: theme.textTheme.titleLarge?.copyWith(
                          color: currentPlan == 'premium'
                              ? Colors.white
                              : theme.colorScheme.onSurface,
                        ),
                      ),
                      SizedBox(height: 0.5.h),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 2.w,
                          vertical: 0.3.h,
                        ),
                        decoration: BoxDecoration(
                          color: AppTheme.accentLight,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          'MOST POPULAR',
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: AppTheme.onAccentLight,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                  currentPlan == 'premium'
                      ? Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 3.w,
                            vertical: 0.5.h,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            'ACTIVE',
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: theme.colorScheme.primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        )
                      : const SizedBox.shrink(),
                ],
              ),
              SizedBox(height: 1.h),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '₦45,000',
                    style: theme.textTheme.headlineMedium?.copyWith(
                      color: currentPlan == 'premium'
                          ? Colors.white
                          : theme.colorScheme.primary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(width: 2.w),
                  Padding(
                    padding: EdgeInsets.only(bottom: 0.5.h),
                    child: Text(
                      '/year',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: currentPlan == 'premium'
                            ? Colors.white.withValues(alpha: 0.8)
                            : theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 0.5.h),
              Text(
                '₦3,750/month • Save ₦9,000 annually',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: currentPlan == 'premium'
                      ? Colors.white.withValues(alpha: 0.9)
                      : AppTheme.successLight,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 2.h),
              _buildFeatureItem(
                context,
                'Unlimited property listings',
                isPremium: currentPlan == 'premium',
              ),
              _buildFeatureItem(
                context,
                'Zero commission on all transactions',
                isPremium: currentPlan == 'premium',
              ),
              _buildFeatureItem(
                context,
                'Advanced AI contract tools',
                isPremium: currentPlan == 'premium',
              ),
              _buildFeatureItem(
                context,
                'Priority listing visibility',
                isPremium: currentPlan == 'premium',
              ),
              _buildFeatureItem(
                context,
                'Analytics dashboard',
                isPremium: currentPlan == 'premium',
              ),
              _buildFeatureItem(
                context,
                'Priority customer support',
                isPremium: currentPlan == 'premium',
              ),
              _buildFeatureItem(
                context,
                'Verified badge',
                isPremium: currentPlan == 'premium',
              ),
              SizedBox(height: 2.h),
              currentPlan == 'free'
                  ? SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: onUpgrade,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.accentLight,
                          foregroundColor: AppTheme.onAccentLight,
                          padding: EdgeInsets.symmetric(vertical: 1.5.h),
                        ),
                        child: Text(
                          'Upgrade to Premium',
                          style: theme.textTheme.labelLarge?.copyWith(
                            color: AppTheme.onAccentLight,
                          ),
                        ),
                      ),
                    )
                  : const SizedBox.shrink(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFeatureItem(
    BuildContext context,
    String text, {
    bool isPremium = false,
  }) {
    final theme = Theme.of(context);
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 0.5.h),
      child: Row(
        children: [
          CustomIconWidget(
            iconName: 'check_circle',
            color: isPremium ? Colors.white : AppTheme.successLight,
            size: 20,
          ),
          SizedBox(width: 2.w),
          Expanded(
            child: Text(
              text,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: isPremium ? Colors.white : theme.colorScheme.onSurface,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
