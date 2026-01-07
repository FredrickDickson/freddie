import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

/// Contract form section widget
/// Displays collapsible form section with fields
class ContractFormSectionWidget extends StatefulWidget {
  final Map<String, dynamic> section;
  final Map<String, dynamic> formData;
  final Function(String, dynamic) onFieldChanged;

  const ContractFormSectionWidget({
    Key? key,
    required this.section,
    required this.formData,
    required this.onFieldChanged,
  }) : super(key: key);

  @override
  State<ContractFormSectionWidget> createState() =>
      _ContractFormSectionWidgetState();
}

class _ContractFormSectionWidgetState extends State<ContractFormSectionWidget> {
  bool _isExpanded = true;

  Widget _buildField(Map<String, dynamic> field) {
    final theme = Theme.of(context);
    final fieldType = field["type"];
    final fieldKey = field["key"];
    final fieldValue = widget.formData[fieldKey];

    switch (fieldType) {
      case "text":
      case "phone":
      case "currency":
        return TextFormField(
          initialValue: fieldValue?.toString() ?? '',
          decoration: InputDecoration(
            labelText: field["label"],
            hintText: field["required"] == true
                ? '${field["label"]} *'
                : field["label"],
            suffixIcon: field["required"] == true
                ? CustomIconWidget(
                    iconName: 'star',
                    color: theme.colorScheme.error,
                    size: 3.w,
                  )
                : null,
          ),
          keyboardType: fieldType == "phone"
              ? TextInputType.phone
              : fieldType == "currency"
              ? TextInputType.number
              : TextInputType.text,
          onChanged: (value) => widget.onFieldChanged(fieldKey, value),
        );

      case "number":
        return TextFormField(
          initialValue: fieldValue?.toString() ?? '',
          decoration: InputDecoration(
            labelText: field["label"],
            hintText: field["required"] == true
                ? '${field["label"]} *'
                : field["label"],
            suffixIcon: field["required"] == true
                ? CustomIconWidget(
                    iconName: 'star',
                    color: theme.colorScheme.error,
                    size: 3.w,
                  )
                : null,
          ),
          keyboardType: TextInputType.number,
          onChanged: (value) => widget.onFieldChanged(fieldKey, value),
        );

      case "dropdown":
        return DropdownButtonFormField<String>(
          initialValue: fieldValue?.toString(),
          decoration: InputDecoration(
            labelText: field["label"],
            hintText: field["required"] == true
                ? '${field["label"]} *'
                : field["label"],
            suffixIcon: field["required"] == true
                ? CustomIconWidget(
                    iconName: 'star',
                    color: theme.colorScheme.error,
                    size: 3.w,
                  )
                : null,
          ),
          items: (field["options"] as List)
              .map(
                (option) => DropdownMenuItem<String>(
                  value: option,
                  child: Text(option),
                ),
              )
              .toList(),
          onChanged: (value) => widget.onFieldChanged(fieldKey, value),
        );

      case "checkbox":
        return CheckboxListTile(
          title: Text(field["label"], style: theme.textTheme.bodyMedium),
          value: fieldValue == true,
          onChanged: (value) => widget.onFieldChanged(fieldKey, value),
          contentPadding: EdgeInsets.zero,
          controlAffinity: ListTileControlAffinity.leading,
        );

      case "textarea":
        return TextFormField(
          initialValue: fieldValue?.toString() ?? '',
          decoration: InputDecoration(
            labelText: field["label"],
            hintText: field["required"] == true
                ? '${field["label"]} *'
                : field["label"],
            alignLabelWithHint: true,
          ),
          maxLines: 4,
          onChanged: (value) => widget.onFieldChanged(fieldKey, value),
        );

      default:
        return const SizedBox.shrink();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        children: [
          InkWell(
            onTap: () {
              setState(() {
                _isExpanded = !_isExpanded;
              });
            },
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            child: Container(
              padding: EdgeInsets.all(4.w),
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(2.w),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: CustomIconWidget(
                      iconName: widget.section["icon"],
                      color: theme.colorScheme.primary,
                      size: 5.w,
                    ),
                  ),
                  SizedBox(width: 3.w),
                  Expanded(
                    child: Text(
                      widget.section["title"],
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  CustomIconWidget(
                    iconName: _isExpanded ? 'expand_less' : 'expand_more',
                    color: theme.colorScheme.onSurfaceVariant,
                    size: 6.w,
                  ),
                ],
              ),
            ),
          ),
          if (_isExpanded)
            Padding(
              padding: EdgeInsets.fromLTRB(4.w, 0, 4.w, 4.w),
              child: Column(
                children: [
                  Divider(
                    color: theme.colorScheme.outline.withValues(alpha: 0.2),
                  ),
                  SizedBox(height: 2.h),
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: (widget.section["fields"] as List).length,
                    separatorBuilder: (context, index) => SizedBox(height: 2.h),
                    itemBuilder: (context, index) {
                      final field = (widget.section["fields"] as List)[index];
                      return _buildField(field);
                    },
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
