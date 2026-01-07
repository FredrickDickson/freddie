import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';

import '../../core/app_export.dart';

/// Onboarding Flow screen that introduces new users to the agent-free property marketplace
/// Uses introduction_screen package for smooth page transitions and progress indicators
class OnboardingFlow extends StatefulWidget {
  const OnboardingFlow({Key? key}) : super(key: key);

  @override
  State<OnboardingFlow> createState() => _OnboardingFlowState();
}

class _OnboardingFlowState extends State<OnboardingFlow> {
  final _introKey = GlobalKey<IntroductionScreenState>();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return IntroductionScreen(
      key: _introKey,
      globalBackgroundColor: theme.scaffoldBackgroundColor,
      pages: [
        _buildFindPropertiesPage(theme),
        _buildSecureContractsPage(theme),
        _buildVerifiedUsersPage(theme),
        _buildListPropertyPage(theme),
      ],
      onDone: () => _navigateToUserTypeSelection(),
      onSkip: () => _navigateToUserTypeSelection(),
      showSkipButton: true,
      skip: Text(
        'Skip',
        style: theme.textTheme.labelLarge?.copyWith(
          color: theme.colorScheme.primary,
        ),
      ),
      next: CustomIconWidget(
        iconName: 'arrow_forward',
        color: theme.colorScheme.primary,
        size: 24,
      ),
      done: Text(
        'Get Started',
        style: theme.textTheme.labelLarge?.copyWith(
          color: theme.colorScheme.primary,
          fontWeight: FontWeight.w600,
        ),
      ),
      dotsDecorator: DotsDecorator(
        size: const Size.square(10.0),
        activeSize: const Size(24.0, 10.0),
        activeColor: theme.colorScheme.primary,
        color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.3),
        spacing: const EdgeInsets.symmetric(horizontal: 4.0),
        activeShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24.0),
        ),
      ),
      controlsMargin: const EdgeInsets.all(16.0),
      controlsPadding: const EdgeInsets.fromLTRB(8.0, 4.0, 8.0, 4.0),
    );
  }

  /// First onboarding page - Find Properties Direct
  PageViewModel _buildFindPropertiesPage(ThemeData theme) {
    return PageViewModel(
      title: "Find Properties Direct",
      body:
          "Browse verified properties without agent fees. Connect directly with property owners and save money on every transaction.",
      image: Center(
        child: CustomImageWidget(
          imageUrl:
              "https://images.unsplash.com/photo-1560518883-ce09059eeffa?w=800&q=80",
          width: MediaQuery.of(context).size.width * 0.8,
          height: MediaQuery.of(context).size.height * 0.35,
          fit: BoxFit.contain,
          semanticLabel:
              "Modern residential house exterior with large windows and landscaped front yard",
        ),
      ),
      decoration: PageDecoration(
        titleTextStyle: theme.textTheme.headlineMedium!.copyWith(
          fontWeight: FontWeight.w600,
          color: theme.colorScheme.onSurface,
        ),
        bodyTextStyle: theme.textTheme.bodyLarge!.copyWith(
          color: theme.colorScheme.onSurfaceVariant,
          height: 1.5,
        ),
        imagePadding: const EdgeInsets.only(top: 60, bottom: 24),
        contentMargin: const EdgeInsets.symmetric(horizontal: 24),
        bodyPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        pageColor: theme.scaffoldBackgroundColor,
      ),
    );
  }

  /// Second onboarding page - Secure AI Contracts
  PageViewModel _buildSecureContractsPage(ThemeData theme) {
    return PageViewModel(
      title: "Secure AI Contracts",
      body:
          "Generate legally binding contracts automatically with AI. No lawyers needed - our smart system handles all the paperwork for you.",
      image: Center(
        child: CustomImageWidget(
          imageUrl:
              "https://images.unsplash.com/photo-1450101499163-c8848c66ca85?w=800&q=80",
          width: MediaQuery.of(context).size.width * 0.8,
          height: MediaQuery.of(context).size.height * 0.35,
          fit: BoxFit.contain,
          semanticLabel:
              "Business professional signing legal documents with pen on desk with laptop and coffee",
        ),
      ),
      decoration: PageDecoration(
        titleTextStyle: theme.textTheme.headlineMedium!.copyWith(
          fontWeight: FontWeight.w600,
          color: theme.colorScheme.onSurface,
        ),
        bodyTextStyle: theme.textTheme.bodyLarge!.copyWith(
          color: theme.colorScheme.onSurfaceVariant,
          height: 1.5,
        ),
        imagePadding: const EdgeInsets.only(top: 60, bottom: 24),
        contentMargin: const EdgeInsets.symmetric(horizontal: 24),
        bodyPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        pageColor: theme.scaffoldBackgroundColor,
      ),
    );
  }

  /// Third onboarding page - Verified Users Only
  PageViewModel _buildVerifiedUsersPage(ThemeData theme) {
    return PageViewModel(
      title: "Verified Users Only",
      body:
          "Trust and safety first. All users undergo KYC verification with ID upload and selfie matching. Look for the verified badge.",
      image: Center(
        child: CustomImageWidget(
          imageUrl:
              "https://images.unsplash.com/photo-1633265486064-086b219458ec?w=800&q=80",
          width: MediaQuery.of(context).size.width * 0.8,
          height: MediaQuery.of(context).size.height * 0.35,
          fit: BoxFit.contain,
          semanticLabel:
              "Person holding smartphone showing security verification checkmark with blue shield icon",
        ),
      ),
      decoration: PageDecoration(
        titleTextStyle: theme.textTheme.headlineMedium!.copyWith(
          fontWeight: FontWeight.w600,
          color: theme.colorScheme.onSurface,
        ),
        bodyTextStyle: theme.textTheme.bodyLarge!.copyWith(
          color: theme.colorScheme.onSurfaceVariant,
          height: 1.5,
        ),
        imagePadding: const EdgeInsets.only(top: 60, bottom: 24),
        contentMargin: const EdgeInsets.symmetric(horizontal: 24),
        bodyPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        pageColor: theme.scaffoldBackgroundColor,
      ),
    );
  }

  /// Fourth onboarding page - List Your Property
  PageViewModel _buildListPropertyPage(ThemeData theme) {
    return PageViewModel(
      title: "List Your Property",
      body:
          "Property owners can list unlimited properties with premium accounts. Zero commission fees and reach thousands of verified tenants directly.",
      image: Center(
        child: CustomImageWidget(
          imageUrl:
              "https://images.unsplash.com/photo-1560520653-9e0e4c89eb11?w=800&q=80",
          width: MediaQuery.of(context).size.width * 0.8,
          height: MediaQuery.of(context).size.height * 0.35,
          fit: BoxFit.contain,
          semanticLabel:
              "Real estate agent holding house keys with modern apartment building in background",
        ),
      ),
      decoration: PageDecoration(
        titleTextStyle: theme.textTheme.headlineMedium!.copyWith(
          fontWeight: FontWeight.w600,
          color: theme.colorScheme.onSurface,
        ),
        bodyTextStyle: theme.textTheme.bodyLarge!.copyWith(
          color: theme.colorScheme.onSurfaceVariant,
          height: 1.5,
        ),
        imagePadding: const EdgeInsets.only(top: 60, bottom: 24),
        contentMargin: const EdgeInsets.symmetric(horizontal: 24),
        bodyPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        pageColor: theme.scaffoldBackgroundColor,
      ),
    );
  }

  /// Navigate to user type selection screen
  void _navigateToUserTypeSelection() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _UserTypeSelectionSheet(),
    );
  }
}

/// Bottom sheet for user type selection
class _UserTypeSelectionSheet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
        top: 24,
        left: 24,
        right: 24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Handle bar
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: theme.colorScheme.onSurfaceVariant.withValues(
                  alpha: 0.3,
                ),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Title
          Text(
            "I'm here to...",
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),

          Text(
            "Choose your account type to get started",
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),

          // Looking for property button
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(
                context,
                rootNavigator: true,
              ).pushNamed('/authentication-screen');
            },
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomIconWidget(
                  iconName: 'search',
                  color: theme.colorScheme.onPrimary,
                  size: 24,
                ),
                const SizedBox(width: 12),
                Text(
                  "I'm Looking for Property",
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: theme.colorScheme.onPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Property owner button
          OutlinedButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(
                context,
                rootNavigator: true,
              ).pushNamed('/authentication-screen');
            },
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomIconWidget(
                  iconName: 'home_work',
                  color: theme.colorScheme.primary,
                  size: 24,
                ),
                const SizedBox(width: 12),
                Text(
                  "I'm a Property Owner",
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
