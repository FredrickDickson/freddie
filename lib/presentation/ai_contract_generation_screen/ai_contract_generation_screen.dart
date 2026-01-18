import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/custom_icon_widget.dart';
import '../../core/services/ai_service.dart';
import './widgets/gen_ui_form_widget.dart';
import './widgets/ai_suggestion_widget.dart';
import './widgets/contract_form_section_widget.dart';
import './widgets/contract_preview_widget.dart';
import './widgets/contract_template_card_widget.dart';
import './widgets/signature_pad_widget.dart';

/// AI Contract Generation Screen
/// Automates legal document creation with mobile-friendly form interface
/// and e-signature integration
class AiContractGenerationScreen extends StatefulWidget {
  const AiContractGenerationScreen({Key? key}) : super(key: key);

  @override
  State<AiContractGenerationScreen> createState() =>
      _AiContractGenerationScreenState();
}

class _AiContractGenerationScreenState
    extends State<AiContractGenerationScreen> {
  int _currentStep = 0;
  String _selectedContractType = '';
  bool _isGenerating = false;
  // State variables
  final Map<String, dynamic> _formData = {};
  final List<Map<String, dynamic>> _aiSuggestions = [];
  List<Map<String, dynamic>> _genUiSteps = [];
  bool _useGenUi = true; // Toggle for GenUI mode

  // Mock contract templates
  final List<Map<String, dynamic>> _contractTemplates = [
    {
      "id": "lease",
      "type": "Lease Agreement",
      "description":
          "Standard residential lease agreement for rental properties",
      "jurisdiction": "Lagos State, Nigeria",
      "icon": "description",
      "color": 0xFF4A90A4,
      "estimatedTime": "5-7 minutes",
      "thumbnail":
          "https://images.unsplash.com/photo-1450101499163-c8848c66ca85?w=400",
      "semanticLabel":
          "Document with pen on wooden desk representing lease agreement",
    },
    {
      "id": "sale",
      "type": "Sale Agreement",
      "description": "Property purchase and sale agreement with transfer terms",
      "jurisdiction": "Federal Capital Territory, Nigeria",
      "icon": "home_work",
      "color": 0xFF2D5A27,
      "estimatedTime": "8-10 minutes",
      "thumbnail":
          "https://images.unsplash.com/photo-1560518883-ce09059eeffa?w=400",
      "semanticLabel":
          "Modern house exterior with sold sign representing property sale",
    },
    {
      "id": "shortlet",
      "type": "Short-let Agreement",
      "description": "Temporary accommodation agreement for vacation rentals",
      "jurisdiction": "Lagos State, Nigeria",
      "icon": "event_available",
      "color": 0xFFE8B931,
      "estimatedTime": "3-5 minutes",
      "thumbnail":
          "https://images.unsplash.com/photo-1582268611958-ebfd161ef9cf?w=400",
      "semanticLabel":
          "Cozy apartment interior with calendar representing short-term rental",
    },
  ];

  // Mock form sections
  final List<Map<String, dynamic>> _formSections = [
    {
      "title": "Property Details",
      "icon": "home",
      "fields": [
        {
          "label": "Property Address",
          "key": "propertyAddress",
          "type": "text",
          "required": true,
          "autoFill": "123 Lekki Phase 1, Lagos, Nigeria",
        },
        {
          "label": "Property Type",
          "key": "propertyType",
          "type": "dropdown",
          "required": true,
          "options": ["Apartment", "House", "Duplex", "Commercial"],
          "autoFill": "Apartment",
        },
        {
          "label": "Number of Bedrooms",
          "key": "bedrooms",
          "type": "number",
          "required": true,
          "autoFill": "3",
        },
        {
          "label": "Number of Bathrooms",
          "key": "bathrooms",
          "type": "number",
          "required": true,
          "autoFill": "2",
        },
      ],
    },
    {
      "title": "Parties Information",
      "icon": "people",
      "fields": [
        {
          "label": "Landlord Name",
          "key": "landlordName",
          "type": "text",
          "required": true,
          "autoFill": "Adebayo Okonkwo",
        },
        {
          "label": "Landlord Phone",
          "key": "landlordPhone",
          "type": "phone",
          "required": true,
          "autoFill": "+234 803 456 7890",
        },
        {
          "label": "Tenant Name",
          "key": "tenantName",
          "type": "text",
          "required": true,
          "autoFill": "Chioma Nwankwo",
        },
        {
          "label": "Tenant Phone",
          "key": "tenantPhone",
          "type": "phone",
          "required": true,
          "autoFill": "+234 805 123 4567",
        },
      ],
    },
    {
      "title": "Financial Terms",
      "icon": "payments",
      "fields": [
        {
          "label": "Monthly Rent",
          "key": "monthlyRent",
          "type": "currency",
          "required": true,
          "autoFill": "₦500,000",
        },
        {
          "label": "Security Deposit",
          "key": "securityDeposit",
          "type": "currency",
          "required": true,
          "autoFill": "₦1,000,000",
        },
        {
          "label": "Lease Duration",
          "key": "leaseDuration",
          "type": "dropdown",
          "required": true,
          "options": ["6 Months", "1 Year", "2 Years", "3 Years"],
          "autoFill": "1 Year",
        },
        {
          "label": "Payment Method",
          "key": "paymentMethod",
          "type": "dropdown",
          "required": true,
          "options": ["Bank Transfer", "Cash", "Cheque"],
          "autoFill": "Bank Transfer",
        },
      ],
    },
    {
      "title": "Special Conditions",
      "icon": "rule",
      "fields": [
        {
          "label": "Pets Allowed",
          "key": "petsAllowed",
          "type": "checkbox",
          "required": false,
          "autoFill": false,
        },
        {
          "label": "Smoking Allowed",
          "key": "smokingAllowed",
          "type": "checkbox",
          "required": false,
          "autoFill": false,
        },
        {
          "label": "Subletting Allowed",
          "key": "sublettingAllowed",
          "type": "checkbox",
          "required": false,
          "autoFill": false,
        },
        {
          "label": "Additional Terms",
          "key": "additionalTerms",
          "type": "textarea",
          "required": false,
          "autoFill":
              "Tenant is responsible for utility bills. Property must be maintained in good condition.",
        },
      ],
    },
  ];

  // AI suggestions
  Future<void> _generateAISuggestions() async {
    final suggestions = await AiService().getContractSuggestions(_formData);
    setState(() {
      _aiSuggestions.clear();
      _aiSuggestions.addAll(suggestions);
    });
  }

  Future<void> _selectContractTemplate(String templateId) async {
    setState(() {
      _selectedContractType = templateId;
      _currentStep = 1;
    });
    
    _generateAISuggestions();
    
    final steps = await AiService().getGenUiForm(templateId);
    setState(() {
      _genUiSteps = steps;
      // Auto-fill form data
      for (var section in _formSections) {
        for (var field in (section["fields"] as List)) {
          if (field["autoFill"] != null) {
            _formData[field["key"]] = field["autoFill"];
          }
        }
      }
    });
  }

  void _updateFormData(String key, dynamic value) {
    setState(() {
      _formData[key] = value;
    });
  }

  void _applySuggestion(Map<String, dynamic> suggestion) {
    setState(() {
      _formData[suggestion["field"]] = suggestion["suggestion"];
      _aiSuggestions.remove(suggestion);
    });
  }

  Future<void> _generateContract() async {
    setState(() {
      _isGenerating = true;
    });

    final result = await AiService().generateContract(_formData);

    setState(() {
      _isGenerating = false;
      if (result['status'] == 'success') {
        _currentStep = 2;
      } else {
        // Handle error
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error generating contract: ${result['error']}')),
        );
      }
    });
  }

  void _proceedToSigning() {
    setState(() {
      _currentStep = 3;
    });
  }

  void _completeContract() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Contract generated successfully! Both parties will receive a secure link for review and signature.',
          style: TextStyle(fontSize: 12.sp),
        ),
        backgroundColor: const Color(0xFF2D5A27),
        duration: const Duration(seconds: 4),
      ),
    );

    Navigator.of(
      context,
      rootNavigator: true,
    ).pushReplacementNamed('/property-dashboard');
  }

  Widget _buildStepIndicator() {
    final theme = Theme.of(context);
    final steps = ["Select Template", "Fill Details", "Preview", "Sign"];

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      color: theme.colorScheme.surface,
      child: Row(
        children: List.generate(steps.length, (index) {
          final isActive = index == _currentStep;
          final isCompleted = index < _currentStep;

          return Expanded(
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      Container(
                        width: 8.w,
                        height: 8.w,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isCompleted
                              ? const Color(0xFF2D5A27)
                              : isActive
                              ? theme.colorScheme.primary
                              : theme.colorScheme.surfaceContainerHighest,
                        ),
                        child: Center(
                          child: isCompleted
                              ? CustomIconWidget(
                                  iconName: 'check',
                                  color: Colors.white,
                                  size: 4.w,
                                )
                              : Text(
                                  '${index + 1}',
                                  style: theme.textTheme.labelMedium?.copyWith(
                                    color: isActive
                                        ? Colors.white
                                        : theme.colorScheme.onSurfaceVariant,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                        ),
                      ),
                      SizedBox(height: 0.5.h),
                      Text(
                        steps[index],
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: isActive
                              ? theme.colorScheme.primary
                              : theme.colorScheme.onSurfaceVariant,
                          fontWeight: isActive
                              ? FontWeight.w600
                              : FontWeight.w400,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                if (index < steps.length - 1)
                  Container(
                    width: 4.w,
                    height: 0.2.h,
                    color: isCompleted
                        ? const Color(0xFF2D5A27)
                        : theme.colorScheme.surfaceContainerHighest,
                  ),
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget _buildTemplateSelection() {
    final theme = Theme.of(context);

    return SingleChildScrollView(
      padding: EdgeInsets.all(4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Select Contract Template',
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            'Choose the appropriate contract type based on your property transaction',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          SizedBox(height: 3.h),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _contractTemplates.length,
            separatorBuilder: (context, index) => SizedBox(height: 2.h),
            itemBuilder: (context, index) {
              final template = _contractTemplates[index];
              return ContractTemplateCardWidget(
                template: template,
                onTap: () => _selectContractTemplate(template["id"]),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildFormFilling() {
    if (_useGenUi && _genUiSteps.isNotEmpty) {
      return GenUiFormWidget(
        steps: _genUiSteps,
        formData: _formData,
        onFieldChanged: _updateFormData,
        onComplete: _generateContract,
      );
    }

    final theme = Theme.of(context);
    // ... existing static form implementation ...

    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(4.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (_aiSuggestions.isNotEmpty) ...[
                  Text(
                    'AI Suggestions',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 1.h),
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _aiSuggestions.length,
                    separatorBuilder: (context, index) => SizedBox(height: 1.h),
                    itemBuilder: (context, index) {
                      return AiSuggestionWidget(
                        suggestion: _aiSuggestions[index],
                        onApply: () => _applySuggestion(_aiSuggestions[index]),
                      );
                    },
                  ),
                  SizedBox(height: 3.h),
                ],
                Text(
                  'Contract Details',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 2.h),
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _formSections.length,
                  separatorBuilder: (context, index) => SizedBox(height: 2.h),
                  itemBuilder: (context, index) {
                    return ContractFormSectionWidget(
                      section: _formSections[index],
                      formData: _formData,
                      onFieldChanged: _updateFormData,
                    );
                  },
                ),
              ],
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.all(4.w),
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
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isGenerating ? null : _generateContract,
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 2.h),
                ),
                child: _isGenerating
                    ? SizedBox(
                        width: 5.w,
                        height: 5.w,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            theme.colorScheme.onPrimary,
                          ),
                        ),
                      )
                    : Text(
                        'Generate Contract',
                        style: theme.textTheme.labelLarge?.copyWith(
                          color: theme.colorScheme.onPrimary,
                        ),
                      ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPreview() {
    return Column(
      children: [
        Expanded(
          child: ContractPreviewWidget(
            contractType: _selectedContractType,
            formData: _formData,
          ),
        ),
        Container(
          padding: EdgeInsets.all(4.w),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
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
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      setState(() {
                        _currentStep = 1;
                      });
                    },
                    style: OutlinedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 2.h),
                    ),
                    child: Text('Edit Details'),
                  ),
                ),
                SizedBox(width: 2.w),
                Expanded(
                  flex: 2,
                  child: ElevatedButton(
                    onPressed: _proceedToSigning,
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 2.h),
                    ),
                    child: Text('Proceed to Sign'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSigning() {
    return Column(
      children: [
        Expanded(child: SignaturePadWidget(onComplete: _completeContract)),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: CustomAppBar(
        title: 'AI Contract Generation',
        leading: IconButton(
          icon: CustomIconWidget(
            iconName: 'arrow_back',
            color: theme.colorScheme.onSurface,
            size: 6.w,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          if (_currentStep > 0)
            IconButton(
              icon: CustomIconWidget(
                iconName: 'help_outline',
                color: theme.colorScheme.onSurface,
                size: 6.w,
              ),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text('Contract Generation Help'),
                    content: Text(
                      'Our AI analyzes your property details and generates legally compliant contracts based on Nigerian property law. All contracts include blockchain verification for authenticity.',
                      style: theme.textTheme.bodyMedium,
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text('Got it'),
                      ),
                    ],
                  ),
                );
              },
            ),
        ],
      ),
      body: Column(
        children: [
          _buildStepIndicator(),
          Expanded(
            child: _currentStep == 0
                ? _buildTemplateSelection()
                : _currentStep == 1
                ? _buildFormFilling()
                : _currentStep == 2
                ? _buildPreview()
                : _buildSigning(),
          ),
        ],
      ),
    );
  }
}
