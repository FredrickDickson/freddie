import 'package:flutter/material.dart';

/// Custom bottom navigation bar widget for property marketplace app.
/// Implements thumb-zone prioritized navigation with platform-native feel.
///
/// This widget is parameterized and reusable - navigation logic should be
/// handled by the parent widget, not hardcoded here.
class CustomBottomBar extends StatelessWidget {
  /// Current selected index
  final int currentIndex;

  /// Callback when navigation item is tapped
  final Function(int) onTap;

  /// Optional background color override
  final Color? backgroundColor;

  /// Optional selected item color override
  final Color? selectedItemColor;

  /// Optional unselected item color override
  final Color? unselectedItemColor;

  /// Optional elevation override
  final double? elevation;

  const CustomBottomBar({
    Key? key,
    required this.currentIndex,
    required this.onTap,
    this.backgroundColor,
    this.selectedItemColor,
    this.unselectedItemColor,
    this.elevation,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onTap,
      type: BottomNavigationBarType.fixed,
      backgroundColor:
          backgroundColor ?? theme.bottomNavigationBarTheme.backgroundColor,
      selectedItemColor:
          selectedItemColor ?? theme.bottomNavigationBarTheme.selectedItemColor,
      unselectedItemColor:
          unselectedItemColor ??
          theme.bottomNavigationBarTheme.unselectedItemColor,
      selectedLabelStyle: theme.bottomNavigationBarTheme.selectedLabelStyle,
      unselectedLabelStyle: theme.bottomNavigationBarTheme.unselectedLabelStyle,
      elevation: elevation ?? 8.0,
      enableFeedback: true,
      showSelectedLabels: true,
      showUnselectedLabels: true,
      items: [
        // Dashboard/Home - Property listings feed with map toggle
        BottomNavigationBarItem(
          icon: const Icon(Icons.home_outlined, size: 24),
          activeIcon: const Icon(Icons.home, size: 24),
          label: 'Home',
          tooltip: 'Property Dashboard',
        ),

        // Search - Advanced filtering and location-based discovery
        BottomNavigationBarItem(
          icon: const Icon(Icons.search_outlined, size: 24),
          activeIcon: const Icon(Icons.search, size: 24),
          label: 'Search',
          tooltip: 'Property Search',
        ),

        // Messages - Real-time landlord-tenant communication
        BottomNavigationBarItem(
          icon: const Icon(Icons.chat_bubble_outline, size: 24),
          activeIcon: const Icon(Icons.chat_bubble, size: 24),
          label: 'Messages',
          tooltip: 'Messages',
        ),

        // Profile - Account management and verification status
        BottomNavigationBarItem(
          icon: const Icon(Icons.person_outline, size: 24),
          activeIcon: const Icon(Icons.person, size: 24),
          label: 'Profile',
          tooltip: 'User Profile',
        ),
      ],
    );
  }
}

/// Navigation item data model for type safety
class BottomNavItem {
  final String label;
  final IconData icon;
  final IconData activeIcon;
  final String route;
  final String tooltip;

  const BottomNavItem({
    required this.label,
    required this.icon,
    required this.activeIcon,
    required this.route,
    required this.tooltip,
  });
}

/// Predefined navigation items matching the Mobile Navigation Hierarchy
class BottomNavItems {
  static const List<BottomNavItem> items = [
    BottomNavItem(
      label: 'Home',
      icon: Icons.home_outlined,
      activeIcon: Icons.home,
      route: '/property-dashboard',
      tooltip: 'Property Dashboard',
    ),
    BottomNavItem(
      label: 'Search',
      icon: Icons.search_outlined,
      activeIcon: Icons.search,
      route: '/property-search-screen',
      tooltip: 'Property Search',
    ),
    BottomNavItem(
      label: 'Messages',
      icon: Icons.chat_bubble_outline,
      activeIcon: Icons.chat_bubble,
      route: '/messaging-screen',
      tooltip: 'Messages',
    ),
    BottomNavItem(
      label: 'Profile',
      icon: Icons.person_outline,
      activeIcon: Icons.person,
      route: '/user-profile-screen',
      tooltip: 'User Profile',
    ),
  ];
}
