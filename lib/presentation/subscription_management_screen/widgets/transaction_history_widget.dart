import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

/// Widget displaying transaction history for premium subscriptions
class TransactionHistoryWidget extends StatelessWidget {
  final List<Map<String, dynamic>> transactions;

  const TransactionHistoryWidget({Key? key, required this.transactions})
    : super(key: key);

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
      child: transactions.isEmpty
          ? Padding(
              padding: EdgeInsets.all(8.w),
              child: Column(
                children: [
                  CustomIconWidget(
                    iconName: 'receipt_long',
                    color: theme.colorScheme.onSurfaceVariant.withValues(
                      alpha: 0.5,
                    ),
                    size: 48,
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    'No transactions yet',
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            )
          : ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: transactions.length,
              separatorBuilder: (context, index) =>
                  Divider(height: 1, color: theme.dividerColor),
              itemBuilder: (context, index) {
                final transaction = transactions[index];
                final date = transaction["date"] as DateTime;
                final status = transaction["status"] as String;

                return InkWell(
                  onTap: () {
                    _showTransactionDetails(context, transaction);
                  },
                  child: Padding(
                    padding: EdgeInsets.all(4.w),
                    child: Row(
                      children: [
                        Container(
                          width: 12.w,
                          height: 12.w,
                          decoration: BoxDecoration(
                            color: status == 'Completed'
                                ? AppTheme.successLight.withValues(alpha: 0.1)
                                : AppTheme.warningLight.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Center(
                            child: CustomIconWidget(
                              iconName: status == 'Completed'
                                  ? 'check_circle'
                                  : 'pending',
                              color: status == 'Completed'
                                  ? AppTheme.successLight
                                  : AppTheme.warningLight,
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
                                transaction["description"] as String,
                                style: theme.textTheme.titleMedium,
                              ),
                              SizedBox(height: 0.3.h),
                              Text(
                                '${date.day}/${date.month}/${date.year} • ${transaction["paymentMethod"]}',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: theme.colorScheme.onSurfaceVariant,
                                ),
                              ),
                              SizedBox(height: 0.3.h),
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 2.w,
                                  vertical: 0.2.h,
                                ),
                                decoration: BoxDecoration(
                                  color: status == 'Completed'
                                      ? AppTheme.successLight.withValues(
                                          alpha: 0.1,
                                        )
                                      : AppTheme.warningLight.withValues(
                                          alpha: 0.1,
                                        ),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  status,
                                  style: theme.textTheme.labelSmall?.copyWith(
                                    color: status == 'Completed'
                                        ? AppTheme.successLight
                                        : AppTheme.warningLight,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              transaction["amount"] as String,
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(height: 0.5.h),
                            CustomIconWidget(
                              iconName: 'chevron_right',
                              color: theme.colorScheme.onSurfaceVariant,
                              size: 20,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }

  void _showTransactionDetails(
    BuildContext context,
    Map<String, dynamic> transaction,
  ) {
    final theme = Theme.of(context);
    final date = transaction["date"] as DateTime;

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.all(6.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Transaction Details', style: theme.textTheme.titleLarge),
                IconButton(
                  icon: CustomIconWidget(
                    iconName: 'close',
                    color: theme.colorScheme.onSurface,
                    size: 24,
                  ),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
            SizedBox(height: 2.h),
            _buildDetailRow(
              context,
              'Transaction ID',
              transaction["id"] as String,
            ),
            _buildDetailRow(
              context,
              'Description',
              transaction["description"] as String,
            ),
            _buildDetailRow(context, 'Amount', transaction["amount"] as String),
            _buildDetailRow(
              context,
              'Date',
              '${date.day}/${date.month}/${date.year}',
            ),
            _buildDetailRow(
              context,
              'Payment Method',
              transaction["paymentMethod"] as String,
            ),
            _buildDetailRow(context, 'Status', transaction["status"] as String),
            SizedBox(height: 3.h),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () {
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Receipt downloaded successfully'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                },
                icon: CustomIconWidget(
                  iconName: 'download',
                  color: theme.colorScheme.primary,
                  size: 20,
                ),
                label: const Text('Download Receipt'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(BuildContext context, String label, String value) {
    final theme = Theme.of(context);
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 1.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          Text(
            value,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
