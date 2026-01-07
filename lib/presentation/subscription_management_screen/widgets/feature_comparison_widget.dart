import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

/// Widget displaying feature comparison between Free and Premium plans
class FeatureComparisonWidget extends StatelessWidget {
  const FeatureComparisonWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final List<Map<String, dynamic>> features = [
      {
        "feature": "Property Listings",
        "free": "Up to 5",
        "premium": "Unlimited",
      },
      {"feature": "Transaction Commission", "free": "5%", "premium": "0%"},
      {
        "feature": "AI Contract Generation",
        "free": "Basic",
        "premium": "Advanced",
      },
      {
        "feature": "Listing Visibility",
        "free": "Standard",
        "premium": "Priority",
      },
      {"feature": "Analytics Dashboard", "free": false, "premium": true},
      {"feature": "Verified Badge", "free": false, "premium": true},
      {"feature": "Customer Support", "free": "Email", "premium": "Priority"},
      {"feature": "Property Boost", "free": "Paid", "premium": "Free"},
    ];

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.dividerColor),
      ),
      child: Column(
        children: [
          // Header Row
          Container(
            padding: EdgeInsets.all(3.w),
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withValues(alpha: 0.1),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Text(
                    'Feature',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Expanded(
                  child: Center(
                    child: Text(
                      'Free',
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Center(
                    child: Text(
                      'Premium',
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Feature Rows
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: features.length,
            separatorBuilder: (context, index) =>
                Divider(height: 1, color: theme.dividerColor),
            itemBuilder: (context, index) {
              final feature = features[index];
              return Container(
                padding: EdgeInsets.all(3.w),
                child: Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Text(
                        feature["feature"] as String,
                        style: theme.textTheme.bodyMedium,
                      ),
                    ),
                    Expanded(
                      child: Center(
                        child: _buildFeatureValue(
                          context,
                          feature["free"],
                          false,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Center(
                        child: _buildFeatureValue(
                          context,
                          feature["premium"],
                          true,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureValue(
    BuildContext context,
    dynamic value,
    bool isPremium,
  ) {
    final theme = Theme.of(context);

    if (value is bool) {
      return CustomIconWidget(
        iconName: value ? 'check_circle' : 'cancel',
        color: value
            ? (isPremium ? theme.colorScheme.primary : AppTheme.successLight)
            : theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
        size: 20,
      );
    }

    return Text(
      value.toString(),
      style: theme.textTheme.bodyMedium?.copyWith(
        color: isPremium
            ? theme.colorScheme.primary
            : theme.colorScheme.onSurface,
        fontWeight: isPremium ? FontWeight.w600 : FontWeight.w400,
      ),
      textAlign: TextAlign.center,
    );
  }
}
