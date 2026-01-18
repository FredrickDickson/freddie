import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart' as latlong;
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../core/providers/property_provider.dart';
import '../../core/models/property_model.dart';
import '../../widgets/custom_icon_widget.dart';
import './widgets/filter_chips_widget.dart';
import './widgets/filter_modal_widget.dart';
import './widgets/property_card_widget.dart';
import './widgets/search_header_widget.dart';
import './widgets/sort_bottom_sheet_widget.dart';

/// Property Search Screen with advanced filtering and discovery tools
/// Accessed via bottom tab navigation - content-only widget
class PropertySearchScreen extends ConsumerStatefulWidget {
  const PropertySearchScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<PropertySearchScreen> createState() => _PropertySearchScreenState();
}

class _PropertySearchScreenState extends ConsumerState<PropertySearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  bool _isMapView = false;
  String _selectedSort = 'Relevance';

  // Active filters
  Map<String, dynamic> _activeFilters = {
    'query': '',
    'propertyType': null,
    'minPrice': 0.0,
    'maxPrice': 50000000.0,
    'bedrooms': null,
  };

  // Search history
  List<String> _searchHistory = [
    'Lekki Phase 1',
    '3 bedroom flat',
    'Victoria Island apartments',
  ];

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() {
        _activeFilters['query'] = _searchController.text;
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    // Handled by listener
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
      _activeFilters = {
        ..._activeFilters,
        ...filters,
      };
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

  void _navigateToPropertyDetails(Property property) {
    Navigator.of(
      context,
      rootNavigator: true,
    ).pushNamed('/property-details-screen', arguments: property);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final propertiesAsync = ref.watch(propertyListProvider(_activeFilters));

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
          },
        ),

        // Filter Chips
        FilterChipsWidget(
          activeFilters: _activeFilters,
          onFilterTap: _showFilterModal,
          onChipRemoved: (filterKey) {
            setState(() {
              _activeFilters[filterKey] = null;
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
              propertiesAsync.when(
                data: (properties) => Text(
                  '${properties.length} properties found',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                loading: () => const SizedBox.shrink(),
                error: (_, __) => const SizedBox.shrink(),
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
          child: propertiesAsync.when(
            data: (properties) {
              if (properties.isEmpty) {
                return _buildEmptyState(theme);
              }
              return _isMapView 
                  ? _buildMapView(theme, properties) 
                  : _buildListView(theme, properties);
            },
            loading: () => Center(
              child: CircularProgressIndicator(color: theme.colorScheme.primary),
            ),
            error: (error, _) => Center(
              child: Text('Error: $error'),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildListView(ThemeData theme, List<Property> properties) {
    return ListView.builder(
      controller: _scrollController,
      padding: EdgeInsets.symmetric(vertical: 1.h),
      itemCount: properties.length,
      itemBuilder: (context, index) {
        final property = properties[index];
        return PropertyCardWidget(
          property: property,
          onTap: () => _navigateToPropertyDetails(property),
          onSaveToggle: () {
            // Implement save toggle logic
          },
        );
      },
    );
  }

  Widget _buildMapView(ThemeData theme, List<Property> properties) {
    // Calculate center of all properties or default to Lagos
    final center = properties.isNotEmpty
        ? latlong.LatLng(
            properties.map((p) => p.latitude).reduce((a, b) => a + b) /
                properties.length,
            properties.map((p) => p.longitude).reduce((a, b) => a + b) /
                properties.length,
          )
        : const latlong.LatLng(6.5244, 3.3792);

    return FlutterMap(
      options: MapOptions(
        initialCenter: center,
        initialZoom: 12,
      ),
      children: [
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          userAgentPackageName: 'com.freddie.app',
        ),
        MarkerLayer(
          markers: properties.map((property) {
            return Marker(
              point: latlong.LatLng(property.latitude, property.longitude),
              width: 40,
              height: 40,
              child: GestureDetector(
                onTap: () => _navigateToPropertyDetails(property),
                child: CustomIconWidget(
                  iconName: 'location_on',
                  color: theme.colorScheme.primary,
                  size: 40,
                ),
              ),
            );
          }).toList(),
        ),
      ],
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
                    'query': '',
                    'propertyType': null,
                    'minPrice': 0.0,
                    'maxPrice': 50000000.0,
                    'bedrooms': null,
                  };
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
