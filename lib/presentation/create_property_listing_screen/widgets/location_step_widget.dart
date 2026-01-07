import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
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
  GoogleMapController? _mapController;
  LatLng _currentPosition = const LatLng(6.5244, 3.3792); // Lagos, Nigeria
  Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();
    if (widget.address != null) {
      _addressController.text = widget.address!;
    }
    if (widget.latitude != null && widget.longitude != null) {
      _currentPosition = LatLng(widget.latitude!, widget.longitude!);
      _updateMarker(_currentPosition);
    }
  }

  @override
  void dispose() {
    _addressController.dispose();
    _mapController?.dispose();
    super.dispose();
  }

  void _updateMarker(LatLng position) {
    setState(() {
      _markers = {
        Marker(
          markerId: const MarkerId('property_location'),
          position: position,
          draggable: true,
          onDragEnd: (newPosition) {
            _onLocationSelected(newPosition);
          },
        ),
      };
    });
  }

  void _onLocationSelected(LatLng position) {
    setState(() {
      _currentPosition = position;
      _updateMarker(position);
    });

    final address =
        'Lat: ${position.latitude.toStringAsFixed(4)}, Lng: ${position.longitude.toStringAsFixed(4)}';
    _addressController.text = address;
    widget.onLocationChanged(address, position.latitude, position.longitude);
  }

  void _useCurrentLocation() {
    final position = const LatLng(6.5244, 3.3792);
    _mapController?.animateCamera(CameraUpdate.newLatLngZoom(position, 15));
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
            child: GoogleMap(
              initialCameraPosition: CameraPosition(
                target: _currentPosition,
                zoom: 15,
              ),
              markers: _markers,
              onMapCreated: (controller) {
                _mapController = controller;
              },
              onTap: _onLocationSelected,
              myLocationButtonEnabled: false,
              zoomControlsEnabled: true,
              mapToolbarEnabled: false,
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
                          'Tap on the map or drag the marker to set exact location',
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
