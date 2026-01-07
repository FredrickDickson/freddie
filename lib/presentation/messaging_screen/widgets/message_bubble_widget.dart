import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

/// Individual message bubble with platform-appropriate styling
class MessageBubbleWidget extends StatelessWidget {
  final Map<String, dynamic> message;
  final bool isSender;
  final VoidCallback? onLongPress;

  const MessageBubbleWidget({
    Key? key,
    required this.message,
    required this.isSender,
    this.onLongPress,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final String content = message['content'] as String? ?? '';
    final String timestamp = message['timestamp'] as String? ?? '';
    final String status = message['status'] as String? ?? 'sent';
    final String? attachmentUrl = message['attachmentUrl'] as String?;
    final String? attachmentType = message['attachmentType'] as String?;
    final String? attachmentLabel = message['attachmentLabel'] as String?;

    return Align(
      alignment: isSender ? Alignment.centerRight : Alignment.centerLeft,
      child: GestureDetector(
        onLongPress: () => _showMessageOptions(context),
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 0.5.h),
          constraints: BoxConstraints(maxWidth: 75.w),
          child: Column(
            crossAxisAlignment: isSender
                ? CrossAxisAlignment.end
                : CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.5.h),
                decoration: BoxDecoration(
                  color: isSender
                      ? theme.colorScheme.primary
                      : theme.colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                    bottomLeft: Radius.circular(isSender ? 16 : 4),
                    bottomRight: Radius.circular(isSender ? 4 : 16),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (attachmentUrl != null && attachmentType != null) ...[
                      _buildAttachment(
                        context,
                        attachmentUrl,
                        attachmentType,
                        attachmentLabel ?? '',
                      ),
                      if (content.isNotEmpty) SizedBox(height: 1.h),
                    ],
                    if (content.isNotEmpty)
                      Text(
                        content,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: isSender
                              ? theme.colorScheme.onPrimary
                              : theme.colorScheme.onSurface,
                        ),
                      ),
                  ],
                ),
              ),
              SizedBox(height: 0.5.h),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    timestamp,
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  if (isSender) ...[
                    SizedBox(width: 1.w),
                    CustomIconWidget(
                      iconName: _getStatusIcon(status),
                      size: 14,
                      color: status == 'read'
                          ? theme.colorScheme.primary
                          : theme.colorScheme.onSurfaceVariant,
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAttachment(
    BuildContext context,
    String url,
    String type,
    String label,
  ) {
    final theme = Theme.of(context);

    if (type == 'image') {
      return ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: CustomImageWidget(
          imageUrl: url,
          width: 60.w,
          height: 40.w,
          fit: BoxFit.cover,
          semanticLabel: label,
        ),
      );
    }

    if (type == 'document') {
      return Container(
        padding: EdgeInsets.all(2.w),
        decoration: BoxDecoration(
          color: isSender
              ? theme.colorScheme.onPrimary.withValues(alpha: 0.1)
              : theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomIconWidget(
              iconName: 'description',
              size: 24,
              color: isSender
                  ? theme.colorScheme.onPrimary
                  : theme.colorScheme.primary,
            ),
            SizedBox(width: 2.w),
            Flexible(
              child: Text(
                url.split('/').last,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: isSender
                      ? theme.colorScheme.onPrimary
                      : theme.colorScheme.onSurface,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      );
    }

    return const SizedBox.shrink();
  }

  String _getStatusIcon(String status) {
    switch (status) {
      case 'sent':
        return 'check';
      case 'delivered':
        return 'done_all';
      case 'read':
        return 'done_all';
      default:
        return 'schedule';
    }
  }

  void _showMessageOptions(BuildContext context) {
    final theme = Theme.of(context);
    showModalBottomSheet(
      context: context,
      builder: (BuildContext sheetContext) => Container(
        padding: EdgeInsets.symmetric(vertical: 2.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: CustomIconWidget(
                iconName: 'content_copy',
                size: 24,
                color: theme.colorScheme.onSurface,
              ),
              title: Text('Copy', style: theme.textTheme.bodyLarge),
              onTap: () {
                Clipboard.setData(
                  ClipboardData(text: message['content'] as String? ?? ''),
                );
                Navigator.pop(sheetContext);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Message copied to clipboard'),
                    duration: Duration(seconds: 2),
                  ),
                );
              },
            ),
            if (isSender)
              ListTile(
                leading: CustomIconWidget(
                  iconName: 'delete_outline',
                  size: 24,
                  color: theme.colorScheme.error,
                ),
                title: Text(
                  'Delete',
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: theme.colorScheme.error,
                  ),
                ),
                onTap: () {
                  Navigator.pop(sheetContext);
                  onLongPress?.call();
                },
              ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'flag',
                size: 24,
                color: theme.colorScheme.error,
              ),
              title: Text(
                'Report',
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: theme.colorScheme.error,
                ),
              ),
              onTap: () {
                Navigator.pop(sheetContext);
                _showReportDialog(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showReportDialog(BuildContext context) {
    final theme = Theme.of(context);
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) => AlertDialog(
        title: Text('Report Message', style: theme.textTheme.titleLarge),
        content: Text(
          'Are you sure you want to report this message? Our team will review it.',
          style: theme.textTheme.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: Text(
              'Cancel',
              style: theme.textTheme.labelLarge?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Message reported successfully'),
                  duration: Duration(seconds: 2),
                ),
              );
            },
            child: Text(
              'Report',
              style: theme.textTheme.labelLarge?.copyWith(
                color: theme.colorScheme.error,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
