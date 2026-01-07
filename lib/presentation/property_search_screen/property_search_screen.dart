import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../widgets/custom_icon_widget.dart';
import './widgets/filter_chips_widget.dart';
import './widgets/filter_modal_widget.dart';
import './widgets/property_card_widget.dart';
import './widgets/search_header_widget.dart';
import './widgets/sort_bottom_sheet_widget.dart';

/// Property Search Screen with advanced filtering and discovery tools
/// Accessed via bottom tab navigation - content-only widget
class PropertySearchScreen extends StatefulWidget {
  const PropertySearchScreen({Key? key}) : super(key: key);

  @override
  State<PropertySearchScreen> createState() => _PropertySearchScreenState();
}

class _PropertySearchScreenState extends State<PropertySearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  bool _isMapView = false;
  bool _isLoading = false;
  String _selectedSort = 'Relevance';

  // Active filters
  Map<String, dynamic> _activeFilters = {
    'propertyType': null,
    'priceRange': [0.0, 50000000.0],
    'location': null,
    'bedrooms': null,
  };

  // Search history
  List<String> _searchHistory = [
    'Lekki Phase 1',
    '3 bedroom flat',
    'Victoria Island apartments',
  ];

  // Mock property data
  final List<Map<String, dynamic>> _allProperties = [
    {
      "id": 1,
      "title": "Luxury 3 Bedroom Apartment",
      "location": "Lekki Phase 1, Lagos",
      "price": "\\₦45,000,000",
      "priceValue": 45000000,
      "bedrooms": 3,
      "bathrooms": 3,
      "area": "120 sqm",
      "propertyType": "Apartment",
      "image":
          "https://img.rocket.new/generatedImages/rocket_gen_img_1e13741fb-1766566954518.png",
      "semanticLabel":
          "Modern luxury apartment living room with floor-to-ceiling windows, contemporary furniture, and city skyline view",
      "isVerified": true,
      "isSaved": false,
      "datePosted": "2 days ago",
      "distance": "2.5 km away",
      "amenities": ["Swimming Pool", "Gym", "24/7 Security"],
    },
    {
      "id": 2,
      "title": "Spacious 4 Bedroom Duplex",
      "location": "Victoria Island, Lagos",
      "price": "\\₦85,000,000",
      "priceValue": 85000000,
      "bedrooms": 4,
      "bathrooms": 4,
      "area": "250 sqm",
      "propertyType": "House",
      "image":
          "https://img.rocket.new/generatedImages/rocket_gen_img_18d30bde1-1766936726876.png",
      "semanticLabel":
          "Elegant two-story duplex exterior with white facade, large windows, and landscaped front garden",
      "isVerified": true,
      "isSaved": true,
      "datePosted": "1 week ago",
      "distance": "5.8 km away",
      "amenities": ["Garden", "Parking", "Generator"],
    },
    {
      "id": 3,
      "title": "Modern 2 Bedroom Flat",
      "location": "Ikeja GRA, Lagos",
      "price": "\\₦28,000,000",
      "priceValue": 28000000,
      "bedrooms": 2,
      "bathrooms": 2,
      "area": "85 sqm",
      "propertyType": "Apartment",
      "image":
          "https://img.rocket.new/generatedImages/rocket_gen_img_1bebffcac-1765192413762.png",
      "semanticLabel":
          "Contemporary apartment interior with open-plan kitchen, dining area, and modern appliances",
      "isVerified": false,
      "isSaved": false,
      "datePosted": "3 days ago",
      "distance": "8.2 km away",
      "amenities": ["Elevator", "Backup Water"],
    },
    {
      "id": 4,
      "title": "Executive 5 Bedroom Villa",
      "location": "Banana Island, Lagos",
      "price": "\\₦250,000,000",
      "priceValue": 250000000,
      "bedrooms": 5,
      "bathrooms": 6,
      "area": "450 sqm",
      "propertyType": "Villa",
      "image":
          "https://images.unsplash.com/photo-1642329873337-24a26c287cce",
      "semanticLabel":
          "Luxurious waterfront villa with infinity pool, palm trees, and ocean view at sunset",
      "isVerified": true,
      "isSaved": false,
      "datePosted": "5 days ago",
      "distance": "12.5 km away",
      "amenities": ["Private Beach", "Cinema Room", "Wine Cellar"],
    },
    {
      "id": 5,
      "title": "Cozy 1 Bedroom Studio",
      "location": "Yaba, Lagos",
      "price": "\\₦15,000,000",
      "priceValue": 15000000,
      "bedrooms": 1,
      "bathrooms": 1,
      "area": "45 sqm",
      "propertyType": "Studio",
      "image":
          "https://img.rocket.new/generatedImages/rocket_gen_img_1fed1ead2-1767570684909.png",
      "semanticLabel":
          "Compact studio apartment with minimalist design, murphy bed, and efficient space utilization",
      "isVerified": false,
      "isSaved": true,
      "datePosted": "1 day ago",
      "distance": "3.7 km away",
      "amenities": ["WiFi", "Furnished"],
    },
    {
      "id": 6,
      "title": "Elegant 3 Bedroom Penthouse",
      "location": "Ikoyi, Lagos",
      "price": "\\₦120,000,000",
      "priceValue": 120000000,
      "bedrooms": 3,
      "bathrooms": 3,
      "area": "180 sqm",
      "propertyType": "Penthouse",
      "image":
          "https://img.rocket.new/generatedImages/rocket_gen_img_10f7fd659-1766936729005.png",
      "semanticLabel":
          "Upscale penthouse terrace with outdoor seating, city panorama, and evening lighting",
      "isVerified": true,
      "isSaved": false,
      "datePosted": "4 days ago",
      "distance": "6.3 km away",
      "amenities": ["Rooftop Terrace", "Smart Home", "Concierge"],
    },
  ];

  List<Map<String, dynamic>> _filteredProperties = [];

  @override
  void initState() {
    super.initState();
    _filteredProperties = List.from(_allProperties);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    setState(() {
      _isLoading = true;
    });

    // Simulate search delay
    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        if (query.isEmpty) {
          _filteredProperties = List.from(_allProperties);
        } else {
          _filteredProperties = _allProperties.where((property) {
            final title = (property['title'] as String).toLowerCase();
            final location = (property['location'] as String).toLowerCase();
            final searchLower = query.toLowerCase();
            return title.contains(searchLower) ||
                location.contains(searchLower);
          }).toList();
        }
        _isLoading = false;
      });
    });
  }

  void _onSearchSubmitted(String query) {
    if (query.isNotEmpty && !_searchHistory.contains(query)) {
      setState(() {
        _searchHistory.insert(0, query);
        if (_searchHistory.length > 5) {
          _searchHistory.removeLast();
        }
      });
    }
  }

  void _applyFilters(Map<String, dynamic> filters) {
    setState(() {
      _activeFilters = filters;
      _isLoading = true;
    });

    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        _filteredProperties = _allProperties.where((property) {
          // Property type filter
          if (filters['propertyType'] != null &&
              property['propertyType'] != filters['propertyType']) {
            return false;
          }

          // Price range filter
          final priceRange = filters['priceRange'] as List<double>;
          final propertyPrice = property['priceValue'] as int;
          if (propertyPrice < priceRange[0] || propertyPrice > priceRange[1]) {
            return false;
          }

          // Bedrooms filter
          if (filters['bedrooms'] != null &&
              property['bedrooms'] != filters['bedrooms']) {
            return false;
          }

          // Location filter
          if (filters['location'] != null &&
              !(property['location'] as String).contains(filters['location'])) {
            return false;
          }

          return true;
        }).toList();

        _applySorting();
        _isLoading = false;
      });
    });
  }

  void _applySorting() {
    switch (_selectedSort) {
      case 'Price (Low to High)':
        _filteredProperties.sort(
          (a, b) => (a['priceValue'] as int).compareTo(b['priceValue'] as int),
        );
        break;
      case 'Price (High to Low)':
        _filteredProperties.sort(
          (a, b) => (b['priceValue'] as int).compareTo(a['priceValue'] as int),
        );
        break;
      case 'Date Listed':
        // Already in order by date
        break;
      case 'Distance':
        // Sort by distance (parse km value)
        _filteredProperties.sort((a, b) {
          final distA = double.parse((a['distance'] as String).split(' ')[0]);
          final distB = double.parse((b['distance'] as String).split(' ')[0]);
          return distA.compareTo(distB);
        });
        break;
      default:
        // Relevance - keep original order
        break;
    }
  }

  void _toggleSaveProperty(int propertyId) {
    setState(() {
      final index = _filteredProperties.indexWhere(
        (p) => p['id'] == propertyId,
      );
      if (index != -1) {
        _filteredProperties[index]['isSaved'] =
            !(_filteredProperties[index]['isSaved'] as bool);
      }

      final allIndex = _allProperties.indexWhere((p) => p['id'] == propertyId);
      if (allIndex != -1) {
        _allProperties[allIndex]['isSaved'] =
            !(_allProperties[allIndex]['isSaved'] as bool);
      }
    });
  }

  void _showFilterModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => FilterModalWidget(
        currentFilters: _activeFilters,
        onApplyFilters: _applyFilters,
      ),
    );
  }

  void _showSortBottomSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => SortBottomSheetWidget(
        currentSort: _selectedSort,
        onSortSelected: (sort) {
          setState(() {
            _selectedSort = sort;
            _applySorting();
          });
        },
      ),
    );
  }

  void _toggleMapView() {
    setState(() {
      _isMapView = !_isMapView;
    });
  }

  void _navigateToPropertyDetails(Map<String, dynamic> property) {
    Navigator.of(
      context,
      rootNavigator: true,
    ).pushNamed('/property-details-screen', arguments: property);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        // Search Header
        SearchHeaderWidget(
          controller: _searchController,
          searchHistory: _searchHistory,
          onSearchChanged: _onSearchChanged,
          onSearchSubmitted: _onSearchSubmitted,
          onHistoryItemTap: (query) {
            _searchController.text = query;
            _onSearchChanged(query);
          },
        ),

        // Filter Chips
        FilterChipsWidget(
          activeFilters: _activeFilters,
          onFilterTap: _showFilterModal,
          onChipRemoved: (filterKey) {
            setState(() {
              _activeFilters[filterKey] = null;
              _applyFilters(_activeFilters);
            });
          },
        ),

        // Action Bar
        Container(
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
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${_filteredProperties.length} properties found',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              Row(
                children: [
                  // Map Toggle
                  InkWell(
                    onTap: _toggleMapView,
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 3.w,
                        vertical: 1.h,
                      ),
                      decoration: BoxDecoration(
                        color: _isMapView
                            ? theme.colorScheme.primary.withValues(alpha: 0.1)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: _isMapView
                              ? theme.colorScheme.primary
                              : theme.colorScheme.outline.withValues(
                                  alpha: 0.3,
                                ),
                        ),
                      ),
                      child: Row(
                        children: [
                          CustomIconWidget(
                            iconName: _isMapView ? 'list' : 'map',
                            size: 18,
                            color: _isMapView
                                ? theme.colorScheme.primary
                                : theme.colorScheme.onSurfaceVariant,
                          ),
                          SizedBox(width: 1.w),
                          Text(
                            _isMapView ? 'List' : 'Map',
                            style: theme.textTheme.labelMedium?.copyWith(
                              color: _isMapView
                                  ? theme.colorScheme.primary
                                  : theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(width: 2.w),
                  // Sort Button
                  InkWell(
                    onTap: _showSortBottomSheet,
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 3.w,
                        vertical: 1.h,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: theme.colorScheme.outline.withValues(
                            alpha: 0.3,
                          ),
                        ),
                      ),
                      child: Row(
                        children: [
                          CustomIconWidget(
                            iconName: 'sort',
                            size: 18,
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                          SizedBox(width: 1.w),
                          Text(
                            'Sort',
                            style: theme.textTheme.labelMedium?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        // Content Area
        Expanded(
          child: _isMapView ? _buildMapView(theme) : _buildListView(theme),
        ),
      ],
    );
  }

  Widget _buildListView(ThemeData theme) {
    if (_isLoading) {
      return Center(
        child: CircularProgressIndicator(color: theme.colorScheme.primary),
      );
    }

    if (_filteredProperties.isEmpty) {
      return _buildEmptyState(theme);
    }

    return ListView.builder(
      controller: _scrollController,
      padding: EdgeInsets.symmetric(vertical: 1.h),
      itemCount: _filteredProperties.length,
      itemBuilder: (context, index) {
        final property = _filteredProperties[index];
        return PropertyCardWidget(
          property: property,
          onTap: () => _navigateToPropertyDetails(property),
          onSaveToggle: () => _toggleSaveProperty(property['id'] as int),
        );
      },
    );
  }

  Widget _buildMapView(ThemeData theme) {
    return Container(
      color: theme.colorScheme.surfaceContainerHighest,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomIconWidget(
              iconName: 'map',
              size: 64,
              color: theme.colorScheme.primary.withValues(alpha: 0.5),
            ),
            SizedBox(height: 2.h),
            Text(
              'Map View',
              style: theme.textTheme.titleLarge?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            SizedBox(height: 1.h),
            Text(
              'Interactive map with property pins',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant.withValues(
                  alpha: 0.7,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(ThemeData theme) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 8.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomIconWidget(
              iconName: 'search_off',
              size: 64,
              color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
            ),
            SizedBox(height: 2.h),
            Text(
              'No properties found',
              style: theme.textTheme.titleLarge?.copyWith(
                color: theme.colorScheme.onSurface,
              ),
            ),
            SizedBox(height: 1.h),
            Text(
              'Try adjusting your filters or search terms',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            SizedBox(height: 3.h),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _searchController.clear();
                  _activeFilters = {
                    'propertyType': null,
                    'priceRange': [0.0, 50000000.0],
                    'location': null,
                    'bedrooms': null,
                  };
                  _filteredProperties = List.from(_allProperties);
                });
              },
              child: const Text('Clear All Filters'),
            ),
          ],
        ),
      ),
    );
  }
}
