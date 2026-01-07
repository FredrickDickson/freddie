import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

/// Animated typing indicator for when other party is composing
class TypingIndicatorWidget extends StatefulWidget {
  final String userName;

  const TypingIndicatorWidget({Key? key, required this.userName})
    : super(key: key);

  @override
  State<TypingIndicatorWidget> createState() => _TypingIndicatorWidgetState();
}

class _TypingIndicatorWidgetState extends State<TypingIndicatorWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1500),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.5.h),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildDot(0),
                SizedBox(width: 1.w),
                _buildDot(1),
                SizedBox(width: 1.w),
                _buildDot(2),
              ],
            ),
          ),
          SizedBox(width: 2.w),
          Text(
            '${widget.userName} is typing...',
            style: theme.textTheme.labelSmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDot(int index) {
    final theme = Theme.of(context);
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final delay = index * 0.2;
        final value = (_controller.value - delay).clamp(0.0, 1.0);
        final opacity = (value < 0.5 ? value * 2 : (1 - value) * 2).clamp(
          0.3,
          1.0,
        );

        return Container(
          width: 2.w,
          height: 2.w,
          decoration: BoxDecoration(
            color: theme.colorScheme.onSurfaceVariant.withValues(
              alpha: opacity,
            ),
            shape: BoxShape.circle,
          ),
        );
      },
    );
  }
}
