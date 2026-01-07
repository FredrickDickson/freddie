import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

/// Personal information card with editable fields
class PersonalInfoCardWidget extends StatefulWidget {
  final Map<String, dynamic> userData;
  final Function(Map<String, dynamic>) onUpdate;

  const PersonalInfoCardWidget({
    Key? key,
    required this.userData,
    required this.onUpdate,
  }) : super(key: key);

  @override
  State<PersonalInfoCardWidget> createState() => _PersonalInfoCardWidgetState();
}

class _PersonalInfoCardWidgetState extends State<PersonalInfoCardWidget> {
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.userData['name']);
    _emailController = TextEditingController(text: widget.userData['email']);
    _phoneController = TextEditingController(text: widget.userData['phone']);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _toggleEdit() {
    if (_isEditing) {
      widget.onUpdate({
        'name': _nameController.text,
        'email': _emailController.text,
        'phone': _phoneController.text,
      });
    }
    setState(() => _isEditing = !_isEditing);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      child: Padding(
        padding: EdgeInsets.all(4.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Personal Information',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                IconButton(
                  onPressed: _toggleEdit,
                  icon: CustomIconWidget(
                    iconName: _isEditing ? 'check' : 'edit',
                    color: theme.colorScheme.primary,
                    size: 5.w,
                  ),
                ),
              ],
            ),
            SizedBox(height: 2.h),
            _buildInfoField(
              context: context,
              label: 'Full Name',
              controller: _nameController,
              icon: 'person',
              enabled: _isEditing,
            ),
            SizedBox(height: 2.h),
            _buildInfoField(
              context: context,
              label: 'Email Address',
              controller: _emailController,
              icon: 'email',
              enabled: _isEditing,
              keyboardType: TextInputType.emailAddress,
            ),
            SizedBox(height: 2.h),
            _buildInfoField(
              context: context,
              label: 'Phone Number',
              controller: _phoneController,
              icon: 'phone',
              enabled: _isEditing,
              keyboardType: TextInputType.phone,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoField({
    required BuildContext context,
    required String label,
    required TextEditingController controller,
    required String icon,
    required bool enabled,
    TextInputType? keyboardType,
  }) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: theme.textTheme.labelMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        SizedBox(height: 0.5.h),
        TextField(
          controller: controller,
          enabled: enabled,
          keyboardType: keyboardType,
          style: theme.textTheme.bodyLarge,
          decoration: InputDecoration(
            prefixIcon: Padding(
              padding: EdgeInsets.all(3.w),
              child: CustomIconWidget(
                iconName: icon,
                color: enabled
                    ? theme.colorScheme.primary
                    : theme.colorScheme.onSurfaceVariant,
                size: 5.w,
              ),
            ),
            filled: true,
            fillColor: enabled
                ? theme.colorScheme.surface
                : theme.colorScheme.surfaceContainerHighest,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: theme.colorScheme.outline),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: theme.colorScheme.outline),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: theme.colorScheme.primary,
                width: 2,
              ),
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: theme.colorScheme.outline.withValues(alpha: 0.5),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
