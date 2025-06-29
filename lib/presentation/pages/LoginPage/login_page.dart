import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../components/LoginComponent/login_form.dart';
import '../../routes/app_routes.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with TickerProviderStateMixin {
  late AnimationController _backgroundAnimationController;
  late Animation<double> _backgroundAnimation;

  @override
  void initState() {
    super.initState();
    
    // Set status bar style
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
    );

    _backgroundAnimationController = AnimationController(
      duration: const Duration(seconds: 20),
      vsync: this,
    );

    _backgroundAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(_backgroundAnimationController);

    _backgroundAnimationController.repeat();
  }

  @override
  void dispose() {
    _backgroundAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF6C5CE7),
              Color(0xFF5A4FCF),
              Color(0xFF4834D4),
            ],
          ),
        ),
        child: Stack(
          children: [
            // Animated Background Elements
            _buildAnimatedBackground(),
            
            // Safe Area Content
            SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    const SizedBox(height: 40),
                    
                    // App Logo and Title
                    _buildAppHeader(),
                    
                    const SizedBox(height: 60),
                    
                    // Login Form
                    LoginForm(
                      onLoginSuccess: _handleLoginSuccess,
                      onForgotPassword: _handleForgotPassword,
                      onSignUp: _handleSignUp,
                    ),
                    
                    const SizedBox(height: 40),
                    
                    // Footer
                    _buildFooter(),
                    
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnimatedBackground() {
    return AnimatedBuilder(
      animation: _backgroundAnimation,
      builder: (context, child) {
        return Stack(
          children: [
            // Floating circles
            Positioned(
              top: 100 + (50 * _backgroundAnimation.value),
              left: 50 + (30 * _backgroundAnimation.value),
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.1),
                ),
              ),
            ),
            Positioned(
              top: 200 + (30 * _backgroundAnimation.value),
              right: 30 + (40 * _backgroundAnimation.value),
              child: Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.08),
                ),
              ),
            ),
            Positioned(
              bottom: 150 + (60 * _backgroundAnimation.value),
              left: 30 + (50 * _backgroundAnimation.value),
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.06),
                ),
              ),
            ),
            Positioned(
              bottom: 300 + (40 * _backgroundAnimation.value),
              right: 60 + (20 * _backgroundAnimation.value),
              child: Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.09),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildAppHeader() {
    return Column(
      children: [
        // App Icon
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(30),
            border: Border.all(
              color: Colors.white.withOpacity(0.3),
              width: 2,
            ),
          ),
          child: const Icon(
            Icons.account_balance_wallet,
            size: 60,
            color: Colors.white,
          ),
        ),
        
        const SizedBox(height: 24),
        
        // App Name
        const Text(
          'DomCry',
          style: TextStyle(
            fontSize: 36,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            letterSpacing: 1.2,
          ),
        ),
        
        const SizedBox(height: 8),
        
        // App Tagline
        Text(
          'Your Secure Crypto Wallet',
          style: TextStyle(
            fontSize: 18,
            color: Colors.white.withOpacity(0.9),
            fontWeight: FontWeight.w300,
          ),
        ),
        
        const SizedBox(height: 16),
        
        // Version Badge
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: Colors.white.withOpacity(0.3),
            ),
          ),
          child: Text(
            'v1.0.0',
            style: TextStyle(
              fontSize: 12,
              color: Colors.white.withOpacity(0.8),
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFooter() {
    return Column(
      children: [
        // Security Badge
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Colors.white.withOpacity(0.2),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.security,
                size: 20,
                color: Colors.white.withOpacity(0.9),
              ),
              const SizedBox(width: 8),
              Text(
                'Bank-level Security',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white.withOpacity(0.9),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        
        const SizedBox(height: 16),
        
        // Copyright
        Text(
          '© 2024 DomCry. All rights reserved.',
          style: TextStyle(
            fontSize: 12,
            color: Colors.white.withOpacity(0.7),
          ),
        ),
        
        const SizedBox(height: 8),
        
        // Terms and Privacy
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton(
              onPressed: _showTermsDialog,
              child: Text(
                'Terms of Service',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.white.withOpacity(0.8),
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
            Text(
              ' • ',
              style: TextStyle(
                color: Colors.white.withOpacity(0.7),
              ),
            ),
            TextButton(
              onPressed: _showPrivacyDialog,
              child: Text(
                'Privacy Policy',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.white.withOpacity(0.8),
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  void _handleLoginSuccess() {
    // Navigate to home page
    Navigator.pushReplacementNamed(context, AppRoutes.home);
  }

  void _handleForgotPassword() {
    // Handle forgot password
    _showComingSoonDialog('Password Recovery');
  }

  void _handleSignUp() {
    // Handle sign up
    _showComingSoonDialog('Sign Up');
  }

  void _showTermsDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: const Text('Terms of Service'),
        content: const SingleChildScrollView(
          child: Text(
            'Welcome to DomCry! By using our app, you agree to our terms and conditions. '
            'We are committed to providing a secure and reliable cryptocurrency wallet service. '
            'Please use our services responsibly and in accordance with applicable laws.',
            style: TextStyle(fontSize: 14),
          ),
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF6C5CE7),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text('OK', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showPrivacyDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: const Text('Privacy Policy'),
        content: const SingleChildScrollView(
          child: Text(
            'Your privacy is important to us. DomCry is committed to protecting your personal information '
            'and ensuring the security of your data. We use industry-standard encryption and security measures '
            'to safeguard your information. We do not share your personal data with third parties without your consent.',
            style: TextStyle(fontSize: 14),
          ),
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF6C5CE7),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text('OK', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showComingSoonDialog(String feature) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFF6C5CE7).withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Icon(
                Icons.construction,
                color: Color(0xFF6C5CE7),
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            const Text('Coming Soon'),
          ],
        ),
        content: Text(
          '$feature feature is coming soon! We\'re working hard to bring you the best experience.',
          style: const TextStyle(fontSize: 14),
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF6C5CE7),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text('OK', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}