import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../widgets/custom_icon_widget.dart';
import './widgets/filter_chips_widget.dart';
import './widgets/property_card_widget.dart';
import './widgets/search_header_widget.dart';

class PropertyDashboardInitialPage extends StatefulWidget {
  const PropertyDashboardInitialPage({Key? key}) : super(key: key);

  @override
  State<PropertyDashboardInitialPage> createState() =>
      _PropertyDashboardInitialPageState();
}

class _PropertyDashboardInitialPageState
    extends State<PropertyDashboardInitialPage> {
  bool isMapView = false;
  bool isRefreshing = false;
  final ScrollController _scrollController = ScrollController();

  final List<Map<String, dynamic>> properties = [
    {
      "id": 1,
      "title": "Modern 3 Bedroom Apartment",
      "price": "₦2,500,000",
      "location": "Lekki Phase 1, Lagos",
      "propertyType": "Apartment",
      "bedrooms": 3,
      "bathrooms": 2,
      "area": "120 sqm",
      "isVerified": true,
      "image":
          "https://images.unsplash.com/photo-1721742126814-f267ecb2d1de",
      "semanticLabel":
          "Modern apartment living room with grey sofa, wooden coffee table, and large windows with city view",
      "ownerName": "Adebayo Johnson",
      "ownerAvatar":
          "https://images.unsplash.com/photo-1721742126814-f267ecb2d1de",
      "ownerAvatarLabel":
          "Professional photo of a Nigerian man with short black hair wearing a blue shirt",
      "postedDate": "2 days ago",
      "views": 245,
      "isFavorite": false,
    },
    {
      "id": 2,
      "title": "Luxury 4 Bedroom Duplex",
      "price": "₦5,800,000",
      "location": "Victoria Island, Lagos",
      "propertyType": "Duplex",
      "bedrooms": 4,
      "bathrooms": 3,
      "area": "250 sqm",
      "isVerified": true,
      "image":
          "https://images.unsplash.com/photo-1504651869292-610d3cb9751b",
      "semanticLabel":
          "Luxury duplex exterior with white walls, large glass windows, and modern architectural design",
      "ownerName": "Chioma Okafor",
      "ownerAvatar":
          "https://images.unsplash.com/photo-1504651869292-610d3cb9751b",
      "ownerAvatarLabel":
          "Professional photo of a Nigerian woman with braided hair wearing a white blouse",
      "postedDate": "5 hours ago",
      "views": 892,
      "isFavorite": true,
    },
    {
      "id": 3,
      "title": "Cozy 2 Bedroom Flat",
      "price": "₦1,200,000",
      "location": "Ikeja GRA, Lagos",
      "propertyType": "Flat",
      "bedrooms": 2,
      "bathrooms": 1,
      "area": "85 sqm",
      "isVerified": false,
      "image":
          "https://images.unsplash.com/photo-1584383009987-d099f76055aa",
      "semanticLabel":
          "Cozy bedroom with wooden bed frame, white bedding, and warm lighting from bedside lamps",
      "ownerName": "Ibrahim Musa",
      "ownerAvatar":
          "https://images.unsplash.com/photo-1584383009987-d099f76055aa",
      "ownerAvatarLabel":
          "Professional photo of a Nigerian man with short hair wearing a grey polo shirt",
      "postedDate": "1 week ago",
      "views": 156,
      "isFavorite": false,
    },
    {
      "id": 4,
      "title": "Executive 5 Bedroom Villa",
      "price": "₦12,000,000",
      "location": "Banana Island, Lagos",
      "propertyType": "Villa",
      "bedrooms": 5,
      "bathrooms": 4,
      "area": "450 sqm",
      "isVerified": true,
      "image":
          "https://img.rocket.new/generatedImages/rocket_gen_img_19150013d-1765061396237.png",
      "semanticLabel":
          "Executive villa with swimming pool, palm trees, and modern white architecture with glass walls",
      "ownerName": "Funke Adeyemi",
      "ownerAvatar":
          "https://img.rocket.new/generatedImages/rocket_gen_img_19150013d-1765061396237.png",
      "ownerAvatarLabel":
          "Professional photo of a Nigerian woman with natural hair wearing a yellow dress",
      "postedDate": "3 days ago",
      "views": 1543,
      "isFavorite": false,
    },
    {
      "id": 5,
      "title": "Student Studio Apartment",
      "price": "₦450,000",
      "location": "Yaba, Lagos",
      "propertyType": "Studio",
      "bedrooms": 1,
      "bathrooms": 1,
      "area": "35 sqm",
      "isVerified": true,
      "image":
          "https://img.rocket.new/generatedImages/rocket_gen_img_16ce4edc1-1767330899500.png",
      "semanticLabel":
          "Compact studio apartment with bed, study desk, and kitchenette in an open layout",
      "ownerName": "Emeka Nwosu",
      "ownerAvatar":
          "https://img.rocket.new/generatedImages/rocket_gen_img_16ce4edc1-1767330899500.png",
      "ownerAvatarLabel":
          "Professional photo of a Nigerian man with glasses wearing a black t-shirt",
      "postedDate": "4 days ago",
      "views": 678,
      "isFavorite": true,
    },
  ];

  final List<Map<String, String>> activeFilters = [
    {"label": "₦1M - ₦3M", "type": "price"},
    {"label": "Lekki", "type": "location"},
    {"label": "3 Beds", "type": "bedrooms"},
  ];

  Future<void> _handleRefresh() async {
    setState(() => isRefreshing = true);
    await Future.delayed(const Duration(seconds: 2));
    setState(() => isRefreshing = false);
  }

  void _toggleFavorite(int propertyId) {
    setState(() {
      final index = properties.indexWhere((p) => p["id"] == propertyId);
      if (index != -1) {
        properties[index]["isFavorite"] =
            !(properties[index]["isFavorite"] as bool);
      }
    });
  }

  void _removeFilter(String label) {
    setState(() {
      activeFilters.removeWhere((filter) => filter["label"] == label);
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        SearchHeaderWidget(
          isMapView: isMapView,
          onViewToggle: () => setState(() => isMapView = !isMapView),
          onFilterTap: () {
            // Navigate to filter screen
          },
        ),
        if (activeFilters.isNotEmpty)
          FilterChipsWidget(
            filters: activeFilters,
            onRemoveFilter: _removeFilter,
          ),
        Expanded(
          child: isMapView ? _buildMapView(theme) : _buildListView(theme),
        ),
      ],
    );
  }

  Widget _buildListView(ThemeData theme) {
    return RefreshIndicator(
      onRefresh: _handleRefresh,
      child: ListView.builder(
        controller: _scrollController,
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
        itemCount: properties.length + 1,
        itemBuilder: (context, index) {
          if (index == properties.length) {
            return SizedBox(
              height: 8.h,
              child: Center(
                child: CircularProgressIndicator(
                  color: theme.colorScheme.primary,
                ),
              ),
            );
          }

          final property = properties[index];
          return PropertyCardWidget(
            property: property,
            onTap: () {
              Navigator.of(
                context,
                rootNavigator: true,
              ).pushNamed('/property-details-screen');
            },
            onFavoriteToggle: () => _toggleFavorite(property["id"] as int),
            onShare: () {
              // Share functionality
            },
            onContact: () {
              Navigator.of(
                context,
                rootNavigator: true,
              ).pushNamed('/messaging-screen');
            },
          );
        },
      ),
    );
  }

  Widget _buildMapView(ThemeData theme) {
    return Stack(
      children: [
        Container(
          color: theme.colorScheme.surfaceContainerHighest,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomIconWidget(
                  iconName: 'map',
                  size: 64,
                  color: theme.colorScheme.primary,
                ),
                SizedBox(height: 2.h),
                Text('Map View', style: theme.textTheme.titleLarge),
                SizedBox(height: 1.h),
                Text(
                  'Property locations will be displayed here',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
        Positioned(
          bottom: 2.h,
          right: 4.w,
          child: FloatingActionButton(
            onPressed: () {
              Navigator.of(
                context,
                rootNavigator: true,
              ).pushNamed('/create-property-listing-screen');
            },
            backgroundColor: theme.colorScheme.tertiary,
            child: CustomIconWidget(
              iconName: 'add',
              size: 28,
              color: theme.colorScheme.onTertiary,
            ),
          ),
        ),
      ],
    );
  }
}
