import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../components/RegisterComponent/register_form.dart';
import '../../routes/app_routes.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

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
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // App Logo and Title
                  _buildAppHeader(),
                  const SizedBox(height: 40),
                  
                  // Register Form
                  RegisterForm(
                    onRegisterSuccess: () {
                      // Navigate to LOGIN page after successful registration
                      Navigator.pushReplacementNamed(context, AppRoutes.login);
                    },
                    onLoginRedirect: () {
                      // Navigate to login page
                      Navigator.pushReplacementNamed(context, AppRoutes.login);
                    },
                  ),
                  
                  const SizedBox(height: 20),
                  
                  // Footer
                  _buildFooter(),
                ],
              ),
            ),
          ),
        ),
      ),
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
            size: 64,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 20),
        
        // App Title
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
        
        // App Subtitle
        Text(
          'Your Gateway to Cryptocurrency',
          style: TextStyle(
            fontSize: 16,
            color: Colors.white.withOpacity(0.9),
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildFooter() {
    return Column(
      children: [
        // Version Info
        Text(
          'Version 1.0.0',
          style: TextStyle(
            fontSize: 12,
            color: Colors.white.withOpacity(0.7),
          ),
        ),
        const SizedBox(height: 8),
        
        // Copyright
        Text(
          '© 2024 DomCry. All rights reserved.',
          style: TextStyle(
            fontSize: 12,
            color: Colors.white.withOpacity(0.7),
          ),
        ),
        const SizedBox(height: 16),
        
        // Security Badge
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: Colors.white.withOpacity(0.2),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.security,
                size: 16,
                color: Colors.white.withOpacity(0.9),
              ),
              const SizedBox(width: 8),
              Text(
                'Secure & Encrypted',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.white.withOpacity(0.9),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}