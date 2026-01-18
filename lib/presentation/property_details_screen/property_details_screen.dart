import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../core/models/property_model.dart';
import '../../widgets/custom_icon_widget.dart';
import './widgets/action_buttons_widget.dart';
import './widgets/image_gallery_widget.dart';
import './widgets/property_header_widget.dart';
import './widgets/property_tabs_widget.dart';

/// Property Details Screen displaying comprehensive property information
class PropertyDetailsScreen extends StatefulWidget {
  const PropertyDetailsScreen({Key? key}) : super(key: key);

  @override
  State<PropertyDetailsScreen> createState() => _PropertyDetailsScreenState();
}

class _PropertyDetailsScreenState extends State<PropertyDetailsScreen> {
  bool _isSaved = false;
  Property? _property;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is Property) {
      _property = args;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (_property == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Property Details')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomIconWidget(
                iconName: 'error_outline',
                color: theme.colorScheme.error,
                size: 48,
              ),
              SizedBox(height: 2.h),
              Text(
                'Failed to load property details',
                style: theme.textTheme.titleMedium,
              ),
              SizedBox(height: 2.h),
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Go Back'),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      body: Column(
        children: [
          // Custom App Bar with Transparent Background
          SafeArea(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Back Button
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.9),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: IconButton(
                      icon: CustomIconWidget(
                        iconName: 'arrow_back',
                        color: Colors.black87,
                        size: 24,
                      ),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ),

                  // Action Buttons
                  Row(
                    children: [
                      // Share Button
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.9),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.1),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: IconButton(
                          icon: CustomIconWidget(
                            iconName: 'share',
                            color: Colors.black87,
                            size: 24,
                          ),
                          onPressed: _shareProperty,
                        ),
                      ),
                      SizedBox(width: 2.w),

                      // Save Button
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.9),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.1),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: IconButton(
                          icon: CustomIconWidget(
                            iconName: _isSaved ? 'favorite' : 'favorite_border',
                            color: _isSaved ? Colors.red : Colors.black87,
                            size: 24,
                          ),
                          onPressed: _toggleSave,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // Scrollable Content
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // Image Gallery
                  ImageGalleryWidget(property: _property!),

                  // Property Header
                  PropertyHeaderWidget(property: _property!),

                  // Property Tabs
                  SizedBox(
                    height: 60.h,
                    child: PropertyTabsWidget(property: _property!),
                  ),
                ],
              ),
            ),
          ),

          // Action Buttons
          ActionButtonsWidget(property: _property!),
        ],
      ),
    );
  }

  void _shareProperty() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Property link copied to clipboard'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _toggleSave() {
    setState(() {
      _isSaved = !_isSaved;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _isSaved ? 'Property saved' : 'Property removed from saved',
        ),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
