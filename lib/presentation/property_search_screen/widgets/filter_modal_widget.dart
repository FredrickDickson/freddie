import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class FilterModalWidget extends StatefulWidget {
  final Map<String, dynamic> currentFilters;
  final ValueChanged<Map<String, dynamic>> onApplyFilters;

  const FilterModalWidget({
    Key? key,
    required this.currentFilters,
    required this.onApplyFilters,
  }) : super(key: key);

  @override
  State<FilterModalWidget> createState() => _FilterModalWidgetState();
}

class _FilterModalWidgetState extends State<FilterModalWidget> {
  late Map<String, dynamic> _filters;

  final List<String> _propertyTypes = [
    'Apartment',
    'House',
    'Villa',
    'Penthouse',
    'Studio',
    'Duplex',
  ];

  final List<int> _bedroomOptions = [1, 2, 3, 4, 5];

  final List<String> _amenities = [
    'Swimming Pool',
    'Gym',
    '24/7 Security',
    'Parking',
    'Generator',
    'Elevator',
    'Garden',
    'Backup Water',
  ];

  Set<String> _selectedAmenities = {};

  @override
  void initState() {
    super.initState();
    _filters = Map.from(widget.currentFilters);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      height: 90.h,
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: theme.colorScheme.outline.withValues(alpha: 0.2),
                ),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () {
                    setState(() {
                      _filters = {
                        'propertyType': null,
                        'priceRange': [0.0, 50000000.0],
                        'location': null,
                        'bedrooms': null,
                      };
                      _selectedAmenities.clear();
                    });
                  },
                  child: Text(
                    'Clear All',
                    style: theme.textTheme.labelLarge?.copyWith(
                      color: theme.colorScheme.primary,
                    ),
                  ),
                ),
                Text(
                  'Filters',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                IconButton(
                  icon: CustomIconWidget(
                    iconName: 'close',
                    size: 24,
                    color: theme.colorScheme.onSurface,
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),

          // Filter Content
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(4.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Property Type
                  _buildSectionTitle(theme, 'Property Type'),
                  SizedBox(height: 1.h),
                  Wrap(
                    spacing: 2.w,
                    runSpacing: 1.h,
                    children: _propertyTypes.map((type) {
                      final isSelected = _filters['propertyType'] == type;
                      return FilterChip(
                        label: Text(type),
                        selected: isSelected,
                        onSelected: (selected) {
                          setState(() {
                            _filters['propertyType'] = selected ? type : null;
                          });
                        },
                        backgroundColor: theme.colorScheme.surfaceContainerHighest,
                        selectedColor: theme.colorScheme.primary,
                        labelStyle: theme.textTheme.labelMedium?.copyWith(
                          color: isSelected
                              ? theme.colorScheme.onPrimary
                              : theme.colorScheme.onSurfaceVariant,
                        ),
                      );
                    }).toList(),
                  ),
                  SizedBox(height: 3.h),

                  // Price Range
                  _buildSectionTitle(theme, 'Price Range'),
                  SizedBox(height: 1.h),
                  RangeSlider(
                    values: RangeValues(
                      (_filters['priceRange'] as List<double>)[0],
                      (_filters['priceRange'] as List<double>)[1],
                    ),
                    min: 0,
                    max: 50000000,
                    divisions: 100,
                    labels: RangeLabels(
                      '₦${_formatPrice((_filters['priceRange'] as List<double>)[0])}',
                      '₦${_formatPrice((_filters['priceRange'] as List<double>)[1])}',
                    ),
                    onChanged: (values) {
                      setState(() {
                        _filters['priceRange'] = [values.start, values.end];
                      });
                    },
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '₦${_formatPrice((_filters['priceRange'] as List<double>)[0])}',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                      Text(
                        '₦${_formatPrice((_filters['priceRange'] as List<double>)[1])}',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 3.h),

                  // Bedrooms
                  _buildSectionTitle(theme, 'Bedrooms'),
                  SizedBox(height: 1.h),
                  Row(
                    children: _bedroomOptions.map((count) {
                      final isSelected = _filters['bedrooms'] == count;
                      return Expanded(
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 1.w),
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                _filters['bedrooms'] = isSelected
                                    ? null
                                    : count;
                              });
                            },
                            borderRadius: BorderRadius.circular(8),
                            child: Container(
                              padding: EdgeInsets.symmetric(vertical: 1.5.h),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? theme.colorScheme.primary
                                    : theme.colorScheme.surfaceContainerHighest,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: isSelected
                                      ? theme.colorScheme.primary
                                      : theme.colorScheme.outline.withValues(
                                          alpha: 0.3,
                                        ),
                                ),
                              ),
                              child: Text(
                                '$count',
                                textAlign: TextAlign.center,
                                style: theme.textTheme.titleMedium?.copyWith(
                                  color: isSelected
                                      ? theme.colorScheme.onPrimary
                                      : theme.colorScheme.onSurfaceVariant,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  SizedBox(height: 3.h),

                  // Amenities
                  _buildSectionTitle(theme, 'Amenities'),
                  SizedBox(height: 1.h),
                  Wrap(
                    spacing: 2.w,
                    runSpacing: 1.h,
                    children: _amenities.map((amenity) {
                      final isSelected = _selectedAmenities.contains(amenity);
                      return FilterChip(
                        label: Text(amenity),
                        selected: isSelected,
                        onSelected: (selected) {
                          setState(() {
                            if (selected) {
                              _selectedAmenities.add(amenity);
                            } else {
                              _selectedAmenities.remove(amenity);
                            }
                          });
                        },
                        backgroundColor: theme.colorScheme.surfaceContainerHighest,
                        selectedColor: theme.colorScheme.primary,
                        labelStyle: theme.textTheme.labelMedium?.copyWith(
                          color: isSelected
                              ? theme.colorScheme.onPrimary
                              : theme.colorScheme.onSurfaceVariant,
                        ),
                      );
                    }).toList(),
                  ),
                  SizedBox(height: 3.h),

                  // Proximity
                  _buildSectionTitle(theme, 'Proximity'),
                  SizedBox(height: 1.h),
                  _buildProximityOption(theme, 'Schools', 'school'),
                  _buildProximityOption(theme, 'Markets', 'shopping_cart'),
                  _buildProximityOption(theme, 'Transport', 'directions_bus'),
                ],
              ),
            ),
          ),

          // Apply Button
          Container(
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 8,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: ElevatedButton(
              onPressed: () {
                widget.onApplyFilters(_filters);
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 6.h),
              ),
              child: const Text('Apply Filters'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(ThemeData theme, String title) {
    return Text(
      title,
      style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
    );
  }

  Widget _buildProximityOption(ThemeData theme, String label, String icon) {
    return Padding(
      padding: EdgeInsets.only(bottom: 1.h),
      child: Row(
        children: [
          CustomIconWidget(
            iconName: icon,
            size: 20,
            color: theme.colorScheme.onSurfaceVariant,
          ),
          SizedBox(width: 3.w),
          Expanded(child: Text(label, style: theme.textTheme.bodyMedium)),
          Text(
            'Within 5 km',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
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
