import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../widgets/custom_icon_widget.dart';
import './widgets/feature_comparison_widget.dart';
import './widgets/payment_method_widget.dart';
import './widgets/subscription_plan_card_widget.dart';
import './widgets/transaction_history_widget.dart';

/// Subscription Management Screen handles premium account upgrades and billing
/// with secure mobile payment integration.
class SubscriptionManagementScreen extends StatefulWidget {
  const SubscriptionManagementScreen({Key? key}) : super(key: key);

  @override
  State<SubscriptionManagementScreen> createState() =>
      _SubscriptionManagementScreenState();
}

class _SubscriptionManagementScreenState
    extends State<SubscriptionManagementScreen> {
  bool _isProcessing = false;
  bool _autoRenewal = true;
  String _currentPlan = 'free'; // 'free' or 'premium'
  DateTime? _renewalDate;

  // Mock subscription data
  final Map<String, dynamic> _subscriptionData = {
    "currentPlan": "free",
    "renewalDate": DateTime.now().add(const Duration(days: 30)),
    "isActive": false,
    "remainingListings": 3,
    "totalListings": 5,
  };

  // Mock transaction history
  final List<Map<String, dynamic>> _transactionHistory = [
    {
      "id": "TXN001",
      "date": DateTime.now().subtract(const Duration(days: 365)),
      "amount": "₦45,000",
      "status": "Completed",
      "description": "Annual Premium Subscription",
      "paymentMethod": "Paystack",
    },
    {
      "id": "TXN002",
      "date": DateTime.now().subtract(const Duration(days: 730)),
      "amount": "₦45,000",
      "status": "Completed",
      "description": "Annual Premium Subscription",
      "paymentMethod": "Flutterwave",
    },
  ];

  @override
  void initState() {
    super.initState();
    _currentPlan = _subscriptionData["currentPlan"] as String;
    _renewalDate = _subscriptionData["renewalDate"] as DateTime?;
  }

  Future<void> _handleUpgrade() async {
    setState(() => _isProcessing = true);

    // Simulate payment processing
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isProcessing = false;
      _currentPlan = 'premium';
      _renewalDate = DateTime.now().add(const Duration(days: 365));
      _subscriptionData["currentPlan"] = 'premium';
      _subscriptionData["isActive"] = true;
    });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Successfully upgraded to Premium!'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 3),
        ),
      );
    }
  }

  Future<void> _handleCancellation() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cancel Subscription'),
        content: const Text(
          'Are you sure you want to cancel your premium subscription? You will lose access to premium features at the end of your billing period.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Keep Premium'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Cancel Subscription'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      setState(() {
        _autoRenewal = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Subscription cancelled. You will retain premium access until the end of your billing period.',
            ),
            duration: Duration(seconds: 3),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          'Subscription Management',
          style: theme.appBarTheme.titleTextStyle,
        ),
        leading: IconButton(
          icon: CustomIconWidget(
            iconName: 'arrow_back',
            color: theme.appBarTheme.foregroundColor ?? theme.primaryColor,
            size: 24,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: CustomIconWidget(
              iconName: 'help_outline',
              color: theme.appBarTheme.foregroundColor ?? theme.primaryColor,
              size: 24,
            ),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Contact support for billing assistance'),
                  duration: Duration(seconds: 2),
                ),
              );
            },
          ),
        ],
      ),
      body: _isProcessing
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(color: theme.colorScheme.primary),
                  SizedBox(height: 2.h),
                  Text(
                    'Processing payment...',
                    style: theme.textTheme.bodyLarge,
                  ),
                ],
              ),
            )
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Current Plan Status
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(4.w),
                    margin: EdgeInsets.all(4.w),
                    decoration: BoxDecoration(
                      color: _currentPlan == 'premium'
                          ? theme.colorScheme.primary.withValues(alpha: 0.1)
                          : theme.colorScheme.surface,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: _currentPlan == 'premium'
                            ? theme.colorScheme.primary
                            : theme.dividerColor,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Current Plan',
                              style: theme.textTheme.titleMedium,
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 3.w,
                                vertical: 0.5.h,
                              ),
                              decoration: BoxDecoration(
                                color: _currentPlan == 'premium'
                                    ? theme.colorScheme.primary
                                    : theme.colorScheme.onSurfaceVariant,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                _currentPlan == 'premium' ? 'PREMIUM' : 'FREE',
                                style: theme.textTheme.labelSmall?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 1.h),
                        _currentPlan == 'premium'
                            ? Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Renewal Date: ${_renewalDate != null ? "${_renewalDate!.day}/${_renewalDate!.month}/${_renewalDate!.year}" : "N/A"}',
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      color: theme.colorScheme.onSurfaceVariant,
                                    ),
                                  ),
                                  SizedBox(height: 1.h),
                                  Row(
                                    children: [
                                      Text(
                                        'Auto-renewal',
                                        style: theme.textTheme.bodyMedium,
                                      ),
                                      const Spacer(),
                                      Switch(
                                        value: _autoRenewal,
                                        onChanged: (value) {
                                          if (!value) {
                                            _handleCancellation();
                                          } else {
                                            setState(
                                              () => _autoRenewal = value,
                                            );
                                          }
                                        },
                                      ),
                                    ],
                                  ),
                                ],
                              )
                            : Text(
                                'Remaining Listings: ${_subscriptionData["remainingListings"]}/${_subscriptionData["totalListings"]}',
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: theme.colorScheme.onSurfaceVariant,
                                ),
                              ),
                      ],
                    ),
                  ),

                  // Subscription Plans
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 4.w),
                    child: Text(
                      'Choose Your Plan',
                      style: theme.textTheme.titleLarge,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  SubscriptionPlanCardWidget(
                    currentPlan: _currentPlan,
                    onUpgrade: _handleUpgrade,
                  ),

                  SizedBox(height: 3.h),

                  // Feature Comparison
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 4.w),
                    child: Text(
                      'Feature Comparison',
                      style: theme.textTheme.titleLarge,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  const FeatureComparisonWidget(),

                  SizedBox(height: 3.h),

                  // Payment Methods
                  _currentPlan == 'free'
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 4.w),
                              child: Text(
                                'Payment Methods',
                                style: theme.textTheme.titleLarge,
                              ),
                            ),
                            SizedBox(height: 2.h),
                            const PaymentMethodWidget(),
                            SizedBox(height: 3.h),
                          ],
                        )
                      : const SizedBox.shrink(),

                  // Transaction History
                  _currentPlan == 'premium'
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 4.w),
                              child: Text(
                                'Transaction History',
                                style: theme.textTheme.titleLarge,
                              ),
                            ),
                            SizedBox(height: 2.h),
                            TransactionHistoryWidget(
                              transactions: _transactionHistory,
                            ),
                          ],
                        )
                      : const SizedBox.shrink(),

                  SizedBox(height: 4.h),
                ],
              ),
            ),
    );
  }
}
