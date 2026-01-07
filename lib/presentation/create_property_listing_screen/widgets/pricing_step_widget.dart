import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class PricingStepWidget extends StatefulWidget {
  final String price;
  final String? rentalTerms;
  final String currency;
  final String? propertyType;
  final String? category;
  final String? location;
  final Function(String) onPriceChanged;
  final Function(String) onRentalTermsChanged;

  const PricingStepWidget({
    Key? key,
    required this.price,
    required this.rentalTerms,
    required this.currency,
    required this.propertyType,
    required this.category,
    required this.location,
    required this.onPriceChanged,
    required this.onRentalTermsChanged,
  }) : super(key: key);

  @override
  State<PricingStepWidget> createState() => _PricingStepWidgetState();
}

class _PricingStepWidgetState extends State<PricingStepWidget> {
  final TextEditingController _priceController = TextEditingController();
  bool _isLoadingAISuggestion = false;
  String? _aiSuggestedPrice;

  @override
  void initState() {
    super.initState();
    _priceController.text = widget.price;
    _priceController.addListener(() {
      widget.onPriceChanged(_priceController.text);
    });
  }

  @override
  void dispose() {
    _priceController.dispose();
    super.dispose();
  }

  Future<void> _getAIPriceSuggestion() async {
    setState(() {
      _isLoadingAISuggestion = true;
    });

    await Future.delayed(const Duration(seconds: 2));

    final basePrice = widget.category == 'Rent' ? 500000 : 25000000;
    final locationMultiplier = widget.location?.contains('Lagos') ?? false
        ? 1.5
        : 1.0;
    final typeMultiplier = widget.propertyType == 'House' ? 1.3 : 1.0;
    final suggestedPrice = (basePrice * locationMultiplier * typeMultiplier)
        .toInt();

    setState(() {
      _aiSuggestedPrice = suggestedPrice.toString();
      _isLoadingAISuggestion = false;
    });
  }

  void _applySuggestedPrice() {
    if (_aiSuggestedPrice != null) {
      _priceController.text = _aiSuggestedPrice!;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SingleChildScrollView(
      padding: EdgeInsets.all(4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Set your price',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            'Price your property competitively to attract more interest',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          SizedBox(height: 3.h),
          TextField(
            controller: _priceController,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            decoration: InputDecoration(
              labelText: widget.category == 'Rent'
                  ? 'Monthly Rent'
                  : widget.category == 'Sale'
                  ? 'Sale Price'
                  : 'Nightly Rate',
              prefixText: '${widget.currency} ',
              prefixStyle: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
              hintText: '0',
              suffixIcon: IconButton(
                icon: CustomIconWidget(
                  iconName: 'auto_awesome',
                  color: theme.colorScheme.primary,
                  size: 24,
                ),
                onPressed: _getAIPriceSuggestion,
              ),
            ),
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 2.h),
          if (_isLoadingAISuggestion)
            Container(
              padding: EdgeInsets.all(3.w),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                  SizedBox(width: 3.w),
                  Text(
                    'AI is analyzing market data...',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          if (_aiSuggestedPrice != null && !_isLoadingAISuggestion)
            Container(
              padding: EdgeInsets.all(3.w),
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: theme.colorScheme.primary, width: 1),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CustomIconWidget(
                        iconName: 'auto_awesome',
                        color: theme.colorScheme.primary,
                        size: 20,
                      ),
                      SizedBox(width: 2.w),
                      Text(
                        'AI Price Suggestion',
                        style: theme.textTheme.labelLarge?.copyWith(
                          color: theme.colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 1.h),
                  Text(
                    '${widget.currency} ${_formatPrice(_aiSuggestedPrice!)}',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                  SizedBox(height: 1.h),
                  Text(
                    'Based on ${widget.propertyType} properties in ${widget.location ?? "your area"}',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: _applySuggestedPrice,
                      child: Text('Apply Suggested Price'),
                    ),
                  ),
                ],
              ),
            ),
          if (widget.category == 'Rent') ...[
            SizedBox(height: 3.h),
            Text(
              'Rental Terms',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 2.h),
            _buildRentalTermsOptions(theme),
          ],
          SizedBox(height: 3.h),
          Container(
            padding: EdgeInsets.all(3.w),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CustomIconWidget(
                      iconName: 'info',
                      color: theme.colorScheme.onSurfaceVariant,
                      size: 20,
                    ),
                    SizedBox(width: 2.w),
                    Text(
                      'Pricing Information',
                      style: theme.textTheme.labelLarge?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 1.h),
                Text(
                  '• Free account: 5% commission on successful transactions\n• Premium account: Zero commission + unlimited listings',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRentalTermsOptions(ThemeData theme) {
    final terms = [
      {'value': 'Monthly', 'description': 'Pay monthly'},
      {'value': 'Quarterly', 'description': 'Pay every 3 months'},
      {'value': 'Annually', 'description': 'Pay yearly'},
    ];

    return Column(
      children: terms.map((term) {
        final isSelected = widget.rentalTerms == term['value'];

        return Padding(
          padding: EdgeInsets.only(bottom: 2.h),
          child: InkWell(
            onTap: () => widget.onRentalTermsChanged(term['value'] as String),
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: EdgeInsets.all(4.w),
              decoration: BoxDecoration(
                color: isSelected
                    ? theme.colorScheme.primary.withValues(alpha: 0.1)
                    : theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isSelected
                      ? theme.colorScheme.primary
                      : theme.colorScheme.outline,
                  width: isSelected ? 2 : 1,
                ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(2.w),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? theme.colorScheme.primary
                          : theme.colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: CustomIconWidget(
                      iconName: 'calendar_today',
                      color: isSelected
                          ? theme.colorScheme.onPrimary
                          : theme.colorScheme.onSurfaceVariant,
                      size: 20,
                    ),
                  ),
                  SizedBox(width: 3.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          term['value'] as String,
                          style: theme.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: isSelected
                                ? theme.colorScheme.primary
                                : theme.colorScheme.onSurface,
                          ),
                        ),
                        SizedBox(height: 0.5.h),
                        Text(
                          term['description'] as String,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (isSelected)
                    CustomIconWidget(
                      iconName: 'check_circle',
                      color: theme.colorScheme.primary,
                      size: 24,
                    ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  String _formatPrice(String price) {
    if (price.isEmpty) return '0';
    final number = int.tryParse(price) ?? 0;
    return number.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]},',
    );
  }
}
