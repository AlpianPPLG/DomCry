import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'routes/app_routes.dart';

class DomCryApp extends StatelessWidget {
  const DomCryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DomCry - Crypto Wallet',
      debugShowCheckedModeBanner: false,
      
      // CRITICAL: Set login as initial route
      initialRoute: AppRoutes.login,
      
      // Use our route generator
      onGenerateRoute: AppRoutes.generateRoute,
      
      // Handle unknown routes by redirecting to login
      onUnknownRoute: (settings) {
        return MaterialPageRoute(
          builder: (_) => const LoginRedirectPage(),
          settings: const RouteSettings(name: AppRoutes.login),
        );
      },
      
      // App theme configuration
      theme: _buildAppTheme(),
    );
  }

  ThemeData _buildAppTheme() {
    return ThemeData(
      primarySwatch: Colors.deepPurple,
      primaryColor: const Color(0xFF6C5CE7),
      fontFamily: 'SF Pro Display',
      visualDensity: VisualDensity.adaptivePlatformDensity,
      
      // Status bar configuration
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF6C5CE7),
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light,
          statusBarBrightness: Brightness.dark,
        ),
      ),
      
      // Button themes
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF6C5CE7),
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(vertical: 16),
        ),
      ),
      
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: const Color(0xFF6C5CE7),
        ),
      ),
      
      // Input field theme
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF6C5CE7), width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red),
        ),
        filled: true,
        fillColor: Colors.grey.shade50,
      ),
      
      // Card theme
      cardTheme: CardThemeData(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        color: Colors.white,
      ),
      
      // Bottom navigation theme
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Colors.white,
        selectedItemColor: Color(0xFF6C5CE7),
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),
      
      // Scaffold theme
      scaffoldBackgroundColor: Colors.grey.shade50,
    );
  }
}

// Redirect page for unknown routes
class LoginRedirectPage extends StatefulWidget {
  const LoginRedirectPage({super.key});

  @override
  State<LoginRedirectPage> createState() => _LoginRedirectPageState();
}

class _LoginRedirectPageState extends State<LoginRedirectPage> {
  @override
  void initState() {
    super.initState();
    // Automatically redirect to login after a brief delay
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        Navigator.pushReplacementNamed(context, AppRoutes.login);
      }
    });
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
        child: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.account_balance_wallet,
                size: 64,
                color: Colors.white,
              ),
              SizedBox(height: 16),
              Text(
                'DomCry',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Redirecting to login...',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white70,
                ),
              ),
              SizedBox(height: 24),
              CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}