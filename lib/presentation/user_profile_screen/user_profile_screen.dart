import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../widgets/custom_app_bar.dart';
import './widgets/account_settings_card_widget.dart';
import './widgets/help_support_card_widget.dart';
import './widgets/my_listings_card_widget.dart';
import './widgets/personal_info_card_widget.dart';
import './widgets/premium_upgrade_card_widget.dart';
import './widgets/profile_header_widget.dart';
import './widgets/transaction_history_card_widget.dart';
import './widgets/verification_status_card_widget.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({Key? key}) : super(key: key);

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  // Mock user data
  final Map<String, dynamic> _userData = {
    'name': 'Chinedu Okafor',
    'email': 'chinedu.okafor@example.com',
    'phone': '+234 803 456 7890',
    'avatar':
        'https://img.rocket.new/generatedImages/rocket_gen_img_1192981a2-1763292809719.png',
    'avatarDescription':
        'Professional headshot of a Nigerian man with short black hair wearing a navy blue shirt',
    'accountType': 'Free',
    'isVerified': true,
  };

  final Map<String, dynamic> _verificationData = {
    'kycComplete': true,
    'propertyVerified': false,
    'trustScore': 75,
  };

  final Map<String, dynamic> _settingsData = {
    'subscriptionType': 'Free Plan',
    'pushNotifications': true,
    'emailNotifications': true,
    'smsNotifications': false,
    'darkMode': false,
    'biometricAuth': false,
  };

  final int _listingCount = 3;

  final List<Map<String, dynamic>> _recentTransactions = [
    {
      'type': 'debit',
      'description': 'Commission Payment',
      'amount': '15,000',
      'date': '05 Jan 2026',
    },
    {
      'type': 'credit',
      'description': 'Property Listing Fee Refund',
      'amount': '5,000',
      'date': '03 Jan 2026',
    },
    {
      'type': 'debit',
      'description': 'Listing Boost Payment',
      'amount': '10,000',
      'date': '01 Jan 2026',
    },
  ];

  void _handleEditAvatar() {
    Fluttertoast.showToast(
      msg: 'Avatar editing feature coming soon',
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
    );
  }

  void _handleUpdatePersonalInfo(Map<String, dynamic> updatedData) {
    setState(() {
      _userData['name'] = updatedData['name'];
      _userData['email'] = updatedData['email'];
      _userData['phone'] = updatedData['phone'];
    });
    Fluttertoast.showToast(
      msg: 'Personal information updated successfully',
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
    );
  }

  void _handleCompleteVerification() {
    Navigator.of(
      context,
      rootNavigator: true,
    ).pushNamed('/kyc-verification-screen');
  }

  void _handleToggleSetting(String key, bool value) {
    setState(() {
      _settingsData[key] = value;
    });
    Fluttertoast.showToast(
      msg: 'Setting updated',
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
    );
  }

  void _handleManageSubscription() {
    Navigator.of(
      context,
      rootNavigator: true,
    ).pushNamed('/subscription-management-screen');
  }

  void _handleViewListings() {
    Navigator.of(
      context,
      rootNavigator: true,
    ).pushNamed('/create-property-listing-screen');
  }

  void _handleViewAllTransactions() {
    Fluttertoast.showToast(
      msg: 'Transaction history feature coming soon',
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
    );
  }

  void _handleUpgradeToPremium() {
    Navigator.of(
      context,
      rootNavigator: true,
    ).pushNamed('/subscription-management-screen');
  }

  void _handleFAQ() {
    Fluttertoast.showToast(
      msg: 'FAQ feature coming soon',
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
    );
  }

  void _handleCustomerSupport() {
    Navigator.of(context, rootNavigator: true).pushNamed('/messaging-screen');
  }

  void _handleLogout() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.of(
                context,
                rootNavigator: true,
              ).pushNamedAndRemoveUntil(
                '/authentication-screen',
                (route) => false,
              );
            },
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }

  void _handleDeleteAccount() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Account'),
        content: const Text(
          'Are you sure you want to delete your account? This action cannot be undone and all your data will be permanently removed.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Fluttertoast.showToast(
                msg: 'Account deletion requires security verification',
                toastLength: Toast.LENGTH_LONG,
                gravity: ToastGravity.BOTTOM,
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.errorLight,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bool isPremium = _userData['accountType'] == 'Premium';

    return Column(
      children: [
        CustomAppBar(
          title: 'Profile',
          centerTitle: true,
          actions: [
            IconButton(
              onPressed: () {
                Fluttertoast.showToast(
                  msg: 'Settings feature coming soon',
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                );
              },
              icon: CustomIconWidget(
                iconName: 'settings',
                color: theme.colorScheme.onSurface,
                size: 6.w,
              ),
            ),
          ],
        ),
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                ProfileHeaderWidget(
                  userData: _userData,
                  onEditAvatar: _handleEditAvatar,
                ),
                SizedBox(height: 2.h),
                PersonalInfoCardWidget(
                  userData: _userData,
                  onUpdate: _handleUpdatePersonalInfo,
                ),
                VerificationStatusCardWidget(
                  verificationData: _verificationData,
                  onCompleteVerification: _handleCompleteVerification,
                ),
                AccountSettingsCardWidget(
                  settingsData: _settingsData,
                  onToggleSetting: _handleToggleSetting,
                  onManageSubscription: _handleManageSubscription,
                ),
                MyListingsCardWidget(
                  listingCount: _listingCount,
                  onViewListings: _handleViewListings,
                ),
                TransactionHistoryCardWidget(
                  recentTransactions: _recentTransactions,
                  onViewAll: _handleViewAllTransactions,
                ),
                if (!isPremium)
                  PremiumUpgradeCardWidget(onUpgrade: _handleUpgradeToPremium),
                HelpSupportCardWidget(
                  onFAQ: _handleFAQ,
                  onCustomerSupport: _handleCustomerSupport,
                ),
                Card(
                  margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
                  child: Column(
                    children: [
                      ListTile(
                        leading: Container(
                          padding: EdgeInsets.all(2.w),
                          decoration: BoxDecoration(
                            color: AppTheme.errorLight.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: CustomIconWidget(
                            iconName: 'logout',
                            color: AppTheme.errorLight,
                            size: 5.w,
                          ),
                        ),
                        title: Text(
                          'Logout',
                          style: theme.textTheme.bodyLarge?.copyWith(
                            color: AppTheme.errorLight,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        trailing: CustomIconWidget(
                          iconName: 'chevron_right',
                          color: theme.colorScheme.onSurfaceVariant,
                          size: 5.w,
                        ),
                        onTap: _handleLogout,
                      ),
                      Divider(height: 1),
                      ListTile(
                        leading: Container(
                          padding: EdgeInsets.all(2.w),
                          decoration: BoxDecoration(
                            color: AppTheme.errorLight.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: CustomIconWidget(
                            iconName: 'delete_forever',
                            color: AppTheme.errorLight,
                            size: 5.w,
                          ),
                        ),
                        title: Text(
                          'Delete Account',
                          style: theme.textTheme.bodyLarge?.copyWith(
                            color: AppTheme.errorLight,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        trailing: CustomIconWidget(
                          iconName: 'chevron_right',
                          color: theme.colorScheme.onSurfaceVariant,
                          size: 5.w,
                        ),
                        onTap: _handleDeleteAccount,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 2.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4.w),
                  child: Text(
                    'Version 1.0.0',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
                SizedBox(height: 2.h),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
