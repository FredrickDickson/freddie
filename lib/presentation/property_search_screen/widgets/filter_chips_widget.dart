import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class FilterChipsWidget extends StatelessWidget {
  final Map<String, dynamic> activeFilters;
  final VoidCallback onFilterTap;
  final ValueChanged<String> onChipRemoved;

  const FilterChipsWidget({
    Key? key,
    required this.activeFilters,
    required this.onFilterTap,
    required this.onChipRemoved,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final List<Map<String, dynamic>> quickFilters = [
      {
        'key': 'propertyType',
        'label': 'Property Type',
        'icon': 'home',
        'value': activeFilters['propertyType'],
      },
      {
        'key': 'priceRange',
        'label': 'Price Range',
        'icon': 'payments',
        'value': _getPriceRangeLabel(),
      },
      {
        'key': 'location',
        'label': 'Location',
        'icon': 'location_on',
        'value': activeFilters['location'],
      },
      {
        'key': 'bedrooms',
        'label': 'Bedrooms',
        'icon': 'bed',
        'value': activeFilters['bedrooms'] != null
            ? '${activeFilters['bedrooms']} BR'
            : null,
      },
    ];

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border(
          bottom: BorderSide(
            color: theme.colorScheme.outline.withValues(alpha: 0.2),
            width: 1,
          ),
        ),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            // Quick filter chips
            ...quickFilters.map((filter) {
              final isActive = filter['value'] != null;
              return Padding(
                padding: EdgeInsets.only(right: 2.w),
                child: FilterChip(
                  label: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CustomIconWidget(
                        iconName: filter['icon'] as String,
                        size: 16,
                        color: isActive
                            ? theme.colorScheme.onPrimary
                            : theme.colorScheme.onSurfaceVariant,
                      ),
                      SizedBox(width: 1.w),
                      Text(
                        isActive
                            ? filter['value'].toString()
                            : filter['label'] as String,
                        style: theme.textTheme.labelMedium?.copyWith(
                          color: isActive
                              ? theme.colorScheme.onPrimary
                              : theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                      if (isActive) ...[
                        SizedBox(width: 1.w),
                        CustomIconWidget(
                          iconName: 'close',
                          size: 14,
                          color: theme.colorScheme.onPrimary,
                        ),
                      ],
                    ],
                  ),
                  selected: isActive,
                  onSelected: (selected) {
                    if (isActive) {
                      onChipRemoved(filter['key'] as String);
                    } else {
                      onFilterTap();
                    }
                  },
                  backgroundColor: theme.colorScheme.surfaceContainerHighest,
                  selectedColor: theme.colorScheme.primary,
                  side: BorderSide(
                    color: isActive
                        ? theme.colorScheme.primary
                        : theme.colorScheme.outline.withValues(alpha: 0.3),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                ),
              );
            }),

            // More Filters button
            InkWell(
              onTap: onFilterTap,
              borderRadius: BorderRadius.circular(8),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: theme.colorScheme.primary),
                ),
                child: Row(
                  children: [
                    CustomIconWidget(
                      iconName: 'tune',
                      size: 18,
                      color: theme.colorScheme.primary,
                    ),
                    SizedBox(width: 2.w),
                    Text(
                      'More Filters',
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String? _getPriceRangeLabel() {
    final range = activeFilters['priceRange'] as List<double>?;
    if (range == null || (range[0] == 0.0 && range[1] == 50000000.0)) {
      return null;
    }
    return '₦${_formatPrice(range[0])} - ₦${_formatPrice(range[1])}';
  }

  String _formatPrice(double price) {
    if (price >= 1000000) {
      return '${(price / 1000000).toStringAsFixed(1)}M';
    } else if (price >= 1000) {
      return '${(price / 1000).toStringAsFixed(0)}K';
    }
    return price.toStringAsFixed(0);
  }
}
