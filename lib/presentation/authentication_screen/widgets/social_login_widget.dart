import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

/// Social login widget providing Google and Facebook authentication options.
/// Implements platform-native SDK integration with proper button styling.
class SocialLoginWidget extends StatelessWidget {
  final VoidCallback onGoogleLogin;
  final VoidCallback onFacebookLogin;
  final bool isLoading;

  const SocialLoginWidget({
    Key? key,
    required this.onGoogleLogin,
    required this.onFacebookLogin,
    required this.isLoading,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        Row(
          children: [
            Expanded(child: Divider(color: theme.colorScheme.outline)),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 3.w),
              child: Text(
                'OR',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Expanded(child: Divider(color: theme.colorScheme.outline)),
          ],
        ),
        SizedBox(height: 3.h),
        Text(
          'Continue with',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        SizedBox(height: 2.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildSocialButton(
              context: context,
              icon: 'g_logo',
              label: 'Google',
              onPressed: isLoading ? null : onGoogleLogin,
              backgroundColor: Colors.white,
              borderColor: theme.colorScheme.outline,
            ),
            SizedBox(width: 4.w),
            _buildSocialButton(
              context: context,
              icon: 'facebook',
              label: 'Facebook',
              onPressed: isLoading ? null : onFacebookLogin,
              backgroundColor: const Color(0xFF1877F2),
              borderColor: const Color(0xFF1877F2),
              isWhiteIcon: true,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSocialButton({
    required BuildContext context,
    required String icon,
    required String label,
    required VoidCallback? onPressed,
    required Color backgroundColor,
    required Color borderColor,
    bool isWhiteIcon = false,
  }) {
    final theme = Theme.of(context);

    return Expanded(
      child: Container(
        height: 6.h,
        decoration: BoxDecoration(
          color: backgroundColor,
          border: Border.all(color: borderColor),
          borderRadius: BorderRadius.circular(2.w),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onPressed,
            borderRadius: BorderRadius.circular(2.w),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 3.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomIconWidget(
                    iconName: icon == 'g_logo' ? 'g_translate' : 'facebook',
                    color: isWhiteIcon
                        ? Colors.white
                        : theme.colorScheme.onSurface,
                    size: 5.w,
                  ),
                  SizedBox(width: 2.w),
                  Flexible(
                    child: Text(
                      label,
                      style: theme.textTheme.titleSmall?.copyWith(
                        color: isWhiteIcon
                            ? Colors.white
                            : theme.colorScheme.onSurface,
                        fontWeight: FontWeight.w600,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
