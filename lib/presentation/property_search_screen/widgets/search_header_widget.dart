import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class SearchHeaderWidget extends StatefulWidget {
  final TextEditingController controller;
  final List<String> searchHistory;
  final ValueChanged<String> onSearchChanged;
  final ValueChanged<String> onSearchSubmitted;
  final ValueChanged<String> onHistoryItemTap;

  const SearchHeaderWidget({
    Key? key,
    required this.controller,
    required this.searchHistory,
    required this.onSearchChanged,
    required this.onSearchSubmitted,
    required this.onHistoryItemTap,
  }) : super(key: key);

  @override
  State<SearchHeaderWidget> createState() => _SearchHeaderWidgetState();
}

class _SearchHeaderWidgetState extends State<SearchHeaderWidget> {
  bool _showHistory = false;
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      setState(() {
        _showHistory = _focusNode.hasFocus && widget.searchHistory.isNotEmpty;
      });
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.fromLTRB(4.w, 2.h, 4.w, 1.h),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Search Input
          Container(
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: _focusNode.hasFocus
                    ? theme.colorScheme.primary
                    : theme.colorScheme.outline.withValues(alpha: 0.2),
                width: _focusNode.hasFocus ? 2 : 1,
              ),
            ),
            child: TextField(
              controller: widget.controller,
              focusNode: _focusNode,
              onChanged: widget.onSearchChanged,
              onSubmitted: (value) {
                widget.onSearchSubmitted(value);
                _focusNode.unfocus();
              },
              style: theme.textTheme.bodyLarge,
              decoration: InputDecoration(
                hintText: 'Search location, property type...',
                hintStyle: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant.withValues(
                    alpha: 0.6,
                  ),
                ),
                prefixIcon: Padding(
                  padding: EdgeInsets.all(3.w),
                  child: CustomIconWidget(
                    iconName: 'search',
                    size: 24,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                suffixIcon: widget.controller.text.isNotEmpty
                    ? Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: CustomIconWidget(
                              iconName: 'mic',
                              size: 22,
                              color: theme.colorScheme.primary,
                            ),
                            onPressed: () {
                              // Voice search functionality
                            },
                          ),
                          IconButton(
                            icon: CustomIconWidget(
                              iconName: 'clear',
                              size: 20,
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                            onPressed: () {
                              widget.controller.clear();
                              widget.onSearchChanged('');
                            },
                          ),
                        ],
                      )
                    : Padding(
                        padding: EdgeInsets.all(3.w),
                        child: IconButton(
                          icon: CustomIconWidget(
                            iconName: 'mic',
                            size: 22,
                            color: theme.colorScheme.primary,
                          ),
                          onPressed: () {
                            // Voice search functionality
                          },
                        ),
                      ),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 4.w,
                  vertical: 1.5.h,
                ),
              ),
            ),
          ),

          // Search History Dropdown
          if (_showHistory) ...[
            SizedBox(height: 1.h),
            Container(
              constraints: BoxConstraints(maxHeight: 25.h),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: theme.colorScheme.outline.withValues(alpha: 0.2),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ListView.separated(
                shrinkWrap: true,
                padding: EdgeInsets.symmetric(vertical: 1.h),
                itemCount: widget.searchHistory.length,
                separatorBuilder: (context, index) => Divider(
                  height: 1,
                  color: theme.colorScheme.outline.withValues(alpha: 0.1),
                ),
                itemBuilder: (context, index) {
                  final query = widget.searchHistory[index];
                  return InkWell(
                    onTap: () {
                      widget.onHistoryItemTap(query);
                      _focusNode.unfocus();
                    },
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 4.w,
                        vertical: 1.5.h,
                      ),
                      child: Row(
                        children: [
                          CustomIconWidget(
                            iconName: 'history',
                            size: 20,
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                          SizedBox(width: 3.w),
                          Expanded(
                            child: Text(
                              query,
                              style: theme.textTheme.bodyMedium,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          CustomIconWidget(
                            iconName: 'north_west',
                            size: 18,
                            color: theme.colorScheme.onSurfaceVariant
                                .withValues(alpha: 0.5),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ],
      ),
    );
  }
}
