import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import './widgets/login_form_widget.dart';
import './widgets/register_form_widget.dart';
import './widgets/social_login_widget.dart';

/// Authentication Screen enables secure user login/registration with mobile-optimized input methods.
/// Implements segmented control for Login/Register mode switching with data persistence.
/// Integrates biometric authentication and KYC verification flow.
class AuthenticationScreen extends StatefulWidget {
  const AuthenticationScreen({Key? key}) : super(key: key);

  @override
  State<AuthenticationScreen> createState() => _AuthenticationScreenState();
}

class _AuthenticationScreenState extends State<AuthenticationScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _formKey = GlobalKey<FormState>();

  // Form controllers
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _nameController = TextEditingController();

  bool _isLoading = false;
  bool _termsAccepted = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    // Simulate authentication
    await Future.delayed(const Duration(seconds: 2));

    setState(() => _isLoading = false);

    // Mock credentials validation
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    if (email == 'tenant@freddie.com' && password == 'Tenant@123') {
      _showSuccessAndNavigate('Tenant login successful');
    } else if (email == 'landlord@freddie.com' && password == 'Landlord@123') {
      _showSuccessAndNavigate('Landlord login successful');
    } else {
      _showError('Invalid credentials. Please check your email and password.');
    }
  }

  Future<void> _handleRegister() async {
    if (!_formKey.currentState!.validate()) return;

    if (!_termsAccepted) {
      _showError('Please accept the terms and conditions to continue');
      return;
    }

    setState(() => _isLoading = true);

    // Simulate registration
    await Future.delayed(const Duration(seconds: 2));

    setState(() => _isLoading = false);

    _showSuccessAndNavigate(
      'Registration successful! Please complete KYC verification.',
    );
  }

  void _showSuccessAndNavigate(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
    );

    Future.delayed(const Duration(milliseconds: 500), () {
      Navigator.of(
        context,
        rootNavigator: true,
      ).pushReplacementNamed('/kyc-verification-screen');
    });
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Theme.of(context).colorScheme.error,
      ),
    );
  }

  Future<void> _handleSocialLogin(String provider) async {
    setState(() => _isLoading = true);

    await Future.delayed(const Duration(seconds: 2));

    setState(() => _isLoading = false);

    _showSuccessAndNavigate('$provider login successful');
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 3.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 2.h),
                  _buildLogo(theme),
                  SizedBox(height: 3.h),
                  _buildTabBar(theme),
                  SizedBox(height: 3.h),
                  _buildFormContent(theme),
                  SizedBox(height: 3.h),
                  SocialLoginWidget(
                    onGoogleLogin: () => _handleSocialLogin('Google'),
                    onFacebookLogin: () => _handleSocialLogin('Facebook'),
                    isLoading: _isLoading,
                  ),
                  SizedBox(height: 2.h),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLogo(ThemeData theme) {
    return Column(
      children: [
        Container(
          width: 20.w,
          height: 20.w,
          decoration: BoxDecoration(
            color: theme.colorScheme.primary,
            borderRadius: BorderRadius.circular(4.w),
          ),
          child: Center(
            child: Text(
              'F',
              style: theme.textTheme.headlineLarge?.copyWith(
                color: theme.colorScheme.onPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        SizedBox(height: 2.h),
        Text(
          'Freddie',
          style: theme.textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.primary,
          ),
        ),
        SizedBox(height: 1.h),
        Text(
          'No agent. No wahala.',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }

  Widget _buildTabBar(ThemeData theme) {
    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(2.w),
      ),
      child: TabBar(
        controller: _tabController,
        indicator: BoxDecoration(
          color: theme.colorScheme.primary,
          borderRadius: BorderRadius.circular(2.w),
        ),
        labelColor: theme.colorScheme.onPrimary,
        unselectedLabelColor: theme.colorScheme.onSurfaceVariant,
        labelStyle: theme.textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: theme.textTheme.titleMedium,
        tabs: const [
          Tab(text: 'Login'),
          Tab(text: 'Register'),
        ],
      ),
    );
  }

  Widget _buildFormContent(ThemeData theme) {
    return Form(
      key: _formKey,
      child: SizedBox(
        height: 50.h,
        child: TabBarView(
          controller: _tabController,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            LoginFormWidget(
              emailController: _emailController,
              passwordController: _passwordController,
              isLoading: _isLoading,
              onLogin: _handleLogin,
              onForgotPassword: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Password reset link sent to your email'),
                  ),
                );
              },
            ),
            RegisterFormWidget(
              nameController: _nameController,
              emailController: _emailController,
              phoneController: _phoneController,
              passwordController: _passwordController,
              confirmPasswordController: _confirmPasswordController,
              termsAccepted: _termsAccepted,
              isLoading: _isLoading,
              onTermsChanged: (value) =>
                  setState(() => _termsAccepted = value ?? false),
              onRegister: _handleRegister,
            ),
          ],
        ),
      ),
    );
  }
}
