import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

/// Transaction history card showing recent activity
class TransactionHistoryCardWidget extends StatelessWidget {
  final List<Map<String, dynamic>> recentTransactions;
  final VoidCallback onViewAll;

  const TransactionHistoryCardWidget({
    Key? key,
    required this.recentTransactions,
    required this.onViewAll,
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Transaction History',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                TextButton(onPressed: onViewAll, child: Text('View All')),
              ],
            ),
            SizedBox(height: 2.h),
            recentTransactions.isEmpty
                ? _buildEmptyState(context)
                : ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: recentTransactions.length > 3
                        ? 3
                        : recentTransactions.length,
                    separatorBuilder: (context, index) => Divider(height: 2.h),
                    itemBuilder: (context, index) {
                      final transaction = recentTransactions[index];
                      return _buildTransactionItem(context, transaction);
                    },
                  ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 3.h),
        child: Column(
          children: [
            CustomIconWidget(
              iconName: 'receipt_long',
              color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
              size: 12.w,
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
      ),
    );
  }

  Widget _buildTransactionItem(
    BuildContext context,
    Map<String, dynamic> transaction,
  ) {
    final theme = Theme.of(context);
    final String type = transaction['type'] ?? '';
    final bool isCredit = type == 'credit';

    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(2.w),
          decoration: BoxDecoration(
            color: isCredit
                ? theme.colorScheme.primary.withValues(alpha: 0.1)
                : AppTheme.errorLight.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: CustomIconWidget(
            iconName: isCredit ? 'arrow_downward' : 'arrow_upward',
            color: isCredit ? theme.colorScheme.primary : AppTheme.errorLight,
            size: 5.w,
          ),
        ),
        SizedBox(width: 3.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                transaction['description'] ?? 'Transaction',
                style: theme.textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 0.5.h),
              Text(
                transaction['date'] ?? '',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
        Text(
          '${isCredit ? '+' : '-'}₦${transaction['amount'] ?? '0'}',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: isCredit ? theme.colorScheme.primary : AppTheme.errorLight,
          ),
        ),
      ],
    );
  }
}
