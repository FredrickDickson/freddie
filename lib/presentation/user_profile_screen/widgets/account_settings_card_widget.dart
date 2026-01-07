import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

/// Account settings card with subscription, notifications, and privacy controls
class AccountSettingsCardWidget extends StatelessWidget {
  final Map<String, dynamic> settingsData;
  final Function(String, bool) onToggleSetting;
  final VoidCallback onManageSubscription;

  const AccountSettingsCardWidget({
    Key? key,
    required this.settingsData,
    required this.onToggleSetting,
    required this.onManageSubscription,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      child: Padding(
        padding: EdgeInsets.all(4.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Account Settings',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 2.h),
            _buildSettingItem(
              context: context,
              title: 'Subscription',
              subtitle: settingsData['subscriptionType'] ?? 'Free Plan',
              icon: 'card_membership',
              trailing: TextButton(
                onPressed: onManageSubscription,
                child: Text('Manage'),
              ),
            ),
            Divider(height: 3.h),
            _buildToggleItem(
              context: context,
              title: 'Push Notifications',
              subtitle: 'Receive alerts for messages and bookings',
              icon: 'notifications',
              value: settingsData['pushNotifications'] ?? true,
              onChanged: (value) => onToggleSetting('pushNotifications', value),
            ),
            Divider(height: 3.h),
            _buildToggleItem(
              context: context,
              title: 'Email Notifications',
              subtitle: 'Receive updates via email',
              icon: 'email',
              value: settingsData['emailNotifications'] ?? true,
              onChanged: (value) =>
                  onToggleSetting('emailNotifications', value),
            ),
            Divider(height: 3.h),
            _buildToggleItem(
              context: context,
              title: 'SMS Notifications',
              subtitle: 'Receive SMS alerts',
              icon: 'sms',
              value: settingsData['smsNotifications'] ?? false,
              onChanged: (value) => onToggleSetting('smsNotifications', value),
            ),
            Divider(height: 3.h),
            _buildToggleItem(
              context: context,
              title: 'Dark Mode',
              subtitle: 'Use dark theme',
              icon: 'dark_mode',
              value: settingsData['darkMode'] ?? false,
              onChanged: (value) => onToggleSetting('darkMode', value),
            ),
            Divider(height: 3.h),
            _buildToggleItem(
              context: context,
              title: 'Biometric Authentication',
              subtitle: 'Use fingerprint or face recognition',
              icon: 'fingerprint',
              value: settingsData['biometricAuth'] ?? false,
              onChanged: (value) => onToggleSetting('biometricAuth', value),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingItem({
    required BuildContext context,
    required String title,
    required String subtitle,
    required String icon,
    required Widget trailing,
  }) {
    final theme = Theme.of(context);

    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(2.w),
          decoration: BoxDecoration(
            color: theme.colorScheme.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: CustomIconWidget(
            iconName: icon,
            color: theme.colorScheme.primary,
            size: 5.w,
          ),
        ),
        SizedBox(width: 3.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: theme.textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 0.5.h),
              Text(
                subtitle,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
        trailing,
      ],
    );
  }

  Widget _buildToggleItem({
    required BuildContext context,
    required String title,
    required String subtitle,
    required String icon,
    required bool value,
    required Function(bool) onChanged,
  }) {
    final theme = Theme.of(context);

    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(2.w),
          decoration: BoxDecoration(
            color: theme.colorScheme.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: CustomIconWidget(
            iconName: icon,
            color: theme.colorScheme.primary,
            size: 5.w,
          ),
        ),
        SizedBox(width: 3.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: theme.textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 0.5.h),
              Text(
                subtitle,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
        Switch(value: value, onChanged: onChanged),
      ],
    );
  }
}
