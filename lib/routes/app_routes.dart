import 'package:flutter/material.dart';
import '../presentation/subscription_management_screen/subscription_management_screen.dart';
import '../presentation/splash_screen/splash_screen.dart';
import '../presentation/property_details_screen/property_details_screen.dart';
import '../presentation/user_profile_screen/user_profile_screen.dart';
import '../presentation/property_search_screen/property_search_screen.dart';
import '../presentation/ai_contract_generation_screen/ai_contract_generation_screen.dart';
import '../presentation/authentication_screen/authentication_screen.dart';
import '../presentation/property_dashboard/property_dashboard.dart';
import '../presentation/onboarding_flow/onboarding_flow.dart';
import '../presentation/create_property_listing_screen/create_property_listing_screen.dart';
import '../presentation/kyc_verification_screen/kyc_verification_screen.dart';
import '../presentation/messaging_screen/messaging_screen.dart';

class AppRoutes {
  // TODO: Add your routes here
  static const String initial = '/';
  static const String subscriptionManagement =
      '/subscription-management-screen';
  static const String splash = '/splash-screen';
  static const String propertyDetails = '/property-details-screen';
  static const String userProfile = '/user-profile-screen';
  static const String propertySearch = '/property-search-screen';
  static const String aiContractGeneration = '/ai-contract-generation-screen';
  static const String authentication = '/authentication-screen';
  static const String propertyDashboard = '/property-dashboard';
  static const String onboardingFlow = '/onboarding-flow';
  static const String createPropertyListing = '/create-property-listing-screen';
  static const String kycVerification = '/kyc-verification-screen';
  static const String messaging = '/messaging-screen';

  static Map<String, WidgetBuilder> routes = {
    initial: (context) => const SplashScreen(),
    subscriptionManagement: (context) => const SubscriptionManagementScreen(),
    splash: (context) => const SplashScreen(),
    propertyDetails: (context) => const PropertyDetailsScreen(),
    userProfile: (context) => const UserProfileScreen(),
    propertySearch: (context) => const PropertySearchScreen(),
    aiContractGeneration: (context) => const AiContractGenerationScreen(),
    authentication: (context) => const AuthenticationScreen(),
    propertyDashboard: (context) => const PropertyDashboard(),
    onboardingFlow: (context) => const OnboardingFlow(),
    createPropertyListing: (context) => const CreatePropertyListingScreen(),
    kycVerification: (context) => const KycVerificationScreen(),
    messaging: (context) => const MessagingScreen(),
    // TODO: Add your other routes here
  };
}
