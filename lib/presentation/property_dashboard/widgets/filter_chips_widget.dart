import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class FilterChipsWidget extends StatelessWidget {
  final List<Map<String, String>> filters;
  final Function(String) onRemoveFilter;

  const FilterChipsWidget({
    Key? key,
    required this.filters,
    required this.onRemoveFilter,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border(
          bottom: BorderSide(
            color: theme.colorScheme.outline.withValues(alpha: 0.1),
          ),
        ),
      ),
      child: Row(
        children: [
          Text(
            'Active Filters:',
            style: theme.textTheme.labelMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(width: 2.w),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: filters.map((filter) {
                  return Padding(
                    padding: EdgeInsets.only(right: 2.w),
                    child: Chip(
                      label: Text(
                        filter["label"]!,
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: theme.colorScheme.onPrimaryContainer,
                        ),
                      ),
                      deleteIcon: CustomIconWidget(
                        iconName: 'close',
                        size: 16,
                        color: theme.colorScheme.onPrimaryContainer,
                      ),
                      onDeleted: () => onRemoveFilter(filter["label"]!),
                      backgroundColor: theme.colorScheme.primaryContainer,
                      side: BorderSide.none,
                      padding: EdgeInsets.symmetric(
                        horizontal: 2.w,
                        vertical: 0.5.h,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              // Clear all filters
            },
            child: Text(
              'Clear All',
              style: theme.textTheme.labelSmall?.copyWith(
                color: theme.colorScheme.error,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
