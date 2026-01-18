import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class GenUiFormWidget extends StatefulWidget {
  final List<Map<String, dynamic>> steps;
  final Map<String, dynamic> formData;
  final Function(String, dynamic) onFieldChanged;
  final VoidCallback onComplete;

  const GenUiFormWidget({
    Key? key,
    required this.steps,
    required this.formData,
    required this.onFieldChanged,
    required this.onComplete,
  }) : super(key: key);

  @override
  State<GenUiFormWidget> createState() => _GenUiFormWidgetState();
}

class _GenUiFormWidgetState extends State<GenUiFormWidget> {
  int _currentStepIndex = 0;

  void _nextStep() {
    if (_currentStepIndex < widget.steps.length - 1) {
      setState(() {
        _currentStepIndex++;
      });
    } else {
      widget.onComplete();
    }
  }

  void _previousStep() {
    if (_currentStepIndex > 0) {
      setState(() {
        _currentStepIndex--;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final currentStep = widget.steps[_currentStepIndex];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.all(4.w),
          child: Text(
            currentStep['question'] ?? '',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Expanded(
          child: ListView.separated(
            padding: EdgeInsets.symmetric(horizontal: 4.w),
            itemCount: (currentStep['fields'] as List).length,
            separatorBuilder: (context, index) => SizedBox(height: 2.h),
            itemBuilder: (context, index) {
              final field = currentStep['fields'][index];
              return _buildField(field);
            },
          ),
        ),
        Container(
          padding: EdgeInsets.all(4.w),
          child: Row(
            children: [
              if (_currentStepIndex > 0)
                Expanded(
                  child: OutlinedButton(
                    onPressed: _previousStep,
                    child: const Text('Back'),
                  ),
                ),
              if (_currentStepIndex > 0) SizedBox(width: 4.w),
              Expanded(
                child: ElevatedButton(
                  onPressed: _nextStep,
                  child: Text(_currentStepIndex == widget.steps.length - 1 ? 'Generate' : 'Next'),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildField(Map<String, dynamic> field) {
    final theme = Theme.of(context);
    final key = field['key'];
    final label = field['label'];
    final type = field['type'];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: theme.textTheme.labelLarge?.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 1.h),
        TextFormField(
          initialValue: widget.formData[key]?.toString() ?? '',
          onChanged: (value) => widget.onFieldChanged(key, value),
          decoration: InputDecoration(
            hintText: 'Enter $label',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          keyboardType: type == 'number' || type == 'currency' ? TextInputType.number : TextInputType.text,
        ),
      ],
    );
  }
}
