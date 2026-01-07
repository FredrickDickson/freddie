import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Custom app bar widget for property marketplace app.
/// Implements adaptive header with search integration and contextual actions.
/// Responds to scroll behavior and maintains thumb accessibility.
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  /// Title text to display
  final String? title;

  /// Optional title widget (overrides title text)
  final Widget? titleWidget;

  /// Leading widget (typically back button or menu)
  final Widget? leading;

  /// Actions to display on the right side
  final List<Widget>? actions;

  /// Whether to show back button automatically
  final bool automaticallyImplyLeading;

  /// Background color override
  final Color? backgroundColor;

  /// Foreground color override
  final Color? foregroundColor;

  /// Elevation override
  final double? elevation;

  /// Whether to center the title
  final bool centerTitle;

  /// Bottom widget (typically TabBar)
  final PreferredSizeWidget? bottom;

  /// System overlay style for status bar
  final SystemUiOverlayStyle? systemOverlayStyle;

  /// Whether this app bar is flexible (for use in SliverAppBar)
  final bool isFlexible;

  /// Scroll controller for scroll-aware behavior
  final ScrollController? scrollController;

  const CustomAppBar({
    Key? key,
    this.title,
    this.titleWidget,
    this.leading,
    this.actions,
    this.automaticallyImplyLeading = true,
    this.backgroundColor,
    this.foregroundColor,
    this.elevation,
    this.centerTitle = false,
    this.bottom,
    this.systemOverlayStyle,
    this.isFlexible = false,
    this.scrollController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appBarTheme = theme.appBarTheme;

    return AppBar(
      title: titleWidget ?? (title != null ? Text(title!) : null),
      leading: leading,
      actions: actions,
      automaticallyImplyLeading: automaticallyImplyLeading,
      backgroundColor: backgroundColor ?? appBarTheme.backgroundColor,
      foregroundColor: foregroundColor ?? appBarTheme.foregroundColor,
      elevation: elevation ?? appBarTheme.elevation,
      scrolledUnderElevation: appBarTheme.scrolledUnderElevation,
      shadowColor: appBarTheme.shadowColor,
      centerTitle: centerTitle,
      titleTextStyle: appBarTheme.titleTextStyle,
      bottom: bottom,
      systemOverlayStyle: systemOverlayStyle ?? _getSystemOverlayStyle(context),
    );
  }

  /// Get appropriate system overlay style based on theme
  SystemUiOverlayStyle _getSystemOverlayStyle(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    return brightness == Brightness.light
        ? SystemUiOverlayStyle.dark
        : SystemUiOverlayStyle.light;
  }

  @override
  Size get preferredSize {
    final double bottomHeight = bottom?.preferredSize.height ?? 0.0;
    return Size.fromHeight(kToolbarHeight + bottomHeight);
  }
}

/// Custom search app bar variant with integrated search field
class CustomSearchAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  /// Search text controller
  final TextEditingController? controller;

  /// Hint text for search field
  final String hintText;

  /// Callback when search text changes
  final ValueChanged<String>? onChanged;

  /// Callback when search is submitted
  final ValueChanged<String>? onSubmitted;

  /// Leading widget (typically back button)
  final Widget? leading;

  /// Actions to display on the right side
  final List<Widget>? actions;

  /// Background color override
  final Color? backgroundColor;

  /// Whether to autofocus the search field
  final bool autofocus;

  const CustomSearchAppBar({
    Key? key,
    this.controller,
    this.hintText = 'Search properties...',
    this.onChanged,
    this.onSubmitted,
    this.leading,
    this.actions,
    this.backgroundColor,
    this.autofocus = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appBarTheme = theme.appBarTheme;

    return AppBar(
      backgroundColor: backgroundColor ?? appBarTheme.backgroundColor,
      elevation: appBarTheme.elevation,
      leading: leading,
      title: TextField(
        controller: controller,
        autofocus: autofocus,
        onChanged: onChanged,
        onSubmitted: onSubmitted,
        style: theme.textTheme.bodyLarge,
        decoration: InputDecoration(
          hintText: hintText,
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          prefixIcon: const Icon(Icons.search, size: 24),
          suffixIcon: controller?.text.isNotEmpty ?? false
              ? IconButton(
                  icon: const Icon(Icons.clear, size: 20),
                  onPressed: () {
                    controller?.clear();
                    onChanged?.call('');
                  },
                )
              : null,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
        ),
      ),
      actions: actions,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

/// Custom property detail app bar with transparent background and gradient overlay
class CustomPropertyDetailAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  /// Whether to show back button
  final bool showBackButton;

  /// Actions to display on the right side
  final List<Widget>? actions;

  /// Callback for back button
  final VoidCallback? onBackPressed;

  /// Whether to use gradient overlay
  final bool useGradient;

  const CustomPropertyDetailAppBar({
    Key? key,
    this.showBackButton = true,
    this.actions,
    this.onBackPressed,
    this.useGradient = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: showBackButton
          ? Container(
              margin: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.9),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.black87),
                onPressed: onBackPressed ?? () => Navigator.of(context).pop(),
                padding: EdgeInsets.zero,
              ),
            )
          : null,
      actions: actions?.map((action) {
        return Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.9),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: action,
        );
      }).toList(),
      flexibleSpace: useGradient
          ? Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withValues(alpha: 0.4),
                    Colors.transparent,
                  ],
                ),
              ),
            )
          : null,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
