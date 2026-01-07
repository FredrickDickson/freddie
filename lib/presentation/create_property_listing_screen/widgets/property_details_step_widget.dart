import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class PropertyDetailsStepWidget extends StatefulWidget {
  final int bedrooms;
  final int bathrooms;
  final List<String> amenities;
  final String description;
  final Function(int) onBedroomsChanged;
  final Function(int) onBathroomsChanged;
  final Function(List<String>) onAmenitiesChanged;
  final Function(String) onDescriptionChanged;

  const PropertyDetailsStepWidget({
    Key? key,
    required this.bedrooms,
    required this.bathrooms,
    required this.amenities,
    required this.description,
    required this.onBedroomsChanged,
    required this.onBathroomsChanged,
    required this.onAmenitiesChanged,
    required this.onDescriptionChanged,
  }) : super(key: key);

  @override
  State<PropertyDetailsStepWidget> createState() =>
      _PropertyDetailsStepWidgetState();
}

class _PropertyDetailsStepWidgetState extends State<PropertyDetailsStepWidget> {
  final TextEditingController _descriptionController = TextEditingController();
  final int _maxDescriptionLength = 1000;
  final int _minDescriptionLength = 50;

  @override
  void initState() {
    super.initState();
    _descriptionController.text = widget.description;
    _descriptionController.addListener(() {
      widget.onDescriptionChanged(_descriptionController.text);
    });
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  void _toggleAmenity(String amenity) {
    final updatedAmenities = List<String>.from(widget.amenities);
    if (updatedAmenities.contains(amenity)) {
      updatedAmenities.remove(amenity);
    } else {
      updatedAmenities.add(amenity);
    }
    widget.onAmenitiesChanged(updatedAmenities);
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
            'Tell us about your property',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            'Provide detailed information to attract potential tenants',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          SizedBox(height: 3.h),
          _buildRoomCounters(theme),
          SizedBox(height: 3.h),
          Text(
            'Amenities',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 2.h),
          _buildAmenitiesGrid(theme),
          SizedBox(height: 3.h),
          Text(
            'Property Description',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 1.h),
          TextField(
            controller: _descriptionController,
            maxLines: 8,
            maxLength: _maxDescriptionLength,
            decoration: InputDecoration(
              hintText:
                  'Describe your property in detail. Include unique features, nearby amenities, and what makes it special...',
              counterText:
                  '${_descriptionController.text.length}/$_maxDescriptionLength',
              helperText: 'Minimum $_minDescriptionLength characters required',
              helperStyle: theme.textTheme.bodySmall?.copyWith(
                color:
                    _descriptionController.text.length >= _minDescriptionLength
                    ? theme.colorScheme.primary
                    : theme.colorScheme.error,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRoomCounters(ThemeData theme) {
    return Column(
      children: [
        _buildCounter(
          theme: theme,
          label: 'Bedrooms',
          value: widget.bedrooms,
          onIncrement: () => widget.onBedroomsChanged(widget.bedrooms + 1),
          onDecrement: () => widget.bedrooms > 0
              ? widget.onBedroomsChanged(widget.bedrooms - 1)
              : null,
        ),
        SizedBox(height: 2.h),
        _buildCounter(
          theme: theme,
          label: 'Bathrooms',
          value: widget.bathrooms,
          onIncrement: () => widget.onBathroomsChanged(widget.bathrooms + 1),
          onDecrement: () => widget.bathrooms > 0
              ? widget.onBathroomsChanged(widget.bathrooms - 1)
              : null,
        ),
      ],
    );
  }

  Widget _buildCounter({
    required ThemeData theme,
    required String label,
    required int value,
    required VoidCallback onIncrement,
    required VoidCallback? onDecrement,
  }) {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.colorScheme.outline, width: 1),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
          Row(
            children: [
              IconButton(
                onPressed: onDecrement,
                icon: CustomIconWidget(
                  iconName: 'remove_circle_outline',
                  color: onDecrement != null
                      ? theme.colorScheme.primary
                      : theme.colorScheme.onSurface.withValues(alpha: 0.38),
                  size: 28,
                ),
              ),
              Container(
                width: 12.w,
                alignment: Alignment.center,
                child: Text(
                  value.toString(),
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              IconButton(
                onPressed: onIncrement,
                icon: CustomIconWidget(
                  iconName: 'add_circle_outline',
                  color: theme.colorScheme.primary,
                  size: 28,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAmenitiesGrid(ThemeData theme) {
    final amenitiesList = [
      {'name': 'WiFi', 'icon': 'wifi'},
      {'name': 'Parking', 'icon': 'local_parking'},
      {'name': 'Air Conditioning', 'icon': 'ac_unit'},
      {'name': 'Swimming Pool', 'icon': 'pool'},
      {'name': 'Gym', 'icon': 'fitness_center'},
      {'name': 'Security', 'icon': 'security'},
      {'name': 'Generator', 'icon': 'power'},
      {'name': 'Garden', 'icon': 'yard'},
      {'name': 'Balcony', 'icon': 'balcony'},
      {'name': 'Elevator', 'icon': 'elevator'},
      {'name': 'Furnished', 'icon': 'weekend'},
      {'name': 'Pet Friendly', 'icon': 'pets'},
    ];

    return Wrap(
      spacing: 2.w,
      runSpacing: 1.h,
      children: amenitiesList.map((amenity) {
        final isSelected = widget.amenities.contains(amenity['name']);

        return InkWell(
          onTap: () => _toggleAmenity(amenity['name'] as String),
          borderRadius: BorderRadius.circular(8),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
            decoration: BoxDecoration(
              color: isSelected
                  ? theme.colorScheme.primary.withValues(alpha: 0.1)
                  : theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: isSelected
                    ? theme.colorScheme.primary
                    : theme.colorScheme.outline,
                width: isSelected ? 2 : 1,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomIconWidget(
                  iconName: amenity['icon'] as String,
                  color: isSelected
                      ? theme.colorScheme.primary
                      : theme.colorScheme.onSurfaceVariant,
                  size: 20,
                ),
                SizedBox(width: 1.w),
                Text(
                  amenity['name'] as String,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: isSelected
                        ? theme.colorScheme.primary
                        : theme.colorScheme.onSurface,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}
