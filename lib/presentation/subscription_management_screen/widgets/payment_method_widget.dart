import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

/// Widget displaying available payment methods for subscription
class PaymentMethodWidget extends StatefulWidget {
  const PaymentMethodWidget({Key? key}) : super(key: key);

  @override
  State<PaymentMethodWidget> createState() => _PaymentMethodWidgetState();
}

class _PaymentMethodWidgetState extends State<PaymentMethodWidget> {
  String _selectedMethod = 'paystack';

  final List<Map<String, dynamic>> _paymentMethods = [
    {
      "id": "paystack",
      "name": "Paystack",
      "description": "Pay with card via Paystack",
      "icon": "payment",
      "supported": ["Visa", "Mastercard", "Verve"],
    },
    {
      "id": "flutterwave",
      "name": "Flutterwave",
      "description": "Pay with card via Flutterwave",
      "icon": "credit_card",
      "supported": ["Visa", "Mastercard", "Verve"],
    },
    {
      "id": "bank_transfer",
      "name": "Bank Transfer",
      "description": "Direct bank transfer",
      "icon": "account_balance",
      "supported": ["All Nigerian Banks"],
    },
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.dividerColor),
      ),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(4.w),
            child: Row(
              children: [
                CustomIconWidget(
                  iconName: 'lock',
                  color: AppTheme.successLight,
                  size: 20,
                ),
                SizedBox(width: 2.w),
                Expanded(
                  child: Text(
                    'All payments are secure and encrypted',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.successLight,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Divider(height: 1, color: theme.dividerColor),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _paymentMethods.length,
            separatorBuilder: (context, index) =>
                Divider(height: 1, color: theme.dividerColor),
            itemBuilder: (context, index) {
              final method = _paymentMethods[index];
              final isSelected = _selectedMethod == method["id"];

              return InkWell(
                onTap: () {
                  setState(() => _selectedMethod = method["id"] as String);
                },
                child: Container(
                  padding: EdgeInsets.all(4.w),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? theme.colorScheme.primary.withValues(alpha: 0.05)
                        : Colors.transparent,
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 12.w,
                        height: 12.w,
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primary.withValues(
                            alpha: 0.1,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Center(
                          child: CustomIconWidget(
                            iconName: method["icon"] as String,
                            color: theme.colorScheme.primary,
                            size: 24,
                          ),
                        ),
                      ),
                      SizedBox(width: 3.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              method["name"] as String,
                              style: theme.textTheme.titleMedium,
                            ),
                            SizedBox(height: 0.3.h),
                            Text(
                              method["description"] as String,
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                            SizedBox(height: 0.5.h),
                            Wrap(
                              spacing: 1.w,
                              children: (method["supported"] as List<String>)
                                  .map(
                                    (card) => Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 2.w,
                                        vertical: 0.2.h,
                                      ),
                                      decoration: BoxDecoration(
                                        color: theme.colorScheme.surface,
                                        borderRadius: BorderRadius.circular(4),
                                        border: Border.all(
                                          color: theme.dividerColor,
                                        ),
                                      ),
                                      child: Text(
                                        card,
                                        style: theme.textTheme.labelSmall,
                                      ),
                                    ),
                                  )
                                  .toList(),
                            ),
                          ],
                        ),
                      ),
                      Radio<String>(
                        value: method["id"] as String,
                        groupValue: _selectedMethod,
                        onChanged: (value) {
                          setState(() => _selectedMethod = value!);
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
