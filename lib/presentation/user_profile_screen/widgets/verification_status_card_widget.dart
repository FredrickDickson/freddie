import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

/// Verification status card showing KYC progress and trust score
class VerificationStatusCardWidget extends StatelessWidget {
  final Map<String, dynamic> verificationData;
  final VoidCallback onCompleteVerification;

  const VerificationStatusCardWidget({
    Key? key,
    required this.verificationData,
    required this.onCompleteVerification,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bool kycComplete = verificationData['kycComplete'] ?? false;
    final bool propertyVerified = verificationData['propertyVerified'] ?? false;
    final int trustScore = verificationData['trustScore'] ?? 0;

    return Card(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      child: Padding(
        padding: EdgeInsets.all(4.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Verification Status',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 2.h),
            _buildVerificationItem(
              context: context,
              title: 'KYC Verification',
              isComplete: kycComplete,
              icon: 'verified_user',
            ),
            SizedBox(height: 1.5.h),
            _buildVerificationItem(
              context: context,
              title: 'Property Ownership',
              isComplete: propertyVerified,
              icon: 'home_work',
            ),
            SizedBox(height: 2.h),
            Container(
              padding: EdgeInsets.all(3.w),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(2.w),
                    decoration: BoxDecoration(
                      color: _getTrustScoreColor(trustScore, theme),
                      shape: BoxShape.circle,
                    ),
                    child: CustomIconWidget(
                      iconName: 'shield',
                      color: theme.colorScheme.onPrimary,
                      size: 6.w,
                    ),
                  ),
                  SizedBox(width: 3.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Trust Score',
                          style: theme.textTheme.labelMedium?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                        SizedBox(height: 0.5.h),
                        Row(
                          children: [
                            Expanded(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(4),
                                child: LinearProgressIndicator(
                                  value: trustScore / 100,
                                  backgroundColor: theme.colorScheme.outline
                                      .withValues(alpha: 0.2),
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    _getTrustScoreColor(trustScore, theme),
                                  ),
                                  minHeight: 1.h,
                                ),
                              ),
                            ),
                            SizedBox(width: 2.w),
                            Text(
                              '$trustScore/100',
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                                color: _getTrustScoreColor(trustScore, theme),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            if (!kycComplete || !propertyVerified) ...[
              SizedBox(height: 2.h),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: onCompleteVerification,
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 1.5.h),
                  ),
                  child: Text('Complete Verification'),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildVerificationItem({
    required BuildContext context,
    required String title,
    required bool isComplete,
    required String icon,
  }) {
    final theme = Theme.of(context);

    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(2.w),
          decoration: BoxDecoration(
            color: isComplete
                ? theme.colorScheme.primary.withValues(alpha: 0.1)
                : theme.colorScheme.outline.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: CustomIconWidget(
            iconName: icon,
            color: isComplete
                ? theme.colorScheme.primary
                : theme.colorScheme.onSurfaceVariant,
            size: 5.w,
          ),
        ),
        SizedBox(width: 3.w),
        Expanded(child: Text(title, style: theme.textTheme.bodyLarge)),
        CustomIconWidget(
          iconName: isComplete ? 'check_circle' : 'radio_button_unchecked',
          color: isComplete
              ? theme.colorScheme.primary
              : theme.colorScheme.onSurfaceVariant,
          size: 5.w,
        ),
      ],
    );
  }

  Color _getTrustScoreColor(int score, ThemeData theme) {
    if (score >= 80) return theme.colorScheme.primary;
    if (score >= 50) return AppTheme.warningLight;
    return AppTheme.errorLight;
  }
}
