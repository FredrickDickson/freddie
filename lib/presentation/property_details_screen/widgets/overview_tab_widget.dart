import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

/// Overview tab displaying property description, features, and amenities
class OverviewTabWidget extends StatefulWidget {
  final Map<String, dynamic> property;

  const OverviewTabWidget({Key? key, required this.property}) : super(key: key);

  @override
  State<OverviewTabWidget> createState() => _OverviewTabWidgetState();
}

class _OverviewTabWidgetState extends State<OverviewTabWidget> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  final Set<DateTime> _bookedDates = {};

  @override
  void initState() {
    super.initState();
    _initializeBookedDates();
  }

  void _initializeBookedDates() {
    if (widget.property["propertyType"] == "Short-let") {
      final bookedDates = widget.property["bookedDates"] as List<dynamic>?;
      if (bookedDates != null) {
        for (var dateStr in bookedDates) {
          _bookedDates.add(DateTime.parse(dateStr as String));
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Description Section
          Text(
            'Description',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            widget.property["description"] as String,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
              height: 1.5,
            ),
          ),
          SizedBox(height: 3.h),

          // Key Features Section
          Text(
            'Key Features',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 1.5.h),
          _buildKeyFeatures(theme),
          SizedBox(height: 3.h),

          // Amenities Section
          Text(
            'Amenities',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 1.5.h),
          _buildAmenities(theme),
          SizedBox(height: 3.h),

          // Availability Calendar (for short-lets)
          if (widget.property["propertyType"] == "Short-let") ...[
            Text(
              'Availability Calendar',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 1.5.h),
            _buildAvailabilityCalendar(theme),
            SizedBox(height: 2.h),
          ],
        ],
      ),
    );
  }

  Widget _buildKeyFeatures(ThemeData theme) {
    final features = widget.property["keyFeatures"] as List<dynamic>;

    return Wrap(
      spacing: 3.w,
      runSpacing: 1.5.h,
      children: features.map((feature) {
        final featureMap = feature as Map<String, dynamic>;
        return Container(
          width: 28.w,
          padding: EdgeInsets.all(3.w),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: theme.colorScheme.outline.withValues(alpha: 0.2),
            ),
          ),
          child: Column(
            children: [
              CustomIconWidget(
                iconName: featureMap["icon"] as String,
                color: theme.colorScheme.primary,
                size: 28,
              ),
              SizedBox(height: 1.h),
              Text(
                featureMap["label"] as String,
                style: theme.textTheme.labelMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 0.5.h),
              Text(
                featureMap["value"] as String,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildAmenities(ThemeData theme) {
    final amenities = widget.property["amenities"] as List<dynamic>;

    return Wrap(
      spacing: 2.w,
      runSpacing: 1.h,
      children: amenities.map((amenity) {
        final amenityMap = amenity as Map<String, dynamic>;
        return GestureDetector(
          onLongPress: () {
            _showAmenityDescription(amenityMap["name"] as String);
          },
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
            decoration: BoxDecoration(
              color: theme.colorScheme.primaryContainer.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: theme.colorScheme.primary.withValues(alpha: 0.3),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomIconWidget(
                  iconName: amenityMap["icon"] as String,
                  color: theme.colorScheme.primary,
                  size: 18,
                ),
                SizedBox(width: 2.w),
                Text(
                  amenityMap["name"] as String,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurface,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildAvailabilityCalendar(ThemeData theme) {
    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: TableCalendar(
        firstDay: DateTime.now(),
        lastDay: DateTime.now().add(const Duration(days: 365)),
        focusedDay: _focusedDay,
        selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
        onDaySelected: (selectedDay, focusedDay) {
          if (!_bookedDates.any((date) => isSameDay(date, selectedDay))) {
            setState(() {
              _selectedDay = selectedDay;
              _focusedDay = focusedDay;
            });
          }
        },
        calendarStyle: CalendarStyle(
          todayDecoration: BoxDecoration(
            color: theme.colorScheme.primary.withValues(alpha: 0.3),
            shape: BoxShape.circle,
          ),
          selectedDecoration: BoxDecoration(
            color: theme.colorScheme.primary,
            shape: BoxShape.circle,
          ),
          disabledDecoration: BoxDecoration(
            color: theme.colorScheme.surface,
            shape: BoxShape.circle,
          ),
          outsideDaysVisible: false,
        ),
        headerStyle: HeaderStyle(
          formatButtonVisible: false,
          titleCentered: true,
          titleTextStyle: theme.textTheme.titleMedium!,
        ),
        enabledDayPredicate: (day) {
          return !_bookedDates.any((date) => isSameDay(date, day));
        },
      ),
    );
  }

  void _showAmenityDescription(String amenityName) {
    final descriptions = {
      'WiFi':
          'High-speed wireless internet connection available throughout the property',
      'Parking': 'Dedicated parking space included with the property',
      'Security': '24/7 security personnel and CCTV surveillance',
      'Generator': 'Backup power generator for uninterrupted electricity',
      'Water': 'Constant water supply with backup storage',
      'Air Conditioning': 'Central or split AC units in all rooms',
      'Kitchen': 'Fully equipped modern kitchen with appliances',
      'Gym': 'Access to on-site fitness center',
      'Pool': 'Swimming pool available for residents',
      'Garden': 'Well-maintained garden or outdoor space',
    };

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(amenityName),
        content: Text(
          descriptions[amenityName] ?? 'Amenity included with property',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}
