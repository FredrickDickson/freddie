import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
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
  bool _isLoading = true;
  Map<String, dynamic>? _propertyData;

  @override
  void initState() {
    super.initState();
    _loadPropertyData();
  }

  Future<void> _loadPropertyData() async {
    await Future.delayed(const Duration(milliseconds: 800));
    setState(() {
      _propertyData = _getMockPropertyData();
      _isLoading = false;
    });
  }

  Map<String, dynamic> _getMockPropertyData() {
    return {
      "id": "PROP001",
      "title": "Luxury 3 Bedroom Apartment in Lekki Phase 1",
      "price": "₦5,500,000/year",
      "location": "Lekki Phase 1, Lagos",
      "fullAddress": "15 Admiralty Way, Lekki Phase 1, Lagos State, Nigeria",
      "isVerified": true,
      "propertyType": "Rent",
      "description":
          "Experience luxury living in this beautifully furnished 3-bedroom apartment located in the heart of Lekki Phase 1. This modern property features spacious rooms, contemporary finishes, and access to premium amenities. Perfect for families or professionals seeking comfort and convenience in one of Lagos's most prestigious neighborhoods. The apartment offers stunning views, ample natural light, and is situated close to shopping centers, restaurants, and major business districts.",
      "images": [
        {
          "url":
              "https://images.unsplash.com/photo-1722942434635-0b34e98811d8",
          "semanticLabel":
              "Modern living room with grey sectional sofa, wooden coffee table, and large windows with city views",
        },
        {
          "url":
              "https://images.unsplash.com/photo-1612320743558-020669ff20e8",
          "semanticLabel":
              "Spacious master bedroom with king-size bed, white bedding, and minimalist decor",
        },
        {
          "url":
              "https://images.unsplash.com/photo-1722604817803-4c88edef9bc0",
          "semanticLabel":
              "Contemporary kitchen with white cabinets, marble countertops, and stainless steel appliances",
        },
        {
          "url":
              "https://images.unsplash.com/photo-1692220434788-47df994bec07",
          "semanticLabel":
              "Elegant bathroom with walk-in shower, floating vanity, and modern fixtures",
        },
        {
          "url":
              "https://img.rocket.new/generatedImages/rocket_gen_img_1a90fec5c-1766590825698.png",
          "semanticLabel":
              "Private balcony with outdoor seating overlooking city skyline at sunset",
        },
        {
          "url":
              "https://images.unsplash.com/photo-1722248240765-cba73bf26b54",
          "semanticLabel":
              "Cozy dining area with wooden table, modern chairs, and pendant lighting",
        },
      ],
      "keyFeatures": [
        {"icon": "bed", "label": "Bedrooms", "value": "3"},
        {"icon": "bathtub", "label": "Bathrooms", "value": "3"},
        {"icon": "square_foot", "label": "Area", "value": "180 sqm"},
        {"icon": "local_parking", "label": "Parking", "value": "2 spaces"},
      ],
      "amenities": [
        {"icon": "wifi", "name": "WiFi"},
        {"icon": "local_parking", "name": "Parking"},
        {"icon": "security", "name": "Security"},
        {"icon": "power", "name": "Generator"},
        {"icon": "water_drop", "name": "Water"},
        {"icon": "ac_unit", "name": "Air Conditioning"},
        {"icon": "kitchen", "name": "Kitchen"},
        {"icon": "fitness_center", "name": "Gym"},
        {"icon": "pool", "name": "Pool"},
        {"icon": "yard", "name": "Garden"},
      ],
      "coordinates": {"latitude": 6.4474, "longitude": 3.4700},
      "nearbyAmenities": [
        {
          "icon": "school",
          "name": "Corona School",
          "type": "School",
          "distance": "1.2 km",
          "duration": "5 min drive",
        },
        {
          "icon": "shopping_cart",
          "name": "The Palms Shopping Mall",
          "type": "Shopping",
          "distance": "2.5 km",
          "duration": "8 min drive",
        },
        {
          "icon": "local_hospital",
          "name": "Reddington Hospital",
          "type": "Hospital",
          "distance": "3.0 km",
          "duration": "10 min drive",
        },
        {
          "icon": "restaurant",
          "name": "Cactus Restaurant",
          "type": "Restaurant",
          "distance": "800 m",
          "duration": "3 min drive",
        },
      ],
      "averageRating": 4.5,
      "ratingBreakdown": {"5": 12, "4": 5, "3": 2, "2": 1, "1": 0},
      "reviews": [
        {
          "userName": "Chioma Okafor",
          "userAvatar":
              "https://img.rocket.new/generatedImages/rocket_gen_img_1a0ea65bb-1763296441079.png",
          "userAvatarLabel":
              "Professional headshot of a Nigerian woman with braided hair wearing a blue blouse",
          "rating": 5.0,
          "date": "2 weeks ago",
          "comment":
              "Absolutely love this apartment! The location is perfect, close to everything I need. The landlord is very responsive and the property is exactly as described. Highly recommend!",
          "helpfulCount": 8,
        },
        {
          "userName": "Emeka Nwosu",
          "userAvatar":
              "https://img.rocket.new/generatedImages/rocket_gen_img_1d0e5ef1f-1763292250024.png",
          "userAvatarLabel":
              "Professional headshot of a Nigerian man with short hair wearing a white shirt",
          "rating": 4.0,
          "date": "1 month ago",
          "comment":
              "Great property with excellent amenities. The only minor issue is parking can be tight during peak hours, but overall a fantastic place to live.",
          "helpfulCount": 5,
        },
        {
          "userName": "Aisha Mohammed",
          "userAvatar":
              "https://img.rocket.new/generatedImages/rocket_gen_img_1e24da9d6-1763297055199.png",
          "userAvatarLabel":
              "Professional headshot of a Nigerian woman with hijab wearing a green dress",
          "rating": 5.0,
          "date": "2 months ago",
          "comment":
              "The apartment exceeded my expectations. Very clean, modern, and the neighborhood is safe and quiet. Perfect for families!",
          "helpfulCount": 12,
        },
      ],
      "hasVirtualTour": true,
    };
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (_isLoading) {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(color: theme.colorScheme.primary),
        ),
      );
    }

    if (_propertyData == null) {
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
                onPressed: _loadPropertyData,
                child: const Text('Retry'),
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
                  ImageGalleryWidget(
                    images: (_propertyData!["images"] as List<dynamic>)
                        .cast<Map<String, dynamic>>(),
                  ),

                  // Property Header
                  PropertyHeaderWidget(property: _propertyData!),

                  // Property Tabs
                  SizedBox(
                    height: 60.h,
                    child: PropertyTabsWidget(property: _propertyData!),
                  ),
                ],
              ),
            ),
          ),

          // Action Buttons
          ActionButtonsWidget(property: _propertyData!),
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
