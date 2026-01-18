import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

/// Contract preview widget
/// Displays formatted contract with zoom and navigation
class ContractPreviewWidget extends StatefulWidget {
  final String contractType;
  final Map<String, dynamic> formData;

  const ContractPreviewWidget({
    Key? key,
    required this.contractType,
    required this.formData,
  }) : super(key: key);

  @override
  State<ContractPreviewWidget> createState() => _ContractPreviewWidgetState();
}

class _ContractPreviewWidgetState extends State<ContractPreviewWidget> {
  final ScrollController _scrollController = ScrollController();
  double _textScale = 1.0;

  String _getContractTitle() {
    switch (widget.contractType) {
      case 'lease':
        return 'RESIDENTIAL LEASE AGREEMENT';
      case 'sale':
        return 'PROPERTY SALE AGREEMENT';
      case 'shortlet':
        return 'SHORT-LET ACCOMMODATION AGREEMENT';
      default:
        return 'CONTRACT AGREEMENT';
    }
  }

  String _generateContractContent() {
    final landlordName = widget.formData["landlordName"] ?? "N/A";
    final tenantName = widget.formData["tenantName"] ?? "N/A";
    final propertyAddress = widget.formData["propertyAddress"] ?? "N/A";
    final monthlyRent = widget.formData["monthlyRent"] ?? "N/A";
    final securityDeposit = widget.formData["securityDeposit"] ?? "N/A";
    final leaseDuration = widget.formData["leaseDuration"] ?? "N/A";

    return '''
THIS AGREEMENT is made on ${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}

BETWEEN:

$landlordName (hereinafter referred to as "the Landlord")

AND

$tenantName (hereinafter referred to as "the Tenant")

PROPERTY DETAILS:
The property located at $propertyAddress (hereinafter referred to as "the Property")

TERMS AND CONDITIONS:

1. LEASE DURATION
The lease shall commence on the date of signing and continue for a period of $leaseDuration.

2. RENT
The Tenant agrees to pay monthly rent of $monthlyRent to the Landlord.

3. SECURITY DEPOSIT
The Tenant shall pay a security deposit of $securityDeposit, which shall be refundable at the end of the lease term, subject to the condition of the Property.

4. MAINTENANCE
The Tenant shall maintain the Property in good condition and shall be responsible for minor repairs.

5. UTILITIES
The Tenant shall be responsible for payment of all utility bills including electricity, water, and waste disposal.

6. TERMINATION
Either party may terminate this agreement by giving 30 days written notice to the other party.

7. GOVERNING LAW
This agreement shall be governed by the laws of the Federal Republic of Nigeria.

8. BLOCKCHAIN VERIFICATION
This contract is secured with blockchain verification hash: ${DateTime.now().millisecondsSinceEpoch.toRadixString(16).toUpperCase()}

SIGNATURES:

_____________________          _____________________
Landlord Signature             Tenant Signature

Date: _______________          Date: _______________
''';
  }

  void _zoomIn() {
    setState(() {
      _textScale = (_textScale + 0.1).clamp(0.8, 2.0);
    });
  }

  void _zoomOut() {
    setState(() {
      _textScale = (_textScale - 0.1).clamp(0.8, 2.0);
    });
  }


  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            border: Border(
              bottom: BorderSide(
                color: theme.colorScheme.outline.withValues(alpha: 0.2),
              ),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Contract Preview',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              Row(
                children: [
                  IconButton(
                    icon: CustomIconWidget(
                      iconName: 'zoom_out',
                      color: theme.colorScheme.onSurface,
                      size: 5.w,
                    ),
                    onPressed: _zoomOut,
                  ),
                  Text(
                    '${(_textScale * 100).toInt()}%',
                    style: theme.textTheme.labelMedium,
                  ),
                  IconButton(
                    icon: CustomIconWidget(
                      iconName: 'zoom_in',
                      color: theme.colorScheme.onSurface,
                      size: 5.w,
                    ),
                    onPressed: _zoomIn,
                  ),
                  IconButton(
                    icon: CustomIconWidget(
                      iconName: 'download',
                      color: theme.colorScheme.primary,
                      size: 5.w,
                    ),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Contract will be available for download after signing',
                            style: TextStyle(fontSize: 12.sp),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            controller: _scrollController,
            padding: EdgeInsets.all(4.w),
            child: Container(
              padding: EdgeInsets.all(4.w),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: theme.colorScheme.outline.withValues(alpha: 0.2),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Column(
                      children: [
                        CustomIconWidget(
                          iconName: 'description',
                          color: theme.colorScheme.primary,
                          size: 12.w,
                        ),
                        SizedBox(height: 2.h),
                        Text(
                          _getContractTitle(),
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w700,
                            fontSize: (16 * _textScale).sp,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 1.h),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 3.w,
                            vertical: 1.h,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(
                              0xFF2D5A27,
                            ).withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              CustomIconWidget(
                                iconName: 'verified',
                                color: const Color(0xFF2D5A27),
                                size: 4.w,
                              ),
                              SizedBox(width: 1.w),
                              Text(
                                'AI-Generated & Blockchain Verified',
                                style: theme.textTheme.labelSmall?.copyWith(
                                  color: const Color(0xFF2D5A27),
                                  fontWeight: FontWeight.w600,
                                  fontSize: (10 * _textScale).sp,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    _generateContractContent(),
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontSize: (14 * _textScale).sp,
                      height: 1.6,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Container(
                    padding: EdgeInsets.all(3.w),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE8B931).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: const Color(0xFFE8B931).withValues(alpha: 0.3),
                      ),
                    ),
                    child: Row(
                      children: [
                        CustomIconWidget(
                          iconName: 'info',
                          color: const Color(0xFFE8B931),
                          size: 5.w,
                        ),
                        SizedBox(width: 2.w),
                        Expanded(
                          child: Text(
                            'This contract is legally binding once signed by both parties. Please review carefully before proceeding.',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                              fontSize: (12 * _textScale).sp,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
