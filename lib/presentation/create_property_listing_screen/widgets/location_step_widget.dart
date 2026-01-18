import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart' as latlong;
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class LocationStepWidget extends StatefulWidget {
  final String? address;
  final double? latitude;
  final double? longitude;
  final Function(String, double, double) onLocationChanged;

  const LocationStepWidget({
    Key? key,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.onLocationChanged,
  }) : super(key: key);

  @override
  State<LocationStepWidget> createState() => _LocationStepWidgetState();
}

class _LocationStepWidgetState extends State<LocationStepWidget> {
  final TextEditingController _addressController = TextEditingController();
  final MapController _mapController = MapController();
  latlong.LatLng _currentPosition = const latlong.LatLng(6.5244, 3.3792); // Lagos, Nigeria

  @override
  void initState() {
    super.initState();
    if (widget.address != null) {
      _addressController.text = widget.address!;
    }
    if (widget.latitude != null && widget.longitude != null) {
      _currentPosition = latlong.LatLng(widget.latitude!, widget.longitude!);
    }
  }

  @override
  void dispose() {
    _addressController.dispose();
    _mapController.dispose();
    super.dispose();
  }

  void _onLocationSelected(latlong.LatLng position) {
    setState(() {
      _currentPosition = position;
    });

    final address =
        'Lat: ${position.latitude.toStringAsFixed(4)}, Lng: ${position.longitude.toStringAsFixed(4)}';
    _addressController.text = address;
    widget.onLocationChanged(address, position.latitude, position.longitude);
  }

  void _useCurrentLocation() {
    final position = const latlong.LatLng(6.5244, 3.3792);
    _mapController.move(position, 15);
    _onLocationSelected(position);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(4.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Where is your property located?',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 1.h),
                Text(
                  'Pin the exact location on the map or enter the address',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                SizedBox(height: 3.h),
                TextField(
                  controller: _addressController,
                  decoration: InputDecoration(
                    labelText: 'Property Address',
                    hintText: 'Enter full address',
                    prefixIcon: Padding(
                      padding: EdgeInsets.all(3.w),
                      child: CustomIconWidget(
                        iconName: 'location_on',
                        color: theme.colorScheme.onSurfaceVariant,
                        size: 24,
                      ),
                    ),
                    suffixIcon: IconButton(
                      icon: CustomIconWidget(
                        iconName: 'my_location',
                        color: theme.colorScheme.primary,
                        size: 24,
                      ),
                      onPressed: _useCurrentLocation,
                    ),
                  ),
                  maxLines: 2,
                ),
                SizedBox(height: 2.h),
              ],
            ),
          ),
          Container(
            height: 40.h,
            width: double.infinity,
            child: FlutterMap(
              mapController: _mapController,
              options: MapOptions(
                initialCenter: _currentPosition,
                initialZoom: 15,
                onTap: (tapPosition, point) => _onLocationSelected(point),
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'com.freddie.app',
                ),
                MarkerLayer(
                  markers: [
                    Marker(
                      point: _currentPosition,
                      width: 40,
                      height: 40,
                      child: CustomIconWidget(
                        iconName: 'location_on',
                        color: theme.colorScheme.primary,
                        size: 40,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.all(4.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 2.h),
                Container(
                  padding: EdgeInsets.all(3.w),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      CustomIconWidget(
                        iconName: 'info',
                        color: theme.colorScheme.primary,
                        size: 20,
                      ),
                      SizedBox(width: 2.w),
                      Expanded(
                        child: Text(
                          'Tap on the map to set exact location',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 2.h),
                if (widget.latitude != null && widget.longitude != null)
                  Container(
                    padding: EdgeInsets.all(3.w),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Selected Location',
                          style: theme.textTheme.labelMedium?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                        SizedBox(height: 1.h),
                        Row(
                          children: [
                            CustomIconWidget(
                              iconName: 'check_circle',
                              color: theme.colorScheme.primary,
                              size: 20,
                            ),
                            SizedBox(width: 2.w),
                            Expanded(
                              child: Text(
                                'Latitude: ${widget.latitude!.toStringAsFixed(6)}\nLongitude: ${widget.longitude!.toStringAsFixed(6)}',
                                style: theme.textTheme.bodySmall,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
