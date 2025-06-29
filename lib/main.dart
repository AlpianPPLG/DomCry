import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'presentation/routes/app_routes.dart';
import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  // Set system UI overlay style for splash screen
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      statusBarBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.transparent,
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );

  // Set preferred orientations
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Note: SessionManager initialization moved to splash screen
  // for better user experience with loading indication
  debugPrint('🚀 Main: App starting with splash screen...');

  // Run the app
  runApp(const DomCryApp());
}

class DomCryApp extends StatelessWidget {
  const DomCryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DomCry Crypto Wallet',
      debugShowCheckedModeBanner: false,
      
      // IMPORTANT: Set initial route to SPLASH SCREEN
      initialRoute: AppRoutes.splash,
      
      // Use our custom route generator
      onGenerateRoute: AppRoutes.generateRoute,
      
      // Fallback route if route not found - redirect to splash
      onUnknownRoute: (settings) {
        return MaterialPageRoute(
          builder: (_) => const SplashRedirectPage(),
          settings: const RouteSettings(name: AppRoutes.splash),
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
      
      // AppBar theme
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
      
      // ElevatedButton theme
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
      
      // TextButton theme
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: const Color(0xFF6C5CE7),
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        ),
      ),
      
      // Input decoration theme
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
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red, width: 2),
        ),
        filled: true,
        fillColor: Colors.grey.shade50,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
      
      // Card theme
      cardTheme: CardThemeData(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        color: Colors.white,
        shadowColor: Colors.black.withOpacity(0.1),
      ),
      
      // BottomNavigationBar theme
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Colors.white,
        selectedItemColor: Color(0xFF6C5CE7),
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
        selectedLabelStyle: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w400,
        ),
      ),
      
      // Scaffold theme
      scaffoldBackgroundColor: Colors.grey.shade50,
      
      // Divider theme
      dividerTheme: DividerThemeData(
        color: Colors.grey.shade300,
        thickness: 1,
        space: 1,
      ),
      
      // SnackBar theme
      snackBarTheme: SnackBarThemeData(
        backgroundColor: const Color(0xFF6C5CE7),
        contentTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        behavior: SnackBarBehavior.floating,
        elevation: 4,
      ),
      
      // Dialog theme
      dialogTheme: DialogThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        elevation: 8,
        backgroundColor: Colors.white,
        titleTextStyle: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: Color(0xFF2D3748),
        ),
        contentTextStyle: TextStyle(
          fontSize: 14,
          color: Colors.grey.shade700,
          height: 1.4,
        ),
      ),
      
      // Checkbox theme
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const Color(0xFF6C5CE7);
          }
          return Colors.transparent;
        }),
        checkColor: WidgetStateProperty.all(Colors.white),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
        ),
      ),
      
      // Progress indicator theme
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: Color(0xFF6C5CE7),
        linearTrackColor: Color(0xFFE2E8F0),
        circularTrackColor: Color(0xFFE2E8F0),
      ),
    );
  }
}

// Redirect page for unknown routes - now redirects to splash
class SplashRedirectPage extends StatefulWidget {
  const SplashRedirectPage({super.key});

  @override
  State<SplashRedirectPage> createState() => _SplashRedirectPageState();
}

class _SplashRedirectPageState extends State<SplashRedirectPage> {
  @override
  void initState() {
    super.initState();
    debugPrint('🔄 SplashRedirect: Redirecting to splash screen...');
    
    // Automatically redirect to splash after a brief delay
    Future.delayed(const Duration(milliseconds: 100), () {
      if (mounted) {
        Navigator.pushReplacementNamed(context, AppRoutes.splash);
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
              // App Icon
              Icon(
                Icons.account_balance_wallet,
                size: 64,
                color: Colors.white,
              ),
              SizedBox(height: 16),
              
              // App Name
              Text(
                'DomCry',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 1.2,
                ),
              ),
              SizedBox(height: 8),
              
              // Loading Text
              Text(
                'Loading...',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white70,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 24),
              
              // Loading Indicator
              SizedBox(
                width: 32,
                height: 32,
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  strokeWidth: 3,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}