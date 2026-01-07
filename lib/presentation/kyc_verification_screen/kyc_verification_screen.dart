
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../widgets/custom_icon_widget.dart';
import './widgets/document_type_selector_widget.dart';
import './widgets/document_upload_widget.dart';
import './widgets/selfie_capture_widget.dart';
import './widgets/verification_progress_widget.dart';

class KycVerificationScreen extends StatefulWidget {
  const KycVerificationScreen({Key? key}) : super(key: key);

  @override
  State<KycVerificationScreen> createState() => _KycVerificationScreenState();
}

class _KycVerificationScreenState extends State<KycVerificationScreen> {
  int _currentStep = 0;
  String _selectedDocumentType = 'National ID';
  XFile? _documentImage;
  XFile? _selfieImage;
  bool _isProcessing = false;

  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _documentNumberController =
      TextEditingController();
  final TextEditingController _dateOfBirthController = TextEditingController();

  @override
  void dispose() {
    _fullNameController.dispose();
    _documentNumberController.dispose();
    _dateOfBirthController.dispose();
    super.dispose();
  }

  void _handleDocumentTypeChange(String type) {
    setState(() {
      _selectedDocumentType = type;
      _documentImage = null;
    });
  }

  void _handleDocumentCapture(XFile image) {
    setState(() {
      _documentImage = image;
    });
  }

  void _handleSelfieCapture(XFile image) {
    setState(() {
      _selfieImage = image;
    });
  }

  bool _canProceedToNextStep() {
    switch (_currentStep) {
      case 0:
        return _documentImage != null;
      case 1:
        return _selfieImage != null;
      case 2:
        return _fullNameController.text.isNotEmpty &&
            _documentNumberController.text.isNotEmpty &&
            _dateOfBirthController.text.isNotEmpty;
      default:
        return false;
    }
  }

  void _handleNextStep() {
    if (!_canProceedToNextStep()) return;

    if (_currentStep < 2) {
      setState(() {
        _currentStep++;
      });
    } else {
      _submitVerification();
    }
  }

  void _handlePreviousStep() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep--;
      });
    }
  }

  Future<void> _submitVerification() async {
    setState(() {
      _isProcessing = true;
    });

    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isProcessing = false;
    });

    if (!mounted) return;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            CustomIconWidget(
              iconName: 'check_circle',
              color: Theme.of(context).colorScheme.primary,
              size: 28,
            ),
            SizedBox(width: 2.w),
            Text(
              'Verification Submitted',
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ],
        ),
        content: Text(
          'Your documents have been submitted successfully. Our team will review your information within 24-48 hours. You will receive a notification once verification is complete.',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(
                context,
                rootNavigator: true,
              ).pushNamed('/property-dashboard');
            },
            child: const Text('Continue to Dashboard'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.appBarTheme.backgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: CustomIconWidget(
            iconName: 'arrow_back',
            color:
                theme.appBarTheme.foregroundColor ??
                theme.colorScheme.onSurface,
            size: 24,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'KYC Verification',
          style: theme.appBarTheme.titleTextStyle,
        ),
      ),
      body: _isProcessing
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(color: theme.colorScheme.primary),
                  SizedBox(height: 2.h),
                  Text(
                    'Processing your verification...',
                    style: theme.textTheme.bodyLarge,
                  ),
                ],
              ),
            )
          : Column(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                  color: theme.colorScheme.surface,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Secure Your Account',
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 1.h),
                      Text(
                        'Complete identity verification to access all marketplace features and build trust with other users.',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                      SizedBox(height: 2.h),
                      VerificationProgressWidget(
                        currentStep: _currentStep,
                        totalSteps: 3,
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.symmetric(
                      horizontal: 4.w,
                      vertical: 2.h,
                    ),
                    child: _buildStepContent(theme),
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surface,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 8,
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
                              onPressed: _handlePreviousStep,
                              style: OutlinedButton.styleFrom(
                                padding: EdgeInsets.symmetric(vertical: 1.5.h),
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
                          flex: _currentStep > 0 ? 1 : 1,
                          child: ElevatedButton(
                            onPressed: _canProceedToNextStep()
                                ? _handleNextStep
                                : null,
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.symmetric(vertical: 1.5.h),
                              backgroundColor: theme.colorScheme.primary,
                              foregroundColor: theme.colorScheme.onPrimary,
                              disabledBackgroundColor: theme
                                  .colorScheme
                                  .onSurfaceVariant
                                  .withValues(alpha: 0.3),
                            ),
                            child: Text(
                              _currentStep < 2
                                  ? 'Continue'
                                  : 'Submit Verification',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildStepContent(ThemeData theme) {
    switch (_currentStep) {
      case 0:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Step 1: Upload ID Document',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 1.h),
            Text(
              'Take a clear photo of your government-issued ID. Ensure all text is readable and the document is not expired.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            SizedBox(height: 3.h),
            DocumentTypeSelectorWidget(
              selectedType: _selectedDocumentType,
              onTypeChanged: _handleDocumentTypeChange,
            ),
            SizedBox(height: 3.h),
            DocumentUploadWidget(
              documentType: _selectedDocumentType,
              capturedImage: _documentImage,
              onImageCaptured: _handleDocumentCapture,
            ),
          ],
        );
      case 1:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Step 2: Take a Selfie',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 1.h),
            Text(
              'Take a clear selfie for face verification. Remove glasses and ensure good lighting. Your face should match the photo on your ID.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            SizedBox(height: 3.h),
            SelfieCaptureWidget(
              capturedImage: _selfieImage,
              onImageCaptured: _handleSelfieCapture,
            ),
          ],
        );
      case 2:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Step 3: Confirm Your Information',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 1.h),
            Text(
              'Review and confirm the information extracted from your document. Make corrections if needed.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            SizedBox(height: 3.h),
            TextField(
              controller: _fullNameController,
              decoration: InputDecoration(
                labelText: 'Full Name',
                hintText: 'Enter your full name as shown on ID',
                prefixIcon: Icon(Icons.person_outline, size: 20),
              ),
              style: theme.textTheme.bodyLarge,
            ),
            SizedBox(height: 2.h),
            TextField(
              controller: _documentNumberController,
              decoration: InputDecoration(
                labelText: 'Document Number',
                hintText: 'Enter your ID number',
                prefixIcon: Icon(Icons.badge_outlined, size: 20),
              ),
              style: theme.textTheme.bodyLarge,
            ),
            SizedBox(height: 2.h),
            TextField(
              controller: _dateOfBirthController,
              decoration: InputDecoration(
                labelText: 'Date of Birth',
                hintText: 'DD/MM/YYYY',
                prefixIcon: Icon(Icons.calendar_today_outlined, size: 20),
              ),
              style: theme.textTheme.bodyLarge,
              keyboardType: TextInputType.datetime,
            ),
            SizedBox(height: 3.h),
            Container(
              padding: EdgeInsets.all(3.w),
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: theme.colorScheme.primary.withValues(alpha: 0.3),
                  width: 1,
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomIconWidget(
                    iconName: 'info_outline',
                    color: theme.colorScheme.primary,
                    size: 20,
                  ),
                  SizedBox(width: 2.w),
                  Expanded(
                    child: Text(
                      'Your information will be kept secure and used only for verification purposes. Review time: 24-48 hours.',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      default:
        return const SizedBox.shrink();
    }
  }
}
