import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/custom_icon_widget.dart';
import './widgets/location_step_widget.dart';
import './widgets/photo_upload_step_widget.dart';
import './widgets/pricing_step_widget.dart';
import './widgets/property_details_step_widget.dart';
import './widgets/property_type_step_widget.dart';

class CreatePropertyListingScreen extends StatefulWidget {
  const CreatePropertyListingScreen({Key? key}) : super(key: key);

  @override
  State<CreatePropertyListingScreen> createState() =>
      _CreatePropertyListingScreenState();
}

class _CreatePropertyListingScreenState
    extends State<CreatePropertyListingScreen> {
  int _currentStep = 0;
  final int _totalSteps = 5;

  // Form data storage
  Map<String, dynamic> _listingData = {
    'propertyType': null,
    'category': null,
    'location': null,
    'address': null,
    'latitude': null,
    'longitude': null,
    'bedrooms': 1,
    'bathrooms': 1,
    'amenities': <String>[],
    'description': '',
    'photos': <String>[],
    'videos': <String>[],
    'price': '',
    'rentalTerms': null,
    'currency': '₦',
  };

  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: CustomAppBar(
        title: 'Create Listing',
        leading: IconButton(
          icon: CustomIconWidget(
            iconName: 'close',
            color: theme.colorScheme.onSurface,
            size: 24,
          ),
          onPressed: () => _handleBackPress(),
        ),
        actions: [
          TextButton(
            onPressed: _saveDraft,
            child: Text(
              'Save Draft',
              style: theme.textTheme.labelLarge?.copyWith(
                color: theme.colorScheme.primary,
              ),
            ),
          ),
        ],
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(
                color: theme.colorScheme.primary,
              ),
            )
          : Column(
              children: [
                _buildProgressIndicator(theme),
                Expanded(child: _buildCurrentStep()),
                _buildNavigationButtons(theme),
              ],
            ),
    );
  }

  Widget _buildProgressIndicator(ThemeData theme) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Step ${_currentStep + 1} of $_totalSteps',
                style: theme.textTheme.labelMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const Spacer(),
              Text(
                '${((_currentStep + 1) / _totalSteps * 100).toInt()}%',
                style: theme.textTheme.labelMedium?.copyWith(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(height: 1.h),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: (_currentStep + 1) / _totalSteps,
              backgroundColor: theme.colorScheme.surfaceContainerHighest,
              valueColor: AlwaysStoppedAnimation<Color>(
                theme.colorScheme.primary,
              ),
              minHeight: 0.8.h,
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            _getStepTitle(),
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCurrentStep() {
    switch (_currentStep) {
      case 0:
        return PropertyTypeStepWidget(
          selectedPropertyType: _listingData['propertyType'],
          selectedCategory: _listingData['category'],
          onPropertyTypeChanged: (type) {
            setState(() {
              _listingData['propertyType'] = type;
            });
          },
          onCategoryChanged: (category) {
            setState(() {
              _listingData['category'] = category;
            });
          },
        );
      case 1:
        return LocationStepWidget(
          address: _listingData['address'],
          latitude: _listingData['latitude'],
          longitude: _listingData['longitude'],
          onLocationChanged: (address, lat, lng) {
            setState(() {
              _listingData['address'] = address;
              _listingData['latitude'] = lat;
              _listingData['longitude'] = lng;
            });
          },
        );
      case 2:
        return PropertyDetailsStepWidget(
          bedrooms: _listingData['bedrooms'],
          bathrooms: _listingData['bathrooms'],
          amenities: _listingData['amenities'],
          description: _listingData['description'],
          onBedroomsChanged: (value) {
            setState(() {
              _listingData['bedrooms'] = value;
            });
          },
          onBathroomsChanged: (value) {
            setState(() {
              _listingData['bathrooms'] = value;
            });
          },
          onAmenitiesChanged: (amenities) {
            setState(() {
              _listingData['amenities'] = amenities;
            });
          },
          onDescriptionChanged: (description) {
            setState(() {
              _listingData['description'] = description;
            });
          },
        );
      case 3:
        return PhotoUploadStepWidget(
          photos: _listingData['photos'],
          videos: _listingData['videos'],
          onPhotosChanged: (photos) {
            setState(() {
              _listingData['photos'] = photos;
            });
          },
          onVideosChanged: (videos) {
            setState(() {
              _listingData['videos'] = videos;
            });
          },
        );
      case 4:
        return PricingStepWidget(
          price: _listingData['price'],
          rentalTerms: _listingData['rentalTerms'],
          currency: _listingData['currency'],
          propertyType: _listingData['propertyType'],
          category: _listingData['category'],
          location: _listingData['address'],
          onPriceChanged: (price) {
            setState(() {
              _listingData['price'] = price;
            });
          },
          onRentalTermsChanged: (terms) {
            setState(() {
              _listingData['rentalTerms'] = terms;
            });
          },
        );
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildNavigationButtons(ThemeData theme) {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 4,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            if (_currentStep > 0)
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    setState(() {
                      _currentStep--;
                    });
                  },
                  style: OutlinedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 2.h),
                    side: BorderSide(
                      color: theme.colorScheme.primary,
                      width: 1,
                    ),
                  ),
                  child: Text('Back'),
                ),
              ),
            if (_currentStep > 0) SizedBox(width: 3.w),
            Expanded(
              flex: _currentStep > 0 ? 1 : 2,
              child: ElevatedButton(
                onPressed: _canProceed() ? _handleNextStep : null,
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 2.h),
                  backgroundColor: theme.colorScheme.primary,
                  disabledBackgroundColor: theme.colorScheme.onSurface
                      .withValues(alpha: 0.12),
                ),
                child: Text(
                  _currentStep == _totalSteps - 1
                      ? 'Publish Listing'
                      : 'Continue',
                  style: theme.textTheme.labelLarge?.copyWith(
                    color: _canProceed()
                        ? theme.colorScheme.onPrimary
                        : theme.colorScheme.onSurface.withValues(alpha: 0.38),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getStepTitle() {
    switch (_currentStep) {
      case 0:
        return 'Property Type & Category';
      case 1:
        return 'Location Details';
      case 2:
        return 'Property Details';
      case 3:
        return 'Photos & Videos';
      case 4:
        return 'Pricing Information';
      default:
        return '';
    }
  }

  bool _canProceed() {
    switch (_currentStep) {
      case 0:
        return _listingData['propertyType'] != null &&
            _listingData['category'] != null;
      case 1:
        return _listingData['address'] != null &&
            _listingData['latitude'] != null &&
            _listingData['longitude'] != null;
      case 2:
        return _listingData['description'].toString().trim().isNotEmpty &&
            _listingData['description'].toString().trim().length >= 50;
      case 3:
        return (_listingData['photos'] as List).isNotEmpty;
      case 4:
        return _listingData['price'].toString().trim().isNotEmpty &&
            (_listingData['category'] != 'Rent' ||
                _listingData['rentalTerms'] != null);
      default:
        return false;
    }
  }

  void _handleNextStep() {
    if (_currentStep < _totalSteps - 1) {
      setState(() {
        _currentStep++;
      });
    } else {
      _publishListing();
    }
  }

  void _handleBackPress() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep--;
      });
    } else {
      _showExitDialog();
    }
  }

  void _showExitDialog() {
    final theme = Theme.of(context);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Discard Listing?', style: theme.textTheme.titleLarge),
        content: Text(
          'Your progress will be lost. You can save as draft to continue later.',
          style: theme.textTheme.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context, rootNavigator: true).pop();
            },
            child: Text(
              'Discard',
              style: TextStyle(color: theme.colorScheme.error),
            ),
          ),
        ],
      ),
    );
  }

  void _saveDraft() async {
    setState(() {
      _isLoading = true;
    });

    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      _isLoading = false;
    });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Draft saved successfully'),
          backgroundColor: Theme.of(context).colorScheme.primary,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  void _publishListing() async {
    setState(() {
      _isLoading = true;
    });

    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isLoading = false;
    });

    if (mounted) {
      _showSuccessDialog();
    }
  }

  void _showSuccessDialog() {
    final theme = Theme.of(context);
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: EdgeInsets.all(3.w),
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: CustomIconWidget(
                iconName: 'check_circle',
                color: theme.colorScheme.primary,
                size: 48,
              ),
            ),
            SizedBox(height: 2.h),
            Text(
              'Listing Published!',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 1.h),
            Text(
              'Your property is now live and visible to potential tenants.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 2.h),
            Container(
              padding: EdgeInsets.all(2.w),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      'freddie.app/property/FRD-${DateTime.now().millisecondsSinceEpoch}',
                      style: theme.textTheme.bodySmall?.copyWith(
                        fontFamily: 'monospace',
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  SizedBox(width: 2.w),
                  CustomIconWidget(
                    iconName: 'content_copy',
                    color: theme.colorScheme.primary,
                    size: 20,
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          OutlinedButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context, rootNavigator: true).pop();
            },
            child: Text('View Listing'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context, rootNavigator: true).pop();
            },
            child: Text('Done'),
          ),
        ],
      ),
    );
  }
}
